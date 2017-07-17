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
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	var sttParams = ${request.sttParams};
	$(function(){
		// 初始化页面元素及表单验证
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		if (sttParams) {
			$("#serverip").val(sttParams.serverip);
			$("#user").val(sttParams.user);
			$("#password").val(sttParams.password);
			$("#forder").val(sttParams.forder);
			$("#rptid").val(sttParams.rptid);
			$("#dat").val(sttParams.dat);
			$("#orgid").val(sttParams.orgid);
			$("#curcde").val(sttParams.curcde);
		}
		// 表单验证初始化
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				// 参数对象
				var paramObj = {
					"resObj.resId" : "${resObj.resId}",
					"resObj.sttParams" : JSON.stringify(getJsonParams())
				};
				//开启蒙板层
				add_onload();
				$.post("${ctx}/rdd_resdown!saveResSttParams.action",paramObj,function(data){ 
					if(data.result=="succ"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
					}
			    },"json");
				//关闭蒙板层
				clean_onload();
			}
		});
		$("#serverip").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
		$("#user").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
		$("#password").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
		$("#forder").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
		$("#rptid").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
	}
	
	// 获取Json参数
	function getJsonParams() {
		var obj = {
			serverip : $.trim($("#serverip").val()),
			user : $.trim($("#user").val()),
			password : $.trim($("#password").val()),
			forder : $.trim($("#forder").val()),
			rptid : $.trim($("#rptid").val()),
			dat : $.trim($("#dat").val()),
			orgid : $.trim($("#orgid").val()),
			curcde : $.trim($("#curcde").val())
		}
		return obj;
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
					<!-- 服务器IP -->
					<li class="desc" style="width:130px;"><b>* </b>服务器IP：</li>
					<li><input id="serverip" name="serverip" maxlength="15" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="serveripTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 用户名 -->
					<li class="desc" style="width:130px;"><b>* </b>用户名：</li>
					<li><input id="user" name="user" maxlength="50" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="userTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 密码 -->
					<li class="desc" style="width:130px;"><b>* </b>密码：</li>
					<li><input id="password" name="password" maxlength="50" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="passwordTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 报表服务器目录 -->
					<li class="desc" style="width:130px;"><b>* </b>报表服务器目录：</li>
					<li><input id="forder" name="forder" maxlength="50" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="forderTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 报表编号 -->
					<li class="desc" style="width:130px;"><b>* </b>报表编号：</li>
					<li><input id="rptid" name="rptid" maxlength="50" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="rptidTip"></div></li>
				</ul>
			 </div>
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
		<!-- 提交 -->
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<!-- 取消 -->
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>
