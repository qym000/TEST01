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
<script type="text/javascript"  src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJava.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	var orgdata = [{ORGNAM : "中国银行安徽省分行", ORGIDT : "A0013"},
			        {ORGNAM : "中国银行黄山分行", ORGIDT : "A1643"},
			        {ORGNAM : "中国银行宿州分行", ORGIDT : "A1728"},
			        {ORGNAM : "中国银行阜阳分行", ORGIDT : "A0166"},
			        {ORGNAM : "中国银行淮南分行", ORGIDT : "A8001"},
			        {ORGNAM : "中国银行芜湖分行", ORGIDT : "A2844"},
			        {ORGNAM : "中国银行宣城分行", ORGIDT : "A7061"},
			        {ORGNAM : "中国银行铜陵分行", ORGIDT : "A8604"},
			        {ORGNAM : "中国银行滁州分行", ORGIDT : "B0441"},
			        {ORGNAM : "中国银行亳州分行", ORGIDT : "B5764"},
			        {ORGNAM : "中国银行安庆分行", ORGIDT : "B5779"},
			        {ORGNAM : "中国银行六安分行", ORGIDT : "B3120"},
			        {ORGNAM : "中国银行蚌埠分行", ORGIDT : "B4618"},
			        {ORGNAM : "中国银行马鞍山分行", ORGIDT : "A1183"},
			        {ORGNAM : "中国银行合肥市分行", ORGIDT : "B5484"},
			        {ORGNAM : "中国银行淮北分行", ORGIDT : "B0070"},
			        {ORGNAM : "中国银行池州分行", ORGIDT : "A0092"}];
	$(function() {
		initDemo();
	    SyntaxHighlighter.all();
	});
	
	// 初始化演示效果
	function initDemo() {
		$("#test").popselector({
			type : "radio",
			oneLineCount : 2,
			winTitle : "机构选择",
			defaultValue : "A0013",
			textField : "ORGNAM",
			valueField : "ORGIDT",
			inputValue : true,
			data : orgdata
		});
		
		$("#test2").popselector({
			type : "checkbox",
			oneLineCount : 3,
			openOnParent : true,
			winTitle : "机构选择",
			winWidth : 520,
			winHeight : 300,
			defaultValue : "A0013,B5779,A1183",
			textField : "ORGNAM",
			valueField : "ORGIDT",
			data : orgdata
		});
		
		$("#test3").popselector({
			type : "tree-radio",
			url : "${ctx}/demo_myui!genPopselectorData.action",
			param : {id : "123"},
			winTitle : "选择手机品牌",
			defaultValue : "05",
			treeShowIcon : true
		});
		
		$("#test4").popselector({
			type : "tree-checkbox",
			url : "${ctx}/demo_myui!genPopselectorData.action",
			winTitle : "选择手机品牌",
			winHeight : 350,
			winWidth : 350,
			treeShowIcon : false
		});
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-popselector效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;font-family:微软雅黑 ">
				radio:<input id="test" name="test" style="width:120px;" class="myui-text"/>
                checkbox:<input id="test2" name="test2" style="width:120px;" class="myui-text"/>
                tree-radio:<input id="test3" name="test3" style="width:120px;" class="myui-text"/>
                tree-checkbox<input id="test4" name="test4" style="width:120px;" class="myui-text"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-popselector使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="brush: js">
// 本地数据
var orgdata = [{ORGNAM : "中国银行安徽省分行", ORGIDT : "A0013"},
               {ORGNAM : "中国银行黄山分行", ORGIDT : "A1643"},
               {ORGNAM : "中国银行宿州分行", ORGIDT : "A1728"},
               {ORGNAM : "中国银行阜阳分行", ORGIDT : "A0166"},
               {ORGNAM : "中国银行淮南分行", ORGIDT : "A8001"},
               {ORGNAM : "中国银行芜湖分行", ORGIDT : "A2844"},
               {ORGNAM : "中国银行宣城分行", ORGIDT : "A7061"},
               {ORGNAM : "中国银行铜陵分行", ORGIDT : "A8604"},
               {ORGNAM : "中国银行滁州分行", ORGIDT : "B0441"},
               {ORGNAM : "中国银行亳州分行", ORGIDT : "B5764"},
               {ORGNAM : "中国银行安庆分行", ORGIDT : "B5779"},
               {ORGNAM : "中国银行六安分行", ORGIDT : "B3120"},
               {ORGNAM : "中国银行蚌埠分行", ORGIDT : "B4618"},
               {ORGNAM : "中国银行马鞍山分行", ORGIDT : "A1183"},
               {ORGNAM : "中国银行合肥市分行", ORGIDT : "B5484"},
               {ORGNAM : "中国银行淮北分行", ORGIDT : "B0070"},
               {ORGNAM : "中国银行池州分行", ORGIDT : "A0092"}];
               
// type为radio类型
$("#test").popselector({
  type : "radio",
  oneLineCount : 2, // 一行显示数
  winTitle : "机构选择", // 弹出窗口标题
  defaultValue : "A0013", // 设置默认值
  textField : "ORGNAM", // 显示文本的字段
  valueField : "ORGIDT", // 实际值字段,
  inputValue : true, // 在input框中显示实际值而非描述文本
  data : orgdata // 本地数据不用写url，而是将data树形设置为本地数组
});

// type为checkbox类型
$("#test2").popselector({
  type : "checkbox",
  oneLineCount : 3,
  openOnParent : true, // 窗体在父页面打开
  winTitle : "机构选择",
  winWidth : 520, // 窗体宽度,若不设置默认400
  winHeight : 300, // 窗体高度，若不设置默认400
  textField : "ORGNAM",
  valueField : "ORGIDT",
  defaultValue : "A0013,B5779,A1183", //checkbox设置多值用逗号分隔
  data : orgdata
});

// type为tree-radio,树形单选
$("#test3").popselector({
  type : "tree-radio",
  url : "demo_myui!genPopselectorData.action", // 远程请求数据时须填写url
  param : {id : "123"}, // 远程请求数据需要一同传的参数
  winTitle : "选择手机品牌",
  defaultValue : "05",
  treeShowIcon : true // 是否将树上节点的图标显示出来
});

// type为tree-checkbox,树形多选
$("#test4").popselector({
  type : "tree-checkbox",
  url : "demo_myui!genPopselectorData.action",
  winTitle : "选择手机品牌",
  winHeight : 350,
  winWidth : 350,
  treeShowIcon : false
});

// 获取值
var value = $("#test").popselector("getValue");
// 获取文本
var text = $("#test").popselector("getText");
// 获取数据
var data = $("#test").popselector("getData");
// 设置值
$("#test").popselector("setValue", "A0013,A1728,A8001");
// 加载数据
$("#test").popselector("loadData", orgdata);
</pre>
<pre class="brush: java">
  /**
   * 获取popselector-弹出选择树远程数据
   * @return 无转向
   */
  public String genPopselectorData() {
    List&lt;Map&lt;String, Object>> mapList = new ArrayList&lt;Map&lt;String, Object>>();
    Map&lt;String, Object> map = new HashMap&lt;String, Object>();
    map.put("name", "国内产品");
    map.put("nocheck", true);
    map.put("id", "C");
    map.put("pId", null);
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "国外产品");
    map.put("id", "I");
    map.put("pId", null);
    map.put("nocheck", true);
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "诺基亚");
    map.put("id", "01");
    map.put("pId", "I");
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "小米");
    map.put("id", "02");
    map.put("pId", "C");
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "苹果");
    map.put("id", "03");
    map.put("pId", "I");
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "华为");
    map.put("id", "04");
    map.put("pId", "C");
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "魅族");
    map.put("id", "05");
    map.put("pId", "C");
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "OPPO");
    map.put("id", "06");
    map.put("pId", "C");
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "HTC");
    map.put("id", "07");
    map.put("pId", "I");
    mapList.add(map);
    map = new HashMap&lt;String,Object>();
    map.put("name", "三星");
    map.put("id", "08");
    map.put("pId", "I");
    mapList.add(map);
    Struts2Utils.renderText(JSONArray.fromObject(mapList).toString());
    return NONE;
  }
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
						<td>'radio'</td>
						<td class="table-desc">弹出类型：[checkbox]多选框选择器 [radio]单选框选择器 [tree-radio]树状单选 [tree-checkbox]树状多选</td>
					</tr>
					<tr>
						<td>url</td>
						<td>String</td>
						<td>null</td>
						<td class="table-desc">请求数据的URL</td>
					</tr>
					<tr>
						<td>param</td>
						<td>JS Object</td>
						<td>{}</td>
						<td class="table-desc">远程请求数据时要传入的其他参数</td>
					</tr>
					<tr>
						<td>data</td>
						<td>JS Object-Array</td>
						<td>null</td>
						<td class="table-desc">当url为null时，data属性为本地数据</td>
					</tr>
					<tr>
						<td>openOnParent</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否在父页面弹出窗口</td>
					</tr>
                    <tr>
                        <td>winTitle</td>
                        <td>String</td>
                        <td>"选择"</td>
                        <td class="table-desc">窗口标题</td>
                    </tr>
                    <tr>
                        <td>winWidth</td>
                        <td>Number</td>
                        <td>400</td>
                        <td class="table-desc">窗口宽度</td>
                    </tr>
                    <tr>
                        <td>winHeight</td>
                        <td>Number</td>
                        <td>400</td>
                        <td class="table-desc">窗口高度</td>
                    </tr>
					<tr>
						<td>oneLineCount</td>
						<td>Number</td>
						<td>1</td>
						<td class="table-desc">一行显示数，默认1，type为checkbox或radio时有效</td>
					</tr>
                    <tr>
                        <td>valueField</td>
                        <td>String</td>
                        <td>"value"</td>
                        <td class="table-desc">实际值字段，默认字段名为value，type为checkbox或radio时有效</td>
                    </tr>
					<tr>
						<td>textField</td>
						<td>String</td>
						<td>'text'</td>
						<td class="table-desc">显示文本字段，默认字段名为text，type为chckbox或radio时有效</td>
					</tr>
                    <tr>
                        <td>treeShowIcon</td>
                        <td>Boolean</td>
                        <td>false</td>
                        <td class="table-desc">当选择树时是否显示节点的图标</td>
                    </tr>
                    <tr>
                        <td>inputValue</td>
                        <td>Boolean</td>
                        <td>false</td>
                        <td class="table-desc">是否将实际值回显到文本框中，默认false（回显到文本框中的是描述文本）</td>
                    </tr>
					<tr>
						<td>defaultValue</td>
						<td>String</td>
						<td>null</td>
						<td class="table-desc">设置默认值，多选时使用英文半角逗号分隔</td>
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
						<td>getValue</td>
						<td>String</td>
						<td>void</td>
						<td class="table-desc">获取实际值，checkbox和tree-checkbox返回多值用逗号分隔</td>
					</tr>
					<tr>
						<td>getText</td>
						<td>String</td>
						<td>void</td>
						<td class="table-desc">获取文本内容,checkbox和tree-checkbox返回多值用逗号分隔</td>
					</tr>
					<tr>
						<td>setValue</td>
						<td>void</td>
						<td>String</td>
						<td class="table-desc">设置值，checkbox和tree-checkbox设置多值用逗号分隔</td>
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
						<td class="table-desc">获取加载的数据</td>
					</tr>
					<tr>
						<td>loadData</td>
						<td>void</td>
						<td>JS Array</td>
						<td class="table-desc">重新加载数据</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>