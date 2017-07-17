<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<script type="text/javascript">

    var v_winParam;
    var v_menu;
	function sbt(){
		var v_pid = $("#menu").popselector("getValue");
		
		var v_qid = v_winParam.qid;
		if(!v_pid) {
			$.messager.alert('<s:text name="common_msg_info"/>','请选择上级功能','error');
			return false;
		}
		
		if($('#name').val() == '') {
			$.messager.alert('<s:text name="common_msg_info"/>','菜单名称不能为空','error');
			return false;
		}
		var v_param = {
				"menuObj.id"   : v_menu.id,
				"menuObj.pid"  : v_pid,
				"queryId"      : v_qid,
				"menuObj.nam"  : encodeURI($('#name').val(),"utf-8")
		}
		$.getJSON("${ctx}/query_online!saveOrUpdateMenuObj.action",v_param,function(data){
			if(data.result == 'succ'){
				$.messager.alert('<s:text name="common_msg_info"/>','操作成功','info', function(){
					clsWin();
				});
			} else {
				$.messager.alert('<s:text name="common_msg_info"/>','操作失败','error', function(){
					clsWin();
				});
			}
		});
	}
	
	$(function(){
		var v_opts = parent.$('#addQuery2MenuWin').window('options');
		v_winParam  = v_opts.param;
		$('#name').val(v_winParam.qname);
		initMenu(v_winParam.qid);
	})
	
	function initMenu(p_qid){
		$.getJSON("${ctx}/query_online!findMenuList.action",{id : p_qid},function(data){
			$("#menu").popselector({
				  type : "tree-radio",
				  data : data.list,
				  winTitle : "选择菜单",
				  winHeight : 240,
				  winWidth : 350,
				  winTop : 15,
				  treeShowIcon : false,
				  defaultValue :　data.queryMenu.pId
			});
			v_menu = data.queryMenu;
			if(data.queryMenu.name) {
				$('#name').val(data.queryMenu.name);
			}
		});
	}
	
		//关闭当前窗口
    function clsWin(){
    	parent.$('#addQuery2MenuWin').window('close');
    }
	
</script>
</head>
<body>
	<div id="addFolderWin"></div>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>上级功能：</li>
					<li><input id="menu"  name="menu" style="width: 250px" class="myui-text"/></li>
				</ul>
			</div>
			 <div class="item">
				<ul>
					<li class="desc">查询名称：</li>
					<li><input id="name"  name="name" style="width: 250px" class="myui-text"/></li>
				</ul>
			</div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>

