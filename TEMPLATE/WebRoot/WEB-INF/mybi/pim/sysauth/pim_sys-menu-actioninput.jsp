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
		//动作类型：
		$("#isdevuse2").combo({
			mode:'local',
			valueField:'value',
			textField:'text',
			panelHeight:60,
			data:[{value:'0',text:'<s:text name="sysauth_sysAction_typ_common"/>'},//一般动作
			      {value:'2',text:'<s:text name="sysauth_sysAction_typ_default"/>'},//默认
			      {value:'1',text:'<s:text name="sysauth_sysAction_typ_devuse"/>'}//开发专用
			      ]
		});
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(msg){$.messager.alert('<s:text name="common_msg_info"/>',msg,'info');},
			onSuccess:function(){
				var param="actionObj.menuId="+$("#menuId").val();
				param+="&actionObj.code="+$.trim($("#code").val());
				param+="&actionObj.nam="+$.trim($("#nam").val());
				param+="&actionObj.namEg="+$.trim($("#namEg").val());
				param+="&actionObj.url="+$.trim($("#url").val());
				var isdevuse=$("#isdevuse2").combo('getValue');
				param+="&actionObj.isdevuse="+isdevuse;
				param+="&actionObj.ord="+$.trim($("#ord").val());
				add_onload();//开启蒙板层
				$.post("pim_sys-menu!saveSysActionObj.action",param,function(data){ 
					if(data.result=="succ"){
						parent.findDataBySysMenuId('${sysMenu.id}');	//回显刚才操作的记录
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',function(){
							clsWin();
						});
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
					}
					
					clean_onload();//关闭蒙板层
			    },"json");
			}
		});
		$("#code").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="sysauth_sysAction_code"/><s:text name="common_msg_formvalidte_required"/>'})//编码不能为空
		.ajaxValidator({
			dataType : "text",
			url : "pim_sys-menu!isSysActionCodeUnique.action",
			type : "POST",
			data: {},
			success : function(data){
				if (data == "false") {
					return '<s:text name="sysauth_sysAction_code"/><s:text name="common_msg_formvalidte_alreadyexist"/>';  //编码已经存在
                } else {  
                    return true;  
                }  
			},
			onError : '<s:text name="sysauth_sysAction_code"/><s:text name="common_msg_formvalidte_alreadyexist"/>',//编码已经存在
			onWait : '<s:text name="common_msg_formvalidte_validating"/>'//校验中
		});
		
		$("#nam").formValidator({onFocus:""}).inputValidator({min:1,onErrorMin:'<s:text name="sysauth_sysAction_nam2"/><s:text name="common_msg_formvalidte_required"/>'});//动作名称不能为空
		$("#namEg").formValidator({onFocus:""}).inputValidator({min:1,onErrorMin:'<s:text name="sysauth_sysAction_namEg"/><s:text name="common_msg_formvalidte_required"/>'});//英文名称不能为空
		$("#url").formValidator({onFocus:""}).inputValidator({max:500,onError:'<s:text name="common_msg_formvalidte_nomorethan"><s:param>500</s:param></s:text>'});//不能超过500字符
		$("#ord").formValidator({onFocus:""}).regexValidator({regExp:"intege1",dataType:"enum",onError:'<s:text name="sysauth_sysAction_ord"/><s:text name="common_msg_formvalidte_onlyinteger"/>'});//排序只能输入正整数
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
			 <input type="hidden" id="menuId" name="menuId" value="${sysMenu.id}"> 
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysMenu"/>：</li>
					<li style="width:200px;">
						<s:if test='#session.i18nDefault.equals("en")'>
							${sysMenu.namEg}
						</s:if><s:else>
							${sysMenu.nam}
						</s:else>
					</li>
				</ul>
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysAction_code"/>：</li>
					<li><input id="code" name="code" maxlength="50" value="" class="myui-text" style="width:200px;"/></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysAction_nam2"/>：</li>
					<li><input id="nam" name="nam" maxlength="20" value="" class="myui-text" style="width:200px;"/></li>
				</ul>
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysAction_namEg"/>：</li>
					<li><input id="namEg" name="namEg" maxlength="30" value="" class="myui-text" style="width:200px;"/></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc">URL：</li>
					<li><textarea id="url" name="url" class="myui-textarea" style="width:506px;height:50px;"></textarea></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysAction_typ"/>：</li>
					<li><input id="isdevuse2" name="isdevuse2" style="width:200px;"/></li>
				</ul>
				<ul>
					<li class="desc"><s:text name="sysauth_sysAction_ord"/>：</li>
					<li><input id="ord" name="ord" maxlength="3" value="9" class="myui-text" style="width:200px;"/></li>
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

