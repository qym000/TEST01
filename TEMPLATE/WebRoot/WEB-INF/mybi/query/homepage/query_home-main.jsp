<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/query/themes/${apptheme}/query_home.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.core-3.2.min.js"></script>
<style type="text/css">

</style>

<script type="text/javascript">
var queryTitle = "我的目录";
var keyword = "";
var parentId = "";
var curMenu = null, zTree_Menu = null;
var setting = {
	async: {
		enable: true, // 启用异步请求节点数据
		url:"query_homepage!loadMenuTree.action" // 异步请求url
	},
	view: {
		showLine: false,
		showIcon: false,
		selectedMulti: false,
		dblClickExpand: false,
		showTitle: false,
		nameIsHTML: true,
		addDiyDom: addDiyDom
	},
	data: {
		simpleData: {
			enable: true
		}
	},
	callback : {
		onClick : zTreeOnClick
	}
};

function refreshMenuTree() {
	var treeObj = $("#treeDemo");
	$.fn.zTree.init(treeObj, setting);
}

function zTreeOnClick(event, treeId, treeNode) {
	var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
	if (treeNode.level > 0) {
		treeObj.expandNode(treeNode);
	}
	queryTitle = treeNode.desc;
	keyword = "";
	parentId = treeNode.id;
	$("iframe[name='myframe']").attr("src", "${ctx}/query_homepage!toSelect.action");
}

function addDiyDom(treeId, treeNode) {
	var spaceWidth = 8;
	var switchObj = $("#" + treeNode.tId + "_switch"),
	icoObj = $("#" + treeNode.tId + "_ico");
	switchObj.remove();
	icoObj.before(switchObj);
	
	if (treeNode.level > 1) {
		var spaceStr = "<span style='display: inline-block;width:" + (spaceWidth * treeNode.level)+ "px'></span>";
		switchObj.before(spaceStr);
	}
	icoObj.remove();
}

$(function(){
	var treeObj = $("#treeDemo");
	$.fn.zTree.init(treeObj, setting);
	zTree_Menu = $.fn.zTree.getZTreeObj("treeDemo");
	//curMenu = zTree_Menu.getNodes()[0].children[0].children[0];
	//zTree_Menu.selectNode(curMenu);
	treeObj.addClass("showIcon");
	$("#search").bind("keyup", function(e){
		if (e.keyCode == 13 && $.trim($("#search").val()) != "") {
			var tObj = $.fn.zTree.getZTreeObj("treeDemo");
			var nodes = tObj.getSelectedNodes();
			if (nodes.length == 0) {
				queryTitle = "在“我的目录”检索“" + getKeywordShow() + "”";
				parentId = "2";
			}else {
				queryTitle = "在“" + nodes[0].desc + "”检索“" + getKeywordShow() + "”";
				parentId = nodes[0].id;
			}
			keyword = $.trim($("#search").val());
			$("iframe[name='myframe']").attr("src", "${ctx}/query_homepage!toSelect.action");
		}else if (e.keyCode == 13 && $.trim($("#search").val()) == "") {
			var tObj = $.fn.zTree.getZTreeObj("treeDemo");
			var nodes = tObj.getSelectedNodes();
			if (nodes.length == 0) {
				queryTitle = "我的目录";
				parentId = "2";
			}else {
				queryTitle = nodes[0].desc;
				parentId = nodes[0].id;
			}
			keyword = "";
			$("iframe[name='myframe']").attr("src", "${ctx}/query_homepage!toSelect.action");
		}
	});
});

function getKeywordShow() {
	var tmp = $.trim($("#search").val());
	if (tmp.length > 20) {
		tmp = tmp.substring(0,20) + "...";
	}
	return tmp; 
}

</script>
</head>
<body style="height:655px;">
<div class="myui-layout">
  <div class="rowgroup">
    <div class="content" style="width:280px;height:660px;background-color:#FBFBFB" title="工作目录">
      <div style="width:265px;padding:10px 5px 0px;color:#666;">
        <input id="search" value="检索" onfocus="this.value='';" onblur="this.value='检索'" style="width:235px;height:25px;margin-right:5px;border-radius:5px;border:1px solid #D2D2D2;padding-left:5px;color:#666;vertical-align:middle;outline:none;"/><i class="fa fa-search fw"></i>
      </div>
      <div style="width:275px;">
        <ul id="treeDemo" class="ztree"></ul>
      </div>
    </div>
    <iframe name="myframe" src="${ctx}/query_homepage!toWelcome.action" style="width:915px;height:665px" frameborder="0" scrolling="no"></iframe>
  </div>
</div>
</body>
</html>