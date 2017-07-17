<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>${sysname}</title>
	<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
	<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
	
	<script type="text/javascript">
		<!--
	    $(document).ready(function(){
	    	var obj=$("li.select_selected");
	    	loadTabContent();
	    });
	    
	    //加载内容
	    function loadTabContent(){
	    	var tab = $("li.select_selected");
            var tabId = tab.attr("id");
            var assignUrl = tab.attr("assignUrl");
            if(assignUrl!=null && assignUrl!=""){
            	 $("#myfrm").attr("src",assignUrl);
            }
	    }
	    
	    //点击时，使该标签选中，然后加载内容
	    function setSel(o){
	    	$(".select_selected").addClass("select_unselected").removeClass("select_selected");
	    	$(o).parent().removeClass("select_unselected").addClass("select_selected");
	    	
	    	loadTabContent();
	    }
	    
	    //点击左移箭头
	    function toleft(o){
	    	var thispos=$(o).offset().left;
	    	var lipos=$("ul li:first").offset().left;
	    	if((lipos-thispos)>45){
	    		return;
	    	}
	    	
	    	var tmp=parseInt($(".tabarea .tab").css("left").replace("px",""))+50;
	    	$(".tabarea .tab").css("left",tmp+"px");
	    }
	    
	    //点击右移箭头
	    function toright(o){
	    	var thispos=$(o).offset().left;
	    	var lipos=$("ul li:last").offset().left;
	    	if((thispos-lipos)>105){
	    		return;
	    	}
	    	
	    	var tmp=parseInt($(".tabarea .tab").css("left").replace("px",""))-50;
	    	$(".tabarea .tab").css("left",tmp+"px");
	    }
		// -->
	</script>
	<style type="text/css">
		.tabarea { width:98%; margin:auto;padding:0px;overflow:hidden;}
		.tabarea .tab  { height:40px; position:relative;left:0px;}
		.tabarea .tab  li{float:left;list-style-type:none; margin-left:2px; margin-top:14px; height:38px; text-align:center;font-family:"微软雅黑";font-size:14px;}
		.select_selected{ background: url(${ctx}/mybi/pim/themes/default/images/tab_select.png) no-repeat;cursor:pointer} 
		.select_selected a{color:#ffffff;margin:0 0px;padding:3px 14px;display:block;height:26px;}
		.select_unselected{background: url(${ctx}/mybi/pim/themes/default/images/tab_unselect.png) no-repeat;}
		.select_unselected a{color:#000000;margin:0 0px;padding:3px 14px;display:block;height:26px;}
		.contentdiv{height:600px;width:98%;margin:auto;background:#fff;border:1px solid #A0A0A0;}
	</style>
</head>
<body style="background-color: #F7F7F7;height:650px;">

   	<div class="tabarea" style="height:42px;">
	   <table width="100%;">
	   	  <tr>
	   	  	<td width="40px;" nowrap="nowrap" style="padding-left:5px;padding-bottom:5px;"><a href="javascript:void(0);" onclick="toleft(this);"><img src="${ctx}/mybi/pim/themes/default/images/left.png" style="padding-top:2px;"/></a></td>
	   	  	<td nowrap="nowrap" >
	   	  		<div  style="border:0px;overflow:hidden;margin:0px 5px;">
		   	  		<ul class="tab" style="width:200%;" >
				   	  <s:iterator value="%{#request.sysRestypList}" id="o" status="index">
				   	  	 <s:if test="#index.first">
				   	  	 	<li class="select_selected" id="tab_res_${o.id}" code="tab_res_${o.code}" assignUrl="${o.sysUserAssignUrl}">
				   	  	 		<s:if test='#session.i18nDefault.equals("en")'>
				   	  	 			<a href="javascript:void(0);" onclick="setSel(this)">${o.namEg}</a>
				   	  	 		</s:if><s:else>
				   	  	 			<a href="javascript:void(0);" onclick="setSel(this)">${o.nam}</a>
				   	  	 		</s:else>
				   	  	 	</li>
				   	  	 </s:if><s:else>
				   	  	    <li class="select_unselected" id="tab_res_${o.id}" code="tab_res_${o.code}" assignUrl="${o.sysUserAssignUrl}">
				   	  	    	<s:if test='#session.i18nDefault.equals("en")'>
				   	  	 			<a href="javascript:void(0);" onclick="setSel(this)">${o.namEg}</a>
				   	  	 		</s:if><s:else>
				   	  	 			<a href="javascript:void(0);" onclick="setSel(this)">${o.nam}</a>
				   	  	 		</s:else>
				   	  	    </li>
				   	  	 </s:else>
				   	  </s:iterator>
				   </ul>
			   </div>
	   	  	</td>
	   	  	<td width="40px;" nowrap="nowrap" style="text-align:right;padding-right:5px;padding-bottom:5px;"><a href="javascript:void(0);" onclick="toright(this);"><img src="${ctx}/mybi/pim/themes/default/images/right.png" style="padding-top:2px;"/></a></td>
	   	  </tr>
	   </table>
	</div>
	<div class="contentdiv">
		<iframe id="myfrm" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;"></iframe>
	</div>
	
</body>

</html>	