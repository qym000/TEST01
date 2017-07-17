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
	
	function initDemo() {
		$("#test").multinput({
			maxHeight : 150,
			pasteSeprator : ",",
			defaultValue : ["中国","美国"]
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-multinput效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input id="test" name="test" style="width:300px;"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-multinput使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
$("#test").multinput({
  maxHeight : 150,
  pasteSeprator : ",",
  defaultValue : ["中国","美国"]
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
						<td>maxHeight</td>
						<td>Number</td>
						<td>200</td>
						<td class="table-desc">输入框的最大高度，输入框初始高度为，当输入值足够多且到达指定最大高度时，会出现垂直滚动条</td>
					</tr>
					<tr>
						<td>confirmKeyCode</td>
						<td>JS Array</td>
						<td>[13, 32]</td>
						<td class="table-desc">确定输入生成item的键盘码，默认为回车和空格的键盘码</td>
					</tr>
					<tr>
						<td>pasteSeprator</td>
						<td>String</td>
						<td>' '</td>
						<td class="table-desc">粘贴分隔符，粘贴内容到输入框时会根据该属性进行分割生成item</td>
					</tr>
					<tr>
						<td>defaultValue</td>
						<td>JS Array</td>
						<td>null</td>
						<td class="table-desc">初始化时默认的值</td>
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
					<tr>
						<td>getValue</td>
						<td>JS Array</td>
						<td>void</td>
						<td class="table-desc">获取当前值,以数组的形式返回</td>
					</tr>
					<tr>
						<td>setValue</td>
						<td>void</td>
						<td>JS Array</td>
						<td class="table-desc">设置当前值,设置的值应为数组形式</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>