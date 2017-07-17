<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	$(function(){
		$("#orgnam").multinput2();
		$.validator.init({position:"right"}).addValidType("remote", "远程验证错误", function(value){
			var flag;
			$.ajax({  
                url : "${ctx}/demo_crud!checkName.action",
                type : 'POST',                    
                timeout : 60000,  
                data: {"testObj.name" : $("#name").val()},  
                async: false,    
                success : function(data, textStatus, jqXHR) {     
                    if (data == "1") {  
                        flag = true;      
                    }else{  
                        flag = false;  
                    }  
                }  
            });
			return flag;
		});
		$("#name").validator({
			required : true,
			validType : ['remote']
		});
		$("#work").combo({
			comboType : "normal-multi",
			mode : "local",
			data : [{text:"网络工程师",value:"网络工程师"},
			        {text:"JAVA工程师",value:"JAVA工程师"},
			        {text:"数据库工程师",value:"数据库工程师"},
			        {text:"前端工程师",value:"前端工程师"}
					]
		});
		
		$("#form_input").form({
			url : "${ctx}/demo_crud!formSubmit.action",
			bindJavaObj : "testObj",
			success : function(data) {
				alert(data.result);
			}
		});
	});
	
	//表单提交
	function sbt(){
		$("#form_input").form("submit",{
			otherParam : {id : $("#work").combo("getValues").join(",")}
		});
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
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>姓名：</li>
					<li><input id="name" name="name" class="myui-text" /></li>
				</ul>
			 </div>
             <div class="item">
                <ul>
                    <li class="desc"><b>* </b>年龄：</li>
                    <li><input id="age" name="age" class="myui-text myui-validator" required="true" validType="['maxLength(5)']"/></li>
                </ul>
             </div>
             <div class="item">
              <ul>
                <li class="desc"><b>* </b>单位：</li>
                <li><input id="orgnam" name="orgnam" class="myui-validator" required="true" style="width:200px;"/></li>
              </ul>
             </div>
             <div class="item">
                <ul>
                    <li class="desc"><b>* </b>出生日期：</li>
                    <li><input id="birthday" name="birthday" class="myui-datebox myui-validator" required="true"/></li>
                </ul>
             </div>
             <div class="item">
                <ul>
                    <li class="desc"><b>* </b>工作：</li>
                    <li><input id="work" name="work" class="myui-text myui-validator" required="true"/></li>
                </ul>
             </div>
             <div class="item">
			 	<ul>
                  <li class="desc" style="width:120px;">性别：</li>
                  <li>
                    <input type="radio" name="gender" value="男"/>男
                    <input type="radio" name="gender" value="女"/>女
                  </li>
                </ul>
			 </div>
             <div class="item">
                <ul>
                  <li class="desc" style="width:120px;">爱好：</li>
                  <li>
                    <input type="checkbox" name="hobby" value="吃饭"/>吃饭
                    <input type="checkbox" name="hobby" value="睡觉"/>睡觉
                    <input type="checkbox" name="hobby" value="上网"/>上网
                    <input type="checkbox" name="hobby" value="玩"/>玩
                  </li>
                </ul>
              </div>
			 <div class="item">
				<ul>
					<li class="desc">描述：</li>
					<li><textarea id="desc" maxlength="80" class="myui-textarea" style="width:200px;"></textarea></li>
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

