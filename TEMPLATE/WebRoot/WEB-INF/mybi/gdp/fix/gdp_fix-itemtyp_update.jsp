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
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
  $(function(){
    // 初始化页面元素及表单验证
    initPage();
  });
  
  // 初始化页面元素
  function initPage() {
    // 表单验证初始化
    $.formValidator.initConfig({formID:"form_input",
      onError:function(){
        return false;
      },
      onSuccess:function(){
        // 参数对象
        var paramObj = {
          "itemtypObj.itemtypId" : "${itemtypObj.itemtypId}",
          "itemtypObj.itemtypCode" : $.trim($("#itemtypCode").val()),
          "itemtypObj.itemtypName" : $.trim($("#itemtypName").val())
        }
        //开启蒙板层
        add_onload();
        $.post("${ctx}/gdp_fix-itemtyp!updateItemtypObj.action",paramObj,function(data){ 
          if(data.result=="succ"){
            //回显刚才操作的记录
            parent.findListById(data.callbackCondition);  
            $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatesucc"/>','info',clsWin);
          }else if(data.result=="fail"){
            $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_updatefail"/>','info');
          }
          },"json");
        //关闭蒙板层
        clean_onload();
      }
    });
    $("#itemtypCode").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
    $("#itemtypName").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
  }
  
  // 表单提交
  function sbt(){
    $("#form_input").submit();
  }
  
  // 关闭当前窗口
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
          <li class="desc" style="width:130px;"><b>* </b>项目类型编码：</li>
          <li><input id="itemtypCode" name="itemtypCode" maxlength="10" value="${itemtypObj.itemtypCode }" class="myui-text" style="width:160px;"/></li>
          <li class="tipli"><div id="itemtypCodeTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc" style="width:130px;"><b>* </b>项目类型名称：</li>
          <li><input id="itemtypName" name="itemtypName" maxlength="30" value="${itemtypObj.itemtypName }" class="myui-text" style="width:160px;"></textarea></li>
          <li class="tipli"><div id="itemtypNameTip"></div></li>
        </ul>
       </div>
     </form>
  </div>
  <div class="operate">
    <!-- 提交 -->
    <a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
    <!-- 取消 -->
    <a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
  </div>
</div>

</body>
</html>
