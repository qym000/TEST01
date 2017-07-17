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
	var ids_role=parent.opener.getIdFieldsOfChecked();
	var setting = {
		view:{
			showIcon: false
		},
		check: {
			enable: true,
			chkStyle: "checkbox",
			chkboxType: { "Y": "s", "N": "s" },
			chkStyle : "checkbox"
			
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		async: {
			enable: true,
			url:"pim_res-org!findResList.action",
			otherParam: ["ids_role", ids_role],					
			autoParam:["id"],
			dataFilter: filter
		}
	};
	
	$(function(){
		add_onload();//开启蒙板层
		
		$.fn.zTree.init($("#orgTree"), setting); 
		
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
		//被选中的角色
		//var ids_role=parent.opener.getIdFieldsOfChecked();
		
		var orgTree=$.fn.zTree.getZTreeObj("orgTree");
		var o_nodes = orgTree.getCheckedNodes(true);
		
		var ids_orgidt="";
		for(i=0;i<o_nodes.length;i++){
			ids_orgidt+=o_nodes[i].id+",";
		}
		
		add_onload();//开启蒙板层
		$.post("pim_res-org!assignResList.action",{ids_role:ids_role,ids_orgidt:ids_orgidt},function(data){ 
			if(data.result=="succ"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info',function(){ //添加成功
    			});
			}else if(data.result=="fail"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info'); //添加失败
			}
			
			clean_onload();//关闭蒙板层
        },"json"); 
	}
    
    //
    function chg(){
    	var tmp = $("#ty").attr("checked")? "s":"";
    	var orgTree=$.fn.zTree.getZTreeObj("orgTree");
    	orgTree.setting.check.chkboxType = { "Y" : tmp, "N" : tmp };
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
		<div  class="myui-datagrid" style="width:100%;height:35px;overflow:auto;">	
			<table style="width:100%;border-top-width:0px;align:left;">
				<tr>
					<th style="text-align:left;">&nbsp;&nbsp;&nbsp;<input type="checkbox" id="ty" onchange="chg()" checked>&nbsp;级联勾选下级</th>
				</tr>
			</table>
		 </div>
		
		
		<div  class="myui-datagrid" style="width:100%;height:500px;overflow:auto;">
			<ul id="orgTree" class="ztree"></ul>
		</div>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()" style="margin-left:20px;float:left;"><s:text name="common_action_submit"/></a>
	</div>
</div>

</body>

</html>