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
		chkStyle : "radio",
		enable : true,
		radioType : "all"
	}
}
var openFlag = true;
var opts = null;
var target = null;
var tId = getURLParameter("tId");
var openOnParent = getURLParameter("openOnParent");
var frameName = getURLParameter("frameName");
$(function() {
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
	//var val = $(target).attr("realValue");
	var val = opts.realValue;
	if (val != null && val != undefined) {
		var treeObj = $.fn.zTree.getZTreeObj("tree");
		var node = treeObj.getNodeByParam("id", val, null);
		if (node != null) {
			treeObj.checkNode(node, true, false);
			var parentNode = node.getParentNode();
			if (parentNode != null) {
				treeObj.expandNode(parentNode, true, false, true);
			}
		}
	}
}

// 提交
function sbt() {
	var treeObj = $.fn.zTree.getZTreeObj("tree");
	var checkedNodes = treeObj.getCheckedNodes(true);
	var currentValue = null;
	var currentText = null;
	if (checkedNodes != null && checkedNodes.length > 0){
		currentValue = checkedNodes[0].id;
		currentText = checkedNodes[0].name;
	}
	opts.realValue = currentValue;
	opts.showText = currentText;
	//$(target).attr("realValue", currentValue);
	//$(target).attr("showText", currentText);
	if (opts.inputValue) {
		$(target).val(currentValue);
	}else {
		$(target).val(currentText);
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