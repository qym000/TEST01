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
		$("#orgidt").inputbox({
			  autocomplete : true,
			  acMode : 'remote',
			  acUrl : 'pim_org!findOrgListWithoutAuth.action',
			  textField : 'orgidtAndOrgnam',
				valueField : 'orgidt',
				acPanelWidth : 300,
		    panelHeight : 150,
			  onLoadSuccess : function(data) {
			  	$(this).inputbox("setText", $(this).inputbox("getTextByValue", "${request.obj.orgidt}"));
		  	}
		});
		 
		//密码重置combo
	/*	$("#resetPasswd").combo({
			mode:'local',
			valueField:'value',
			textField:'text',
			panelHeight:'30px',
			data : [{value:'0',text:'<s:text name="common_option_no"/>'},{value:'1',text:'<s:text name="common_option_yes"/>'}]
		});*/
		//解锁combo
		$("#unlck").combo({
			mode:'local',
			valueField:'value',
			textField:'text',
			panelHeight:'30px',
			data : [{value:'0',text:'<s:text name="common_option_no"/>'},{value:'1',text:'<s:text name="common_option_yes"/>'}]
		});
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param=$("#form_input").serialize();
				param+="&obj.id="+$("#id").val();
				param+="&obj.logid="+$.trim($("#logid").val());
				param+="&obj.nam="+$.trim($("#nam").val());
				param+="&obj.phonenum="+$.trim($("#phonenum").val());
				param+="&obj.email="+$.trim($("#email").val());
				param+="&obj.orgidt="+$.trim($("#orgidt").inputbox("getValueByText", $("#orgidt").val()));
				param+="&obj.remark="+$.trim($("#remark").val());
				param+="&obj.stat="+$("#stat").combo('getValue');
			//	param+="&resetPasswd="+$("#resetPasswd").combo('getValue');
				param+="&resetPasswd=0";
				param+="&unlck="+$("#unlck").combo('getValue');
				add_onload();//开启蒙板层
				$.post("pim_sys-user!updateSysUserObj.action",param,function(data){ 
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
		$("#logid").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'}).functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "pim_sys-user!isSysUserLogidUnique.action?logid_tmp="+encodeURIComponent('${obj.logid}'),
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
				url : "pim_sys-user!isSysUserIpBindUnique.action?ipBind_tmp=${obj.ipBind}",
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
	/*	$("#orgidt").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'}).functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "pim_org!isCdeorgOrgidtValid.action",
			type : "POST",
			data: {orgidt:$("#orgidt").inputbox("getValueByText", $("#orgidt").val())},
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
			 <input type="hidden" id="id" name="id"  value="${request.obj.id}"/>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysuser_logid"/>：</li>
					<li><input id="logid" name="logid" maxlength="32" value="${request.obj.logid}" class="myui-text"/></li>
					<li class="tipli"><div id="logidTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysuser_nam"/>：</li>
					<li><input id="nam" name="nam" maxlength="100" value="${request.obj.nam}" class="myui-text"/></li>
					<li class="tipli"><div id="namTip"></div></li>
				</ul>
			 </div>
			 <!-- div class="item">
				<ul>
					<li class="desc"><s:text name="common_action_resetPasswd"/>：</li>
					<li>
						<input id="resetPasswd" style="width:200px"/>
					</li>
				</ul>
			 </div -->
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
					<li><input id="phonenum" name="phonenum" maxlength="20" value="${request.obj.phonenum}" class="myui-text"/></li>
					<li class="tipli"><div id="phonenumTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_email"/>：</li>
					<li><input id="email" name="email" maxlength="80" value="${request.obj.email}" class="myui-text"/></li>
					<li class="tipli"><div id="emailTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_stat"/>：</li>
					<li>
						<s:if test='#request.obj.stat=="1"'>
						<input id="stat" style="width:200px" class="myui-combo" myui-options="mode:'local',panelHeight:'50',data:[{value:'1',text:'有效'},{value:'0',text:'无效'}]"/>
						</s:if><s:elseif test='#request.obj.stat=="0"'>
						<input id="stat" style="width:200px" class="myui-combo" myui-options="mode:'local',panelHeight:'50',data:[{value:'0',text:'无效'},{value:'1',text:'有效'}]"/>
						</s:elseif><s:elseif test='#request.obj.stat=="2"'>
						<input id="stat" style="width:200px" class="myui-combo" myui-options="mode:'local',panelHeight:'50',data:[{value:'2',text:'锁定'}]"/>
						</s:elseif><s:elseif test='#request.obj.stat=="3"'>
						<input id="stat" style="width:200px" class="myui-combo" myui-options="mode:'local',panelHeight:'50',data:[{value:'2',text:'密码过期'}]"/>
						</s:elseif>
					</li>
				</ul>
			 </div>
			 <div class="item" <s:if test='#request.obj.stat=="2"'>style="display:''"</s:if><s:else>style="display:none"</s:else>>
				<ul>
					<li class="desc"><s:text name="common_action_unlck"/>：</li>
					<li>
						<input id="unlck" style="width:200px"/>
					</li>
				</ul>
			 </div>
			 
			 <s:iterator value="%{#request.sysUserColConfigList}" id="o">
			 	<s:if test='#o.isExtend=="1" || #o.isExtend=="3"'>
			 		<div class="item">
						<ul>
							<li class="desc">
								<s:if test='#session.i18nDefault=="en"'>
									${o.colnamEn}&nbsp;&nbsp;
								</s:if><s:else>
									${o.colnamCh}&nbsp;&nbsp;
								</s:else>
							</li>
							<li>
								<input id="${o.prop}" name="obj.${o.prop}" maxlength="${o.maxlen}" class="myui-text"
		    						<s:if test='#o.prop=="ipBind"'>
										value="${request.obj.ipBind}"
									</s:if><s:elseif test='#o.prop=="property1"'>
										value="${request.obj.property1}"
									</s:elseif><s:elseif test='#o.prop=="property2"'>
										value="${request.obj.property2}"
									</s:elseif><s:elseif test='#o.prop=="property3"'>
										value="${request.obj.property3}"
									</s:elseif><s:elseif test='#o.prop=="property4"'>
										value="${request.obj.property4}"
									</s:elseif><s:elseif test='#o.prop=="property5"'>
										value="${request.obj.property5}"
									</s:elseif><s:elseif test='#o.prop=="property6"'>
										value="${request.obj.property6}"
									</s:elseif><s:elseif test='#o.prop=="property7"'>
										value="${request.obj.property7}"
									</s:elseif><s:elseif test='#o.prop=="property8"'>
										value="${request.obj.property8}"
									</s:elseif><s:elseif test='#o.prop=="property9"'>
										value="${request.obj.property9}"
									</s:elseif><s:elseif test='#o.prop=="property10"'>
										value="${request.obj.property10}"
									</s:elseif><s:elseif test='#o.prop=="property11"'>
										value="${request.obj.property11}"
									</s:elseif><s:elseif test='#o.prop=="property12"'>
										value="${request.obj.property12}"
									</s:elseif><s:elseif test='#o.prop=="property13"'>
										value="${request.obj.property13}"
									</s:elseif><s:elseif test='#o.prop=="property14"'>
										value="${request.obj.property14}"
									</s:elseif><s:elseif test='#o.prop=="property15"'>
										value="${request.obj.property15}"
									</s:elseif><s:elseif test='#o.prop=="property16"'>
										value="${request.obj.property16}"
									</s:elseif><s:elseif test='#o.prop=="property17"'>
										value="${request.obj.property17}"
									</s:elseif><s:elseif test='#o.prop=="property18"'>
										value="${request.obj.property18}"
									</s:elseif><s:elseif test='#o.prop=="property19"'>
										value="${request.obj.property19}"
									</s:elseif><s:elseif test='#o.prop=="property20"'>
										value="${request.obj.property20}"
									</s:elseif><s:elseif test='#o.prop=="property21"'>
										value="${request.obj.property21}"
									</s:elseif><s:elseif test='#o.prop=="property22"'>
										value="${request.obj.property22}"
									</s:elseif><s:elseif test='#o.prop=="property23"'>
										value="${request.obj.property23}"
									</s:elseif><s:elseif test='#o.prop=="property24"'>
										value="${request.obj.property24}"
									</s:elseif><s:elseif test='#o.prop=="property25"'>
										value="${request.obj.property25}"
									</s:elseif><s:elseif test='#o.prop=="property26"'>
										value="${request.obj.property26}"
									</s:elseif><s:elseif test='#o.prop=="property27"'>
										value="${request.obj.property27}"
									</s:elseif><s:elseif test='#o.prop=="property28"'>
										value="${request.obj.property28}"
									</s:elseif><s:elseif test='#o.prop=="property29"'>
										value="${request.obj.property29}"
									</s:elseif><s:elseif test='#o.prop=="property30"'>
										value="${request.obj.property30}"
									</s:elseif>
									
		    					/>
							</li>
							<li class="tipli"><div id="${o.prop}Tip"></div></li>
						</ul>
					 </div>
			 	</s:if>
			 </s:iterator>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_remark"/>：</li>
					<li><textarea id="remark" name="remark" maxlength="80" class="myui-textarea" style="width:200px;height:50px;">${request.obj.remark}</textarea></li>
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

