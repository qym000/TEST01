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
					"userObj.birthday" : $("#birthday").datebox("getValue") ,
					"userObj.position" : $.trim($("#position").val()) ,
					"userObj.phoneNum" : $.trim($("#phoneNum").val()) ,
					"userObj.address" : $.trim($("#address").val()),
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
		$("#birthday").formValidator().inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
		$("#position").formValidator().inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
		$("#phoneNum").formValidator().functionValidator({
			fun:function(val) {
				var reg = /^[0-9]*$/;
				if (!reg.test(val)) {
					return "请输入数字";
				}
				return true;
			}
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
			<li class="left-normal"></li><li class="center-normal">基本信息</li><li class="right-normal"></li>
		</ul>
		<ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 2);">
			<li class="left"></li><li class="center">个人信息</li><li class="right2"></li>
		</ul>
		<ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 3);">
			<li class="left-normal"></li><li class="center-normal">其他信息</li><li class="right-normal"></li>
		</ul>
	</div>
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>出生日期：</li>
					<li><input id="birthday" name="birthday" value="${obj.birthday}" maxlength="8" class="myui-datebox" style="width:200px;"/></li>
					<li class="tipli"><div id="birthdayTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>职位：</li>
					<li><input id="position" name="position" value="${obj.position}" maxlength="30" class="myui-text"/></li>
					<li class="tipli"><div id="positionTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc">联系方式：</li>
					<li><input id="phoneNum" name="phoneNum" value="${obj.phoneNum}" maxlength="11" class="myui-text"/></li>
					<li class="tipli"><div id="phoneNumTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc">地址：</li>
					<li><input id="address" name="address" value="${obj.address}" maxlength="80" class="myui-text" style="width:200px;"/></li>
					<li class="tipli"><div id="addressTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt();"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>

</html>

