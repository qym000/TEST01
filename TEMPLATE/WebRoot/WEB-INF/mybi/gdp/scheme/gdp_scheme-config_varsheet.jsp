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
.config-container {
	margin-left:35px;
	width:1150px;
	padding-bottom:10px;
}
.form-table {font-size:14px;font-family:微软雅黑;margin-left:100px;}
.form-table tr td{height:30px;text-align:left;}
.form-table tr .label{width:100px;text-align:right;padding-right:5px;}
.form-table tr .label b{color:#FF0000;font-size:16px;vertical-align: middle;}
.form-table tr .split{width:50px;}
.form-table tr .input{width:165px;text-align:left;}
.form-table tr .tip {width:150px;}
.form-table tr .tip div{width:145px;text-align:left;margin-left:5px;}
.tree-table {font-size:14px;font-family:微软雅黑;}
.tree-table tr .title{padding:15px 0 5px 0;}
.tree-table tr .split{width:50px;text-align:center;font-size:20px;color:#A0A0A0;cursor: default;}
.file-preview {font-size:14px;margin-top:15px;margin-bottom:10px;font-family:微软雅黑}
.file-table {width:940px;overflow:auto;font-size:14px;border-right:1px solid #A0A0A0;font-family:微软雅黑}
.file-table th {background-color:#17A1F9;color:#FFF;height:25px;border-left:1px solid #A0A0A0;white-space:nowrap;}
.file-table td {height:25px;border-left:1px solid #A0A0A0;border-bottom:1px solid #A0A0A0;white-space:nowrap;}
.tree-box {width:345px;height:450px;border:1px solid #A0A0A0;}
.myui-file{
	line-height:22px;
	height:22px;
	border:1px solid #D2D2D2;
	background-color:#FBFBFB;
	width:113px;
	color:#A0A0A0;
	font-style:italic;
	cursor:pointer;
	font-size:12px;
	vertical-align:middle;
}
.gdp-btn-small {
	vertical-align:middle;
	color:#727272;
	margin-left:3px;
	border: 1px solid #dbdbdb;
	background-color:#FBFBFB;
	font-size:11px;
	padding:4px 8px;
	font-family:微软雅黑,黑体;
	cursor: pointer;
}
.gdp-btn-small:HOVER{
	color:#fe710a;
}
.gdp-btn-big {
	vertical-align:middle;
	color:#727272;
	margin-left:15px;
	border: 1px solid #dbdbdb;
	background-color:#FBFBFB;
	font-size:13px;
	padding:6px 15px;
	font-family:微软雅黑,黑体;
	cursor: pointer;
}
.gdp-btn-big:HOVER{
	color:#fe710a;
}
.oper-icon {
	height: 18px;
	width: 18px;
	overflow: hidden;
	display: inline-block;
	vertical-align: top;
	cursor: pointer;
	border : 1px solid #EFEFEF;
}
.oper-icon:HOVER {
	border : 1px solid #CCC;
}
.ztree li span.button.none_ico_docu{width:0px;}
.ztree li span.button.mapped_ico_docu{width:16px;}
</style>
<script type="text/javascript">
	// 该方案已配置标识
	var hasConf = ${request.hasConf};
	// 字段映射是否已全选
	var isAllChecked = true;
	// 数据库表字段树设置选项
	var setting = {
		view: {
			dblClickExpand : false, // 取消双击展开节点
			fontCss : {color:"blue"}
		},
		data: {
			key : {
				title : "desc" // 悬浮提示为节点的"desc"属性
			},
			simpleData: {
				enable: true // 使用id和pId的简单数据格式
			}
		},			
		async: {
			enable: true, // 启用异步请求节点数据
			url:"gdp_scheme-config!getTabColTreeNodes.action", // 异步请求url
			otherParam:{tabName:""} // 异步请求提交参数设置
		},
		callback : {
			onClick : tabColTreeOnClick, // 表字段树节点点击事件
			onAsyncSuccess : tabColTreeOnAsyncSuccess // 数据库表树加载成功事件
		}
	};
	
	// 文件列树设置选项
	var setting2 = {
		view: {
			dblClickExpand: false, // 取消双击展开节点
			showIcon : false // 取消图标
		},
		check : {
			enable : true, // 启用复选框
			chkStyle : "radio" // 单选样式
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
			onClick : fileColTreeOnClick // 文件列点击事件
		}
	};
	
	// 映射关系树
	var setting3 = {
		view: {
			showIcon : false, // 取消图标
			fontCss : colMapTreeGetFont // 映射关系树自定义字体样式
		},
		check : {
			enable : true
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
			beforeClick : colMapTreeBeforeClick, // 映射关系树点击前事件
			onClick : colMapTreeOnClick // 映射关系树点击事件
		}
	};

	// 主初始化函数
	$(function(){
		// 添加导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
		// 页面元素初始化
		initPage();
	})
	
	// 页面元素初始化
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
			panelWidth : 200,
			onSelect : function(item) {
				if (item.tabName != "") {
					// 选择数据表后表名若不为空,刷新表字段ztree树
					setting.async.otherParam.tabName = item.tabName;
					$.fn.zTree.init($("#tabColTree"), setting);
					$("#tabTitle").html(item.tabComment);
					// 重新选择数据表后重置映射关系树
					$.fn.zTree.init($("#colMapTree"), setting3, []);
				}
			},
			onLoadSuccess : function() {
				if (hasConf) {
					// 若已配置,将已配置的信息回显
					$.fn.zTree.init($("#colMapTree"), setting3, ${request.vlmapZtree});
					$("#tabName").combo("setValue", "${vlconfObj.tabName}");
					setting.async.otherParam.tabName = "${vlconfObj.tabName}";
					$.fn.zTree.init($("#tabColTree"), setting);
					$("#tabTitle").html($("#tabName").combo("getText"));
				}else {
					// 初始化映射关系树(初始无节点)
					$.fn.zTree.init($("#colMapTree"), setting3, []);
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
			// 加载文件列头Ztree
			$.fn.zTree.init($("#fileColTree"), setting2, ${request.fileCols});
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
	            $.fn.zTree.init($("#fileColTree"), setting2, data.fileCols);
	            // 加载文件预览HTML
	            $("#preview").html(data.previewHtml);
	        }else if (data.result == "fail"){
	            $.messager.alert('<s:text name="common_msg_info"/>', data.msg, 'info');
	        }
        },"json");
	}
	
	// 添加一条"表字段-文件列"映射
	function addColMap(){
		// 获取表字段ztree树对象
		var tctObj = $.fn.zTree.getZTreeObj("tabColTree");
		// 获取文件列头ztree树对象
		var fctObj = $.fn.zTree.getZTreeObj("fileColTree");
		// 获取映射关系ztree树对象
		var cmtObj = $.fn.zTree.getZTreeObj("colMapTree");
		// 若两个对象中任何一个为空,则返回
		if (tctObj == null || fctObj == null) {
			return;
		}
		// 获取表字段选中节点
		var tcNodes = tctObj.getSelectedNodes();
		if (tcNodes == "") {
			// 若表字段树无选中的节点,则提示请先选择表字段
			$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_selectTableColumn'/>", 'info');
			return;
		}
		// 查找映射树是否已经对该字段进行映射
		var mappedNode = cmtObj.getNodeByParam("id", tcNodes[0].id, null);
		if (mappedNode) {
			// 若已经映射该字段则提示并返回
			$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_columnHasMapped'/>", 'info');
			return;
		}
		// 获取文件列头勾选的节点
		var fcNodes = fctObj.getCheckedNodes();
		// 定义一个新的字段节点作为被映射节点
		var pNode = {
			id : tcNodes[0].id,
			pId : null,
			name : tcNodes[0].name,
			desc : tcNodes[0].desc,
			isParent : true,
			font : {'color' : 'blue'}
		};
		var mapNode = null;// 定义映射对象节点
		// 若文件列头没有被勾选的节点,则检查"映射为sheet页名称"的勾选状态,
		// 若为true且其他字段还没有映射该选项,则加入映射关系树
		if (fcNodes == "") {
			// 获取"空映射"选项的勾选状态
			var nullMapChecked = $("input[name='isNullMap']").is(":checked");
			if (nullMapChecked) {
				// 只选择了空映射
				pNodes = cmtObj.addNodes(null, pNode);
				mapNode = {
					id : "N@" + pNode.id,
					pId : pNode.id,
					name : "映射对象：空映射",
					desc : "空映射",
					nocheck : true
				};
				cmtObj.addNodes(pNodes[0], mapNode);
				cmtObj.selectNode(pNodes[0]);
				// 设置数据库表字段节点已映射样式
				tcNodes[0].iconSkin = "mapped";
				tctObj.updateNode(tcNodes[0]);
			}else {
				// 若既没有选中sheet页映射和空映射又没有勾选文件列节点,则提示返回
				$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_checkFileColumn'/>", 'info');
				return;
			}
		}else {
			if (fcNodes.length > 1) {
				// 只能选择一个文件列进行映射
				$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_onlyOneFileColumn'/>", 'info');
				return;
			} 
			// 若勾选了文件列节点则添加一个"数据库表列-文件列"映射关系节点
			pNodes = cmtObj.addNodes(null, pNode);
			$.each(fcNodes, function(idx, item){
				mapNode = {
					id : item.id + "@" + pNode.id, // 映射文件列id为"列标号@字段ID"
					pId : pNode.id, // 父节点为被映射的字段ID
					name : "映射对象：" + item.name,
					desc : item.desc, // 悬浮提示为文件列原提示
					fcName : item.fcName, // 原文件列名称
					fileCol : item.id, // 对应文件列标号
					nocheck : true
				}
				cmtObj.addNodes(pNodes[0], mapNode);
				cmtObj.selectNode(pNodes[0]);
				// 设置数据库表字段节点已映射样式
				tcNodes[0].iconSkin = "mapped";
				tctObj.updateNode(tcNodes[0]);
			});
		}
		// 还原(取消)勾选的文件列
		fctObj.checkAllNodes(false);
		// 取消勾选的"空映射"
		$("input[name='isNullMap']").attr("checked",false);
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
	
	// 表字段节点点击事件
	function tabColTreeOnClick(event, treeId, treeNode) {
		// 获取映射关系ztree树对象
		var cmtObj = $.fn.zTree.getZTreeObj("colMapTree");
		// 点击表字段节点的同时,将映射关系树对应字段的父节点也选中
		var nodes = cmtObj.getNodesByParam("id", treeNode.id, null);
		if (nodes != null && nodes.length > 0) {
			cmtObj.selectNode(nodes[0]);
		}else {
			// 若没有找到则取消选中
			var selectedNodes = cmtObj.getSelectedNodes();
			if (selectedNodes.length > 0) {
				cmtObj.cancelSelectedNode(selectedNodes[0]);
			}
		}
	}
	
	// 映射关系树点击前事件
	function colMapTreeBeforeClick(treeId, treeNode, clickFlag) {
		// 非父节点禁止选中
		return treeNode.isParent;
	}
	
	// 映射关系树点击节点事件
	function colMapTreeOnClick(event, treeId, treeNode) {
		// 获取表字段ztree树对象
		var tctObj = $.fn.zTree.getZTreeObj("tabColTree");
		if (treeNode.isParent) {
			// 若是字段父节点则点击映射字段节点的同时,将表字段树对应字段页选中(tabColTreeOnClick事件的逆操作)
			var nodes = tctObj.getNodesByParam("id", treeNode.id, null);
			if (nodes != null && nodes.length > 0) {
				tctObj.selectNode(nodes[0]);
			}else {
				// 若没有则取消选中
				var selectedNodes = tctObj.getSelectedNodes();
				if (selectedNodes.length > 0) {
					tctObj.cancelSelectedNode(selectedNodes[0]);
				}
			}
		}
	}
	
	// 映射关系树自定义字体样式
	function colMapTreeGetFont(treeId, node) {
		return node.font ? node.font : {};
	}
	
	// 映射关系树全选
	function colMapTreeCheckAll() {
		// 获取映射关系树ztree对象;
		var cmtObj = $.fn.zTree.getZTreeObj("colMapTree");
		if (isAllChecked) {
			cmtObj.checkAllNodes(true); // 全部勾选
			isAllChecked = false;
		}else {
			cmtObj.checkAllNodes(false);
			isAllChecked = true;
		}
	}
	
	// 删除映射关系
	function delColMap() {
		// 获取映射关系树ztree对象
		var cmtObj = $.fn.zTree.getZTreeObj("colMapTree");
		// 获取表字段树ztree对象
		var tctObj = $.fn.zTree.getZTreeObj("tabColTree");
		var ckNodes = cmtObj.getCheckedNodes();
		// 若映射关系树勾选节点存在,则删除映射,同时隐藏表字段树已映射图标
		if (ckNodes != null && ckNodes.length > 0) {
			$.each(ckNodes, function(idx,item){
				cmtObj.removeNode(item);
				// 找到表字段树对应的字段节点并取消前面的已映射图标
				var nodes = tctObj.getNodesByParam("id", item.id, null);
				if (nodes != null && nodes.length > 0) {
					nodes[0].iconSkin = "none";
					tctObj.updateNode(nodes[0]);
				}
			});
		}
	}
	
	// 添加转换函数
	function addTransFunc() {
		// 获取映射关系树ztree对象
		var cmtObj = $.fn.zTree.getZTreeObj("colMapTree");
		var ckNodes = cmtObj.getCheckedNodes();
		if (ckNodes == null || ckNodes == "" || ckNodes == undefined || ckNodes.length == 0) {
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
		// 获取映射关系树ztree对象
		var cmtObj = $.fn.zTree.getZTreeObj("colMapTree");
		var ckNodes = cmtObj.getCheckedNodes();
		var mapNode = null;
		$.each(ckNodes, function(idx,item){
			// 删除函数子节点
			funcNode = cmtObj.getNodesByParam("id", "F@"+item.id, item, null);
			if (funcNode != null && funcNode.length > 0) {
				cmtObj.removeNode(funcNode[0]);
			}
			if (flag) {
				// 若选择了函数则添加函数子节点
				mapNode = {
					id : "F@" + item.id, // 映射文件列id为"F@字段名"
					pId : item.id, // 父节点为被映射的字段ID
					name : "转换函数：" + funcName,
					desc : funcExpr, // 悬浮提示为函数表达式
					funcId : funcId, // 函数ID
					nocheck : true
				}
				cmtObj.addNodes(item, mapNode); // 添加转换函数子节点;
			}
		});
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
		var cmtObj = $.fn.zTree.getZTreeObj("colMapTree"); // 映射关系树ztree对象
		var pNodes = cmtObj.getNodesByParam("isParent",true,null); // 映射关系树的所有父节点(表字段节点)
		if (pNodes == 0) {
			// 没有配置完成提示
			$.messager.alert('<s:text name="common_msg_info"/>', "<s:text name='gdp_config_notComplateConfig'/>", 'info');
			return;
		}
		// 遍历所有已添加的映射关系节点
		$.each(pNodes, function(idx,item){
			obj = {
				tabCol : item.id,
				tabColnam : item.name,
				ordNo : idx
			}; // 将映射关系以对象形式存储
			nodes = cmtObj.getNodesByParam("pId",item.id,item);
			// 子节点为映射关系相关信息,循环遍历取出信息
			for (var i = 0; i < nodes.length; i++) {
				tmp = nodes[i].id.substring(0,2);
				if (tmp == "S@") {
					obj.mapType = "1"; // sheet页映射
				}else if (tmp == "N@") {
					obj.mapType = "2"; // 空映射
				}else if (tmp == "F@") {
					obj.funcId = nodes[i].funcId; // 转换函数
				}else {
					obj.fileCol = nodes[i].fileCol;
					obj.fileColhead = nodes[i].fcName;
					obj.mapType = "0"; // 普通映射
				}
			}
			mapArr.push(obj); // 将映射关系对象添加至数组中
		});
		// 要保存的配置参数对象
		var paramObj = {
			"vlConfObj.schemeId" : "${sheetObj.id}",
			"vlConfObj.tabName" : tabName,
			"vlConfObj.headLine" : $.trim($("#headLine").val())==""?"0":$.trim($("#headLine").val()),
			"vlConfObj.impType" : $("#impType").combo("getValue"),
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
	
	// 数据库表ZTREE树加载成功后的事件
	function tabColTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		if (hasConf) {
			// 当用户点击"方案配置"时,由java端判断该方案是否已经配置,若已配置在数据库表Ztree树回显后
			// 执行该方法,主要用于(1)将已配置字段图标加在数据库表Ztree树上 (2)将映射树上的父节点显示为蓝色
			// 若还没有配置该方案,此方法不执行;
			var tctObj = $.fn.zTree.getZTreeObj(treeId);
			var cmtObj = $.fn.zTree.getZTreeObj("colMapTree"); // 映射关系树ztree对象
			// 查找映射树上所有父节点;
			var pNodes = cmtObj.getNodesByParam("isParent",true,null); // 映射关系树的所有父节点(表字段节点)
			if (pNodes.length > 0) {
				// 若存在父节点则循环遍历
				$.each(pNodes, function(idx, item){
					// 查找数据库表树上对应字段节点
					node = tctObj.getNodeByParam("id", item.id, null);
					if (node != null) {
						// 若有一一对应的数据库表字段节点则将该节点图标换位已映射图标
						node.iconSkin = "mapped";
						tctObj.updateNode(node);
						item.desc = node.desc;
					}
					// 将父节点颜色显示为蓝色
					item.font = {"color" : "blue"};
					cmtObj.updateNode(item);
				});
			}
		}
	}
	
	// check"空映射"事件
	function checkNullMap() {
		var fctObj = $.fn.zTree.getZTreeObj("fileColTree");
		if (fctObj != null) {
			var nodes = fctObj.getCheckedNodes(true);
			if (nodes != null && nodes != "" && nodes.length > 0) {
				fctObj.checkNode(nodes[0],false,false);
			}
		}
	}
	
	// 自动映射
	function autoMap() {
		// 获取表字段ztree树对象
		var tctObj = $.fn.zTree.getZTreeObj("tabColTree");
		// 获取文件列头ztree树对象
		var fctObj = $.fn.zTree.getZTreeObj("fileColTree");
		// 获取映射关系ztree树对象
		var cmtObj = $.fn.zTree.getZTreeObj("colMapTree");
		// 若两个对象中任何一个为空,则返回
		if (tctObj == null || fctObj == null) {
			$.messager.alert('<s:text name="common_msg_info"/>',"请先选择数据库表和上传模板文件",'info');
			return;
		}
		var allNodes = tctObj.getNodes();
		$.each(allNodes,function(idx,item){
			if (cmtObj.getNodeByParam("id",item.id,null) == null) {
				var fuzzyNodes = fctObj.getNodesByParam("fcName",item.name,null);
				if (fuzzyNodes != null && fuzzyNodes.length > 0) {
					// 定义一个新的字段节点作为被映射节点
					var pNode = {
						id : item.id,
						pId : null,
						name : item.name,
						desc : item.desc,
						isParent : true,
						font : {'color' : 'blue'}
					};
					pNodes = cmtObj.addNodes(null, pNode);
					mapNode = {
						id : fuzzyNodes[0].id + "@" + pNode.id, // 映射文件列id为"列标号@字段ID"
						pId : pNode.id, // 父节点为被映射的字段ID
						name : "映射对象：" + fuzzyNodes[0].name,
						desc : fuzzyNodes[0].desc, // 悬浮提示为文件列原提示
						fcName : fuzzyNodes[0].fcName, // 原文件列名称
						fileCol : fuzzyNodes[0].id, // 对应文件列标号
						nocheck : true
					}
					cmtObj.addNodes(pNodes[0], mapNode);
					cmtObj.selectNode(pNodes[0]);
					// 设置数据库表字段节点已映射样式
					item.iconSkin = "mapped";
					tctObj.updateNode(item);
				}
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
			<td class="split"></td>
			<!-- 导入方式 -->
			<td class="label"><s:text name="gdp_config_impType"/>:</td>
			<td class="input"><input id="impType" name="impType" style="width:160px;"/></td>
			<td class="split"></td>
			<!-- 列头所在行 -->
			<td class="label"><s:text name="gdp_config_headerLine"/>:</td>
			<td class="input" >
				<input id="headLine" name="headLine" style="width:113px;"/>
			</td>
		</tr>
	</table>
	</form>
</div>

<div class="config-container">
	<table class="tree-table" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<!-- 数据库表列 -->
			<td class="title"><s:text name="gdp_config_dbTableColumns"/></td>
			<td class="split"></td>
			<!-- 模板文件列 -->
			<td class="title"><s:text name="gdp_config_fileColumns"/></td>
			<td class="split"></td>
			<!-- 映射关系 -->
			<td class="title"><s:text name="gdp_config_mappingRelationship"/></td>
		</tr>
		<tr>
			<td>
				<div class="tree-box">
					<div style="width:100%;background-color:#EEE;height:23px;padding-top:5px;border-bottom:1px solid #A0A0A0;">
						<span id="tabTitle" style="margin-left:8px;"></span>
					</div>
					<div style="overflow:auto;height:420px;">
						<ul id="tabColTree" class="ztree"></ul>
					</div>
				</div>
			</td>
			<td class="split"></td>
			<td>
				<div class="tree-box">
					<div id="sheetMapDiv" style="width:100%;background-color:#EEE;height:23px;padding-top:5px;border-bottom:1px solid #A0A0A0;">
						<!-- 空映射 -->
						<input type="checkbox" id="isNullMap" name="isNullMap" onclick="checkNullMap()" style="vertical-align:middle;margin-left:23px"/>
						<label for="isNullMap" style="vertical-align:middle;cursor:pointer;margin-left:2px;" title="<s:text name='gdp_config_nullMappingDesc'/>"><s:text name="gdp_config_nullMapping"/></label>
					</div>
					<div style="overflow:auto;height:420px;">
						<ul id="fileColTree" class="ztree"></ul>
					</div>
				</div>
			</td>
			<td class="split">
				<a href="javascript:void(0)" onclick="addColMap()" class="gdp-btn-small" style="font-size:14px">-></a>
			</td>
			<td>
				<div class="tree-box">
					<div id="operPanel" style="width:100%;background-color:#EEE;height:23px;padding-top:5px;border-bottom:1px solid #A0A0A0;text-align:right;">
						<!-- 函数 -->
						<a href="javascript:void(0)" onclick="addTransFunc()" style="font-size:11px;color:blue;"><s:text name="gdp_config_function"/></a>&nbsp;|
						<!-- 全选 -->
						<a href="javascript:void(0)" onclick="colMapTreeCheckAll()" style="font-size:11px;color:blue;"><s:text name="gdp_config_checkAll"/></a>&nbsp;|
						<!-- 删除 -->
						<a href="javascript:void(0)" onclick="delColMap()" style="font-size:11px;color:blue;"><s:text name="gdp_config_delete"/></a>&nbsp;|
						<!-- 自动 -->
						<a href="javascript:void(0)" onclick="autoMap()" style="margin-right:5px;font-size:11px;color:blue;"><s:text name="gdp_config_auto"/></a>
					</div>
					<div style="overflow:auto;height:420px;">
						<ul id="colMapTree" class="ztree"></ul>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="5" align="center" style="padding:25px 0 10px 0;">
				<!-- 保存 -->
				<a href="javascript:void(0)" onclick="saveConfig()" class="gdp-btn-big">
					<s:text name="gdp_common_save"/></a>
			</td>
		</tr>
	</table>
</div>

<div id="previewDiv" class="config-container" style="border:none;">
	<!-- 文件预览(只显示前2行) -->
	<div class="file-preview"><s:text name="gdp_config_filePreview"/>：</div>
	<div style="width:1150px;height:105px;overflow:auto;">
		<table id="preview" class="file-table" cellpadding="0" cellspacing="0" align="center">
		</table>
	</div>
</div>

<div id="inputWin"></div>

</body>
</html>

