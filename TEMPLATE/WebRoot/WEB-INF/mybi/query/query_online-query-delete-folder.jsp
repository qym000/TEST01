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
<script>

	//window传来的参数
	var v_winParam;

	$(function(){
		var v_opts = parent.$('#deleteFolderWin').window('options');
		v_winParam  = v_opts.param;
		$('.fName').append(v_winParam.name);
	})
	
	//关闭当前窗口
	function clsWin(){
		parent.$('#deleteFolderWin').window('close');
	}
	
	function del(type){
		var v_param = {
			delType         : type,
			"query_main.id" : v_winParam.id,
			"query_main.pid" : v_winParam.pId
		}
		
		$.post("${ctx}/query_online!deleteQuery.action", v_param,function(data){
			
			var jsondata = JSON.parse(data);
			if(jsondata.result == 'succ'){
				$.messager.alert('<s:text name="common_msg_info"/>','删除'+v_winParam.name+'成功','info', function(){
					parent.window.loadFolderArea(v_winParam.pId);
					clsWin();
					parent.parent.window.loadZTree("query", false);
				});
				
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','删除'+v_winParam.name+'文件夹失败','error', function(){
					clsWin();
				});
			}
		});
	}
	
</script>
<style>
.delOper a{color:blue; text-decoration: underline;}
</style>

</head>
<body>
		<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc" style="width: 330px;text-align: left"><div class="delOper"><a href="###" onclick="del('autoMove')">删除(<span class="fName"></span>)目录，将目录下内容转移至当前目录的上级</a></div></li>
				</ul>
			</div>
			 <div class="item">
				<ul>
					<li class="desc" style="width: 330px;text-align: left"><div class="delOper"><a href="###" onclick="del('cascade')">删除(<span class="fName"></span>)目录以及目录下所有内容</a><span style="color:red">(不推荐)</span></div></li>
				</ul>
			</div>
			<div class="operate">
				<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
			</div>
		 </form>
	</div>
</div>
</body>
</html>

