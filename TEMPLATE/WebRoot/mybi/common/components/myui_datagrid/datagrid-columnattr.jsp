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
		var v_opts = parent.$('#editColumnAttrWin').window('options');
		v_winParam  = v_opts.param;
		setTabSelectedByTab($("#colattr-link"));
	});
	
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#editColumnAttrWin').window('close');
    }
    
    function sbt(){
    	
    	//如果是链接修改的时候
    	if($('.myui-form .top-main').find('.tab-selected').attr('ind') == 0) {
    		//var d_seltabifr = $('.myui-form').find('.top-body iframe');
    		var v_form = $('.myui-form .top-body #colattr-link-frame')[0].contentWindow.getForm();
    		if(v_form) {
    		   parent.window.setColLink(v_form);
    		   clsWin();
    		}
    	}
    }
    
    function removeLink(){
    	parent.window.removeColLink(v_winParam.colidx);
    	clsWin();
    }
</script>
<style type="text/css">
.myui-layout{margin: 0;}
.myui-layout .myui-template-graywin .top-body{border:0px;}
</style>
</head>
<body>
<div class="myui-form">
	<div class="form">
		<div class="myui-layout">
			<div class="tabs" style="width: 498px;height: 270px">
				<div class="tabcontent" id="colattr-link"  title="<i class='fa fa-link'></i> 链接" style="width: 490px;height: 250px">
					<iframe src="datagrid-columnattr-link.jsp" id="colattr-link-frame" frameborder="0" scrolling="no"></iframe>
				</div>
			</div>
		</div>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="removeLink()">清除链接</a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>