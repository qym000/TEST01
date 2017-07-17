<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/demo/themes/${apptheme}/demo-stepform.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	$(function(){
		if (parent.stepParam != null) {
			$("#nam").val(parent.stepParam.nam);
			$("#orgidt").val(parent.stepParam.orgidt==undefined?"${session.orgcdeObj.orgidt}":parent.stepParam.orgidt);
		} 
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				parent.stepParam.nam = $.trim($("#nam").val());
				parent.stepParam.orgidt = $.trim($("#orgidt").val());
				parent.$("#inputWin").window("close");
		    	parent.$("#inputWin").window({
					open : true,
					content:'<iframe id="formS2" name="formS2" src=demo_step-form!stepFormController.action?step=2 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				});
			}
		});
		$("#nam").formValidator().inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'})//不能为空
		.functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "demo_crud!isCrudNamUnique.action",
			type : "POST",
			data: {nam:$("#nam").val()},
			success : function(data){
				if (data == "false") {
					return '<s:text name="common_msg_formvalidte_alreadyexist"/>';  //已经存在
                } else {  
                    return true;  
                }  
			},
			onError : '<s:text name="common_msg_formvalidte_alreadyexist"/>',//已经存在
			onWait : '<s:text name="common_msg_formvalidte_validating"/>'//校验中
		});
		var temp_orgidt=null;
		$("#orgidt").formValidator().inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'})
		.functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "pim_org!isCdeorgOrgidtValid.action",
			type : "POST",
			data: {orgidt:$("#orgidt").val()},
			success : function(data){
				temp_orgidt=data;
				if (data == "noExist") {
					return '<s:text name="org_orgidt_noExist"/>';  //机构不存在
                } else if (data == "noAuth") {
                	return '<s:text name="org_orgidt_noAuth"/>';  //机构不在权限范围内
                } else {  
                    return true;  
                }  
			},
			onError : function(val,dom){
				if (temp_orgidt == "noExist") {
					return '<s:text name="org_orgidt_noExist"/>';  //机构不存在
                } else if (temp_orgidt == "noAuth") {
                	return '<s:text name="org_orgidt_noAuth"/>';  //机构不在权限范围内
                } 
			},
			onWait : '<s:text name="common_msg_formvalidte_validating"/>'//校验中
		});
	});
	
	//下一步
	function next(){
		$("#form_input").submit();
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
</script>
</head>
<body>
<div class="myui-form">
	<div class="stepFormTitleBg">
		<ul class="stepFormTitleCur">
			<li class="left"/><li class="center">基本信息</li><li class="right"/>
		</ul>
		<ul class="stepFormTitleCur">
			<li class="left-normal"></li><li class="center-normal">个人信息</li><li class="right-normal"></li>
		</ul>
		<ul class="stepFormTitleCur">
			<li class="left-normal"></li><li class="center-normal">其他信息</li><li class="right-normal"></li>
		</ul>
	</div>
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>姓名：</li>
					<li><input id="nam" name="nam" maxlength="30" class="myui-text"/></li>
					<li class="tipli"><div id="namTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>所属机构：</li>
					<li><input id="orgidt" name="orgidt" maxlength="30" value="${session.orgcdeObj.orgidt}" class="myui-text"/></li>
					<li class="tipli"><div id="orgidtTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="next()">下一步</a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>

</html>

