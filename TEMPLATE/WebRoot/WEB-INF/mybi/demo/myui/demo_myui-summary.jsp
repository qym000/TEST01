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
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	$(function() {
	    SyntaxHighlighter.all();
	});
	
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:675px"  title="MYUI控件使用说明">
			<h3>统一初始化方法</h3>
			<pre class="pre-text">
           使用MYUI控件具有十分统一的初始化方式，易于开发。所有MYUI控件是基于jQuery-1.8.0基本JS库开发的jQuery插件，因此在使用前请确保引入该JS库。
    除此之外，在使用前还应当确保引入了MYUI的基本JS文件和CSS文件，因此完整的申明引入应当如下所示：</pre>
			<pre class="brush:html">
		&lt;link href="app/mybi/common/themes/default/myui.css" rel="stylesheet" type="text/css"/>
		&lt;script type="app/javascript" src="${ctx}/mybi/common/scripts/jquery.js">&lt;/script> 
		&lt;script type="app/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js">&lt;/script></pre>
			<pre class="pre-text">
           这样就可使用JS的初始化方法来初始化你想要的控件了，以myui-combo下拉选择控件为例，可以使用options对象传入方式进行控件的初始化，在此之前需
   要在HTML代码中加入一个input标签：</pre>
			<pre class="brush:html">
		&lt;input id="test" name="test" style="width:135px;"/></pre>
			<pre class="pre-text">
           然后以id为test作为选择器获取到jQuery的DOM对象并进行combo初始化如下：</pre>
            <pre class="brush:js">
$("#test").combo({
	mode : "local",
	data : [{text : "Java", value : "0"},{text : "C++", value : "1"}]
});</pre>
			<pre class="pre-text">
           在部分MYUI控件中，你还可直接使用HTML代码进行控件初始化操作，比如上面的代码等价于在HTML代码中定义如下：</pre>
            <pre class="brush:html">
		&lt;input id="test" name="test" class="myui-combo" 
		  myui-options="mode:'local',data:[{text : 'Java', value : '0'},{text : 'C++', value : '1'}]"/></pre>
			<pre class="pre-text">
           需要注意的是，使用HTML初始化控件时，需要定义class属性为对应控件的命名控件例如上面代码中的class="myui-combo"，同时myui-options定义了该
    控件的配置属性。</pre>
    		<h3>控件的配置属性</h3>
    		<pre class="pre-text">
           MYUI控件中的配置属性是指在初始化中传入的options参数对象，例如上例中combo控件初始化时，传入了两个配置属性mode（数据模式）和data（本地
    数组数据）两个属性，MYUI控件会自动解析出属性的值并初始化至combo控件中。
           
           有的配置属性会有默认值，当不初始化某个配置属性且该配置属性含有默认值时，MYUI控件会自动将默认值初始化至相应控件中，比如上例中combo控件有
    一个属性panelHeight（下拉框的高度）含有默认值200，但是我们并没有初始化该属性，那么MYUI控件会自动将默认值200作为该属性的值传入，而不需要我们
    设置它，这大大简化了初始化中不必要我们关心的参数，当然若有需要，可以在初始化时赋值来达到我们的需求，比如我要定义下拉框的高度因为200px的高度不
    符合我的要求，那么我们就需要在初始化时除了指定mode和data两个属性之外，还要指定panelHeight属性的值。
           
           属性有不同的数据类型，在初始化时我们需要知道该属性应当传入的数据类型，比如上例中mode的数据类型为字符串型("remote"和"local",分别表示
    数据来自远程请求还是本地)，那么我们传入的值为数组类型就是错误的。同理data属性的数据类型是对象数组，那么我们传入的值为字符串型就是错误的。</pre>
    		<h3>控件的事件调用</h3>
    		<pre class="pre-text">
           在MYUI控件中名还支持事件回调函数，我们需要在这些特殊的配置属性中传入函数而非其他数据类型，例如combo控件中支持当用户选择某一个选项时的
    回调函数，在该事件中我们需要进行一些处理，那么我们就需要在控件初始化中指定自己写的函数作为回调函数。如下所示：</pre>
    		<pre class="brush:js">
$("#test").combo({
	onSelect : function(item){
		alert("我选择了" + item.text + ",值为" + item.value);
	} // 当用户选择某个下拉选项时，弹出提示框
});</pre>
			<pre class="pre-text">
	   在上例中，我们定义了onSelect事件的回调函数，在该函数中，控件会给我们一个名为item的参数，该参数是用户选择的那一项的对象。我们可以使用对象
    访问的形式获得到该对象对应的属性并且做一些业务逻辑处理。</pre>
    		<h3>控件的方法调用</h3>
    		<pre class="pre-text">
           MYUI控件除了支持属性和事件来指定复合自己需要的控件外，还支持一些内置的方法调用，例如combo控件支持在已初始化的控件对象上重新加载数据来
    替换原有的下拉选项，例如：</pre>
    		<pre class="brush:js">
$("#test").combo("loadData",[{text:"Javascript",value:"2"},{text:"Php",value:"3"}]);</pre>
			<pre class="pre-text">
	   以上代码表示将已初始化的控件对象$("#test")重新加载数据替换原有选项。该方法第一个参数"loadData"是控件固有的方法命名控件，表示用户要调用"重
    新加载数据"这一方法，而第二个参数是用户自己传入的要替换的数组数据。在有些方法中不支持第二个参数，比如combo控件中获取当前选择的值的方法，如：</pre>
    		<pre class="brush:js">
var value = $("#test").combo("getValue");//定义变量value并将下拉选择的当前值赋给它</pre>
		<br/>
		</div>
	</div>
</div>
	

</body>
</html>