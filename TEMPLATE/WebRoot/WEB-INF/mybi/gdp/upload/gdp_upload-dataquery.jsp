<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- 缺口数据查询 -->
<title><s:text name="gdp_upload_gapDataQuery"/></title>
<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript">
	var curCols = null;
	var curTab = null;
	// 主初始化函数
	$(function(){
		// 页面元素初始化
		initPage();
		// 进入页面默认查询
	})
	
	// 分页查询缺口数据
	function cx(pNum) {
		if (curCols != null && curTab != null) {
			var paramObj = {
				tabName : curTab,
				columns : JSON.stringify(curCols),
				cendat : $("#cendat").datebox("getValue"),
				page : pNum
			}
			tmp_component_before_load("datagrid"); // 开启蒙板层;
			$.post("${ctx}/gdp_upload!findGdpDataPager.action",paramObj,function(data){
				$(".myui-datagrid-pagination").html(data.datapage);
				// 渲染数据
				if (data.datalist != null && data.datalist.length > 0) {
					var htm = "";
					$.each(data.datalist,function(idx,item){
						htm += "<tr>";
						$.each(curCols,function(i,col){
							if (item[col.colName] == undefined || item[col.colName] == null) {
								htm += "<td></td>";
							}else {
								htm += "<td align='center'>"+ item[col.colName] + "</td>";
							}
						});
						htm += "</tr>"
					});
					$("#databody").html(htm);
				}else {
					$("#databody").html("<tr><td colspan='100'><s:text name='common_msg_nodata'/></td></tr>")
				}
				tmp_component_after_load("datagrid");
			},"json");
		}
	}
	
	// 页面元素初始化
	function initPage() {
		// 数据日期控件初始化
		$("#cendat").datebox({
			defaultDate : "${request.cendat}"
		});
		// 数据库表下拉列表初始化
		$("#tabName").combo({
			mode : "local",
			data : ${request.tabList},
			textField : "tabComment",
			valueField : "tabName",
			isCustom : true,
			penelHeight : 140,
			onLoadSuccess : function(){
				// 当请求数据传到时,渲染数据表格的头部信息;
				$.post("${ctx}/gdp_upload!findColumnsByTabName.action",{"tabcolObj.tabName" : $("#tabName").combo("getValue")},function(data){
					if (data.colList != null && data.colList.length > 0) {
						curTab = $("#tabName").combo("getValue");
						curCols = data.colList;
						// 清除原有数据
						$("#databody").html("");
						$(".myui-datagrid-pagination").html("");
						renderColumns(data.colList);
					}
				},"json");
			},
			onSelect : function(item) {
				// 当请求数据传到时,渲染数据表格的头部信息;
				$.post("${ctx}/gdp_upload!findColumnsByTabName.action",{"tabcolObj.tabName" : item.tabName},function(data){
					if (data.colList != null && data.colList.length > 0) {
						curTab = item.tabName;
						curCols = data.colList;
						// 清除原有数据
						$("#databody").html("");
						$(".myui-datagrid-pagination").html("");
						renderColumns(data.colList);
					}
				},"json");
			}
		});
	}
	
	// 渲染datagrid的数据表头
	function renderColumns(colList) {
		var ths = "";
		$.each(colList,function(idx,item){
			if (item.colComment == undefined || item.colComment == null || item.colComment == '') {
				// 若果字段没有注释显示字段名
				ths += "<th>"+item.colName+"</th>";
			}else {
				// 否则显示字段注释;
				ths += "<th>"+item.colComment+"</th>";
			}
		});
		$("#tabCols").html(ths);
	}
</script>

</head>
<body style="height:640px;">

<div class="myui-layout" style="width:1150px;margin:auto;">
	<div class="content" style="height:750px;" title="<s:text name='gdp_upload_gapDataQuery'/> -- 【<s:text name='gdp_upload_scheme'/>】${schemeObj.schemeName}">
		<div class="myui-template-condition" style="width:1100px;">
		    <ul>
		    	<!-- 数据日期 -->
		   	    <li class="desc"><s:text name="gdp_upload_cendat"/>：</li>
		        <li>
		      	    <input type="text" id="cendat" name="cendat" style="width:160px"/>
			    </li>
			    <!-- 数据库表 -->
			    <li class="desc"><s:text name="gdp_config_databaseTable"/>：</li>
		        <li>
			  	    <input type="text" id="tabName" name="tabName" style="width:160px"/>
			    </li>
		    </ul>
		</div>
		
		<div class="myui-template-operating" style="width:1100px;">
			<div class="baseop">
				<ul>
					<!-- 查询 -->
					<li><a href="javascript:void(0)" onclick="cx(1)" class="myui-button-query-main" >
						<s:text name="common_action_select"/></a></li>
				</ul>
			</div>
		</div>
		
		<div class="myui-datagrid" style="width:1100px;">
			<table>
				<tr id="tabCols">
				</tr>
				<tbody id="databody">
				</tbody>		
			</table>
		</div>
		
		<div class="myui-datagrid-pagination"></div>
	</div>
</div>

<div id="inputWin"></div>

</body>
</html>

