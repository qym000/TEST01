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
		$("#test").combo({
			mode : "local",
			data : [{text:"Java",value:"0"},{text:"Javascript",value:"1"},{text:"C++",value:"2"}],
			panelHeight : 90,
			isCustom : true,
			customData : [{text:"全部",value:"ALL"}],
			editable : true,
			searchable : true
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-combo效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input id="test" name="test"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-combo使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
$("#test").combo({
	mode : "local",
	data : [{text:"Java",value:"0"},{text:"Javascript",value:"1"},{text:"C++",value:"2"}],
	panelHeight : 90,
	isCustom : true,
	customData : [{text:"全部",value:"ALL"}],
	editable : true,
	searchable : true
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
						<td>comboType</td>
						<td>String</td>
						<td>'normal-single'</td>
						<td class="table-desc">下拉控件的类型：”normal-single”为单选，”normal-multi”为多选</td>
					</tr>
					<tr>
						<td>mode</td>
						<td>String</td>
						<td>'remote'</td>
						<td class="table-desc">获取数据的方式，远程数据（remote）或本地数据（local）</td>
					</tr>
					<tr>
						<td>url</td>
						<td>String</td>
						<td>''</td>
						<td class="table-desc">当获取数据方式为remote时,远程服务器地址url</td>
					</tr>
					<tr>
						<td>param</td>
						<td>JS Object</td>
						<td>null</td>
						<td class="table-desc">当获取数据方式为remote时,需向远程服务器传入的参数</td>
					</tr>
					<tr>
						<td>data</td>
						<td>JS Object-Array</td>
						<td>null</td>
						<td class="table-desc">当获取数据方式为local时,渲染的下拉选择数据</td>
					</tr>
					<tr>
						<td>method</td>
						<td>String</td>
						<td>'post'</td>
						<td class="table-desc">当获取数据方式为remote时,请求数据的方式,有'post'和'get'两种</td>
					</tr>
					<tr>
						<td>valueField</td>
						<td>String</td>
						<td>'value'</td>
						<td class="table-desc">选择项值的实际字段</td>
					</tr>
					<tr>
						<td>textField</td>
						<td>String</td>
						<td>'text'</td>
						<td class="table-desc">选择项文本的实际字段</td>
					</tr>
					<tr>
						<td>defaultValue</td>
						<td>JS Object</td>
						<td>null</td>
						<td class="table-desc">初始选择项的值，当什么都不填时,会自动选择第一项,在多选模式下,应传入非对象数组</td>
					</tr>
					<tr>
						<td>isCustom</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否使用自定义拼接选项,当远程获得的数据不满足要求时,可以使用此功能,比如要添加'全部'选项</td>
					</tr>
					<tr>
						<td>customData</td>
						<td>JS Object-Array</td>
						<td>null</td>
						<td class="table-desc">当使用自定义拼接选项功能时,要拼接的选项数组</td>
					</tr>
					<tr>
						<td>customPosition</td>
						<td>String/Number</td>
						<td>'top'</td>
						<td class="table-desc">当使用自定义拼接选项功能时,拼接选项所在原数组的位置,使用'top'或'bottom'表示顶部或底部,使用数字时表示在原数组的任意位置,注意数字值不要超过原数组的长度</td>
					</tr>
					<tr>
						<td>panelHeight</td>
						<td>Number</td>
						<td>200</td>
						<td class="table-desc">下拉选择弹出框panel的高度</td>
					</tr>
					<tr>
						<td>panelWidth</td>
						<td>Number</td>
						<td>与input框宽度一致</td>
						<td class="table-desc">下拉选择弹出框panel的宽度</td>
					</tr>
					<tr>
						<td>disabled</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否禁用combo选择框,当为true时,用户不能进行任何操作</td>
					</tr>
					<tr>
						<td>readonly</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否只读combo选择框,当为true时,用户不能进行选择</td>
					</tr>
					<tr>
						<td>editable</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">Input框是否可编辑</td>
					</tr>
					<tr>
						<td>searchable</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否需开启模糊匹配查询，editable为true时可用</td>
					</tr>
					<tr>
						<td>scrollTarget</td>
						<td>String/jQuery DOM Object</td>
						<td>'body'</td>
						<td class="table-desc">滚动定位的对象</td>
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
						<td>onBeforeLoad</td>
						<td>void</td>
						<td class="table-desc">当初始化combo数据前调用</td>
					</tr>
					<tr>
						<td>onLoadSuccess</td>
						<td>void</td>
						<td class="table-desc">当初始化combo数据成功后调用</td>
					</tr>
					<tr>
						<td>onLoadError</td>
						<td>void</td>
						<td class="table-desc">当从远程获取数据错误时调用</td>
					</tr>
					<tr>
						<td>onSelect</td>
						<td>JS Object</td>
						<td class="table-desc">当选择一个选项时调用</td>
					</tr>
					<tr>
						<td>onUnselect</td>
						<td>JS Object</td>
						<td class="table-desc">在多选模式下,当反选一个选项时调用</td>
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
						<td>getValue</td>
						<td>JS Object</td>
						<td>void</td>
						<td class="table-desc">单选模式下,获取combo的当前值</td>
					</tr>
					<tr>
						<td>getValues</td>
						<td>JS Array</td>
						<td>void</td>
						<td class="table-desc">多选模式下,获取combo的当前值,以数组形式返回,如["01","02","03"]</td>
					</tr>
					<tr>
						<td>setValue</td>
						<td>void</td>
						<td>JS Object</td>
						<td class="table-desc">单选模式下,设置combo的值</td>
					</tr>
					<tr>
						<td>setValues</td>
						<td>void</td>
						<td>JS Array</td>
						<td class="table-desc">多选模式下,设置combo的当前值,传入值数组,如["01","02","03"]</td>
					</tr>
					<tr>
						<td>options</td>
						<td>JS Object</td>
						<td>void</td>
						<td class="table-desc">获得myui-options配置选项对象</td>
					</tr>
					<tr>
						<td>getData</td>
						<td>JS Array</td>
						<td>void</td>
						<td class="table-desc">获得选择项数据</td>
					</tr>
					<tr>
						<td>loadData</td>
						<td>void</td>
						<td>JS Array</td>
						<td class="table-desc">重新渲染选择项数据</td>
					</tr>
					<tr>
						<td>reset</td>
						<td>void</td>
						<td>void</td>
						<td class="table-desc">将combo选择框当前值置为空</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>