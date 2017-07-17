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
		
		//参数类型combo
		$("#paramtypId").combo({
			mode:'local',
			valueField:'id',
			textField:'nam',
			data : ${request.paramtypList},
			isCustom:true,
			customData:[{id:'',nam:'<s:text name="msgboard_typ_all"/>'}]
		});
		
		//默认执行查询
		cx(1);
		
		//导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
	})
	
	//分页查询
    function cx(page){
		//参数
		var param={
				"obj.paramtypId" : $("#paramtypId").combo('getValue') ,	
				"obj.pdesc" : $.trim($("#pdesc").val()) ,
				page : page
		};
		//开启蒙板层
		tmp_component_before_load("datagrid");
		//提交
		$.post("pim_sys-param!findSysParamPager.action",param,function(data){ 
    		$(".myui-datagrid-pagination").html(data.datapage);
    		var _data="";
    		if(data.datalist.length>0){
	    		$.each(data.datalist,function(idx,item){
	    			_data+="<tr>";
	    			_data+="<td>&nbsp;&nbsp;<input type='checkbox' name='checkboxitem' value='"+item.pkey+"'>&nbsp;&nbsp;</td>";
	    			_data+="<td>"+item.paramtypNam+"</td>";
	    			<s:if test='#session.loginUserObj.id.equals("0")'>
	    			_data+="<td>"+item.pkey+"</td>";
	    			</s:if>
	    			if(item.pdesc!=null && item.pdesc.length>20){
	    				_data+="<td title="+item.pdesc+">"+item.pdesc.substring(0,20)+"...</td>";	
	    			}else{
	    				_data+="<td title="+item.pdesc+">"+item.pdesc+"</td>";
	    			}
	    			_data+="<td width=200px>"+item.pval+"</td>";
	    			<s:if test='#session.loginUserObj.id.equals("0")'>
	    			_data+="<td align=center>"+item.isdevuseShow+"</td>";
	    			</s:if>
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
    function findList(pkey){
    	var param={
				"obj.pkey" : pkey
		};
		$.post("pim_sys-param!findSysParamObjByPkey.action",param,function(data){ 
			$(".myui-datagrid-pagination").html('');
    		var _data="";
   			_data+="<tr>";
   			_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+data.obj.pkey+"'></td>";
   			_data+="<td>"+data.obj.paramtypNam+"</td>";
   			<s:if test='#session.loginUserObj.id.equals("0")'>
   			_data+="<td>"+data.obj.pkey+"</td>";
   			</s:if>
   			_data+="<td>"+data.obj.pdesc+"</td>";
   			_data+="<td>"+data.obj.pval+"</td>";
   			<s:if test='#session.loginUserObj.id.equals("0")'>
   			_data+="<td align=center>"+data.obj.isdevuseShow+"</td>";
   			</s:if>
   			_data+="</tr>";
			$("#databody").html('').html(_data);
        },"json"); 	
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
			content:'<iframe id="myframe" src=pim_sys-param!toSysParamObjUpdate.action?pkey='+str+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:520,
			panelHeight:310
		});
	}
</script>
</head>
<body style="height:630px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
   <ul>
   	  <li class="desc"><s:text name="sysparamtyp_nam"/>：</li>
      <li>
	  	 <input id="paramtypId"/>
	  </li>
      <li class="desc" style="width: 100px"><s:text name="sysparam_pkey"/>/<s:text name="sysparam_pval"/>/<s:text name="sysparam_pdesc"/>：</li>
      <li>
	  	 <input type="text" id="pdesc" name="pdesc" title='<s:text name="common_msg_fuzzy_query"/>'/>
	  </li>
   </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<li><a href="javascript:void(0);" onclick="cx(1)" class="myui-button-query-main" actionCode="ACTION_PIM_PARAM_SEL"><s:text name="common_action_select"/></a></li>
			<li><a href="javascript:void(0);" onclick="openUptWin()" class="myui-button-query" actionCode="ACTION_PIM_PARAM_UPT"><s:text name="common_action_update"/></a></li>
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
			<th style="width:50px;"><input type="checkbox" name="all" onclick="checkAll('checkboxitem')" /></th>
			<th><s:text name="sysparamtyp_nam"/></th>
			<s:if test='#session.loginUserObj.id.equals("0")'>
			<th><s:text name="sysparam_pkey"/></th>
			</s:if>
			<th><s:text name="sysparam_pdesc"/></th>
			<th><s:text name="sysparam_pval"/></th>
			<s:if test='#session.loginUserObj.id.equals("0")'>
			<th><s:text name="sysparam_isdevuse"/></th>
			</s:if>
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

