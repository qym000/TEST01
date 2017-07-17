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
					"pim_jdbc.ip":$.trim($("#ip").val()),
					"pim_jdbc.port":$.trim($("#port").val()),
					"pim_jdbc.sid":$.trim($("#sid").val()),
					"pim_jdbc.username":$.trim($("#username").val()),
					"pim_jdbc.password":$.trim($("#password").val()),
					"pim_jdbc.remark":$.trim($("#remark").val())
				};
				$.post("pim_jdbc!saveJdbcObj.action", param, function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);//回显刚才操作的记录
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
					}
					clean_onload();//关闭蒙板层
			    },"json");
			}
		});
		
		$("#ip").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#port").formValidator({onFocus:""}).regexValidator({regExp:"intege1",dataType:"enum",onError:'<s:text name="common_msg_formvalidte_onlyinteger"/>'});//只能输入正整数
		$("#sid").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#username").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#password").formValidator({onFocus:""}).inputValidator({min:1, onError:"<s:text name='common_msg_formvalidte_required'/>"});
		$("#remark").formValidator({onFocus:""}).inputValidator({max:100,onError:'<s:text name="common_msg_formvalidte_nomorethan"><s:param>100</s:param></s:text>'});//不能超过100字符
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
			"pim_jdbc.ip":$.trim($("#ip").val()),
			"pim_jdbc.port":$.trim($("#port").val()),
			"pim_jdbc.sid":$.trim($("#sid").val()),
			"pim_jdbc.username":$.trim($("#username").val()),
			"pim_jdbc.password":$.trim($("#password").val())
		};
		
		 if(param["pim_jdbc.ip"] == "" || param["pim_jdbc.port"] == "" || param["pim_jdbc.sid"] == "" || param["pim_jdbc.username"] == "" || param["pim_jdbc.password"] == ""){
			 return;
		 }
		 
		 add_onload();
		 $.getJSON("pim_jdbc!testJDBCConnection.action", param, function(data){
			if(data.info == "succ"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="pim_common_testconn_succ"/>','info');
			}else if(data.info == "unknown_sid"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="pim_common_unknown_sid"/>','info');
			}else if(data.info == "invalid_user_pwd"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="pim_common_unknown_invalid_user_pwd"/>','info');
			}else if(data.info == "ioexpcetion"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="pim_common_io_exception"/>','info');
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
			 <div class="item">
				<ul>
					<li class="desc" style="width:120px;"><b>*</b><s:text name="pim_jdbc_serverip"/>：</li>
					<li><input id="ip" name="ip" maxlength="15" class="myui-text"/></li>
					<li class="tipli"><div id="ipTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc" style="width:120px;"><b>*</b><s:text name="pim_jdbc_serverport"/>：</li>
					<li><input id="port" name="port" maxlength="5" class="myui-text" value="1521"/></li>
					<li class="tipli"><div id="portTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc" style="width:120px;"><b>*</b><s:text name="pim_jdbc_oraclesid"/>：</li>
					<li><input id="sid" name="sid" maxlength="50" class="myui-text"/></li>
					<li class="tipli"><div id="sidTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc" style="width:120px;"><b>*</b><s:text name="pim_jdbc_oracleusername"/>：</li>
					<li><input id="username" name="username" maxlength="10" class="myui-text"/></li>
					<li class="tipli"><div id="usernameTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc" style="width:120px;"><b>*</b><s:text name="pim_jdbc_oraclepassword"/>：</li>
					<li><input id="password"  type="password" name="password" maxlength="10" class="myui-text"/></li>
					<li class="tipli"><div id="passwordTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc" style="width:120px;"><s:text name="pim_jdbc_oracleremark"/>：</li>
					<li><textarea id="remark" name="remark" class="myui-textarea" style="width:200px;"></textarea></li>
					<li class="tipli"><div id="remarkTip"></div></li>
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