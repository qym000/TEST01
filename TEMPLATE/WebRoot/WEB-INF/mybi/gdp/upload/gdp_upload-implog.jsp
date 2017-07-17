<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<!-- 缺口数据导数日志 -->
<title><s:text name="gdp_upload_gapDataLog"/></title>
<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<style type="text/css">
.link-style {color:blue}
.link-style:HOVER{color:blue;text-decoration:underline;}
</style>
<script type="text/javascript">
	var logList = ${request.logList};
	var logSize = ${showSize};
	// 主初始化函数
	$(function(){
		// 页面元素初始化
		initPage();
	})
	
	// 页面元素初始化
	function initPage() {
		if (logList != null && logList.length > 0) {
			var htm = "";
			for (var i = 0; i < logList.length; i++) {
				htm += "<tr><td align='center'>"+ (i + 1) +"</td>";
				htm += "<td align='center'>"+logList[i].sheetNum+"</td>";
				htm += "<td align='center'>"+logList[i].rowNum+"</td>";
				htm += "<td>"+logList[i].tabName+"</td>";
				htm += "<td align='center'><a href='javascript:void(0)' onclick='toViewLogDetail(\""+logList[i].taskId+"\",\""+logList[i].logNo+"\")' class='link-style'>查看详情</a></td>";
				htm += "</tr>";
				if ( i == logSize - 1) {
					break;
				}
			}
			$("#databody").html(htm);
		}else {
			$("#databody").html("<tr><td colspan='5'><s:text name='common_msg_nodata'/></td></tr>");
		}
		splitRow("datagrid")
	}
	
	// 查看日志详情
	function toViewLogDetail(taskId,logNo) {
		$("#inputWin").window({
			open : true,
			headline:"<s:text name='gdp_upload_logDetail'/>",
			content:'<iframe src=gdp_upload!toViewLogDetail.action?taskId='+taskId+'&logNo='+logNo+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:435
		});
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
<body style="height:640px;">

<div class="myui-layout" style="width:1150px;margin:auto;">
	<div class="content" style="height:250px;" title="<s:text name='gdp_upload_gapDataLog'/> --【<s:text name='gdp_upload_scheme'/>】${request.schemeName}">
		<pre id="logArea" style="margin:auto;width:100%;height:250px;font-size:13px;font-family:微软雅黑;overflow:auto;background-color:#FCFCFC">${request.impLog}</pre>
	</div>
	<div class="content" title="错误对照表(最多显示${showSize}条)" style="height:500px;">
		<div class="myui-datagrid" style="width:1140px;">
			<table style="width:1130px;">
				<tr>
					<!-- 序号 -->
					<th>序号</th>
					<!-- 错误Sheet -->
					<th>错误Sheet号</th>
					<!-- 错误行号 -->
					<th>错误行号</th>
					<!-- 表名 -->
					<th>表名</th>
					<!-- 操作 -->
					<th>操作</th>
				</tr>
				<tbody id="databody">
				</tbody>		
			</table>
		</div>
	</div>
</div>

<div id="inputWin"></div>

</body>
</html>

