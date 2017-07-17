<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<script type="text/javascript">
	/*var setting = {
	    view: {
	        dblClickExpand: false,
	        showIcon:true
	    },
	    callback: {
	        onClick: function(e, treeId, treeNode){
	        	$('#menu').comboSD("setText",treeNode.name);
	        	$('#menu').comboSD("closePanel");
	        }
	    }
	};*/
	
	var zTreeObj;
	
	//ztree相关的js
	var setting = {
		view: {
			dblClickExpand: false,
			selectedMulti:false
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		edit:{
			enable:false,
			showRemoveBtn:false,
			showRenameBtn:false,
			drag:{
				isMove:false
			}
		},
		
		callback: {
			onClick: function(e, treeId, treeNode){
	        	$('#menu').comboSD("closePanel");
	        	loadFolderArea(treeNode.id);
    			setcomboSDAttr(treeNode);
	        },
			onCheck: false,
			beforeDrag: false,
			beforeDrop: false
		}
	};
	
	
	
	$(function(){
		$("#menu").comboSD({
		    panelHeight : 200,
		    panelWidth : 300,
		    initPanelContent : function(panelObj) {
		        var html = "<ul id='tree_menu' class='ztree' style='width:170px;overflow:auto;'></ul>";
		        $(panelObj).append(html);
		        
		        $.getJSON("${ctx}/query_online!getQueryTree.action",{"query_main.type":"1"},function(data){
		        	var baseFolder = {
			        		"id"   : "-1",
			        		"pId"  : "",
			        		"name" : "目录",
			        		"key"  : "-1",
			        		"open" : true
			        	};
		        	
		        	data.push(baseFolder);
		        	zTreeObj = $.fn.zTree.init($("#tree_menu"), setting, data);
		        	zTreeObj.expandAll(true);
		        	setcomboSDAttr(baseFolder);
		        	loadFolderArea("-1");
				});
		        
		    } // 初始化panel,自定义
		});
	})
	
	function setcomboSDAttr(p_fobj){
		$('#menu').comboSD("setText", p_fobj.name);
		$('#menu').attr("fid", p_fobj.id);
		$('#menu').attr("fpid", p_fobj.pId);
		$('#menu').attr("fname", p_fobj.name);
	}
	
	function backFolder(){
		var pid = $('#menu').attr("fpid");
		if(pid == ""){
			$.messager.alert('<s:text name="common_msg_info"/>','已经是最高级目录'); //操作失败
			return false;
		}
		if(pid == '-1'){
			var baseFolder = {
	        		id   : '-1',
	        		pId  : '',
	        		name : '目录'
	        	};
			setcomboSDAttr(baseFolder);
			loadFolderArea('-1');
		}else{
			$.getJSON("${ctx}/query_online!getQueryTree.action",{"query_main.id":pid,"query_main.type":"1"},function(data){
				$(data).each(function(index, obj){
					setcomboSDAttr(obj);
					loadFolderArea(obj.id);
				});
			});
		}
	}
	
	function addFolderWin(){
		$("#addFolderWin").window({
			open : true,
			headline:'添加目录',
			content:'<iframe id="addQueryFrame" src="${ctx}/query_homepage!toFolderAdd.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:400,
			panelHeight:250
		});
	}
	
	function loadFolderArea(pid){
		
		$.getJSON("${ctx}/query_online!getQueryTree.action",{"query_main.pid":pid,"query_main.type":"1"},function(data){
			$(".folderArea").empty();
        	$(data).each(function(index, obj){
        		var v_li = $('<li></li>').appendTo($(".folderArea"));
        		$(v_li).attr('id', obj.id);
        		$(v_li).attr('name', obj.name);
        		$(v_li).attr('pid', obj.pId);
        		$(v_li).append('<div><img class="addFileBtn" src="${ctx}/mybi/common/themes/${apptheme}/images/folder.png"></img></div>');
        		$(v_li).append('<div class="filename">'+obj.name+'</div>');
        		$(v_li).dblclick(function(){
        			loadFolderArea($(v_li).attr('id'));
        			var p_fobj = {
        					id   :　$(v_li).attr('id'),
        					name : $(v_li).attr('name'),
        					pId  : $(v_li).attr('pid'),
        			}
        			setcomboSDAttr(p_fobj);
        		});
        		
        		$(v_li).click(function(){
        			var v_curli = $(this);
        			$(this).parent().find('.folderAreaSelected').removeClass('folderAreaSelected');
        			$(this).parent().find('.delFolder').remove();
        			$(this).addClass('folderAreaSelected');
        			var dv_del = $('<div class="delFolder"><img class="addFileBtn" src="${ctx}/mybi/common/themes/${apptheme}/images/del.png"></img></div>').appendTo($(this));
        			$(dv_del).mouseover(function(){
       				  $(this).find('.addFileBtn').attr('src','${ctx}/mybi/common/themes/${apptheme}/images/del_sel.png');
       				});
        			$(dv_del).mouseout(function(){
         			  $(this).find('.addFileBtn').attr('src','${ctx}/mybi/common/themes/${apptheme}/images/del.png');
         			});
        			
        			$(dv_del).click(function(){
        				
        				var p_fobj = {
            					id   :　$(this).parent().attr("id"),
            					name : $(this).parent().attr("name"),
            					pId  : $(this).parent().attr("pid")
            			}
        				$("#deleteFolderWin").window({
        					open : true,
        					param : p_fobj,
        					headline:'删除目录',
        					content:'<iframe id="addQueryFrame" src="${ctx}/query_homepage!toFolderDelete.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
        					panelWidth:350,
        					panelHeight:250
        				});
        				
        			});
        			
        		/*	$(dv_del).click(function(){
        				var v_li_id = $(this).parent().attr("id");
        				var v_li_pid = $(this).parent().attr("pid");
        				var v_li_name = $(this).parent().attr("name");
        				$.post("${ctx}/query_online!deleteQuery.action", {"query_main.id" : v_li_id },function(data){
        					var jsondata = JSON.parse(data);
        					if(jsondata.result == 'succ'){
        						$.messager.alert('<s:text name="common_msg_info"/>','删除'+v_li_name+'文件夹成功','error');
        						loadFolderArea(v_li_pid);
        					}else{
        						$.messager.alert('<s:text name="common_msg_info"/>','删除目录'+v_li_name+'失败','error'); 
        					}
        				});
        			})*/
        		});
        	})
		});
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#dirSettingWin').window('close');
    }
	
</script>
<style>
.item {margin-left: 10px;}
#tree_menu li{clear: both}
.upFileBtn{margin-top: 5px;cursor: pointer;}
.addFileBtn{margin-top: 5px;cursor: pointer;}
.folderArea li div{text-align: center}
.folderArea li{margin-left: 5px;padding: 0px 5px 0px 5px}
.folderArea li .filename{font-size: 10px;white-space: nowrap;text-overflow:ellipsis;overflow:hidden;width:50px}
.folderAreaSelected{background-color: #CCC;font-weight: bold;position:relative}
.delFolder{position: absolute;left:35px;top:0;z-index: 400px}
</style>
</head>
<body>
<div id="addFolderWin"></div>
<div id="deleteFolderWin"></div>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			<div class="item">
				<ul>
					<li>&nbsp;&nbsp;目录(M)：</li>
					<li><input id="menu"  name="menu" style="width: 300px" class="myui-text"/></li>
					<li style="margin-left: 5px;width:60px;text-align: right;vertical-align: bottom;" >
					<img class="upFileBtn" onclick="backFolder()" src="${ctx}/mybi/common/themes/${apptheme}/images/upfolder.png"></img>
					<img class="addFileBtn" onclick="addFolderWin()" src="${ctx}/mybi/common/themes/${apptheme}/images/addfolder.png"></img></li>
				</ul>
			</div>
			 <div class="item" style="border: 1px solid #DDD;height: 230px;margin-top:10px;width: 438px;overflow:auto;">
			 	<ul class="folderArea">
			 	</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>