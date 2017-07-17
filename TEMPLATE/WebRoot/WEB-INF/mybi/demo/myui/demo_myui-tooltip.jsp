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
		$("font").tooltip({
			css : "width:100px",
			content : "欢迎使用MYUI控件库，<a href='http://www.baidu.com/' target='_blank' style='color:blue'>点击这里跳转</a>"
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-tooltip效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;font-family:微软雅黑 ">
			   将鼠标指针悬浮到<font color="blue" >这里</font>即可看到效果
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-tooltip使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
$("font").tooltip({
	css : "width:100px",
	content : "欢迎使用MYUI控件库，&lt;a href='http://www.baidu.com/' target='_blank' style='color:blue'>点击这里跳转&lt;/a>"
});
//更简单的使用方法：&lt;div class='myui-tooltip' content='在这里添加内容'>&lt;/div>
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
						<td>content</td>
						<td>String</td>
						<td>""</td>
						<td class="table-desc">要设置显示的内容</td>
					</tr>
					<tr>
					    <td>css</td>
						<td>String</td>
						<td>null</td>
						<td class="table-desc">自定义样式，写入字符串形如：font-size:12px;background-color:#FFF</td>
					</tr>
                    <tr>
                      <td>trigger</td>
                      <td>String</td>
                      <td>"hover"</td>
                      <td class="table-desc">定义如何触发提示工具： click,hover,focus。</td>
                    </tr>
                    <tr>
                      <td>selector</td>
                      <td>String</td>
                      <td>false</td>
                      <td class="table-desc">如果提供了一个选择器，提示工具的触发动作被委派到指定的目标。</td>
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
						<td>beforeTipShow</td>
						<td>void</td>
						<td class="table-desc">提示信息显示前触发，若返回false,则不会显示</td>
					</tr>
                    <tr>
                      <td>beforeTipHide</td>
                      <td>void</td>
                      <td class="table-desc">提示信息隐藏前触发，若返回false,则不会隐藏</td>
                    </tr>
                    <tr>
                      <td>afterTipShow</td>
                      <td>void</td>
                      <td class="table-desc">提示信息显示后触发</td>
                    </tr>
                    <tr>
                      <td>afterTipHide</td>
                      <td>void</td>
                      <td class="table-desc">提示信息隐藏后触发</td>
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
                      <td>setContent</td>
                      <td>void</td>
                      <td>String</td>
                      <td class="table-desc">设置提示内容</td>
                    </tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>