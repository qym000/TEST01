<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title></title>
<link href="${ctx}/mybi/common/scripts/syntaxHighlighter/styles/shCoreEclipse.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shCore.js"></script>
<script type="text/javascript"  src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJScript.js"></script>
<script type="text/javascript"  src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushXml.js"></script>
<script type="text/javascript"  src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJava.js"></script>
<script type="text/javascript"  src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"  src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
$(function() {
    SyntaxHighlighter.all();
    
    $("#dbConnect").combo({
      url:'demo_coding-template!selConnectSelect.action',
      defaultValue:'',
      valueField:'connectId',
      textField:'connectDesc',
      panelHeight:80
    });
    
    parent.clean_onload();
    
});

// 生成代码模板
function getTemplate() {
  
  var connectId = $("#dbConnect").combo("getValue");
  var tableName = $("#tableName").val();
  
  if (connectId == "" || tableName == "") {
    $.messager.alert('代码助手','请输入数据库连接及目标表名。','warning');
  }
  
  // 获取代码模板
  // 请求数据
    $.ajax({
      url : "demo_coding-insert!getTemplate.action",
      type : "post",
      data : {
        connectId : connectId,
        tableName : tableName
      },
      dataType : "json",
      success : function(data) {
        $("#template").val(data.template);
      },
      error : function(){
        $("#template").val(data.message);
      }
    });
  
  
}

// 开打高级设置窗口
function openDetailWin() {
    $("#inputWin").window({
        open : true,
        headline:'高级设置',
        content:'<iframe id="myframe" src=demo_coding-insert!toInsertDetailInput.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
        panelWidth:600,
        panelHeight:250
      });

}

// 清空代码模板
function clearTemplate() {
  $("#template").val('');
}

// 将内容复制到剪切板
function copyTemplate() {
  
  var s = $("#template").val();
  
  if (s == "") {
    $.messager.alert('代码助手', '请创建代码模板！', 'warning');
  }
  
  if (window.clipboardData) {
    window.clipboardData.setData("Text", s);
  } else if (navigator.userAgent.indexOf("Opera") != -1) {
    window.location = s;
  } else if (window.netscape) {
     try {
        netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
     } catch (e) {
       $.messager.alert('代码助手', '被浏览器拒绝！\n请手动复制代码模板', 'warning');
     }
     var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance(Components.interfaces.nsIClipboard);
     if (!clip) {
       return;
     }
     var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance(Components.interfaces.nsITransferable);
     if (!trans) {
       return;
     }
     trans.addDataFlavor('text/unicode');
     var str = new Object();
     var len = new Object();
     var str = Components.classes["@mozilla.org/supports-string;1"].createInstance(Components.interfaces.nsISupportsString);
     var copytext = s;
     str.data = copytext;
     trans.setTransferData("text/unicode", str, copytext.length * 2);
     var clipid = Components.interfaces.nsIClipboard;
     if (!clip) {
        return false; 
     }
     clip.setData(trans, null, clipid.kGlobalClipboard);
  } else {
    $.messager.alert('代码助手', '当前浏览器不支持，请手动复制代码。', 'warning');
  }
}

</script>
</head>
<body style="height:1024px">
  <div class="myui-layout">
  <div class="linegroup">
    <div class="content" style="width:960px;height:212px;"  title="参数选择">
      <div class="myui-form">
        <!-- 表单内容 -->
        <div class="form" style="width:800px;height:110px;margin:0;padding-left:150px;padding-top:20px">
          <form id="form_input" method="post">
            <div class="item">
              <ul>
                <li class="desc"><b>*</b>数据库连接：</li>
                <li><input id="dbConnect" name="dbConnect" value="" class="myui-text"/></li>
                <li class="tipli"><div id="dbConnectTip"></div></li>
              </ul>
            </div>
            <div class="item">
              <ul>
                <li class="desc"><b>*</b>目标表：</li>
                <li><input id="tableName" name="tableName" value="${obj.tableName}" class="myui-text"/></li>
                <li class="tipli"><div id="tableNameTip"></div></li>
              </ul>
            </div>
          </form>
        </div>
        <div style="height:35px;text-align:right;border-top:1px solid #e5e5e5">
           <a class="myui-button-query-main-big" href="javascript:void(0)" onclick="getTemplate()" style="margin:11px 20px 0px 0px">生成模板</a>
           <a class="myui-button-query-big" href="javascript:void(0)" onclick="openDetailWin()" style="margin:11px 20px 0px 0px">高级设置</a>
        </div>
      </div>
       
    </div>
    <div class="content" style="width:960px;height:450px" title="代码模板" position="right">
      <div class="operate" style="border:1px solid red">
         <ul>
           <li><a href="#" onclick="copyTemplate()">复制代码</a></li>
           <li><a href="#" onclick="clearTemplate()">清空模板</a></li>
         </ul>
      </div>
      <ul>
        <li><textarea id="template" name="template" class="myui-textarea" style="width:936px;height:396px;margin:10px 0 0px 10px;">${obj.afterSql}</textarea></li>
      </ul>
    </div>
  </div>
</div>
<div id="inputWin"></div>
</body>
</html>