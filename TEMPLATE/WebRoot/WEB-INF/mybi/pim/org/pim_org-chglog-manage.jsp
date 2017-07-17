<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css"  rel="stylesheet" type="text/css">
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript">
  $(function(){
    //动作权限过滤
    actionAuthFilter();
    
    $("#chgtyp").combo({
      mode:'local',
      valueField:'id',
      textField:'nam',
      data : [{id:'', nam:'<s:text name="org_chglog_please_select"/>'},
              {id:'1', nam:'<s:text name="org_chglog_chgtyp_add"/>'},
              {id:'2', nam:'<s:text name="org_chglog_chgtyp_updinfo"/>'},
              {id:'3', nam:'<s:text name="org_chglog_chgtyp_updmap"/>'},
              {id:'4', nam:'<s:text name="org_chglog_chgtyp_delorg"/>'}],
      panelWidth:150,
      panelHeight:150
    });
    
    cx(1);
  });

  //分页查询
    function cx(page){
    
    //参数
    var chgtyp = $("#chgtyp").combo("getValue");
    var orgidt = $("#orgidt").val();
    //开启蒙板层
    tmp_component_before_load("datagrid");
    //提交
    $.post("pim_org-chglog!findOrgChglogPager.action?page="+page,{chgtyp:chgtyp,orgidt:orgidt},function(data){ 
        $(".myui-datagrid-pagination").html(data.datapage);
        var _data="";
        if(data.datalist.length>0){
          $.each(data.datalist,function(idx,item){
               _data+="<tr>";
               _data+="<td>" + item.orgidt + "</td>";
               _data+="<td>" + item.orgnam + "</td>";
            _data+="<td>" + item.nam + "</td>";
            _data+="<td>" + item.usrnam + "</td>";
            _data+="<td>" + item.chgdate + "</td>";
            _data+="<td>" + item.chgdesc + "</td>";
               _data+="</tr>";
        });
        }else{
          _data+="<tr><td colspan="+$(".myui-datagrid table tr th").length+">"+"<s:text name='common_msg_nodata'/>"+"</td></tr>";
        }
      $("#databody").html(_data);
      //关闭蒙板层
      tmp_component_after_load("datagrid");
        },"json");   
  }
  
  //删除
  function deleteObjs(){
    var objsChecked=$("input[name='checkboxitem']:checked");
    if(objsChecked.length <= 0){
      $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
        return;
      }else if(objsChecked.length > 1){
        $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_singleselect"/>','info');//没有选择记录
        return;
    }

    $.messager.confirm('<s:text name="common_msg_info"/>', '<s:text name="common_msg_confirmdelete"/>', function(){
             var id = $("input[name='checkboxitem']:checked").eq(0).val();  
             $.post("product-class-map!delProductClassMap.action",{id:id},function(data){ 
          if(data.result=="succ"){
            $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info', function(){//操作成功
              cx(1);  
            });
        }else if(data.result=="fail"){
          $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>'); //操作失败
        }
          },"json");
        });
  }
  
  //得到表中选中的记录
  function getIdFieldsOfChecked(){
    var ids="";
    var objsChecked=$("input[name='checkboxitem']:checked");
    if(objsChecked.length>=1){
      for(var i=0;i<objsChecked.length;i++){
        ids+=$(objsChecked[i]).val()+",";
      }
    }
    return ids;
  }
</script>
</head>
<body style="padding-left:8px;">
  <div class="myui-template-condition" style="margin-top:8px;width:850px;">
     <ul>
        <li class="desc"><s:text name="org_chglog_chgtyp"/>：</li>
        <li>
         <input type="text" id="chgtyp" style="width: 150px;"/>
      </li>
      <li class="desc"><s:text name=""/><s:text name="org_chglog_orgidt"/>：</li>
        <li>
         <input type="text" id="orgidt" style="width: 150px;" title='<s:text name="common_msg_fuzzy_query"/>'/>
      </li>
     </ul>
  </div>
  <div class="myui-template-operating" style="width:850px;">
    <div class="baseop">
      <ul>
        <li><a href="javascript:void(0);" onclick="cx(1)" class="myui-button-query-main"><s:text name="common_action_select"/></a></li>
      </ul>
    </div>
  </div>

  <div class="myui-datagrid" style="width:850px;">  
    <table>
      <tr>
        <th><s:text name="org_chglog_orgidt"/></th>
        <th><s:text name="org_chglog_orgnam"/></th>
        <th><s:text name="org_chglog_chgtyp"/></th>
        <th><s:text name="org_chglog_operator"/></th>
        <th><s:text name="org_chglog_operate_time"/></th>
        <th><s:text name="org_chglog_chgdes"/></th>
      </tr>
      <tbody id="databody">
      </tbody>    
    </table>
  </div>

  <div class="myui-datagrid-pagination"></div>
</body>
</html>