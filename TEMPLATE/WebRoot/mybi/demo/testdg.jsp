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
	function find(){
		var logid = $("#logid").val();
		var orgidt = $('#orgidt').val();
		var param = {
			'obj.logid' : 	$.trim($("#logid").val()) ,
			'obj.orgidt' : 	$.trim($("#orgidt").val()) ,
			page:1
		};
		$('.myui-datagrid2').datagrid2('load',param);
	}

	function getcase(){
		var rst = $('.myui-datagrid2').datagrid2('getCase');
		top.$('body').attr('value',rst);
	}
	
	function loadcase(){
		var param = top.$('body').attr('value');
		var rst = $('.myui-datagrid2').datagrid2('loadCase',param);
	}
	
	function test(){
		$.messager.confirm2('<s:text name="common_msg_info"/>', "提示", function(){return "123";});
	}
	
	$(function(){
		/*$('.datagrid-list2 .list-body').bind('scroll', function(){
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
		});*/
	});
	
  </script>
  </head>
  <body style="height:500px;">
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
  
		<table class="myui-datagrid2" myui-options="url:'${ctx}/pim_sys-user!findSysUserPagerTest.action',multiSort:true,showColumn:true,showFilters:true,exportUrl:'${ctx}/pim_sys-user!testExport.action',exportFileName:'飒飒大师',exportFileType:'xlsx',selectMaxExportCnt:15" height=150>
			<thead myui-options="frozen:true">
				<tr>
					<th myui-options="field:'id',checkbox:true"></th>
					<th myui-options="field:'logid',sortable:true,align:'center',width:200"><s:text name="sysauth_sysuser_logid" /></th>
				</tr>
			</thead>
			<thead>	
				<tr>
					<th myui-options="field:'nam',sortable:true,width:200"><s:text name="sysauth_sysuser_nam" /></th>
					<th myui-options="field:'orgidt',align:'center',width:200"><s:text name="org_orgidt" /></th>
					<th myui-options="field:'orgnam',width:200"><s:text name="org_orgnam" /></th>
					<th myui-options="field:'modate',datatype:'number',align:'center',width:200">修改日期日期日期日期日期日</th>
				</tr>
			</thead>
		</table>
  </body>
</html>
