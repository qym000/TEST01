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
	var ids_role=parent.opener.getIdFieldsOfChecked();
	$(function(){
		findResList();
	});
	
	//获取资源列表
    function findResList(){
    	//var ids_role=parent.parent.getIdFieldsOfChecked();
    	var _data="";
    	add_onload();//开启蒙板层
    	$.post("pim_res-sys-menu!findResList.action",{ids_role:ids_role},function(data){ 
    		if(data.objList.length>0){
	    		$.each(data.objList,function(idx,item){
	    			_data+="<tr>";
	    			_data+="<td>";
	    			if(item.lvl>=2){
	    				for(i=0;i<(item.lvl-1)*2;i++){
	    					_data+="&nbsp;&nbsp;";
		    			}
	    			}
	    			if(item.isChecked=="1"){
	    				_data+="<input type='checkbox' name='checkboxitem' pid='"+item.pid+"' id='"+item.id+"' class='menu_item "+item.pid+"'  onclick=pnodecheck('"+item.pid+"','"+item.id+"','1') value='"+item.id+"' checked='checked'>&nbsp;";
	    			}else{
	    				_data+="<input type='checkbox' name='checkboxitem' pid='"+item.pid+"' id='"+item.id+"' class='menu_item "+item.pid+"'  onclick=pnodecheck('"+item.pid+"','"+item.id+"','1') value='"+item.id+"'>&nbsp;";
	    			}
	    			
	    			<s:if test='#session.i18nDefault.equals("zh")'>
	    			_data+=item.nam;
	    			</s:if><s:elseif test='#session.i18nDefault.equals("en")'>
	    			_data+=item.namEg;
	    			</s:elseif>
	    			_data+="</td>";
	    			_data+="<td>";
	    			if(item.sysActionList.length>0){
		    			$.each(item.sysActionList,function(i,o){
		    				if(i!=0 && i%6==0){
		    					_data+="<br/>";
		    				}
		    				if(o.isChecked=="1"){
		    					if(o.isdefault=="1"){
		    						_data+="&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='checkboxitem2' isdefault='"+o.isdefault+"' mid='"+item.id+"' class='action_item'  value='"+o.id+"' onclick=rd(this,'"+item.pid+"','"+item.id+"','0') checked='checked'>&nbsp;";
			    					<s:if test='#session.i18nDefault.equals("zh")'>
			    					_data+='<span style="color:gray">'+o.nam+'</span>';
					    			</s:if><s:elseif test='#session.i18nDefault.equals("en")'>
					    			_data+='<span style="color:gray">'+o.namEg+'</span>';
					    			</s:elseif>
		    					}else{
		    						_data+="&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='checkboxitem2' isdefault='"+o.isdefault+"' mid='"+item.id+"' class='action_item'  value='"+o.id+"' onclick=mcheck(this,'"+item.pid+"','"+item.id+"','0') checked='checked'>&nbsp;";
		    						<s:if test='#session.i18nDefault.equals("zh")'>
		    						_data+=o.nam;
					    			</s:if><s:elseif test='#session.i18nDefault.equals("en")'>
					    			_data+=o.namEg;
					    			</s:elseif>
		    					}
		    				}else{
		    					if(o.isdefault=="1"){
		    						_data+="&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='checkboxitem2' isdefault='"+o.isdefault+"' mid='"+item.id+"' class='action_item'  value='"+o.id+"' disabled='disabled' onclick=rd(this,'"+item.pid+"','"+item.id+"','0')>&nbsp;";
		    						<s:if test='#session.i18nDefault.equals("zh")'>
		    						_data+='<span style="color:#aaa">'+o.nam+'</span>';
					    			</s:if><s:elseif test='#session.i18nDefault.equals("en")'>
					    			_data+='<span style="color:gray">'+o.namEg+'</span>';
					    			</s:elseif>
		    					}else{
		    						_data+="&nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='checkboxitem2' isdefault='"+o.isdefault+"' mid='"+item.id+"' class='action_item'  value='"+o.id+"' onclick=mcheck(this,'"+item.pid+"','"+item.id+"','0')>&nbsp;";
		    						<s:if test='#session.i18nDefault.equals("zh")'>
		    						_data+=o.nam;
					    			</s:if><s:elseif test='#session.i18nDefault.equals("en")'>
					    			_data+=o.namEg;
					    			</s:elseif>
		    					}
		    				}
		    			});
	    			}
	    			_data+="</td>";
	    			_data+="</tr>";
				});
	    		$("#databody").html(_data);
    		}
 
    		clean_onload();//关闭蒙板层
        },"json"); 
    }
    
    //提交分配
    function sbt(){
		//被选中的角色
		//var ids_role=parent.parent.getIdFieldsOfChecked();
    	//被选中的功能
		var menuChecked=$("input[name='checkboxitem'].menu_item:checked");
		var ids_menu="";
		var ids_action="";
		if(menuChecked.length>0){
    		menuChecked.each(function (){
    			ids_menu+=$(this).val()+",";
	    	});
		}
		//被选中的动作
		var actionChecked=$("input[name='checkboxitem2'].action_item:checked");
		if(actionChecked.length>0){
    		actionChecked.each(function (){
    			ids_action+=$(this).val()+",";
	    	});
		}
		
		add_onload();//开启蒙板层
		$.post("pim_res-sys-menu!assignResList.action",{ids_role:ids_role,ids_menu:ids_menu,ids_action:ids_action},function(data){ 
			if(data.result=="succ"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info',function(){ //添加成功
    			});
			}else if(data.result=="fail"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info'); //添加失败
			}
			
			clean_onload();//关闭蒙板层
        },"json"); 
	}
    
    //当选中动作时，所属功能节点被选中
    function mcheck(obj,pid,id,isactionautocheck){
    	if($(obj).prop("checked")==true){
    		$("input[name='checkboxitem'][id='"+id+"']").attr('checked', true);
	    	pnodecheck(pid,id,isactionautocheck);
    	}else{
    		if($("input[name='checkboxitem2'][mid='"+id+"']:checked").length==0){
    			$("input[name='checkboxitem'][id='"+id+"']").attr('checked', false);
		    	pnodecheck(pid,id,isactionautocheck);
    		}
    	}
    }
    
   //当选中动作时，所属功能节点被选中
   function rd(obj,pid,id,isactionautocheck){
	   $(obj).attr('checked', true);
	   return false;
   }
    
   //子节点关联父节点勾选,父节点关联子节点取消勾选
   function pnodecheck(pid,id,isactionautocheck){
		var $obj = $('#'+pid);
		var $id = $('#'+id);
		if($id.prop("checked")==true){
			if(isactionautocheck=="1"){
				//选中当前功能的所有动作
				$("input[name='checkboxitem2'][mid='"+id+"']").each(function() {
					$(this).attr('disabled', false);
			        $(this).attr('checked', true);
				});
			}else{
				//选中当前功能的所有默认动作
				$("input[name='checkboxitem2'][mid='"+id+"']").each(function() {
					if($(this).attr("isdefault")=="1"){
						$(this).attr('disabled', false);
				        $(this).attr('checked', true);
					}
				});
			}
			
			//选中上级功能节点
			if(typeof($obj.attr('pid'))!="undefined"){
				$obj.attr("checked","checked");
				pnodecheck($('#'+pid).attr('pid'),$('#'+id).attr('pid'),isactionautocheck);
			}
		}else{
			$('.'+id).prop("checked",false);
			//取消选中当前功能的所有动作
			$("input[name='checkboxitem2'][mid='"+id+"']").each(function() {
		        $(this).attr('checked', false);
		        
		        if($(this).attr("isdefault")=="1"){
					$(this).attr('disabled', 'disabled');
				}
			});
			
			$("input[name='checkboxitem'][pid='"+id+"']").each(function(i) {
				$(this).prop("checked",false);
				pnodecheck(id,this.id,isactionautocheck);
			});
		}
	}
</script>
</head>
<body style="overflow:auto;">

<div class="myui-form">
	<div class="form" style="width:100%;overflow-x:hidden;>
		<form id="form_input" method="post">
			 <div  class="myui-datagrid" style="margin:5px;width:auto;height:550px;overflow:auto;">	
				<table style="width:100%;border-top-width:0px;">
					<tr>
						<th><s:text name="sysauth_sysMenu"/></th>
						<th><s:text name="sysauth_sysAction"/></th>
					</tr>
					<tbody id="databody">
					</tbody>		
				</table>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()" style="margin-left:20px;float:left;"><s:text name="common_action_submit"/></a>
	</div>
</div>

</body>

</html>

