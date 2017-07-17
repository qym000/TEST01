<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"	rel="stylesheet" type="text/css" />
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/ajaxfileupload/ajaxfileupload.js"></script>
<script type="text/javascript">
	function upload(){
		if($("#install_pkg").val() == null || $("#install_pkg").val() == "") {
			$.messager.alert("提示", "请选择安装包文件", "info");
			return false;
		}
		
		add_onload();
		$.ajaxFileUpload({
            url:'vm_version!uploadUpdPkgFile.action?obj.code=${obj.code}',//用于文件上传的服务器端请求地址
            secureuri:false,//一般设置为false
            fileElementId:'install_pkg',//文件上传空间的id属性  <input type="file" id="file" name="file" />
            dataType: 'text/json',//返回值类型 一般设置为json
            success: function (data, status){
            	if(data.result == "succ"){
            		parent.$("#updbtn").attr("code", "${obj.code}");
            		parent.compareResult(data.resultMap);
            		clsWin();
            	}else{
            		clean_onload();
            		$.messager.alert("提示", data.result, "info");
            	}
            },
            onUploadError : function(data, status, e){
            	$.messager.alert("提示", data.result, "info");
        	}
        });
	}
	
	function clsWin(){
		parent.$("#inputWin").window("close");
	}
</script>
</head>
<body>
	<div class="myui-form">
		<div class="form">
			<form id="form_input" method="post">
				 <div class="item">
					<ul>
						<li class="desc">安装包：</li>
						<li><input id="install_pkg" name="install_pkg" type="file" /></li>
						<li class="tipli"><div id="install_pkgTip"></div></li>
					</ul>
				 </div>
			 </form>
		</div>
		<div class="operate">
			<a class="main_button" href="javascript:void(0);" onclick="upload()">提交</a>
			<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">取消</a>
		</div>
	</div>
</body>
</html>