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
		
		//菜单导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
		cx(1);
	});

	//分页查询
    function cx(page){
		//开启蒙板层
		tmp_component_before_load("datagrid");
		
		//参数
 		var ip = $.trim($("#ip").val());
		var param = {"pim_jdbc.ip":ip, page:page};
		
		//提交
		$.post("pim_jdbc!findJdbcPager.action", param, function(data){ 
    		$(".myui-datagrid-pagination").html(data.datapage);
    		var _data="";
    		if(data.datalist.length > 0){
	    		$.each(data.datalist,function(idx,item){
	    			_data+="<tr>";
	    			_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+item.connectId+"'></td>";
	    			_data+="<td>"+item.ip+"</td>";
	    			_data+="<td>"+item.port+"</td>";
	    			_data+="<td>"+item.sid+"</td>";
	    			_data+="<td>"+item.username+"</td>";
	    			_data+="<td>"+item.connectDesc+"</td>";
	    			_data+="<td>"+item.remark+"</td>";
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
		var param = {"pim_jdbc.connectId":id};
		$.post("pim_jdbc!findJdbcObjById.action", param, function(data){ 
			$(".myui-datagrid-pagination").html('');
    		var _data="";
    		_data+="<tr>";
			_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+data.obj.connectId+"'></td>";
			_data+="<td>"+data.obj.ip+"</td>";
			_data+="<td>"+data.obj.port+"</td>";
			_data+="<td>"+data.obj.sid+"</td>";
			_data+="<td>"+data.obj.username+"</td>";
			_data+="<td>"+data.obj.connectDesc+"</td>";
			_data+="<td>"+data.obj.remark+"</td>";
			_data+="</tr>";
			$("#databody").html(_data);
        },"json"); 	
	}
	
	//添加
	function openInputWin(){
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_add"/>',
			content:'<iframe id="myframe" src=pim_jdbc!toJdbcObjInput.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:540,
			panelHeight:400
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
			content:'<iframe id="myframe" src=pim_jdbc!toJdbcObjUpdate.action?pim_jdbc.connectId='+str+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:540,
			panelHeight:400
		});
	} 
	
	//删除
	function deleteObjs(){
		var objsChecked=$("input[name='checkboxitem']:checked");
		if(objsChecked.length<=0){
			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
    		return;
    	}
		var _msg='<s:text name="common_msg_confirmdelete"/>';
		$.messager.confirm('<s:text name="common_msg_info"/>', _msg, function(){
           	var ids_jdbc = getIdFieldsOfChecked();
           	var param = {ids_jdbc:ids_jdbc};
           	$.post("pim_jdbc!deleteJdbcList.action", param, function(data){ 
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
</script>
</head>
<body style="height:630px;">
	<div class="myui-template-top-location"></div>

	<div class="myui-template-condition">
	   <ul>
	      <li class="desc" style="width: 120px"><s:text name="pim_jdbc_serverip"/>：</li>
	      <li>
		  	 <input type="text" id="ip" name="ip" title='<s:text name="common_msg_fuzzy_query"/>'/>
		  </li>
	   </ul>
	</div>

	<div class="myui-template-operating">
		<div class="baseop">
			<ul>
				<li><a href="javascript:void(0);" onclick="cx(1)" class="myui-button-query-main" actionCode="ACTION_PIM_JDBC_SEL"><s:text name="common_action_select"/></a></li>
				<li><a href="javascript:void(0);" onclick="openInputWin()" class="myui-button-query" actionCode="ACTION_PIM_JDBC_SAV"><s:text name="common_action_add"/></a></li>
				<li><a href="javascript:void(0);" onclick="openUptWin()" class="myui-button-query" actionCode="ACTION_PIM_JDBC_UPT"><s:text name="common_action_update"/></a></li>
				<li><a href="javascript:void(0);" onclick="deleteObjs()" class="myui-button-query" actionCode="ACTION_PIM_JDBC_DEL"><s:text name="common_action_delete"/></a></li>
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
				<th><s:text name="pim_jdbc_serverip"/></th>
				<th><s:text name="pim_jdbc_serverport"/></th>
				<th><s:text name="pim_jdbc_oraclesid"/></th>
				<th><s:text name="pim_jdbc_oracleusername"/></th>
				<th><s:text name="pim_jdbc_connectdesc"/></th>
				<th><s:text name="pim_jdbc_oracleremark"/></th>
			</tr>
			<tbody id="databody"></tbody>		
		</table>
	</div>

	<div class="myui-datagrid-pagination"></div>

	<div id="inputWin"></div>
</body>
</html>