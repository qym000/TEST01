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
	$(function(){
		//动作权限过滤
		actionAuthFilter();
	})
	
	//分页查询
    function cx(page){
		//参数
		var typ=$("#typ li.option_selected").attr("vl");
		var userId=$("#userId").val();
		//var content=$("#content").val();
		//开启蒙板层
		tmp_component_before_load("datagrid");
		//提交
		$.post("pim_sys-improve!findSysImprovePager.action?page="+page,{typ:typ,userId:userId},function(data){ 
    		$(".myui-datagrid-pagination").html(data.datapage);
    		var _data="";
    		if(data.datalist.length>0){
	    		$.each(data.datalist,function(idx,item){
	    			_data+="<tr>";
	    			_data+="<td>"+item.typShow+"</td>";
	    			_data+="<td>"+item.userNam+"</td>";
	    			_data+="<td>"+item.content+"</td>";
	    			_data+="<td>"+item.oprDate+"</td>";
	    			_data+="<td>"+item.phonenum+"</td>";
	    			_data+="<td>"+item.email+"</td>";
	    			
	    			_data+="</tr>";
				});
    		}else{
    			_data+="<tr><td colspan=10>没有符合要求的记录！</td></tr>";   //没有符合要求的记录！
    		}
			$("#databody").html(_data);
			//关闭蒙板层
			tmp_component_after_load("datagrid");
        },"json"); 	
	}
	
	//复选框全选
	/**
   	function checkAll(str){   
		var a = document.getElementsByName(str);   
		var n = a.length;   
		for (var i=0; i<n; i++)   {
			if(a[i].disabled==false){
			  	a[i].checked = window.event.srcElement.checked;   
			}
		}
	}**/
</script>
</head>
<body style="height:660px;">

<div class="myui-template-top-location">
   <ul class="index">
   	  <li><s:text name="common_msg_location"/>：</li>
   	  <s:iterator value="%{#request.locationList}" id="loc" status="index">
   	  	 <s:if test='#loc.url!=null'>
   	  	 	<s:if test="#index.last">
   	  	 		<li class="index_current"> <s:if test="#index.index >=1"> > </s:if> ${nam}&nbsp;</li>
   	  	 	</s:if><s:else>
   	  	 		<s:if test='#loc.url.indexOf("?")!=-1'>
   	  	 			<li class="index_current"> <s:if test="#index.index >=1"> > </s:if> <a href="${url}&authTyp=menu&authMenuId=${id}">${nam}</a>&nbsp;</li>
   	  	 		</s:if><s:else>
   	  	 			<li class="index_current"> <s:if test="#index.index >=1"> > </s:if> <a href="${url}?authTyp=menu&authMenuId=${id}">${nam}</a>&nbsp;</li>
   	  	 		</s:else>
   	  	 	</s:else>
   	  	 </s:if><s:else>
   	  	 	<li class="index_his"> <s:if test="#index.index >=1"> > </s:if> ${nam}&nbsp;</li>
   	  	 </s:else>
   	  </s:iterator>
   </ul>
</div>

<div class="myui-template-condition">
   <ul>
      <li class="desc"><s:text name="msgboard_typ"/>：</li>
      <li>
	  	 <ul class="seltile" id="typ">
		 	<li class="option_selected" vl=""><s:text name="msgboard_typ_all"/></li>
			<li class="option" vl="0"><s:text name="msgboard_typ0"/></li>
			<li class="option" vl="1"><s:text name="msgboard_typ1"/></li>
			<li class="option" vl="2"><s:text name="msgboard_typ2"/></li>
		 </ul>
	  </li>
   </ul>
</div>

<div class="myui-template-condition">
   <ul>
      <li class="desc"><s:text name="sysauth_sysuser"/>：</li>
      <li>
	  	 <input type="text" id="userId" name="userId" title='<s:text name="common_msg_fuzzy_query"/>'/>
	  </li>
   </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<li><a href="javascript:void(0);" onclick="cx(1)" class="myui-button-query" actionCode="ACTION_PIM_IMPROVE_SEL" style="display:none;">查询</a></li>
		</ul>
	</div>
	<div class="tableop">
		<ul>
		</ul>
	</div>
</div>

<div  class="myui-datagrid">	
	<table>
		<tr>
			<th><s:text name="msgboard_typ"/></th>
			<th><s:text name="sysauth_sysuser"/></th>
			<th><s:text name="msgboard_content"/></th>
			<th><s:text name="msgboard_oprDate"/></th>
			<th><s:text name="sysauth_sysuser_phonenum"/></th>
			<th><s:text name="sysauth_sysuser_email"/></th>
		</tr>
		<tbody id="databody">
			
		</tbody>		
	</table>
</div>

<div class="myui-datagrid-pagination"></div>

<div class="myui_window" id="inputWin">
</div>

</body>

<script type="text/javascript">
	//$(function(){  
		//setSelected("tab");
		//setSelected("seltile");
	//});  
</script>
</html>

