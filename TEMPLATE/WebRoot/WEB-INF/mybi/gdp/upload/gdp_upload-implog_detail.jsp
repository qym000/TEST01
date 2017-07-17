<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<style type="text/css">
pre {
	white-space:pre-wrap;
	word-wrap:break-word;
}
</style>
<script type="text/javascript">
	/**
	 * 关闭当前窗口
	 */
    function clsWin(){
    	parent.$('#inputWin').window("close");
    }
	
</script>
</head>
<body>

<div class="myui-form">
	<div class="form" style="overflow:hidden;padding-top:2px">
		<pre id="logArea" style="margin:auto;width:99%;border:1px solid #A0A0A0;height:350px;font-size:13px;font-family:微软雅黑;overflow:auto;">${request.logContent}</pre>
	</div>
	<div class="operate">
		<!-- 关闭 -->
		<a id="btn_cls" class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_close"/></a>
	</div>
</div>
</body>
</html>

