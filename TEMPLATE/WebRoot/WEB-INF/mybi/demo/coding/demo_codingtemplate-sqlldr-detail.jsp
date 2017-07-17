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
	            "sqlldrDetail.skip" : $.trim($("#skip").val()) ,
	            "sqlldrDetail.errors" : $.trim($("#errors").val()) ,
	            "sqlldrDetail.rows" : $.trim($("#rows").val()),
	            "sqlldrDetail.bindsize" : $.trim($("#bindsize").val()),
	            "sqlldrDetail.readsize" : $.trim($("#readsize").val()),
	            "sqlldrDetail.direct" : $.trim($("#direct").combo("getValue")),
	            "sqlldrDetail.is_trim_function" : $.trim($("#is_trim_function").combo("getValue")),
	            "sqlldrDetail.fields_treminated" : $.trim($("#fields_treminated").val()),
	            "sqlldrDetail.load_mode" : $.trim($("#load_mode").combo("getValue")),
	            "sqlldrDetail.data_file" : $.trim($("#data_file").val()),
	            "sqlldrDetail.is_col_comments" : $.trim($("#is_col_comments").combo("getValue"))
	        };
	        add_onload();//开启蒙板层
	        $.post("demo_coding-sqlldr!saveDetail.action",param,function(data){
	          if(data.result=="succ"){
	        	  $.messager.alert('高级设置','设置成功。','info');
	          }else if(data.result=="fail"){
	            $.messager.alert('高级设置','无效的参数设置！','warning');
	          }
	         clean_onload();//关闭蒙板层
	          },"json");
	      }
	    });
	  
	  $("#skip").formValidator({onFocus:""}).inputValidator({min:1, onError:"请输入内容或“恢复默认”。"}).functionValidator({fun:intege1Valid});
  });
  
// 从session中获取表单的值
function getValueFromSession() {
	 // 回显当前设置
    $("#skip").val("${session.Demo_sqlldrObj.skip}");
    $("#errors").val("${session.Demo_sqlldrObj.errors}");
    $("#rows").val("${session.Demo_sqlldrObj.rows}");
    $("#bindsize").val("${session.Demo_sqlldrObj.bindsize}");
    $("#readsize").val("${session.Demo_sqlldrObj.readsize}");
    $("#direct").combo({
          mode : "local",
          data : [{text:"是",value:"true"},{text:"否",value:"false"}],
          defaultValue:"${session.Demo_sqlldrObj.direct}",
          panelHeight:44
      });
    $("#is_trim_function").combo({
          mode : "local",
          data : [{text:"是",value:"true"},{text:"否",value:"false"}],
          defaultValue:"${session.Demo_sqlldrObj.is_trim_function}",
          panelHeight:44
      });
    $("#fields_treminated").val("${session.Demo_sqlldrObj.fields_treminated}");
    $("#load_mode").combo({
          mode : "local",
          data : [{text:"APPEND",value:"APPEND"},{text:"INSERT",value:"INSERT"},{text:"REPLACE",value:"REPLACE"},{text:"TRUNCATE",value:"TRUNCATE"}],
          defaultValue:"${session.Demo_sqlldrObj.load_mode}",
          panelHeight:88
      });
    $("#data_file").val("${session.Demo_sqlldrObj.data_file}");
    $("#is_col_comments").combo({
          mode : "local",
          data : [{text:"是",value:"true"},{text:"否",value:"false"}],
          defaultValue:"${session.Demo_sqlldrObj.is_col_comments}",
          panelHeight:44
      });
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
	
	$.post("demo_coding-sqlldr!toDefault.action",function(data){
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
          <li><input id="skip" name="skip" maxlength="10" class="myui-text"/></li>
          <li class="tipli"><div id="skipTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">ERRORS：</li>
          <li><input id="errors" name="errors" maxlength="10"" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">ROWS：</li>
          <li><input id="rows" name="rows" maxlength="10" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">BINDSIZE：</li>
          <li><input id="bindsize" name="bindsize" maxlength="20" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">READSIZE：</li>
          <li><input id="readsize" name="readsize" maxlength="20" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">DIRECT：</li>
          <li><input id="direct" name="direct" maxlength="10" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">trim()函数：</li>
          <li><input id="is_trim_function" name="is_trim_function" maxlength="10" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">字段分隔符：</li>
          <li><input id="fields_treminated" name="fields_treminated" maxlength="10" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">载入方式：</li>
          <li><input id="load_mode" name="load_mode" maxlength="10" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">数据文件：</li>
          <li><input id="data_file" name="data_file" maxlength="30" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
        </ul>
       </div>
       <div class="item">
        <ul>
          <li class="desc">添加注释：</li>
          <li><input id="is_col_comments" name="is_col_comments" maxlength="10" class="myui-text"/></li>
          <li class="tipli"><div id="orgidtTip"></div></li>
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

