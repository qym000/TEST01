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
	//窗口参数
	var v_winParam;
	$(function(){
		initColum();
	});
	
	function initColum(){
		//var target = parent.parent.$('.myui-datagrid2');
		//var opts = parent.parent.$('.myui-datagrid2').datagrid2('options');
		//var allcol = opts.allColumns;
		
		$('#valtyp1').attr('checked',true);
		$('.singleValue').show();
		$('.valtyp').change(function(){
			if ($(this).val() == 'single') {
				$('.singleValue').show();
				$('.conditionValue').hide();
			} else {
				$('.singleValue').hide();
				$('.conditionValue').show();
			}
		})
		
		$("#datatype").combo({
		    mode : "local",
		    data : [{"key":"string","value":"字符串"},{"key":"number","value":"数字"},{"key":"date","value":"日期"}],
		    panelHeight : 90,
		    valueField : 'key',
		    textField : 'value'
		});
		
		var v_opts = parent.$('#addCustomColWin').window('options');
		v_winParam  = v_opts.param;
		if(v_winParam){
			if(v_winParam.datatype){
				$("#datatype").combo('setValue', v_winParam.datatype);
			}
			if(v_winParam.title){
				$('#title').val(v_winParam.title);
			}
			
			if(v_winParam.colVal){
				var v_defJson = JSON.parse(v_winParam.colVal);
				if(v_defJson.valtyp == 'single') {
					$('#singleValue').val(v_defJson.value);
				} else if (v_defJson.valtyp == 'condition') {
					$('#valtyp2').attr('checked',true);
					$('.singleValue').hide();
					$('.conditionValue').show();
					$('#defaultVal').val(v_defJson.defaultVal);
					$(v_defJson.conval).each(function(idx, obj){
						var vc_id = addConVal();
						$('#col'+vc_id).combo('setValue', obj.col);
						$('#compare'+vc_id).combo('setValue', obj.compare);
						$('#compareVal'+vc_id).val(obj.compareVal);
						$('#compare'+vc_id+"_2").combo('setValue', obj.compare2);
						$('#compareVal'+vc_id+"_2").val(obj.compareVal2);
						$('#value'+vc_id).val(obj.value);
					});
				}
			}
		}
		addValueBox();
	}
	
	function addValueBox(){
		$('.valueBox').click(function() {
			var v_param = {
					col : v_winParam,
					id  : $(this).attr('id'),
					val :　$(this).val()
			}
			$("#addCustomColWin").window({
				open : true,
				param : v_param,
				headline:'定义字段',
				content:'<iframe id="addCustomColframe" src="${ctx}/mybi/common/components/myui_datagrid/datagrid-addCustomCol-colValue.jsp" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:500,
				panelHeight:300,
				top : 10
			});
		})
	}
	
	
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#addCustomColWin').window('close');
    }
    
    function addConVal(){
    	var v_id = new Date().getTime();
    	var opts = parent.parent.$('.myui-datagrid2').datagrid2('options');
    	
    	var v_selCol = new Array;
    	for(var i=0;i<opts.allColumns.length;i++){
			var col = opts.allColumns[i];
			if(!col.checkbox && !col.hidden && !col.expr){
				v_selCol.push(col);
			}
    	}
    	
    	var d_tr = $('<tr class="item" id="'+v_id+'"></tr>').insertBefore($('.defaultVal'));
    	var d_td_condition = $('<td rowspan="2"></td>').appendTo($(d_tr));
    	var d_td_col_input = $('<input id="col'+v_id+'" pid="'+v_id+'" class="myui-text tabcol_input" />').appendTo($(d_td_condition));
		$(d_td_col_input).combo({
			mode : "local",
		    data : v_selCol,
		    valueField : "field",
		    panelHeight : 140,
		    textField : "title",
		    onSelect : function(){
		    	$('#compare'+$(this).attr('pid')).combo('loadData', getCompare(getDatatypeByCol($(this))));
		    	$('#compare'+$(this).attr('pid') + '_2').combo('loadData', getCompare(getDatatypeByCol($(this))));
			}
		});
		//$(d_td_condition).append('&nbsp;&nbsp;');
		
    	var d_td_compare = $('<td></td>').appendTo($(d_tr));
    	var d_td_compare_input = $('<input style="width:70px"  id="compare'+v_id+'" pid="'+v_id+'" class="myui-text" />').appendTo($(d_td_compare));
    	$(d_td_compare_input).combo({
			mode : "local",
		    data : getCompare(getDatatypeByCol($(d_td_col_input))),
		    panelHeight : 150,
		    valueField : "val",
		    textField : "text"
		});
    	
    	$(d_td_compare).append('&nbsp;&nbsp;');
    	//var d_td_compareVal = $('<li style="margin-left: 10px"></li>').appendTo($(d_td_compare));
    	var d_td_compareVal_input = $('<input style="width:100px" id="compareVal'+v_id+'" pid="'+v_id+'" class="myui-text" />').appendTo($(d_td_compare));
    	
    	var d_td_value = $('<td rowspan="2"></td>').appendTo($(d_tr));
    	var d_td_value_input = $('<input class="tabval-text myui-text tabval-text valueBox"  id="value'+v_id+'" pid="'+v_id+'"/>').appendTo($(d_td_value));
    	$(d_td_value).append('&nbsp;');
    	var d_td_value_del = $('<i class="fa fa-trash fa"  pid="'+v_id+'"></i>').appendTo($(d_td_value));
    	$(d_td_value_del).click(function(){
    		$("#"+$(this).attr('pid')+"_2").remove();
    		$("#"+$(this).attr('pid')).remove();
    	})
    	
    	var d_tr2 = $('<tr class="item" id="'+v_id+'_2"></tr>').insertBefore($('.defaultVal'));
    	var d_td_compare2 = $('<td></td>').appendTo($(d_tr2));
    	var d_td_compare_input2 = $('<input style="width:70px"  id="compare'+v_id+'_2" pid="'+v_id+'_2" class="myui-text" />').appendTo($(d_td_compare2));
    	$(d_td_compare_input2).combo({
			mode : "local",
		    data : getCompare(getDatatypeByCol($(d_td_col_input))),
		    isCustom : true,
		    customData : [{text:"请选择",val:""}],
		    panelHeight : 150,
		    valueField : "val",
		    textField : "text"
		});
    	
    	$(d_td_compare2).append('&nbsp;&nbsp;');
    	//var d_td_compareVal = $('<li style="margin-left: 10px"></li>').appendTo($(d_td_compare));
    	var d_td_compareVal_input2 = $('<input style="width:100px" id="compareVal'+v_id+'_2" pid="'+v_id+'_2" class="myui-text" />').appendTo($(d_td_compare2));
    	
    	addValueBox();
    	return v_id;
    }
    
    function getCompare(datatype) {
    	var v_rst = new Array();
    	
    	v_rst.push({text:"等于",val:"="});
    	v_rst.push({text:"不等于",val:"<>"});
		
		
		
		if(datatype == 'string'){
			v_rst.push({text:"包含",val:"like"});
			v_rst.push({text:"不包含",val:"not like"});
		}
		
		if(datatype == 'number' || datatype == 'date'){
			v_rst.push({text:"大于",val:">"});
			v_rst.push({text:"大于等于",val:">="});
			v_rst.push({text:"小于",val:"<"});
			v_rst.push({text:"小于等于",val:"<="});
		}
		return v_rst;
    }
    
    function getDatatypeByCol(p_col) {
    	var v_rst = "string";
    	var v_col_val = $(p_col).combo('getValue');
    	var allcol = $(p_col).combo('getData');
    	for(var i=0;i<allcol.length;i++){
			var col = allcol[i];
			if(v_col_val == col.field) {
			  v_rst = col.datatype;
			  break;
			}
    	}
    	return v_rst;
    }
    

	function sbt(){
		var v_title = $('#title').val();
		var v_datatype = $('#datatype').combo('getValue');
		var v_valtyp = $('.valtyp:checked').val();
		var v_rst_json;
		if(v_title == ''){
			$.messager.alert('<s:text name="common_msg_info"/>', '名称不能为空','info');
			return false;
		}
		
		if(v_valtyp == 'single') {
			var v_val = $('#singleValue').val();
			if(!v_val){
				$.messager.alert('<s:text name="common_msg_info"/>', '值不能为空','info');
				return false;
			}
			v_rst_json = {
					valtyp : v_valtyp,
					value  : v_val
			}
		} else {
			var conval = new Array();
			var v_vali_flag = true;  
			if ($('.tabcol_input').length == 0) {
				$.messager.alert('<s:text name="common_msg_info"/>', '请添加条件','info');
				return false;
			}
			
			$('.tabcol_input').each(function(idx){
				var v_compareVal = $('#compareVal'+$(this).attr('pid')).val();
				var v_value = $('#value'+$(this).attr('pid')).val();
				
				if(v_compareVal == null || v_compareVal == ''){
					$.messager.alert('<s:text name="common_msg_info"/>', '第'+(idx+1)+'行条件值不能为空','info');
					v_vali_flag = false;
					return false;
				}
				
				if(v_value == null || v_value == ''){
					$.messager.alert('<s:text name="common_msg_info"/>', '第'+(idx+1)+'行值不能为空','info');
					v_vali_flag = false;
					return false;
				}
				
				conval.push({ 
					col         : $(this).combo('getValue'),
					compare     : $('#compare'+$(this).attr('pid')).combo('getValue'),
					compareVal  : v_compareVal,
					compare2    : $('#compare'+$(this).attr('pid')+"_2").combo('getValue'),
					compareVal2 : $('#compareVal'+$(this).attr('pid')+"_2").val(),
					value       : v_value
				});
			})
			if(!v_vali_flag) {
				return false;
			}
			
			v_rst_json = {
				    valtyp     : v_valtyp,
					defaultVal : $('#defaultVal').val(),
					conval     : conval
			}
		}
		
		
		
		if(v_winParam && v_winParam.rowidx){
			parent.window.updateColumn(v_title, v_datatype, JSON.stringify(v_rst_json), v_winParam.rowidx);
		}else{
			parent.window.createColumn("COL" + (new Date()).getTime(), v_title, v_datatype, true, JSON.stringify(v_rst_json));
			parent.window.loadColunmSort();
		}
		clsWin();
	}
    
</script>
<style type="text/css">
.form{width:550px;border:0px}
.myui-layout{padding-left:10px;border:0px;margin-top: 10px}
.myui-layout .content .cust_colVal{width: 99%;height:99%;border: 0px;font-size: 14px;font-family: "微软雅黑";text-indent:3px;}
.cust_col_blank{color:#CCC;font-size: 14px;}
.myui-layout .collist{margin-top: 5px}
.myui-layout .collist li{padding-top: 5px;padding-left: 5px;cursor: pointer;}
.myui-layout .collist li label{cursor: pointer;}
.myui-layout .collist li:hover{background-color: #E0ECFF;border-color: #E0ECFF;}
.addConditionVal{color:#374fff;cursor: pointer;}
.singleValue,.conditionValue{display: none}
.valueBox{cursor: pointer; readonly:readonly}
.myui-text{width:180px}
.tabval-text{width:120px}
.conditionValue{width: 520px;padding: 10px 10px 0 20px}
.conditionValue table{border-collapse: collapse;}
.conditionValue table tr{border: 1px solid #CCC;}
.conditionValue table td{vertical-align:middle;text-align: left;color:#333;height: 30px;font-family:"微软雅黑";font-size: 14px;padding-left: 10px;border:1px solid #E0DFDF;}
.conditionValue table td select{font-family:"微软雅黑";font-size: 12px;width: 100px}
.conditionValue table th{background-color: #EEE;color:#666;height: 25px;font-family:"微软雅黑";font-size: 14px;}
.conditionValue table tr .addtd{text-align: center}
.conditionValue table tr .colth{width: 160px}
.conditionValue table tr .conth{width: 200px}
.conditionValue table tr .valth{width: 150px;text-align: center;}
.conditionValue table tr .label{text-align: center;}
.conditionValue table i:HOVER{color:red;cursor: pointer;}
.tabcol_input{width:140px}
</style>
</head>
<body>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
		
		<div class="item">
			<ul>
				<li style="margin-left: 20px">名&nbsp;&nbsp;&nbsp;称：</li>
				<li><input class="myui-text" id="title" name="title" /></li>
				<li style="margin-left: 20px">数据类型：</li>
				<li><input class="myui-text" id="datatype" name="datatype" /></li>
				
			</ul>
		 </div>
		 <div class="item">
			<ul>
				<li style="margin-left: 20px">值类型：</li>
				<li>
                    <input type="radio" class="valtyp" name = "valtyp" id="valtyp1" value="single"/>&nbsp;表达式&nbsp;&nbsp;
					<input type="radio" class="valtyp" name = "valtyp" id="valtyp2" value="condition"/>&nbsp;条件表达式
                </li>
			</ul>
		 </div>
		 <div class="singleValue">
		   <div class="item">
				<ul>
					<li style="margin-left: 20px">字段值：</li>
					<li><input class="myui-text valueBox" id="singleValue" name="singleValue" /></li>
				</ul>
			</div>
		 </div>
		 <div class="conditionValue">
		 	<table>
				<tr class="title">
					<th class='colth'>字段</th>
					<th class='conth'>条件</th>
					<th class='valth'>值</th>
				</tr>
				<tr>
					<td colspan="3" class="addtd"><span class="addConditionVal" onclick="return addConVal()"><i class='fa fa-plus-square fa-lg'></i>&nbsp;添加条件信息</span></td>
				</tr>
				<tr class="defaultVal">
					<td class="label" colspan="2">默认值(除以上情况取此值)</td>
					<td><input class="myui-text valueBox tabval-text" id="defaultVal" name="defaultVal" /></td>
				</tr>
			</table>
		 	
		 	
		 	<!-- div class="item">
				<ul>
					<li style="margin-left: 20px"></li>
				</ul>
			</div>
			<div class="item defaultVal">
				<ul>
					<li style="margin-left: 20px">默认值：</li>
					<li><input class="myui-text valueBox" id="defaultVal" name="defaultVal" /></li>
				</ul>
			</div -->
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