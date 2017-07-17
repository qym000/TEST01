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
		 
		cx(1);
	});
	
	//分页查询
    function cx(page){
    	var ids_role=parent.getIdFieldsOfChecked();
		//开启蒙板层
		tmp_component_before_load("datagrid");
		//提交
		$.post("pim_sys-role!findSysUserPagerForAssign.action",{ids_role:ids_role},function(data){ 
    		var _data="";
    		if(data.datalist.length>0){
	    		$.each(data.datalist,function(idx,item){
	    			_data+="<tr>";
	    			if(item.isChecked=="1"){
	    				_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+item.id+"' checked></td>";	
	    			}else{
	    				_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+item.id+"'></td>";
	    			}
	    			
	    			_data+="<td>"+item.nam+"</td>";
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
	
	/**
	 * 表单提交
	 */
	function sbt(){
		var ids_role=parent.getIdFieldsOfChecked();
		var ids_user=getIdFieldsOfChecked();
		var ids_user_unsel=getIdFieldsOfUnChecked();
		$.post("pim_sys-role!saveSysUserSysRoleMapList.action",{ids_role:ids_role,ids_user:ids_user,ids_user_unsel:ids_user_unsel},function(data){ 
    		if(data.result=="succ"){
    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info',function(){ //添加成功
	    			clsWin();
    			});
			}else if(data.result=="fail"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>'); //添加失败
			}
        },"json");
	}
	
	/**
	 * 关闭当前窗口
	 */
    function clsWin(){
    	parent.$('#inputWin').window('close');
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
    
	//得到表中没有选中的记录
	function getIdFieldsOfUnChecked(){
		var ids="";
		var objsChecked=$("input[name='checkboxitem']:not(checked)");
		if(objsChecked.length>=1){
			for(var i=0;i<objsChecked.length;i++){
				ids+=$(objsChecked[i]).val()+",";
			}
		}
		return ids;
	}
	
	//复选框全选
   	function checkAll(str){   
		var a = document.getElementsByName(str);   
		var n = a.length;   
		for (var i=0; i<n; i++)   {
			if(a[i].disabled==false){
			  	a[i].checked = window.event.srcElement.checked;   
			}
		}
	}	
</script>
</head>
<body>

<div class="myui-form">
	<div class="form" style="width:578px;overflow-x:hidden;">
		<form id="form_input" method="post">
			 <div  class="myui-datagrid" style="width:100%;height:200px;overflow:auto;">	
				<table style="width:100%;border-top-width:0px;">
					<tr>
						<th><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
						<th><s:text name="sysauth_sysuser_nam"/></th>
					</tr>
					<tbody id="databody">
					</tbody>		
				</table>
			 </div>
			 <div class="myui-datagrid-pagination"></div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>

