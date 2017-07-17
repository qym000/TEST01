<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	$(function(){
		// 初始化页面元素及表单验证
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		// 表单验证初始化
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var orgid = $.trim($("#orgid").val());
				var dat = $.trim($("#dat").val());
				var curcde = $.trim($("#curcde").val());
				//导出监控
				monitorExportStatus('rdd_resdown!monitorExportStatus.action');
		    	window.location.href = "rdd_resdown!downloadZipFile.action?id=${request.resId}&orgid="
		    		+ orgid + "&dat=" + dat + "&curcde=" + curcde;
			}
		});
	}
	
	// 表单提交
	function sbt(){
		$("#form_input").submit();
	}
	
	// 关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
</script>
</head>
<body>

<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc" style="width:130px;">日期：</li>
					<li><input id="dat" name="dat" maxlength="50" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="passwordTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc" style="width:130px;">机构：</li>
					<li><input id="orgid" name="orgid" maxlength="15" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="serveripTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc" style="width:130px;">币种：</li>
					<li><input id="curcde" name="curcde" maxlength="50" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="rptidTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<!-- 下载 -->
		<a class="main_button" href="javascript:void(0);" onclick="sbt()">下载</a>
		<!-- 取消 -->
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>
