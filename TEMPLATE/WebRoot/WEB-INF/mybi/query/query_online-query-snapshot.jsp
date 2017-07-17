<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	
	//窗口参数
	var v_winParam;
	$(function(){
		var v_opts = parent.$('#showSnapshotWin').window('options');
		v_winParam  = v_opts.param;
		$("#type").combo({
		    mode : "local",
		    data : [{text:"excel",value:"xlsx"},{text:"txt文本",value:"txt"},{text:"csv格式",value:"csv"}],
		    panelHeight : 90
		});
		loadFileArea();
	});
	
	function loadFileArea() {
		$('.folderArea').empty();
		$.post('${ctx}/pim_snapshot!getSnapshotList.action', {"snapshot.queryid":parent.window.getUrlParam("id")}, function(data){
			var jsondata = JSON.parse(data);
			 $(jsondata).each(function(idx, obj) {
				 var jsonobjparam = JSON.parse(obj.param);
				 var d_li = $('<li></li>').appendTo($('.folderArea'));
				 $(d_li).attr('id', obj.id);
				 $(d_li).attr('name', obj.name);
				 $(d_li).attr('filetype', jsonobjparam.exportFileType);
				 $(d_li).attr('filename', obj.filler1);
				 var v_type = '';
				 if(jsonobjparam.exportFileType == 'txt') {
					 v_type = 'txt';
				 } else {
					 v_type = 'excel';
				 }
				 $(d_li).append($('<div><img class="addFileBtn" src="${ctx}/mybi/query/themes/default/images/query-'+v_type+'.png"></div>'));
				 $(d_li).append($('<div class="filename">'+jsonobjparam.exportFileName +'</div>'));
				 if(obj.state == 2) {
					 $(d_li).remove();
				 } else if (obj.state == 0 || obj.state == 1) {
					 $(d_li).addClass('folderAreaRun');
					 var dv_del = $('<div class="runsnap">正在加工..</div>').appendTo($(d_li));
				 } else {
					 $(d_li).find('.addFileBtn').parent().click(function() {
							window.location.href= "${ctx}/pim_snapshot!snapshotFileDownload.action?exportFileName=" + $(this).parent().attr('name') + "&exportFileType=" + $(this).parent().attr('filetype') + "&snapshot.filler1=" + $(this).parent().attr('filename');
						 })
						 
					 $(d_li).mouseenter(function(e){
							$(this).addClass('folderAreafocus');
							var dv_del = $('<div class="delsnap"><img class="delFolderBtn" src="${ctx}/mybi/common/themes/${apptheme}/images/del.png"></img></div>').appendTo($(this));
		        			$(dv_del).mouseover(function(){
		       				  $(this).find('.delFolderBtn').attr('src','${ctx}/mybi/common/themes/${apptheme}/images/del_sel.png');
		       				});
		        			$(dv_del).mouseout(function(){
		         			  $(this).find('.delFolderBtn').attr('src','${ctx}/mybi/common/themes/${apptheme}/images/del.png');
		         			});
		        			$(dv_del).click(function(){
		        				
		        				var v_delparam = {
		    							"snapshot.id" :  $(this).parent().attr('id'),
		    							"snapshot.filler1" : $(this).parent().attr('filename')
		    					}
		        				$.post('${ctx}/pim_snapshot!deleteQuerySnapshot.action', v_delparam, function(data){
		        					var jsondata = JSON.parse(data);
		        					if(jsondata.result == 'succ'){
		        						$.messager.alert('<s:text name="common_msg_info"/>','删除成功','info', function(){
		        							loadFileArea();
		        						});
		        						
		        					}else{
		        						$.messager.alert('<s:text name="common_msg_info"/>','任务提交失败','error', function(){
		        							clsWin();
		        						});
		        					}
		        				 });
		        			})
						}).mouseleave(function(e){
							$(this).removeClass('folderAreafocus');
							$(this).find('.delsnap').remove();
						});
				 }
				 
				 
				 
			 })
		 });
	}
	 
	 function sbt(){
		 var v_name = $('#name').val();
		 var v_type = $('#type').combo('getValue');
		 if(!v_name){
			 $.messager.alert('<s:text name="common_msg_info"/>','请填写需要保存的快照名称'); //操作失败
			 return false;
		 }
		 var opts = parent.$('.myui-datagrid2').datagrid2('options');
		 var dgdata = parent.$('.myui-datagrid2').datagrid2('data');
		 var queryId = parent.window.getUrlParam("id");
		 
		//设置原有查询参数
	    var param = $.extend({}, opts.queryParams,{
				"showColumnList": opts.showColumnList,
				"mergeColumnList": opts.mergeColumnList,
				"filterColumnList": opts.filterColumnList,
				"paramColumnList" : opts.paramColumnList,
				"custColExpr"     : opts.custColExpr,
				"sort": opts.sort,
				"order": opts.order,
				"exportColumnList" : parent.$('.myui-datagrid2').datagrid2('getVisableColumn'),
				"exportFileName" : v_name,
				"exportFileType" : v_type,
				"totalRecord" : dgdata.data.pager.totalRecord
			});
		var snap_param = {
				"snapshot.queryid" : queryId,
				"snapshot.type" : '1',
				"snapshot.name" : v_name,
				"snapshot.param" : JSON.stringify(param)
		}
		$.extend(param, snap_param);
		 $.post('${ctx}/query_online!buildSnapshot.action', param, function(data){
			 var jsondata = JSON.parse(data);
			if(jsondata.result == 'succ'){
				$.messager.alert('<s:text name="common_msg_info"/>','已经提交快照任务,加工完成后会自动展示在清单中','info', function(){
					loadFileArea();
				});
				
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','任务提交失败','error', function(){
					clsWin();
				});
			}
		 });
	 }
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#showSnapshotWin').window('close');
    }
</script>
<style type="text/css">
.snapdiv{border: 1px solid #DDD;height: 250px;margin-top:10px;width: 530px;}
.item {margin-left: 10px;}
.folderArea li div{text-align: center}
.folderArea li{margin-left: 5px;padding: 5px 5px 0px 5px;width: 50px;cursor: pointer;}
.folderArea li .filename{font-size: 10px;white-space: nowrap;text-overflow:ellipsis;overflow:hidden;}
.folderAreafocus{background-color: #CCC;font-weight: bold;position:relative}
.delsnap{position: absolute;left:45px;top:0;z-index: 400px}
.folderAreaRun{background-color: #666;font-weight: bold;position:relative;cursor: default;}
.runsnap{position: absolute;top:0;z-index: 400px;font-size: 12px;color: #FFF;}
</style>
</head>
<body>
<div id="addTabJoinWin"></div>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
			<div class="item snapdiv">
			 	<ul class="folderArea">
			 	</ul>
			 </div>
			 <div class="item">
				<ul>
					<li>名称：</li>
					<li><input id="name" name="name" style="width:150px" class="myui-text"/></li>
					<li style="margin-left: 20px">类型：</li>
					<li><input id="type" name="type" class="myui-text" style="width:150px" /></li>
					<li style="margin-left: 20px"><a class="myui-button-query-main" href="javascript:void(0);" onclick="sbt()">保存</a></li>
					</ul>
			  </div>
		</form>
	</div>
</div>
</body>
</html>