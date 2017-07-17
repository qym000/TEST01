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
	function clsWin(){
	  parent.$('#systemParamWin').window('close');
	}
	
	function sbt(){
	  var v_sysparam =  $("input[name='test']:checked").val();
	  if(v_sysparam) {
	    parent.$('#'+v_winParam.id).val(v_sysparam);
	  }
	  clsWin();
	}
	
	var v_winParam;
	$(function(){
	  var v_opts = parent.$('#systemParamWin').window('options');
	  v_winParam  = v_opts.param;
	  $("input[name='test']").each(function(){
		  if($(this).val() == v_winParam.val) {
			  $(this).attr('checked','checked');
		  }
	  })
	  
	  $("#contentTable td label").click(function(){
		$(this).parent().find('input').attr('checked','checked')
	  })
	})
</script>
<style type="text/css">
#contentTable tr td {padding-left:10px;white-space:nowrap;padding-top:2px;padding-bottom:2px;}
#contentTable tr td input {vertical-align:middle;}
#contentTable tr td label {cursor:pointer;margin-left:5px;}
</style>
</head>
<body>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<div id="contentDiv" style="overflow: auto;  margin-left: 10px; margin-top: 5px;">
      		<table id="contentTable">
      			<tbody>
      				<tr>
      					<td><input type="radio" name="test" value="$(SYSPARAM_DATACENDAT)"><label>数据日期</label></td>
      				</tr>
      				<tr>
      					<td><input type="radio" name="test" value="$(SYSPARAM_SYSCENDAT)"><label>系统日期</label></td>
      				</tr>
      				<tr>
      					<td><input type="radio" name="test" value="$(LOGINPARAM_USERID)"><label>登录人用户ID</label></td>
      				</tr>
      				<tr>
      					<td><input type="radio" name="test" value="$(LOGINPARAM_LOGID)"><label>登录人用户登录编号</label></td>
      				</tr>
      				<tr>
      					<td><input type="radio" name="test" value="$(LOGINPARAM_ORGIDT)"><label>登录人所属机构</label></td>
      				</tr>
      			</tbody>
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