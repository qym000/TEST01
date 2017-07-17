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
.wenzi1 span{ font-size:20px; color:#858585; margin-left:46px;}
.wenzi2{padding-top:16px;}
.wenzi2 span{ font-size:20px; color:#858585; margin-left:46px;}
.wenzi3 span{ font-size:20px; color:#858585; margin-left:46px;}
.wenzi3 a{ font-size:20px; color:#527afb;}
</style>
<title>无标题文档</title>
<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script> 
<script type="text/javascript">
		$().ready(function(){
	    	var i18n=getCookie("com.mingyoutech.cookie.i18n");
	    	if(i18n!=null && i18n=="en"){
	    		document.title='${sysnameEg}';
	    	}else{
	    		document.title='${sysname}';
	    	}
	    	
	    	//绑定回车事件
            $("body").bind("keypress",function(event){
                 if (getKeyCode(event) == 13){
                	 reLogin();
	    		    event.preventDefault();
	    	     }
	        });
	    });
	
		//获得事件码
        function getKeyCode(evt) {
            if (typeof(evt)=='string') return evt.charCodeAt(0);
            return document.all? event.keyCode: (evt && evt.which)? evt.which: 0;
        }
		
	    function reLogin(){
	    	top.location.href = '${ctx}/index.jsp';
	   	}
    </script>
</head>

<body>
<div class="top">
 <div class="column">
   <!-- img src="images/tu1.png" -->
   <div class="footer"> 
      <div class="left_picture">
        <img src="${ctx}/mybi/common/themes/default/images/img-error.png">
      </div>
      <div class="right_picture">
        <div class="wenzi1">
          <span href="">系统提示:</span>
        </div>
        <div class="wenzi2">
          <span>您由于长时间未操作，用户已过期。</span>
        </div>
        <div class="wenzi3">
          <span>请：<a href="#" onclick="reLogin();"><s:text name="common_msg_clickrelogin"/></a></span>
        </div>
        </div>
      </div>
   </div>
 </div>
</div>
</body>
</html>
