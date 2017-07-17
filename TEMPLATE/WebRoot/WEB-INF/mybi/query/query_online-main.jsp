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
	<script type="text/javascript"	src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
	<script>
	
	//数据集数对象
	var dsJson;
	
	//ztree相关的js
	var setting = {
		view: {
			//showIcon:false,
			dblClickExpand: false,
			selectedMulti:false
			
		},
		check: {
			enable : true
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
			onCheck: onCheck,
			beforeCheck : function(treeId, treeNode){ 
				if(treeNode.checked && treeId == 'queryContainer') {
					return false;
				}else{
					onClick( null, treeId, treeNode);
					return false;
				}
			},
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
		if((treeNode.type == '8' && treeId == 'dataSetContainer')) {
			treeObj.checkNode(treeNode, treeNode.checked ? false : true, false);
			onCheck(e, treeId, treeNode);
		}else if(treeNode.type == '2' && treeId == 'queryContainer'){
			treeObj.checkNode(treeNode, true, false);
			onCheck(e, treeId, treeNode);
		}
	}
	
	function onCheck(e, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var nodes = treeObj.getCheckedNodes(true);
		
		
		$("#queryList .top-main").find('.operate').empty();
		
		//如果没有选择字段清空页面
		if(nodes.length == 0) {
			$('#queryFrame').attr("src", "");
			return false;
		}
		
		if(treeId == 'dataSetContainer'){
			dsJson = getDatasetJson(nodes);
			//处理默认表连接
			if (dsJson.parids.length > 1 ) {
				$.post("${ctx}/query_dataset!getDatasetDefaultTabjoin.action",{"jsonStr":dsJson.parids.join(',')},function(data){
					var jsonData = JSON.parse(data);
					$.extend(dsJson,{
						"tableJoin" : JSON.stringify(jsonData.data)
					});
					$('#queryFrame').attr("src", "${ctx}/query_online!query.action?edit=true");
				})
			} else {
				$('#queryFrame').attr("src", "${ctx}/query_online!query.action?edit=true");
			}
			dsJson.parids = null;
			$("#queryList .top-main").find('.operate').append('<a href="###"  actionCode="ACTION_QUERY_QUERY_MANAGE" onclick="insertQuery()"><s:text name="保存查询"/></a>');
		}else if(treeId == 'queryContainer'){
			dsJson = JSON.parse(treeNode.dsstr);
			var parent_node = treeNode.getParentNode();
			$("#queryList .top-main").find('.operate').append('<a href="###"  actionCode="ACTION_QUERY_QUERY_SAVEMENU" onclick="insertQuery2Menu(\''+treeNode.id+'\',\''+treeNode.name+'\')"><s:text name="保存为功能"/></a>&nbsp;&nbsp;&nbsp;&nbsp;');
			if(parent_node){
				$("#queryList .top-main").find('.operate').append('<a href="###"  actionCode="ACTION_QUERY_QUERY_MANAGE" onclick="insertQuery(\''+treeNode.id+'\',\''+parent_node.id+'\',\''+parent_node.name+'\',\''+parent_node.pId+'\')"><s:text name="保存查询"/></a>');
			}else{
				$("#queryList .top-main").find('.operate').append('<a href="###"  actionCode="ACTION_QUERY_QUERY_MANAGE" onclick="insertQuery(\''+treeNode.id+'\')"><s:text name="保存查询"/></a>');
			}
			$("#queryList .top-main").find('.operate').append('&nbsp;&nbsp;&nbsp;&nbsp;<a href="###" actionCode="ACTION_QUERY_QUERY_MANAGE" onclick="deleteQuery(\''+treeNode.id+'\', \''+treeNode.name+'\')"><s:text name="删除查询"/></a>');
			$('#queryFrame').attr("src", "${ctx}/query_online!query.action?edit=true&id=" + treeNode.id);
		}
		
		//动作权限过滤
		actionAuthFilter();
	}
	
	function getDatasetJson(nodes){
		var cols = [];
		var v_allParids = [];
		var v_sqlParamList = [];
		var v_parObjArr = [];
		var v_parIdArr = [];
		for(var i=0;i<nodes.length;i++){
			var parentNode = nodes[i].getParentNode();
		//	if(v_parIdArr.indexOf() == -1) {
			if(jQuery.inArray(parentNode.id,v_parIdArr) == -1) {
				v_parObjArr.push(parentNode);
				v_parIdArr.push(parentNode.id);
			}
			if((parentNode.type == 1 || parentNode.type ==2 ) &&  v_allParids.join(',').indexOf(parentNode.id + '@@@' + parentNode.key)==-1) {
				v_allParids.push(parentNode.id + '@@@' + parentNode.key);
			}
			cols.push({
				dsid    : parentNode.id,
				colname : "COL" + i,
				colname_ognl : nodes[i].key,
				coldesc : nodes[i].name,
				datatype: nodes[i].datatype
			});
		}
		
		var v_paramColumnList = [];
		for(var i=0; i<v_parObjArr.length; i++) {
			var v_parObj = v_parObjArr[i];
			if (v_parObj.sqlParamList) {
				var parSqlParam = JSON.parse(v_parObj.sqlParamList);
				for(var j=0; j<parSqlParam.length; j++) {
					v_paramColumnList.push({
						 id          : parSqlParam[j].param + i + j,
						 dsid        : v_parObj.id,
						 name        : parSqlParam[j].param,
						 desc        : parSqlParam[j].desc,
						 sqldefval   : parSqlParam[j].defval,
						 defaultVal  : parSqlParam[j].defval,
						 value       : '',
						 partyp      : 'sql'
					});
				}
			}
		}
		
		var obj = {
				opts   : {},
				cols   : cols,
				parids : v_allParids
		}
		if(v_paramColumnList.length>0) {
			obj.paramColumnList = v_paramColumnList;
		}
		
		return obj;
	}
	
	/**
	 * 加载数据集树
	 */
	var zTree_dataset;
	function loadDatasetZTree(p_isInit){
		add_onload();//开启蒙板层
		setting.check.chkStyle = "checkbox";
		$.getJSON("${ctx}/query_dataset!getDatasetTree.action",{},function(data){
			$.fn.zTree.init($("#dataSetContainer"), setting, data);
			zTree_dataset = $.fn.zTree.getZTreeObj("dataSetContainer");
			zTree_dataset.cancelSelectedNode();//取消当前所有选中的节点
			treeNode_ = null;
			clean_onload();//关闭蒙板层
			if(p_isInit) {
				initQueryFrame();
			}
			$("#treeObj .top-main").find('.operate').append('<img class="datasetManage"  actionCode="ACTION_QUERY_DATASET_MANAGE" onclick="datasetManageWin()" src="${ctx}/mybi/common/themes/${apptheme}/images/icons/set.png"></img>');
			
			//动作权限过滤
			actionAuthFilter();
		});
	}
	
	/**
	 * 加载数据集树
	 */
	var zTree_query;
	function loadQueryZTree(p_isInit){
		add_onload();//开启蒙板层
		setting.check.chkStyle = "radio";
		setting.check.radioType  = "all";
		$.getJSON("${ctx}/query_online!getQueryTree.action",{},function(data){
			$.fn.zTree.init($("#queryContainer"), setting, data);
			zTree_query = $.fn.zTree.getZTreeObj("queryContainer");
			zTree_query.cancelSelectedNode();//取消当前所有选中的节点
			zTree_query.expandAll(true);
			treeNode_ = null;
			clean_onload();//关闭蒙板层
			if(p_isInit) {
				initQueryFrame();
			}
			if ("${request.id}" != null && "${request.id}" != "") {
				var node = zTree_query.getNodeByParam("id", "${request.id}");
				zTree_query.selectNode(node);
				zTree_query.checkNode(node, true, true, true);
			}
		});
	}
	
/*	function addDataset(){
		$("#addDatasetWin").window({
			open : true,
			headline:'条件控件配置',
			content:'<iframe id="myframe" src="${ctx}/query_dataset!toAdd.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:350
		});
	}*/
	
	$(document).ready(function(){
		if ("${request.id}" != null && "${request.id}" != "") {
			setTabSelectedByTab($(".tabcontent").eq(1));
			$(".tabcontent").eq(1).click();
		}else {
			loadDatasetZTree("");
		}
	});
	
	/**
	 * @param p_typ 加载类型 dataset,query
	 * @param p_isInit 是否刷新查询页面
	 */
	function loadZTree(p_typ, p_isInit){
		if(p_isInit == null) {
			p_isInit = true;
		}
		if (p_typ == 'dataset') {
			loadDatasetZTree(p_isInit);
		} else if(p_typ == 'query'){
			loadQueryZTree(p_isInit);
		}
	}
	
	function insertQuery(p_qid,p_qparentid,p_qparentname,p_qparentpid){
		if(!dsJson){
			$.messager.alert('<s:text name="common_msg_info"/>','请先选择数据集或者选择查询列表','info');//没有选择记录
			return false;
		}
		var parentObj = {
        		id   : p_qparentid,
        		pId  : p_qparentpid && p_qparentpid != 'null' ? p_qparentpid : "-1" ,
        		name : p_qparentname
        	};
		var v_param = {
				id          : p_qid,
				parentObj   : parentObj,
				dsJson      : JSON.stringify(dsJson),
				dgcase      : queryFrame.window.getcase()
		}
		
		$("#addQueryWin").window({
			open : true,
			param :v_param,
			headline:'保存在线查询',
			content:'<iframe id="addQueryFrame" src="${ctx}/query_online!toQueryAdd.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:460,
			panelHeight:380
		});
	}
	
    function insertQuery2Menu(p_qid, p_qname){
        var v_param = {
        		qid   : p_qid,
        		qname : p_qname
        }
    	$("#addQuery2MenuWin").window({
			open : true,
			param :v_param,
			headline:'保存在线查询',
			content:'<iframe id="addQueryFrame" src="${ctx}/query_online!toAddQuery2Menu.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:460,
			panelHeight:350
		});
    }
	
	function loadcase(){
		var param = top.$('body').attr('value');
		var rst = $('.myui-datagrid2').datagrid2('loadCase',param);
	}
	
	
	function deleteQuery(p_qid, p_qname){
		$.messager.confirm2('<s:text name="common_msg_info"/>', "是否删除("+p_qname+")查询", function(){	
			$.post("${ctx}/query_online!deleteQuery.action", {"query_main.id" : p_qid},function(data){
				var jsondata = JSON.parse(data);
				if(jsondata.result == 'succ'){
					$.messager.alert('<s:text name="common_msg_info"/>','删除成功','info', function(){
						loadZTree("query");
						initQueryFrame();
					});
					
				}else{
					$.messager.alert('<s:text name="common_msg_info"/>','删除失败','error', function(){
						
					});
				}
			});
		});
	}
	
	function refreshNodeById(p_id){
		add_onload();//开启蒙板层
		setting.check.chkStyle = "checkbox";
		$.getJSON("${ctx}/query_dataset!getDatasetTree.action",{},function(data){
			$.fn.zTree.init($("#dataSetContainer"), setting, data);
			zTree_dataset = $.fn.zTree.getZTreeObj("dataSetContainer");
			zTree_dataset.cancelSelectedNode();//取消当前所有选中的节点
			treeNode_ = null;
			clean_onload();//关闭蒙板层
			initQueryFrame();
			$("#treeObj .top-main").find('.operate').append('<img class="datasetManage" actionCode="ACTION_QUERY_DATASET_MANAGE" onclick="datasetManageWin()" src="${ctx}/mybi/common/themes/${apptheme}/images/icons/set.png"></img>');
			var treeObj = $.fn.zTree.getZTreeObj("dataSetContainer");
			var v_node = treeObj.getNodeByParam("id", p_id);
			treeObj.expandNode(v_node, true, false, true);
			//动作权限过滤
			actionAuthFilter();
		});
	}
	
	function datasetManageWin(){
		$("#datasetManageWin").window({
			open : true,
			headline:'数据源管理',
			content:'<iframe id="datasetManageFrame" src="${ctx}/query_dataset!toManage.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:900,
			panelHeight:450
		});
	}
	
	function unCheckALl(){
		zTree_dataset.checkAllNodes(false);
		$('#queryFrame').attr("src", "");
		$("#queryList .top-main").find('.operate').empty();
	}
	
	function initQueryFrame(){
		$('#queryFrame').attr("src", "");
		$("#queryList .top-main").find('.operate').empty();
		$("#treeObj .top-main").find('.operate').empty();
	}
</script>
<style>
.orgidt_input_select_input_div{font-family: 微软雅黑;height:25px;margin:0;position: relative;width:100%;}
.orgidt_input_select_input_div input{width:99%;height: 25px}
.search_ico_div{ 
	background: url("${ctx}/mybi/common/themes/default/images/search.png");
	background-repeat:no-repeat;
	background-position:center center;
	position:absolute;                
	width:20px;                
	height:25px;                
	top:0px;                
	right:1px;
	z-index:99;
	cursor:pointer;
}
.myui-datagrid2{margin-top: 20px}
.dataSetOper{font-family:"微软雅黑"; font-size:12px;margin-left: 5px;margin-top: 5px}
.dataSetOper a{color:#374fff;}
.datasetManage{cursor: pointer;margin-top: 10px}
</style>
</head>
<body style="height:670px;">
	<div id="addQueryWin"></div>
	<div id="datasetManageWin"></div>
	<div id="addQuery2MenuWin"></div>
	<div class="myui-layout">
		<div class="rowgroup">
		
			<div class="tabs" id="treeObj" style="width: 260px;height: 620px">
				<div class="operate">
					<ul class = "datasetOper">
					</ul>
				</div>
				<div class="tabcontent"  onclick="loadZTree('dataset')"  headline="数据源" selected="true">
					<div style="width:255px;margin-top:3px;overflow: auto;height:580px">
						<div class="dataSetOper"><a href="###" onclick="unCheckALl()">清空选择</a></div>
						<ul id="dataSetContainer" class="ztree"></ul>
					</div>
				</div>
				<div class="tabcontent"   onclick="loadZTree('query')" title="查询目录">
					<div style="width:255px;margin-top:3px;overflow: auto;height:580px">
						<ul id="queryContainer" class="ztree"></ul>
					</div>
				</div>
			</div>
				
			<div class="content" id="queryList" headline="查询列表" style="width: 940px;height: 620px">
				<div class="operate">
					<ul class = "queryOper">
					</ul>
				</div>
				<iframe id="queryFrame" name="queryFrame" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />
				<!--table class="myui-datagrid2" id="querylist"  myui-options="url:'${ctx}/query_online!query.action',multiSort:true,isAutoBuild:false,showColumn:true,showFilters:true,showParamOperate:true,exportUrl:'${ctx}/query_online!queryExport.action',exportFileName:'飒飒大师',exportFileType:'xlsx'" width="900px" height="350px"></table-->
			</div>
		</div>
	</div>
</body>
</html>