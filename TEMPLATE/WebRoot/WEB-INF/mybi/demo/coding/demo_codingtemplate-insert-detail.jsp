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
	  
	  // 从session中获取值
	  getValueFromSession();
	  
	  $.formValidator.initConfig({formID:"form_input",
	      onError:function(){
	        return false;
	      },
	      onSuccess:function(){
	        var param={
	            "insertDetail.retract" : $.trim($("#retract").val()) ,
	            "insertDetail.is_append" : $.trim($("#is_append").val())
	        };
	        add_onload();//开启蒙板层
	        $.post("demo_coding-insert!saveDetail.action",param,function(data){
	          if(data.result=="succ"){
	        	  $.messager.alert('高级设置','设置成功。','info');
	          }else if(data.result=="fail"){
	            $.messager.alert('高级设置','无效的参数设置！','warning');
	          }
	         clean_onload();//关闭蒙板层
	          },"json");
	      }
	    });
	  
  });
  
// 从session中获取表单的值
function getValueFromSession() {
	 // 回显当前设置
    $("#retract").val("${session.Demo_insertObj.retract}");
    $("#is_append").val("${session.Demo_insertObj.is_append}");
}
  

// 正整数验证
function intege1Valid(v){
  var reg = /^(0|[1-9]\d*)$/;
  //var reg = /^[1-9][0-9]*$/;
  if(v != null && v != "" && !reg.test(v)){
    return "请输入有效正整数。"; 
  }
  return true;
}

// 恢复默认值
function toDefault() {
	
	add_onload();//开启蒙板层
	
	$.post("demo_coding-insert!toDefault.action",function(data){
        if(data.result=="succ"){
          $.messager.alert('高级设置','全部参数已恢复为默认值。','info',clsWin);
        }else if(data.result=="fail"){
          $.messager.alert('高级设置','无法恢复默认值。','warning');
        }
        clean_onload();//关闭蒙板层
        },"json");
	
}
  
//表单提交
function sbt(){
  $("#form_input").submit();
}
  
//关闭当前窗口
function clsWin(){
  parent.$('#inputWin').window('close');
}
</script>
</head>
<body>

<div class="myui-form">
  <div class="form" style="padding-left:50px">
    <form id="form_input" method="post">
       <div class="item">
        <ul>
          <li class="desc">SKIP：</li>
          <li><input id="retract" name="retract" maxlength="10" class="myui-text"/></li>
          <li class="tipli"><div id="retractTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">ERRORS：</li>
          <li><input id="is_append" name="is_append" maxlength="10"" class="myui-text"/></li>
          <li class="tipli"><div id="is_appendTip"></div></li>
        </ul>
       </div>
     </form>
  </div>
  <div class="operate">
    <a class="main_button" href="javascript:void(0);" onclick="sbt()">保存</a>
    <a class="button" href="javascript:void(0);" onclick="toDefault()">恢复默认</a>
    <a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">退出</a>
  </div>
</div>

</body>

</html>

