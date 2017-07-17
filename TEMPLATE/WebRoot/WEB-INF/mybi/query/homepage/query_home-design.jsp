<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>在线查询设计</title>
<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript">
</script>
</head>
<body style="height:640px;margin-top:10px;">
<div style="display:inline-block;margin-top:15px;margin-bottom:15px;width:200px;font-size:18px;font-family:微软雅黑;margin-left:170px;font-weight:600;color:#464646"><span style="color:#55ACCD;padding-right:5px;">来数宝&trade;</span>在线查询设计</div>
<div class="myui-layout" style="width:1280px;margin:auto;">
	<iframe name="myframe" src="${ctx}/query_online!toManage.action?id=${request.id}" style="width:1250px;height:740px" frameborder="0" scrolling="no"></iframe>
</div>
</body>
</html>

