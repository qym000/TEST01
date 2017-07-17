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
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	var awkSrc = ${request.awkScript};
	$(function(){
		// 初始化页面元素及表单验证
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		$("#awkScript").val(awkSrc.content);
		$("body").unbind();
		// 表单验证初始化
		$.formValidator.initConfig({formID:"form_input",mode:"AlertTip",
			onError:function(msg){$.messager.alert('提示',msg,'info');},
			onSuccess:function(){
				// 参数对象
				var paramObj = {
					id : parent.schemeId,
					awkScriptFileName : awkSrc.fileName,
					scriptContent : $.trim($("#awkScript").val())
				};
				// 开启蒙板层
				add_onload();
				$.post("${ctx}/gdp_scheme-erms!saveAwkFile.action",paramObj,function(data){ 
					// 关闭蒙板层
					clean_onload();
					if(data.result=="succ"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="gdp_common_saveSucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="gdp_common_saveFail"/>','info');
					}
			    },"json");
			}
		});
		// Awk脚本命令不能为空
		$("#awkScript").formValidator().inputValidator({min:1,onError:"AWK脚本命令不能为空"});
	}
	
	// 表单提交
	function sbt(){
		$("#form_input").submit();
	}
	
	// 关闭当前窗口
    function clsWin(){
    	parent.$("#inputWin").window('close');
    }
	
</script>
</head>
<body>

<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<!-- AWK脚本 -->
					<li class="desc" style="width:120px;">AWK脚本：</li>
					<li><textarea id="awkScript" name="awkScript" class="myui-textarea" wrap="off" style="width:500px;height:400px;font-family:Courier New;overflow:scroll;"></textarea></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<!-- 保存 -->
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="gdp_common_save"/></a>
		<!-- 取消 -->
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>
