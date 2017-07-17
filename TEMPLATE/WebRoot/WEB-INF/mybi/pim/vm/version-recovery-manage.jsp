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
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<style type="text/css">
	.bak_version_item{
		width:494px;height:80px;border-bottom:1px gray dotted;padding-left:4px;padding-top:8px;cursor: pointer;
	}
	
	.bak_version_item_selected{
		background-color:#D0E5FC;
	}
	
	.bak_version_name{
		text-align: center;float:left;width:150px;
	}
	
	.bak_version_log{
		float:left;margin-left:30px;color:red;
	}
</style>
<script type="text/javascript">
	$(function(){
		var html = "";
		$.each($.parseJSON('${bakMap}'), function(key, value){
			html += '<div class="bak_version_item">';
			html += '<div class="bak_version_name">';
			html += '<img src="${ctx}/mybi/common/themes/default/images/folder.png" />';
			html += '<div>' + key + '</div>';
			html += '</div>';
			html += '<div class="bak_version_log">';
			html +=	value;
			html += '</div>';
			html += '</div>';
		});
		$(".form").html(html);
		
		$(".bak_version_item").click(function(){
			$(".bak_version_item").removeClass("bak_version_item_selected");
			$(this).addClass("bak_version_item_selected");
		});
		
	});
	
	//表单提交
	function sbt(){
		if($(".bak_version_item_selected").length){
			var bakpath = $(".bak_version_item_selected .bak_version_name div").html();
			$.messager.confirm("提示", "确认进行版本恢复吗?", function(){
				parent.recovery("${obj.id}", "${obj.code}", bakpath);
			});
		}else{
			$.messager.alert("提示", "未选中任何版本", "info");
		}
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
</script>
</head>
<body>
<div class="myui-form">
	<div class="form">
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()">版本恢复</a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">关闭</a>
	</div>
</div>
</body>
</html>