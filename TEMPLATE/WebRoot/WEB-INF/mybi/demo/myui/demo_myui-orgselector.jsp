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
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushXml.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJava.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	$(function() {
		initDemo();
	    SyntaxHighlighter.all();
	});
	
	function initDemo() {
		$("#test").orgselector({
			targetid:"test",
			winnam : "orgwin",
			isMultiple : true
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-orgselector效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input id="test" name="test" class="myui-text"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-orgselector使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
$("#test").orgselector({
	targetid:"test",
	winnam : "orgwin",
	isMultiple : true
});
</pre>
<pre class="brush: html">
	&lt;!-- 定义输入框和窗口弹出div -->
	&lt;input id="test" name="test" class="myui-text"/>
	&lt;div id="orgwin">&lt;/div>
</pre>
<pre class="brush: java">
	// 在java中可以用Pim_orgParseUtil工具类来获取机构控件选择的机构
	// 当你的机构来源表不是TP_PIM_ORG时，请指定机构表名称，否则可直接传入null
	orgSrcSysObj.setSrcorg(Pim_orgParseUtil.newInstance().parseOrg(null));
</pre>
<pre class="brush: xml">
&lt;!-- 在mybatis中可以使用解析过的机构来作为动态SQL的参数 -->
&lt;if test="srcorg != null and srcorg != '' ">
	AND ORGIDT IN (\${srcorg})			
&lt;/if>
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
						<td>targetid</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">input框的id，选完机构后将会把选择的机构填充到本文本框内</td>
					</tr>
					<tr>
						<td>framename</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">机构弹窗的父页面是否是一个iframe窗口，如果是需要指明iframe的名称，如果不是则无需指定</td>
					</tr>
					<tr>
						<td>winnam</td>
						<td>String</td>
						<td>'orgSelectorWin'</td>
						<td class="table-desc">要在哪个div里弹出机构选择窗口</td>
					</tr>
					<tr>
						<td>onCallback</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">回调函数，关闭机构选择框前是否执行某些操作，若执行，都可写在onCallback函数里面</td>
					</tr>
					<tr>
						<td>tabname</td>
						<td>String</td>
						<td>'TP_PIM_ORG'</td>
						<td class="table-desc">机构弹窗里的机构来源表</td>
					</tr>
					<tr>
						<td>rootnode</td>
						<td>String</td>
						<td>TP_PIM_PARAM中的LOCAL_TOP_ORGIDT</td>
						<td class="table-desc">机构来源表里的顶级机构，若不写则默认跟着TP_PIM_PARAM中的LOCAL_TOP_ORGIDT走</td>
					</tr>
					<tr>
						<td>withAuth</td>
						<td>boolean</td>
						<td>false</td>
						<td class="table-desc">是否带权限，默认不带[false：不带权限，true：带权限]</td>
					</tr>
					<tr>
						<td>isMultiple</td>
						<td>boolean</td>
						<td>true</td>
						<td class="table-desc">机构是单选还是多选【true：多选，false：单选】</td>
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
						<td>onBeforeClick</td>
						<td>Void</td>
						<td>Boolean</td>
						<td class="table-desc">弹出机构选择窗口前的函数，返回true弹出，false不弹出</td>
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
						<td>Pim_orgParseUtil.newInstance().parseOrg(String tabnam)</td>
						<td>String</td>
						<td>String</td>
						<td class="table-desc">参数默认值为TP_PIM_ORG，传入null即可。</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	
<div id="orgwin"></div>
</body>
</html>