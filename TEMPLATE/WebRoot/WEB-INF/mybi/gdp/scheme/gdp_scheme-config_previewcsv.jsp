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
<style type="text/css">
pre {
	width:1070px;
	height:470px;
	font-family:Courier New;
	font-size:14px;
	overflow:scroll;
	margin:auto;
	border:1px solid #A0A0A0;
}
</style>
<script type="text/javascript">
	$(function(){
		// 初始化页面元素及表单验证
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		$("body").unbind();
	}
	
	// 关闭当前窗口
    function clsWin(){
    	parent.$("#inputWin").window('close');
    }
	
</script>
</head>
<body>

<div class="myui-form">
	<div class="form" style="overflow:hidden;padding-top:2px">
		<pre id="csvContent">${request.csvContent}</pre>
	</div>
	<div class="operate">
		<!-- 取消 -->
		<a class="main_button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_close"/></a>
	</div>
</div>

</body>
</html>
