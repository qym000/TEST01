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
  var orgval; 
	$(function(){
		$("#orgidt").inputbox({
			  autocomplete : true,
			  acMode : 'remote',
			  acUrl : 'pim_org!findOrgListWithoutAuth.action',
			  textField : 'orgidtAndOrgnam',
				valueField : 'orgidt',
				acPanelWidth : 300,
		    panelHeight : 150
		});
		
		
	/*	$("#orgidt").bind('propertychange', function(){
			alert( $("#orgidt").inputbox('getValue'));
			orgval = $("#orgidt").inputbox('getValue');
		})*/
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param=$("#form_input").serialize();
				param+="&obj.id="+$.trim($("#logid").val());
				param+="&obj.logid="+$.trim($("#logid").val());
				param+="&obj.nam="+$.trim($("#nam").val());
				param+="&obj.phonenum="+$.trim($("#phonenum").val());
				param+="&obj.email="+$.trim($("#email").val());
				param+="&obj.orgidt="+$.trim($("#orgidt").inputbox("getValueByText", $("#orgidt").val()));
				param+="&obj.remark="+$.trim($("#remark").val());
				add_onload();//开启蒙板层
				$.post("pim_sys-user!saveSysUserObj.action",param,function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
					}
				clean_onload();//关闭蒙板层
			    },"json");
				
			}
		});
		$("#logid").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'}) //不能为空
		.functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "pim_sys-user!isSysUserLogidUnique.action",
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
		$("input[name='obj.ipBind']").formValidator({onFocus:""}).ajaxValidator({
				dataType : "text",
				url : "pim_sys-user!isSysUserIpBindUnique.action",
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
		var temp_orgidt=null;
	/*	$("#orgidt").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'})
		.functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "pim_org!isCdeorgOrgidtValid.action",
			type : "POST",
			data: {orgidt: orgval},
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
		$("#orgidt").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'}) //非空验证
	//	.functionValidator({fun:isHasSpecialChar}) // 特殊字符验证
		.functionValidator({fun : function(val){ // 远程验证机构存在和权限
			var result = null;
			var org = $("#orgidt").inputbox("getValueByText", $("#orgidt").val());
			if (org == null || org == "") {
				// 在机构联想控件数据中未找到机构则直接返回机构不存在
				return '<s:text name="org_orgidt_noExist"/>';
			}
			// 远程验证机构
			$.ajax({
				url : "pim_org!isCdeorgOrgidtValid.action",
				type : "post",
				data : {orgidt : org},
				dataType : "json",
				async : false,  //需关闭异步，保证结果返回前不会继续执行验证代码
				success : function(data) {
					 result = data;
				}
			});
			// 判断返回的结果显示对应的校验信息
			if (result == "noExist") {
				return '<s:text name="org_orgidt_noExist"/>';  //机构不存在
            } else if (result == "noAuth") {
            	return '<s:text name="org_orgidt_noAuth"/>';  //机构不在权限范围内
            } else {  
                return true;  // 正确机构无误直接通过验证
            } 
		}});
		$("#nam").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'})//不能为空
		$("#remark").formValidator({onFocus:""}).inputValidator({max:80,onError:'<s:text name="common_msg_formvalidte_nomorethan"><s:param>80</s:param></s:text>'});//不能超过80字符
		$("#email").formValidator({empty:true,onFocus:""}).regexValidator({regExp: "^([\\w-.]+)@(([[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.)|(([\\w-]+.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(]?)$", onError: '<s:text name="common_msg_formvalidte_formatnotright"/>'});//格式不正确
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
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysuser_logid"/>：</li>
					<li><input id="logid" name="logid" maxlength="32" class="myui-text"/></li>
					<li class="tipli"><div id="logidTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysuser_nam"/>：</li>
					<li><input id="nam" name="nam" maxlength="100" class="myui-text"/></li>
					<li class="tipli"><div id="namTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_passwd"/>：</li>
					<li><s:text name="common_msg_default"/>“${request.defaultpassword}”</li>
					<li class="tipli"><div id="passwdTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="org"/>：</li>
					<li><input id="orgidt" name="orgidt" maxlength="30" class="myui-text"/></li>
					<li class="tipli"><div id="orgidtTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_phonenum"/>：</li>
					<li><input id="phonenum" name="phonenum" maxlength="20" class="myui-text"/></li>
					<li class="tipli"><div id="phonenumTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_email"/>：</li>
					<li><input id="email" name="email" maxlength="80" class="myui-text"/></li>
					<li class="tipli"><div id="emailTip"></div></li>
				</ul>
			 </div>
			 <s:iterator value="%{#request.sysUserColConfigList}" id="o">
				 <s:if test='#o.isExtend=="1" || #o.isExtend=="3"'>
				 	<div class="item">
						<ul>
							<li class="desc">
								<s:if test='#session.i18nDefault=="en"'>
									${o.colnamEn}：
								</s:if><s:else>
									${o.colnamCh}：
								</s:else>
							</li>
							<li><input id="${o.prop}" name="obj.${o.prop}" maxlength="${o.maxlen}" class="myui-text"/></li>
							<li class="tipli"><div id="${o.prop}Tip"></div></li>
						</ul>
					 </div>
				 </s:if>
			 </s:iterator>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_remark"/>：</li>
					<li><textarea id="remark" name="remark" maxlength="80" class="myui-textarea" style="width:200px;height:50px;"></textarea></li>
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

