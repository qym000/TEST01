<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<script type="text/javascript">

	//字段值信息
	var v_colval;
	
	var v_sqlparam_reg = /\\$\(.*?\)/g;
	
	//验证非法字符
	var v_invalid_char  = /'/g;
	
	var v_sqlparam_arr = new Array();
	
	function sbt(){
		var v_id = '${qds.id}';
		var v_srcdes = $('#srcdes').val();
		var v_type =  $("input[name='type']:checked").val();
		var v_src ='';
		if(v_type == '1' || v_type == '2'){
			v_src = $('#src').combo('getValue');
		}else if( v_type == '3'){
			v_src = $('#src').val();
		}
		if(!v_srcdes || v_srcdes == ''){
			$.messager.alert('<s:text name="common_msg_info"/>','描述不能为空','info'); //操作失败
			return false;
		}
		if (v_invalid_char.test(v_srcdes)) {
			$.messager.alert('<s:text name="common_msg_info"/>','描述存在非法字符，请重新输入','info'); //操作失败
			return false;
		}
		
		if((!v_src || v_src == '') && v_type != '0' && v_type != '4'){
			$.messager.alert('<s:text name="common_msg_info"/>','数据库表/视图/SQL不能为空','info'); //操作失败
			return false;
		}
		
		if(v_type == '3'){
			if($('.myui-datagrid').length == 0){
				$.messager.alert('<s:text name="common_msg_info"/>','请点击  获取字段  执行SQL并获取字段信息','info'); 
				return false;	
			}
		}
		
		var descIllegalMsg;
		$('#collist').find('.desc').each(function(idx, obj){
			 if (v_invalid_char.test($(this).val())) {
				 descIllegalMsg = '第'+ (idx + 1 ) + '行字段' + $(this).parent().prev().html() + '包含非法字符   单引号,请重新填写';
				 return false;
			 }
		})
		
		if(descIllegalMsg) {
			$.messager.alert('<s:text name="common_msg_info"/>', descIllegalMsg,'info');
			 return false;
		}
		
		//设置如果不是SQL不需要进行验证
		var v_valid_param = {
			"query_dataset.src" : v_src
		}
		
		if(v_type != '3'){
			v_valid_param = null;
		}
		
		$.post("${ctx}/query_dataset!getDatasetColumn.action", v_valid_param,function(data){
			var jsondata = JSON.parse(data);
			if(jsondata.result == 'fail'){
				$.messager.alert('<s:text name="common_msg_info"/>','SQL语句执行失败，请查证','error'); 
				return false;
			}else{
				var v_filler1 = [];
				$('.coltr').each(function(){
					v_filler1.push({
						"name"         : $(this).find('.colname').html(),
						"desc"         : $(this).find('.desc').val(),
						"datatype"     : $(this).find('.datatype').val(),
						"auth_rescode" : $(this).find('.auth a').attr('auth_rescode'),
						"auth_stData"  : $(this).find('.auth a').attr('auth_stData')
					});
				})
				
				var v_datasetobj = {
					    "query_dataset.id"   : v_id,
		 				"query_dataset.type" : $("input[name='type']:checked").val(),
						"query_dataset.srcdes" : v_srcdes,
						"query_dataset.src" : v_src,
						"query_dataset.pid" : $("#pid").attr('pid'),
						"query_dataset.filler1" : JSON.stringify(v_filler1)
				}
				
				
				if( $("input[name='type']:checked").val() == '3' &&　v_sqlparam_arr.length > 0) {
					v_datasetobj["query_dataset.filler3"] = JSON.stringify(v_sqlparam_arr);
				}
				
				if ($("input[name='type']:checked").val() == "4") {
					var indItems = $("#colSelected tr");
					if (indItems.length == 0) {
						$.messager.alert("提示", "请选择指标及指标值类型后提交", "info");
						return false;
					}
					var indvalList = [];
					$.each(indItems, function(idx, item){
						var obj = {
							indcde : $(item).attr("indcde"),
							themeCode : $(item).attr("themeCode"),
							indvalNo : $(item).attr("indvalNo"),
							indvalName : $(item).attr("indvalName")
						};
						indvalList.push(obj);
					});
					v_datasetobj.jsonStr = JSON.stringify(indvalList);
				}
				
				var v_url = "${ctx}/query_dataset!insertDataset.action";
				var v_opmsg = "添加";
				if(v_id && v_id != ''){
					v_url = "${ctx}/query_dataset!updateDataset.action";
					v_opmsg = "修改";
				}
				
				$.post(v_url, v_datasetobj,function(data){
					var jsondata = JSON.parse(data);
					if(jsondata.result == 'succ'){
						$.messager.alert('<s:text name="common_msg_info"/>',v_opmsg + '成功','info', function(){
							parent.parent.window.refreshNodeById($("#pid").attr('pid'));
							parent.window.refreshNodeById($("#pid").attr('pid'));
						}); 
						return true;
					}else{
						$.messager.alert('<s:text name="common_msg_info"/>',v_opmsg + '失败','error');
						return false;
					}
				})
			}
		});
		
	}
	
	$(function(){
		
		var v_folder = parent.window.folderNode;
		
		var v_colvalstr = '${qds.filler1}';
		
		if(v_colvalstr && v_colvalstr != ''){
			v_colval = JSON.parse(v_colvalstr);
		}
		

		if('${qds.filler3}' != '') {
			v_sqlparam_arr = JSON.parse('${qds.filler3}');
		}
		
		if(v_folder) {
			$("#pid").val(v_folder.name);
			$("#pid").attr('pid', v_folder.id);
		}
		$("#srcdes").val('${qds.srcdes}');
		var v_type = '${qds.type}' == '' ? '0' : '${qds.type}';
		$("#type"+v_type).attr("checked","checked");
		$('.type').change(function(){
			//默认值处理
			var v_defsrc = $('#defsrc').val();
			if($(this).val() != '${qds.type}')
				v_defsrc = null;
			setAttrByType($(this).val(), v_defsrc);
		});
		setAttrByType(v_type, $('#defsrc').val());
		
		
		var v_id = '${qds.id}';
		
		if(v_id && v_id != ''){
			
			if('${qds.type}' == '0'){
				$('.type').attr('disabled',true);
				$('.cancel').before('<a class="button" href="javascript:void(0);"  style="margin-right:5px;" onclick="delDatasetFloder(\''+v_id+'\')">删除</a>');
			}else{
				$('.cancel').before('<a class="button" href="javascript:void(0);"  style="margin-right:5px;" onclick="delDataset(\''+v_id+'\')">删除</a>');
			}
		}
	})
	
	function setAttrByType(p_type, p_src){
		$('.ownerAttr').remove();
		if(p_type == "0"){
			return false;
		}else if(p_type == "1"){
			var d_div =$('<div class="item ownerAttr"><ul><li class="desc">数据库表：</li><li><input id="src"  name="src" style="width:420px" class="myui-text"/></li></ul></div>').appendTo($('#form_input'));
			var d_input_table = $(d_div).find('.myui-text');
			var v_param = {
					"query_dataset.type" : "TABLE"
				};
			$(d_input_table).combo({
				url : "${ctx}/query_dataset!getUserTable.action",
				param : v_param,
			    valueField : "TABNAM",
			    textField : "TABDES",
			    onSelect : function(){buildColumn($(this).combo('getValue'), '1');},
			    onLoadSuccess : function(){buildColumn($(this).combo('getValue'), '1');},
			    editable : true,
			    searchable : true,
			    defaultValue : p_src
			});
		}else if(p_type == "2"){
			var d_div =$('<div class="item ownerAttr"><ul><li class="desc">数据库视图：</li><li><input id="src"  name="src" style="width:420px" class="myui-text"/></li></ul></div>').appendTo($('#form_input'));
			var d_input_table = $(d_div).find('.myui-text');
			var v_param = {
					"query_dataset.type" : "VIEW"
				};
			$(d_input_table).combo({
				url : "${ctx}/query_dataset!getUserTable.action",
				param : v_param,
			    valueField : "TABNAM",
			    textField : "TABDES",
			    editable : true,
			    onSelect : function(){buildColumn($(this).combo('getValue'), '2');},
			    onLoadSuccess : function(){buildColumn($(this).combo('getValue'), '2');},
			    searchable : true,
			    defaultValue : p_src
			});
			
		}else if(p_type == "3"){
			var d_div =$('<div class="item ownerAttr"><ul><li class="desc"><div>sql：</div></li><li><textarea id="src"  name="src" style="width:420px;height:170px" class="myui-text"></textarea></li></ul></div>').appendTo($('#form_input'));
			
			//执行SQL获取字段按钮
			var d_getCol_div = $('<div class="getCol ownerAttr"></div>').appendTo($(d_div).find('.desc'));
			var d_setParam_div = $('<div class="setParamDiv ownerAttr"></div>').appendTo($(d_div).find('.desc'));
			var d_getCol_btn = $('<a class="myui-button-query" href="javascript:void(0);">获取字段</a>');
			var d_setSqlParam_btn = $('<a class="myui-button-query sqlParamBtn" href="javascript:void(0);">设置参数</a>');
			$(d_getCol_div).append($(d_getCol_btn));
			$(d_setParam_div).append($(d_setSqlParam_btn));
			$(d_setSqlParam_btn).hide();
			$(d_getCol_btn).click(function(){
				buildColumn($(this).parent().parent().parent().find('#src').val(), '3');
			});
			
			$(d_setSqlParam_btn).click(function(){
				var v_matarr = $(this).parent().parent().next().find('#src').val().match(v_sqlparam_reg);
			    if(v_matarr) {
			    	$("#setSqlParamWin").window({
						open : true,
						param : v_sqlparam_arr,
						headline:'sql参数设置',
						content:'<iframe id="addCustomColframe" src="${ctx}/query_dataset!toSqlParamConf.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
						panelWidth:550,
						top : "10",
						panelHeight:250
					});
			    } else {
					return false;
			    }
			})
			
			var d_input_table = $(d_div).find('#src');
			$(d_input_table).change(function(){
			    var v_matarr = $(this).val().match(v_sqlparam_reg);
			    setSqlparamInfo(v_matarr);
			  /*  if(v_matarr) {
					$(this).parent().prev().find('.sqlParamBtn').show();

					var v_param = new Array();
			    	var v_paramstrarr = new Array();
			    	for(var i =0; i< v_matarr.length; i++) {
			    		var v_sqlparam = v_matarr[i].substring(2, v_matarr[i].lastIndexOf(')'))
			    		if(v_paramstrarr.indexOf(v_sqlparam)>=0) {
			    			continue;
			    		}

			    		v_param_obj = new Object();
			    		v_param_obj = {
				    			param : v_sqlparam,
				    			desc : v_sqlparam
				    	}
				    	
				    	v_paramstrarr.push(v_sqlparam);
				    	for(var j=0; j<v_sqlparam_arr.length; j++) {
				    		if (v_sqlparam_arr[j].param == v_param_obj.param) {
				    			v_param_obj.desc = v_sqlparam_arr[j].desc;
				    		}
				    	}
				    	v_param.push(v_param_obj);
				    }
			    	v_sqlparam_arr = v_param;
					
			    } else {
					$(this).parent().prev().find('.sqlParamBtn').hide();
					v_sqlparam_arr = new Array();
			    }*/
			})
			
			
			
			$(d_input_table).val(p_src);
			if(p_src && p_src != '') {
				var v_matarr = $(d_input_table).val().match(v_sqlparam_reg);
				setSqlparamInfo(v_matarr);
				buildColumn(p_src, '3');
			 /*   if(v_matarr) {
			    	$(d_div).find('.sqlParamBtn').show();
			    } else {
			    	$(d_div).find('.sqlParamBtn').hide();
			    	v_sqlparam_arr = new Array();
			    }*/
			}
		}  else if (p_type == "4") {
			var d_div =$('<div class="item ownerAttr"><ul><li class="desc">指标：</li><li><input id="src"  name="src" style="width:420px" class="myui-text"/></li></ul></div>').appendTo($('#form_input'));
			var t = "<table class='ownerAttr' style='width:100%;margin:auto;'><tr><td id='indval_select'></td><td id='indval_items'></td></tr></table>";
			$("#form_input").append($(t));
			$('#indval_select').append($('<div class="myui-datagrid" style="width:250px;height:190px;" id="collist"><table style="width:250px;"><tr><th width="80">值类型</th><th width="190">值名称</th><th width="50">添加</th></tr><tbody id="databody"></tbody></table></div>'));
			$('#indval_items').append($('<div class="myui-datagrid" style="width:250px;height:180px;border:1px solid #E0DFDF;overflow-y:auto;overflow-x:hidden;"><table style="width:100%;table-layout:fixed;"><tbody id="colSelected"></tbody></table></div>'));
			var d_input_table = $(d_div).find('.myui-text');
			$(d_input_table).combo({
				url : "${ctx}/query_dataset!getIndexList.action",
			    valueField : "indcde",
			    textField : "indnam",
			    isCustom : true,
			    customData : [{indcde:"",indnam:"--请选择--"}],
			    editable : true,
			    onSelect : function(item){buildIndval(item.indcde, item.indnam);},
			    onLoadSuccess : function(){},
			    searchable : true
			});
			var htm = "";
			$.each($.parseJSON('${qds.filler1}'), function(idx, item){
				if (item.themeCode) {
					htm += "<tr themeCode='"+item.themeCode+"' indcde='" + item.name.split("_")[0] + "' indvalNo='"+item.name.split("_")[1]+"' desc='" + item.desc +"'><td width='200'>"+ item.desc +"</td><td class='indval-add' width='30' onclick='removeIndval(this)'><i class='fa fa-trash'></i></td></tr>";	
				}
			});
			$("#colSelected").html(htm);
		}
	}
	
	function setSqlparamInfo(p_matarr){
		if(p_matarr) {
			$('#form_input').find('.sqlParamBtn').show();
			var v_param = new Array();
	 //   	var v_paramstrarr = new Array();
	    	for(var i =0; i< p_matarr.length; i++) {
	    		var v_sqlparam = p_matarr[i].substring(2, p_matarr[i].lastIndexOf(')'))
	    		
	    		var v_skip = false;
	    		for(var j=0; j<v_param.length; j++) {
	    			if(v_param[j].param == v_sqlparam) {
	    				v_skip = true;
		    			break;
		    		}
	    		}
	    		if(v_skip) {
	    			continue;
	    		}

	    		v_param_obj = new Object();
	    		v_param_obj = {
		    			param   : v_sqlparam,
		    			desc    : v_sqlparam,
		    			defval  : ''
		    	}
		    	
		    //	v_paramstrarr.push(v_sqlparam);
		    	for(var j=0; j<v_sqlparam_arr.length; j++) {
		    		if (v_sqlparam_arr[j].param == v_param_obj.param) {
		    			v_param_obj.desc = v_sqlparam_arr[j].desc;
		    			v_param_obj.defval = v_sqlparam_arr[j].defval;
		    		}
		    	}
		    	v_param.push(v_param_obj);
		    }
	    	v_sqlparam_arr = v_param;
	    } else {
			$('#form_input').find('.sqlParamBtn').hide();
			v_sqlparam_arr = new Array();
	    }
	}
	
	function buildIndval(indcde, indnam) {
		indnam = $.trim(indnam.substring(indnam.indexOf("】")+ 1));
		var paramObj = {
			indcde : indcde
		};
		$.post("${ctx}/query_dataset!findIndvalByIndcde.action", {jsonStr : JSON.stringify(paramObj)}, function(data){
			var htm = "";
			$.each(data.fmlList, function(idx,item){
				htm += "<tr themeCode='" + data.themeCode + "' indnam='"+indnam+"' indcde='"+indcde+"' indvalNo='" + item.indvalNo + "' valId='"+item.valId+"' indvalName='"+item.indvalName+"'><td>" + item.valId + "</td><td>" + item.indvalName + "</td><td class='indval-add' onclick='addIndval(this);'><i class='fa fa-plus-square'></i></td></tr>";
			});
			$("#databody").html(htm);
		}, "json");
	}
	
	function addIndval(target) {
		var item = $(target).parent();
		var indnam = $(item).attr("indnam");
		var indcde = $(item).attr("indcde");
		var themeCode = $(item).attr("themeCode");
		var indvalNo = $(item).attr("indvalNo");
		var valId = $(item).attr("valId");
		var indvalName = $(item).attr("indvalName");
		var selCols = $("#colSelected tr");
		for (var i = 0; i < selCols.length; i++) {
			if ($(selCols[i]).attr("indcde") == indcde && $(selCols[i]).attr("indvalNo") == indvalNo) {
				return;
			}
		}
		var htm = "";
		if (selCols.length > 0 && indcde != $(selCols[0]).attr("indcde")) {
			add_onload();
			var indArr = [indcde, $(selCols[0]).attr("indcde")];
			$.post("${ctx}/query_dataset!checkIndexDimension.action",{jsonStr : JSON.stringify(indArr)}, function(data){
				clean_onload();
				if (data.result = "succ") {
					if (data.flag) {
						htm += "<tr themeCode='"+themeCode+"' indcde='" + indcde + "' indvalNo='"+indvalNo+"' indvalName='" + indnam + "-" + indvalName +"'><td width='200'>"+indnam + "-" + indvalName +"</td><td class='indval-add' width='30' onclick='removeIndval(this)'><i class='fa fa-trash'></i></td></tr>";	
						$("#colSelected").append(htm);
					}else {
						$.messager.alert("提示", "所选指标维度不匹配，请检查", "info");
					}
				}else {
					$.messager.alert("提示", "请求数据失败，请稍后再试", "info");
				}
			}, "json");
		}else {
			htm += "<tr themeCode='"+themeCode+"' indcde='" + indcde + "' indvalNo='"+indvalNo+"' indvalName='" + indnam + "-" + indvalName +"'><td width='200'>"+indnam + "-" + indvalName +"</td><td class='indval-add' width='30' onclick='removeIndval(this)'><i class='fa fa-trash'></i></td></tr>";	
			$("#colSelected").append(htm);
		}
	}
	
	function removeIndval(target) {
		$(target).parent().remove();
	}
	
	/**
	 * 创建字段
	 * @param v_src : 表/视图/sql
	 * @param v_type : 1/表，2/视图，3/sql
	 */
	function buildColumn(v_src, v_type){
		$('.myui-datagrid').remove();
		$.post("${ctx}/query_dataset!getDatasetColumn.action", {"query_dataset.src":v_src, "query_dataset.type":v_type, "query_dataset.filler3":JSON.stringify(v_sqlparam_arr)},function(data){
			var jsondata = JSON.parse(data);
			if(jsondata.result == 'succ'){
				var v_cols = jsondata.data;
				$('#form_input').append($('<div class="myui-datagrid ownerAttr" id="collist"><table><tr><th>字段名称</th><th>字段描述</th><th>字段类型</th><th>安全策略</th></tr><tbody id="databody"></tbody></table></div>'));
				
				for(var i=0; i< v_cols.length; i++){
					var v_tr_id = 'coltr'+i;
					var d_tr = $('<tr class="coltr" id="'+v_tr_id+'"></tr>').appendTo($('#databody'));
					var col_typ = "string";
					if(v_cols[i].type == 'DATE' || v_cols[i].type == 'date'){
						col_typ = "date";
					}else if(v_cols[i].type == 'NUMBER' || v_cols[i].type == 'number'){
						col_typ = "number";
					}
					$(d_tr).append($('<td class="colname">'+v_cols[i].name+'</td>'));
					$(d_tr).append($('<td><input class="desc myui-text" type="text"></td>'));
					
					var datatypesel=$('<select class="datatype myui-text"/>',{name:"datatype"}); 
					$('<option />',{ 
						val:"string", 
						text:"字符类型" , 
						selected:"selected"
					}).appendTo(datatypesel); 
					$('<option>',{ 
						val:"number", 
						text:"数字类型"
					}).appendTo(datatypesel);
					$('<option>',{ 
						val:"date", 
						text:"日期类型"
					}).appendTo(datatypesel);
					var d_td = $('<td></td>').appendTo($(d_tr));
					$(d_td).append($(datatypesel));
					$(datatypesel).val(col_typ);
					$(datatypesel).attr("disabled",true); 
					
					if (v_cols[i].desc) {
						$(d_tr).find('.desc').val(v_cols[i].desc);
					}
					
					var d_td = $('<td class="auth"></td>').appendTo($(d_tr));
					$(d_td).append('<a href="###">配置</a>');
					
					$(d_td).find('a').click(function(){
						var v_colnam = $(this).parent().parent().find('.colname').html();
						var v_coldes = $(this).parent().parent().find('.desc').val();
						var v_param = {
								"auth_rescode" : $(this).attr('auth_rescode'),
								"auth_stData"  : $(this).attr('auth_stData'),
								"edit_tr"      : $(this).parent().parent().attr('id')
						}
						$("#datasetAuthManageWin").window({
							open : true,
							param : v_param,
							headline:v_colnam +'('+ v_coldes +')字段安全管理',
							content:'<iframe id="datasetAuthManageFrame" src="${ctx}/query_dataset!toDatasetColSecurity.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
							panelWidth:400,
							panelHeight:250
						});
					});
					
					//设置进入功能时候的默认值
					if(v_colval && v_colval[i] && $('input:radio[name="type"]:checked').val() == '${qds.type}'){
						if(v_colval[i].name && v_colval[i].name.toLocaleUpperCase() == v_cols[i].name){
							$(d_tr).find('.desc').val(v_colval[i].desc);
							if(v_colval[i].auth_rescode || v_colval[i].auth_stData) {
								$(d_tr).find('.auth a').html('修改');
								$(d_tr).find('.auth a').attr('auth_rescode',v_colval[i].auth_rescode);
								$(d_tr).find('.auth a').attr('auth_stData',v_colval[i].auth_stData);
							}
						}
					}
				}				
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','SQL语句执行失败，请查证','error'); 
				return false;
			}
		})
		
	}
	
	function authWin(p_obj) {
		alert(p_obj);
	}

	function delDataset(p_id){
		$.post("${ctx}/query_dataset!deleteDataset.action", {"query_dataset.id":p_id},function(data){
			var jsondata = JSON.parse(data);
			if(jsondata.result == 'succ'){
				$.messager.alert('<s:text name="common_msg_info"/>','删除成功','info', function(){
					parent.parent.window.refreshNodeById($("#pid").attr('pid'));
					parent.window.refreshNodeById($("#pid").attr('pid'));
					parent.window.initDatasetFrame();
				}); 
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','删除失败','error', function(){
				}); 
			}
		});
	}
	
	function delDatasetFloder(p_id){
		var p_fobj = {
				"id"   :  p_id,
				"pId"  :  $("#pid").attr('pid'),
				"name" :  $('#srcdes').val()
		}
		
		$("#deleteFolderWin").window({
			open : true,
			param : p_fobj,
			headline:'删除目录',
			content:'<iframe id="addQueryFrame" src="${ctx}/query_dataset!toDatasetFolderDelete.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:350,
			panelHeight:250
		});
	}
	
		//关闭当前窗口
    function clsWin(){
    	parent.parent.$('#datasetManageWin').window('close');
    }
	
</script>
<style>
#collist {margin-top: 10px;}
#collist table{width:620px;}
#collist table .inputAttr{width: 100px}
#collist .myui-text{width:140px}
#collist .colname{width:200px}
#collist .auth{text-align: center;}
.form{height:320px}
.getCol{margin-top: 10px;margin-right: 5px;}
.setParamDiv{margin-top: 5px;margin-right: 5px;}
.indval-add{text-align:center;cursor:pointer;}
.indval-add:HOVER{color:#000}
#colSelected tr:hover {background-color:#E0ECFF}
#colSelected td {border-left:none;border-right:none;overflow:hidden;white-space:nowrap;}
</style>
</head>
<body>
<input type="hidden" id="defsrc" value="${qds.src}">
<div id="deleteFolderWin"></div>
<div id="datasetAuthManageWin"></div>
<div id="setSqlParamWin"></div>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc">所属目录：</li>
					<li><input id="pid"  name="pid" readonly="readonly" style="width:156px" class="myui-text"/></li>
					<li class="desc">描述：</li>
					<li><input id="srcdes"  name="srcdes" class="myui-text" style="width:156px"/></li>
				</ul>
			</div>
			 <div class="item">
				<ul>
					<li class="desc">类型：</li>
					<li>
						<input type="radio" class="type" name = "type" id="type0" value="0"/>&nbsp;目录&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" class="type" name = "type" id="type1" value="1"/>&nbsp;数据库表&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" class="type" name = "type" id="type2" value="2"/>&nbsp;数据库视图&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="radio" class="type" name = "type" id="type3" value="3"/>&nbsp;SQL&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type="radio" class="type" name = "type" id="type4" value="4"/>&nbsp;指标
					</li>
				</ul>
			</div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" enter="false" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button cancel" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>