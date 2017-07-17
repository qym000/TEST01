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
// 提交
function sbt() {
	parent.window.resolveHandInput($.trim($("#cycleCode").val()));
	clsWin();
}

// 关闭窗口
function clsWin() {
	parent.$("#handinputWin").window("close");
}
</script>
</head>
<body>
<div class="myui-form">
  <div class="form">
	<div class="item">
	  <ul>
		<li class="desc">周期代码：</li>
		<li><input id="cycleCode" name="cycleCode" class="myui-text"/></li>
	  </ul>
	</div>
  </div>
  <div class="operate">
    <a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
    <a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
  </div>
</div>
<div id="handinputWin"></div>
</body>
</html>