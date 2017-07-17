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
			$("#birthday").datebox("setValue",parent.stepParam.birthday);
			$("#position").val(parent.stepParam.position);
			$("#phoneNum").val(parent.stepParam.phoneNum);
			$("#address").val(parent.stepParam.address);
		}
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				parent.stepParam.birthday = $.trim($("#birthday").datebox("getValue"));
				parent.stepParam.position = $.trim($("#position").val());
				parent.stepParam.phoneNum = $.trim($("#phoneNum").val());
				parent.stepParam.address = $.trim($("#address").val());
				parent.$("#inputWin").window("close");
		    	parent.$("#inputWin").window({
					open : true,
					content:'<iframe id="formS3" name="formS3" src=demo_step-form!stepFormController.action?step=3 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				});
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
	
	//上一步
	function back(){
		parent.$("#inputWin").window("close");
    	parent.$("#inputWin").window({
			open : true,
			content:'<iframe id="formS1" name="formS1" src=demo_step-form!stepFormController.action?step=1 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
		});
	}
	
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
			<li class="left-normal"/><li class="center-normal">基本信息</li><li class="right-normal"/>
		</ul>
		<ul class="stepFormTitleCur">
			<li class="left"></li><li class="center">个人信息</li><li class="right"></li>
		</ul>
		<ul class="stepFormTitleCur">
			<li class="left-normal"></li><li class="center-normal">其他信息</li><li class="right-normal"></li>
		</ul>
	</div>
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>出生日期：</li>
					<li><input id="birthday" name="birthday" maxlength="8" class="myui-datebox" style="width:200px;"/></li>
					<li class="tipli"><div id="birthdayTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>职位：</li>
					<li><input id="position" name="position" maxlength="30" class="myui-text"/></li>
					<li class="tipli"><div id="positionTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc">联系方式：</li>
					<li><input id="phoneNum" name="phoneNum" maxlength="11" class="myui-text"/></li>
					<li class="tipli"><div id="phoneNumTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc">地址：</li>
					<li><input id="address" name="address" maxlength="80" class="myui-text" style="width:200px;"/></li>
					<li class="tipli"><div id="addressTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="button" href="javascript:void(0);" onclick="back()">上一步</a>
		<a class="main_button" href="javascript:void(0);" onclick="next()">下一步</a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>

</html>

