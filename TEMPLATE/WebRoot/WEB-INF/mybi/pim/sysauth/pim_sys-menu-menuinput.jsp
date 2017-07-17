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
		//是否开发专用combo
		$("#isdevuse2").combo({
			mode:'local',
			valueField:'value',
			textField:'text',
			panelHeight:60,
			data:[{value:'0',text:'<s:text name="common_option_no"/>'},{value:'1',text:'<s:text name="common_option_yes"/>'}]
		});
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param="menuObj.pid="+$("#pid").val();
				param+="&menuObj.id="+$.trim($("#id").val());
				param+="&menuObj.nam="+$.trim($("#nam").val());
				param+="&menuObj.namEg="+$.trim($("#namEg").val());
				param+="&menuObj.url="+$.trim($("#url").val());
				param+="&menuObj.actcls="+$.trim($("#actcls").val());
				var isdevuse=$("#isdevuse2").combo('getValue');
				param+="&menuObj.isdevuse="+isdevuse;
				param+="&menuObj.ord="+$.trim($("#ord").val());
				add_onload();//开启蒙板层
				$.post("pim_sys-menu!saveSysMenuObj.action",param,function(data){ 
					if(data.result=="succ"){
						//parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',function(){
							parent.reloadSelfTree();
							clsWin();
						});
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
					}
					
					clean_onload();//关闭蒙板层
			    },"json");
				
			}
		});
		$("#nam").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});//不能为空
		$("#namEg").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});//不能为空
		$("#ord").formValidator({onFocus:""}).regexValidator({regExp:"intege1",dataType:"enum",onError:'<s:text name="common_msg_formvalidte_onlyinteger"/>'});//只能输入正整数
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
			 <input type="hidden" id="pid" name="pid" value="${pid}"> 
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysMenu_pMenu"/>：</li>
					<s:if test='#session.i18nDefault.equals("en")'>
					<li>${pSysMenu.namEg}</li>
					</s:if><s:else>
					<li>${pSysMenu.nam}</li>
					</s:else>
					<li></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysMenu_nam2"/>：</li>
					<li><input id="nam" name="nam" maxlength="20" value="" class="myui-text" style="width:200px;"/></li>
					<li class="tipli"><div id="namTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="sysauth_sysMenu_namEg"/>：</li>
					<li><input id="namEg" name="namEg" maxlength="30" value="" class="myui-text" style="width:200px;"/></li>
					<li class="tipli"><div id="namEgTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc">URL：</li>
					<li><input id="url" name="url" maxlength="300" value="" class="myui-text" style="width:200px;"/></li>
					<li class="tipli"><div id="orgidtTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysMenu_relation"/> Action：</li>
					<li><input id="actcls" name="actcls" maxlength="300" value="" class="myui-text" style="width:200px;"/></li>
					<li class="tipli"><div id="actclsTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysMenu_isdevuse"/>：</li>
					<li><input id="isdevuse2" name="isdevuse2" style="width:200px;"/></li>
					<li class="tipli"><div id="isdevuse2Tip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysMenu_ord"/>：</li>
					<li><input id="ord" name="ord" maxlength="3" value="9" class="myui-text" style="width:200px;"/></li>
					<li class="tipli"><div id="ordTip"></div></li>
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

