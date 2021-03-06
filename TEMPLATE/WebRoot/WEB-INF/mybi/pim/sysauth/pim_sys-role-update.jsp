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
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param={
						"obj.id" : $("#id").val() ,
						"obj.nam" : $.trim($("#nam").val()) ,
				//		"obj.orgidt" : $.trim($("#orgidt").val()) ,
						"obj.assignable" : $('input[name="assignable"]:checked ').val() ,
						"obj.remark" : $.trim($("#remark").val())
				};
				add_onload();//开启蒙板层
				$.post("pim_sys-role!updateSysRoleObj.action",param,function(data){ 
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
		$("#nam").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'})//不能为空
		.functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "pim_sys-role!isSysRoleNamUnique.action?nam_tmp="+encodeURIComponent('${obj.nam}'),
			type : "POST",
			data: {nam:$("#nam").val()},
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
	/*	var temp_orgidt=null;
		$("#orgidt").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'})//不能为空
		.functionValidator({fun:isHasSpecialChar})
			.ajaxValidator({
				dataType : "text",
				url : "pim_org!isCdeorgOrgidtValid.action",
				type : "POST",
				data: {orgidt:$("#orgidt").val()},
				success : function(data){
					temp_orgidt=data;
					if (data == "noExist") {
						return '<s:text name="org_orgidt_noExist"/>';  //机构不存在
	                } else if (data == "noAuth") {
	                	return '<s:text name="org_orgidt_noAuth"/>';  //机构不在权限范围内
	                } else {  
	                    return true;  
	                }  
				},
				onError : function(val,dom){
					if (temp_orgidt == "noExist") {
						return '<s:text name="org_orgidt_noExist"/>';  //机构不存在
	                } else if (temp_orgidt == "noAuth") {
	                	return '<s:text name="org_orgidt_noAuth"/>';  //机构不在权限范围内
	                } 
				},
				onWait : '<s:text name="common_msg_formvalidte_validating"/>'//校验中
			});*/
		$("#remark").formValidator({onFocus:""}).inputValidator({max:80,onError:'<s:text name="common_msg_formvalidte_nomorethan"><s:param>80</s:param></s:text>'});//不能超过80字符
		if('${request.obj.assignable}' == '1') {
			$('#assignable_y').attr("checked","checked");
		}
	});
	
	//表单提交
	function sbt(){
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
	<div class="form">
		<form id="form_input" method="post">
			<input type="hidden" id="id" name="id"  value="${request.obj.id}"/>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysrole_nam"/>：</li>
					<li><input id="nam" name="nam" maxlength="30" value="${request.obj.nam}" class="myui-text"/></li>
					<li class="tipli"><div id="namTip"></div></li>
				</ul>
			 </div>
			 <!-- div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysrole_orgidt"/>：</li>
					<li><input id="orgidt" name="orgidt" maxlength="30" value="${request.obj.orgidt}" class="myui-text"/></li>
					<li class="tipli"><div id="orgidtTip"></div></li>
				</ul>
			 </div -->
			 <div class="item">
				<ul>
					<li class="desc">可再授权：</li>
					<li><input type="radio" id="assignable_y" value="1" name="assignable"/>&nbsp;是&nbsp;&nbsp;&nbsp;&nbsp;
					    <input type="radio" id="assignable_n" value="0" name="assignable" checked/>&nbsp;否
					</li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysrole_remark"/>：</li>
					<li><textarea id="remark" name="remark" maxlength="80" class="myui-textarea" style="width:200px;">${request.obj.remark}</textarea></li>
					<li class="tipli"><div id="remarkTip"></div></li>
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

