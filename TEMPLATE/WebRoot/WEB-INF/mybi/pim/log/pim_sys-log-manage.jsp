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
<script type="text/javascript" src="${ctx}/mybi/common/scripts/datePicker/WdatePicker.js"></script>
<script type="text/javascript">
	$(function(){
		//动作权限过滤
		actionAuthFilter();
		//导航
		loadLocationLeading("${authMenuId}","${session.i18nDefault}");
		
		$("#oprDate1").datebox({
			dateFormat : 'YYYYMMDD',
			defaultDate : '${startDate}',
			range:{max:{type:'selector',value:'#oprDate2'}}
		});
		$("#oprDate2").datebox({
			dateFormat : 'YYYYMMDD',
			defaultDate : '${endDate}',
			range:{min:{type:'selector',value:'#oprDate1'}}
		});
	})
	
	//分页查询
    function cx(page){
		var oprDate1=$("#oprDate1").val();
		var oprDate2=$("#oprDate2").val();
		//参数
		var param={
				"obj.oprDate1" : oprDate1 ,	
				"obj.oprDate2" : oprDate2 ,	
				"obj.userId" : $.trim($("#userId").val()) ,
				"obj.menuId" : $.trim($("#menuId").val()) ,
				"obj.ip" : $.trim($("#ip").val()) ,
				page : page
		};
		
		//开启蒙板层
		tmp_component_before_load("datagrid");
		//提交
		$.post("pim_sys-log!findSysLogPager.action",param,function(data){ 
    		$(".myui-datagrid-pagination").html(data.datapage);
    		var _data="";
    		if(data.datalist.length>0){
	    		$.each(data.datalist,function(idx,item){
	    			_data+="<tr>";
	    			_data+="<td align=center>"+item.oprDate+"</td>";
	    			_data+="<td align=center>"+item.userLogid+"</td>";
	    			_data+="<td>"+item.userNam+"</td>";
	    			
	    			<s:if test='#session.i18nDefault.equals("en")'>
	    			_data+="<td>"+item.oprDetailEg+"</td>";
	    			</s:if><s:else>
	    			_data+="<td>"+item.oprDetail+"</td>";
	    			</s:else>
	    			_data+="<td>"+item.ip+"</td>";
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
	
	//导出
    function expObjs(exportFileType){
    	//导出操作
    	var oprDate1=$("#oprDate1").val();
    	var oprDate2=$("#oprDate2").val();
    	var userId=$("#userId").val();
    	var ip=$("#ip").val();
    	var menuId=$("#menuId").val();
    	
    	//监控导出状态
    	monitorExportStatus('pim_sys-log!monitorExportStatus.action');
		$.post("pim_sys-log!findSysLogCount.action?exportFileType="+exportFileType+"&oprDate1="+oprDate1
				+"&oprDate2="+oprDate2+"&userId="+userId+"&ip="+ip+"&menuId="+menuId,{},function(data){ 
    		//判断数量是否超限
			if(data.exportStatus=="overrun"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_over"/>',info); //导出数量超限
    			return;
			}
    		//导出
    		window.location.href = "pim_sys-log!exportSysLogList.action?exportFileType="+exportFileType+"&oprDate1="+oprDate1
			+"&oprDate2="+oprDate2+"&userId="+encodeURIComponent(userId)+"&ip="+ip+"&menuId="+encodeURIComponent(menuId);
        },"json"); 
    }
</script>
</head>
<body style="height:660px;">

<div class="myui-template-top-location"></div>

<div class="myui-template-condition">
   <ul>
      <li class="desc" style="width: 45px;"><s:text name="syslog_oprDate"/>：</li>
      <li>
	  	 <input id="oprDate1" name="oprDate1" style="width:86px"> - <input id="oprDate2" name="oprDate2" style="width:86px">
	  </li>
	  <li class="desc" style="width: 45px;"><s:text name="sysauth_sysuser"/>：</li>
      <li>
	  	 <input type="text" id="userId" name="userId" title='<s:text name="common_msg_fuzzy_query"/>'/>
	  </li>
   </ul>
</div>

<div class="myui-template-condition">
   <ul>
      <li class="desc" style="width: 45px;"><s:text name="sysauth_sysMenu"/>：</li>
      <li>
	  	 <input type="text" id="menuId" name="menuId" title='<s:text name="common_msg_fuzzy_query"/>'/>
	  </li>
	  <li class="desc" style="width: 45px;">IP：</li>
      <li>
	  	 <input type="text" id="ip" name="ip" title='<s:text name="common_msg_fuzzy_query"/>'/>
	  </li>
	  
   </ul>
</div>

<div class="myui-template-operating">
	<div class="baseop">
		<ul>
			<li><a href="javascript:void(0);" onclick="cx(1)" class="myui-button-query-main" actionCode="ACTION_PIM_LOG_SEL"><s:text name="common_action_select"/></a></li>
		</ul>
	</div>
	<div class="tableop">
		<ul>
			<li><a href="javascript:void(0);" onclick="expObjs('excel2003');" actionCode="ACTION_PIM_LOG_EXP"><s:text name="common_action_export"/></a></li>
		</ul>
	</div>
</div>

<div  class="myui-datagrid">	
	<table>
		<tr>
			<th><s:text name="syslog_oprTime"/></th>
			<th><s:text name="sysauth_sysuser_logid"/></th>
			<th><s:text name="sysauth_sysuser_nam"/></th>
			<s:if test='#session.i18nDefault.equals("en")'>
			<th><s:text name="syslog_opr"/></th>
			</s:if><s:else>
			<th><s:text name="syslog_opr"/></th>
			</s:else>
			<th>IP</th>
		</tr>
		
		<tbody id="databody">
		</tbody>		
	</table>
</div>

<div class="myui-datagrid-pagination"></div>

</body>

</html>

