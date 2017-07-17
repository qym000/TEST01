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
		$("#test").datebox({
			dateFormat : 'YYYY/MM/DD',
			defaultDate : '2015/03/23',
			range : {min:{type:'constant',value:'2015/03/23'},max:{type:'constant',value:'2015/03/29'}},
			onSelect : function(val) {
				$.messager.alert("提示", val, "info");
			}
		});
		$("#test2").datebox({
			calendarType : "month",
			dateFormat : 'YYYY-MM'
		});
		$("#test3").datebox({
			calendarType : "quarter",
			defaultDate : '2015Q2'
		});
		$("#test4").datebox({
			calendarType : "eml"
		});
		$("#test5").datebox({
			dateFormat : 'YYYY/MM/DD',
			defaultDate : '2015/08/23',
			scrollTarget : $("#mydiv2")
		});
	}
	
	function getValue(){
		$.messager.alert("提示",$("#test4").datebox("judge","20130320"),"info");
	}
	
	function setValue(){
		$("#test4").datebox("setValue", "201306L");
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-datebox效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input id="test" style="width:160px"/>&nbsp;&nbsp;
				<input id="test2" style="width:160px"/>&nbsp;&nbsp;
				<input id="test3" style="width:160px"/>&nbsp;&nbsp;
				<input id="test4" style="width:160px"/>&nbsp;&nbsp;
				<input type="button" value="getValue" onclick="getValue()"/>
				<input type="button" value="setValue" onclick="setValue()"/>
				<input id="endDate" type="hidden" value="2015-10-23"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-datebox使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
// 普通日期框,带今天选择
$("#test").datebox({
	dateFormat : 'YYYY/MM/DD',
	defaultDate : '2015/08/23',
	range : {min:{type:'constant',value:'2015/03/23'},max:{type:'constant',value:'2015/03/29'}},
	onSelect : function(val) {
		$.messager.alert(val);
	},
	buttons : true
});

// 月份选择
$("#test2").datebox({
	calendarType : "month",
	dateFormat : 'YYYY-MM'
});

// 季度选择
$("#test3").datebox({
	calendarType : "quarter",
	defaultDate : '2015Q2'
});

// 上中下旬选择
$("#test4").datebox({
	calendarType : "eml"
});

// 年选择
$("#test4").datebox({
	calendarType : "year"
});

// 半年选择
$("#test4").datebox({
	calendarType : "halfyear"
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
						<td>calendarType</td>
						<td>String</td>
						<td>'date'</td>
						<td class="table-desc">日历类型-- date:日期选择 month:月份选择 quarter:季度选择 eml:上中下旬选择 year:年份选择 halfyear:半年选择</td>
					</tr>
					<tr>
						<td>buttons</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否在选择界面使用“今天”选择按钮</td>
					</tr>
					<tr>
						<td>showIcon</td>
						<td>Boolean</td>
						<td>true</td>
						<td class="table-desc">是否在input框中显示日历图标</td>
					</tr>
					<tr>
						<td>dateFormat</td>
						<td>String</td>
						<td>'YYYYMMDD'</td>
						<td class="table-desc">在input框中显示和获取值时的日期格式化,只有calendarType类型为'date'和'month'时有效</td>
					</tr>
					<tr>
						<td>range</td>
						<td>JS Object</td>
						<td>null</td>
						<td class="table-desc">范围参数对象,格式为:{min:{type:'constant',value:'20150323'},max:{type:'selector',value:'#endDate'}}，其中min为设置下线，max设置上限，type分为constant和select，分别为常量和类选择器</td>
					</tr>
					<tr>
						<td>defaultDate</td>
						<td>String</td>
						<td>空字符串</td>
						<td class="table-desc">默认显示日期</td>
					</tr>
					<tr>
						<td>autoValidate</td>
						<td>Boolean</td>
						<td>true</td>
						<td class="table-desc">是否开启自动校验</td>
					</tr>
					<tr>
						<td>disabled</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否禁用datebox控件</td>
					</tr>
					<tr>
						<td>editable</td>
						<td>Boolean</td>
						<td>true</td>
						<td class="table-desc">datebox中的input框是否可编辑</td>
					</tr>
					<tr>
						<td>scrollTarget</td>
						<td>String/jQuery DOM Object</td>
						<td>"body"</td>
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
						<td>onSelect</td>
						<td>String</td>
						<td class="table-desc">用户定义的点击datebox中有效日期/月份/季度/旬/年/半年的事件,参数为完整的格式化后的日期..</td>
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
						<td>getDateFormat</td>
						<td>String</td>
						<td>void</td>
						<td class="table-desc">获取组合框的日期格式</td>
					</tr>
					<tr>
						<td>getValue</td>
						<td>String</td>
						<td>void</td>
						<td class="table-desc">获取当前选择的值</td>
					</tr>
					<tr>
						<td>setValue</td>
						<td>void</td>
						<td>String</td>
						<td class="table-desc">设置当前值，不同的日历类型格式不同，如QUARTER:2015Q1 EML:201503M HALFYEAR:2016H1</td>
					</tr>
					<tr>
						<td>getDatePeriod</td>
						<td>JS Object</td>
						<td>void</td>
						<td class="table-desc">获取Quarter、EML、Halfyear类型的日期段对象，含有两个属性beginDate,endDate</td>
					</tr>
					<tr>
						<td>getLastDay</td>
						<td>String</td>
						<td>void</td>
						<td class="table-desc">获取选择月份的最后一天,只对带有月份选择的控件有效</td>
					</tr>
					<tr>
						<td>judge</td>
						<td>String</td>
						<td>String</td>
						<td class="table-desc">传入一个YYYYMMDD日期,获取其日期段表达式,只对QUARTER、EML、HALFYEAR类型控件有效(如,20150321,得到2015Q1或201503L或2015H1)</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>