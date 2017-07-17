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

	function openAlert1() {
		$.messager.alert("提示","要提示的说明信息","info");
	}
	
	function openAlert2() {
		$.messager.alert("警告","要提示的警告信息","warning",function(){
			alert("点击确定触发");
		});
	}
	
	function openAlert3() {
		$.messager.alert("错误","要提示的错误信息","error");
	}
	
	function openConfirm1() {
		$.messager.confirm("提示","确定要执行此操作吗？",function(r){
			$.messager.alert("提示","确定事件！","info");
		},function(r){
			$.messager.alert("提示","取消事件！","info");
		});
	}
	
	function openConfirm2() {
		$.messager.confirm2("提示","确定要执行此操作吗？",function(r){
			$.messager.alert("提示","确定事件！","info");
		});
	}
	
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-messager效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input type="button" value="Alert" onclick="openAlert1()" style="width:100px;height:20px;"/>
				<input type="button" value="Alert2" onclick="openAlert2()" style="width:100px;height:20px;"/>
				<input type="button" value="Alert3" onclick="openAlert3()" style="width:100px;height:20px;"/>
				<input type="button" value="Confirm1" onclick="openConfirm1()" style="width:100px;height:20px;"/>
				<input type="button" value="Confirm2" onclick="openConfirm2()" style="width:100px;height:20px;"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-messager使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
// Alert1 样式为info的普通提示框
$.messager.alert("提示","要提示的说明信息","info");

// Alert2 样式为warning的且带有事件处理的普通提示框
$.messager.alert("警告","要提示的警告信息","warning",function(){
	alert("点击确定触发");
});

// Alert3 样式为error的普通提示框
$.messager.alert("错误","要提示的错误信息","error");

// Confirm1 带有确认事件和取消事件的确认提示框
$.messager.confirm("提示","确定要执行此操作吗？",function(r){
	$.messager.alert("提示","确定事件！","info");
},function(r){
	$.messager.alert("提示","取消事件！","info");
});

// Confirm2 只带有确认事件的确认提示框
$.messager.confirm2("提示","确定要执行此操作吗？",function(r){
	$.messager.alert("提示","确定事件！","info");
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
						<td>ok</td>
						<td>String</td>
						<td>确认/ok</td>
						<td class="table-desc">确认按钮文字，支持国际化</td>
					</tr>
					<tr>
						<td>cancel</td>
						<td>String</td>
						<td>关闭/cancel</td>
						<td class="table-desc">取消按钮文字，支持国际化</td>
					</tr>
					<tr>
						<td>panelWidth</td>
						<td>Number</td>
						<td>280</td>
						<td class="table-desc">窗口的宽度</td>
					</tr>
					<tr>
						<td>panelHeight</td>
						<td>Number</td>
						<td>150</td>
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
						<td class="table-desc">窗口内容</td>
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
		</div>
	</div>
</div>
	
</body>
</html>