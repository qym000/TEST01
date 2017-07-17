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
    <link rel="shortcut icon" href="appcase/builtin/theme/${apptheme}/images/ico_${sysmarker}.ico" type="image/x-icon" />
    <link href="${ctx}/mybi/pim/theme/${apptheme}/login.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${ctx}/mybi/common/script/lib/jquery.js"></script>
    <script type="text/javascript" src="${ctx}/mybi/common/script/my.jslib.js"></script>
    <script type="text/javascript" >
        $().ready(function(){
        	$("#logid").focus();
        	
        	var i18n=getCookie("com.mingyoutech.cookie.i18n");
        	if(i18n==null || i18n=="zh"){
        		document.title='${sysname}';
        	}else{
        		document.title='${sysnameEg}';
        	}
        	
            //绑定回车事件
            $("body").bind("keypress",function(event){
                 if (getKeyCode(event) == 13){
                	 login();
	    		    event.preventDefault();
	    	     }
	        });
        });
    
        //获得事件码
        function getKeyCode(evt) {
            if (typeof(evt)=='string') return evt.charCodeAt(0);
            return document.all? event.keyCode: (evt && evt.which)? evt.which: 0;
        }
    
        //提交
        function login(){
            var logid=$.trim($("#logid").val());
            var passwd=$.trim($("#passwd").val());
            var isLogidCookie=getChecked("isLogidCookie");
            var isPasswdCookie=getChecked("isPasswdCookie");
            if(logid==""){
                $("#loginmsg").html('<s:text name="sysauth_sysuser_logid_notEmpty"/>');  //登录编号不能为空
                return;
            }else if(passwd==""){
    		    $("#loginmsg").html('<s:text name="sysauth_sysuser_passwd_notEmpty"/>');  //密码不能为空
    		    return;
    	    }
            
            $("#btn_sub").hide();
            $("#loginmsg").html("<img src='${ctx}/mybi/pim/theme/${apptheme}/images/loading.gif' width='16px' height='16px'/>");
    	
            $.getJSON("login-sso!ssoLogin.action",{logid:logid,passwd:passwd,isLogidCookie:isLogidCookie,isPasswdCookie:isPasswdCookie},function(data){
                var message=data.message;
                if(message == "logid not exist") {
 				    $("#loginmsg").html('<s:text name="sysauth_sysuser_logid_notExist"/>');  //用户名不存在
 		        }else if(message=="not match"){
 				    $("#loginmsg").html('<s:text name="sysauth_sysuser_passwd_wrong"/>');  //用户名密码不正确
 			    }else if(message == "stat invalid") {
				    $("#loginmsg").html('<s:text name="sysauth_sysuser_stat_invalid"/>');  //用户状态无效
			    }else if(message == "stat lck") {
				    $("#loginmsg").html('<s:text name="sysauth_sysuser_stat_lck"/>');   //用户已被锁定
			    }else if(message == "login repeate") {
				    $("#loginmsg").html('<s:text name="sysauth_sysuser_msg_loginrepeate"/>');   //用户已经登录
			    }else if(message == "login succ"){
				    location = "main-default.action";
 			    } 
 			    $("#btn_sub").show();
            }); 
        }
        
     	//得到表中选中的记录
		function getChecked(ck){
		    var isCk = document.getElementsByName(ck);
		    var val;
		    if(isCk[0].checked){
		        val = isCk[0].value;
			}else{
				val="0";
			}
		    
		    return val;
		}
    </script>
</head>
<body>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td height="147" align="center" background="${ctx}/mybi/pim/theme/${apptheme}/images/top02.gif">&nbsp;</td>
        </tr>
    </table>
    <table width="562" border="0" align="center" cellpadding="0" cellspacing="0" class="right-table03">
	    <tr>
            <td colspan="2" align="center" style="color:black;font-size:31px;font-family: 黑体;font-weight:bold">
            	#####	单点登录......................根据实际情况修改	#####
                <img src="${ctx}/appcase/builtin/theme/${apptheme}/images/sysnam_${sysmarker}.png"  border="0">
            </td>
        </tr>
        <tr>
            <td width="221">
                <table width="95%" border="0" cellpadding="0" cellspacing="0" class="login-text01">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="login-text01">
                                <tr>
                                    <td align="center"><img src="${ctx}/appcase/builtin/theme/${apptheme}/images/logo1_${sysmarker}.png" width="150" height="150" /></td>
                                </tr>
                                <tr>
                                    <td height="40" align="center">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                        <td><img src="${ctx}/mybi/pim/theme/${apptheme}/images/line01.gif" width="5" height="292" /></td>
                    </tr>
                </table>
            </td>
            <td>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="31%" height="35" class="login-text02"><s:text name="sysauth_sysuser_logid"/>：</td>
                        <td width="69%"><input id="logid" name="logid" type="text" size="30" value="${logid}" style="width:220px"/></td>
                    </tr>
                    <tr>
                        <td height="35" class="login-text02"><s:text name="sysauth_sysuser_passwd"/>：</td>
                        <td><input id="passwd" name="passwd" type="password" size="30"  value="${passwd}" style="width:220px"/></td>
                    </tr>
                    <tr>
                        <td height="35" class="login-text02"></td>
                        <td class="login-text02" style="text-align:left;">
                        	<input type="checkbox" name="isLogidCookie" value="1"/><s:text name="sysauth_sysuser_logid_rem"/>(${cookie_age_logid}<s:text name="common_msg_day"/>)
                        	<br/>
                        	<input type="checkbox" name="isPasswdCookie" value="1"/><s:text name="sysauth_sysuser_passwd_rem"/>(${cookie_age_passwd}<s:text name="common_msg_day"/>)
                        </td>
                    </tr>
                    <tr>
                        <td height="35">&nbsp;</td>
                        <td>
                            <input id="btn_sub" type="button" class="right-button01" value='<s:text name="common_action_login"/>' onclick="login()" />
                            <span id="loginmsg" style="color:#F0D07A;font-weight:bold;">
                            	${request.message}
                            </span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>