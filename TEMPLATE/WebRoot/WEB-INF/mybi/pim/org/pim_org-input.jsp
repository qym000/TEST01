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
	  $("#orglvl").combo({
          mode:'local',
          valueField:'ORGLVL',
          textField:'ORGLVLNAM',
          data:${request.orglvllist},
          panelHeight:100
      });
	  
	  
    $.formValidator.initConfig({formID:"form_input",
      onError:function(){
        return false;
      },
      
      onSuccess:function(){
        add_onload();//开启蒙板层
        var up_orgidt = $.trim($("#up_orgidt").val());
        var orgidt = $.trim($("#orgidt").val());
        var orgnam = $.trim($("#orgnam").val());
        var orglvl = $("#orglvl").combo("getValue");
        var form_param = {
        		"orgInfoObj.up_orgidt" : up_orgidt,
        		"orgInfoObj.orgidt" : orgidt,
        		"orgInfoObj.orgnam" : orgnam,
        		"orgInfoObj.orglvl" : orglvl
        };
        $.post("pim_org-info!saveOrgidt.action",form_param,function(data){ 
          if(data.result=="succ"){
            //刷新机构树
            parent.loadZTree($("#orgidt").val());
            parent.$('#inputWin').window("close");
          }else if(data.result=="fail"){
            $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info');
          }
          clean_onload();//关闭蒙板层
          },"json");
      }
    });
    
    $("#orgidt").formValidator({onFocus:""}).inputValidator({min:1,onError:"<s:text name='org_validate_required_field'/>"}).functionValidator({fun:isHasSpecialChar})
    .ajaxValidator({
      dataType : "text",
      url : "pim_org-info!checkOrgRepeat.action",
      type : "POST",
      data: {orgidt:$("#orgidt").val()},
      success : function(data){
        if (data == "false") {
                    return "<s:text name='org_validate_org_exist'/>";  
                } else {  
                    return true;  
                }  
      },
      onError : "<s:text name='org_validate_org_exist'/>",
      onWait : "<s:text name='org_validate_checking'/>"
    });
    
    $("#orgnam").formValidator({onFocus:""}).inputValidator({min:1,onError:"<s:text name='org_validate_required_field'/>"});
  });
  
  //正则验证是否含有空格
  function isHasSpecialChar(v){
    var reg=/^[^ 　]+$/;
      if(v!=null && v!="" && !reg.test(v)){
        return "<s:text name='org_validate_cant_contains_backspace'/>"; 
      }
      return true;
  }
  
  /**
   * 表单提交
   */
  function sbt(){
    $("#form_input").submit();
  }
  
  /**
   * 关闭当前窗口
   */
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
              <li class="desc"><b>*</b><s:text name="org_info_uporg"/>：</li>
              <li><input id="up_orgidt" name="orgInfoObj.up_orgidt" maxlength="10" readonly="readonly" value="${up_orgidt}" class="myui-text"/></li>
            </ul>
           </div>
           <div class="item">
            <ul>
              <li class="desc"><b>*</b><s:text name="org_info_orgidt"/>：</li>
              <li><input id="orgidt" name="orgInfoObj.orgidt" maxlength="10" class="myui-text"/></li>
              <li class="tipli"><div id="orgidtTip"></div></li>
            </ul>
           </div>
           <div class="item">
            <ul>
              <li class="desc"><b>*</b><s:text name="org_info_orgnam"/>：</li>
              <li><input id="orgnam" name="orgInfoObj.orgnam" maxlength="20" class="myui-text"/></li>
              <li class="tipli"><div id="orgnamTip"></div></li>
            </ul>
           </div>
           <div class="item">
           	<ul>
                <!-- <li class="desc">机构层级：</li> -->
                <li class="desc"><b>*</b><s:text name="org_column_orglvl"/>：</li>
                <li><input id="orglvl" maxlength="4" class="myui-text"/></li>
                <li class="tipli"><div id="orglvlTip"></div></li>
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