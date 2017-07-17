<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript">
  // 主初始化函数
  $(function(){
    // 动作权限过滤
    actionAuthFilter();
    // 添加导航
    loadLocationLeading("${authMenuId}","${session.i18nDefault}");
    // 页面元素初始化
    initPage();
    // 进入页面默认查询
    cx(1);
  })
  
  // 页面元素初始化
  function initPage() {
    // 回车事件
    $("#itemCode").bind("keydown",function(e){
      if (e.keyCode == 13) {
        cx(1);
      }
    });
    myui_datagrid_renderOrder(cx);
  }
  
  // 请求分页查询
  function cx(page) {
    // 查询参数;
    var paramObj = {
      "itemObj.itemCode" : $("#itemCode").val(),
      page : page,
      sort : $("input[name='sort']").val(),
      order : $("input[name='order']").val()
    };
    // 开启蒙板层
    tmp_component_before_load("datagrid");
    $.post("${ctx}/gdp_fix-item!findItemPager.action",paramObj,function(data){
      $(".myui-datagrid-pagination").html(data.datapage);
      var htm = "";
      if (data.datalist != null && data.datalist.length > 0) {
        $.each(data.datalist, function(idx,item){
          htm += "<tr>";
            htm += "<td><input type='checkbox' name='checkboxitem' value='"+item.itemCode+"'></td>";
            htm += "<td align='center'>"+ item.itemCode +"</td>";
            htm += "<td>"+ item.itemName +"</td>";
            htm += "<td>"+ item.itemAlias +"</td>";
            htm += "</tr>";
        });
      }else {
        // 没有数据
        htm += "<tr><td colspan='5'><s:text name='common_msg_nodata'/></td></tr>"
      }
      $("#databody").html(htm);
      //关闭蒙板层
      tmp_component_after_load("datagrid");
    },"json");
  }
  
  // 根据ID查询函数列表,用于添加修改回显
  function findListById(id) {
    $.post("${ctx}/gdp_fix-item!findItemByCode.action",{"itemObj.itemCode" : id},function(data){ 
        $(".myui-datagrid-pagination").html('');
        var htm = "";
        htm += "<tr>";
      htm += "<td><input type='checkbox' name='checkboxitem' value='" + data.itemCode + "'></td>";
      htm += "<td align='center'>"+ data.itemCode +"</td>";
      htm += "<td>"+ data.itemName +"</td>";
      htm += "<td>"+ data.itemAlias +"</td>";
      htm += "</tr>";
      $("#databody").html(htm);
    },"json");  
  }
  
  // 添加一个函数
  function add() {
    $("#inputWin").window({
      open : true,
      headline:"<s:text name='common_action_add'/>",
      content:'<iframe src=gdp_fix-item!toItemInput.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
      panelWidth:500,
      panelHeight:350
    });
  }
  
  // 修改一个函数
  function upt() {
    var objsChecked = $("input[name='checkboxitem']:checked");
      if (objsChecked.length <= 0) {
        // 勾选记录数小于1时提示必须勾选一条记录
        $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');
        return;
      }else if (objsChecked.length > 1) {
        // 勾选记录数大于1时提示只能勾选一条记录
        $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_singleselect"/>','info');
        return;
      }
      var id = $(objsChecked[0]).val();
      // 打开修改窗口
      $("#inputWin").window({
      open : true,
      headline:"<s:text name='common_action_update'/>",
      content:'<iframe src=gdp_fix-item!toItemUpdate.action?id='+ id +' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
      panelWidth:500,
      panelHeight:350
    });
  }
  
  // 批量删除函数对象
  function del() {
    var objsChecked = $("input[name='checkboxitem']:checked");
      if (objsChecked.length <= 0) {
        // 勾选记录数小于1时提示必须勾选一条记录
        $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');
        return;
      }
      // 获取所有勾选项的ID
      var idArr = [];
      $.each(objsChecked,function(idx,item){
        idArr.push($(item).val());
      });
      add_onload();
      $.post("${ctx}/gdp_fix-item!deleteItemObj.action",{id : idArr.join(",")},function(data){
        clean_onload();
        if(data.result=="succ"){
          // 操作成功
            $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info',function(){
              cx(1);  
            });
        }else if(data.result=="fail"){
          // 操作失败
          $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>',"info"); //操作失败
        }
      },"json");
  }
  
  /*导入项目码*/
  function importItems() {
	  $("#inputWin").window({
	  	open : true,
		headline:"导入项目",
		content:'<iframe src=gdp_fix-item!toImportItems.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
		panelWidth:500,
		panelHeight:270  
	  });
  }
  
  /*回填文件*/
  function writeToFile() {
	  $("#inputWin").window({
		open : true,
	  	headline:"回填文件",
		content:'<iframe src=gdp_fix-item!toWriteToFile.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
		panelWidth:500,
		panelHeight:270   
	  });
  }
</script>

</head>
<body style="height:640px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
    <ul>
        <li class="desc" style="width:120px">项目编码/名称：</li>
        <li>
            <input type="text" id="itemCode" name="itemCode" class="myui-text" style="width:160px" title='<s:text name="common_msg_fuzzy_query"/>'/>
        </li>
    </ul>
</div>

<div class="myui-template-operating">
  <div class="baseop">
    <ul>
      <!-- 查询 -->
      <li><a href="javascript:void(0)" onclick="cx(1)" actionCode="ACTION_GDP_FIXITEM_SEL" class="myui-button-query-main" 
        ><s:text name="common_action_select"/></a></li>
      <!-- 添加 -->
      <li><a href="javascript:void(0)" onclick="add()" actionCode="ACTION_GDP_FIXITEM_ADD" class="myui-button-query" 
        ><s:text name="common_action_add"/></a></li>
      <!-- 修改 -->
      <li><a href="javascript:void(0)" onclick="upt()" actionCode="ACTION_GDP_FIXITEM_UPT" class="myui-button-query" 
        ><s:text name="common_action_update"/></a></li>
      <!-- 删除 -->
      <li><a href="javascript:void(0)" onclick="del()" actionCode="ACTION_GDP_FIXITEM_DEL" class="myui-button-query" 
        ><s:text name="common_action_delete"/></a></li>
      <!-- 导入项目 -->
      <li><a href="javascript:void(0)" onclick="importItems()" actionCode="ACTION_GDP_FIXITEM_IMP" class="myui-button-query" 
        >导入项目</a></li>
      <!-- 回填文件 -->
      <li><a href="javascript:void(0)" onclick="writeToFile()" actionCode="ACTION_GDP_FIXITEM_WRITE" class="myui-button-query" 
        >回填文件</a></li>
    </ul>
  </div>
</div>

<div class="myui-datagrid">
  <table>
    <tr>
      <th><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
      <th field="itemCode" sortable="true">项目编码</th>
      <th field="itemName" sortable="true">项目名称</th>
      <th field="itemAlias" sortable="true">项目别名</th>
    </tr>
    <tbody id="databody">
    </tbody>    
  </table>
</div>

<div class="myui-datagrid-pagination"></div>

<div id="inputWin"></div>

</body>
</html>

