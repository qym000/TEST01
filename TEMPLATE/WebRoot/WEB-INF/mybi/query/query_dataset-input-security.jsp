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
	<link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<script type="text/javascript">

	//window传来的参数
	var v_winParam;
	function sbt(){
		var rst_auth_rescode = '';
		var rst_auth_stData = '';
		if($("#auth_rescode").length != 0) {
		  rst_auth_rescode = $("#auth_rescode").combo('getValue');
		}
		 
		if($("#auth_stData").length != 0) {
		  rst_auth_stData = $("#auth_stData").combo('getValue');
		}
		  
		var par_obj = parent.$('#databody').find('#' + v_winParam.edit_tr).find('.auth a');
		$(par_obj).html('修改');
		$(par_obj).attr('auth_rescode', rst_auth_rescode);
		$(par_obj).attr('auth_stData', rst_auth_stData);
		clsWin();
	}
	
	$(function(){
		var v_opts = parent.$('#datasetAuthManageWin').window('options');
		v_winParam  = v_opts.param;
		
		if (v_winParam.auth_rescode) {
			checkAuth('res');
		}

		if (v_winParam.auth_stData) {
			checkAuth('st');
		}
		
		$('#ch_auth_rescode').change(function(){ 
			if ($(this).prop('checked')) {
				checkAuth('res');
			} else {
				$('.li_auth_rescode').empty();
			}
		});
		
        $('#ch_auth_stData').change(function(){ 
        	if ($(this).prop('checked')) {
				checkAuth('st');
			} else {
				$('.li_auth_stData').empty();
			}
		});
		
	})
	
	function checkAuth(p_type) {
		if (p_type == 'res') {
			$('.li_auth_rescode').html('<input id="auth_rescode"  name="auth_rescode" style="width: 250px" class="myui-text"/>');
			$('#ch_auth_rescode').attr('checked', true);
			$("#auth_rescode").combo({
			    mode : "local",
			    data : [{text:"机构资源",value:"RES_ORG"}],
			    panelHeight : 90,
			    searchable : true,
			    defaultValue :　v_winParam.auth_rescode
			});
		}else if(p_type == 'st') {
			$('.li_auth_stData').html('<input id="auth_stData"  name="auth_stData" style="width: 250px" class="myui-text"/>');
			$('#ch_auth_stData').attr('checked', true);
			$("#auth_stData").combo({
			    url : '${ctx}/query_dataset!getSensitiveInfo.action',
			    panelHeight : 90,
			    valueField : 'id',
			    textField : 'name',
			    defaultValue :　v_winParam.auth_stData
			});
		}
	}
	
	
		//关闭当前窗口
    function clsWin(){
    	parent.$('#datasetAuthManageWin').window('close');
    }
	
</script>
<style>
.item ul li{height: 25px;}
</style>
</head>
<body>
	<div id="addFolderWin"></div>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc"><input type="checkbox" id="ch_auth_rescode" name="ch_auth_rescode"/>&nbsp;资源权限</li>
					<li style="padding-left: 10px" class="li_auth_rescode"></li>
				</ul>
			</div>
			 <div class="item">
				<ul>
					<li class="desc"><input type="checkbox" id="ch_auth_stData" name="ch_auth_stData"/>&nbsp;敏感数据</li>
					<li style="padding-left: 10px" class="li_auth_stData"></li>
				</ul>
			</div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>

