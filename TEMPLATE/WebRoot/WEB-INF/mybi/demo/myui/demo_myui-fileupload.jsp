<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title></title>
<link href="${ctx}/mybi/common/scripts/syntaxHighlighter/styles/shCoreEclipse.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"	rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/demo/themes/${apptheme}/demo-myui.css"	rel="stylesheet" type="text/css" />
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shCore.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJScript.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJava.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	$(function() {
		initDemo();
	    SyntaxHighlighter.all();
	});
	
	function initDemo() {
		$("#fileText").fileupload({
			url : "demo_myui!uploadMyFile.action", // 上传文件的请求路径
			fileElementId : "my", // 上传文件的ID
			secureuri : false, // 安全路径,防止浏览器阻止javascript脚本
			dataType : "text", // 请求返回的数据类型
			fileSize : 1024*1024*1024, // 上传文件大小限制,默认1G
			fileType : ["xls","xlsx","csv","txt"], // 允许文件的类型,数组表示,不区分大小写,如["xls","xlsx"]
			timeout : 30000, // 超时时间设定,单位毫秒
			showProgress : true, // 是否显示进度条
			onUploadSuccess : function(data,status){
				$.messager.alert("提示","上传成功了：" + status , "info");
			}, // 上传完成后回调函数,返回的数据和状态
			onUploadError : function(data,status,e){
				$.messager.alert("提示","上传失败了：" + status, "info");
			} // 上传失败回调;
		});			
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-fileupload效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input id="fileText"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-fileupload使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
/**
 * JavaScript代码
 */
$("#fileText").fileupload({
	url : "demo_myui!uploadMyFile.action", // 上传文件的请求路径
	fileElementId : "my", // 上传文件的ID
	secureuri : false, // 安全路径,防止浏览器阻止javascript脚本
	dataType : "text", // 请求返回的数据类型
	fileSize : 1024*1024*1024, // 上传文件大小限制,默认1G
	fileType : ["xls","xlsx","csv","txt"], // 允许文件的类型,数组表示,不区分大小写,如["xls","xlsx"]
	timeout : 30000, // 超时时间设定,单位毫秒
	showProgress : true, // 是否显示进度条
	onUploadSuccess : function(data,status){
		$.messager.alert("上传成功了：" + status);
	}, // 上传完成后回调函数,返回的数据和状态
	onUploadError : function(data,status,e){
		$.messager.alert("上传失败了：" + status);
	} // 上传失败回调;
});		
</pre>
<pre class="brush: java">
/**
 * Java代码
 */
private File my; // 我的文件
private String myFileName; // 文件名称
private String myContentType; // 文件类型

/**
 * 上传文件的请求ACTION方法
 * @return NONEs
 */
public String uploadMyFile() {
	System.out.println(my.getPath());
	System.out.println(myFileName);
	System.out.println(myContentType);
	return NONE;
}

</pre>
			</div>
			<div class="tabcontent" title="属性">
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>属性名称</th>
						<th>属性类型</th>
						<th>默认值</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>url</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">上传文件的请求路径</td>
					</tr>
					<tr>
						<td>data</td>
						<td>Object/Function</td>
						<td>null</td>
						<td class="table-desc">其他要一同上传的参数;</td>
					</tr>
					<tr>
						<td>fileElementId</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">上传文件的ID</td>
					</tr>
					<tr>
						<td>secureuri</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">安全路径,防止浏览器阻止javascript脚本</td>
					</tr>
					<tr>
						<td>dataType</td>
						<td>String</td>
						<td>"text"</td>
						<td class="table-desc">请求返回的数据类型</td>
					</tr>
					<tr>
						<td>fileSize</td>
						<td>Number</td>
						<td>1024*1024*1024</td>
						<td class="table-desc">上传文件大小限制,默认1G,注意在低版本IE该参数可能无效</td>
					</tr>
					<tr>
						<td>timeout</td>
						<td>Number</td>
						<td>null</td>
						<td class="table-desc">超时时间设定,单位毫秒</td>
					</tr>
					<tr>
						<td>showProgress</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否显示上传进度</td>
					</tr>
				</table>
			</div>
			<div class="tabcontent" title="事件">
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>事件属性名称</th>
						<th>参数</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>beforeUpload</td>
						<td>String,Number,Array</td>
						<td class="table-desc">上传文件前的回调,三个参数分别为,文件路径,文件大小,文件类型</td>
					</tr>
					<tr>
						<td>onUploadSuccess</td>
						<td>JSON,String</td>
						<td class="table-desc">上传完成后回调函数,返回的数据和状态</td>
					</tr>
					<tr>
						<td>onUploadError</td>
						<td>JSON,String,event</td>
						<td class="table-desc">上传失败回调</td>
					</tr>
				</table>
			</div>
			<div class="tabcontent" title="方法">
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>方法名称</th>
						<th>返回类型</th>
						<th>参数类型</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>options</td>
						<td>JS Object</td>
						<td>void</td>
						<td class="table-desc">获得myui-options配置选项对象</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>