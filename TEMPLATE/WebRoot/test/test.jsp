<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"
	rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/lsb/themes/${apptheme}/buttons.css"
  rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css"
  rel="stylesheet" type="text/css" />
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
	<script type="text/javascript">
	$(function(){
		$("#showPusher").click(function(e){
			$.msgpusher.show(0,'缺口数据补录：【ERMS报表方案】导数成功！');
		});
		$("#here").tooltip({
			css : "background-color:#000;color:#FFF",
			trigger : "focus",
			content : "Bootstrap是最受欢迎的HTML、CSS和JS的前端开发框架，用于开发响应式布局、移动设备优先的WEB项目。它使用了最新的浏览器技术，给你的Web开发提供了时尚的版式。"
		});
		$("#test").datebox({
			calendarType : "year",
			//range : {min:{type:'constant',value:'20100211'},max:{type:'constant',value:'20150911'}},
			buttons : true,
			defaultDate : "2012",
			onSelect : function(val) {
				alert(val);
			}
		});
		$("#popTest").popselector({
			type : "checkbox",
			oneLineCount : 2,
			winTitle : "机构选择",
			data : [{text : "中国银行安徽省分行", value : "0"},
			        {text : "中国银行黄山分行", value : "1"},
			        {text : "中国银行泰州分行", value : "2"},
			        {text : "中国银行郑州分行", value : "3"},
			        {text : "郑州百花路营业厅", value : "4"},
			        {text : "中国银行芜湖分行", value : "5"},
			        {text : "中国银行徐州省分行", value : "6"},
			        {text : "中国银行杭州分行", value : "7"},
			        {text : "中国银行上海分行", value : "8"},
			        {text : "中国银行呼和浩特分行", value : "9"},
			        {text : "郑州金水区分行", value : "10"},
			        {text : "中国银行山东省分行", value : "11"},
			        {text : "中国银行大连分行", value : "12"},
			        {text : "中国银行合肥分行", value : "13"},
			        {text : "中国银行秦皇岛分行", value : "14"},
			        {text : "中国银行福州分行", value : "15"},
			        {text : "中国银行澳大利亚分行", value : "16"},
			        {text : "中国银行赞比亚分行", value : "17"}]
		});
		/*$("#popTest2").popselector({
			type : "tree-checkbox",
			url : "${ctx}/demo_myui!genPopselectorData.action",
			oneLineCount : 2,
			winTitle : "选择手机品牌",
			winHeight : 400,
			winWidth: 400,
			treeShowIcon : true
		});*/
		
		$("#orgidt").multinput2();
	});
	
	function setValue(val) {
		//$("#popTest2").popselector("setValue", "06,01,02");
		$("#orgidt").multinput("setValue", ["中国", "美国", "俄罗斯"]);
	}
	
	function getValue() {
		//alert($("#popTest2").popselector("getValue"));
		var arr = $("#orgidt").multinput2("getValue");
		alert(arr);
		alert(arr.length);
	}
	
	function toInput() {
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_add"/>',
			content:'<iframe id="myframe" name="myframe" src=${ctx}/test/testcombo.jsp scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:400
		});
	}
	
	function test() {
		var name = $("#test").attr("name");
		alert(name);
	}
	
</script>
</head>
<body style="height:900px;">

	<div class="myui-template-top-location"></div>

	<div class="myui-template-condition">
		<ul>
			<li class="desc">数据日期：</li>
			<li><input id="test" class="myui-validator"/></li>
		</ul>
	</div>
  
	<div>
		<input type="button" value="setValue" onclick="setValue('2021H2')"/>
		<input type="button" value="getValue" onclick="getValue()"/>
        <input type="button" value="openWin" onclick="toInput()"/>
        <input type="button" value="test" onclick="test()"/>
	</div>
  
  <div class="myui-template-condition">
    <ul>
      <li class="desc">其他：</li>
      <li><input id="popTest" class="myui-validator" required="true"/></li>
    </ul>
  </div>
  <div class="myui-template-condition">
    <ul>
      <li class="desc">周期：</li>
      <li><input id="cycle" name="cycle" class="myui-cycle" defaultValue="M3"/></li>
    </ul>
  </div>
  <br />
  <div>
    <input id="orgidt" name="orgidt" style="width:200px;"/>
    <br/><br/>
    <br/>
  	这是一段测试文字,这是一段测试文字,这是一段测试文字,这是一段测试文字,这是一段测试文字,这是一段这是一段测试文字,这是一段测试文字,请将鼠标悬浮在<a id="here" href="###" >这里</a>。
  </div>
  <br /><br /><br /><br /><br /><br /><br />
  	<div>
		<input id="showPusher" type="button" value="showPusher"/>
	</div>
</body>
<div id="inputWin"></div>
</html>

