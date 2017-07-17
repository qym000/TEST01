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
.config-container {width:1200px;padding-bottom:10px;margin-left:15px;}
.tree-table {font-size:14px;font-family:微软雅黑;}
.tree-table tr .title{padding:15px 0 5px 0;}
.tree-table tr .split{width:50px;text-align:center;font-size:20px;color:#A0A0A0;cursor: default;}
.title-table {border-collapse:collapse;table-layout:fixed;}
.title-table tr {height:25px;background-color:#F8F6ED;font-size:13px;font-family:微软雅黑;}
.title-table tr th{border:1px solid #E0DFDF;border-bottom:none;}
.rec-table {border-collapse:collapse;width:100%;font-size:13px;font-family:微软雅黑;}
.rec-table tr {height:30px;cursor:pointer;}
.rec-table tr:HOVER {height:30px;background-color:#99D9EA;}
.rec-table .selected {height:30px;background-color:#FFDF9B;}
.rec-table tr td{border:1px solid #E0DFDF;white-space:nowrap;overflow:hidden;}
.rec-table-tr-odd {background-color:#F0F0F0}
.rec-table-tr-even {background-color:#FFFFFF}
</style>
<script type="text/javascript">
	var hasConf = ${request.hasConf};
	$(function(){
		// 添加导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
		// 初始化页面
		initPage();
	});
	
	// 初始化页面
	function initPage() {
		renderEventTab(${request.impEventList});
		renderEtlTab(${request.etlTaskList});
		if (hasConf) {
			// 初始化已配置计划
			$("#cycle").val("${planObj.cycle}");
			var htm = "";
			var imgHtml = "";
			$.each(${request.planConfList},function(idx,item){
				if (item.eventId == "ETL01") {
					$("#etlTab tr[val='"+item.cdtKey+"']").addClass("selected");	
				}else {
					imgHtml = "<img src='${ctx}/mybi/gdp/themes/${apptheme}/images/empty.png' onclick='removeCdt(\""+item.cdtKey+"\")' style='vertical-align:middle;'/>";
					htm += "<tr val='"+item.cdtKey+"' eventId='"+item.eventId+"'><td width='120'>"+item.cdtName+"</td>";
					htm +="<td width='50' align='center'>"+item.component+"</td>";
					htm +="<td width='150'>"+item.eventDesc+"</td>";
					htm +="<td width='40' align='center'>"+imgHtml+"</td></tr>";
				}
			});
			$("#cdtTab").append(htm);
			splitRow("#cdtTab");
		}
	}
	
	//隔行变色
   	function splitRow(target) {
   		$(target+" tr").addClass('rec-table-tr-odd'); 
   		$(target+" tr:even").addClass('rec-table-tr-even'); 
   	}
	
	// 渲染事件列表
	function renderEventTab(data) {
		var imgHtml = "";
		var htm = "";
		$.each(data,function(idx,item){
			imgHtml = "<img src='${ctx}/mybi/gdp/themes/${apptheme}/images/add.png' onclick='addCdt(\""+item.eventId+"\")' style='vertical-align:middle;'/>";
			htm += "<tr val='"+item.eventId+"'><td width='60' align='center'>"+(item.eventType=="IMP"?"条件":"结果")+"</td>";
			htm += "<td width='50' align='center'>"+item.component+"</td>";
			htm += "<td width='190' title='"+item.eventDesc+"'>"+item.eventDesc+"</td>";
			htm += "<td width='60' align='center'>"+imgHtml+"</td></tr>";
		});
		$("#eventTab").html(htm);
		splitRow("#eventTab");
	}
	
	// 渲染ETL批量列表
	function renderEtlTab(data) {
		var htm = "";
		$.each(data,function(idx,item){
			htm += "<tr val='"+item.TASK_ID+"'><td width='200'>"+item.TASK_ID+"</td>";
			htm += "<td width='200'>"+item.TASK_NAME+"</td>";
			htm += "<td width='70' align='center'>"+item.CENDAT+"</td>";
			htm += "<td width='70' align='center'>"+item.RUNSTA+"</td>";
			htm += "<td width='100' align='center'>"+(item.IS_CHECK=="Y"?"是":"否")+"</td>";
			htm += "<td width='100' align='center'>"+(item.IS_AUTO=="Y"?"是":"否")+"</td></tr>";
		});
		$("#etlTab").html(htm);
		splitRow("#etlTab");
		$("#etlTab tr").bind("click",function(e){
			$("#etlTab tr").removeClass("selected");
			$(this).addClass("selected");
		});
	}
	
	// 添加触发条件
	function addCdt(eventId) {
		$("#inputWin").window({
			open : true,
			headline:"选择触发对象",
			content:'<iframe src=gdp_plan!toSelCdtObj.action?id='+eventId+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:450
		});
	}
	
	// 删除触发条件
	function removeCdt(id) {
		$("#cdtTab tr[val='"+id+"']").remove();
		$("#cdtTab tr").removeClass();
		splitRow("#cdtTab");
	}
	
	// 为cdtTab追加触发条件
	function appendCdtHtm(arr,eventId) {
		var htm = "";
		var imgHtml = "";
		var eventTr = $("#eventTab tr[val='"+eventId+"']")
		for (var i = 0;i < arr.length; i++) {
			imgHtml = "<img src='${ctx}/mybi/gdp/themes/${apptheme}/images/empty.png' onclick='removeCdt(\""+arr[i].id+"\")' style='vertical-align:middle;'/>";
			htm += "<tr val='"+arr[i].id+"' eventId='"+eventId+"'><td width='120'>"+arr[i].name+"</td>";
			htm +="<td width='50' align='center'>"+$(eventTr).find("td").eq(1).text()+"</td>";
			htm +="<td width='150'>"+$(eventTr).find("td").eq(2).text()+"</td>";
			htm +="<td width='40' align='center'>"+imgHtml+"</td></tr>";
		}
		$("#cdtTab").append(htm);
		splitRow("#cdtTab");
	}
	
	// 转向计划周期配置页面
	function toSelCycle() {
		var cycle = $("#cycle").val();
    	$("#inputWin").window({
			open : true,
			headline:"计划周期配置",
			content:'<iframe src=gdp_plan!toCycleConfInput.action?cycle='+cycle+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:330
		});
	}
	
	// 保存计划配置
	function saveConfig() {
		var cycle = $.trim($("#cycle").val());
		var cdts = $("#cdtTab tr");
		var task = $("#etlTab .selected");
		if (cycle == "") {
			$.messager.alert('<s:text name="common_msg_info"/>', "周期不能为空，请配置周期", 'info');
			return;
		}
		if (cdts == null || cdts.length < 1) {
			$.messager.alert('<s:text name="common_msg_info"/>', "请添加触发条件", 'info');
			return;
		}
		if (task == null || task.length < 1) {
			$.messager.alert('<s:text name="common_msg_info"/>', "请选择要启动的ETL批量", 'info');
			return;
		}
		var arr = [];
		for (var i = 0; i < cdts.length; i++) {
			var obj = {
				eventId : $(cdts[i]).attr("eventId"),
				cdtKey : $(cdts[i]).attr("val"),
				cdtName : $(cdts[i]).find("td").eq(0).text()
			};
			arr.push(obj);
		}
		arr.push({
			eventId : "ETL01",
			cdtKey : $(task[0]).attr("val"),
			cdtName : $(task[0]).find("td").eq(1).text()
		});
		var paramObj = {
			"planObj.planId" : "${request.planId}",
			"planObj.cycle" : cycle,
			confStr : JSON.stringify(arr)
		};
		add_onload();
		$.post("${ctx}/gdp_plan!savePlanConfig.action",paramObj,function(data){
			clean_onload();
			if(data.result=="succ"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info');
			}else if(data.result=="fail"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
			}
		},"json");
	}
</script>

</head>
<body style="height:750px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition" style="margin-bottom:10px;">
    <ul>
    	<!-- 计划周期 -->
   	    <li class="desc">计划周期：</li>
        <li>
      	    <input type="text" id="cycle" name="cycle" class="myui-text" readonly="readonly" style="width:160px;cursor:pointer;" onclick="toSelCycle()"/>
	    </li>
	    <!-- 重复执行 -->
		<!-- <li class="desc" style="width:70px;">重复执行：</li>
		<li>
			<ul class="seltile" id="ectRepeat">
				<li class="option" vl="0">开启</li>
				<li class="option_selected" vl="1">关闭</li>
			</ul>
		</li> -->
    </ul>
</div>

<div class="myui-layout"  style="margin-left:15px;">
	<div class="linegroup">
		<div class="rowgroup">
			<div class="content" style="width:600px;height:300px;" title="事件">
				<table style="width:598px;" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<table class="title-table" style="width:598px" cellspacing="0" cellpadding="0" align="center" border="0">
								<tr>
									<th width="60">事件类型</th>
									<th width="50">所属组件</th>
									<th width="190">事件描述</th>
									<th width="60">操作</th>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<div style="overflow-y:auto;overflow-x:hidden; width:100%; height:242px;background-color:#FBFBFB"> 
					        	<table id="eventTab" class="rec-table" style="table-layout:fixed;width:598px;" cellspacing="0" cellpadding="0" border="0"> 
					          	</table>
					       	</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="content" style="width:600px;height:300px;" title="触发条件">
				<table style="width:598px;" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<table class="title-table" style="width:598px" cellspacing="0" cellpadding="0" align="center" border="0">
								<tr>
									<th width="120">触发对象</th>
									<th width="50">所属组件</th>
									<th width="150">条件描述</th>
									<th width="40">操作</th>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<div style="overflow-y:auto;overflow-x:hidden; width:100%; height:242px;background-color:#FBFBFB"> 
					        	<table id="cdtTab" class="rec-table" style="table-layout:fixed;width:598px;" cellspacing="0" cellpadding="0" border="0"> 
					          	</table>
					       	</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="content" style="width:1210px;height:300px;" title="选择要启动的ETL批量">
			<table style="width:1208px;" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>
							<table class="title-table" style="width:1208px" cellspacing="0" cellpadding="0" align="center" border="0">
								<tr>
									<th width="200">批量编号</th>
									<th width="200">批量名称</th>
									<th width="70">数据日期</th>
									<th width="70">批量状态</th>
									<th width="100">校验模式</th>
									<th width="100">自动切批</th>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<div style="overflow-y:auto;overflow-x:hidden; width:100%; height:242px;background-color:#FBFBFB"> 
					        	<table id="etlTab" class="rec-table" style="table-layout:fixed;width:1208px;" cellspacing="0" cellpadding="0" border="0"> 
					          	</table>
					       	</div>
						</td>
					</tr>
				</table>
		</div>
	</div>
</div>

<div class="config-container">
	<table class="tree-table" align="center" cellpadding="0" cellspacing="0" style="width:100%;">
		<tr>
			<td colspan="5" align="center" style="padding:25px 0 10px 0;">
				<!-- 保存 -->
				<a href="javascript:void(0)" onclick="saveConfig()" class="myui-button-query-main" >
					<s:text name="gdp_common_save"/></a>
			</td>
		</tr>
	</table>
</div>

<div id="inputWin"></div>

</body>
</html>

