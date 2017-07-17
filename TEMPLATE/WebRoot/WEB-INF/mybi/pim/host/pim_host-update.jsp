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
<script type="text/javascript">
	$(function(){
		$("#connType").combo({
			mode:'local',
			valueField:'id',
			textField:'nam',
			data : [{id:"SSH", nam:"SSH"}, {id:"TELNET", nam:"TELNET"}, {id:"CMD", nam:"CMD"}],
			isCustom:false,
			panelHeight:80,
			defaultValue:'${obj.connType}',
			onSelect:function(r){
				if(r.id == "SSH" || r.id == "TELNET"){
					$(".disablebutton").show();
				}else if(r.id == "CMD"){
					$(".disablebutton").hide();
				}
			},
			
			onLoadSuccess:function(){
				if('${obj.connType}' == 'CMD'){
					$(".disablebutton").hide();
				}
			}
		});
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			
			onSuccess:function(){
				add_onload();//开启蒙板层
				var param = {
					"pim_host.hostId":$.trim($("#hostId").val()),
					"pim_host.hostName":$.trim($("#hostName").val()),
					"pim_host.serverIp":$.trim($("#serverIp").val()),
					"pim_host.username":$.trim($("#username").val()),
					"pim_host.password":$.trim($("#password").val()),
					"pim_host.connType":$("#connType").combo("getValue"),
					"pim_host.remark":$.trim($("#remark").val())
				};
				$.post("pim_host!updateHostObj.action", param, function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatesucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatefail"/>','info');
					}
					clean_onload();//关闭蒙板层
			    },"json");
			}
		});
		
		$("#hostName").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"})
		.ajaxValidator({
			dataType : "text",
			url : "pim_host!checkHostNameUnique.action?hostName_tmp="+encodeURIComponent('${obj.hostName}'),
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
		$("#username").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#password").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#remark").formValidator({onFocus:""}).inputValidator({max:800,onError:'<s:text name="common_msg_formvalidte_nomorethan"><s:param>800</s:param></s:text>'});//不能超过100字符
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
			"pim_host.serverIp":$.trim($("#serverIp").val()),
			"pim_host.username":$.trim($("#username").val()),
			"pim_host.password":$.trim($("#password").val()),
			"pim_host.connType":$("#connType").combo("getValue")
		};
		
		 if(param["pim_host.serverIp"] == "" || param["pim_host.username"] == "" || param["pim_host.password"] == "" || param["pim_host.connType"] == ""){
			 return;
		 }
		 
		 add_onload();
		 $.getJSON("pim_host!testHostConnection.action", param, function(data){
			if(data.info == "succ"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="pim_common_testconn_succ"/>','info');
			}else if(data.info == "connfail"){
				$.messager.alert('<s:text name="common_msg_info"/>', '<s:text name="pim_common_testconn_connfail"/>','info');
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>', '<s:text name="pim_common_testconn_loginerr"/>','info');
			}
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
			<input type="hidden" id="hostId" name="hostId" value="${obj.hostId}"/>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_host_hostname"/>：</li>
					<li><input id="hostName" name="pim_host.hostName" maxlength="30" value="${obj.hostName}" class="myui-text"/></li>
					<li class="tipli"><div id="hostNameTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_host_hostip"/>：</li>
					<li><input id="serverIp" name="serverIp" maxlength="20" value="${obj.serverIp}" class="myui-text"/></li>
					<li class="tipli"><div id="serverIpTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_host_username"/>：</li>
					<li><input id="username" name="username" maxlength="20" value="${obj.username}" class="myui-text"/></li>
					<li class="tipli"><div id="usernameTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_host_password"/>：</li>
					<li><input id="password"  type="password" name="password" maxlength="20" value="${obj.password}" class="myui-text"/></li>
					<li class="tipli"><div id="passwordTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b><s:text name="pim_host_connecttype"/>：</li>
					<li><input id="connType" class="myui-text"/></li>
					<li class="tipli"><div id="connTypeTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="pim_host_remark"/>：</li>
					<li><textarea id="remark" name="remark" maxlength="80" class="myui-textarea" style="width:200px;">${obj.remark}</textarea></li>
					<li></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="button disablebutton" href="javascript:void(0);" onclick="testConnection();"><s:text name="pim_common_testconn"/></a>
		<a class="main_button" href="javascript:void(0);" onclick="sbt();"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin();" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>