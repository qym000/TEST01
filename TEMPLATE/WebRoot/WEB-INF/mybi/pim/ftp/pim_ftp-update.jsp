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
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidatorRegex.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	$(function(){
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			
			onSuccess:function(){
				add_onload();//开启蒙板层
				
				var param = {
					"pim_ftp.ftpId":$.trim($("#ftpId").val()),	
					"pim_ftp.ftpDesc":$.trim($("#ftpDesc").val()),	
					"pim_ftp.serverIp":$.trim($("#serverIp").val()),	
					"pim_ftp.serverPort":$.trim($("#serverPort").val()),	
					"pim_ftp.username":$.trim($("#username").val()),	
					"pim_ftp.password":$.trim($("#password").val()),	
					"pim_ftp.url":$.trim($("#url").val())	
				};
				$.post("pim_ftp!updateFtpObj.action", param, function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);//回显刚才操作的记录
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatesucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatefail"/>','info');
					}
					clean_onload();//关闭蒙板层
			    },"json");
			}
		});
		
		$("#ftpDesc").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"})
		.ajaxValidator({
			dataType : "text",
			url : "pim_ftp!checkFtpUnique.action?ftpDesc_tmp="+encodeURIComponent('${obj.ftpDesc}'),
			type : "POST",
			data: {},
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
		$("#serverIp").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#serverPort").formValidator({onFocus:""}).regexValidator({regExp:"intege1",dataType:"enum",onError:'<s:text name="common_msg_formvalidte_onlyinteger"/>'});//只能输入正整数
		$("#username").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#password").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#url").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
	});
	
	/**
	 * 表单提交
	 */
	function sbt(){
		$("#form_input").submit();
	}
	
	/**
	 * 测试连接
	 */
	 function testConnection(){
		 var param = {
			"pim_ftp.ftpDesc":$.trim($("#ftpDesc").val()),	
			"pim_ftp.serverIp":$.trim($("#serverIp").val()),	
			"pim_ftp.serverPort":$.trim($("#serverPort").val()),	
			"pim_ftp.username":$.trim($("#username").val()),	
			"pim_ftp.password":$.trim($("#password").val())	
		};
		 
		 if(param["pim_ftp.serverIp"] == "" || param["pim_ftp.serverPort"] == "" || param["pim_ftp.username"] == "" || param["pim_ftp.password"] == ""){
			 return;
		 }
		 
		 add_onload();//开启蒙板层
		 $.getJSON("pim_ftp!testFtpConnection.action", param, function(data){
			if(data.info == "succ"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="pim_common_testconn_succ"/>','info');
			}else if(data.info == "fail"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="pim_common_testconn_fail"/>','info');
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>', data.errmsg,'info');
			}
			clean_onload();
		 }).error(function(xhr,errorText,errorType){
	        	$.messager.alert('<s:text name="common_msg_info"/>',xhr.responseText,'info');
	        	clean_onload();
	     });
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
			<input type="hidden" id="ftpId" name="ftpId" value="${obj.ftpId}"/>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_ftp_ftpdesc"/>：</li>
					<li><input id="ftpDesc" name="pim_ftp.ftpDesc" maxlength="30" class="myui-text" value="${obj.ftpDesc}"/></li>
					<li class="tipli"><div id="ftpDescTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_ftp_serverip"/>：</li>
					<li><input id="serverIp" name="serverIp" maxlength="20" class="myui-text" value="${obj.serverIp}"/></li>
					<li class="tipli"><div id="serverIpTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_ftp_port"/>：</li>
					<li><input id="serverPort" name="serverPort" maxlength="10" class="myui-text" value="${obj.serverPort}"/></li>
					<li class="tipli"><div id="serverPortTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_ftp_username"/>：</li>
					<li><input id="username" name="username" maxlength="10" class="myui-text" value="${obj.username}"/></li>
					<li class="tipli"><div id="usernameTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_ftp_password"/>：</li>
					<li><input id="password"  type="password" name="password" maxlength="30" class="myui-text" value="${obj.password}"/></li>
					<li class="tipli"><div id="passwordTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_ftp_filepath"/>：</li>
					<li><input id="url" name="url" maxlength="100" class="myui-text" value="${obj.url}"/></li>
					<li class="tipli"><div id="urlTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="button" href="javascript:void(0);" onclick="testConnection();"><s:text name="pim_common_testconn"/></a>
		<a class="main_button" href="javascript:void(0);" onclick="sbt();"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin();" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>