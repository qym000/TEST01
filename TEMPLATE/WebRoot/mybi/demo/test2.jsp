<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"
	rel="stylesheet" type="text/css" />
<link
	href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>

<script type="text/javascript">
	function cx(){
		var logid = $("#logid").val();
		var orgidt = $('#orgidt').val();
		var param = {
			'obj.logid' : 	$.trim($("#logid").val()) ,
			'obj.orgidt' : 	$.trim($("#orgidt").val()) ,
			page:1
		};
		$('.myui-datagrid').datagrid('load',param);
	}
	
	function getcase(){
		var rst = $('.myui-datagrid').datagrid('getCase');
		top.$('body').attr('value',rst);
	}
	
	function loadcase(){
		var param = top.$('body').attr('value');
		var rst = $('.myui-datagrid').datagrid('loadCase',param);
	}
</script>
</head>
<body style="height:900px;">

	<div class="myui-template-condition">
		<ul>
			<li class="desc"><s:text name="sysauth_sysuser_logid" />：</li>
			<li><input type="text" id="logid" name="logid"
				title='<s:text name="sysauth_sysuser_msg_logidnam"/>' /></li>
			<li class="desc"><s:text name="org" />：</li>
			<li><input type="text" id="orgidt" name="orgidt"
				title='<s:text name="common_msg_fuzzy_query"/>' /></li>
		</ul>
	</div>
	
	

	<div class="myui-template-operating">
		<div class="baseop">
			<ul>
				<li><a href="javascript:void(0);" onclick="cx(1)"
					class="myui-button-query-main" actionCode="ACTION_PIM_USER_SEL"><s:text
							name="common_action_select" />
				</a>
				</li>
				<li><a href="javascript:void(0);" onclick="getcase()"
					class="myui-button-query" actionCode="ACTION_PIM_USER_SEL">
						保存方案
				</a>
				</li>
				<li><a href="javascript:void(0);" onclick="loadcase()"
					class="myui-button-query" actionCode="ACTION_PIM_USER_SEL">
						加载方案
				</a>
				</li>
			</ul>
		</div>
	</div>

	<div class="myui-datagrid" myui-options="url:'${ctx}/pim_sys-user!findSysUserPagerTest.action',multiSort:true,showColumn:true,showFilters:true,export:true" width="1200px">
		<table>
			<tr>
				<th myui-options="field:'id',checkbox:true"></th>
				<th myui-options="field:'logid',sortable:true,hidden:true"><s:text name="sysauth_sysuser_logid" /></th>
				<th myui-options="field:'nam',sortable:true"><s:text name="sysauth_sysuser_nam" /></th>
				<th myui-options="field:'orgidt'"><s:text name="org_orgidt" /></th>
				<th myui-options="field:'orgnam'"><s:text name="org_orgnam" /></th>
				<th myui-options="field:'modate',datatype:'number'">修改日期</th>
			</tr>
		</table>
	</div>
</body>
</html>

