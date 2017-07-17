<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>${sysname}</title>
<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
<style type="text/css">
	body{ margin:0;}
	a{ text-decoration:none;}
	img{ border:none; display:block;}
	.top{ width:100%; background-color:#ffffff; overflow:hidden;}
	.column{ width:1024px;margin:auto;} 
	.footer{ width:600px;padding-top:74px; margin:auto;}
	.left_picture{ float:left;}
	.right_picture{ float:left;}
	.wenzi1 a{ font-size:70px; color:#858585; margin-left:46px;}
	.wenzi1 span{ font-size:70px; color:#ce0102;}
	.wenzi2 span{ font-size:20px; color:#000000; margin-left:46px;}
	.line{ margin:16px 0 16px 0; margin-left:46px;}
	.wenzi3 a{ font-size:14px; color:#8e8e8d; margin-left:46px;}
	.wenzi3 span{ font-size:14px; color:#91181a; margin-left:10px}
	.wenzi3{float:left;}
	.wenzi4{float:left;}
	.wenzi4 a{ font-size:14px; color:#8e8e8d;}
</style>
</head>
<body>
<div class="top">
 <div class="column">
   <!-- img src="images/tu1.png"-->
   <div class="footer"> 
      <div class="left_picture">
        <img src="${ctx}/mybi/common/themes/default/images/img-error.png">
      </div>
      <div class="right_picture">
        <div class="wenzi1">
          <a href="">Error</a>
        </div>
        <div class="wenzi2">
              <span> 没有权限...</span>
        </div>
        <div class="line">
          <img src="${ctx}/mybi/common/themes/default/images/line.png">
        </div>
        <div class="wenzi3">
          
        </div>
        <!-- div class="wenzi4">
          <a href="">秒之后页面会自动跳转...</a>
        </div -->
      </div>
   </div>
 </div>
</div>
</body>
</html>
