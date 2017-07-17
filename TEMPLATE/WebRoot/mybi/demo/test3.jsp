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
  
  <script type="text/javascript">
	function find(){
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
		alert(rst);
	}
	
	function loadcase(){
		var param = top.$('body').attr('value');
		var rst = $('.myui-datagrid').datagrid('loadCase',param);
	}
	
	$(function(){
		$('.datagrid-list2 .list-body').bind('scroll', function(){
		/*	var b1 = dc.view1.children('div.datagrid-body');
			b1.scrollTop($(this).scrollTop());
			var c1 = dc.body1.children(':first');
			var c2 = dc.body2.children(':first');
			if (c1.length && c2.length){
				var top1 = c1.offset().top;
				var top2 = c2.offset().top;
				if (top1 != top2){
					b1.scrollTop(b1.scrollTop()+top1-top2);
				}
			}*/
			var b1 = $('.datagrid-list1 .list-body');
			b1.scrollTop($(this).scrollTop());
			var c1 = b1.children('.datagrid-body-inner').children(':first');
			var c2 = $(this).children(':first');
			if (c1.length && c2.length){
				var top1 = c1.offset().top;
				var top2 = c2.offset().top;
				if (top1 != top2){
					b1.scrollTop(b1.scrollTop()+top1-top2);
				}
			}
			$('.datagrid-list2').children('div.list-header,div.list-footer').scrollLeft($(this).scrollLeft());
			$(this).children('table').css('left', -$(this).scrollLeft());
		});
	});
	
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
				<li><a href="javascript:void(0);" onclick="find(1)"
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
  
    <!-- div class="myui-datagrid" myui-options="url:'${ctx}/pim_sys-user!findSysUserPagerTest.action',multiSort:true,showColumn:true,showFilters:true,exportUrl:'${ctx}/pim_sys-user!testExport.action',exportFileName:'userlist',exportFileType:'xlsx'" width="1200px">
		<table cellspacing="0" cellpadding="0" align="center" border="0" width="100%" height="100%">
			<tr>
				<th myui-options="field:'id',checkbox:true"></th>
				<th myui-options="field:'logid',sortable:true,hidden:true"><s:text name="sysauth_sysuser_logid" /></th>
				<th myui-options="field:'nam',sortable:true"><s:text name="sysauth_sysuser_nam" /></th>
				<th myui-options="field:'orgidt'"><s:text name="org_orgidt" /></th>
				<th myui-options="field:'orgnam'"><s:text name="org_orgnam" /></th>
				<th myui-options="field:'modate',datatype:'number'">修改日期</th>
			</tr>
		</table>
	</div-->
	
	
	
	<div class="myui-datagrid2" >
		<div class="datagrid-header" style="width: 1020px">
			<div class="datagrid-title"></div>
			<div class="tableop">
				<ul>
					<li><a href="javascript:void(0);"
						onclick="expObjs('excel2003');" actionCode="ACTION_PIM_USER_EXP"
						>test123
					</a>
					</li>
					<li><a href="javascript:void(0);"
						onclick="expObjs('excel2003');" actionCode="ACTION_PIM_USER_EXP"
						>ttttt
					</a>
					</li>
				</ul>
			</div>
		</div>
		<div class="datagrid-body" style="width: 1200px">
			<div class="datagrid-list" style="width: 1200px; height: 400px">
				<div style="width: 500px;" class="datagrid-list1">
					<div class="list-header">
						<div class="list-header-inner">
							<table class="list-header-table">	
								<tbody>
									<tr class="header-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"></div></td>
										<td><div 	class="list-cell" style="width: 226px">登录编号</div></td>
										<td><div 	class="list-cell" style="width: 226px">名称</div></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div style="height: 375px"  class="list-body">
						<div class="list-body-inner">
							<table class="list-body-table" cellspadding="0" cellspacing="0">	
								<tbody>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell" style="width: 226px">admin</div></td>
										<td><div 	class="list-cell" style="width: 226px">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
									<tr class="data-row">
										<td class="list-cell-widgets-td"><div class="list-cell-widgets"><input type="checkbox" name="checkboxitem" value="id"/></div></td>
										<td><div 	class="list-cell">admin</div></td>
										<td><div 	class="list-cell">超级管理员用户</div></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="list-footer"></div>
				</div>
				<div style="width: 700px;" class="datagrid-list2">
					<div class="list-header">
						<div  class="list-header-inner">
							<table class="list-header-table" style="width: 927px">	
								<tbody>
									<tr class="header-row">
										<td><div 	class="list-cell"  style="width: 300px">机构号</div></td>
										<td><div 	class="list-cell"  style="width: 300px">机构名称</div></td>
										<td><div 	class="list-cell"  style="width: 300px">修改日期</div></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div style="height: 375px" class="list-body">
							<table class="list-body-table" width="927px">	
								<tbody>
									<tr class="data-row">
										<td><div 	class="list-cell"  style="width: 300px">A0013</div></td>
										<td><div 	class="list-cell"  style="width: 300px">中国银行安徽省分行</div></td>
										<td><div 	class="list-cell"  style="width: 300px"></div></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
									<tr class="data-row">
										<td><div 	class="list-cell">A0013</div></td>
										<td><div 	class="list-cell">中国银行安徽省分行</div></td>
										<td></td>
									</tr>
								</tbody>
							</table>
					</div>
					<div class="list-footer"></div>
				</div>
			</div>
			<div class="datagrid-pager pagination" style="width: 1196px">
				<div class="pagination-info">共17条&nbsp;首页&nbsp;上一页&nbsp;<a href="javascript:cx(2)">下一页</a>&nbsp;<a href="javascript:cx(2)">末页</a>&nbsp;第1/2页</div>
			</div>
		</div>
		<div class="datagrid-footer"></div>
	</div>
  </body>
  
  
  
</html>
