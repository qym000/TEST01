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
	// 当前查询页；
	var curPage = 1;
	$(function(){
		// 添加导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
		// 初始化页面
		initPage();
		// 进入页面默认查询
		cx(1);
	});
	
	// 初始化页面
	function initPage() {
		$("#openFlag").combo({
			mode : "local",
			data : [{text:"<s:text name='gdp_common_all'/>",value:""}, // 全部
			        {text:"关闭",value:"0"}, // 关闭
			        {text:"开启",value:"1"}], // 开启
			panelHeight : 70
		});
		myui_datagrid_renderOrder(cx);
	}
	
	// 请求查询计划列表
	function cx(page) {
		var paramObj = {
			"planObj.planName" : $.trim($("#planName").val()),
			"planObj.openFlag" : $("#openFlag").combo("getValue"),
			page : page,
			sort : $("input[name='sort']").val(),
			order : $("input[name='order']").val()
		};
		// 开启蒙板层
		tmp_component_before_load("datagrid");
		$.post("${ctx}/gdp_plan!findPlanPager.action",paramObj,function(data){
			$(".myui-datagrid-pagination").html(data.datapage);
			var htm = "";
			var tmp = "";
			if (data.datalist != null && data.datalist.length > 0) {
				$.each(data.datalist, function(idx,item){
					if (item.openFlag == 0) {
						tmp = "关闭";
					}else if (item.openFlag == 1) {
						tmp = "开启";
					}
					htm += "<tr>";
	    			htm += "<td><input type='checkbox' name='checkboxitem' value='"+item.planId+"'></td>";
	    			htm += "<td>"+ item.planName +"</td>";
	    			htm += "<td>"+ item.planDesc +"</td>";
	    			htm += "<td align='center'>"+ tmp +"</td>";
	    			htm += "<td align='center'>";
	    			htm += "<a href='javascript:void(0)' class='link-style' actionCode='ACTION_GDP_PLAN_CONF' onclick='configPlan(\""+item.planId+"\")'>配置</a>";
	    			if (item.openFlag == 0) {
	    				htm += "<a href='javascript:void(0)' style='margin-left:10px;' class='link-style' actionCode='ACTION_GDP_PLAN_SWITCH' onclick='switchOpenFlag(\""+item.planId+"\",true)'>开启</a>";
	    			}else if (item.openFlag == 1) {
						htm += "<a href='javascript:void(0)' style='margin-left:10px;' class='link-style' actionCode='ACTION_GDP_PLAN_SWITCH' onclick='switchOpenFlag(\""+item.planId+"\",false)'>关闭</a>";	    				
	    			}
	    			htm += "</td>"
	    			htm += "</tr>";
				});
			}else {
				// 没有数据
				htm += "<tr><td colspan='6'><s:text name='common_msg_nodata'/></td></tr>"
			}
			$("#databody").html(htm);
			//关闭蒙板层
			tmp_component_after_load("datagrid");
			curPage = page;
		},"json");
	}
	
	// 根据id查询计划列表，用于修改添加回显
	function findListById(id) {
		$.post("${ctx}/gdp_plan!findPlanObjById.action",{"planObj.planId" : id},function(data){ 
    		$(".myui-datagrid-pagination").html('');
    		var htm = "";
    		var tmp = "";
    		// 开启状态(0:关闭,1:开启)
    		if (data.openFlag == 0) {
				tmp = "关闭";
			}else if (data.openFlag == 1) {
				tmp = "开启";
			}
    		htm += "<tr>";
			htm += "<td><input type='checkbox' name='checkboxitem' value='" + data.planId + "'></td>";
			htm += "<td>" + data.planName + "</td>";
			htm += "<td>" + data.planDesc + "</td>";
			htm += "<td align='center'>" + tmp +"</td>";
			htm += "<td align='center'>";
			htm += "<a href='javascript:void(0)' class='link-style' actionCode='ACTION_GDP_PLAN_CONF' onclick='configPlan(\""+data.planId+"\")'>配置</a>";
			if (data.openFlag == 0) {
				htm += "<a href='javascript:void(0)' style='margin-left:10px;' class='link-style' actionCode='ACTION_GDP_PLAN_SWITCH' onclick='switchOpenFlag(\""+data.planId+"\",true)'>开启</a>";
			}else if (data.openFlag == 1) {
				htm += "<a href='javascript:void(0)' style='margin-left:10px;' class='link-style' actionCode='ACTION_GDP_PLAN_SWITCH' onclick='switchOpenFlag(\""+data.planId+"\",false)'>关闭</a>";	    				
			}
			htm += "</td>"
			htm += "</tr>";
			$("#databody").html(htm);
			actionAuthFilter();
        },"json"); 	
	}
	
	// 添加计划
	function addPlan() {
		$("#inputWin").window({
			open : true,
			headline:"<s:text name='common_action_add'/>",
			content:'<iframe src=gdp_plan!toAddPlan.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:250
		});
	}
	
	// 修改计划
	function uptPlan() {
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
			content:'<iframe src=gdp_plan!toUpdatePlan.action?id='+ id +' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:250
		});
	}
	
	// 批量删除计划对象
	function delPlan() {
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
    	// 添加蒙板层;
    	add_onload();
    	$.post("${ctx}/gdp_plan!deletePlanObjs.action",{id : idArr.join(",")},function(data){
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
	
	// 切换开启状态
	function switchOpenFlag(planId,status) {
		if (status) {
			add_onload();
	    	$.post("${ctx}/gdp_plan!checkPlanConfStatus.action",{id : planId},function(data){
	    		clean_onload();
	    		if (data.hasConf) {
	    			// 添加蒙板层;
    		    	add_onload();
    		    	var params = {
    		    		"planObj.planId" : planId,
    		    		"planObj.openFlag" : "1"
    		    	};
    		    	$.post("${ctx}/gdp_plan!switchOpenFlag.action",params,function(data){
    		    		clean_onload();
    		    		if(data == "fail"){
    						// 操作失败
    						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>',"info"); //操作失败
    					}else {
    						cx(curPage);
    					}
    		    	},"text");
	    		}else {
	    			// 未配置无法开启
					$.messager.alert('<s:text name="common_msg_info"/>','计划任务还未配置，无法开启',"info");
	    		}
	    	},"json");
		} else {
			// 添加蒙板层;
	    	add_onload();
	    	var params = {
	    		"planObj.planId" : planId,
	    		"planObj.openFlag" : "0"
	    	};
	    	$.post("${ctx}/gdp_plan!switchOpenFlag.action",params,function(data){
	    		clean_onload();
	    		if(data == "fail"){
					// 操作失败
					$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>',"info"); //操作失败
				}else {
					cx(curPage);
				}
	    	},"text");
		}
	}
	
	// 配置计划任务
	function configPlan(planId) {
		$("iframe",parent.document).attr("src","${ctx}/gdp_plan!toConfigPlan.action?id="+planId);
	}
	
</script>

</head>
<body style="height:640px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
    <ul>
    	<!-- 计划名称 -->
   	    <li class="desc">计划名称：</li>
        <li>
      	    <input type="text" id="planName" name="planName" class="myui-text" style="width:160px" title='<s:text name="common_msg_fuzzy_query"/>'/>
	    </li>
	    <!-- 开启状态 -->
   	    <li class="desc">开启状态：</li>
        <li>
      	    <input type="text" id="openFlag" name="openFlag" class="myui-text" style="width:160px" title='<s:text name="common_msg_fuzzy_query"/>'/>
	    </li>
    </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<!-- 查询 -->
			<li><a href="javascript:void(0)" onclick="cx(1)" class="myui-button-query-main" 
				actionCode="ACTION_GDP_PLAN_SEL"><s:text name="common_action_select"/></a></li>
			<!-- 添加 -->
			<li><a href="javascript:void(0)" onclick="addPlan()" class="myui-button-query" 
				actionCode="ACTION_GDP_PLAN_ADD"><s:text name="common_action_add"/></a></li>
			<!-- 修改 -->
			<li><a href="javascript:void(0)" onclick="uptPlan()" class="myui-button-query" 
				actionCode="ACTION_GDP_PLAN_UPT"><s:text name="common_action_update"/></a></li>
			<!-- 删除 -->
			<li><a href="javascript:void(0)" onclick="delPlan()" class="myui-button-query" 
				actionCode="ACTION_GDP_PLAN_DEL"><s:text name="common_action_delete"/></a></li>
		</ul>
	</div>
</div>

<div class="myui-datagrid">
	<table>
		<tr>
			<th><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
			<!-- 计划名称 -->
			<th field="planName" sortable="true">计划名称</th>
			<!-- 计划描述 -->
			<th>计划描述</th>
			<!-- 开启状态 -->
			<th field="openFlag" sortable="true">开启状态</th>
			<!-- 操作 -->
			<th><s:text name="gdp_common_operation" /></th>
		</tr>
		<tbody id="databody">
		</tbody>		
	</table>
</div>

<div class="myui-datagrid-pagination"></div>

<div id="inputWin"></div>

</body>
</html>

