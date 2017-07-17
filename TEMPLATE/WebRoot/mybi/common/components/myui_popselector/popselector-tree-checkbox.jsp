<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet"  href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/json2.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript"  src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<style type="text/css">
.popselector-btn-small {vertical-align:middle;color:#727272;margin-left:3px;border: 1px solid #dbdbdb;background-color:#FBFBFB;font-size:12px;padding:1px 8px;font-family:微软雅黑,黑体;cursor: pointer;}
.popselector-btn-small:HOVER{color:#fe710a;}
</style>
<script type="text/javascript">
var setting = {
	view : {
		showIcon : true
	},
	data : {
		simpleData : {
			enable : true
		}
	},
	check : {
		chkStyle : "checkbox",
		enable : true
	}
}
var ckAllFlag = true;
var opts = null;
var target = null;
var tId = getURLParameter("tId");
var openOnParent = getURLParameter("openOnParent");
var frameName = getURLParameter("frameName");
$(function() {
	$("body").unbind();
	if (openOnParent == "true") {
		target = parent.eval(frameName).$("#" + tId);
		opts = parent.eval(frameName).$("#" + tId).popselector("options");
	}else {
		target = parent.$("#" + tId)
		opts = parent.$("#" + tId).popselector("options");
	}
	render();
});

// 根据数据渲染内容
function render() {
	$("#operDiv").css("width", (opts.winWidth - 22) + "px")
            	 .css("height", "30px")
            	 .css("margin-left", "10px")
            	 .css("margin-top", "5px")
	$("#contentDiv").css("width",(opts.winWidth - 22) + "px")
                	.css("height",(opts.winHeight - 114) + "px")
                	.css("border", "1px solid #EFEFEF")
                	.css("margin-left", "10px");
	setting.view.showIcon = opts.treeShowIcon;
	var str = JSON.stringify(opts.data);
	var nodes = $.parseJSON(str);
	$.fn.zTree.init($("#tree"), setting, nodes);
	setDefaultValue();
	$("#search").inputbox({
		type : "action",
		icon : "icon-search",
		onEnterDo : function(val) {
			$.fn.zTree.init($("#tree"), setting, $.parseJSON(JSON.stringify(opts.data)));
			var treeObj = $.fn.zTree.getZTreeObj("tree");
			if ($.trim(val) != "") {
				var nodes = treeObj.getNodesByParamFuzzy("name", val, null);
				$.fn.zTree.init($("#tree"), setting, nodes);
			}
			treeObj.expandAll(true);
		}
	});
}

// 设置已选
function setDefaultValue() {
	var str = opts.realValue;
	if (str != null && str != undefined) {
		var vals = str.split(",");
		var treeObj = $.fn.zTree.getZTreeObj("tree");
		$.each(vals, function(idx,item){
			var node = treeObj.getNodeByParam("id", item, null);
			if (node != null) {
				treeObj.checkNode(node, true, false);
				var parentNode = node.getParentNode();
				if (parentNode != null) {
					treeObj.expandNode(parentNode, true, false, true);
				}
			}
		});
	}
}

//全选
function ckAll() {
	var treeObj = $.fn.zTree.getZTreeObj("tree");
	treeObj.expandAll(true);
	if (ckAllFlag) {
		treeObj.checkAllNodes(true);
		ckAllFlag = false;
	}else {
		treeObj.checkAllNodes(false);
		ckAllFlag = true;
	}
}

// 反选
function ckReverse() {
	var treeObj = $.fn.zTree.getZTreeObj("tree");
	treeObj.expandAll(true);
	var ckNodes = treeObj.getCheckedNodes(true);
	treeObj.checkAllNodes(true);
	$.each(ckNodes, function(idx,item){
		treeObj.checkNode(item, false, false);
	});
}

// 提交
function sbt() {
	var treeObj = $.fn.zTree.getZTreeObj("tree");
	var checkedNodes = treeObj.getCheckedNodes(true);
	var valStr = null;
	var txtStr = null;
	if (checkedNodes != null && checkedNodes != undefined && checkedNodes.length > 0) {
		valStr = "";
		txtStr = "";
		$.each(checkedNodes, function(idx,item){
			if (idx == checkedNodes.length - 1) {
				valStr += item.id;
				txtStr += item.name;
			}else {
				valStr += item.id + ",";
				txtStr += item.name + ",";
			}
		});
	}
	opts.realValue = valStr;
	opts.showText = txtStr;
	if (opts.inputValue) {
		$(target).val(valStr);
	}else {
		$(target).val(txtStr);
	}
	$(target).focus();
	clsWin();
}

// 获取URL参数
function getURLParameter(name) {
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) {
   		return decodeURI(r[2]);
    }
    return null;
}

// 关闭窗口
function clsWin() {
	parent.$("#popselectorWin .main ul li[class='close']").click();
}

</script>
</head>
<body>
<div class="myui-form">
  <div class="form">
    <div id="operDiv">
      <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
          <td>
            <a href="javascript:void(0)" onclick="ckAll()" class="popselector-btn-small" >全选</a>
            <a href="javascript:void(0)" onclick="ckReverse()" class="popselector-btn-small" >反选</a>
          </td>
          <td align="right"><span>搜索：</span><input id="search" style="width:120px;vertical-align:middle;" class="myui-text"/></td>
        </tr>
      </table>
    </div>
    <div id="contentDiv" style="overflow:auto;">
      <ul id="tree" class="ztree"></ul>
    </div>
  </div>
  <div class="operate">
    <a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
    <a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
  </div>
</div>
</body>
</html>