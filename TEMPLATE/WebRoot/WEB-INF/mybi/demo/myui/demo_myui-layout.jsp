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
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushXml.js"></script>
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
		<div class="tabs" style="width:960px;height:672px" title="myui-layout使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: html">
&lt;!-- 使用时先要定义myui-layout标签 -->
&lt;div class="myui-layout">

	&lt;!-- rowgroup用于左右横向排列布局 -->
	&lt;div class="rowgroup">
	
		&lt;!-- content中需要自己制定宽高样式，并且自定义title属性用于显示标题 -->
		&lt;div class="content" style="width:250px;height:672px;" title="ZTREE树">
		
			&lt;!-- 在content div中可以定义自己想要内容，比如构建一个ztree树的容器 -->
			&lt;div style="width:230px;">
				&lt;ul id="mytree" class="ztree">&lt;/ul>
			&lt;/div>
		&lt;/div>
		
		&lt;!-- linegroup用于上下纵向排列布局 -->
		&lt;div class="linegroup">
			&lt;div class="content" style="width:960px;height:150px;" title="content区域">
			
				&lt;!-- 按钮操作区域样式名为operate，可以自由定义需要的按钮链接，必须写在内容的开头 -->
				&lt;div class="operate">
					&lt;ul>
						&lt;li>&lt;a href="javascript:void(0)" 
							onclick="add()" style="color:#374fff;">添加&lt;/a>&lt;/li>
						&lt;li> &lt;a href="javascript:void(0)"
							onclick="del()" style="color:#374fff;">删除&lt;/a>&lt;/li>
					&lt;/ul>
				&lt;/div>
				该部分可以自己定义想要的内容！
			&lt;/div>
			
			&lt;!-- tabs用于定义选项卡切换，position属性可以定义选项卡切换按钮的位置， -->
			&lt;!-- 默认为左侧，title标题的位置和position相对，在tabs里定义具体的选项卡tabcontent -->
			&lt;div class="tabs" style="width:960px;height:537px" title="选项卡" position="right">
				&lt;div class="tabcontent" title="选项卡1">选项卡1&lt;/div>
				&lt;div class="tabcontent" title="选项卡2">选项卡2&lt;/div>
				&lt;div class="tabcontent" title="选项卡3">
				
					&lt;!-- 在tabcontent中还可以定义iframe标签内嵌页面 -->
					&lt;iframe id="tabframe" name="tabframe" scrolling="no" 
						frameborder="0" style="width:100%;height:100%;overflow:hidden;">&lt;/iframe>
				&lt;/div>
			&lt;/div>
		&lt;/div>
	&lt;/div>
&lt;/div>
</pre>
			</div>
			<div class="tabcontent" title="属性">
				<h3>content属性</h3>
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>属性名称</th>
						<th>属性类型</th>
						<th>默认值</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>title</td>
						<td>String</td>
						<td>空</td>
						<td class="table-desc">头部名称</td>
					</tr>
					<tr>
						<td>style</td>
						<td>String</td>
						<td>空</td>
						<td class="table-desc">窗口需要自己设置高度与宽度（width,height），高度计算包含33px头部高度</td>
					</tr>
				</table>
				<h3>tabs属性</h3>
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>属性名称</th>
						<th>属性类型</th>
						<th>默认值</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>title</td>
						<td>String</td>
						<td>空</td>
						<td class="table-desc">头部名称</td>
					</tr>
					<tr>
						<td>position</td>
						<td>String</td>
						<td>left</td>
						<td class="table-desc">只能填写left或者right，标签页在哪个方向显示</td>
					</tr>
					<tr>
						<td>style</td>
						<td>String</td>
						<td>空</td>
						<td class="table-desc">窗口需要自己设置高度与宽度（width,height），高度计算包含33px头部高度</td>
					</tr>
				</table>
				<h3>tabcontent属性</h3>
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>属性名称</th>
						<th>属性类型</th>
						<th>默认值</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>title</td>
						<td>String</td>
						<td>空</td>
						<td class="table-desc">Tab页名称</td>
					</tr>
					<tr>
						<td>selected</td>
						<td>Boolean</td>
						<td>空</td>
						<td class="table-desc">是否默认选中，如果不填写则不选中</td>
					</tr>
				</table>
			</div>
			<div class="tabcontent" title="事件">
				<table class="api-table" cellpadding="0" cellspacing="0">
					<tr>
						<th>事件属性名称</th>
						<th>参数</th>
						<th>返回类型</th>
						<th>说明</th>
					</tr>
					<tr>
						<td>Tabcontent标签的onclick事件</td>
						<td>自定义</td>
						<td>true/false/空</td>
						<td class="table-desc">可以自定义点击事件，返回false时候不触发切换标签操作 </td>
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
						<td>getContentByTab</td>
						<td>void</td>
						<td>tabcontent对象</td>
						<td class="table-desc">获取tab页中的内容父对象，使用返回值.children()获取所有返回值，主要用于外部调用</td>
					</tr>
					<tr>
						<td>setTabSelectedByTab</td>
						<td>void</td>
						<td>tabcontent对象</td>
						<td class="table-desc">设置标签页选中并进行内容切换，主要用于外部调用</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	
</body>
</html>