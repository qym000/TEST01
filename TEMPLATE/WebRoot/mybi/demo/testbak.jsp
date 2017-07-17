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
<link
	href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
  
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
	
  </script>
  </head>
  <body style="height:900px;">
	
	
  
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
	<div class="myui-datagrid2">
		<div class="datagrid-header">
		  
		  <div class="param">
		  	<div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_logid" />：</li>
					<li><input type="text" id="logid" name="logid"
						title='<s:text name="sysauth_sysuser_msg_logidnam"/>' /></li>
					<li class="desc"><s:text name="org" />：</li>
					<li><input type="text" id="orgidt" name="orgidt"
						title='<s:text name="common_msg_fuzzy_query"/>' /></li>
				</ul>
			</div>
			</div>
		
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
			<div class="tableop">
				<ul>
					<li><a href="javascript:void(0);">选择列</a>
					</li>
					<li><a href="javascript:void(0);">列筛选</a>
					</li>
					<li><a href="javascript:void(0);">导出</a>
					</li>
				</ul>
			</div>
		</div>
		<div class="datagrid-body" style="width: 1200px;">
			<div class="datagrid-list" style="width: 1200px; height: 300px;">
				<div class="datagrid-list1" style="width: 260px;">
					<div class="list-header">
						<div class="list-header-inner">
							<table class="list-header-table" cellspadding="0" cellspacing="0">
								<tbody>
									<tr class="header-row">
										<td class="list-cell-widgets-td" field="id"><div
												class="list-cell-widgets">
												<input type="checkbox">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width: 221px;">
												登录编号<span class="datagrid-sort-icon myui-common-hover">&nbsp;</span>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="list-body" style="height: 275px;">
						<div class="list-body-inner">
							<table class="list-body-table">
								<tbody>
									<tr class="data-row myui-datagrid-tr-odd" idx="0">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem"
													value="7171c33b51254b19b7debb081835419f">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">bnjvjkghk</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
										idx="1">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem"
													value="7d113581f1df4e4e9fc962595d74619a">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd" idx="2">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test12">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test12</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
										idx="3">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test11">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test11</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd" idx="4">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test10">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test10</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
										idx="5">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test9">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test9</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd" idx="6">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test8">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test8</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
										idx="7">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test7">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test7</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd" idx="8">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test6">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test6</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
										idx="9">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test5">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test5</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd" idx="10">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test4">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test4</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
										idx="11">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test3">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test3</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd" idx="12">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test2">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test2</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
										idx="13">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test1">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test1</div>
										</td>
									</tr>
									<tr class="data-row myui-datagrid-tr-odd" idx="14">
										<td class="list-cell-widgets-td"><div
												class="list-cell-widgets">
												<input type="checkbox" name="checkboxitem" value="test17">
											</div>
										</td>
										<td field="logid"><div class="list-cell"
												style="width:221px;text-align:center">test17</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="list-footer">
						<div class="list-footer-inner"></div>
					</div>
				</div>
				<div class="datagrid-list2" style="width: 940px;">
					<div class="list-header">
						<div class="list-header-inner">
							<table class="list-header-table" cellspadding="0" cellspacing="0">
								<tbody>
									<tr class="header-row">
										<td field="nam"><div class="list-cell"
												style="width: 221px;">
												名称<span class="datagrid-sort-icon myui-common-hover">&nbsp;</span>
											</div>
										</td>
										<td field="orgidt"><div class="list-cell"
												style="width: 221px;">机构号</div>
										</td>
										<td field="orgnam"><div class="list-cell"
												style="width: 221px;">机构名称</div>
										</td>
										<td field="modate"><div class="list-cell"
												style="width: 221px;">修改日期日期日期日期日期日</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="list-body" style="height: 275px;">
						<table class="list-body-table">
							<tbody>
								<tr class="data-row myui-datagrid-tr-odd" idx="0">
									<td field="nam"><div class="list-cell" style="width:221px"></div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160122</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
									idx="1">
									<td field="nam"><div class="list-cell" style="width:221px"></div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160301</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd" idx="2">
									<td field="nam"><div class="list-cell" style="width:221px">test12</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
									idx="3">
									<td field="nam"><div class="list-cell" style="width:221px">test11</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd" idx="4">
									<td field="nam"><div class="list-cell" style="width:221px">test10</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
									idx="5">
									<td field="nam"><div class="list-cell" style="width:221px">test9</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd" idx="6">
									<td field="nam"><div class="list-cell" style="width:221px">test8</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
									idx="7">
									<td field="nam"><div class="list-cell" style="width:221px">test7</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd" idx="8">
									<td field="nam"><div class="list-cell" style="width:221px">test6</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
									idx="9">
									<td field="nam"><div class="list-cell" style="width:221px">test5</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd" idx="10">
									<td field="nam"><div class="list-cell" style="width:221px">test4</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
									idx="11">
									<td field="nam"><div class="list-cell" style="width:221px">test3</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd" idx="12">
									<td field="nam"><div class="list-cell" style="width:221px">test2</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd myui-datagrid-tr-even"
									idx="13">
									<td field="nam"><div class="list-cell" style="width:221px">test1</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
								<tr class="data-row myui-datagrid-tr-odd" idx="14">
									<td field="nam"><div class="list-cell" style="width:221px">test17</div>
									</td>
									<td field="orgidt"><div class="list-cell"
											style="width:221px;text-align:center">A0013</div>
									</td>
									<td field="orgnam"><div class="list-cell"
											style="width:221px">中国银行安徽省分行</div>
									</td>
									<td field="modate"><div class="list-cell"
											style="width:221px;text-align:center">20160222</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="list-footer">
						<div class="list-footer-inner"></div>
					</div>
				</div>
			</div>
			<div class="datagrid-pager pagination" style="width: 1196px;">
				<div class="pagination-info">
					
					<div>
						<ul>
							<li><span class="prepagenolink">&lt; 上一页</span></li>
							<li><span class="pagenumsel">1</span></li>
							<li><span class="pagenum">2</span></li>
							<li><span class="pagenum">3</span></li>
							<li><span class="pagenum">4</span></li>
							<li><span class="pagenum">5</span></li>
							<li><span class="pagenum">6</span></li>
							<li><span class="pagenum">7</span></li>
							<li><span class="pagemore">...</span></li>
							<li><span class="nextpage">下一页 &gt;</span></li>
							<li><span class="totalpage">共15页</span></li>
							<li><span class="topage">到第 <input class="topagenum"/> 页</span></li>
							<li><span class="topagebtn">确 定</span></li> 
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="datagrid-footer"></div>
	</div>

