<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"	rel="stylesheet" type="text/css" />
<link rel="stylesheet"	href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<script type="text/javascript">
	var setting = {
		data: {
			simpleData: {
				enable: true // 使用id和pId的简单数据格式
			}
		},			
		async: {
			enable: true, // 启用异步请求节点数据
			url:"demo_myui!getDemoTree.action" // 异步请求url
		},
		callback : {
			onClick : zTreeOnClick, // 点击demo节点
			onAsyncSuccess : ztreeOnAsyncSuccess // 加载树成功后事件
		}	
	}

	$(function() {
		add_onload();//开启蒙板层

		$.fn.zTree.init($("#demoTree"), setting);
		
		clean_onload();//关闭蒙板层
	});

	//zTree专用filter
	function filter(treeId, parentNode, childNodes) {
		if (!childNodes)
			return null;
		for ( var i = 0, l = childNodes.length; i < l; i++) {
			childNodes[i].name = childNodes[i].name.replace('', '');
		}
		return childNodes;
	}

	//zTree节点点击触发
	function zTreeOnClick(event, treeId, treeNode) {
		$("#api").attr("src","demo_myui!toApiContent.action?id=" + treeNode.id);
	}
	
	// 加载树成功后自动跳转第一个节点指向
	function ztreeOnAsyncSuccess(event,treeId,treeNode,msg) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var nodes = treeObj.getNodes();
		if (nodes != null && nodes.length > 0) {
			$("#api").attr("src", "demo_myui!toApiContent.action?id=" + nodes[0].id)
		}
	}

</script>
</head>
<body style="height: 670px;">
<div class="myui-layout">
	<div class="rowgroup">
		<div class="content" style="width:250px;height:672px;" title="Demo列表">
			<div style="width:230px;">
				<ul id="demoTree" class="ztree"></ul>
			</div>
		</div>
		<iframe id="api" name="api" style="width:965px;height:680px" frameborder="0" scrolling="no"></iframe>
	</div>
</div>
	

<div id="inputWin"></div>
</body>
</html>