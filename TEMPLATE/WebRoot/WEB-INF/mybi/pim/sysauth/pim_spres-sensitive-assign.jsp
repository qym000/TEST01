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
	//选中的用户
	var ids_user=parent.opener.getIdFieldsOfChecked();
	//zTree设置
	var setting = {
		view:{
			showIcon: false
		},
		check: {
			enable: true,
			chkStyle: "checkbox",
			chkboxType: { "Y": "", "N": "" },
			chkStyle : "checkbox"
			
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		async: {
			enable: true,
			url:"pim_sensitive-info!findSpresList.action",
			otherParam: ["ids_user", ids_user],					
			autoParam:["id"],
			dataFilter: filter
		}
	};
	
	
	$(function(){
		add_onload();//开启蒙板层
		
		$.fn.zTree.init($("#objTree"), setting); 
		
		clean_onload();//关闭蒙板层
	});
	
	function filter(treeId, parentNode, childNodes) {
		if (!childNodes) return null;
		for (var i=0, l=childNodes.length; i<l; i++) {
			childNodes[i].name = childNodes[i].name.replace('','');
		}
		return childNodes;
	}
	
    
    //提交分配
    function sbt(){
		var objTree=$.fn.zTree.getZTreeObj("objTree");
		var o_nodes = objTree.getCheckedNodes(true);
		
		var ids_sensitive="";
		for(i=0;i<o_nodes.length;i++){
			ids_sensitive+=o_nodes[i].id+",";
		}
		
		add_onload();//开启蒙板层
		$.post("pim_sensitive-info!assignSpresList.action",{ids_user:ids_user,ids_sensitive:ids_sensitive},function(data){ 
			if(data.result=="succ"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info',function(){ //添加成功
    			});
			}else if(data.result=="fail"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info'); //添加失败
			}
			
			clean_onload();//关闭蒙板层
        },"json"); 
	}
    
    //关闭当前窗口
    function clsWin(){
    	parent.parent.$('#inputWin').window("close");
    }
</script>
</head>
<body style="height:600px;">

<div class="myui-form">
	<div class="form" style="width:100%;overflow-x:hidden;">
		<div  class="myui-datagrid" style="width:100%;height:560px;overflow:auto;">
			<ul id="objTree" class="ztree"></ul>
		</div>
	</div>
	<div class="operate">
		<a class="button" href="javascript:void(0);" onclick="sbt()" style="margin-left:20px;float:left;"><s:text name="common_action_submit"/></a>
	</div>
</div>

</body>
</html>