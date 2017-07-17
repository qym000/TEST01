<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/json2.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<style type="text/css">
.link-style {color:blue}
.link-style:HOVER{color:blue;text-decoration:underline;}
</style>
<script type="text/javascript">
	// 已保存sheet页列表标识
	var hasSaved = ${request.hasSaved};
	// 主初始化函数
	$(function(){
		// 添加导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
		// 页面元素初始化
		initPage();
	})
	
	// 页面元素初始化
	function initPage() {
		var htm = "";
		if (hasSaved) {
			// 若已经保存配置过sheet页子方案列表,则从数据库中查询并回显;
			$.post("${ctx}/gdp_scheme-config!findSheetSchemeList.action",
					{"sheetObj.schemeId" : "${request.schemeId}"},function(data){
				if (data != null && data.length > 0) {
					$.each(data,function(idx,item){
						htm += "<tr id='" + item.id + "'><td align='center'>"+ item.sheetNo + "</td>";
						htm += "<td>" + item.sheetName + "</td>";
						htm += "<td>" + item.schemeName + "</td>";
						htm += "<td align='center'>"+
							   "<a href='javascript:void(0)' class='link-style' onclick='toConfig(\""+item.id+"\")'><s:text name='gdp_common_configure'/></a>"+
						       "<a href='javascript:void(0)' class='link-style' onclick='deleteSheet(\""+item.id+"\")' style='margin-left:10px'><s:text name='gdp_config_delete'/></a></td></tr>";
					});
					$("#databody").html(htm);
				}	
			}, "json");
		}else {
			// 否则在datagrid中提示"没有数据"
			htm = "<tr><td colspan='4'><s:text name='gdp_config_nodata'/></td></tr>";
			$("#databody").html(htm);
		}
	}
	
	// 上传文件选择事件
	function fileOnChange(target) {
		// 获取文件路径
		var path = $(target).val();
		// 将文件路径赋给文件文本框
		$("#fileText").val(path);
	}
	
	// 上传模板文件
	function ajaxFileUpload() {
		// 获取上传的模板文件在本地的路径
		var path = $("#fileText").val();
		// 重新赋值为提示信息"点击选择文件"
		$("#fileText").val("<s:text name='gdp_config_clickToSelectFile'/>");
		if (path == "" || path == "<s:text name='gdp_config_clickToSelectFile'/>") {
			// 若没有选择文件提示先选择;
			$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_config_pleaseSelectFile'/>",'info');
			return;
		}
		// 获取模板文件的文件类型
		var fileType = path.substring(path.lastIndexOf(".") + 1, path.length);
		if (fileType != "xls" && fileType != "xlsx") {
			// 若不是有效的Excel则提示上传有效文件
			$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_config_pleaseExcelFile'/>",'info');
			return;
		}
		add_onload(); // 开启蒙板层
		$.ajaxFileUpload({
			url : "gdp_scheme-config!uploadVarTmplFile.action", // 用于文件上传的服务器端请求地址
			secureuri : false, // 一般设置为false
            fileElementId : 'varTmpl', // 文件上传DOM元素的id属性
            dataType : 'text/json', // 返回值类型 一般设置为json
            success : function(data, status){ // 服务器成功响应处理函数
            	if (data.result == "FAIL") {
            		// 上传失败提示异常信息;
            		$.messager.alert('<s:text name="common_msg_info"/>', data.msg, 'info');
            		return;
            	}
            	var paramObj = {
            		"schemeObj.schemeId" : "${request.schemeId}",
            		"schemeObj.schemeName" : "${request.schemeName}"
            	}
            	// 解析模板文件,取出sheet页信息生成datagrid
            	$.post("gdp_scheme-config!parseSheetInfoFromExcel.action", paramObj, function(data){
            		if (data.result == "succ") {
            			var htm = "";
            			$.each(data.dataList, function(idx, item) {
            				htm += "<tr id='" + item.id + "'><td align='center'>"+ item.sheetNo + "</td>";
            				htm += "<td>" + item.sheetName + "</td>";
            				htm += "<td>" + item.schemeName + "</td>";
            				htm += "<td align='center'>"+
            					   "<a href='javascript:void(0)' class='link-style' onclick='toConfig(\""+item.id+"\")'>配置</a>"+
            				       "<a href='javascript:void(0)' class='link-style' onclick='deleteSheet(\""+item.id+"\")' style='margin-left:10px'>删除</a></td></tr>";
            			});
            			$("#databody").html(htm);
            			hasSaved = false; // 已保存标识
            			clean_onload(); // 关闭蒙板层
            		}else if (data.result == "fail"){
            			// 异常提示
            			$.messager.alert('<s:text name="common_msg_info"/>', data.msg, 'info');
            		}
            	},"json");
            }
		});
	}
	
	// 删除一个sheet页
	function deleteSheet(id) {
		if (hasSaved) {
			// 若已保存了sheet页子方案列表,则从数据库中删除该对象
			// 提示确认信息:删除该子方案会同时删除相关的配置,是否确定执行此操作
			$.messager.confirm2("<s:text name='common_msg_info'/>","<s:text name='gdp_config_deleteConfirm'/>",function(r){
				if (r) {
				$.post("${ctx}/gdp_scheme-config!deleteSheetScheme.action", 
					   {"sheetObj.id" : id}, function(data){
					if (data.result == "succ") {
						$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='common_msg_succ'/>", 'info');
						initPage();
					}else {
						$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='common_msg_fail'/>", 'info');
					}
				},"json");
				}
			});
		}else {
			// 否则从DOM对象中删除
			$("#" + id).remove();
			if ($("#databody tr").length == 0) {
				// 没有数据,上传文件后自动读取
				$("#databody").html("<tr><td colspan='4'><s:text name='gdp_config_nodata'/></td></tr>");
			}
		}
	}
	
	// 转到sheet页子方案的配置界面
	function toConfig(id) {
		if (!hasSaved) {
			$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_beforeConfig'/>", 'info');
			return;
		}
		$("iframe",parent.document).attr("src",
			"${ctx}/gdp_scheme-config!toConfigSheetScheme.action?id="+id);
	}
	
	// 保存sheet页列表
	function saveSheetList() {
		if (hasSaved) {
			return; // 已经保存直接返回
		}
		if ($("#databody tr").length == 0 || $("#databody tr td").length == 1) {
			$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_notFoundSheet'/>", 'info');
			return;
		}
		var arr = []; // 保存sheet列表的数组
		$.each($("#databody tr"), function(idx,item){
			// 循环遍历sheet页子方案datagrid,获取sheet页信息封装为数组
			obj = {
				id : $(item).attr("id"),
				sheetNo : $(item).find("td").eq(0).text(),
				sheetName : $(item).find("td").eq(1).text()
			};
			arr.push(obj);
		});
		var paramObj = {
			"schemeObj.schemeId" : "${request.schemeId}",
			sheetsJson : JSON.stringify(arr)
		} // 参数对象
		$.post("${ctx}/gdp_scheme-config!saveSheetList.action", paramObj, function(data){
			if (data.result == "succ") {
				hasSaved = true; // 将已保存标识置为true
				// 保存成功提示
				$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_common_saveSucc'/>",'info');
			}else {
				// 保存失败提示
				$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_common_saveFail'/>",'info');
			}
		}, "json");
	}
	
</script>

</head>
<body style="height:640px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
    <ul>
    	<!-- 模板文件 -->
   	    <li class="desc"><s:text name="gdp_config_templateFile"/>：</li>
        <li>
			<input id="fileText" class="myui-fileupload-text" type="text" readonly="readonly" style="width:120px" value="<s:text name='gdp_config_clickToSelectFile'/>"/>
			<span class="myui-fileupload-wrap" style="position:relative;display:inline-block">
				<a id="fileScan" href="javascript:void(0)" class="myui-fileupload-btn" style="position:absolute;z-index:-9"><s:text name="gdp_upload_browse"/></a></a><input type="file" id="varTmpl" name="varTmpl" onchange="fileOnChange(this)" style="width:43px;height:22px;cursor: pointer;vertical-align:middle;position:absolute;opacity: 0;filter: alpha(opacity=0);"/>
			</span>
	    </li>
    </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<!-- 上传 -->
			<li><a href="javascript:void(0)" onclick="ajaxFileUpload()" class="myui-button-query-main" >
					<s:text name="gdp_common_upload"/></a></li>
			<!-- 保存 -->
			<li><a href="javascript:void(0)" onclick="saveSheetList()" class="myui-button-query" >
					<s:text name="gdp_common_save"/></a></li>
		</ul>
	</div>
</div>

<div class="myui-datagrid">
	<table>
		<tr>
			<!-- Sheet页编号 -->
			<th><s:text name="gdp_config_sheetNo"/></th>
			<!-- Sheet页名称 -->
			<th><s:text name="gdp_config_sheetName"/></th>
			<!-- 所属方案 -->
			<th><s:text name="gdp_config_belongScheme"/></th>
			<!-- 操作 -->
			<th><s:text name="gdp_common_operation" /></th>
		</tr>
		<tbody id="databody">
		</tbody>		
	</table>
</div>

<div class="myui-datagrid-pagination"></div>

</body>
</html>

