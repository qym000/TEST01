<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/ajaxfileupload/ajaxfileupload.js"></script>
<script type="text/javascript">
	$(function(){
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){return false;},
			onSuccess : function (){
				add_onload();//开启蒙板层
		        $.ajaxFileUpload({
		                url:'pim_sys-user!initimportSysUser.action',//用于文件上传的服务器端请求地址
		                secureuri:false,//一般设置为false
		                fileElementId:'importObj',//文件上传空间的id属性  <input type="file" id="file" name="file" />
		                dataType: 'text/json',//返回值类型 一般设置为json
		                success: function (data, status){ 
		                	if(data.result=="succ"){
		                		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_importsucc"/>','info');
		                	}else if(data.result=="fail"){
		                		$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_importfail"/>','info'); //服务器繁忙，请稍候重试！
		                	}else{
		                		$.messager.alert('<s:text name="common_msg_info"/>',data.result,'info');
		                	}
		                	clean_onload();//关闭蒙板层
		                }
		            }
		        )
				//parent.loadOrgTree();	//回显刚才操作的记录
			}
		});
		
		$("#importObj").formValidator({}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
	});
	
	//表单提交
	function sbt(){
		$("#form_input").submit();
	}
	
	//下载
	function dn(exportFileType){
		//监控导出状态
    	monitorExportStatus('pim_sys-user!monitorExportStatus.action');
    	//导出操作
    	window.location.href = "pim_sys-user!exportInitimportModelFile.action?exportFileType="+exportFileType;
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
</script>
</head>
<body>

<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="common_msg_selectfile"/>：</li>
					<li><input type="file" id="importObj" name="importObj" class="myui-text"/></li>
					<li class="tipli"><div id="importObjTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc">&nbsp;</li>
					<li><a  href="javascript:void(0);" onclick="dn('excel2003')" style="text-decoration: underline"><s:text name="common_action_dnmodelfile"/></a></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>

</html>

