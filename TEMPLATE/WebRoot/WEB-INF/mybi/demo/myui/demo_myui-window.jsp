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
	    SyntaxHighlighter.all();
	});
	
	// 初始化演示效果
	function openWin() {
		$("#inputWin").window({
			open : true,
			headline:'测试窗口',
			content:'<iframe id="myframe" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:200,
			panelHeight:200
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-window效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input type="button" value="打开窗口" onclick="openWin()" style="width:100px;height:20px;"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-window使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
$("#inputWin").window({
	open : true,
	headline:'测试窗口',
	content:'&lt;iframe id="myframe" scrolling="no" frameborder="0" 
			style="width:100%;height:100%;overflow:hidden;" />',
	panelWidth:600,
	panelHeight:320
});
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
						<td>panelWidth</td>
						<td>Number</td>
						<td>400</td>
						<td class="table-desc">窗口的宽度</td>
					</tr>
					<tr>
						<td>panelHeight</td>
						<td>Number</td>
						<td>300</td>
						<td class="table-desc">窗口的高度</td>
					</tr>
					<tr>
						<td>top</td>
						<td>Number</td>
						<td>40</td>
						<td class="table-desc">距上边缘距离</td>
					</tr>
					<tr>
						<td>left</td>
						<td>Number</td>
						<td>当前frame中间</td>
						<td class="table-desc">距左边缘距离</td>
					</tr>
					<tr>
						<td>headline</td>
						<td>String</td>
						<td>窗口</td>
						<td class="table-desc">窗口的title</td>
					</tr>
					<tr>
						<td>content</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">窗口的内容，现阶段只支持iframe</td>
					</tr>
					<tr>
						<td>open</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">打开状态</td>
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
						<td>onBeforeClose</td>
						<td>void</td>
						<td class="table-desc">窗口关闭前的函数，如果设置则会在窗口关闭前调用此函数 </td>
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
						<td>open</td>
						<td>void</td>
						<td>void</td>
						<td class="table-desc">打开窗口</td>
					</tr>
					<tr>
						<td>close</td>
						<td>void</td>
						<td>void</td>
						<td class="table-desc">关闭窗口</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	
<div id="inputWin"></div>

</body>
</html>