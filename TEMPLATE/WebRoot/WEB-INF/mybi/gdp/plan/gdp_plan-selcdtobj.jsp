<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link type="text/css" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<script type="text/javascript">
	var setting = {
		treeId:'cdtObjTree',	
		check: {
			enable: true
		},
		data: {
			simpleData: {
				enable: true
			}
		}
	};
	$(function(){
		// 初始化页面元素及表单验证
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		$.fn.zTree.init($("#cdtObjTree"), setting, ${request.cdtTreeNodes}); 
		// 禁用check初始化
		var treeObj = $.fn.zTree.getZTreeObj("cdtObjTree");
		if (treeObj != null) {
			var objs = $("#cdtTab tr",parent.document);
			if (objs != null && objs.length > 0) {
				for (var i = 0; i < objs.length; i++) {
					var node = treeObj.getNodeByParam("id",$(objs[i]).attr("val"),null);
					if (node != null) {
						treeObj.setChkDisabled(node, true);
					}
				}
			}
		}
	}
	
	// 表单提交
	function sbt(){
		var arr = [];
		var treeObj = $.fn.zTree.getZTreeObj("cdtObjTree");
		if (treeObj != null) {
			var nodes = treeObj.getCheckedNodes(true);
			if (nodes != null) {
				for (var i = 0; i < nodes.length; i++) {
					var obj = {};
					obj.id = nodes[i].id;
					obj.name = nodes[i].name;
					arr.push(obj);
				}
			}
		}
		parent.window.appendCdtHtm(arr,"${request.eventId}");
		clsWin();
	}
	
	// 关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
</script>
</head>
<body>

<div class="myui-form">
	<div class="form">
		<div style="height:360px;padding:0px;margin:5px;overflow:auto;border:1px solid #E5E5E5" id="cdtObjTree" class="ztree"></div>
	</div>
	<div class="operate">
		<!-- 提交 -->
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<!-- 取消 -->
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>
