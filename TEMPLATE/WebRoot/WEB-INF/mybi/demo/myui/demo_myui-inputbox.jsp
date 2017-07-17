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
	var data = [{value:"01",text:"java"},
	            {value:"02",text:"javascript"},
	            {value:"03",text:"C++"},
	            {value:"04",text:"C#"},
	            {value:"05",text:"object-c"},
	            {value:"06",text:"pascal"}];
	$(function() {
		initDemo();
	    SyntaxHighlighter.all();
	});
	
	function initDemo() {
		$("#test").inputbox({
			type : "normal",
			autocomplete : true,
			acMode : "local",
			acData : data,
			acPanelHeight : 160,
			acPanelWidth : 200,
			acScrollTarget : "body"
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-inputbox效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input id="test" name="test" class="myui-text"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-inputbox使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
var data = [{value:"01",text:"java"},
	        {value:"02",text:"javascript"},
	        {value:"03",text:"C++"},
	        {value:"04",text:"C#"},
	        {value:"05",text:"object-c"},
	        {value:"06",text:"pascal"}];
	        
$("#test").inputbox({
	type : "normal",
	autocomplete : true,
	acMode : "local",
	acData : data,
	acPanelHeight : 160,
	acPanelWidth : 200,
	acScrollTarget : "body"
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
						<td>type</td>
						<td>String</td>
						<td>'normal'</td>
						<td class="table-desc">normal-普通的文本框 action-带按钮控制的文本框</td>
					</tr>
					<tr>
						<td>autocomplete</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否开启自动补全功能</td>
					</tr>
					<tr>
						<td>acMode</td>
						<td>String</td>
						<td>'local'</td>
						<td class="table-desc">自动补全的数据来源方式，remote：远程数据，local：本地数据</td>
					</tr>
					<tr>
						<td>acUrl</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">Remote模式下的请求数据url</td>
					</tr>
					<tr>
						<td>acParam</td>
						<td>JS Object</td>
						<td>null</td>
						<td class="table-desc">Remote模式下的请求参数</td>
					</tr>
					<tr>
						<td>acData</td>
						<td>JS Array</td>
						<td>Null</td>
						<td class="table-desc">Local模式下的数据</td>
					</tr>
					<tr>
						<td>acPanelHeight</td>
						<td>Number</td>
						<td>200</td>
						<td class="table-desc">自动补全弹出框的高度</td>
					</tr>
					<tr>
						<td>acPanelWidth</td>
						<td>Number</td>
						<td>与input宽度一致</td>
						<td class="table-desc">自动补全弹出框的宽度</td>
					</tr>
					<tr>
						<td>textField</td>
						<td>String</td>
						<td>"text"</td>
						<td class="table-desc">文本显示字段</td>
					</tr>
					<tr>
						<td>valueField</td>
						<td>String</td>
						<td>"value"</td>
						<td class="table-desc">实际值字段</td>
					</tr>
					<tr>
						<td>acScrollTarget</td>
						<td>String/jQuery DOM Object</td>
						<td>"body"</td>
						<td class="table-desc">自动补全弹出框的滚动定位对象</td>
					</tr>
					<tr>
						<td>maxLength</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">Input框允许输入的最大长度</td>
					</tr>
					<tr>
						<td>prompt</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">Input框默认显示的提示文字</td>
					</tr>
					<tr>
						<td>icon</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">Type为action时，文本框的按钮图标</td>
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
						<td>onEnterDo</td>
						<td>String</td>
						<td class="table-desc">回车事件，参数为文本框的值</td>
					</tr>
					<tr>
						<td>onClickBtn</td>
						<td>String</td>
						<td class="table-desc">点击按钮事件，参数为文本框的值</td>
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
						<td>loadData</td>
						<td>void</td>
						<td>JS Array</td>
						<td class="table-desc">手动加载本地数据 data:要加载的数据对象</td>
					</tr>
					<tr>
						<td>getValue</td>
						<td>String</td>
						<td>void</td>
						<td class="table-desc">获取当前值</td>
					</tr>
					<tr>
						<td>setValue</td>
						<td>void</td>
						<td>String</td>
						<td class="table-desc">设置当前值</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>