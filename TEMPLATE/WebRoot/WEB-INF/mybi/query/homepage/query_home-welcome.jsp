<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/query/themes/${apptheme}/buttons.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/query/themes/${apptheme}/query_welcome.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
$(function(){
	$(".quickbtn").hover(function(){
		$(this).css("background-color", "#FF8D19");
	},function(){
		$(this).css("background-color", "#D7D7D7");
	});
	$("#search").bind("keyup", function(e){
		if (e.keyCode == 13) {
			search();
		}
	});
});

function getKeywordShow() {
	var tmp = $.trim($("#search").val());
	if (tmp.length > 20) {
		tmp = tmp.substring(0,20) + "...";
	}
	return tmp; 
}

function search() {
	if ( $.trim($("#search").val()) != "") {
		parent.queryTitle = "全局检索“"+getKeywordShow()+ "”";
	}else {
		parent.queryTitle = "全局检索";
	}
	parent.keyword = $.trim($("#search").val());
	parent.parentId = null;
	window.location.href = "${ctx}/query_homepage!toSelect.action";
}

function dirSetting() {
	$("#dirSettingWin").window({
		open : true,
	    param : null,
	    headline:'目录设置',
	    content:'<iframe id="dirSettingFrame" src="${ctx}/query_homepage!toDirSetting.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
	    panelWidth:460,
	    panelHeight:380
	});
}

function queryDesign() {
	var a = document.getElementById("designLink");
	a.href = "${ctx}/query_homepage!toQueryDesign.action";
	a.setAttribute("onclick","");
	a.click("return false");
}
</script>
</head>
<body style="height:655px;">
<div class="myui-layout">
  <div class="content main_bg" style="width:915px;height:660px;" title="欢迎使用">
    <div style="margin-top:15px;width:150px;font-size:18px;font-family:微软雅黑;margin-left:750px;font-weight:600;color:#464646"><span style="color:#55ACCD;padding-right:5px;">来数宝&trade;</span>在线查询</div>
    <div style="margin-top:50px;margin-left:320px;">
      <input id="search" class="searchbox myui-tooltip" content="全局检索" css="width:50px" style="vertical-align:middle;"/>
      <button class="button button-box" onclick="search();" style="height:33px;vertical-align:middle;border:1px solid #D2D2D2;"><i class="fa fa-search"></i></button>
    </div>
    <span class="quickbtn" title="通过来数宝&trade;在线查询设计器创建您的数据查询页面，&#13;支持多数据源如数据库表、视图、指标或自定义SQL" onclick="queryDesign();" style="margin-left:310px;">
      <span style="margin-left:50px;"><i class='fa fa-edit'></i></span>
      <div>新建设计</div>
    </span>
    <span class="quickbtn" title="对您的查询目录进行添加、编辑或删除" onclick="dirSetting();" style="margin-left:20px;">
      <span style="margin-left:50px;"><i class='fa fa-folder-o'></i></span>
      <div>目录设置</div>
    </span>
    <!-- 
    <span class="quickbtn" style="margin-left:20px;">
      <span style="margin-left:50px;"><i class='fa fa-envelope-o'></i></span>
      <div>我的提醒</div>
    </span>
     -->
  </div>
</div>
</div>
<div id="dirSettingWin"></div>
<a id="designLink" target="_blank" style="display:none;"></a>
</body>
</html>