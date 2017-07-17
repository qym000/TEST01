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
				var baklog = $.trim($("#baklog").val());
				parent.bakup("${obj.id}", "${obj.code}", baklog);
			}
		});
		$("#baklog").formValidator({onFocus:""}).inputValidator({min:1,onError:'不能为空'}).inputValidator({max:200,onError:'不能超过200个字符'});
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
					<li class="desc">备份路径：</li>
					<li>${bakpath}</li>
					<li class="tipli"><div id="bakpathTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>*</b>备份日志：</li>
					<li><textarea id="baklog" name="baklog" maxlength="80" class="myui-textarea" style="width:230px;"></textarea></li>
					<li class="tipli"><div id="baklogTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()">备份</a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">关闭</a>
	</div>
</div>
</body>
</html>