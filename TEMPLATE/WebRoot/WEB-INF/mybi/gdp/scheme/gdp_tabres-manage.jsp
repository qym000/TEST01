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
		// 表有效性combo控件初始化
		$("#isValid").combo({
			mode : "local",
			data : [{text:"<s:text name='gdp_common_all'/>",value:""}, // 全部
			        {text:"<s:text name='gdp_tabres_valid'/>",value:"1"}, // 有效
			        {text:"<s:text name='gdp_tabres_invalid'/>",value:"0"}], // 无效
			panelHeight : 70
		});
		// 回车事件
		$("#tabName").bind("keydown",function(e){
			if (e.keyCode == 13) {
				cx(1);
			}
		});
		// 添加列表排序;
		myui_datagrid_renderOrder(cx);
	}
	
	// 请求查询
	function cx(page) {
		// 查询参数;
		var paramObj = {
			"tabresObj.tabName" : $.trim($("#tabName").val()),
			"tabresObj.isValid" : $("#isValid").combo("getValue"),
			page : page,
			sort : $("input[name='sort']").val(),
			order : $("input[name='order']").val()
		};
		// 开启蒙板层
		tmp_component_before_load("datagrid");
		$.post("${ctx}/gdp_scheme-tabres!findTabresPager.action",paramObj,function(data){
			$(".myui-datagrid-pagination").html(data.datapage);
			var htm = "";
			if (data.datalist != null && data.datalist.length > 0) {
				$.each(data.datalist, function(idx,item){
					htm += "<tr>";
	    			htm += "<td><input type='checkbox' name='checkboxitem' value='"+item.tabName+"'></td>";
	    			htm += "<td>"+item.tabName+"</td>";
	    			htm += "<td>"+item.tabComment+"</td>"
	    			// 有效/无效
	    			htm += "<td align='center'>" + (item.isValid=="1"?"<s:text name='gdp_tabres_valid'/>":"<s:text name='gdp_tabres_invalid'/>") + "</td>"
	    			htm += "</tr>";
				});
			}else {
				// 没有数据
				htm += "<tr><td colspan='4'><s:text name='common_msg_nodata'/></td></tr>"
			}
			$("#databody").html(htm);
			//关闭蒙板层
			tmp_component_after_load("datagrid");
		},"json");
	}
	
	// 根据ID查询表资源列表,用于添加修改回显
	function findListById(id) {
		$.post("${ctx}/gdp_scheme-tabres!findTabresObjByName.action",{"tabresObj.tabName" : id},function(data){ 
    		$(".myui-datagrid-pagination").html('');
    		var htm = "";
    		htm += "<tr>";
			htm += "<td><input type='checkbox' name='checkboxitem' value='" + data.tabName + "'></td>";
			htm += "<td>"+data.tabName+"</td>";
			htm += "<td>"+data.tabComment+"</td>"
			htm += "<td align='center'>" + (data.isValid=="1"?"<s:text name='gdp_tabres_valid'/>":"<s:text name='gdp_tabres_invalid'/>") + "</td>"
			htm += "</tr>";
			$("#databody").html(htm);
        },"json"); 	
	}
	
	// 添加一个表资源
	function addTabres() {
		$("#inputWin").window({
			open : true,
			headline:"<s:text name='common_action_add'/>",
			content:'<iframe src=gdp_scheme-tabres!toAddTabres.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:250
		});
	}
	
	// 修改一个表资源
	function uptTabres() {
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
			content:'<iframe src=gdp_scheme-tabres!toUpdateTabres.action?tabName='+ id +' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:250
		});
	}
	
	// 将表资源置为无效
	function setInvalidByNames() {
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
    	$.post("${ctx}/gdp_scheme-tabres!setInvalidByNames.action",{tabName : idArr.join(",")},function(data){
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
	
	// 将表资源置为有效
	function setValidByNames() {
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
    	$.post("${ctx}/gdp_scheme-tabres!setValidByNames.action",{tabName : idArr.join(",")},function(data){
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
	
</script>

</head>
<body style="height:640px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
    <ul>
    	<!-- 表名/表注释 -->
   	    <li class="desc" style="width:80px;"><s:text name="gdp_tabres_nameOrDesc"/>：</li>
        <li>
      	    <input type="text" id="tabName" name="tabName" class="myui-text" style="width:160px" title='<s:text name="common_msg_fuzzy_query"/>'/>
	    </li>
	    <!-- 状态 -->
   	    <li class="desc" style="width:50px;"><s:text name="gdp_upload_status"/>：</li>
        <li>
      	    <input id="isValid" name="isValid" style="width:160px" />
	    </li>
    </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<!-- 查询 -->
			<li><a href="javascript:void(0)" onclick="cx(1)" class="myui-button-query-main" 
				actionCode="ACTION_GDP_TABRES_SEL"><s:text name="common_action_select"/></a></li>
			<!-- 添加 -->
			<li><a href="javascript:void(0)" onclick="addTabres()" class="myui-button-query" 
				actionCode="ACTION_GDP_TABRES_ADD"><s:text name="common_action_add"/></a></li>
			<!-- 修改 -->
			<li><a href="javascript:void(0)" onclick="uptTabres()" class="myui-button-query" 
				actionCode="ACTION_GDP_TABRES_UPT"><s:text name="common_action_update"/></a></li>
			<!-- 置为有效 -->
			<li><a href="javascript:void(0)" onclick="setValidByNames()" class="myui-button-query" 
				actionCode="ACTION_GDP_TABRES_VALID"><s:text name="gdp_tabres_setValid"/></a></li>
			<!-- 置为无效 -->
			<li><a href="javascript:void(0)" onclick="setInvalidByNames()" class="myui-button-query" 
				actionCode="ACTION_GDP_TABRES_INVALID"><s:text name="gdp_tabres_setInvalid"/></a></li>
		</ul>
	</div>
</div>

<div class="myui-datagrid">
	<table>
		<tr>
			<th><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
			<!-- 数据库表名 -->
			<th field="tabName" sortable="true"><s:text name="gdp_tabres_tabName"/></th>
			<!-- 数据库表描述 -->
			<th field="tabComment" sortable="true"><s:text name="gdp_tabres_tabComment"/></th>
			<!-- 状态 -->
			<th field="isValid" sortable="true"><s:text name="gdp_upload_status"/></th>
		</tr>
		<tbody id="databody">
		</tbody>		
	</table>
</div>

<div class="myui-datagrid-pagination"></div>

<div id="inputWin"></div>

</body>
</html>

