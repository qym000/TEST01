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
.popselector-btn-small {vertical-align:middle;color:#727272;margin-left:3px;border: 1px solid #dbdbdb;background-color:#FBFBFB;font-size:12px;padding:1px 8px;font-family:微软雅黑,黑体;cursor: pointer;}
.popselector-btn-small:HOVER{color:#fe710a;}
</style>
<script type="text/javascript">
var ckAllFlag = true;
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
		htm += "<td><input type='checkbox' id='" + tId + "_" + i + "' name='" + tId + "' value='" + data[i][opts.valueField] + "'/>" 
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
	var str = opts.realValue;
	if (str != null && str != undefined) {
		var vals = str.split(",");
		$.each(vals, function(idx,item){
			$("#contentTable input[type='checkbox'][value='"+item+"']").attr("checked","checked");
		});
	}
}

// 提交
function sbt() {
	var cks = $("#contentTable input[type='checkbox']:checked");
	var valStr = null;
	var txtStr = null;
	if (cks != null && cks != undefined && cks.length > 0) {
		valStr = "";
		txtStr = "";
		$.each(cks, function(idx,item){
			if (idx == cks.length - 1) {
				valStr += $(item).val();
				txtStr += $(item).next().text();
			}else {
				valStr += $(item).val() + ",";
				txtStr += $(item).next().text() + ",";
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

// 全选
function ckAll() {
	if (ckAllFlag) {
		$("#contentTable input[type='checkbox']").attr("checked","checked");
		ckAllFlag = false;
	}else {
		$("#contentTable input[type='checkbox']").removeAttr("checked");
		ckAllFlag = true;
	}
}

// 反选
function ckReverse() {
	var temp = $("#contentTable input[type='checkbox']").not(":checked");
	$("#contentTable input[type='checkbox']:checked").removeAttr("checked");
	$(temp).attr("checked", "checked");
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
      <a href="javascript:void(0)" onclick="ckAll()" class="popselector-btn-small" >全选</a>
      <a href="javascript:void(0)" onclick="ckReverse()" class="popselector-btn-small" >反选</a>
    </div>
    <div id="contentDiv" style="overflow:auto">
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