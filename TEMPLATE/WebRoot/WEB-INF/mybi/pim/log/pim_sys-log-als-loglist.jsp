<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@ include file="/mybi/common/include/js.jsp" %>
	<script type="text/javascript">
		<!--
		    var data_grid;
		    $(document).ready(function(){
		     	data_grid = $('#data_grid');
		        firstLvlMenuId="${firstLvlMenuId}";
		        subMenuId = "${subMenuId}";
		        selType = "${selType}";
		        temp = "${temp}";
		        findPager(1);
		    });

		  	//分页查询
		    function findPager(_pageNumber){
		        var _queryParams = {
		        		               firstLvlMenuId:firstLvlMenuId,
		        		               subMenuId:subMenuId,
		        		               selType:selType,
		        		               temp:temp
		                           };
		        data_grid.datagrid({
		      	    url: 'pim_sys-log-analysis!findMenuSysLogPager.action',
		      	  	pagination:true,
		      	  	loadMsg:'...',
		      		singleSelect:true,
		      	    pageNumber: _pageNumber,
		      	    queryParams: _queryParams,
		      	    view: myview,
		    		emptyMsg: '<s:text name="common_msg_nodata"/>',  //no records found
		    		onBeforeLoad:function(){
		    			$.messager.progress({text:''});
		    		},
		    		onLoadSuccess:function(){
		    			$.messager.progress('close');
		    		},
		    		onLoadError:function(){
		    			$.messager.progress('close');
		    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_serverbusy"/>','error');
		    		}
		      	});
		    }

		    function forwardTo(id){
				if (id == 1){
					window.location.href="${ctx}/pim_sys-log-analysis!toDatalist.action";	
				}else if(id == 2){
					var subMenuId = "${subMenuId}";
					var firstLvlMenuId = "${firstLvlMenuId}";
					var menuName = "${menuName}";
					if (subMenuId != '') {
						window.location.href = '${ctx}/pim_sys-log-analysis!toDatachart.action?subMenuId='+subMenuId+'&menuName='+menuName;
					}
					if (firstLvlMenuId != ''){
						window.location.href = '${ctx}/pim_sys-log-analysis!toDatachart.action?firstLvlMenuId='+firstLvlMenuId+'&menuName='+menuName;
					}
				}
			}
		// -->
	</script>
</head>
<body style="margin:0px 0px;margin:0px 0px;overflow:hidden;">
<div class="easyui-layout" data-options="fit:true">
    <div title="<a href='#' style='color:#0E2D5F;' onclick='forwardTo(1);'><s:text name='logals_datalist'/></a>>><a href='#' style='color:#0E2D5F;' onclick='forwardTo(2);'><s:text name='logals_datachart'/></a>>><s:text name='logals_loglist'/>" data-options="region:'center'">
        <table id="data_grid"
            data-options="fit:true,border:0,rownumbers:true,striped:true,pagination:true,pageSize:${pagesize},pageList:[${pagelist}]">
            
            <thead>
                <tr>
                	<th data-options="field:'oprDate',width:100,halign:'center'"><s:text name="logals_oprDate"/></th>
                    <th data-options="field:'userLogid',width:120,halign:'center'"><s:text name="logals_userLogid"/></th>
                    <th data-options="field:'userNam',width:150,halign:'center'"><s:text name="logals_userNam"/></th>
                    <th data-options="field:'menuNam',width:250,halign:'center'"><s:text name="logals_menuNam"/></th>
                    <th data-options="field:'actionNam',width:100,halign:'center'"><s:text name="logals_actionNam"/></th>
                    <th data-options="field:'ip',width:100,halign:'center'"><s:text name="logals_ip"/></th>
                </tr>
            </thead>
	    </table>     
    </div>
</div>

</body>
</html>	