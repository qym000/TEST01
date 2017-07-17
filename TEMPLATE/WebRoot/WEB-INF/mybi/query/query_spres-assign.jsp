<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.core-3.2.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.excheck-3.2.min.js"></script>
<script type="text/javascript">
	var ids_user=parent.opener.getIdFieldsOfChecked();
	var gv_restyp;
	//ztree相关的js
	var setting = {
		view: {
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
		}
	};
	
	$(function(){
		gv_restyp = parent.$('.select_selected').attr('id').replace('tab_res_', '');
		add_onload();//开启蒙板层
		loadZTree(); 
		clean_onload();//关闭蒙板层
	});
	
	/**
	 * 点击事件
	 */
	var treeNode_ = null;
	
	/**
	 * 加载数据集树
	 */
	var zTree_obj;
	function loadZTree(){
		add_onload();//开启蒙板层
		$.getJSON("${ctx}/query_security!findSpResList.action",{"ids_user": ids_user, "restyp" : gv_restyp},function(data){
			$.fn.zTree.init($("#treeContainer"), setting, data);
			zTree_obj = $.fn.zTree.getZTreeObj("treeContainer");
			zTree_obj.cancelSelectedNode();//取消当前所有选中的节点
			treeNode_ = null;
			clean_onload();//关闭蒙板层
		});
	}
	
    
    //提交分配
    function sbt(){
		//被选中的角色
		//var ids_role=parent.opener.getIdFieldsOfChecked();
		
		var dsTree=$.fn.zTree.getZTreeObj("treeContainer");
		var o_nodes = dsTree.getCheckedNodes(true);
		
		var obj_ids="";
		for(i=0;i<o_nodes.length;i++){
			obj_ids+=o_nodes[i].id+",";
		}
		add_onload();//开启蒙板层
		$.post("query_security!assignSpResList.action",{ids_user : ids_user, obj_ids : obj_ids, restyp : gv_restyp},function(data){ 
			if(data.result=="succ"){
				//添加成功
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info');
			}else{
				//添加失败
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info'); 
			}
			
			clean_onload();//关闭蒙板层
        },"json"); 
	}
    
    //关闭当前窗口
    function clsWin(){
    	//parent.parent.$('#inputWin').window({open:false});
    	parent.parent.$('#inputWin').window("close");
    }
</script>
</head>
<body style="height:600px;">

<div class="myui-form">
	<div class="form" style="width:100%;overflow-x:hidden;">
		<div  class="myui-datagrid" style="width:100%;height:500px;overflow:auto;">
			<ul id="treeContainer" class="ztree"></ul>
		</div>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()" style="margin-left:20px;float:left;"><s:text name="common_action_submit"/></a>
	</div>
</div>

</body>

</html>