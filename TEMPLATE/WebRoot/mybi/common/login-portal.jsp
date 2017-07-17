<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>${sysname}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="pragma" content="no-cache"> 
    <meta http-equiv="cache-control" content="no-cache"> 
    <meta http-equiv="expires" content="0"> 
    <link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
    <script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
    <script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
    <script type="text/javascript" src="${ctx}/mybi/common/scripts/jQuery.md5.js"></script> 
    <link href="${ctx}/mybi/common/themes/${apptheme}/login.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		a{text-decoration:none;color:none;color:#333333;font-family:宋体;font-size:12px;font-weight: normal;font-style:normal;}
		.labeldiv{ font-size:14px; font-family: "微软雅黑"; color:#FFFFFF;}
		.btn{background-image:url(${ctx}/mybi/common/themes/default/images/login/btn-login.png);width:150px;height:41px;border:0px;cursor:hand;background-color:transparent;border:0px;font-family: "微软雅黑";font-size: 16px;color:#8e2d2d;}
		.inputdiv-yzm{border:0px;background:url(${ctx}/mybi/common/themes/default/images/login/query-text-yzm.png);background-repeat:no-repeat;width:130px;height:37px;padding-top:4px;}
		.inputtext-yzm{border:0px; font-family:微软雅黑;font-size:16px;border:0px;margin-left:3px;background:Transparent;width:113px;height:30px;line-height:30px;}
		.inputdiv-long{border:0px;background:url(${ctx}/mybi/common/themes/default/images/login/query-text-long.png);background-repeat:no-repeat;width:287px;height:37px;}
		.inputtext-long{border:0px; font-family:微软雅黑;font-size:16px;border:0px;margin-left:3px;background:Transparent;width:280px;height:30px;line-height:30px;}
		.sysnam-title{ padding-left: 20px; color:#a71e32; line-height:46px;  font-family:微软雅黑; font-size:28px}
		.sysnameg-title{padding-left: 20px; color:#aaa; line-height:46px;  font-family:微软雅黑; font-size:12px}
		.yzmcss{color:#aaa;}
		.login-link{text-align: right; }
		.login-link a{color: #72ACE3;font-family:微软雅黑;font-size:14px;padding-right: 10px;}
	</style>
	<script language="javascript">
		$().ready(function(){
			$("#logid").focus();
		    //绑定回车事件
		    $("body").bind("keypress",function(event){
		         if (getKeyCode(event) == 13){
		        	 login();
				    event.preventDefault();
			     }
		    });
		    var logidpasswderrorinputvcode='${logidpasswderrorinputvcode}';
			var inputerrtimes='${inputerrtimes}';
			
		    if(parseInt(inputerrtimes)>=parseInt(logidpasswderrorinputvcode)){
		    	$("#formtr,#formtbl").attr("height","255px");
			    $(".divyzm").show();
		    }else{
		    	$("#formtr,#formtbl").attr("height","215px");
			    $(".divyzm").hide();
		    }
		});
		
		//登录
		function login(){
			var logid=$.trim($("#logid").val());
	        var passwd=$.trim($("#passwd").val());
	        var vcode="";
	        	
	        if(logid==""){
	            $("#loginmsg").html('<s:text name="sysauth_sysuser_logid_notEmpty"/>');  //登录编号不能为空
	            return;
	        }else if(passwd==""){
			    $("#loginmsg").html('<s:text name="sysauth_sysuser_passwd_notEmpty"/>');  //密码不能为空
			    return;
		    }
	        if($("#vcode").is(":visible")){
	        	vcode=$.trim($("#vcode").val());
	        	if(vcode==""){
	        		 $("#loginmsg").html('<s:text name="common_msg_yzmnotempty"/>');  //yzm不能为空
	 	            return;
	        	}
	        } 
	        
	        $("#loginmsg").html("<img src='${ctx}/mybi/common/themes/default/images/login/loading.gif' width='16px' height='16px'/>");
	        $.getJSON("login-portal!pwdLogin.action",{logid:logid,passwd:$.md5(passwd),vcode:vcode},function(data){
	            var message=data.message;
	            var inputerrtimes=data.inputerrtimes;
	            if(message=="not match"){
					$("#loginmsg").html('<s:text name="sysauth_sysuser_logidpasswd_wrong"/>');  //用户名密码不匹配
					var logidpasswderrorinputvcode='${logidpasswderrorinputvcode}';
					if($("#vcode").is(":hidden") && parseInt(inputerrtimes)>=parseInt(logidpasswderrorinputvcode)){
						$("#formtr,#formtbl").attr("height","255px");
					    $(".divyzm").show();
					}
					
					if($("#vcode").is(":visible")){
					    chgvcode();
				    }
				}else if(message == "vcode error") {
				    $("#loginmsg").html('<s:text name="common_msg_yzmerror"/>');  //验证码错误
				    if($("#vcode").is(":visible")){
					    chgvcode();
				    }
			    }else if(message == "stat invalid") {
				    $("#loginmsg").html('<s:text name="sysauth_sysuser_stat_invalid"/>');  //用户状态无效
				    
				    
				    if($("#vcode").is(":hidden")){
						$("#formtr,#formtbl").attr("height","255px");
					    $(".divyzm").show();
					}
				    chgvcode();
			    }else if(message == "stat lck") {
				    $("#loginmsg").html('<s:text name="sysauth_sysuser_stat_lck"/>');   //用户已被锁定
				    
				    if($("#vcode").is(":hidden")){
						$("#formtr,#formtbl").attr("height","255px");
					    $(".divyzm").show();
					}
				    chgvcode();
			    }else if(message == "login error") {
				    $("#loginmsg").html('<s:text name="sysauth_sysuser_msg_loginerror"/>');   //登录异常
				    
				    if($("#vcode").is(":hidden")){
						$("#formtr,#formtbl").attr("height","255px");
					    $(".divyzm").show();
					}
				    chgvcode();
			    }else if(message == "passwd expire"){
				    location = "main-portal!toBeforeportal.action";
				} else if(message == "login succ"){
				    location = "main-portal.action";
				} 
	        }); 
		}
		
		//支持回车
		function getKeyCode(evt) {
		  if (typeof(evt)=='string') return evt.charCodeAt(0);
		  return document.all? event.keyCode: (evt && evt.which)? evt.which: 0;
		}
		
		function chgvcode(){
			$("#vcodeimage").attr("src", 'generate-vcodeimage.action?aaa='+ Math.random());
		}
		
		function clrvcode(o){
			if($(o).val()=="<s:text name='common_msg_yzm'/>:"){
				$(o).val("");
				$(o).removeClass("yzmcss");
			}
		}
	</script>
</head>
<body style="overflow: hidden"  leftmargin="0" rightmargin="0" topmargin="0" bottommargin="0" width="1024" height="768px">
<form name="f1" method="post">
	<table  width="1024" height="100%" align="center" background="${ctx}/mybi/common/themes/default/images/login/back.jpg" border="0" cellpadding="0" cellspacing="0" >
  		<tr height="21px">
    		<td width="5px" rowspan="3"></td>
    		<td scope="col"></td>
  		</tr>
	 	<tr height="38px">
	    	<td><img src="${ctx}/appcase/builtin/images/logo.png"/></td>
	    </tr>
	    <tr height="21px">
	    	<!-- 此处写链接 -->
	    	<td class="login-link"><!-- a href="#">测试链接1</a><a href="#">测试链接2</a -->&nbsp;</td>
	    </tr>
	    <tr height="2px">
	    	<td background="${ctx}/mybi/common/themes/default/images/login/line-login.jpg" colspan="2"></td>
	    </tr>
	    <tr height="20px">
	    	<td></td>
	    	<td></td>
	  	</tr>
	  	<tr height="31px">
	    	<td align="center" colspan="2" class="sysnam-title">${sysname}</td>
	  	</tr>
	  	<tr height="15px">
	    	<td colspan="2"></td>
	  	</tr>
	  	<tr height="13px">
	    	<td align="center" colspan="2" class="sysnameg-title">${sysname_eg}</td>
	  	</tr>
	  	<tr height="30px">
	    	<td colspan="2"></td>
	  	</tr>
  		<tr height="8px">
    		<td align="center" colspan="2"><img src="${ctx}/mybi/common/themes/default/images/login/nameline-login.jpg"/></td>
  		</tr>
  		<tr height="35px">
    		<td colspan="2"></td>
  		</tr>
	  	<tr height="255px" id="formtr">
	    	<td colspan="2" align="center">
				<table id="formtbl" height="255px" width="330" background="${ctx}/mybi/common/themes/default/images/login/panel-login2.png" style="background-repeat:no-repeat;" cellpadding="0" cellspacing="0">
					<tr height="15px">
						<td width="35px" rowspan="11"></td>
						<td></td>
						<td width="35px" rowspan="11"></td>
					</tr>
					<tr height="5px" align="left" class="labeldiv">
						<td><s:text name="sysauth_sysuser_logid"/></td>
					</tr>
					<tr height="3px">
						<td></td>
					</tr>
					<tr height="37px" align="left">
						<td><div class="inputdiv-long"><input name="logid" type="text" id="logid" class="inputtext-long"/></div></td>
					</tr>
					<tr height="5px">
						<td></td>
					</tr>
					<tr height="5px" align="left" class="labeldiv">
						<td><s:text name="sysauth_sysuser_passwd"/></td>
					</tr>
					<tr height="3px">
						<td></td>
					</tr>
					<tr height="37px" align="left">
						<td><div class="inputdiv-long"><input name="passwd" id="passwd" type="password"  class="inputtext-long" ></div></td>
					</tr>
					<tr height="12px" class="divyzm">
						<td></td>
					</tr>
					
					<tr height="37px" align="left" class="divyzm">
						<td>
							<table border=0>
								<tr>
									<td><div class="inputdiv-yzm"><input  name="vcode" id="vcode" type="text" value="<s:text name="common_msg_yzm"/>:"  onclick="clrvcode(this)"  class="inputtext-yzm yzmcss" ></div></td>
									<td><img src="generate-vcodeimage.action" id="vcodeimage" onclick="this.src='generate-vcodeimage.action?aaa='+ Math.random()" title="<s:text name="common_msg_yzmref2"/>"/></td>
									<td style="padding-top:18px;"><a href="javascript:void(0);" onclick="javascript:chgvcode()" style="color:#fff;text-decoration:underline;"><s:text name="common_msg_yzmref"/></a></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<table width="100%">
								<tr>
									<td width="150px"><input type="button" class="btn" value='<s:text name="common_action_login"/>' style="cursor:hand;" onclick="login()" /></td>
									<td width="100%" align="center" class="labeldiv"  id="loginmsg"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
	  	</tr>
		<tr>
		    <td align="center" colspan="2" ><img src="${ctx}/mybi/common/themes/default/images/login/panel-login-ty.png" width="330"></td>
		</tr> 
	    <tr>
	        <td colspan="2" height="100%">&nbsp;</td>
	    </tr>
	</table>
</form>

</body>

</html>

