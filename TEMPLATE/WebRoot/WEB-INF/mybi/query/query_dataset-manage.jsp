<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"
	rel="stylesheet" type="text/css" />
<link
	href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
	<script>
	
	//文件夹
	var folderNode;
	
	//ztree相关的js
	var setting = {
		view: {
			//showIcon:false,
			dblClickExpand: false,
			selectedMulti:false
		},
		check: {
			enable : false
		},
		data: {
			key:{
				title: "title"
			},
			simpleData: {
				enable: true
			}
		},
		
		edit:{
			enable:false,
			showRemoveBtn:false,
			showRenameBtn:false,
			drag:{
				isMove:false
			}
		},
		
		callback: {
			onClick: onClick,
			beforeDrag: false,
			beforeDrop: false
		}
	};
	
	/**
	 * 点击事件
	 */
	var treeNode_ = null;
	function onClick(e, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		initDatasetFrame();
		if(treeNode.type != '0'){
			folderNode = treeNode.getParentNode();
			$('#datasetFrame').attr("src", "${ctx}/query_dataset!toInput.action?query_dataset.id="+treeNode.id);
		}else{
			folderNode = treeNode.getParentNode();
			$('#datasetFrame').attr("src", "${ctx}/query_dataset!toInput.action?query_dataset.id="+treeNode.id);
		}
	}
	
	/**
	 * 加载数据集树
	 */
	var zTree_dataset;
	function loadDatasetZTree(){
		add_onload();//开启蒙板层
		setting.check.chkStyle = "checkbox";
		$.getJSON("${ctx}/query_dataset!getDatasetManageTree.action",{},function(data){
			$.fn.zTree.init($("#datasetContainer"), setting, data);
			zTree_dataset = $.fn.zTree.getZTreeObj("datasetContainer");
			zTree_dataset.cancelSelectedNode();//取消当前所有选中的节点
			treeNode_ = null;
			clean_onload();//关闭蒙板层
		});
	}
	
	$(document).ready(function(){
		loadDatasetZTree("");
	});
	
/*	function datasetManageWin(){
		$("#datasetManageWin").window({
			open : true,
			headline:'数据集管理',
			content:'<iframe id="datasetManageFrame" src="${ctx}/query_dataset!toManage.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:400,
			panelHeight:250
		});
	}*/
	
	function toAddDataset(){
		var treeObj = $.fn.zTree.getZTreeObj("datasetContainer");
		var nodes = treeObj.getSelectedNodes();
	/*	if(nodes.length == 0){
			$.messager.alert('<s:text name="common_msg_info"/>','请在树中选中添加节点','info');
			return false;
		}*/
		
		if(nodes[0] && nodes[0].type != 0){
			$.messager.alert('<s:text name="common_msg_info"/>','请选择文件夹','info');
			return false;
		}
		
		folderNode = nodes[0];
		$('#datasetFrame').attr("src", "${ctx}/query_dataset!toInput.action");
	}
	
	function refreshNodeById(p_id){
		add_onload();//开启蒙板层
		$.getJSON("${ctx}/query_dataset!getDatasetManageTree.action",{},function(data){
			$.fn.zTree.init($("#datasetContainer"), setting, data);
			zTree_dataset = $.fn.zTree.getZTreeObj("datasetContainer");
			zTree_dataset.cancelSelectedNode();//取消当前所有选中的节点
			treeNode_ = null;
			clean_onload();//关闭蒙板层
			var treeObj = $.fn.zTree.getZTreeObj("datasetContainer");
			var v_node = treeObj.getNodeByParam("id", p_id);
			treeObj.expandNode(v_node, true, false, true);
		});
	}
	
	function initDatasetFrame(){
		$('#datasetFrame').attr("src", "");
	}
</script>
<style>
.myui-layout{margin-top:10px;margin-left:10px;}
</style>
</head>
<body>
	<div class="myui-layout">
		<div class="rowgroup">
			
			<div class="content" id="datasetTree" headline="数据源" style="width: 220px;height: 400px">
				<div class="operate">
					<ul>
						<li><a href="###" onclick="toAddDataset()">添加</a></li>
					</ul>
				</div>
				<div style="width:215px;margin-top:3px;overflow: auto;height:358px">
						<ul id="datasetContainer" class="ztree"></ul>
				</div>
			</div>
			
				
			<div class="content" id="datasetManage" headline="查询列表" style="width: 650px;height: 400px;overflow:auto">
				<iframe id="datasetFrame" name="datasetFrame" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow: hidden" />
			</div>
		</div>
	</div>
</body>
</html>