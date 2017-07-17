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
		
		var workspace = $.trim(parent.$("#workspace").val());
		var param = {
			"obj.workspace" : workspace
		};
		
		add_onload();
		$.ajaxFileUpload({
            url:'vm_version!componentRegeidtInstall.action?' + $.param(param),//用于文件上传的服务器端请求地址
            secureuri:false,//一般设置为false
            fileElementId:'install_pkg',//文件上传空间的id属性  <input type="file" id="file" name="file" />
            dataType: 'text/json',//返回值类型 一般设置为json
            success: function (data, status){
            	if(data.result == "succ"){
            		parent.chkVersion();
            		$.messager.alert("提示", "注册成功", "info", clsWin);
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
	
	/**
	 * 校验组件是否是否符合规范或者已经注册
	 */
	function chkComponent(){
		var install_pkg = $("#install_pkg").val();
		var filename = "";
		if(install_pkg != null && install_pkg != ""){
			filename = install_pkg.substring(install_pkg.lastIndexOf("\\") + 1);
		}
		var patt1 = new RegExp(/^mybi-([a-z]{2,10})-setup.zip$/);
		if(!patt1.test(filename)){
			$.messager.alert("提示", "安装包不符合规范，应为mybi-xxx-setup.zip", "info", function(){
				$("#install_pkg").val("");
			});
		}else{
			var code = filename.split("-")[1];
			parent.$("#databody tr").each(function(){
				var id = $(this).find("td:eq(0)").attr("id");
				if(code == id || (id + "web") == code){
					$.messager.alert("提示", "该组件已注册", "info");
					$("#install_pkg").val("");
				}
			});
			
		}
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
						<li><input id="install_pkg" name="install_pkg" type="file" onchange="chkComponent();"/></li>
						<li class="tipli"><div id="install_pkgTip"></div></li>
					</ul>
				 </div>
			 </form>
		</div>
		<div class="operate">
			<a class="main_button" href="javascript:void(0);" onclick="upload()">开始安装</a>
			<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">取消</a>
		</div>
	</div>
</body>
</html>