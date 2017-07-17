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
<script type="text/javascript" src="${ctx}/mybi/common/scripts/ajaxfileupload/ajaxfileupload.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<style type="text/css">
.config-container {width:1200px;padding-bottom:10px;margin-left:15px;}
.form-table {font-size:14px;font-family:微软雅黑;margin-left:50px;}
.form-table tr td{height:30px;text-align:left;}
.form-table tr .label{width:100px;text-align:right;padding-right:5px;}
.form-table tr .label b{color:#FF0000;font-size:16px;vertical-align: middle;}
.form-table tr .split{width:100px;}
.form-table tr .input{width:200px;text-align:left;}
.form-table tr .tip {width:150px;}
.form-table tr .tip div{width:145px;text-align:left;margin-left:5px;}
.tree-table {font-size:14px;font-family:微软雅黑;}
.tree-table tr .title{padding:15px 0 5px 0;}
.tree-table tr .split{width:50px;text-align:center;font-size:20px;color:#A0A0A0;cursor: default;}
.file-preview {font-size:12px;margin-top:15px;margin-bottom:10px;font-family:微软雅黑}
.file-table {width:1150px;overflow:auto;font-size:14px;border-right:1px solid #A0A0A0;font-family:微软雅黑}
.file-table th {background-color:#17A1F9;color:#FFF;height:25px;border-left:1px solid #A0A0A0;white-space:nowrap;}
.file-table td {height:25px;border-left:1px solid #A0A0A0;border-bottom:1px solid #A0A0A0;white-space:nowrap;}
.gdp-btn-big {vertical-align:middle;color:#727272;margin-left:15px;border: 1px solid #dbdbdb;background-color:#FBFBFB;font-size:13px;padding:6px 15px;font-family:微软雅黑,黑体;cursor: pointer;}
.gdp-btn-big:HOVER{color:#fe710a;}
.map-title-table {border-collapse:collapse;width:888px;table-layout:fixed;}
.map-title-table tr {height:25px;background-color:#F8F6ED;font-size:13px;font-family:微软雅黑;}
.map-title-table tr th{border:1px solid #E0DFDF;border-bottom:none;}
.map-rec-table {border-collapse:collapse;width:100%;font-size:13px;font-family:微软雅黑;}
.map-rec-table tr {height:30px;cursor:pointer;}
.map-rec-table .selected {height:30px;background-color:#99D9EA;}
.map-rec-table tr td{border:1px solid #E0DFDF;white-space:nowrap;overflow:hidden;}
.map-rec-table-tr-odd {background-color:#F0F0F0}
.map-rec-table-tr-even {background-color:#FFFFFF}
</style>
<script type="text/javascript">
	var imgHtml = "<img src='${ctx}/mybi/gdp/themes/${apptheme}/images/accept.png' style='vertical-align:middle;'/>";
	// 该方案已配置标识
	var hasConf = ${request.hasConf};
	// 排序标识
	var sortFlag = 0;
	// 模板文件列节点；
	var fileColNodes;
	
	// 文件列树设置选项
	var setting = {
		view: {
			dblClickExpand: false, // 取消双击展开节点
			selectedMulti : false,
			showIcon : false, // 取消图标
			fontCss : setFontCss
		},
		check : {
			enable : false // 启用复选框
			//chkStyle : "radio" // 单选样式
		},
		data: {
			key : {
				title : "desc" // 悬浮提示为节点的"desc"属性
			},
			simpleData: {
				enable: true // 使用id和pId的简单数据格式
			}
		},
		callback : {
			onClick : fileColTreeOnClick, // 文件列点击事件
			onDblClick : addColMap // 双击节点添加映射
		}
	};
	
	// 已映射设置为蓝色字
	function setFontCss(treeId,treeNode) {
		return treeNode.hasMap?{"color":"blue"}:{"color":"black"};
	}
	
	// 主初始化函数
	$(function(){
		// 添加导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
		// 页面元素初始化
		initPage();
		$("body").unbind();
	})
	
	//隔行变色
   	function splitRow() {
   		$(".map-rec-table tr").addClass('map-rec-table-tr-odd'); 
   		$(".map-rec-table tr:even").addClass('map-rec-table-tr-even'); 
   	}
	
	// 获取远程表资源字段数据；
	function getRemoteTabCols(tabName) {
		$.ajax({
			url : "${ctx}/gdp_scheme-config!getTabCols.action",
			type : "post",
			data : {tabName:tabName},
			async : false,
			success : function(data){
				var htm = "";
				$.each(data,function(idx,item){
					htm += "<tr title='字段名称：" + item.colName + "；字段注释：" + item.colComment +"；数据类型：" + item.dataDesc + "；可否为空：" + item.nullable + "；'>";
					htm += "<td width='25' align='center'><input type='checkbox' name='checkboxitem' mapType='N' tabCol='"+item.colName+"' colComment='"+item.colComment+"' ordNo='"+item.ordNo+"'/></td>";
					htm += "<td width='200'>" + item.colComment + "</td>";
					htm += "<td width='150'>" + item.colName + "</td>";
					htm += "<td width='240'>N/A</td>";
					htm += "<td width='100' align='center'>无映射</td>";
					htm += "<td width='150'>N/A</td></tr>";
				});
				$(".map-rec-table").html(htm);
				splitRow();
				$("input[name='checkboxitem']").bind("click",function(e){
					e.stopPropagation();
				});
				$(".map-rec-table tr").bind("click",function(e){
					if($(this).hasClass("selected")){
						$(this).removeClass("selected");
					}else {
						$(this).parent().find("tr").removeClass("selected");
						$(this).addClass("selected");
					}
				});
			},
			dataType : "json"
		});
	}
	
	// 加载已配置的映射方案
	function loadVlmapCols(data) {
		var temp;
		$.each(data,function(idx,item){
			temp = $("input[name='checkboxitem'][tabCol='"+item.tabCol+"']");
			if (temp != null && temp != undefined) {
				$(temp).attr("mapType",item.mapType);
				if (item.mapType == "0") {
					$(temp).attr("fileCol",item.fileCol);
					$(temp).attr("fileColHead",item.fileColhead);
					$(temp).parent().parent().find("td").eq(3).text("【"+(item.fileCol+1)+"】" + item.fileColhead);
					$(temp).parent().parent().find("td").eq(4).text("字段映射");
				}else if (item.mapType == "1") {
					$(temp).parent().parent().find("td").eq(3).text("Sheet名称");
					$(temp).parent().parent().find("td").eq(4).text("Sheet页映射");
				}else if (item.mapType == "2") {
					$(temp).parent().parent().find("td").eq(3).text("@转换函数值@");
					$(temp).parent().parent().find("td").eq(4).text("函数映射");
				}
				if (item.funcId != null && item.funcId != undefined && item.funcId != "") {
					$(temp).attr("funcId",item.funcId);
					$(temp).parent().parent().find("td").eq(5).text(item.funcName);
				}
				if (item.mapType != "N") {
					var comment = $(temp).parent().parent().find("td").eq(1).text();
					$(temp).parent().parent().find("td").eq(1).html(imgHtml + comment);
				}
			}
		});
	}
	
	// 页面元素初始化
	function initPage() {
		$("#search").inputbox({
			type : "action",
			icon : "icon-search",
			onEnterDo : function(val) {
				$.fn.zTree.init($("#fileColTree"), setting, fileColNodes);
				var treeObj = $.fn.zTree.getZTreeObj("fileColTree");
				if ($.trim(val) != "") {
					var nodes = treeObj.getNodesByParamFuzzy("name", val, null);
					$.fn.zTree.init($("#fileColTree"), setting, nodes);
				}
			}
		});
		// 初始化数据库表资源下拉combo控件
		$("#tabName").combo({
			mode : "local",
			data : ${request.tabresList},
			textField : "tabComment",
			valueField : "tabName",
			isCustom : true,
			customData : [{tabName:"",tabComment:"<s:text name='gdp_common_pleaseSelect'/>"}], // 默认显示请选择
			panelHeight : 250,
			panelWidth : 200,
			onSelect : function(item) {
				if (item.tabName != "") {
					// 选择数据表后表名若不为空,刷新表字段
					getRemoteTabCols(item.tabName);
				}
			},
			onLoadSuccess : function() {
				if (hasConf) {
					// 若已配置,将已配置的信息回显
					$("#tabName").combo("setValue", "${vlconfObj.tabName}");
					getRemoteTabCols("${vlconfObj.tabName}");
					loadVlmapCols(${request.vlmapData});
				}
			}
		});
		// 初始化导入方式下拉combo控件
		$("#impType").combo({
			mode : "local",
			// 0清空导入 1追加导入
			data : [{text:"<s:text name='gdp_config_clearImport'/>",value:"0"},
			        {text:"<s:text name='gdp_config_appendImport'/>",value:"1"}],
			panelHeight : 50
		});
		$("#headLine").inputbox({
			type : "action",
			icon : "icon-reload",
			onEnterDo : function(val) {
				parseFileColumns();
			}
		});
		if (hasConf) {
			$("#impType").combo("setValue","${vlconfObj.impType}");
			$("#headLine").val("${vlconfObj.headLine}");
			$("#filterWord").val("${vlconfObj.filterWord}");
			// 加载文件列头Ztree
			$.fn.zTree.init($("#fileColTree"), setting, ${request.fileCols});
			var treeObj = $.fn.zTree.getZTreeObj("fileColTree");
			// 已映射的文件列头颜色置为蓝色；
			$.each(${request.vlmapData},function(idx,item){
				if (item.mapType == "0") {
					var node = treeObj.getNodeByParam("id",item.fileCol,null);
					if (node != null) {
						node.hasMap = true;
						treeObj.updateNode(node);
					}
				}
			});
			fileColNodes = treeObj.getNodes();
			// 加载文件预览HTML
			$("#preview").html("${request.previewHtml}");
		}
	}
	
	// 解析模板文件
	function parseFileColumns() {
		var paramObj = {
			headLine : $.trim($("#headLine").val()),
			id : "${sheetObj.id}"
		};
    	$.post("gdp_scheme-config!getFileColsBySheetNo.action",paramObj,function(data){
	        if (data.result == "succ") {
	        	// 加载文件列头Ztree
	            $.fn.zTree.init($("#fileColTree"), setting, data.fileCols);
	            var treeObj = $.fn.zTree.getZTreeObj("fileColTree");
    			fileColNodes = treeObj.getNodes();
	            // 加载文件预览HTML
	            $("#preview").html(data.previewHtml);
	        }else if (data.result == "fail"){
	            $.messager.alert('<s:text name="common_msg_info"/>', data.msg, 'info');
	        }
        },"json");
	}
	
	// 添加表字段与文件列映射
	function addColMap(event, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj("fileColTree");
		var colCked = $(".map-rec-table .selected");
		if (colCked.length > 0) {
			for (var i = 0; i < colCked.length; i++) {
				if ($(colCked[i]).find("input").attr("mapType") == 'N') {
					$(colCked[i]).find("td").eq(3).text(treeNode.name);
					$(colCked[i]).find("td").eq(4).text("字段映射");
					$(colCked[i]).find("input").attr("fileCol",treeNode.id);
					$(colCked[i]).find("input").attr("fileColHead",treeNode.fcName);
					$(colCked[i]).find("input").attr("mapType","0");
					treeNode.hasMap = true;
					treeObj.updateNode(treeNode);
					var comment = $(colCked[i]).find("td").eq(1).text();
					$(colCked[i]).find("td").eq(1).html(imgHtml + comment);
				}
			}
		}
		fileColNodes = treeObj.getNodes();
	}
	
	// 添加表字段与文件列映射2(点击“添加映射”按钮的事件)
	function addColMap2() {
		var treeObj = $.fn.zTree.getZTreeObj("fileColTree");
		if (treeObj == null || treeObj == "" || treeObj == undefined) {
			$.messager.alert('<s:text name="common_msg_info"/>', "请先解析模板文件", 'info');
			return;
		}
		var colCked = $(".map-rec-table .selected");
		if (colCked.length == 0) {
			$.messager.alert('<s:text name="common_msg_info"/>', "请选择要映射的字段", 'info');
			return;
		}
		var selNodes = treeObj.getSelectedNodes();
		if (selNodes.length == 0) {
			$.messager.alert('<s:text name="common_msg_info"/>', "请选择对应的文件列节点", 'info');
			return;
		}
		if (colCked.length > 0) {
			for (var i = 0; i < colCked.length; i++) {
				if ($(colCked[i]).find("input").attr("mapType") == 'N') {
					$(colCked[i]).find("td").eq(3).text(selNodes[0].name);
					$(colCked[i]).find("td").eq(4).text("字段映射");
					$(colCked[i]).find("input").attr("fileCol",selNodes[0].id);
					$(colCked[i]).find("input").attr("fileColHead",selNodes[0].fcName);
					$(colCked[i]).find("input").attr("mapType","0");
					selNodes[0].hasMap = true;
					treeObj.updateNode(selNodes[0]);
					var comment = $(colCked[i]).find("td").eq(1).text();
					$(colCked[i]).find("td").eq(1).html(imgHtml + comment);
				}
			}
		}
		fileColNodes = treeObj.getNodes();
	}
	
	// 文件列点击事件
	function fileColTreeOnClick(event, treeId, treeNode) {
		var fctObj = $.fn.zTree.getZTreeObj("fileColTree");
		// 高亮同时check该节点
		fctObj.checkNode(treeNode,true,false,true);
		var index = treeNode.id;
		$("#preview tr th").css({"background-color":"#17A1F9","color":"#FFF"});
		$("#preview tr th").eq(index).css({"background-color":"#FFEBC0","color":"#000"});
	}
	
	// 删除映射关系
	function delColMap() {
		var colCked = $("input[name='checkboxitem']:checked,.map-rec-table .selected td input");
		var treeObj = $.fn.zTree.getZTreeObj("fileColTree");
		if (colCked.length > 0) {
			for (var i = 0; i < colCked.length; i++) {
				if ($(colCked[i]).attr("mapType") != 'N') {
					// 若文件列没有被其他字段映射则颜色还原为黑色；
					if ($(colCked[i]).attr("mapType") == "0") {
						if (treeObj != null) {
							var node = treeObj.getNodeByParam("id",$(colCked[i]).attr("fileCol"),null);
							if (node != null) {
								var temp = $("input[fileCol='"+node.id+"']");
								if (temp.length == 1) {
									node.hasMap = false;
									treeObj.updateNode(node);
								}
							}
						}
					}
					var comment = $(colCked[i]).parent().parent().find("td").eq(1).text();
					$(colCked[i]).parent().parent().find("td").eq(1).text(comment);
					$(colCked[i]).parent().parent().find("td").eq(3).text("N/A");
					$(colCked[i]).parent().parent().find("td").eq(4).text("无映射");
					$(colCked[i]).parent().parent().find("td").eq(5).text("N/A");
					$(colCked[i]).attr("mapType","N");
					$(colCked[i]).removeAttr("fileCol");
					$(colCked[i]).removeAttr("fileColHead");
					$(colCked[i]).removeAttr("funcId");
				}
			}
		}
		$(colCked).removeAttr("checked");
		if (treeObj != null) {
			fileColNodes = treeObj.getNodes();
		}
	}
	
	// 添加转换函数
	function addTransFunc() {
		var colCked = $("input[name='checkboxitem']:checked,.map-rec-table .selected td input");
		if (colCked == null || colCked == "" || colCked == undefined || colCked.length == 0) {
			// 若未勾选则提示"请先在映射关系树中勾选要添加转换函数的字段"
			$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_checkToAddFunc'/>", 'info');
			return;
		}
		// 打开转换函数添加窗口
    	$("#inputWin").window({
			open : true,
			headline:"<s:text name='gdp_config_selectTransFunc'/>",
			content:'<iframe src=gdp_scheme-config!toTransFunc.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:500,
			panelHeight:350
		});
	}
	
	// 添加转换函数到映射关系树上
	function addFuncToMap(flag, funcId, funcName, funcExpr) {
		var colCked = $("input[name='checkboxitem']:checked,.map-rec-table .selected td input");
		if (colCked.length > 0) {
			if (flag) {
				for (var i = 0; i < colCked.length; i++) {
					$(colCked[i]).parent().parent().find("td").eq(5).text(funcName);
					$(colCked[i]).attr("funcId",funcId);
					if ($(colCked[i]).attr("mapType") == 'N') {
						var comment = $(colCked[i]).parent().parent().find("td").eq(1).text();
						$(colCked[i]).parent().parent().find("td").eq(1).html(imgHtml + comment);
						$(colCked[i]).parent().parent().find("td").eq(3).text("@转换函数值@");
						$(colCked[i]).parent().parent().find("td").eq(4).text("函数映射");
						$(colCked[i]).attr("mapType","2");					
					}
				}
			}else {
				for (var i = 0; i < colCked.length; i++) {
					$(colCked[i]).parent().parent().find("td").eq(5).text("N/A");
					$(colCked[i]).removeAttr("funcId");
					if ($(colCked[i]).attr("mapType") == '2') {
						$(colCked[i]).parent().parent().find("td").eq(3).text("N/A");
						$(colCked[i]).parent().parent().find("td").eq(4).text("无映射");
						$(colCked[i]).attr("mapType","N");					
					}
				}
			}
		}
	}
	
	// 保存方案配置
	function saveConfig() {
		var tabName = $("#tabName").combo("getValue");
		var mapArr = []; // 存储映射关系对象的数组
		if (tabName == null || tabName == "") {
			// 没有配置完成提示
			$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_notComplateConfig'/>", 'info');
			return;
		}
		var colMaps = $("input[name='checkboxitem'][mapType!='N']");
		if (colMaps == null || colMaps.length == 0) {
			// 没有配置完成提示
			$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_notComplateConfig'/>", 'info');
			return;
		}
		// 遍历所有已添加的映射关系
		$.each(colMaps, function(idx,item){
			obj = {
				tabCol : $.trim($(item).attr("tabCol")),
				tabColnam : $.trim($(item).attr("colComment")),
				mapType : $.trim($(item).attr("mapType")),
				ordNo : $.trim($(item).attr("ordNo"))
			}; // 将映射关系以对象形式存储
			if (obj.mapType == "0") {
				obj.fileCol = $.trim($(item).attr("fileCol"));
				obj.fileColHead = $.trim($(item).attr("fileColHead"));
			}
			if ($(item).attr("funcId") != null) {
				obj.funcId = $.trim($(item).attr("funcId"));
			}
			mapArr.push(obj); // 将映射关系对象添加至数组中
		});
		// 要保存的配置参数对象
		var paramObj = {
			"vlConfObj.schemeId" : "${sheetObj.id}",
			"vlConfObj.tabName" : tabName,
			"vlConfObj.headLine" : $.trim($("#headLine").val())==""?"0":$.trim($("#headLine").val()),
			"vlConfObj.impType" : $("#impType").combo("getValue"),
			"vlConfObj.filterWord" : $.trim($("#filterWord").val()),
			colMapJson : JSON.stringify(mapArr)
		};
		add_onload();//开启蒙板层
		$.post("${ctx}/gdp_scheme-config!saveSheetConfig.action",paramObj,function(data){
			clean_onload();
			if (data.result == "succ") {
				// 保存成功提示
				$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_common_saveSucc'/>",'info');
			}else {
				// 保存失败提示
				$.messager.alert('<s:text name="common_msg_info"/>',"<s:text name='gdp_common_saveFail'/>",'info');
			}
		},"json");
	}
	
	// 自动映射
	function autoMap() {
		var fctObj = $.fn.zTree.getZTreeObj("fileColTree");
		var tabCol = $("input[name='checkboxitem']");
		var tabColCk = $("input[name='checkboxitem']:checked");
		if (fctObj == null || tabCol.length == 0) {
			$.messager.alert('<s:text name="common_msg_info"/>',"请先选择数据库表和上传模板文件",'info');
			return;
		}
		/*
		if (tabColCk.length == 0) {
			$.messager.alert('<s:text name="common_msg_info"/>',"请选择要自动映射的字段",'info');
			return;
		}*/
		for (var i = 0; i < tabCol.length; i++) {
			var node = fctObj.getNodeByParam("fcName", $(tabCol[i]).attr("colComment"), null);
			if (node != null && node != "" && node.fcName == $(tabCol[i]).attr("colComment")) {
				var comment = $(tabCol[i]).parent().parent().find("td").eq(1).text();
				$(tabCol[i]).parent().parent().find("td").eq(1).html(imgHtml+comment);
				$(tabCol[i]).parent().parent().find("td").eq(3).html(node.name);
				$(tabCol[i]).parent().parent().find("td").eq(4).text("字段映射");
				$(tabCol[i]).attr("fileCol",node.id);
				$(tabCol[i]).attr("fileColHead",node.fcName);
				$(tabCol[i]).attr("mapType","0");
				node.hasMap = true;
				fctObj.updateNode(node);
			}
		}
		fileColNodes = fctObj.getNodes();
		sortColumns("MAPPED");
	}
	
	// 字段列表排序；
	function sortColumns(key) {
		var cols = $(".map-rec-table tr");
		if (key == "COLUMN") {
			if (cols.length > 1) {
				cols.sort(function(a,b){
					var tmp1 = parseInt($(a).find("input").attr("ordNo"),10);
					var tmp2 = parseInt($(b).find("input").attr("ordNo"),10);
					return  sortFlag==1?(tmp2-tmp1):(tmp1 - tmp2);
				});
				sortFlag = 1 - sortFlag;
			}
		}else if (key == "MAPPED") {
			if (cols.length > 1) {
				cols.sort(function(a,b){
					var tmp1 = $(a).find("td").eq(4).text()=="无映射"?-1:1;
					var tmp2 = $(b).find("td").eq(4).text()=="无映射"?-1:1;
					return  tmp1-tmp2;
				});
			}
		}
		var htm = "";
		$.each(cols,function(idx,item){
			htm += "<tr>" + $(item).html() + "</tr>";
		});
		$(".map-rec-table").html(htm);
		splitRow();
		$("input[name='checkboxitem']").bind("click",function(e){
			e.stopPropagation();
		});
		$(".map-rec-table tr").bind("click",function(e){
			if($(this).hasClass("selected")){
				$(this).removeClass("selected");
			}else {
				$(this).parent().find("tr").removeClass("selected");
				$(this).addClass("selected");
			}
		});
	}
</script>

</head>
<body style="overflow:hidden;">

<div class="myui-template-top-location">
   <ul class="index">
   	  <li><s:text name="common_msg_location"/>：</li>
   	  <s:iterator value="%{#request.locationList}" id="loc" status="index">
   	  	 <s:if test='#loc.url!=null'>
   	  	 	<s:if test="#index.last">
   	  	 		<li class="index_current"> <s:if test="#index.index >=1"> > </s:if> ${nam}&nbsp;</li>
   	  	 	</s:if><s:else>
   	  	 		<s:if test='#loc.url.indexOf("?")!=-1'>
   	  	 			<li class="index_current"> <s:if test="#index.index >=1"> > </s:if> <a href="${url}&authTyp=menu&authMenuId=${id}">${nam}</a>&nbsp;</li>
   	  	 		</s:if><s:else>
   	  	 			<li class="index_current"> <s:if test="#index.index >=1"> > </s:if> <a href="${url}?authTyp=menu&authMenuId=${id}">${nam}</a>&nbsp;</li>
   	  	 		</s:else>
   	  	 	</s:else>
   	  	 </s:if><s:else>
   	  	 	<li class="index_his"> <s:if test="#index.index >=1"> > </s:if> ${nam}&nbsp;</li>
   	  	 </s:else>
   	  </s:iterator>
   </ul>
</div>

<div class="config-container">
	<form id="form_input" method="post">
	<table class="form-table" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<!-- 数据库表 -->
			<td class="label"><s:text name="gdp_config_databaseTable"/>:</td>
			<td class="input"><input id="tabName" name="tabName" style="width:160px;"/></td>
			<!-- 导入方式 -->
			<td class="label"><s:text name="gdp_config_impType"/>:</td>
			<td class="input"><input id="impType" name="impType" style="width:160px;"/></td>
			<!-- 列头所在行 -->
			<td class="label"><s:text name="gdp_config_headerLine"/>:</td>
			<td class="input" >
				<input id="headLine" name="headLine" style="width:160px;"/>
			</td>
            <!-- 过滤关键词 -->
            <td class="label"><s:text name="gdp_config_filterWord"/>:</td>
            <td class="input" >
                <input id="filterWord" name="filterWord" style="width:160px;" class="myui-text"/>
            </td>
		</tr>
	</table>
	</form>
</div>

<div class="myui-layout" style="margin-left:15px;">
	<div class="rowgroup">
		<div class="content" style="width:890px;height:450px;" title="字段映射">
			<!-- 按钮操作区域样式名为operate，可以自由定义需要的按钮链接，必须写在内容的开头 -->
            <div class="operate">
            	<ul>
            		<!-- 转换函数 -->
                	<li><a href="javascript:void(0)"
                    	onclick="addTransFunc()" style="color:#374fff;"><s:text name="gdp_config_function"/></a></li>
                    <!-- 删除映射 -->
                    <li> <a href="javascript:void(0)"
                        onclick="delColMap()" style="color:#374fff;"><s:text name="gdp_config_delete"/></a></li>
                    <!-- 自动映射 -->
                    <li> <a href="javascript:void(0)"
                        onclick="autoMap()" style="color:#374fff;"><s:text name="gdp_config_auto"/></a></li>
                    <!-- 字段排序 -->
                    <li> <a href="javascript:void(0)"
                        onclick="sortColumns('COLUMN')" style="color:#374fff;">字段排序</a></li>
                </ul>
            </div>
			
			<table style="width:888px;" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td>
						<table class="map-title-table" cellspacing="0" cellpadding="0" align="center" border="0">
							<tr>
								<th width="25"><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
								<th width="200">字段注释</th><!-- 字段注释 -->
								<th width="150">字段名称</th><!-- 字段名称 -->
								<th width="240">对应文件列</th><!-- 对应文件列 -->
								<th width="100">映射类型</th><!-- 映射类型 -->
								<th width="150">转换函数</th><!-- 转换函数 -->
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<div style="overflow-y:auto;overflow-x:hidden; width:100%; height:392px;background-color:#FBFBFB"> 
				        	<table class="map-rec-table" style="table-layout:fixed;width:888px;" cellspacing="0" cellpadding="0" border="0"> 
				          	</table>
				       	</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="content" style="width:305px;height:450px;" title="模板文件列">
			<div class="operate">
            	<ul>
            		<!-- 添加映射 -->
                	<li><a href="javascript:void(0)"
                    	onclick="addColMap2()" style="color:#374fff;">添加映射</a></li>
                </ul>
            </div>
            <div style="width:303px;height:25px;">
				<input id="search" style="width:299px;height:25px;"/>
			</div>
			<div style="width:303px;height:390px;overflow:auto;background-color:#FBFBFB">
	        	<ul id="fileColTree" class="ztree"></ul>
	        </div>
		</div>
	</div>
</div>

<div class="config-container">
	<table class="tree-table" align="center" cellpadding="0" cellspacing="0" style="width:100%;">
		<tr>
			<td colspan="5" align="center" style="padding:25px 0 10px 0;">
				<!-- 保存 -->
				<a href="javascript:void(0)" onclick="saveConfig()" class="myui-button-query-main" >
					<s:text name="gdp_common_save"/></a>
			</td>
		</tr>
	</table>
</div>

<div id="previewDiv" class="config-container" style="border:none;">
	<!-- 文件预览(只显示前2行) -->
	<div class="file-preview"><s:text name="gdp_config_filePreview"/>：</div>
	<div style="width:1200px;height:105px;overflow:auto;">
		<table id="preview" class="file-table" cellpadding="0" cellspacing="0" align="center">
		</table>
	</div>
</div>

<div id="inputWin"></div>

</body>
</html>

