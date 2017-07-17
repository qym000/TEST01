<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<style type="text/css">
.link-style {color:blue}
.link-style:HOVER{color:blue;text-decoration:underline;}
</style>
<script type="text/javascript">
	// 主初始化函数
	$(function(){
		// 动作权限过滤
		actionAuthFilter();
		// 添加导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
		// 页面元素初始化
		initPage();
		// 进入页面默认查询
		cx(1);
	})
	
	// 页面元素初始化
	function initPage() {
		// 回车事件
		$("#resName").bind("keydown",function(e){
			if (e.keyCode == 13) {
				cx(1);
			}
		});
	}
	
	// 请求查询
	function cx(page) {
		// 查询参数;
		var paramObj = {
			"resObj.resName" : $.trim($("#resName").val()),
			page : page
		};
		// 开启蒙板层
		tmp_component_before_load("datagrid");
		$.post("${ctx}/rdd_resdown!findResInfoPager.action",paramObj,function(data){
			$(".myui-datagrid-pagination").html(data.datapage);
			var htm = "";
			if (data.datalist != null && data.datalist.length > 0) {
				$.each(data.datalist, function(idx,item){
					htm += "<tr>";
	    			htm += "<td><input type='checkbox' name='checkboxitem' value='"+item.resId+"'></td>";
	    			htm += "<td>"+item.resName+"</td>";
	    			htm += "<td>"+item.resServer+"</td>";
	    			htm += "<td align='center'>"+item.moddate+"</td>";
	    			htm += "<td align='center'>";
	    			htm += "<a href='javascript:void(0)' class='link-style' onclick='configRes(\""+item.resId+"\")'>配置</a>";
	    			htm += "<a href='javascript:void(0)' class='link-style' style='margin-left:10px;' onclick='downloadRes(\""+item.resId+"\")'>下载</a></td>";
	    			htm += "</tr>";
				});
			}else {
				// 没有数据
				htm += "<tr><td colspan='5'><s:text name='common_msg_nodata'/></td></tr>"
			}
			$("#databody").html(htm);
			//关闭蒙板层
			tmp_component_after_load("datagrid");
		},"json");
	}
	
	// 根据ID查询方案分类列表,用于添加修改回显
	function findListById(id) {
		$.post("${ctx}/rdd_resdown!findResInfoObjById.action",{id : id},function(data){ 
    		$(".myui-datagrid-pagination").html('');
    		var htm = "";
    		htm += "<tr>";
			htm += "<td><input type='checkbox' name='checkboxitem' value='" + data.classId + "'></td>";
			htm += "<td>" + data.resName + "</td>";
			htm += "<td>" + data.resServer + "</td>";
			htm += "<td align='center'>" + data.moddate + "</td>";
			htm += "<td align='center'>";
			htm += "<a href='javascript:void(0)' class='link-style' onclick='configRes(\""+data.resId+"\")'>配置</a>";
			htm += "<a href='javascript:void(0)' class='link-style' style='margin-left:10px;' onclick='downloadRes(\""+data.resId+"\")'>下载</a></td>";
			htm += "</tr>";
			$("#databody").html(htm);
        },"json"); 	
	}
	
	// 添加一个下载资源对象
	function addRes() {
		$("#inputWin").window({
			open : true,
			headline:"<s:text name='common_action_add'/>",
			content:'<iframe src=rdd_resdown!toAddRes.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:250
		});
	}
	
	// 修改一个下载资源对象
	function uptRes() {
		var objsChecked = $("input[name='checkboxitem']:checked");
    	if (objsChecked.length <= 0) {
    		// 勾选记录数小于1时提示必须勾选一条记录
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');
    		return;
    	}else if (objsChecked.length > 1) {
    		// 勾选记录数大于1时提示只能勾选一条记录
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_singleselect"/>','info');
    		return;
    	}
    	var id = $(objsChecked[0]).val();
    	// 打开修改窗口
    	$("#inputWin").window({
			open : true,
			headline:"<s:text name='common_action_update'/>",
			content:'<iframe src=rdd_resdown!toUptRes.action?id='+ id +' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:250
		});
	}
	
	// 批量删除下载资源对象
	function delRes() {
		var objsChecked = $("input[name='checkboxitem']:checked");
    	if (objsChecked.length <= 0) {
    		// 勾选记录数小于1时提示必须勾选一条记录
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');
    		return;
    	}
    	// 获取所有勾选项的ID
    	var idArr = [];
    	$.each(objsChecked,function(idx,item){
    		idArr.push($(item).val());
    	});
    	// 删除操作不可回退,确定要执行该操作吗?
    	$.messager.confirm2("<s:text name='common_msg_info'/>","<s:text name='gdp_common_deleteConfirm'/>",function(r){
			if (r) {
				// 添加蒙板层;
		    	add_onload();
		    	$.post("${ctx}/rdd_resdown!deleteResInfoObjs.action",{id : idArr.join(",")},function(data){
		    		clean_onload();
		    		if(data.result=="succ"){
		    			// 操作成功
		    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info',function(){
		    				cx(1);	
		    			});
					}else if(data.result=="fail"){
						// 操作失败
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>',"info"); //操作失败
					}
		    	},"json");
			}
		});
	}
	
	// 转向配置下载资源参数
	function configRes(resId) {
    	$("#inputWin").window({
			open : true,
			headline:"基本配置",
			content:'<iframe src=rdd_resdown!toConfigRes.action?id='+ resId +' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:390
		});
	}
	
    // 下载
	function downloadRes(resId) {
    	add_onload();
    	$.post("${ctx}/rdd_resdown!checkConfig.action", {id : resId}, function(data){
    		clean_onload();
    		if (data.result == "true") {
    			//导出监控
				monitorExportStatus('rdd_resdown!monitorExportStatus.action');
		    	window.location.href = "rdd_resdown!downloadZipFile.action?id="+ resId;
    		}else {
    			$.messager.alert('<s:text name="common_msg_info"/>','请先进行配置',"info");
    		}
    	}, "json");
	}
	
</script>

</head>
<body style="height:640px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
    <ul>
    	<!-- 资源名称 -->
   	    <li class="desc">资源名称：</li>
        <li>
      	    <input type="text" id="resName" name="resName" class="myui-text" style="width:160px" title='<s:text name="common_msg_fuzzy_query"/>'/>
	    </li>
    </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<!-- 查询 -->
			<li><a href="javascript:void(0)" onclick="cx(1)" class="myui-button-query-main" 
				actionCode="ACTION_RDD_SEL"><s:text name="common_action_select"/></a></li>
			<!-- 添加 -->
			<li><a href="javascript:void(0)" onclick="addRes()" class="myui-button-query" 
				actionCode="ACTION_RDD_ADD"><s:text name="common_action_add"/></a></li>
			<!-- 修改 -->
			<li><a href="javascript:void(0)" onclick="uptRes()" class="myui-button-query" 
				actionCode="ACTION_RDD_UPT"><s:text name="common_action_update"/></a></li>
			<!-- 删除 -->
			<li><a href="javascript:void(0)" onclick="delRes()" class="myui-button-query" 
				actionCode="ACTION_RDD_DEL"><s:text name="common_action_delete"/></a></li>
		</ul>
	</div>
</div>

<div class="myui-datagrid">
	<table>
		<tr>
			<th><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
			<!-- 资源名称 -->
			<th>资源名称</th>
			<!-- 资源服务器地址 -->
			<th>资源服务器地址</th>
			<!-- 最后修改时间 -->
			<th>最后修改时间</th>
			<!-- 操作 -->
			<th>操作</th>
		</tr>
		<tbody id="databody">
		</tbody>		
	</table>
</div>

<div class="myui-datagrid-pagination"></div>

<div id="inputWin"></div>

</body>
</html>

