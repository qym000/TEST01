<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link type="text/css" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.timer.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<style type="text/css">
.link-style {color:blue}
.link-style:HOVER{color:blue;text-decoration:underline;}
</style>
<script type="text/javascript">
	var runstaMap = ["<s:text name='gdp_upload_uploaded'/>","<s:text name='gdp_upload_importReady'/>","<s:text name='gdp_upload_importRunning'/>","<s:text name='gdp_upload_importSuccess'/>","<s:text name='gdp_upload_importFailure'/>","<s:text name='gdp_upload_passAudit'/>","<s:text name='gdp_upload_otherException'/>"];
	var currentScheme = null; // 当前选中的方案节点;
	var firstFlag = true;
	var timer;
	var pageNumber = 1;
	var chkItems = [];
	// 方案Ztree树设置对象
	var setting = {
		data: {
			key : {
				title : "desc" // 悬浮提示为节点的"desc"属性
			},
			simpleData: {
				enable: true // 使用id和pId的简单数据格式
			}
		},			
		async: {
			enable: true, // 启用异步请求节点数据
			url:"gdp_upload!getSchemeTreeNodes.action" // 异步请求url
		},
		callback : {
			onClick : schemeTreeOnClick, // 方案树点击节点事件
			beforeClick : schemeTreeBeforeClick //  方案树点击节点前事件
		}
	};
	// 主初始化函数
	$(function(){
		// 动作权限过滤
		actionAuthFilter();
		// 页面元素初始化
		initPage();
	})
	
	// 页面元素初始化
	function initPage() {
		// 上传日期控件初始化
		$("#uploadDate").datebox({
			dateFormat : 'YYYYMMDD'
		});
		// 数据日期控件初始化
		$("#cendat").datebox({
			dateFormat : 'YYYYMMDD'
		});
		// 状态combo控件初始化
		$("#runsta").combo({
			mode : "local",
			data : [{text : "<s:text name='gdp_common_all'/>", value : ""},
			        {text : "<s:text name='gdp_upload_uploaded'/>", value : "0"},
			        {text : "<s:text name='gdp_upload_importReady'/>", value : "1"},
			        {text : "<s:text name='gdp_upload_importRunning'/>", value : "2"},
			        {text : "<s:text name='gdp_upload_importSuccess'/>", value : "3"},
			        {text : "<s:text name='gdp_upload_importFailure'/>", value : "4"},
			        {text : "<s:text name='gdp_upload_passAudit'/>", value : "5"},
			        {text : "<s:text name='gdp_upload_otherException'/>", value : "6"}],
			panelHeight : 160
		});
		// 方案ZTREE树初始化
		$.fn.zTree.init($("#schemeTree"), setting);
		// datagrid排序初始化
		myui_datagrid_renderOrder(cx);
	}
	
	// 查询方案下的任务
	function cx(page) {
		var treeObj = $.fn.zTree.getZTreeObj("schemeTree");
		var nodes = treeObj.getSelectedNodes();
		if (nodes.length == 0 || !nodes[0].isScheme) {
			// 若没有选择一个方案,则提示并返回
			$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_upload_pleaseSelectScheme'/>",'info');
			return;
		}
		// 查询条件参数对象
		var paramObj = {
			"taskObj.schemeId" : nodes[0].id,
			"taskObj.uploadDate" : $("#uploadDate").datebox("getValue"),
			"taskObj.originName" : $.trim($("#originName").val()),
			"taskObj.runsta" : $("#runsta").combo("getValue"),
			"taskObj.cendat" : $("#cendat").datebox("getValue"),
			page : page,
			sort : $("input[name='sort']").val(),
			order : $("input[name='order']").val()
		};
		$.ajax({
			url : "${ctx}/gdp_upload!findTaskPagerBySchemeId.action",
			data : paramObj,
			type : "post",
			dataType : "json",
			timeout : 30000,
			success : function(data) {
				$(".myui-datagrid-pagination").html(data.datapage);
				var htm = "";
				if (data.datalist != null && data.datalist.length > 0) {
					$.each(data.datalist, function(idx,item){
						htm += "<tr>";
						htm += "<td><input type='checkbox' name='checkboxitem' runsta='"+item.runsta+"' value='"+item.taskId+"'></td>";
						htm += "<td><a href='javascript:void(0)' class='link-style' onclick='dnloadDataFile(\""+item.taskId+"\")'>" + item.originName + "</a></td>";
						htm += "<td>" + item.orgnam + "</td>";
						htm += "<td align='center'>" + item.cendat + "</td>";
						htm += "<td align='center'>" + item.uploadDate + "</td>";
						if (item.runsta == 3 || item.runsta == 4 || item.runsta == 6) {
							// 导数成功/失败/其他异常时可以查看日志
							htm += "<td align='center'><a href='javascript:void(0)' class='link-style' onclick='toViewLog(\""+item.taskId+"\")'>" + runstaMap[item.runsta] + "</a></td>";
						}else {
							htm += "<td align='center'>" + runstaMap[item.runsta] + "</td>";
						}
						htm += "<td align='center'>";
						<s:if test='#session.sysActionStringWithAuth.indexOf("ACTION_GDP_UPLOAD_START")!=-1'>
							htm += "<a href='javascript:void(0)' actionCode='ACTION_GDP_UPLOAD_START' class='link-style' onclick='startUpTask(\""+item.taskId+"\")'><s:text name='gdp_upload_startUp'/></a>"
						</s:if>
						<s:if test='#session.sysActionStringWithAuth.indexOf("ACTION_GDP_UPLOAD_VIEW")!=-1'>
							htm += "<a href='javascript:void(0)' actionCode='ACTION_GDP_UPLOAD_VIEW' class='link-style' onclick='viewData(\""+item.cendat+"\")' style='margin-left:10px;'><s:text name='gdp_upload_viewData'/></a>"
						</s:if>
						if (item.impType != "0") {
							<s:if test='#session.sysActionStringWithAuth.indexOf("ACTION_GDP_UPLOAD_CLEAR")!=-1'>
								htm += "<a href='javascript:void(0)' actionCode='ACTION_GDP_UPLOAD_CLEAR' class='link-style' onclick='clearData(\""+item.taskId+"\",\""+item.runsta+"\")' style='margin-left:10px;'><s:text name='gdp_upload_clearData'/></a>"
							</s:if>
						}
						htm += "</td></tr>"
					});
				}else {
					// 没有数据
					htm += "<tr><td colspan='7'><s:text name='common_msg_nodata'/></td></tr>"
				}
				$("#databody").html(htm);
				//关闭蒙板层
				if (firstFlag) {
					tmp_component_after_load("datagrid");
				}else {
					splitRow("datagrid");
				}
				// 启动自动刷新;
				startAutoRefresh();
    			firstFlag = false;
    			// 设置已选;
    			$.each(chkItems, function(i){
    				$("input[value='" + chkItems[i] + "']").attr("checked","checked");
    			});
    			chkItems = [];
			},
			beforeSend : function(){
				pageNumber = page;
    			if (firstFlag) {
    				// 第一次查询开启蒙板层
    				tmp_component_before_load("datagrid");
    			}else {
    				// 否则关闭计时器
    				timer.stop();
    			}
    			// 获取选中项;
    			var objsChecked=$("input[name='checkboxitem']:checked");
    			if (objsChecked != null && objsChecked != undefined) {
    				$.each(objsChecked, function(iex){
    					chkItems.push($(this).attr("value"));
    				});
    			}
			},
			error : function(){
				tmp_component_after_load("datagrid");
				if (!firstFlag) {
					timer.stop();
				}
    			firstFlag = true;
    			$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_upload_requestFailure'/>",'error');
			}
		});
	}
	
	// 启动自动刷新;
	function startAutoRefresh(){
		 var val = 5;
		 timer = $.timer(val*1000, function(){
			cx(pageNumber);
		 });
	}
	
	// 分类节点(非方案节点)禁止选中 
	function schemeTreeBeforeClick(treeId, treeNode, clickFlag) {
		return treeNode.isScheme;
	}
	
	// 点击方案树节点事件,点击后自动查询
	function schemeTreeOnClick(event,treeId,treeNode){
		// 将当前选中节点的方案ID赋给全局变量;
		currentScheme = treeNode.id;
		cx(1);
	}
	
	// 文件上传
	function uploadFile() {
		var treeObj = $.fn.zTree.getZTreeObj("schemeTree");
		var nodes = treeObj.getSelectedNodes();
		if (nodes.length == 0 || !nodes[0].isScheme) {
			// 若没有选择一个方案,则提示并返回
			$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_upload_pleaseSelectScheme'/>",'info');
			return;
		}
		$("#inputWin").window({
			open : true,
			headline:"<s:text name='gdp_upload_dataUpload'/>",
			content:'<iframe src=gdp_upload!toUploadFile.action?schemeId='+currentScheme+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:270
		});
	}
	
	// 下载模板文件
	function dnloadTemplate() {
		var treeObj = $.fn.zTree.getZTreeObj("schemeTree");
		var nodes = treeObj.getSelectedNodes();
		if (nodes.length == 0 || !nodes[0].isScheme) {
			// 若没有选择一个方案,则提示并返回
			$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_upload_pleaseSelectScheme'/>",'info');
			return;
		}
		// 验证模板文件是否存在;
		$.post("${ctx}/gdp_upload!checkTemplateFileExist.action",{"schemeObj.schemeId" : currentScheme},function(data){
			if (data.result == "true") {
				window.location.href = "${ctx}/gdp_upload!downloadTemplateFile.action?schemeId=" + currentScheme;
			}else {
				$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_config_fileNotExsit'/>",'info');
				return;
			}
		},"json");
	}
	
	// 下载数据文件
	function dnloadDataFile(taskId) {
		// 验证数据文件是否存在;
		$.post("${ctx}/gdp_upload!checkDataFileExist.action",{"taskObj.taskId" : taskId},function(data){
			if (data.result == "true") {
				window.location.href = "${ctx}/gdp_upload!downloadDataFile.action?taskId=" + taskId;
			}else {
				$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_config_fileNotExsit'/>",'info');
				return;
			}
		},"json");
	}
	
	// 删除任务
	function deleteTask() {
		var objsChecked = $("input[name='checkboxitem']:checked");
    	if (objsChecked.length <= 0) {
    		// 勾选记录数小于1时提示必须勾选一条记录
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');
    		return;
    	}
    	// 检查是否有准备导数或正在导数的任务
    	var flag = false;
    	// 获取所有勾选项的ID
    	var idArr = [];
    	$.each(objsChecked,function(idx,item){
    		if ($(item).attr("runsta") == "1" || $(item).attr("runsta") == "2") {
    			flag = true;
    		}
    		idArr.push($(item).val());
    	});
    	if (flag) {
    		// 有任务正在运行
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="gdp_upload_taskIsRunning"/>','info');
    		return;
    	}
    	// 删除任务会同时清除该任务导入的数据和文件,是否执行该操作?
    	$.messager.confirm2("<s:text name='common_msg_info'/>","<s:text name='gdp_upload_delTaskConfirm'/>",function(r){
			if (r) {
				// 添加蒙板层;
		    	add_onload();
		    	$.post("${ctx}/gdp_upload!deleteTask.action",{taskId : idArr.join(","),schemeId : currentScheme},function(data){
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
	
	/**重置任务*/
	function resetTask() {
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
    	// 确定是否需要重置
    	$.messager.confirm2("<s:text name='common_msg_info'/>","<s:text name='gdp_upload_resetTaskConfirm'/>",function(r){
			if (r) {
				// 添加蒙板层;
		    	add_onload();
		    	$.post("${ctx}/gdp_upload!resetTask.action",{taskId : idArr.join(","),schemeId : currentScheme},function(data){
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
	
	// 转向查看日志页面;
	function toViewLog(taskId) {
		var a = document.getElementById("dataLink");
		a.href = "${ctx}/gdp_upload!toViewLog.action?taskId=" + taskId;
		a.setAttribute("onclick","");
		a.click("return false");
	}
	
	// 启动导数
	function startUpTask(taskId) {
		add_onload();
		$.post("${ctx}/gdp_upload!checkAppendImportEnable.action",{"taskObj.taskId" : taskId},function(data){
			clean_onload();
			if (data.result == "succ") {
				if (data.enable) {
					// 可以启动
					$.post("${ctx}/gdp_upload!startupTask.action",{"taskObj.taskId" : taskId,schemeId : currentScheme},function(data){
						if (data.result == "succ") {
							cx(pageNumber);
						}else {
							$.messager.alert('<s:text name="common_msg_info"/>',data.msg,'info');
						}
					},"json");
				}else {
					// 当期数据存在提示
					$.messager.alert("<s:text name='common_msg_info'/>","<s:text name='gdp_upload_existDataOfCendat'><s:param>"+data.tableName+"</s:param></s:text>","info");
				}
			}else {
				// 操作失败
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>',"info"); //操作失败
			}
		},"json");
	}
	
	// 数据查看
	function viewData(cendat) {
		if (currentScheme == null) {
			return;
		}
		add_onload();
		$.post("${ctx}/gdp_upload!checkViewDataEnable.action",{"schemeObj.schemeId" : currentScheme},function(data){
			clean_onload();
			if (data == "true") {
				var a = document.getElementById("dataLink");
				a.href = "${ctx}/gdp_upload!toViewGdpData.action?schemeId="+currentScheme+"&cendat=" + cendat;
				a.setAttribute("onclick","");
				a.click("return false");
			}else {
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="gdp_upload_checkViewDataEnable"/>','info');
			}
		},"text");
	}
	
	// 清除追加导入的数据
	function clearData(taskId,runsta) {
		if (runsta == '1' || runsta == '2') {
			// 运行中的任务不可执行此操作;
			$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_upload_taskIsRunning'/>",'info');
			return;
		}
		$.messager.confirm2("<s:text name='common_msg_info'/>","<s:text name='gdp_upload_clearConfirm'/>",function(r){
			if (r) {
			add_onload();
			$.post("${ctx}/gdp_upload!clearDataForAppendImport.action", 
				   {"taskObj.taskId" : taskId,schemeId : currentScheme}, function(data){
				clean_onload();
				if (data.result == "succ") {
					$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='common_msg_succ'/>", 'info');
				}else if (data.result == "fail"){
					$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='common_msg_fail'/>", 'info');
				}
			},"json");
			}
		});
	}
	
	// 通过审核
	function auditPass() {
		var objsChecked = $("input[name='checkboxitem']:checked");
    	if (objsChecked.length <= 0) {
    		// 勾选记录数小于1时提示必须勾选一条记录
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');
    		return;
    	}
    	// 检查是否可以审核通过
    	var flag = true;
    	// 获取所有勾选项的ID
    	var idArr = [];
    	$.each(objsChecked,function(idx,item){
    		if ($(item).attr("runsta") != "3") {
    			flag = false;
    		}
    		idArr.push($(item).val());
    	});
    	if (!flag) {
    		// 有任务正在运行
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="gdp_upload_onlyImportSucc"/>','info');
    		return;
    	}
    	add_onload();
    	$.post("${ctx}/gdp_upload!auditPass.action",{taskId : idArr.join(","),schemeId : currentScheme},function(data){
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
	
	//隔行变色
   	function splitRow(tmp_component) {
   		if (tmp_component == "datagrid") {
   			$(".myui-datagrid table tr input:checkbox").parent().css("text-align","center").css("padding-left","0px").css("width","25px");
   			//隔行变色  处理多行表头
   			if($(".myui-datagrid table tr th:last").parent().index()%2 == 0){
   				$(".myui-datagrid table tr").addClass('myui-datagrid-tr-odd'); 
   				$(".myui-datagrid table tr:even").addClass('myui-datagrid-tr-even'); 
   			}else{
   				$(".myui-datagrid table tr td").parent().addClass('myui-datagrid-tr-odd'); 
   				$(".myui-datagrid table tr td").parent().filter(":odd").addClass('myui-datagrid-tr-even'); 
   			}
   		}
   	}
</script>

</head>
<body style="height:665px;">
<div class="myui-layout">
	<div class="rowgroup">
		<div class="content" title="方案列表" style="width:270px;height:672px;">
			<div id="queryTabDiv" style="width:250px;">
				<ul id="schemeTree" class="ztree"></ul>
			</div>
		</div>
		<div class="content" title="数据上传" style="width:945px;height:672px;">
			<div class="myui-template-condition" style="width:925px;">
				<ul style="margin-left:5px;">
					<!-- 上传日期 -->
					<li class="desc" style="width:70px;"><s:text name='gdp_upload_uploadDate'/>：</li>
				    <li style="width:130px;">
				    	<input type="text" id="uploadDate" name="uploadDate"  style="width:120px" />
					</li>
					<!-- 数据日期 -->
					<li class="desc" style="width:70px;"><s:text name='gdp_upload_cendat'/>：</li>
				    <li style="width:130px;">
				    	<input type="text" id="cendat" name="cendat"  style="width:120px" />
					</li>
					<!-- 文件名称 -->
					<li class="desc" style="width:70px;"><s:text name='gdp_upload_fileName'/>：</li>
				    <li style="width:130px;">
						<input type="text" id="originName" name="originName" class="myui-text" style="width:120px" title='<s:text name="common_msg_fuzzy_query"/>'/>
					</li>
					<!-- 状态 -->
					<li class="desc" style="width:50px;"><s:text name='gdp_upload_status'/>：</li>
				    <li style="width:130px;">
						<input type="text" id="runsta" name="runsta" class="myui-text" style="width:120px"/>
					</li>
				</ul>
			</div>
				
			<div class="myui-template-operating" style="width:935px;">
				<div class="baseop" style="margin-left:10px;">
					<ul>
						<!-- 查询 -->
						<li><a href="javascript:void(0)" onclick="firstFlag=true;cx(1)" class="myui-button-query-main" 
							actionCode="ACTION_GDP_UPLOAD_SEL"><s:text name="common_action_select"/></a></li>
						<!-- 上传文件 -->
						<li><a href="javascript:void(0)" onclick="uploadFile()" class="myui-button-query" 
							actionCode="ACTION_GDP_UPLOAD_UPD"><s:text name="gdp_upload_uploadFile"/></a></li>
						<!-- 下载模板 -->
						<li><a href="javascript:void(0)" onclick="dnloadTemplate()" class="myui-button-query" 
							actionCode="ACTION_GDP_UPLOAD_DND"><s:text name="gdp_upload_downloadTemplate"/></a></li>
						<!-- 删除任务 -->
						<li><a href="javascript:void(0)" onclick="deleteTask()" class="myui-button-query" 
							actionCode="ACTION_GDP_UPLOAD_DEL"><s:text name="gdp_upload_deleteTask"/></a></li>
                        <!-- 重置任务 -->
                        <li><a href="javascript:void(0)" onclick="resetTask()" class="myui-button-query" 
                            actionCode="ACTION_GDP_UPLOAD_RESET"><s:text name="gdp_upload_resetTask"/></a></li>
						<!-- 通过审核 -->
						<li><a href="javascript:void(0)" onclick="auditPass()" class="myui-button-query" 
							actionCode="ACTION_GDP_UPLOAD_AUDIT"><s:text name="gdp_upload_passAudit"/></a></li>
					</ul>
				</div>
			</div>
				
			<div class="myui-datagrid" style="width:925px;padding-bottom:15px;">
				<table style="width:100%;">
					<tr>
						<th><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
						<!-- 文件名称 -->
						<th field="originName" sortable="true"><s:text name='gdp_upload_fileName'/></th>
						<!-- 机构名称 -->
						<th field="orgnam" sortable="true"><s:text name='gdp_upload_orgnam'/></th>
						<!-- 数据日期 -->
						<th field="cendat" sortable="true"><s:text name='gdp_upload_cendat'/></th>
						<!-- 上传日期 -->
						<th field="uploadDate" sortable="true"><s:text name='gdp_upload_uploadDate'/></th>
						<!-- 状态 -->
						<th field="runsta" sortable="true"><s:text name='gdp_upload_status'/></th>
						<!-- 操作 -->
						<th><s:text name="gdp_common_operation" /></th>
					</tr>
					<tbody id="databody">
					</tbody>		
				</table>
			</div>
				
			<div class="myui-datagrid-pagination"></div>
		</div>
	</div>
</div>

<div id="inputWin"></div>

</body>
<a id="dataLink" target="_blank" style="display:none;"></a>
</html>

