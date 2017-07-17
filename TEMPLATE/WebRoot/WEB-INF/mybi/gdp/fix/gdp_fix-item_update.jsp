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
          "itemObj.itemCode" : "${itemObj.itemCode}",
          "itemObj.itemName" : $.trim($("#itemName").val()),
          "itemObj.itemAlias" : $.trim($("#itemAlias").val()),
        }
        //开启蒙板层
        add_onload();
        $.post("${ctx}/gdp_fix-item!updateItemObj.action",paramObj,function(data){ 
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
    $("#itemName").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
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
          <li class="desc"><b>* </b>项目编码：</li>
          <li><input id="itemCode" name="itemCode" value="${itemObj.itemCode }" maxlength="6" readonly="readonly" class="myui-text" style="width:160px;"/></li>
          <li class="tipli"><div id="itemCodeTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc"><b>* </b>项目名称：</li>
          <li><input id="itemName" name="itemName" value="${itemObj.itemName }" maxlength="200" class="myui-text" style="width:160px;"/></li>
          <li class="tipli"><div id="itemNameTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">项目别名：</li>
          <li><input id="itemAlias" name="itemAlias" value="${itemObj.itemAlias }" maxlength="200" class="myui-text" style="width:160px;"></li>
          <li class="tipli"><div id="itemAliasTip"></div></li>
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
