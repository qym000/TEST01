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
		
		//默认执行查询
		cx(1);
		
		//导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
	})
	
	//分页查询
    function cx(page){
		//参数
		var param={
				"obj.nam" : $.trim($("#nam").val()) ,
				page : page
		};
		//开启蒙板层
		tmp_component_before_load("datagrid");
		//提交
		$.post("demo_crud!findCrudPager.action",param,function(data){ 
    		$(".myui-datagrid-pagination").html(data.datapage);
    		var _data="";
    		if(data.datalist.length>0){
	    		$.each(data.datalist,function(idx,item){
	    			_data+="<tr>";
	    			_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+item.id+"'></td>";
	    			
	    			<s:if test='#session.sysActionStringWithAuth.indexOf("ACTION_DEMO_CRUD_DETAIL")!=-1'>	  
		    			_data+="<td><a class='link-style' href='javascript:void(0)' onclick='toDetail(\""+item.id+"\")'>"+item.nam+"</a></td>";
	    			</s:if><s:else>
	    				_data+="<td>"+item.nam+"</td>";
	    			</s:else>
	    			
	    			_data+="<td align='center'>"+item.orgidt+"</td>";
	    			_data+="<td>"+item.orgnam+"</td>";
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
	
	//列表查询（一般在用于添加、修改记录后回显）
    function findList(id){
    	//参数
		var param={
				"obj.id" : id
		};
		$.post("demo_crud!findCrudObjById.action",param,function(data){ 
			$(".myui-datagrid-pagination").html('');
    		var _data="";
   			_data+="<tr>";
   			_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+data.obj.id+"'></td>";
   			_data+="<td>"+data.obj.nam+"</td>";
			_data+="<td align='center'>"+data.obj.orgidt+"</td>";
			_data+="<td>"+data.obj.orgnam+"</td>";
   			_data+="</tr>";
			$("#databody").html('').html(_data);
        },"json"); 	
	}
	
	//添加
	function openInputWin(){
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_add"/>',
			content:'<iframe id="myframe" src=demo_crud!toCrudObjInput.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:290
		});
	}
	
	//修改
	function openUptWin(){
		var objsChecked=$("input[name='checkboxitem']:checked");
    	if(objsChecked.length<=0){
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
    		return;
    	}
    	if(objsChecked.length>1){
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_singleselect"/>','info');//只能选择一条记录
    		return;
    	}
    	
    	var str=$(objsChecked[0]).val();
    	
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_update"/>',
			content:'<iframe id="myframe" src=demo_crud!toCrudObjUpdate.action?id='+str+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:290
		});
	} 
	
	//详情(自定义导航)
	function toDetail(cid){
		var str="";
		if(cid==null || cid==""){
			var objsChecked=$("input[name='checkboxitem']:checked");
	    	if(objsChecked.length<=0){
	    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
	    		return;
	    	}
	    	if(objsChecked.length>1){
	    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_singleselect"/>','info');//只能选择一条记录
	    		return;
	    	}
	    	
	    	str=$(objsChecked[0]).val();
		}else{
			str=cid;
		}
		
    	location.href="demo_crud!toCrudObjDetail.action?id="+str;
	}
	
	
	//删除
	function deleteObjs(){
		var objsChecked=$("input[name='checkboxitem']:checked");
		if(objsChecked.length<=0){
			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
    		return;
    	}
		var _msg='<s:text name="common_msg_confirmdelete"/>';
		$.messager.confirm2('<s:text name="common_msg_info"/>', _msg, function(){
           	var ids_crud=getIdFieldsOfChecked();	
           	$.post("demo_crud!deleteCrudList.action",{ids_crud:ids_crud},function(data){ 
	    		if(data.result=="succ"){
	    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info',function(){  //操作成功
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
	
	//把资源分配给角色/用户
	function assign(){
		var restypCode="RES_GRUD"; //资源类型
		
		var objsChecked=$("input[name='checkboxitem']:checked");
    	if(objsChecked.length<=0){
    		$.messager.alert('提示','没有选择记录','info');//没有选择记录
    		return;
    	}
    	//获取选中的资源ID，逗号分隔组成字符串
    	var ids_res= getResIdOfChecked();	
		$("#inputWin").window({
			open : true,
			headline:'分配',
			content:'<iframe id="myframe" src=pim_res2roleuser!toManage.action?restypCode='+restypCode+'&ids_res='+ids_res+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:700,
			panelHeight:420
		});
	}

	// 得到表中选中的记录
	function getResIdOfChecked(){
		var ids="";
		var objsChecked=$("input[name='checkboxitem']:checked");
		if(objsChecked.length>=1){
			for(var i=0;i<objsChecked.length;i++){
				ids+=$(objsChecked[i]).val()+",";
			}
		}
		return ids;
	}
	
	function getRestypCode(){
		return "RES_CRUD";
	}
	
	// 流程表单临时参数对象
	var stepParam = {};
	// 转向流程表单；
	function toStepForm() {
		stepParam = {};
		$("#inputWin").window({
			open : true,
			headline:'流程表单',
			content:'<iframe id="formS1" name="formS2" src=demo_step-form!stepFormController.action?step=1 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:300
		});
	}
	
	// 转向流程表单修改；
	function toStepFormUpt() {
		var objsChecked=$("input[name='checkboxitem']:checked");
    	if(objsChecked.length<=0){
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
    		return;
    	}
    	if(objsChecked.length>1){
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_singleselect"/>','info');//只能选择一条记录
    		return;
    	}
    	
    	var str=$(objsChecked[0]).val();
		$("#inputWin").window({
			open : true,
			headline:'流程表单修改',
			content:'<iframe id="stepFormUpt" name="stepFormUpt" src=demo_step-form!uptFormController.action?step=1&id='+str+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:300
		});
	}
	
	// 导出chartExcel
	function exportChartExcel() {
		window.location.href = "${ctx}/demo_chart-excel!exportChartExcel.action";
	}

</script>
</head>
<body style="height:630px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
   <ul>
      <li class="desc"><s:text name="crud_nam"/>：</li>
      <li>
	  	 <input type="text" id="nam" name="nam" title='<s:text name="common_msg_fuzzy_query"/>'/>
	  </li>
   </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<li><a href="javascript:void(0);" onclick="cx(1)" class="myui-button-query-main" actionCode="ACTION_DEMO_CRUD_SEL"><s:text name="common_action_select"/></a></li>
			<li><a href="javascript:void(0);" onclick="openInputWin()" class="myui-button-query" actionCode="ACTION_DEMO_CRUD_SAV"><s:text name="common_action_add"/></a></li>
			<li><a href="javascript:void(0);" onclick="openUptWin()" class="myui-button-query" actionCode="ACTION_DEMO_CRUD_UPT"><s:text name="common_action_update"/></a></li>
			<li><a href="javascript:void(0);" onclick="deleteObjs()" class="myui-button-query" actionCode="ACTION_DEMO_CRUD_DEL"><s:text name="common_action_delete"/></a></li>
			<li><a href="javascript:void(0);" onclick="toDetail()" class="myui-button-query-big" actionCode="ACTION_DEMO_CRUD_DETAIL">详情(导航)</a></li>
			<li><a href="javascript:void(0);" onclick="assign()" class="myui-button-query-big" actionCode="ACTION_DEMO_CRUD_ASSIGN">权限分配</a></li>
			<li><a href="javascript:void(0);" onclick="toStepForm()" class="myui-button-query-big">流程表单</a></li>
			<li><a href="javascript:void(0);" onclick="toStepFormUpt()" class="myui-button-query-big">流程表单修改</a></li>
			<li><a href="javascript:void(0);" onclick="exportChartExcel()" class="myui-button-query-big">导出图表Excel</a></li>
		</ul>
	</div>
	<div class="tableop">
		<ul>
		</ul>
	</div>
</div>

<div class="myui-datagrid">	
	<table>
		<tr>
			<th><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
			<th><s:text name="crud_nam"/></th>
			<th><s:text name="crud_orgidt"/></th>
			<th><s:text name="org_orgnam"/></th>
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

