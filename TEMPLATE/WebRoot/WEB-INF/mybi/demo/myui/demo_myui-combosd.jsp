<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title></title>
<link href="${ctx}/mybi/common/scripts/syntaxHighlighter/styles/shCoreEclipse.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"	rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/demo/themes/${apptheme}/demo-myui.css"	rel="stylesheet" type="text/css" />
<link rel="stylesheet"	href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shCore.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJScript.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<script type="text/javascript">
	$(function() {
		initDemo();
	    SyntaxHighlighter.all();
	});
	
	// 初始化演示效果
	function initDemo() {
		var setting = {
			view: {
				dblClickExpand: false,
				showIcon:true
			},
			callback: {
				onClick: onClickNode
			}
		};
			

		var nodes = [{
			name : "网站导航",
			open : true,
			id : "0",
			children : [{
				name : "google",
				id : "1"
			}, {
				name : "sina",
				id : "2"
			}, {
				name : "baidu",
				id : "3"
			}]
		}];
		
		$("#test").comboSD({
			autoHide : false,
			showBtnZone:true, //是否显示自定义按钮区域
			buttons:[{
					position : "right",
					id : "clearBtn",
					name : "清空",
					onClickBtn : function (tg) {
						$(this).comboSD("reload");
					}},{
					position : "right",
					id : "closeBtn",
					name : "关闭",
					onClickBtn : function (tg) {
						$(this).comboSD("closePanel");
					}},{
					position : "left",
					id : "myBtn",
					name : "设置",
					onClickBtn : function (tg) {
						$(this).comboSD("setText","yahoo");
					}}],// 自定义的按钮
			panelHeight : 250,
			panelWidth : 200,
			initPanelContent : function(panelObj) {
				var html = "<ul id='tree' class='ztree' style='width:170px;overflow:auto;'></ul>";
				$(panelObj).append(html);
				zTreeObj = $.fn.zTree.init($("#tree"),setting, nodes);
			} // 初始化panel,自定义
		});
	}
	
	function onClickNode(event,treeId,treeNode) {
		$("#test").val(treeNode.name);
	}
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="linegroup">
		<div class="content" style="width:960px;height:125px;"  title="myui-comboSD效果展示">
			<!-- 此区域为效果展示 -->
			<div style="padding:25px;">
				<input id="test" name="test"/>
			</div>
		</div>
		<div class="tabs" style="width:960px;height:537px" title="myui-comboSD使用文档" position="right">
			<div class="tabcontent" title="代码" selected="true">
<pre class="pre-text">
          在myui-comboSD中，可以与其他控件进行组合使用，列如上面的demo中，我们除了初始化了一个comboSD控件外，同时将ztree控件一并显示在
   comboSD的面板中。</pre>
<pre class="brush: js">
var setting = {
	view: {
		dblClickExpand: false,
		showIcon:true
	},
	callback: {
		onClick: onClickNode
	}
};

var nodes = [{
	name : "网站导航",
	open : true,
	id : "0",
	children : [{
		name : "google",
		id : "1"
	}, {
		name : "sina",
		id : "2"
	}, {
		name : "baidu",
		id : "3"
	}]
}];
		
$("#test").comboSD({
	autoHide : false,
	showBtnZone:true, //是否显示自定义按钮区域
	buttons:[{
		position : "right",
		id : "clearBtn",
		name : "清空",
		onClickBtn : function (tg) {
			$(this).comboSD("reload");
		}},{
		position : "right",
		id : "closeBtn",
		name : "关闭",
		onClickBtn : function (tg) {
			$(this).comboSD("closePanel");
		}},{
		position : "left",
		id : "myBtn",
		name : "设置",
		onClickBtn : function (tg) {
			$(this).comboSD("setText","yahoo");
		}}],// 自定义的按钮
	panelHeight : 250,
	panelWidth : 200,
	initPanelContent : function(panelObj) {
		var html = "&lt;ul id='tree' class='ztree' style='width:170px;overflow:auto;'>&lt;/ul>";
		$(panelObj).append(html);
		zTreeObj = $.fn.zTree.init($("#tree"),setting, nodes);
	} // 初始化panel,自定义
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
						<td>showBtnZone</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否显示面板按钮</td>
					</tr>
					<tr>
						<td>buttons</td>
						<td>JS Array</td>
						<td>null</td>
						<td class="table-desc">面板按钮定义，当showBtnZone为true时有效，自定义按钮包括位置，id，name，点击事件。例如：buttons:[{position : "right",id : "sbtBtn",name : "确定",onClickBtn : function (tg) {//点击按钮的逻辑}}]</td>
					</tr>
					<tr>
						<td>stopPropagation</td>
						<td>Boolean</td>
						<td>true</td>
						<td class="table-desc">点击panel是否取消事件冒泡</td>
					</tr>
					<tr>
						<td>panelHeight</td>
						<td>Number</td>
						<td>200</td>
						<td class="table-desc">下拉框panel的高度</td>
					</tr>
					<tr>
						<td>panelWidth</td>
						<td>Number</td>
						<td>与input框宽度一致</td>
						<td class="table-desc">下拉框panel的宽度</td>
					</tr>
					<tr>
						<td>disabled</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">是否禁用</td>
					</tr>
					<tr>
						<td>editable</td>
						<td>Boolean</td>
						<td>false</td>
						<td class="table-desc">input框是否可编辑</td>
					</tr>
					<tr>
						<td>autoHide</td>
						<td>Boolean</td>
						<td>true</td>
						<td class="table-desc">当该控件失去焦点时是否自动隐藏下拉框</td>
					</tr>
					<tr>
						<td>scrollTarget</td>
						<td>String/jQuery DOM Object</td>
						<td>'body'</td>
						<td class="table-desc">滚动定位的对象</td>
					</tr>
					<tr>
						<td>initPanelContent</td>
						<td>Function</td>
						<td>Null</td>
						<td class="table-desc">自定义panel内容初始化函数</td>
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
						<td>onClickPanel</td>
						<td>jQuery DOM Object</td>
						<td class="table-desc">点击下拉选择框penel区域时触发的事件</td>
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
						<td>getInnerPanel</td>
						<td>jQuery DOM Object</td>
						<td>void</td>
						<td class="table-desc">获取可使用内部div DOM对象</td>
					</tr>
					<tr>
						<td>closePanel</td>
						<td>void</td>
						<td>void</td>
						<td class="table-desc">关闭panel</td>
					</tr>
					<tr>
						<td>setText</td>
						<td>void</td>
						<td>String</td>
						<td class="table-desc">设置文本框内容</td>
					</tr>
					<tr>
						<td>reload</td>
						<td>void</td>
						<td>void</td>
						<td class="table-desc">重新加载用户定制的panel内容</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
	

</body>
</html>