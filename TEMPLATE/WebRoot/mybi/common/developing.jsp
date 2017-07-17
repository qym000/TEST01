<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<head>
	<title>${sysname}</title>
	<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
	<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script> 
    <script type="text/javascript">
	    $().ready(function(){
	    	var i18n=getCookie("com.mingyoutech.cookie.i18n");
	    	if(i18n==null || i18n=="en"){
	    		document.title='${sysnameEg}';
	    	}else{
	    		document.title='${sysname}';
	    	}
	    });
    </script>
	</head>
	<body bgcolor="#FDFCFC" style="width: 90%">
		<table  height="30%" align="center">
			<tr>
			    <td>&nbsp;</td>
			</tr>
		</table>
		<table  align="center" style="">
			<tr>
			  	<td width="20%">&nbsp;</td>
			    <td width="307" height="147">
				    <table  style="width: 100%;height: 100%">
				    	<tr><td><img border="0" src="${ctx}/mybi/common/images/err/error.png"></td>
				    		<td align="center"><s:text name="common_msg_deving"/></td>
				    	</tr>
				    </table>
			    </td>
			</tr>
		</table>
		<table height="30%">
			<td></td>
		</table>
	</body>
</html>
  