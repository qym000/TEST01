<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>${sysname}</title>
<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
<meta name="toTop" content="true">
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/themes/default/portal.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/portal.js"></script>
<script type="text/javascript">
	$().ready(function(){
		var stat='${session.loginUserObj.stat}';
		if(stat=="3"){
			openPwdUpdateWin();
		}
	});

	//注销
	function logout(){
		location = "login-portal!sysauthLogout.action";
	}
	
	//弹出密码修改页面
	function openPwdUpdateWin() {
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="sysauth_sysuser_passwd_upt"/>',
			content:'<iframe id="myframe" src=pim_sys-user!toSysUserPwdUpdate.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:300
		});
		
	}
	
	//弹出系统改进建议页面
	function openMsgboardWin() {
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="msgboard"/>',
			content:'<iframe id="myframe" src=pim_sys-improve!toSysImproveObjInput.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:350
		});
	}
	
	function changeLang(flag){
		$.post("start-portal!changeLang.action",{flag:flag},function(data){ 
    		if(data.message=="succ"){
    			window.location.reload();
			}
        },"json");
	}
</script>
</head>
<body class="portal-body">
	<div id="header">
		<div id="top">
			<div id="header_title">
				<ul id="title">
					<li><span id="logo"></span></li>
					<li><img  id="top-line" src="${ctx}/mybi/common/themes/default/images/top-line.png" /></li>
					<li><span id="top-title">${sysname}</span></li>
				</ul>
			</div>
			<div id="header_info">
			<ul>
			</ul>
				<span id="top-user">${session.loginUserObj.nam}&nbsp;&nbsp;</span>
				
				<s:if test='#session.loginUserObj.id!="0"'>
				<span id="top-tools" style="cursor:pointer;" onclick="javascript:openPwdUpdateWin()">
					<img id="top-logout" src="${ctx}/mybi/common/themes/default/images/top-pwd.png" />
					<!-- s:text name="common_action_updatePwd"/> -->&nbsp;&nbsp;</span>
				</s:if>
				
				<s:if test='#session.i18nSwitch=="1"'>
					<s:if test='#session.i18nDefault.equals("en")'>
					
						<span id="top-tools" style="cursor:pointer;" onclick='changeLang("1");'>
							<s:text name="common_msg_zh"/>
						</span>/
						<span  style="color:#DBDBDB">
							<s:text name="common_msg_en"/>
						</span>&nbsp;&nbsp;
					</s:if>
					<s:else>
						<span style="color:#DBDBDB">
							<s:text name="common_msg_zh" />
						</span>/
						<span id="top-tools" style="cursor:pointer;" onclick='changeLang("2");'>
							<s:text name="common_msg_en"/>
						</span>&nbsp;&nbsp;
					</s:else>
				</s:if>
				
				
				<span id="top-tools" style="cursor:pointer;" onclick="javascript:logout()"><img id="top-logout" src="${ctx}/mybi/common/themes/default/images/logout.png" /></span>
				<!-- span id="top-tools" style="cursor:pointer;" onclick="javascript:logout()"><img id="top-logout" src="${ctx}/mybi/common/themes/default/images/top-logout.png" />&nbsp;<s:text name="common_action_logout"/></span -->
			</div>
		</div>
		<!--导航-->
		<div class="nav_main"></div>
	</div>
	<div id="portal">
		<iframe frameborder="0" id="content" name="content" >您的浏览器不支持嵌入式框架，或者当前配置为不显示嵌入式框架。</iframe>
	</div>
	<div id="inputWin"></div>
</body>
<script type="text/javascript">
window.onload=function(){
	renderfun("${ctx}/main-portal!findAllMenu.action","${session.i18nDefault}");
	$("#content").load(function(){
		var mainheight = $(this).contents().find("body").height()+50 > window.screen.availHeight-$(document.body).height()?$(this).contents().find("body").height()+30:window.screen.availHeight-$(document.body).height()-5;
		$(this).height(mainheight);
	});
	
	//如果有欢迎页,则默认加载欢迎页;如果没有,则加载第一个URL非空的功能
	var isHasHomepage='${request.isHasHomepage}';
	if(isHasHomepage=="1"){
		$("#content").attr("src","tp_homepage!toHomepage.action");
	}else{
		$("#content").attr("src","${request.defaultUrl}");
	}
}

function getSysI18n()
{
	return '${session.i18nDefault}';
}
</script>
</html>

