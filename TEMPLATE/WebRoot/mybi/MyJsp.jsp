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
		// 页面元素初始化
		initPage();
		
		//默认执行查询
		cx(1);
		
		//导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
	})
	
	// 页面元素初始化
	function initPage() {
		myui_datagrid_renderOrder(cx);
	}
	
	//分页查询
    function cx(page){
		//参数
		var param={
				"obj.curnam" : $.trim($("#curnam").val()) ,
				sort:$("input[name='sort']").val(),
				order:$("input[name='order']").val(),
				page : page
		};
		//开启蒙板层
		tmp_component_before_load("datagrid");
		//提交
		$.post("curcde!findCurcdePager.action", param, function(data){ 
    		$(".myui-datagrid-pagination").html(data.datapage);
    		var _data="";
    		if(data.datalist.length>0){
	    		$.each(data.datalist, function(idx,item){
	    			_data+="<tr>";
	    			_data+="<td align=center>"+item.curno+"</td>";
	    			_data+="<td align=center>"+item.curcde+"</td>";
	    			_data+="<td>"+item.curnam+"</td>";
	    			_data+="<td>"+item.cureng+"</td>";
	    			_data+="<td>"+item.status+"</td>";
	    			_data+="<td align=center>"+item.changedat+"</td>";
	    			_data+="<td align=right>"+item.w_fcur+"</td>";
	    			_data+="<td>"+item.z_cur+"</td>";
	    			_data+="<td>"+item.z_fcur+"</td>";
	    			_data+="</tr>";
				});
    		}else{
    			_data+="<tr><td colspan="+$(".myui-datagrid table tr th").length+">"+"<s:text name='common_msg_nodata'/>"+"</td></tr>";   //没有符合要求的记录！
    		}
			$("#databody").html(_data);
			
			//关闭蒙板层
			tmp_component_after_load("datagrid");
        },"json"); 	
	}
	
</script>
</head>
<body style="height:630px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
   <ul>
      <li class="desc">币种名称：</li>
      <li>
	  	 <input type="text" id="curnam" name="curnam" />
	  </li>
   </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<li><a href="javascript:void(0);" onclick="cx(1)" class="myui-button-query-main" actionCode="ACTION_CURCDE_SEL">查询</a></li>
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
			<th>币种编号</th>
			<th>币种代码</th>
			<th>币种中文名称</th>
			<th>币种英文名称</th>
			<th>状态</th>
			<th>改变日期</th>
			<th>辅币位</th>
			<th>主营货币单位名称</th>
			<th>主营货币辅币名称</th>
		</tr>
		<tbody id="databody">
		</tbody>		
	</table>
	
</div>

<div class="myui-datagrid-pagination"></div>

<div id="inputWin">
</div>

</body>

</html>

