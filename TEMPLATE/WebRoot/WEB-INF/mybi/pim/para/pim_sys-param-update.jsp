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
		//参数类型combo
		$("#paramtypId").combo({
			mode:'local',
			valueField:'id',
			textField:'nam',
			data : ${request.paramtypList},
			defaultValue : '${request.obj.paramtypId}'
		});
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param={
						"obj.paramtypId" : $("#paramtypId").combo('getValue') ,	
						"obj.id" : $("#id").val() ,	
						"obj.pkey" : $.trim($("#pkey").val()) ,
						"obj.pval" : $.trim($("#pval").val()) ,
						"obj.pdesc" : $.trim($("#pdesc").val())
				};
				
				add_onload();//开启蒙板层
				$.post("pim_sys-param!updateSysParamObj.action",param,function(data){ 
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
		$("#pval").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
		$("#pdesc").formValidator({onFocus:""}).inputValidator({max:80,onError:'<s:text name="common_msg_formvalidte_nomorethan"><s:param>80</s:param></s:text>'});//不能超过80字符
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
			<input type="hidden" id="id" name="obj.id"  value="${request.obj.id}"/>
	        <input type="hidden" id="pkey" name="obj.pkey"  value="${request.obj.pkey}"/>
	        <div class="item">
				<ul>
					<li class="desc"><s:text name="sysparamtyp_nam"/>：</li>
					<li>
						<input id="paramtypId" style="width:200px"/>
					</li>
				</ul>
			 </div>
			 
	        <s:if test='#session.loginUserObj.id.equals("0")'>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysparam_pkey"/>：</li>
					<li>${request.obj.pkey}</li>
					<li></li>
				</ul>
			 </div>
			 </s:if>	
			
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysparam_pval"/>：</li>
					<li><input value="${request.obj.pval}" id="pval" name="obj.pval" maxlength="80" class="myui-text"/></li>
					<li class="tipli"><div id="pvalTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysparam_pdesc"/>：</li>
					<li><textarea id="pdesc" name="obj.pdesc" maxlength="80" class="myui-textarea"  style="width:200px">${request.obj.pdesc}</textarea></li>
					<li class="tipli"><div id="pdescTip"></div></li>
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

