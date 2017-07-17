<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	var opts;
	var selectMaxExportCnt;
	$(function(){
		opts = parent.$('#dataExport').window('options');
		selectMaxExportCnt = opts.param.selectMaxExportCnt;
		if(!selectMaxExportCnt || selectMaxExportCnt == 0){
			selectMaxExportCnt = 50000;
		}
		$.trim($("#size").val(selectMaxExportCnt));
		hint();
	})
	function exportDataToExcel(){
		var page = $.trim($("#page").val());
	  	var size = $.trim($("#size").val());
	  	var startrow = size*(page-1)+1;
	  	var endrow = page*size;
	  	var reg = /^[1-9]*[1-9][0-9]*$/;
  		if(page==null||size==null||page==""||size==""){
 			$.messager.alert("提示","请将表单填写完整","info");
 			return false;
  		}else if(!page.match(reg)||!size.match(reg)){
 			$.messager.alert("提示","请输入有效的正整数","info");
 			return false;
  			//$("#page").focus();
  			//$("#page").select();
  		}else if(size > selectMaxExportCnt){
  			$.messager.alert("提示","导出条数不能超过" + selectMaxExportCnt,"info");
  			startrow = 0;
  			endrow = 0;
  			return;
  		}else{
  		//	parent.exportData(startrow,endrow);
  			
  			var param = $.extend({}, opts.param.param, {
  				page : page,
  				rows : size
  			});
  			
  			var queryParams = $.extend({}, opts.param.queryParams, {
  				page : page,
  				rows : size
  			});
  			
  			$.post(opts.param.url_action + "!setDatagridExportParam.action", param, function(data){
				
				//导出监控，方法写在baseAction中,所以调用了一个固定存在的action
				parent.monitorExportStatus(opts.param.url_action + '!monitorExportStatus.action');
				
				//跳转下载action
		   		window.location.href = encodeURI(opts.param.exportUrl + "?datagridExportParamKey="+opts.param.randomkey + json2UrlParam(queryParams));
			});
  			parent.$('#dataExport').window("close");
  		}
  	}
  	
  	function hint(){
  		var page = $.trim($("#page").val());
  		var size = $.trim($("#size").val());
  		var startrow = size*(page-1)+1;
  		var endrow = page*size;
  		var hint = "";
  		var reg = /^[1-9]*[1-9][0-9]*$/;
  		if(page==null||size==null||page==""||size==""){
  			hint = "请将表单填写完整";
  		}else if(!page.match(reg)||!size.match(reg)){
  			hint = "请输入有效的正整数";
  		}else if(size > selectMaxExportCnt){
  			hint = "导出条数不能超过" + selectMaxExportCnt;
  		}else{
  			hint = "你将导出第 "+page+" 页的 "+size+" （"+startrow+"~"+endrow+"） 条数据";
  		}
  		$("#hint").html(hint);
  	}

	/**
	 * 关闭当前窗口
	 */
    function clsWin(){
    	parent.$('#dataExport').window("close");
    }
</script>
<style>
.note{margin-top: 5px;}
.note .desc{font-size: 10px;}
.note .expdesc{margin-top: 5px;}
.note .expdesc span{font:12px;color:blue;font-family:微软雅黑;text-align:center;}
</style>
	</head>
	<body bgcolor="#FDFCFC" style="margin: 0px;padding: 0px;">
	<div class="myui-form">
			<div class="form">
				 <div class="item">
					<ul>
						<li class="desc"><b>*</b>导出页码：</li>
						<li><input type="text" name="page"  id="page" maxlength="8" value="1" title="请输入一个有效的正整数" onkeyup="hint();"/></li>
					</ul>
				 </div>
				 <div class="item">
					<ul>
						<li class="desc"><b>*</b>导出条数：</li>
						<li><input type="text" name="size" id="size" maxlength="6" value="50000" title="请输入一个有效的正整数" onkeyup="hint();"/></li>
					</ul>
				 </div>
				 <div class="note">
				 	<ul>
						<li class="desc">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							提示（^_^）：
						</li>
						<!-- li class="desc">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							1.&nbsp;Excel文件最大支持65535行数据。
						</li -->
						<li class="desc">
						<!-- -->	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;&nbsp; 导出的数据量过大时，不仅可能会造成内存溢出，而且等待的时间会比较长，
							<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							建议每次导出数据量不超过50000条。
						</li>
						<li class="expdesc" style="text-align:center;">
							<span id="hint" style="">你将导出第 1 页的 50000 （1~50000） 条数据</span>
						</li>
					</ul>
				 </div>
			</div>
			<div class="operate">
				<a class="main_button" href="javascript:void(0);" onclick="exportDataToExcel();">导出</a>
				<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
			</div>
		</div>
	</body>
</html>	
