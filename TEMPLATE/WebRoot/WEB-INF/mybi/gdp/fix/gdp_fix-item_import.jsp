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
<style type="text/css">
.myui-file{
	line-height:22px;
	height:22px;
	border:1px solid #D2D2D2;
	background-color:#FBFBFB;
	width:113px;
	color:#A0A0A0;
	font-style:italic;
	cursor:pointer;
	font-size:12px;
	vertical-align:middle;
}
.gdp-btn-small {
	vertical-align:middle;
	color:#727272;
	margin-left:3px;
	border: 1px solid #dbdbdb;
	background-color:#FBFBFB;
	font-size:11px;
	padding:4px 8px;
	font-family:微软雅黑,黑体;
	cursor: pointer;
}
.gdp-btn-small:HOVER{
	color:#fe710a;
}
</style>
<script type="text/javascript">
	var fileTypeValid = true; // 文件类型验证结果;
	$(function(){
		// 初始化页面元素及表单验证
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		// 表单验证初始化
		$.formValidator.initConfig({formID:"form_input",
			onError:function(msg){$.messager.alert('提示',msg,'info');},
			onSuccess:function(){
				var path = $("#fileText").val();
				if (path == "") {
					// 提示请选择要上传的数据文件
					$.messager.alert("提示","<s:text name='gdp_upload_pleaseSelectFile'/>","info");
					return;
				}
				if (!fileTypeValid) {
					// 文件格式不正确的提示;
					$.messager.alert("提示","<s:text name='gdp_upload_wrongFileFormat'/>","info");
					return;
				}
				add_onload();// 开启蒙板层
				/*
				$.post("${ctx}/gdp_upload!checkCendatUnique.action",paramObj,function(data){
					clean_onload();
					if (data.isExist) {
						$.messager.alert("<s:text name='common_msg_info'/>","<s:text name='gdp_upload_existCendat'/>","info");
						return;
					}else {
						add_onload();*/
						$.ajaxFileUpload({
							url : "gdp_fix-item!importItems.action", // 用于文件上传的服务器端请求地址
							secureuri : false, // 一般设置为false
				            fileElementId : 'dataImp', // 文件上传DOM元素的id属性
				            dataType : 'text/json', // 返回值类型 一般设置为json
				            success : function(data, status){ // 服务器成功响应处理函数
				            	// 关闭蒙板层;
				            	clean_onload();
				            	if (data.result == "succ") {
				            		parent.cx(1);//回显;
				            		// 操作成功提示信息;
				            		$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='common_msg_succ'/>", 'info',clsWin);
				            	}else {
				            		$.messager.alert('<s:text name="common_msg_info"/>', data.msg, 'info');
				            	}
				            }
						});
					/*}
				},"json");*/
			}
		});
	}
	
	// 选择文件事件
	function fileOnChange(target) {
		// 获取文件路径
		var path = $(target).val();
		// 将文件路径赋给文件文本框
		$("#fileText").val(path);
		// 获取文件类型
		var fileType = path.substring(path.lastIndexOf(".") + 1, path.length);
		// 文件类型验证
		if (fileType.toUpperCase() != "XLS" && fileType.toUpperCase() != "XLSX") {
			fileTypeValid = false;
		}else {
			fileTypevalid = true;
		}
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
					<!-- 数据文件 -->
					<li class="desc"><b>* </b>文件：</li>
					<li>
						<input id="fileText" class="myui-fileupload-text" type="text" readonly="readonly"/>
						<span class="myui-fileupload-wrap" style="position:relative;display:inline-block">
							<a id="fileScan" href="javascript:void(0)" class="myui-fileupload-btn" style="position:absolute;z-index:0"><s:text name="gdp_upload_browse"/></a><input type="file" id="dataImp" name="dataImp" onchange="fileOnChange(this)" style="width:43px;height:22px;cursor: pointer;vertical-align:middle;position:absolute;opacity: 0;filter: alpha(opacity=0);"/>
						</span>
					</li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<!-- 提交 -->
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<!-- 取消 -->
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>
