<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	$(function(){
		initColum();
	});
	
	//分页查询
    function initColum(){
    	var target = parent.$('.myui-datagrid2');
		var opts = parent.$('.myui-datagrid2').datagrid2('options');
	/*	var vis_field = $(target).datagrid2('getVisableColumn');
		
		var visfs = vis_field.split("###")[0].split(",");
		var visfdescs = vis_field.split("###")[1].split(",");*/
		var opts = parent.$('.myui-datagrid2').datagrid2('options');
		var allcol = opts.allColumns;
		
		if(opts.paramColumnList){
			var v_paramColumnList = JSON.parse(opts.paramColumnList);
			$(v_paramColumnList).each(function(idx){
				var v_obj = $(this)[0];
				var colattr = parent.$('.myui-datagrid2').datagrid2('getColumnAttr',v_obj.name+",datatype");
				var v_param = $.extend( v_obj, {colattr : colattr});
				addCondition(v_param);
			});
			
		}
		
		for(var i=0;i<allcol.length;i++){
			var col = allcol[i];
		//	if(!col.checkbox && !col.hidden){
			if(!col.checkbox){
				var tmpli = $("<li></li>").appendTo($(".collist"));
				$(tmpli).append("<i class='fa fa-plus-square'></i>&nbsp");
				$(tmpli).append("<label class='col' name='"+col.field+"'>"+col.title+"</label>");
				$(tmpli).bind("click",function(){
					
					
					var colattr = parent.$('.myui-datagrid2').datagrid2('getColumnAttr',$(this).find('.col').attr('name')+",datatype");
					var v_param = {
							name :　$(this).find('.col').attr('name'),
							desc　:　$(this).find('label').html(),
							colattr : colattr
						}
					addCondition(v_param);
				});
			}
		}
	}
	
//	function addCondition(p_col, p_coldes, p_colcompare, p_coltype, p_colattr){
	function addCondition(p_obj){
		//生成字段的ID
		var v_colid = p_obj.name + ($('.conditonlist').children().length + 1);
		var conli = $("<li></li>").appendTo($('.conditonlist'));
		
		var colinput = $("<input class='col' type='text' id='"+v_colid+"' name='"+p_obj.name+"' disabled=true value='"+p_obj.desc+"' class='myui-text'>").appendTo($(conli));
		
		var consel=$('<select class="compare"/>',{name:"consel"}); 
		
		$('<option />',{ 
			val:"=", 
			text:"等于" , 
			selected:"selected"
		}).appendTo(consel); 
		if(p_obj.colattr == 'string'){
			$('<option>',{ 
				val:"like", 
				text:"包含"
			}).appendTo(consel);
		}
		
		if(p_obj.colattr == 'number' ||　p_obj.colattr == 'date'){
			$('<option>',{ 
				val:">", 
				text:"大于"
			}).appendTo(consel);  
			$('<option>',{ 
				val:">=", 
				text:"大于等于"
			}).appendTo(consel);  
			$('<option>',{ 
				val:"<", 
				text:"小于"
			}).appendTo(consel);   
			$('<option>',{ 
				val:"<=", 
				text:"小于等于"
			}).appendTo(consel);   
		}
		
		
		$(conli).append(consel);
		
		var paramType=$('<select class="paramType"/>',{name:"paramType"}); 
		
		$('<option />',{ 
			val:"text", 
			text:"文本框" , 
			selected:"selected"
		}).appendTo(paramType); 
		
		$('<option />',{ 
			val:"select", 
			text:"下拉选择"
		}).appendTo(paramType); 
		
		$('<option />',{ 
			val:"date", 
			text:"日期框"
		}).appendTo(paramType);
		
		$('<option />',{ 
			val:"popradio", 
			text:"弹出单选框"
		}).appendTo(paramType);

		$('<option />',{ 
			val:"popcheckbox", 
			text:"弹出多选框"
		}).appendTo(paramType);
		
		$('<option />',{ 
			val:"multinput", 
			text:"多值文本框"
		}).appendTo(paramType);
		
		$('<option />',{ 
			val:"singleorg", 
			text:"单选机构控件"
		}).appendTo(paramType);
		
		$('<option />',{ 
			val:"multiorg", 
			text:"多选机构控件"
		}).appendTo(paramType);
		

	/*	$('<option />',{ 
			val:"poptree-radio", 
			text:"弹出单选树"
		}).appendTo(paramType);
		
		$('<option />',{ 
			val:"poptree-checkbox", 
			text:"弹出多选树"
		}).appendTo(paramType);*/
		
		$(conli).append(paramType);
	/*	var paramType= $('<input type="text" class="paramType" id="v_colid +'paramType" name="paramType">');
		
		
		$(paramType).combo({
		    mode : "local",
		    data : [{text:"文本框",value:"text"},{text:"下拉选择",value:"select"},{text:"日期框",value:"2"}],
		    panelHeight : 90,
		    editable : false,
		    defaultValue : p_coltype
		});*/
		
		setDefaultValue(conli, p_obj);
		
		var conEditImg = $('<i class="fa fa-edit  fa-lg"></i>').appendTo($(conli));
		$(conli).append('&nbsp;');
		var conimg = $('<i class="fa fa-trash  fa-lg"></i>').appendTo($(conli));
		$(conimg).bind('click',function(){
			$(this).parent().remove();
		});
		
		$(conEditImg).bind('click',function(){
			var v_colid = $(this).parent().children('.col').attr("id");
			$("#showParamOperateConfWin").window({
				open : true,
				headline:'控件配置',
				content:'<iframe id="myframe" src="${ctx}/mybi/common/components/myui_datagrid/datagrid-showParamOperate-conf.jsp" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:500,
				param : v_colid,
				panelHeight:350
			});
		});
		
		if(p_obj.partyp == 'sql') {
			$(conimg).remove();
			$(consel).remove();
			$(colinput).attr('partyp', p_obj.partyp);
			$(colinput).attr('dsid', p_obj.dsid);
			$(colinput).attr('sqldefval', p_obj.sqldefval);
		}
	}
	
	function setDefaultValue(p_conli, p_paramObj){
		var vd_input = $(p_conli).find('.col');
		var vd_paramType = $(p_conli).find('.paramType');
		var vd_compare = $(p_conli).find('.compare');
		
		if(p_paramObj.defaultVal){
			$(vd_input).attr('defaultVal', p_paramObj.defaultVal);
		}
		
		if(p_paramObj.alias){
			$(vd_input).attr('alias', p_paramObj.alias);
		}
		
		if(p_paramObj.ctrlValue){
			$(vd_input).attr('ctrlValue', p_paramObj.ctrlValue);
		}
		
		if(p_paramObj.ctrlValue){
			$(vd_input).attr('valtyp', p_paramObj.valtyp);
		}
		
		if(p_paramObj.type){
			$(vd_paramType).val(p_paramObj.type);
		}
		
		if(p_paramObj.compare){
			$(vd_compare).val(p_paramObj.compare);
		}
		
	}
	
	//表单提交
	function sbt(){
		var rst = '';
		
		var jsonParam = {param: []};
		
		$('.conditonlist').find('li').each(function(idx){
			var v_colinput = $(this).find('.col');
			jsonParam.param.push({
				id         :　$(v_colinput).attr("id"),
				name       :　$(v_colinput).attr("name"),
				desc　                 :　$(v_colinput).val(),
				compare    : $(this).find('.compare').val(),
				type       : $(this).find('.paramType').val(),
				alias      :　$(v_colinput).attr("alias"),
				value      :　$(v_colinput).attr("defaultVal"),
				defaultVal :　$(v_colinput).attr("defaultVal"),
				ctrlValue  :　$(v_colinput).attr("ctrlValue"),
				valtyp     :　$(v_colinput).attr("valtyp"),
				sqlurl     : "${ctx}/query_online!getJsonBySql.action",
				dsid       :　$(v_colinput).attr("dsid"),
				partyp     :　$(v_colinput).attr("partyp"),
				sqldefval  : $(v_colinput).attr("sqldefval"),
			});
		})
		
		
		
		clsWin();
		parent.$('.myui-datagrid2').datagrid2('createCondition', jsonParam);
	}
	
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#showParamOperateWin').window('close');
    }
</script>
<style type="text/css">
.form{width:740px;border:0px}
.myui-layout{padding-left:10px;border:0px;margin-top: 10px}
.myui-layout .conditonlist{margin-top: 10px;margin-left: 10px;}
.myui-layout .conditonlist li{margin-bottom: 5px;}
.myui-layout .conditonlist li select{margin-left: 5px;width:80px}
.myui-layout .conditonlist li input{margin-left: 5px;width:138px;}
.myui-layout .conditonlist li .paramType{margin-left: 5px;width:138px;}
.myui-layout .conditonlist li i{margin-left:5px;width: 12px;height: 15px;vertical-align: middle;cursor: pointer;}
.myui-layout .conditonlist li i:HOVER{color:red}
.myui-layout .collist{margin-top: 5px}
.myui-layout .collist li{padding-top: 5px;padding-left: 5px;cursor: pointer;}
.myui-layout .collist li label{cursor: pointer;}
.myui-layout .collist li:hover{background-color: #E0ECFF;border-color: #E0ECFF;}
</style>
</head>
<body>
<div class="operate" id="showParamOperateConfWin"></div>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
			<div class="myui-layout">
				<div class="rowgroup">
					<div class="content" headline="字段" style="width: 230px;height: 365px">
						<ul class="collist">
						</ul>
					</div>
					<div class="content" headline="条件" style="width: 490px;height: 365px">
						<ul class="conditonlist">
						</ul>
					</div>
				</div>
			</div>
		</form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>