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
		// 方案类型下拉控件
		$("#schemeType").combo({
			mode : "local",
			data : [{text:"<s:text name='gdp_common_all'/>",value:"ALL"}, // 全部
			        {text:"<s:text name='gdp_common_varLength'/>",value:"0"}, // 单个方案
			        {text:"<s:text name='gdp_common_varLengthGroup'/>",value:"1"},// 复合方案
			        {text:"<s:text name='gdp_common_erms'/>",value:"2"}], // ERMS报表方案
			panelHeight : 90
		});
		// 所属分类下拉控件
		$("#classId").combo({
			mode : "local",
			data : ${request.classList},
			textField : "className",
			valueField : "classId",
			isCustom : true,
			customData : [{className:"<s:text name='gdp_common_all'/>",classId:"ALL"}],
			panelHeight : 200
		});
		// 回车事件
		$("#schemeName").bind("keydown",function(e){
			if (e.keyCode == 13) {
				cx(1);
			}
		});
		myui_datagrid_renderOrder(cx);
	}
	
	// 请求查询
	function cx(page) {
		// 查询参数;
		var paramObj = {
			"schemeObj.schemeName" : $.trim($("#schemeName").val()),
			"schemeObj.schemeType" : $("#schemeType").combo("getValue"),
			"schemeObj.classId" : $("#classId").combo("getValue"),
			page : page,
			sort : $("input[name='sort']").val(),
			order : $("input[name='order']").val()
		};
		// 开启蒙板层
		tmp_component_before_load("datagrid");
		$.post("${ctx}/gdp_scheme!findSchemePager.action",paramObj,function(data){
			$(".myui-datagrid-pagination").html(data.datapage);
			var htm = "";
			var tmp = "";
			if (data.datalist != null && data.datalist.length > 0) {
				$.each(data.datalist, function(idx,item){
					// 方案类型(0:普通变长,1:分组变长 2:定长)
					if (item.schemeType == 0) {
						tmp = "<s:text name='gdp_common_varLength'/>";
					}else if (item.schemeType == 1) {
						tmp = "<s:text name='gdp_common_varLengthGroup'/>";
					}else if (item.schemeType == 2){
						tmp = "<s:text name='gdp_common_erms'/>";
					}else {
						tmp = "<s:text name='gdp_common_fixLength'/>";
					}
					htm += "<tr>";
	    			htm += "<td><input type='checkbox' name='checkboxitem' value='"+item.schemeId+"'></td>";
	    			htm += "<td>"+item.schemeName+"</td>";
	    			htm += "<td align='center'>"+ tmp +"</td>";
	    			htm += "<td>"+item.className+"</td>";
	    			// 数据日期类型:按月/按日
	    			htm += "<td align='center'>" + (item.dateType=="1"?"<s:text name='gdp_scheme_byMonth'/>":"<s:text name='gdp_scheme_byDay'/>") + "</td>";
	    			// 有效/无效
	    			htm += "<td align='center'>" + (item.isValid=="1"?"<s:text name='gdp_tabres_valid'/>":"<s:text name='gdp_tabres_invalid'/>") + "</td>";
	    			// 是否有拦截接口
	    			htm += "<td align='center'>" + (item.schcnt==""?"<s:text name='gdp_scheme_no'/>":"<s:text name='gdp_scheme_yes'/>") + "</td>";
	    			// 配置操作
	    			htm += "<td align='center'><a href='javascript:void(0)' class='link-style' actionCode='ACTION_GDP_SCHEME_CONF' onclick='configScheme(\""+item.schemeId+"\")'><s:text name='gdp_scheme_schemeConfig'/></a></td>"
	    			htm += "</tr>";
				});
			}else {
				// 没有数据
				htm += "<tr><td colspan='8'><s:text name='common_msg_nodata'/></td></tr>"
			}
			$("#databody").html(htm);
			actionAuthFilter();
			//关闭蒙板层
			tmp_component_after_load("datagrid");
		},"json");
	}
	
	// 根据ID查询方案列表,用于添加修改回显
	function findListById(id) {
		$.post("${ctx}/gdp_scheme!findSchemeObjById.action",{"schemeObj.schemeId" : id},function(data){ 
    		$(".myui-datagrid-pagination").html('');
    		var htm = "";
    		var tmp = "";
    		// 方案类型(0:单个方案,1:复合方案 2:定长方案)
    		if (data.schemeType == 0) {
				tmp = "<s:text name='gdp_common_varLength'/>";
			}else if (data.schemeType == 1) {
				tmp = "<s:text name='gdp_common_varLengthGroup'/>";
			}else if (data.schemeType == 2){
				tmp = "<s:text name='gdp_common_erms'/>";
			}else {
				tmp = "<s:text name='gdp_common_fixLength'/>";
			}
    		htm += "<tr>";
			htm += "<td><input type='checkbox' name='checkboxitem' value='" + data.schemeId + "'></td>";
			htm += "<td>" + data.schemeName + "</td>";
			htm += "<td align='center'>" + tmp +"</td>";
			htm += "<td>" + data.className +"</td>";
			// 数据日期类型:按月/按日
			htm += "<td align='center'>" + (data.dateType=="1"?"<s:text name='gdp_scheme_byMonth'/>":"<s:text name='gdp_scheme_byDay'/>") + "</td>";
			// 有效/无效
			htm += "<td align='center'>" + (data.isValid=="1"?"<s:text name='gdp_tabres_valid'/>":"<s:text name='gdp_tabres_invalid'/>") + "</td>";
			// 是否有拦截接口
			htm += "<td align='center'>" + (data.schcnt==""?"<s:text name='gdp_scheme_no'/>":"<s:text name='gdp_scheme_yes'/>") + "</td>";
			// 配置操作
			htm += "<td align='center'><a href='javascript:void(0)' class='link-style' actionCode='ACTION_GDP_SCHEME_CONF' style='display:none' onclick='configScheme(\""+data.schemeId+"\")'><s:text name='gdp_scheme_schemeConfig'/></a></td>"
			htm += "</tr>";
			$("#databody").html(htm);
			actionAuthFilter();
        },"json"); 	
	}
	
	// 添加一个方案
	function addScheme() {
		$("#inputWin").window({
			open : true,
			headline:"<s:text name='common_action_add'/>",
			content:'<iframe src=gdp_scheme!toAddScheme.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:450
		});
	}
	
	// 修改一个方案
	function uptScheme() {
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
			content:'<iframe src=gdp_scheme!toUpdateScheme.action?id='+ id +' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:450
		});
	}
	
	// 多个方案置为无效
	function setInvalid() {
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
		add_onload();
		$.post("${ctx}/gdp_scheme!setInvalid.action",{id : idArr.join(",")},function(data){
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
	
	//多个方案置为有效
	function setValid() {
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
		add_onload();
		$.post("${ctx}/gdp_scheme!setValid.action",{id : idArr.join(",")},function(data){
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

	// 配置方案
	function configScheme(schemeId) {
		$("iframe",parent.document).attr("src","${ctx}/gdp_scheme-config!toSchemeConfig.action?id="+schemeId);
	}
	
	//把资源分配给角色/用户
	function assign(){
		var restypCode="RES_GDP"; //资源类型
		
		var objsChecked=$("input[name='checkboxitem']:checked");
    	if(objsChecked.length<=0){
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
    		return;
    	}
    	//获取选中的资源ID，逗号分隔组成字符串
    	var ids_res=getResIdOfChecked();	
    	
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_authSet"/>',
			content:'<iframe id="myframe" src=pim_res2roleuser!toManage.action?restypCode='+restypCode+'&ids_res='+ids_res+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:700,
			panelHeight:420
		});
	}

	// 得到表中选中的记录
	function getResIdOfChecked(){
		var ids="";
		var objsChecked=$("input[name='checkboxitem']:checked");
		if(objsChecked.length>=1){
			for(var i=0;i<objsChecked.length;i++){
				ids+=$(objsChecked[i]).val()+",";
			}
		}
		return ids;
	}
	
	// 获取权限资源类型码
	function getRestypCode(){
		return "RES_GDP";
	}
</script>

</head>
<body style="height:640px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
    <ul>
    	<!-- 方案名称 -->
   	    <li class="desc"><s:text name="gdp_scheme_schemeName"/>：</li>
        <li>
      	    <input type="text" id="schemeName" name="schemeName" class="myui-text" style="width:160px" title='<s:text name="common_msg_fuzzy_query"/>'/>
	    </li>
	    <!-- 所属分类 -->
	    <li class="desc"><s:text name="gdp_scheme_belongClass"/>：</li>
        <li>
	  	    <input type="text" id="classId" name="classId" style="width:160px"/>
	    </li>
	    <!-- 方案类型 -->
	    <li class="desc"><s:text name="gdp_scheme_schemeType"/>：</li>
        <li>
	  	    <input type="text" id="schemeType" name="schemeType" style="width:160px"/>
	    </li>
    </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<!-- 查询 -->
			<li><a href="javascript:void(0)" onclick="cx(1)" class="myui-button-query-main" 
				actionCode="ACTION_GDP_SCHEME_SEL"><s:text name="common_action_select"/></a></li>
			<!-- 添加 -->
			<li><a href="javascript:void(0)" onclick="addScheme()" class="myui-button-query" 
				actionCode="ACTION_GDP_SCHEME_ADD"><s:text name="common_action_add"/></a></li>
			<!-- 修改 -->
			<li><a href="javascript:void(0)" onclick="uptScheme()" class="myui-button-query" 
				actionCode="ACTION_GDP_SCHEME_UPT"><s:text name="common_action_update"/></a></li>
			<!-- 置为无效 -->
			<li><a href="javascript:void(0)" onclick="setInvalid()" class="myui-button-query" 
				actionCode="ACTION_GDP_SCHEME_INVALID"><s:text name="gdp_tabres_setInvalid"/></a></li>
			<!-- 置为有效 -->
			<li><a href="javascript:void(0)" onclick="setValid()" class="myui-button-query" 
				actionCode="ACTION_GDP_SCHEME_VALID"><s:text name="gdp_tabres_setValid"/></a></li>
			<!-- 权限设置 -->
			<li><a href="javascript:void(0);" onclick="assign()" class="myui-button-query" 
				actionCode="ACTION_GDP_SCHEME_ASSIGN"><s:text name="common_action_authSet"/></a></li>
		</ul>
	</div>
</div>

<div class="myui-datagrid">
	<table>
		<tr>
			<th><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
			<!-- 方案名称 -->
			<th field="schemeName" sortable="true"><s:text name="gdp_scheme_schemeName" /></th>
			<!-- 方案类型 -->
			<th field="schemeType" sortable="true"><s:text name="gdp_scheme_schemeType" /></th>
			<!-- 所属分类 -->
			<th field="classId" sortable="true"><s:text name="gdp_scheme_belongClass" /></th>
			<!-- 数据日期类型 -->
			<th field="dateType" sortable="true"><s:text name="gdp_scheme_dateType"/></th>
			<!-- 状态 -->
			<th field="isValid" sortable="true"><s:text name="gdp_upload_status" /></th>
			<!-- 是否有拦截接口 -->
			<th><s:text name="gdp_scheme_interfaceStatus" /></th>
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

