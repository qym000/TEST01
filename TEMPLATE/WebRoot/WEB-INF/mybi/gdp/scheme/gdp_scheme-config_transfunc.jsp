<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	$(function(){
		// 初始化页面元素
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		// 函数选择combo
		$("#funcId").combo({
			url : "${ctx}/gdp_function!findFuncList.action",
			textField : "funcName",
			valueField : "funcId",
			panelHeight : 250,
			isCustom : true,
			customData : [{funcId : "", funcName : "--无函数--"}],
			onSelect : function(item){
				if (item.funcId != "") {
					$("#funcDesc").val(item.funcDesc);
					$("#funcExpr").val(item.funcExpr);
				}else {
					$("#funcDesc").val("");
					$("#funcExpr").val("");
				}
			}
		});
	}
	
	// 表单提交
	function sbt(){
		var funcId = $("#funcId").combo("getValue");
		if (funcId != "") {
			// 若果选择了函数,则将函数添加到映射节点上
			var funcName = $("#funcId").combo("getText");
			var funcExpr = $("#funcExpr").val();
			parent.window.addFuncToMap(true, funcId, funcName, funcExpr);
		}else {
			parent.window.addFuncToMap(false);
		}
		clsWin();
	}
	
	// 关闭当前窗口
    function clsWin(){
    	parent.$("#inputWin").window('close');
    }
</script>
</head>
<body>

<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<!-- 函数名称 -->
					<li class="desc"><s:text name="gdp_function_funcName"/>：</li>
					<li><input id="funcId" name="funcId" style="width:160px;"/></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 功能描述 -->
					<li class="desc"><s:text name="gdp_function_funcDesc"/>：</li>
					<li><textarea id=funcDesc name="funcDesc" class="myui-textarea" readonly="readonly" style="width:160px;height:70px;"></textarea></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 函数表达式 -->
					<li class="desc"><s:text name="gdp_function_funcExpr"/>：</li>
					<li><textarea id="funcExpr" name="funcExpr" class="myui-textarea" readonly="readonly" style="width:160px;height:70px;"></textarea></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<!-- 提交 -->
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<!-- 取消 -->
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>
