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
	<link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
	<script>
	
	var commonParam;
	$(function(){
		$.post("${ctx}/query_online!getCommonParam.action", {},function(v_paramdata){
			commonParam = JSON.parse(v_paramdata);
			initQuery();
		});
	})
	
	function initQuery(){
		var queryId = getUrlParam("id");
		if(!queryId){
			loadOnlineQuery(window.parent.dsJson);
			initTableJoinBtn();
		}else{
			$.post("${ctx}/query_online!getQuery.action",{"query_main.id":queryId},function(data){ 
	    		
				if(data.length>0){
					var queryObj = data[0];
					$('.myui-datagrid2').attr('queryname', queryObj.name);
					$('.myui-datagrid2').attr('queryid', queryObj.id);
					if(getUrlParam("edit")) {
						$('.myui-datagrid2').attr('edit', 'true');
					}
					
					var dsstrJson = JSON.parse(queryObj.dsstr);
					var dgcaseJson = JSON.parse(queryObj.dgcasestr);
					loadOnlineQuery(JSON.parse(queryObj.dsstr), dgcaseJson);
					
					var linkParamArr = new Array();
					//如果通过url传递参数则直接添加到列过滤filterColumnList
					for(var i=0; i< dsstrJson.cols.length; i++) {
						var v_colobj =  dsstrJson.cols[i];
						var v_parval = getUrlParam(v_colobj.colname_ognl);
						if(v_parval) {
							linkParamArr.push({
								colname_ognl : v_colobj.colname_ognl,
								colname : v_colobj.colname,
								colval  : v_parval
							});
							
							if(dgcaseJson.filterColumnList) {
								dgcaseJson.filterColumnList = dgcaseJson.filterColumnList + "," + v_colobj.colname + "###=###"+ v_parval +"###" + v_colobj.coldesc
							} else {
								dgcaseJson.filterColumnList = v_colobj.colname + "###=###"+ v_parval +"###" + v_colobj.coldesc;
							}
						}
					}
					
					var v_linkhis = parent.$('body').data("linkhis");
					/**
					 * 如果是钻取则自动清空参数
					 */
          if(getUrlParam("islink") && dgcaseJson.paramColumnList) {
          	var v_json_paramColumnList = JSON.parse(dgcaseJson.paramColumnList);
          	var v_json_paramColumnarr = [];
          	for (var j=0; j<v_json_paramColumnList.length; j++) {
          		var v_json_paramColumn = v_json_paramColumnList[j];
          		var hasLinkParam = false;
         			for (var k=0; k<linkParamArr.length; k++) {
         				if (linkParamArr[k].colname == v_json_paramColumn.name || linkParamArr[k].colname_ognl == v_json_paramColumn.name) {
         					v_json_paramColumn.defaultVal = linkParamArr[k].colval;
                	v_json_paramColumn.value = linkParamArr[k].colval;
                	hasLinkParam = true;
                	break;
         				}
         			}
          		if(!v_json_paramColumn.sqldefval && !hasLinkParam) {
              	  v_json_paramColumn.defaultVal = "";
              	  v_json_paramColumn.value = "";
          		}
           	  v_json_paramColumnarr.push(v_json_paramColumn);
          	}
          	dgcaseJson.paramColumnList = JSON.stringify(v_json_paramColumnarr);
          }
					
					if(getUrlParam("linkidx") != null) {
						var v_linkidx = getUrlParam("linkidx");
						var v_tmp_linkobj = v_linkhis[v_linkidx];
						dgcaseJson =  JSON.parse(v_tmp_linkobj.querycase);
					//	v_linkhis.splice(v_linkidx);
						var v_newlinkhis = [];
						for (var k=0; k < v_linkidx; k++) {
							v_newlinkhis.push(v_linkhis[k]);
						}
						v_linkhis = v_newlinkhis;
						if(v_linkhis.length>0) {
							parent.$('body').data("linkhis", v_linkhis);
						} else {
							 parent.$('body').removeData("linkhis");
							 v_linkhis = null;
						}
					}
					loadcase(JSON.stringify(dgcaseJson));
					initTableJoinBtn();

					//是否钻取
					 if((getUrlParam("islink") == 'true' || getUrlParam("linkidx") != null) && typeof(v_linkhis) != "undefined" && v_linkhis != null) {
						 createLinkHistory(v_linkhis);
					 } else {
						 parent.$('body').removeData("linkhis");
					 }
					
					/*if(dsstrJson.opts.snapshot)
						initSnapshotBtn();*/
				}else{
					$.messager.alert('<s:text name="common_msg_info"/>','数据库中没有相关查询配置'); //操作失败
				}
	        },"json");
		}
	}
	
	function createLinkHistory(p_linkhis){
		var dgdata = $('.myui-datagrid2').datagrid2('data');
		var panel = dgdata.panel;
		var d_linkdiv = $('<div class="link"><div class="item"><ul><li>历史：</li></ul></div></div>').prependTo(panel.children('.datagrid-header'));
		for (var i=0; i<p_linkhis.length; i++) {
			var p_linkObj = p_linkhis[i];
			if(i>0) {
				$(d_linkdiv).find('ul').append("<li>&nbsp;&nbsp;<i class='fa fa-chevron-right fa-la'>&nbsp;&nbsp;</i></li>");
			}
		    
			var d_query = $("<li class='query' idx='"+i+"'>" + p_linkObj.queryname + "</li>").appendTo($(d_linkdiv).find('ul'));
			$(d_query).click(function(){
				
				var v_backidx = $(this).attr('idx');
				var v_tmp_linkobj = parent.$('body').data("linkhis")[v_backidx];
				
				var v_paramarr = [];
				v_paramarr.push("?linkidx="+v_backidx+"&id=" + v_tmp_linkobj.queryid);
				if(v_tmp_linkobj.edit == 'true') {
					v_paramarr.push("edit=true");
				}
				var v_queryaction =  'query_online!query.action';
				if(window.location.href.indexOf('query_online!queryfun.action') >=0) {
					v_queryaction =  'query_online!queryfun.action';
				}
				window.location.href = '${ctx}/' + v_queryaction + v_paramarr.join('&');
			})
		}
	}
	
	function reloadQuery() {
		var dsstrJson = window.parent.dsJson;
		var dgcaseJson = getcase();
		loadOnlineQuery(dsstrJson);
		loadcase(dgcaseJson);
		initTableJoinBtn();
		/*if(dsstrJson.opts.snapshot)
			initSnapshotBtn();*/
		
		var v_linkhis = parent.$('body').data("linkhis");
		//是否钻取
		 if((getUrlParam("islink") == 'true' || getUrlParam("linkidx") != null) && typeof(v_linkhis) != "undefined" && v_linkhis != null) {
			 createLinkHistory(v_linkhis);
		 }
	}
	
	function initTableJoinBtn(){
		var edit = getUrlParam("edit");
		//如果在编辑模式下，并且为多表则显示表关联
		if(edit){
			var opts = $('.myui-datagrid2').datagrid2('options');
			var v_tabArray = [];
	        for(var str in JSON.parse(opts.queryParams.tableColumns))
	        {
	        	v_tabArray.push(str);
	        }
	        
	        //如果超过两张表显示表关联
	        if(v_tabArray.length > 1){
    			var d_tabjoin_btn = $('<a href="javascript:void(0);">表关联</a>');
    			
    			// 设置点击事件
    			$(d_tabjoin_btn).bind("click", function(){
	        		$("#showTableJoinWin").window({
	        			open : true,
	        			headline:'表关联',
	        			param : { "joinTabs" :  v_tabArray,
	    				      "joinCols" : opts.queryParams.tableJoin},
	        			content:'<iframe id="myframe" src="${ctx}/query_online!toTableJoin.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
	        			panelWidth:700,
	        			panelHeight:460
	        		}); 
    			});
    			
    			$('.myui-datagrid2').datagrid2('appendTableOperate', $(d_tabjoin_btn));
    			
    			//添加选择列窗口
    			$("body").append('<div id="showTableJoinWin"></div>');
	        	
	        }
		}
	}
	
/*	function initSnapshotBtn(){
	   var opts = $('.myui-datagrid2').datagrid2('options');
 	   var d_snapshot_btn = $('<a href="javascript:void(0);">快照</a>');
 			
 		// 设置点击事件
 		$(d_snapshot_btn).bind("click", function(){
	      	$("#showSnapshotWin").window({
	      		open : true,
	      		headline:'快照（点击红色按钮可保存当前查询快照）',
	      		param : { "queryid" :  getUrlParam("id")},
	      		content:'<iframe id="myframe" src="${ctx}/query_online!toSnapshot.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
	      		panelWidth:550,
	      		panelHeight:370
	      	}); 
 		});
 			
 		$('.myui-datagrid2').datagrid2('appendTableOperate', $(d_snapshot_btn));
 			
 		//添加选择列窗口
 		$("body").append('<div id="showSnapshotWin"></div>');
	        	
	}*/
	
	//配置页面加载query
	function loadOnlineQuery(p_dsJson, p_dsCaseJson) {
		var edit = getUrlParam("edit");
		var queryId = getUrlParam("id");
		$('#querylist').empty();
			
		var p_dsJson_cols = p_dsJson.cols;
		var p_dsJson_tableJoin = p_dsJson.tableJoin;
		var p_dsJson_opts = p_dsJson.opts;
		
		if(edit){
			  
				//未添加导出，导出还存在问题
				$('#querylist').attr("myui-options", "url:'${ctx}/query_online!getDatagridData.action',multiSort:true,isAutoBuild:false,showParamOperate:true, showEditStyle:true");
				$('#querylist').attr("width", "900px");
				$('#querylist').attr("height", "350px");
				if(!queryId){
					$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",showColumn:true");
					$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",showFilters:true");
					$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",exportUrl:'${ctx}/query_online!queryExport.action',exportFileName:'导出列表'");
				}else{
					if(p_dsJson_opts){
						if(p_dsJson_opts.width)
							$('#querylist').attr("width", p_dsJson_opts.width);
						if(p_dsJson_opts.height)
							$('#querylist').attr("height", p_dsJson_opts.height);
						if(p_dsJson_opts.showColumn)
							$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",showColumn:true");
						if(p_dsJson_opts.showFilters)
							$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",showFilters:true");
						/*	if(p_dsJson_opts.isPager == false)
						$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",isPager:false");*/
					    if(p_dsJson_opts.pagestyle)
						    $('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",pagestyle:'" + p_dsJson_opts.pagestyle+"'");
						if(p_dsJson_opts.paramLineCnt)
							$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",paramLineCnt:"+p_dsJson_opts.paramLineCnt);
						if(p_dsJson_opts.snapshot)
							$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",snapshot:true, snapshot_queryid:'" + getQueryid() + "', snapshot_url:'query_online!buildSnapshot.action'");
						if(p_dsJson_opts.showExport){
							$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",exportUrl:'${ctx}/query_online!queryExport.action',exportFileName:'"+p_dsJson_opts.exportFileName+"'");
							if(p_dsJson_opts.selectMaxExportCnt && p_dsJson_opts.selectMaxExportCnt > 0){
								$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",selectMaxExportCnt:'"+p_dsJson_opts.selectMaxExportCnt+"'");
							}
							if(p_dsJson_opts.exportpass && p_dsJson_opts.exportpass != ''){
								$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",exportpass:'"+p_dsJson_opts.exportpass+"'");
							}
						}
					}
				}
			}else{
				$('#querylist').attr("myui-options", "url:'${ctx}/query_online!getDatagridData.action'");
				$('#querylist').attr("width", "1196px");
				$('#querylist').attr("height", "350px");
				if(p_dsJson_opts){
					if(p_dsJson_opts.width)
						$('#querylist').attr("width", p_dsJson_opts.width);
					if(p_dsJson_opts.height)
						$('#querylist').attr("height", p_dsJson_opts.height);
					if(p_dsJson_opts.showColumn)
						$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",showColumn:true");
					if(p_dsJson_opts.showFilters)
						$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",showFilters:true");
				/*	if(p_dsJson_opts.isPager == false)
						$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",isPager:false");*/
					if(p_dsJson_opts.pagestyle)
						$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",pagestyle:'" + p_dsJson_opts.pagestyle+"'");
					if(p_dsJson_opts.paramLineCnt)
						$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",paramLineCnt:"+p_dsJson_opts.paramLineCnt);
					if(p_dsJson_opts.snapshot)
						$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",snapshot:true, snapshot_queryid:'" + getQueryid() + "', snapshot_url:'query_online!buildSnapshot.action'");
					if(p_dsJson_opts.showExport){
						$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",exportUrl:'${ctx}/query_online!queryExport.action',exportFileName:'"+p_dsJson_opts.exportFileName+"'");
						if(p_dsJson_opts.selectMaxExportCnt && p_dsJson_opts.selectMaxExportCnt > 0){
							$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",selectMaxExportCnt:'"+p_dsJson_opts.selectMaxExportCnt+"'");
						}
						if(p_dsJson_opts.exportpass && p_dsJson_opts.exportpass != ''){
							$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",exportpass:'"+p_dsJson_opts.exportpass+"'");
						}
					}
				}
			}
		
		    if(p_dsJson_opts.pagesize) {
		    	$('#querylist').attr("myui-options", $('#querylist').attr("myui-options") + ",pagesize:" + p_dsJson_opts.pagesize);
		    }
		
			if(getUrlParam("width") != null) {
				$('.myui-datagrid2').attr("width", getUrlParam("width"));
			}
			
			if(getUrlParam("height") != null) {
				$('.myui-datagrid2').attr("height", getUrlParam("height"));
			}
			
			var tabobj = new Object();
			var thead = $('<thead></thead>').appendTo($('#querylist'));
			var tr = $('<tr></tr>').appendTo($(thead));
			
			for(var i=0; i<p_dsJson_cols.length; i++){
				var v_dsObj = p_dsJson_cols[i];
				
				var tabobj_key = v_dsObj.dsid;
				if(tabobj[tabobj_key]){
					tabobj[tabobj_key] = tabobj[tabobj_key] + ',' + v_dsObj.colname + '@@@' + v_dsObj.colname_ognl;
				}else{
					tabobj[tabobj_key] = v_dsObj.colname + '@@@' + v_dsObj.colname_ognl;
				}
				var v_datatype = "";
				if(v_dsObj.datatype){
					v_datatype = ",datatype:'"+v_dsObj.datatype+"'"
				}
				
				var v_width = ",width:'150'";
				if(v_dsObj.width && v_dsObj.autowidth == false){
					v_width = ",width:'"+v_dsObj.width+"'"
				}
				
				var v_autowidth = ",autowidth:true";
				if(v_dsObj.autowidth == false){
					v_autowidth = ",autowidth:false"
				}
				
				var v_dataformat = "";
				if(v_dsObj.dataformat){
					v_dataformat = ",dataformat:'"+v_dsObj.dataformat+"'"
				}
				
				var v_align = "";
				if(v_dsObj.align){
					v_align = ",align:'"+v_dsObj.align+"'"
				}
				
				$(tr).append('<th myui-options="field:\''+v_dsObj.colname+'\',sortable:true' + v_width  + v_align + v_datatype + v_autowidth + v_dataformat + '">'+v_dsObj.coldesc+'</th>');
			}
			var datasetParam = {
				tableColumns: JSON.stringify(tabobj),
				tableJoin :　p_dsJson_tableJoin,
				queryId : queryId,
				commonParam : commonParam
			};
			
			if( p_dsJson.paramColumnList && p_dsJson.paramColumnList.length > 0) {
				datasetParam.paramColumnList = JSON.stringify(p_dsJson.paramColumnList);
			}

			$('#querylist').datagrid2('loadDatagrid', datasetParam);
			if(p_dsJson.paramColumnList && p_dsJson.paramColumnList.length > 0) {
				$('.myui-datagrid2').datagrid2('options').paramColumnList = JSON.stringify(p_dsJson.paramColumnList);
				var v_con_param = {
					param : p_dsJson.paramColumnList
				}
				if (getUrlParam("islink") == 'true' || getUrlParam("linkidx") != null) {
					v_con_param.isReload = false;
				}
				
				$('.myui-datagrid2').datagrid2('createCondition', v_con_param);
			}
			
		//setAutoHei();
		//alert(p_dsJson_opts.pagesize  + '----' + );
		}
	
		function updateTableJoin(p_tabJoinObj){
			if(p_tabJoinObj.tableJoin){
				var opts = $('.myui-datagrid2').datagrid2('options');
				if (window.parent.dsJson) {
					$.extend(window.parent.dsJson, p_tabJoinObj);
				}
		      $.extend(opts.queryParams, p_tabJoinObj);
				$('.myui-datagrid2').datagrid2('reloadData', true);
			}
		}
		
		function getcase(){
			return $('.myui-datagrid2').datagrid2('getCase');
		}
		
		function getQueryid(){
			return getUrlParam("id");
		}
		
		function loadcase(p_caseStr){
			$('.myui-datagrid2').datagrid2('loadCase',p_caseStr);
		}
		
		function loadCondition(p_paraList){
			$('.myui-datagrid2').datagrid2('createCondition', p_paraList);
		}
		
		function setAutoHei(){
			$('body').height($('div.myui-datagrid2').height() + 120);
		    window.parent.$('#queryFrame').height($('div.myui-datagrid2').height() + 120);
		}
	</script>
<style>
.myui-datagrid2{margin-top: 20px}
</style>
</head>
<body>
<div id="orgControl"></div>
	<table class="myui-datagrid2" id="querylist"></table>
</body>
</html>