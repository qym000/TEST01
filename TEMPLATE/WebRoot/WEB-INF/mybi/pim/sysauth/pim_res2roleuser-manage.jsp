<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
	
	<script type="text/javascript">
		<!--
	    $(document).ready(function(){
	    	var obj=$("li.select_selected");
	    	loadTabContent();
	    	//选项卡切换
	    	$(".tab li").click(function(){
	    		var id = $(this).attr("id");
				$.each($(this).parent().find("li"),function(i){
					if ($(this).attr("id") == id) {
						$(this).removeClass().addClass("select_selected");
					}else {
						$(this).removeClass().addClass("select_unselected");
					}
				});
				var url = $(this).attr("url");
				$("#myfrm").attr("src",url);
	    	});
	    });
	    
	    //加载内容
	    function loadTabContent(){
	    	var url = $(".select_selected").attr("url");
	    	$("#myfrm").attr("src",url);
	    }
	</script>
	<style type="text/css">
		.tabarea { width:940px; margin:auto;overflow:hidden;border-bottom:1px solid #A0A0A0; }
		.tabarea .tab  { height:40px; padding:0 0 0 15px;}
		.tabarea .tab  li{float:left;list-style-type:none; margin-left:5px; margin-top:14px;padding-top:3px;  width:100px; height:38px; text-align:center;font-family:"微软雅黑";font-size:14px;}
		.select_selected{ background: url(${ctx}/mybi/pim/themes/default/images/tab_select.png) no-repeat;cursor:pointer} 
		.select_unselected{background: url(${ctx}/mybi/pim/themes/default/images/tab_unselect.png) no-repeat;cursor:pointer}
	</style>
</head>
<body style="height:400px;">
    	<div class="tabarea" style="height:42px;">
		   <ul class="tab" >
	   	  	 	<li class="select_selected" id="tab_res_role" url="${ctx}/pim_res2roleuser!toSysRoleList.action"><s:text name="sysauth_sysrole_list"/>
	   	  	 	</li>
	   	  	    <li class="select_unselected" id="tab_res_user" url="${ctx}/pim_res2roleuser!toSysUserList.action"><s:text name="sysauth_sysuser_list"/>
	   	  	    </li>
		   </ul>
		</div>
		<div style="height:335px;">
			<iframe id="myfrm" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;"></iframe>
		</div>

</body>
</html>	