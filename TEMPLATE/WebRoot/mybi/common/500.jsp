<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style>
body{ margin:0;}
a{ text-decoration:none;}
img{ border:none; display:block;}
.top{ width:100%; background-color:#ffffff; overflow:hidden;}
.column{ width:1024px;margin:auto;} 
.footer{ width:600px;padding-top:74px; margin:auto;}
.left_picture{ float:left;}
.right_picture{ float:left;}
.wenzi1 a{ font-size:20px; color:#858585; margin-left:46px;}
.wenzi2 a{ font-size:20px; color:#858585; margin-left:66px;}
.line{margin:16px 0 16px 0; margin-left:46px;}
.error-back{margin-left:46px;}
.error-back a{ float:left;font-size:14px; color:#8ad41a;}
.tupian{ float:left; margin-right:6px;}
.error-refresh{margin-left:230px;}
.error-refresh a{ float:left;font-size:14px; color:#036bbd;}
.picture{ float:left; margin-right:6px;}
</style>
<meta charset="utf-8">
<title>无标题文档</title>
</head>
<script type="text/javascript">
	 function reLogin(){
	    	top.location.href = 'index.jsp';
	   	}
	 function reload(){
		 location.reload();
	 }
</script>
<body>
<div class="top">
 <div class="column">
   <div class="footer"> 
      <div class="left_picture">
        <img src="${ctx}/mybi/common/themes/default/images/img-error.png">
      </div>
      <div class="right_picture">
        <div class="wenzi1">
          <a href="">系统提示:</a>
        </div>
        <div class="wenzi2">
          <a href="">当前系统故障，无法显示此网页。</a>
        </div>
        <div class="line">
          <img src="${ctx}/mybi/common/themes/default/images/line.png">
        </div>
        <div class="error-back">
          <img class="tupian" src="${ctx}/mybi/common/themes/default/images/back_error.png">
          <a href="javascript:void(0);" onclick="reLogin();">返回首页</a>
        </div>
        <div class="error-refresh">
          <img class="picture" src="${ctx}/mybi/common/themes/default/images/refresh_error.png">
          <a href="javascript:void(0);" onclick="reload();">刷新此页面</a>
        </div>
      </div>
   </div>
 </div>
</div>
</body>
</html>
