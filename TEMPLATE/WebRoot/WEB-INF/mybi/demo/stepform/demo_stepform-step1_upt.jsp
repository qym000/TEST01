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
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param={
					"userObj.id" : "${obj.id}" ,
					"userObj.nam" : $.trim($("#nam").val()) ,
					"userObj.orgidt" : $.trim($("#orgidt").val()),
					step : "${request.step}"
				};
				add_onload();//开启蒙板层
				$.post("demo_step-form!updateUserObj.action",param,function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatesucc"/>','info');
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatefail"/>','info');
					}
					
					clean_onload();//关闭蒙板层
			    },"json");
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
	
	//提交
	function sbt(){
		$("#form_input").submit();
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
	
	// 切换选项卡页面
	function chgUpdPage(obj, step){
		var flag = $(obj).find("li").eq(2).hasClass("right2");
		if(flag){
			return false;
		}
		window.location.href = "demo_step-form!uptFormController.action?id="+'${obj.id}'+"&step=" + step;	
	}
</script>
</head>
<body>
<div class="myui-form">
	<div class="stepFormTitleBg">
		<ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 1);">
			<li class="left"></li><li class="center">基本信息</li><li class="right2"></li>
		</ul>
		<ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 2);">
			<li class="left-normal"></li><li class="center-normal">个人信息</li><li class="right-normal"></li>
		</ul>
		<ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 3);">
			<li class="left-normal"></li><li class="center-normal">其他信息</li><li class="right-normal"></li>
		</ul>
	</div>
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>姓名：</li>
					<li><input id="nam" name="nam" value="${obj.nam}" maxlength="30" class="myui-text"/></li>
					<li class="tipli"><div id="namTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>所属机构：</li>
					<li><input id="orgidt" name="orgidt" value="${obj.orgidt}" maxlength="30" class="myui-text"/></li>
					<li class="tipli"><div id="orgidtTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt();"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin();" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>

</html>

