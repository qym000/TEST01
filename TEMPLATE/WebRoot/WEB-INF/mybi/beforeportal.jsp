<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidatorRegex.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jQuery.md5.js"></script>
<style type="text/css">
	.container_menu{width:640px; height:280px; border:#cdcdcd 1px solid; margin-left:auto; margin-right:auto; margin-top:100px;}
	.div_left{ width:250px; height:490px; border:#cdcdcd 1px solid; float:left; background-color:#fefefe; border-left:0; border-bottom:0; border-top:0;}
	.title_menu{ width:250px; height:35px; border:#cdcdcd 1px solid; background-color:#fbfbf5; border-left:0; border-right:0; border-top:0; font-size:14px; font-weight:bold;font-family:"微软雅黑";}
	.btn_menu{ width:85px; height:35px; float:right;margin-top:10px; font-size:12px;}
	.div_right{ width:640px; height:400px;border:#cdcdcd 1px solid; float:left;border-left:0; border-right:0; border-top:0; border-bottom:0; position:relative;}
	.title_prop{ width:640px; height:35px; font-size:14px; font-weight:bold; float:left;font-family:"微软雅黑";border:#cdcdcd 1px solid;background-color:#fbfbf5; border-top:0; border-left:0; border-right:0;}
	.label_prop{text-align:right; font-size:12px; font-weight:bold;font-family:"微软雅黑";}
	.title_action{ width:640px; height:30px; border:#cdcdcd 1px solid; background-color:#fbfbf5; font-size:14px;font-weight:bold;font-family:"微软雅黑"; border-left:0; border-right:0; margin-top:20px;}
	.btn_action_list{ width:130px; height:23px; float:right;font-size:12px; color:#374fff; margin-top:7px;}
	.info td{ border:#dbdbdb 1px solid;font-size:12px; color:#646464;height:23px; font-family:"微软雅黑";text-align:center; line-height:23px;}
	.info th{ border:#dbdbdb 1px solid;font-size:12px; color:#000;height:23px; font-family:"微软雅黑";text-align:center; line-height:23px;}
	.button_sbt{position:relative;padding:3px 14px;border: 1px solid #dbdbdb;background:#FFFFFF;bottom:-8px;}
	.button_sbt:HOVER{color: #fe710a;font-weight: bold;}
</style>
<script type="text/javascript">
	$(function(){
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){return false;},
			onSuccess : function (){
				add_onload();//开启蒙板层
				$.post("pim_sys-user!updateSysUserObjPwd.action",{passwd1:$.md5($.trim($("#passwd1").val()))},function(data){ 
		    		if(data.result=="succ"){
		    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatesucc"/>','info',function(){ //修改成功
		    				location = "main-portal.action";
		    			});
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatefail"/>','info'); //修改失败
					}
	
		    		clean_onload();//关闭蒙板层
		        },"json"); 
			}
		});
		
		$("#passwd1").formValidator({onFocus:""}).inputValidator({min:6,onErrorMin:'<s:text name="common_msg_formvalidte_nolessthan"><s:param>6</s:param></s:text>'})
		.functionValidator({fun:isPwdReg})
		.ajaxValidator({
				dataType : "text",
				async : false,
				url : "pim_sys-user!isPasswdValid.action?passwd1=''",
				type : "post",
				data: {passwd_old:function(){
					return $.md5($("#passwd1").val());
				}},
				success : function(data){
					temp_result=data;
					if (data == "VALID") {
	                    return '<s:text name="sysauth_sysuser_passwd_curr_nosame"/>';  //不能与当前密码相同
	                } else {  
	                    return true;  
	                }  
				},
				onError : function(val,dom){
					if (temp_result == "VALID") {
	                    return '<s:text name="sysauth_sysuser_passwd_curr_nosame"/>';  //不能与当前密码相同
	                } 
				},
				onWait : '<s:text name="common_msg_formvalidte_validating"/>'//校验中
		});
		$("#passwd2").formValidator({onFocus:""}).inputValidator({min:6,onErrorMin:'<s:text name="common_msg_formvalidte_nolessthan"><s:param>6</s:param></s:text>'})
			.compareValidator({desID:"passwd1",operateor:"=",onError:'<s:text name="sysauth_sysuser_passwd_notequal"/>'});//两次密码不一致
	});
	
	/**
	 * 表单提交
	 */
	function sbt(){
		$("#form_input").submit();
	}
	
	function enter(){
		location = "main-portal.action";
	}
	
	function isPwdReg(pwd){
		if(!/^((?=.*?\d)(?=.*?[A-Za-z])|(?=.*?\d)(?=.*?[!@#$%^&])|(?=.*?[A-Za-z])(?=.*?[!@#$%^&]))[\dA-Za-z!@#$%^&]+$/.test(pwd)) return "<s:text name='sysauth_sysuser_passwd_reg'/>";//密码必须包含数字，字母，特殊符号 
		return true;
	}
</script>
</head>

<body>
<div class="container_menu" >
         <div class="div_right">
              <div class="title_prop">
                  <a style="float:left; margin-left:15px; margin-top:10px;"><s:text name="sysauth_sysuser_passwd_upt"/><a>
              </div>
              <div class="myui-form" style="height:220px;margin-bottom:0px;">
			 	   <div class="form" style="height:217px;">
			 	   	<br/>
			 		    <form id="form_input" method="post">
	               		<table align="center" border="0">
	               			<tr>
	               				<td class="label_prop"  colspan=3 style="text-align:center;color:red;"><s:text name="sysauth_sysuser_passwd_expiretip"/></td>
	               			</tr>
	               			<tr>
	               				<td colspan=3>&nbsp;</td>
	               			</tr>
		               		<tr height="30px">
		               			<td class="label_prop"  style="width:130px;"><b style="color:#F00;">*</b><s:text name="sysauth_sysuser_passwd_new"/>：</td>
		               			<td style="width:170px;"><input type="password" id="passwd1" name="passwd1" maxlength="16" class="myui-text" style="width:200px; height:20px;"></td>
		               			<td class="tipli" style="width:270px;"><div id="passwd1Tip"></div></td>
		               		</tr>
		               		<tr height="30px">
		               			<td class="label_prop"><b style="color:#F00;">*</b><s:text name="sysauth_sysuser_passwd_new2"/>：</td>
		               			<td><input type="password" id="passwd2" name="passwd2" maxlength="16" class="myui-text" style="width:200px; height:20px;"></td>
		               			<td class="tipli"><div id="passwd2Tip"></div></td>
		               		</tr>
		               		<tr>
		               			<td colspan="3" style="text-align:right;padding-right:50px;padding-top:50px;">
									<a class="button_sbt" id="btn_upt" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<s:if test='#application.passwdexpiremustupdate=="0"'>
										<a class="button_sbt" href="javascript:void(0);" onclick="enter()"><s:text name="common_action_enter"/></a>
									</s:if>
		               			</td>
		               		</tr>
	               		</table>
               		</form>
              	 </div>
               </div>
         </div>
</div>

<div id="inputWin">
</div>
</body>
</html>
