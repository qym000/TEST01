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
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	$(function() {
		initDemo();
	    SyntaxHighlighter.all();
	});
	
	// 初始化演示效果
	function initDemo() {
		$("#showPusher").click(function(e){
			$.msgpusher.show("信息提示","缺口数据补录：【ERMS报表方案】导数成功！");
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-msgpusher效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;font-family:微软雅黑 ">
			   <input id="showPusher" type="button" value="showPusher"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-msgpusher使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
$("#showPusher").click(function(e){
	$.msgpusher.show("信息提示","缺口数据补录：【ERMS报表方案】导数成功！", 5000);
});
</pre>
			</div>
			<div class="tabcontent" title="方法">
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>方法名称</th>
						<th>void</th>
						<th>参数类型</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>show</td>
						<td>JS Object</td>
						<td>String,Number</td>
						<td class="table-desc">第一个参数为标题名称，第二个参数为提示内容，第三个参数为延迟隐藏时间(单位毫秒)</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>