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
	function sbt(){
		var name = $('#name').val();
		if(!name || name == ''){
			$.messager.alert('<s:text name="common_msg_info"/>','名称不能为空'); //操作失败
			return false;
		}
		var v_fobj = {
				"query_main.name" : name,
				"query_main.remark" : $('#remark').val(),
				"query_main.pid" : $("#menu" ,parent.document).attr('fid'),
				"query_main.type" : "1"
		}
		$.post("${ctx}/query_online!insertQuery.action", v_fobj,function(data){
			var jsondata = JSON.parse(data);
			if(jsondata.result == 'succ'){
				$.messager.alert('<s:text name="common_msg_info"/>','添加成功','info', function(){
					parent.window.loadFolderArea($("#menu" ,parent.document).attr('fid'));
					clsWin();
					parent.parent.window.loadZTree("query", false);
				}); 
				
				
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','添加失败','error'); 
				clsWin();
			}
		})
	}
	
	$(function(){
		$('#pname').val($("#menu" ,parent.document).attr('fname'));
	})
	
		//关闭当前窗口
    function clsWin(){
    	parent.$('#addFolderWin').window('close');
    }
	
</script>
</head>
<body>
	<div id="addFolderWin"></div>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc">上级目录：</li>
					<li><input id="pname"  name="pname" readonly="readonly" style="width: 250px" class="myui-text"/></li>
				</ul>
			</div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b>名称：</li>
					<li><input id="name"  name="name" style="width: 250px" class="myui-text"/></li>
				</ul>
			</div>
			<div class="item">
				<ul>
					<li class="desc">描述：</li>
					<li><textarea id="remark"  name="remark" style="width: 250px;height: 50px" class="myui-text"></textarea></li>
				</ul>
			</div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>

