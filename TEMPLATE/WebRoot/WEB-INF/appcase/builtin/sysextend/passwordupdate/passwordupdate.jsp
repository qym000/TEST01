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
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jQuery.md5.js"></script>
<script type="text/javascript">
	$(function(){
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){return false;},
			onSuccess : function (){
				add_onload();//开启蒙板层
				$.post("pim_sys-user!updateSysUserObjPwd.action",{passwd1:$.md5($.trim($("#passwd1").val()))},function(data){ 
		    		if(data.result=="succ"){
		    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatesucc"/>','info',function(){ //修改成功
			    			clsWin();
		    			});
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatefail"/>','info'); //修改失败
					}
	
		    		clean_onload();//关闭蒙板层
		        },"json"); 
			}
		});
		
		var temp_result=null;	
		$("#passwd").formValidator({onFocus:""}).inputValidator({min:1,onErrorMin:'<s:text name="common_msg_formvalidte_required"/>'})
		.ajaxValidator({
				dataType : "text",
				async : false,
				url : "pim_sys-user!isPasswdValid.action?passwd=''",
				type : "post",
				data: {passwd_old:function(){
					return $.md5($("#passwd").val());
				}},
				success : function(data){
					temp_result=data;
					if (data == "NOVALID") {
	                    return '<s:text name="sysauth_sysuser_passwd_curr_wrong"/>';  //当前密码不正确
	                } else {  
	                    return true;  
	                }  
				},
				onError : function(val,dom){
					if (temp_result == "NOVALID") {
	                    return '<s:text name="sysauth_sysuser_passwd_curr_wrong"/>';  //当前密码不正确
	                } 
				},
				onWait : '<s:text name="common_msg_formvalidte_validating"/>'//校验中
		});
		
		$("#passwd1").formValidator({onFocus:""}).inputValidator({min:6,onErrorMin:'<s:text name="common_msg_formvalidte_nolessthan"><s:param>6</s:param></s:text>'})
			.compareValidator({desID:"passwd",operateor:"!=",onError:'<s:text name="sysauth_sysuser_passwd_curr_nosame"/>'}).functionValidator({fun:isPwdReg});
		$("#passwd2").formValidator({onFocus:""}).inputValidator({min:6,onErrorMin:'<s:text name="common_msg_formvalidte_nolessthan"><s:param>6</s:param></s:text>'})
			.compareValidator({desID:"passwd1",operateor:"=",onError:'<s:text name="sysauth_sysuser_passwd_notequal"/>'});//两次密码不一致
	});
	
	function isPwdReg(pwd){
		if(!/^((?=.*?\d)(?=.*?[A-Za-z])|(?=.*?\d)(?=.*?[!@#$%^&])|(?=.*?[A-Za-z])(?=.*?[!@#$%^&]))[\dA-Za-z!@#$%^&]+$/.test(pwd)) return "<s:text name='sysauth_sysuser_passwd_reg'/>";//密码必须包含数字，字母，特殊符号 
		return true;
	}
	
	/**
	 * 表单提交
	 */
	function sbt(){
		$("#form_input").submit();
	}
	
	/**
	 * 关闭当前窗口
	 */
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
					<li class="desc"><b>* </b><s:text name="sysauth_sysuser_passwd_curr"/>：</li>
					<li><input type="password" id="passwd" name="passwd" maxlength="16" class="myui-text"/></li>
					<li class="tipli"><div id="passwdTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysuser_passwd_new"/>：</li>
					<li><input type="password" id="passwd1" name="passwd1" maxlength="16" class="myui-text"/></li>
					<li class="tipli"><div id="passwd1Tip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysuser_passwd_new2"/>：</li>
					<li><input type="password" id="passwd2" name="passwd2" maxlength="16" class="myui-text"/></li>
					<li class="tipli"><div id="passwd2Tip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>

