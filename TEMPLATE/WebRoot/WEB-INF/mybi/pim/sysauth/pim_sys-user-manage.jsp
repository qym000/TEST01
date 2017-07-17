<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"
	rel="stylesheet" type="text/css" />
<link
	href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
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
		

	//	setConditionHide('down');
		
		//参数
		var param={
				"obj.logid" : $.trim($("#logid").val()) ,
				"obj.orgidt" : $.trim($("#orgidt").val()) ,
				"obj.stat" : $("#stat li.option_selected").attr("vl") ,	
				page : page
		};
		
		//开启蒙板层
		tmp_component_before_load("datagrid");
		//提交
		$.post("pim_sys-user!findSysUserPager.action",param,function(data){ 
    		$(".myui-datagrid-pagination").html(data.datapage);
    		var _data="";
    		if(data.datalist.length>0){
	    		$.each(data.datalist,function(idx,item){
	    			_data+="<tr>";
	    			_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+item.id+"'></td>";
	    			_data+="<td align='center'>"+item.logid+"</td>";
	    			_data+="<td align='center'>"+item.nam+"</td>";
	    			_data+="<td align='center'>"+item.orgidt+"</td>";
	    			_data+="<td>"+item.orgnam+"</td>";
	    			_data+="<td align=center>"+item.statShow+"</td>";
	    			
	    			<s:iterator value="%{#request.sysUserColConfigList}" id="o">
		    			<s:if test='#o.isExtend=="1" || #o.isExtend=="2"'>
		    				_data+="<td>"+item.${o.prop}+"</td>";
		    			</s:if>
	    			</s:iterator>
	    			
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
    	var param={
				"obj.id" : id
		};
		$.post("pim_sys-user!findSysUserObjById.action",param,function(data){ 
    		$(".myui-datagrid-pagination").html('');
    		var _data="";
   			_data+="<tr>";
   			_data+="<td align='center'><input type='checkbox' name='checkboxitem' value='"+data.obj.id+"'></td>";
   			_data+="<td align='center'>"+data.obj.logid+"</td>";
			_data+="<td align='center'>"+data.obj.nam+"</td>";
			_data+="<td align='center'>"+data.obj.orgidt+"</td>";
			_data+="<td>"+data.obj.orgnam+"</td>";
			_data+="<td align='center'>"+data.obj.statShow+"</td>";
			
			<s:iterator value="%{#request.sysUserColConfigList}" id="o">
				<s:if test='#o.isExtend=="1" || #o.isExtend=="2"'>
					_data+="<td>"+data.obj.${o.prop}+"</td>";
				</s:if>
			</s:iterator>
   			_data+="</tr>";
			$("#databody").html('').html(_data);
        },"json"); 	
		
	}
	
	//添加
	function openInputWin(){
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_add"/>',
			content:'<iframe id="myframe" src=pim_sys-user!toSysUserObjInput.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:530,
			panelHeight:430
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
    	
    	
        for(var i=0;i<objsChecked.length;i++){
        	//1.如果是admin用户不可以修改（my用户除外）
					if($(objsChecked[i]).val()=="1" && "${loginUserObj.logid}" != "my"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="sysauth_sysrole_msg_noupdate"/>','info'); //最高权限角色不允许修改
						return;
					} else if ($(objsChecked[i]).val() == '${session.loginUserObj.id}'){
						$.messager.alert('<s:text name="common_msg_info"/>','无法修改自己','info'); //最高权限角色不允许修改
						  return;
					} 
				} 
    	
    	var str=$(objsChecked[0]).val();
    	
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_update"/>',
			content:'<iframe id="myframe" src=pim_sys-user!toSysUserObjUpdate.action?id='+str+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:530,
			panelHeight:430
		});
	} 
	
	//删除
	function deleteObjs(){
		var objsChecked=$("input[name='checkboxitem']:checked");
		if(objsChecked.length<=0){
			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
    		return;
    	}else{
			for(var i=0;i<objsChecked.length;i++){
				if($(objsChecked[i]).val() == "1"){
					$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="sysauth_sysuser_msg_noupdate"/>','info'); //最高权限角色不允许修改
					return;
				} else if ($(objsChecked[i]).val() == '${session.loginUserObj.id}'){
					$.messager.alert('<s:text name="common_msg_info"/>','无法删除自己','info'); //最高权限角色不允许修改
				  return;
			  }
			}
		}
		var _msg='<s:text name="common_msg_confirmdelete"/>';
		$.messager.confirm2('<s:text name="common_msg_info"/>', _msg, function(){
           	var ids_user=getIdFieldsOfChecked();	
           	$.post("pim_sys-user!deleteSysUserList.action",{ids_user:ids_user},function(data){ 
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
	
	//角色分配
	function openRoleAssignWin(){
		var objsChecked=$("input[name='checkboxitem']:checked");
    	if(objsChecked.length<=0){
    		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
    		return;
    	}
    	
    	for(var i=0;i<objsChecked.length;i++){
			if($(objsChecked[i]).val()=="1"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="sysauth_sysrole_msg_noupdate"/>','info'); //最高权限角色不允许修改
				return;
			}
		}
    	var ids_user=getIdFieldsOfChecked();
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_roleAssign"/>',
			content:'<iframe id="myframe" src=pim_sys-user!toSysRoleAssign.action?ids_user='+ids_user+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:280,
			panelHeight:340
		});
	}
	
	//弹出特例资源分配页面
	function openSpResAssignWin(obj){
		var objsChecked=$("input[name='checkboxitem']:checked");
		if(objsChecked.length>=1){
			for(var i=0;i<objsChecked.length;i++){
				if($(objsChecked[i]).val()=="1"){
					$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="sysauth_sysuser_msg_noupdate"/>','info'); //最高权限角色不允许修改
					return;
				}
			}
			
			$(obj).attr("target","_blank");
			$(obj).attr("href","pim_sys-user!toSpResAssign.action");
		}else{
			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info'); //请选择数据记录
		}
	}	
	
	//初始数据导入
	function initimportObjs(){
		$("#inputWin").window({
			open : true,
			headline:'<s:text name="common_action_initimport"/>',
			content:'<iframe id="myframe" src=pim_sys-user!toSysUserInitimport.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:340
		});
	}
	
	//导出
    function expObjs(exportFileType){
    	//导出操作
    	var logid=$("#logid").val();
    	var orgidt=$("#orgidt").val();
    	var stat=$("#stat li.option_selected").attr("vl");
    	
    	//监控导出状态
    	monitorExportStatus('pim_sys-user!monitorExportStatus.action');
    	$.post("pim_sys-user!findSysUserCount.action?exportFileType="+exportFileType+"&logid="+logid
				+"&orgidt="+orgidt+"&stat="+stat,{},function(data){ 
    		//判断数量是否超限
			if(data.exportStatus=="overrun"){
    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_over"/>',info); //导出数量超限
    			return;
			}
    		//导出
    		window.location.href = "pim_sys-user!exportSysUserList.action?exportFileType="+exportFileType+"&logid="+encodeURIComponent(logid)
				+"&orgidt="+encodeURIComponent(orgidt)+"&stat="+stat;
        },"json"); 
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
	
	function resetPwd(){
		var objsChecked=$("input[name='checkboxitem']:checked");
   	if(objsChecked.length<=0){
   		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_noselect"/>','info');//没有选择记录
   		return;
   	}
   	if(objsChecked.length>1){
   		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_singleselect"/>','info');//只能选择一条记录
   		return;
   	}
   	
    for(var i=0;i<objsChecked.length;i++){
      //1.如果是admin用户不可以修改（my用户除外）
			if($(objsChecked[i]).val()=="1" && "${loginUserObj.logid}" != "my"){
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="sysauth_sysrole_msg_noupdate"/>','info'); //最高权限角色不允许修改
				return;
			} else if ($(objsChecked[i]).val() == '${session.loginUserObj.id}'){
				$.messager.alert('<s:text name="common_msg_info"/>','无法重置自己','info'); //最高权限角色不允许修改
				  return;
			} 
		} 
   	
   	var str=$(objsChecked[0]).val();
   	var _msg='<s:text name="common_msg_confirmresetpwd"/>';
		$.messager.confirm2('<s:text name="common_msg_info"/>', _msg, function(){
     	var ids_user=getIdFieldsOfChecked().split(',')[0];	
     	$.post("pim_sys-user!resetUserPwd.action",{id:ids_user},function(data){ 
    		if(data.result=="succ"){
    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info');
			  }else if(data.result=="fail"){
				  $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>'); //操作失败
			  }
      },"json");
    });
	}
</script>
</head>
<body style="height:900px;">

	<div class="myui-template-top-location"></div>

	<div class="myui-template-condition">
		<ul>
			<li class="desc"><s:text name="sysauth_sysuser" />：</li>
			<li><input type="text" id="logid" name="logid"
				title='<s:text name="sysauth_sysuser_msg_logidnam"/>' /></li>
			<li class="desc"><s:text name="org" />：</li>
			<li><input type="text" id="orgidt" name="orgidt"
				title='<s:text name="common_msg_fuzzy_query"/>' /></li>
		</ul>
	</div>

	<div class="myui-template-condition">
		<ul>
			<li class="desc" style="width:60px;"><s:text
					name="sysauth_sysuser_stat" />：</li>
			<li>
				<ul class="seltile" id="stat">
					<li class="option" vl=""><s:text
							name="sysauth_sysuser_stat_all" />
					</li>
					<li class="option_selected" vl="1"><s:text
							name="sysauth_sysuser_stat_valid" />
					</li>
					<li class="option" vl="0"><s:text
							name="sysauth_sysuser_stat_invalid" />
					</li>
					<li class="option" vl="2"><s:text
							name="sysauth_sysuser_stat_lck" />
					</li>
				</ul></li>
		</ul>
	</div>
	
	<div class="myui-template-condition-hide" showcnt='1'>
	</div>

	<div class="myui-template-operating">
		<div class="baseop">
			<ul>
				<li><a href="javascript:void(0);" onclick="cx(1)"
					class="myui-button-query-main" actionCode="ACTION_PIM_USER_SEL"><s:text
							name="common_action_select" />
				</a>
				</li>
				<li><a href="javascript:void(0);" onclick="openInputWin()"
					class="myui-button-query" actionCode="ACTION_PIM_USER_SAV"><s:text
							name="common_action_add" />
				</a>
				</li>
				<li><a href="javascript:void(0);" onclick="openUptWin()"
					class="myui-button-query" actionCode="ACTION_PIM_USER_UPT"><s:text
							name="common_action_update" />
				</a>
				</li>
				<li><a href="javascript:void(0);" onclick="deleteObjs()"
					class="myui-button-query" actionCode="ACTION_PIM_USER_DEL"><s:text
							name="common_action_delete" />
				</a>
				</li>
				<li><a href="javascript:void(0);" onclick="openRoleAssignWin()"
					class="myui-button-query" actionCode="ACTION_PIM_USER_ASSIGN"><s:text
							name="common_action_roleAssign" />
				</a>
				</li>
				<li><a href="javascript:void(0);" onclick="resetPwd()" class="myui-button-query" actionCode="ACTION_PIM_USER_RESETPWD"><s:text name="common_action_resetPasswd"/></a></li>
				<li><a href="javascript:void(0);"
					onclick="openSpResAssignWin(this)" class="myui-button-query-big"
					actionCode="ACTION_PIM_USER_SPRES_ASSIGN"><s:text
							name="common_action_spResAssign" />
				</a>
				</li>
			</ul>
		</div>
		<div class="tableop">
			<ul>
				<!-- li><a href="javascript:void(0);" onclick="initimportObjs();"
					actionCode="ACTION_PIM_USER_INITIMPORT" style="display:none;"><s:text
							name="common_action_initimport" />
				</a>
				</li -->
				<li><a href="javascript:void(0);"
					onclick="expObjs('excel2003');" actionCode="ACTION_PIM_USER_EXP"
					style="display:none;"><s:text name="common_action_export" />
				</a>
				</li>
			</ul>
		</div>
	</div>

	<div class="myui-datagrid">
		<table>
			<tr>
				<th><input type="checkbox" name="all"
					onclick="checkAll('checkboxitem')" />
				</th>
				<th><s:text name="sysauth_sysuser_logid" />
				</th>
				<th><s:text name="sysauth_sysuser_nam" />
				</th>
				<th><s:text name="org_orgidt" />
				</th>
				<th><s:text name="org_orgnam" />
				</th>
				<th><s:text name="sysauth_sysuser_stat" />
				</th>
				<s:iterator value="%{#request.sysUserColConfigList}" id="o">
					<s:if test='#o.isExtend=="1" || #o.isExtend=="2"'>
						<th><s:if test='#session.i18nDefault=="en"'>
							${o.colnamEn}
						</s:if>
							<s:else>
							${o.colnamCh}
						</s:else></th>
					</s:if>
				</s:iterator>
			</tr>
			<tbody id="databody">

			</tbody>
		</table>

	</div>

	<div class="myui-datagrid-pagination"></div>

	<div id="inputWin"></div>

</body>

</html>

