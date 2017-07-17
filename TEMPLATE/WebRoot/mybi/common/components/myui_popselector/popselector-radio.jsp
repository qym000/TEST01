<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<style type="text/css">
#contentTable tr td {padding-left:10px;white-space:nowrap;padding-top:2px;padding-bottom:2px;}
#contentTable tr td input {vertical-align:middle;}
#contentTable tr td label {cursor:pointer;margin-left:5px;}
</style>
<script type="text/javascript">
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
	$("#contentDiv").css("width",(opts.winWidth - 22) + "px")
                	.css("height",(opts.winHeight - 84) + "px")
                	.css("border", "1px solid #EFEFEF")
                	.css("margin-left", "10px")
                	.css("margin-top", "5px");
	var cnt = opts.oneLineCount;
	var data = opts.data;
	if (data == null || data == undefined || data.length == 0) {
		return;
	}
	var htm = "";
	for (var i = 0; i < data.length; i++) {
		if (i % cnt == 0) {
			htm += "<tr>";
		}
		htm += "<td><input type='radio' id='" + tId + "_" + i + "' name='" + tId + "' value='" + data[i][opts.valueField] + "'/>" 
			+ "<label for='" + tId + "_" + i + "'>" + data[i][opts.textField] + "</label></td>";
		if ((i + 1) % cnt == 0) {
			htm += "</tr>";
		}
	}
	$("#contentTable").html(htm);
	setDefaultValue();
}

// 设置已选
function setDefaultValue() {
	//var val = $(target).attr("realValue");
	var val = opts.realValue;
	if (val != null && val != undefined) {
		$("#contentTable input[type='radio'][value='"+val+"']").attr("checked","checked");
	}
}

// 提交
function sbt() {
	var currentValue = $("#contentTable input[type='radio']:checked").val();
	var currentText =  $("#contentTable input[type='radio']:checked").next().text();
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
    <div id="contentDiv" style="overflow:auto;">
      <table id="contentTable">
      </table>
    </div>
  </div>
  <div class="operate">
    <a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
    <a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
  </div>
</div>
</body>
</html>