<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link type="text/css" href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" />
<link type="text/css" href="${ctx}/mybi/gdp/themes/${apptheme}/gdp.css" rel="stylesheet" />
<link type="text/css" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/json2.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<style type="text/css">
.config-container {width:1200px;margin-left:15px;}
.form-table {font-size:14px;font-family:微软雅黑;margin-left:50px;width:1100px;}
.form-table tr td{height:30px;text-align:left;}
.form-table tr .label{width:90px;text-align:right;padding-right:5px;}
.form-table tr .label b{color:#FF0000;font-size:16px;vertical-align: middle;}
.form-table tr .input{width:165px;text-align:left;}
.form-table tr .tip {width:150px;}
.form-table tr .tip div{width:145px;text-align:left;margin-left:5px;}
.map-title-table {border-collapse:collapse;width:688px;table-layout:fixed;}
.map-title-table tr {height:25px;background-color:#F8F6ED;font-size:13px;font-family:微软雅黑;}
.map-title-table tr th{border:1px solid #E0DFDF;border-bottom:none;}
.map-rec-table {border-collapse:collapse;width:100%;font-size:13px;font-family:微软雅黑;}
.map-rec-table tr {height:30px;}
.map-rec-table .selected {height:30px;background-color:#99D9EA;}
.map-rec-table tr td{border:1px solid #E0DFDF;white-space:nowrap;overflow:hidden;}
.map-rec-table-tr-odd {background-color:#F0F0F0}
.map-rec-table-tr-even {background-color:#FFFFFF}
</style>
<script type="text/javascript">
var fileName;
$(function(){
	loadLocationLeading("${authMenuId}","${session.i18nDefault}");
	// 页面元素初始化
	initPage();
	$("body").unbind();
});

function initPage() {
	// 初始化数据库表资源下拉combo控件
	$("#tabName").combo({
		mode : "local",
		data : ${request.tabresList},
		textField : "tabComment",
		valueField : "tabName",
		isCustom : true,
		customData : [{tabName:"",tabComment:"<s:text name='gdp_common_pleaseSelect'/>"}], // 默认显示请选择
		panelHeight : 250,
		panelWidth : 200
	});
	// 初始化导入方式下拉combo控件
	$("#impType").combo({
		mode : "local",
		// 0清空导入 1追加导入
		data : [{text:"<s:text name='gdp_config_clearImport'/>",value:"0"},
			    {text:"<s:text name='gdp_config_appendImport'/>",value:"1"}],
		panelHeight : 50
	});
	$.post("gdp_scheme-fix!checkHasSaved.action", {"schemeObj.schemeId" : "${schemeId}"}, function(data){
		if (data.hasSaved == "true") {
			$.post("gdp_scheme-fix!findSavedSheetInfo.action", {"schemeId" : "${schemeId}"}, function(data){
				if (data.dimList.length > 0) {
					renderDimTable(data.dimList);
				}
				if (data.fixconfObj != null) {
					$("#tabName").combo("setValue", data.fixconfObj.tabName);
					$("#impType").combo("setValue", data.fixconfObj.impType);
				}
			}, "json");
		} else {
			renderDimTable(data.dimList);
		}
	}, "json");
}

// 选择文件事件
function fileOnChange(target) {
	// 获取文件路径
	var path = $(target).val();
	// 将文件路径赋给文件文本框
	$("#fileText").val(path);
}

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
	var fileType = path.substring(path.lastIndexOf(".") + 1, path.length).toUpperCase();
	if (path.lastIndexOf(".") < 0 || fileType != "XLS" && fileType != "XLSX" ) {
		$.messager.alert('<s:text name="common_msg_info"/>',"请选择有效文件",'info');
		return;
	}
	add_onload();
	$.ajaxFileUpload({
		url : "gdp_scheme-fix!uploadFixTmplFile.action", // 用于文件上传的服务器端请求地址
		secureuri : false, // 一般设置为false
        fileElementId : 'fixTmpl', // 文件上传DOM元素的id属性
        dataType : 'text/json', // 返回值类型 一般设置为json
        success : function(data, status){ // 服务器成功响应处理函数
          	if (data.result == "fail") {
          		// 上传失败提示异常信息;
           		$.messager.alert('<s:text name="common_msg_info"/>', data.msg, 'info');
           		return;
           	}
           	fileName = data.fileName;
            // 解析模板文件
            var updParamObj = {
            	"fixconfObj.schemeId" : "${schemeId}",
            	"fixconfObj.tabName" : $("#tabName").combo("getValue"),
            	"fixconfObj.impType" : $("#impType").combo("getValue"),
            }
            // 解析文件获得映射关系；
            $.post("gdp_scheme-fix!getFixTmplFileSheetInfo.action",updParamObj,function(data){
            	clean_onload();
            	if (data.result == "succ"){
            		//renderItemTable(data.itemList);
            		renderDimTable(data.dimList);
            	}else if (data.result == "fail"){
            		$.messager.alert('<s:text name="common_msg_info"/>', data.msg, 'info');
            	}
            },"json");
        }
	});
}

// 渲染表格；
function renderItemTable(itemList) {
	if (itemList.length > 0) {
		var htm = "";
		$.each(itemList, function(idx, item){
			htm += "<tr><td width='100' align='center'>" + item.itemCode + "</td>";
			htm += "<td width='200'>" + item.itemName + "</td>";
			htm += "<td width='50' align='center'>" + item.sheetNo + "</td>";
			htm += "<td width='50' align='center'>" + item.rowNo + "</td>";
			htm += "<td width='50' align='center'>" + item.colNo + "</td></tr>";
		});
		$("#itemTable").html(htm);
	} else {
		$("#itemTable").html("<tr><td colspan='5'>未解析到项目数据！</td></tr>");
	}
}

function renderDimTable(dimList) {
	if (dimList.length > 0) {
		var htm = "";
		$.each(dimList, function(idx, item){
            var typ = "";
            if (item.type == "F") {
            	typ = "文件名维度";
            } else if (item.type == "S") {
            	typ = "Sheet名维度";
            } else if (item.type == "R") {
            	typ = "行扩展维度";
            } else if (item.type == "C") {
            	typ = "列扩展维度";
            } else if (item.type == "P") {
            	typ = "单元格维度";
            }
			htm += "<tr><td width='100'>" + item.dimCode + "</td>";
			htm += "<td width='80' align='center'>" + (item.imp=="Y"?"是":"否") + "</td>";
			htm += "<td width='150' align='center'>" + typ + "</td>";
			htm += "<td width='80' align='center'>" + item.count + "</td>";
			htm += "<td width='250'>" + item.endFlag + "</td>";
			htm += "<td width='80' align='center'>" + (item.partition=="Y"?"是":"否") + "</td>";
			htm += "<td width='80' align='center'>" + item.rowNo + "</td>";
			htm += "<td width='80' align='center'>" + item.colNo + "</td>";
			htm += "<td width='250'>" + item.dimInfo + "</td></tr>";
		});
		$("#dimTable").html(htm);
	} else {
		$("#dimTable").html("<tr><td colspan='9'>没有数据，请上传并解析模板文件</td></tr>");
	}
}

// 保存定长sheet映射
function saveFixSheetMap() {
	var tabName = $("#tabName").combo("getValue");
	if (tabName == null || tabName == "") {
		$.messager.alert("提示", "请选择要导入的数据库表", "info");
		return;
	}
	$.post("gdp_scheme-fix!checkHasSaved.action", {"schemeObj.schemeId" : "${schemeId}"}, function(data){
			var paramObj = {
					"fixconfObj.schemeId" : "${schemeId}",
					"fixconfObj.impType" : $("#impType").combo("getValue"),
					"fixconfObj.tabName" : tabName,
					hasSaved : "0"
				};
			if (data.hasSaved == "true") {
				paramObj.hasSaved = "1";
			}
			$.post("gdp_scheme-fix!saveFixSchemeSheetInfo.action", paramObj, function(data){
				if (data.result == "succ") {
					$.messager.alert("提示", "保存成功", "info");
				} else {
					$.messager.alert("提示", "保存失败", "info");
				}
			}, "json");
	}, "json");
}

</script>

</head>
<body style="height:870px;">

<div class="myui-template-top-location"></div>

<div class="config-container">
	<form id="form_input" method="post">
	<table class="form-table" align="center" cellpadding="0" cellspacing="0" >
		<tr>
			<!-- 数据库表 -->
			<td class="label"><s:text name="gdp_config_databaseTable"/>:</td>
			<td class="input"><input id="tabName" name="tabName" style="width:180px;"/></td>
            <!-- 导入方式 -->
            <td class="label"><s:text name="gdp_config_impType"/>:</td>
            <td class="input"><input id="impType" name="impType" style="width:180px;"/></td>
			<!-- 模板文件 -->
			<td class="label"><s:text name="gdp_config_templateFile"/>:</td>
			<td class="input" style="width:230px;">
				<input id="fileText" class="myui-fileupload-text" type="text" readonly="readonly" style="width:90px;" value="<s:text name='gdp_config_clickToSelectFile'/>"/>
				<span class="myui-fileupload-wrap" style="position:relative;display:inline-block">
					<!-- 浏览 -->
					<a id="fileScan" href="javascript:void(0)" class="myui-fileupload-btn" style="position:absolute;z-index:-9"><s:text name="gdp_upload_browse"/></a></a><input type="file" id="fixTmpl" name="fixTmpl" onchange="fileOnChange(this)" style="width:43px;height:22px;cursor: pointer;vertical-align:middle;position:absolute;opacity: 0;filter: alpha(opacity=0);"/>
				</span>
				<!-- 上传 -->
				<a href="javascript:void(0)" class="myui-fileupload-btn" style="width:100px;" onclick="ajaxFileUpload()">上传并解析文件</a>
			</td>
		</tr>
	</table>
	</form>
</div>

<div class="config-container">
  <table class="tree-table" align="center" cellpadding="0" cellspacing="0" style="width:100%;">
    <tr>
      <td colspan="5" align="center" style="padding:25px 0 10px 0;">
        <!-- 保存 -->
        <a href="javascript:void(0)" onclick="saveFixSheetMap()" class="myui-button-query-main" >
          <s:text name="gdp_common_save"/></a>
      </td>
    </tr>
  </table>
</div>

<div class="myui-layout" style="margin-left:15px;">
    <div class="content" style="width:1205px;height:450px;" title="模板文件维度配置信息">
      <table style="width:1200px;" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td>
            <table class="map-title-table" cellspacing="0" cellpadding="0" align="center" border="0" style="width:1200px;">
              <tr>
                <th width="100">维度字段</th>
                <th width="80">是否导入</th>
                <th width="150">类型</th>
                <th width="80">导入数量</th>
                <th width="250">结束标志</th>
                <th width="80">是否分区</th>
                <th width="80">行号</th>
                <th width="80">列号</th>
                <th width="250">关键字</th>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <div style="overflow-y:auto;overflow-x:hidden; width:100%; height:392px;background-color:#FBFBFB"> 
                  <table class="map-rec-table" style="table-layout:fixed;width:1200px;" cellspacing="0" cellpadding="0" border="0"> 
                    <tbody id="dimTable">
                    </tbody>
                  </table>
                </div>
          </td>
        </tr>
      </table>
    </div>
</div>

<div id="inputWin"></div>

</body>
</html>

