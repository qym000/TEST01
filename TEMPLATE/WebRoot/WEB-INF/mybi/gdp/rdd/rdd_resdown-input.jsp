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
				// 参数对象
				var paramObj = {
					"resObj.resName" : $.trim($("#resName").val()),
					"resObj.resType" : "0",
					"resObj.resServer" : $.trim($("#resServer").val())
				}
				//开启蒙板层
				add_onload();
				$.post("${ctx}/rdd_resdown!saveResInfoObj.action",paramObj,function(data){ 
					if(data.result=="succ"){
						//回显刚才操作的记录
						parent.findListById(data.callbackCondition);	
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
					}
			    },"json");
				//关闭蒙板层
				clean_onload();
			}
		});
		// 资源名称不能为空
		$("#resName").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
		// 资源服务器地址不能为空且不可超过200个字符
		$("#resServer").formValidator().inputValidator({min:1,max:200,onErrorMin:"<s:text name='gdp_common_cannotBeEmpty'/>",onErrorMax:"<s:text name='gdp_common_noMoreThan'><s:param>200</s:param></s:text>"});
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
					<!-- 资源名称 -->
					<li class="desc" style="width:130px;"><b>* </b>资源名称：</li>
					<li><input id="resName" name="resName" maxlength="50" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="resNameTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 资源服务器地址 -->
					<li class="desc" style="width:130px;"><b>* </b>资源服务器地址：</li>
					<li><textarea id="resServer" name="resServer" class="myui-textarea" style="width:160px;height:70px;"></textarea></li>
					<li class="tipli"><div id="resServerTip"></div></li>
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
