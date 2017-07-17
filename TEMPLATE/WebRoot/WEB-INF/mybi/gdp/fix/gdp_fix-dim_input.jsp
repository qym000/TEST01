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
    $("#dimtypId").combo({
    	mode : "local",
    	data : ${dimtypList},
    	isCustom : true,
    	valueField : "dimtypId",
    	textField : "dimtypName",
    	customData : [{dimtypId : "", dimtypName : "请选择"}]
    });
    // 表单验证初始化
    $.formValidator.initConfig({formID:"form_input",
      onError:function(){
        return false;
      },
      onSuccess:function(){
        // 参数对象
        var paramObj = {
          "dimObj.dimtypId" : $("#dimtypId").combo("getValue"),
          "dimObj.dimCode" : $.trim($("#dimCode").val()),
          "dimObj.dimInfo" : $.trim($("#dimInfo").val()),
          "dimObj.dimKeyword" : $.trim($("#dimKeyword").val())
        }
        //开启蒙板层
        add_onload();
        $.post("${ctx}/gdp_fix-dim!saveDimObj.action",paramObj,function(data){ 
          if(data.result=="succ"){
            //回显刚才操作的记录
            parent.findListById(data.callbackCondition);  
            $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',clsWin);
          }else if(data.result=="fail"){
            $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
          }
          },"json");
        //关闭蒙板层
        clean_onload();
      }
    });
    $("#dimCode").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
    $("#dimInfo").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
    $("#dimKeyword").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
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
          <li class="desc"><b>* </b>维度类型：</li>
          <li><input id="dimtypId" name="dimtypId" class="myui-text" style="width:160px;"/></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc"><b>* </b>维度编码：</li>
          <li><input id="dimCode" name="dimCode" maxlength="10" class="myui-text" style="width:160px;"/></li>
          <li class="tipli"><div id="dimCodeTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc"><b>* </b>维度名称：</li>
          <li><input id="dimInfo" name="dimInfo" maxlength="30" class="myui-text" style="width:160px;"></textarea></li>
          <li class="tipli"><div id="dimInfoTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc"><b>* </b>关键词：</li>
          <li><input id="dimKeyword" name="dimKeyword" class="myui-text" style="width:160px;"></textarea></li>
          <li class="tipli"><div id="dimKeywordTip"></div></li>
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
