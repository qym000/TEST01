<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	//窗口参数
	var v_winParam;
	
	$(function(){
		var v_opts = parent.$('#editColFormatWin').window('options');
		v_winParam  = v_opts.param;
	})
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#editColFormatWin').window('close');
    }
</script>
<style type="text/css">
.form{width:580px;border:0px}
.myui-layout{padding-left:10px;border:0px;margin-top: 10px}
.myui-layout .collist{margin-top: 5px}
.myui-layout .collist li{padding-top: 5px;padding-left: 5px;cursor: pointer;}
.myui-layout .collist li label{cursor: pointer;}
.myui-layout .collist li:hover{background-color: #E0ECFF;border-color: #E0ECFF;}
.myui-layout .collist li.select{background-color: #99CCFF;border-color: #99CCFF;}
.table1sel,.table2sel{width: 200px;height: 25px;margin-top: 5px}
.select
</style>
</head>
<body>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
			<div class="myui-layout">
				<div class="rowgroup">
					<div class="content" headline="<div class='table1'></div>" style="width: 280px;height: 260px">
						<ul class="collist table1list">
						</ul>
					</div>
					<div class="content" headline="<div class='table2'></div" style="width: 280px;height: 260px">
						<ul class="collist table2list">
						</ul>
					</div>
				</div>
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