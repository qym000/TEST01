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
		$("#test").cycle({
			openOnParent : false,
			defaultValue : "W3|M15"
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-cycle效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;font-family:微软雅黑 ">
				<input id="test" name="test" class="myui-text"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-cycle使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
$("#test").cycle({
  openOnParent : false,
  defaultValue : "W3|M15"
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
						<td>openOnParent</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">周期选择对话框是否在父页面弹出，默认在当前页面弹出</td>
					</tr>
					<tr>
						<td>defaultValue</td>
						<td>String</td>
						<td>null</td>
						<td class="table-desc">初始化时的默认值，若有多个周期请以竖线分割周期代码</td>
					</tr>
				</table>
			</div>
			<div class="tabcontent" title="事件">
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>事件属性名称</th>
						<th>返回值</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>beforeOpen</td>
						<td>void</td>
						<td class="table-desc">打开窗口前调用该事件，若返回false,则不会打开弹窗</td>
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