<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@ include file="/mybi/common/include/js.jsp" %>
	<script type="text/javascript" src="${ctx}/mybi/common/script/datagrid-detailview.js"></script>
	<script type="text/javascript">
		<!--
		    var data_grid;
		    $(document).ready(function(){
		    	//动作权限过滤
		    	//actionAuthFilter('${sysActionListForSysMenuWithAuth}');
		    	
		        data_grid = $('#data_grid');
		       	findPager(1);
		    });
		    
		  	//分页查询
		    function findPager(_pageNumber){
		        var _queryParams = {
		        		firstLvlMenuId:$.trim($("#firstLvlMenuId",parent.document).val())
				    };
		        data_grid.datagrid({
		      	    url: 'pim_sys-log-analysis!findSysLogAlsPager.action',
		      	  	pagination:true,
		      	  	loadMsg:'',
		      	    pageNumber: _pageNumber,
		      	    queryParams: _queryParams,
		      	    view: detailview,
		      	  	singleSelect:true,
		    		emptyMsg: '<s:text name="common_msg_nodata"/>',  //no records found
		    		rowStyler: function(index,row){
	                    return 'background-color:#E5EFFF;color:#000;';
	                },
		    		detailFormatter:function(index,row){
	                    return '<div style="padding:1px 1px 5px 30px"><table class="ddv"></table></div>';
	                },
	                onClickCell:function(index,field,value){
		                if (field == 'menuNam'){
		                	var id = $(this).datagrid('getRows')[index].menuId;
			                window.location.href = '${ctx}/pim_sys-log-analysis!toDatachart.action?firstLvlMenuId='+id+'&menuName='+value;
			            }
					},
	                onExpandRow: function(index,row){
	                    var ddv = $(this).datagrid('getRowDetail',index).find('table.ddv');
	                    var subMenuNam = $.trim($("#subMenuNam",parent.document).val());
	                    ddv.datagrid({
	                        url:encodeURI('pim_sys-log-analysis!findSysLogAlsSubmenuPager.action?firstLvlMenuId='+row.menuId+'&subMenuNam='+subMenuNam),
	                        pagination:true,
	                        singleSelect:true,
	                        pageSize:${pagesize},
	                        pageList:[${pagelist}],
	                        rownumbers:true,
	                        pageNumber: 1,
	                        loadMsg:'',
	                        fitColumns:true,
	                        height:'auto',
	                        columns:[[
	                            {field:'menuNam',title:'<s:text name="logals_menuNam"/>',width:100},
	                            {field:'ndaysView',title:'<s:text name="logals_ndaysView"/>',width:100,halign:'center',align:'right'},
	                            {field:'ndaysCuscnt',title:'<s:text name="logals_ndaysCuscnt"/>',width:100,halign:'center',align:'right'},
	                            {field:'cumulView',title:'<s:text name="logals_cumulView"/>',width:100,halign:'center',align:'right'},
	                            {field:'cumulCuscnt',title:'<s:text name="logals_cumulCuscnt"/>',width:100,halign:'center',align:'right'},
	                        ]],
							onClickCell:function(index,field,value){
								if (field == 'menuNam'){
									var id = $(this).datagrid('getRows')[index].menuId;
		    		                window.location.href = '${ctx}/pim_sys-log-analysis!toDatachart.action?subMenuId='+id+'&menuName='+value;
								}
							},
	                        onResize:function(){
	                            $('#data_grid').datagrid('fixDetailRowHeight',index);
	                        },
	                        onBeforeLoad:function(){
	    		    			$.messager.progress({text:''});
	    		    		},
	                        onLoadSuccess:function(){
	                        	$.messager.progress('close');
	                            setTimeout(function(){
	                                $('#data_grid').datagrid('fixDetailRowHeight',index);
	                            },0);
	                        },
	    		    		onLoadError:function(){
	    		    			$.messager.progress('close');
	    		    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_serverbusy"/>','error');
	    		    		}
	                    });
	                    $('#data_grid').datagrid('fixDetailRowHeight',index);
	                },
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

		// -->
	</script>
</head>
<body style="margin:0px 0px;margin:0px 0px;overflow:hidden;">
<div class="easyui-layout" data-options="fit:true">
    <div title='<s:text name="logals_datalist"/>' data-options="region:'center'">
        <table id="data_grid"
            data-options="fit:true,border:0,rownumbers:false,striped:true,pagination:true,pageSize:${pagesize},pageList:[${pagelist}]">
            
            <thead>
                <tr>
                	<th data-options="field:'menuNam',width:180,halign:'center'"><s:text name="logals_menuNam"/></th>
                    <th data-options="field:'ndaysView',width:150,halign:'center'"><s:text name="logals_ndaysView"/></th>
                    <th data-options="field:'ndaysCuscnt',width:150,halign:'center'"><s:text name="logals_ndaysCuscnt"/></th>
                    <th data-options="field:'cumulView',width:150,halign:'center'"><s:text name="logals_cumulView"/></th>
                    <th data-options="field:'cumulCuscnt',width:150,halign:'center'"><s:text name="logals_cumulCuscnt"/></th>
                </tr>
            </thead>
	    </table>     
    </div>
</div>

</body>
</html>	