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
<script type="text/javascript">
	$(function(){
		$("#typ").combo({
			mode:'local',
			valueField:'value',
			textField:'text',
			panelHeight:100,
			data : [{value:'0',text:'<s:text name="msgboard_typ0"/>'},{value:'1',text:'<s:text name="msgboard_typ1"/>'},{value:'2',text:'<s:text name="msgboard_typ2"/>'}]
		});
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){return false;},
			onSuccess : function (){
				add_onload();//开启蒙板层
				var typ=$("#typ").combo('getValue');
				var content=$("#content").val();
				var phonenum=$("#phonenum").val();
				var email=$("#email").val();
				$.post("pim_sys-improve!saveSysImproveObj.action",{typ:typ,content:content,phonenum:phonenum,email:email},function(data){ 
		    		if(data.result=="succ"){
		    			$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',function(){ //添加成功
			    			clsWin();
		    			});
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info'); //添加失败
					}
		    		clean_onload();//关闭蒙板层
		        },"json"); 
			}
		});
		
		$("#content").formValidator({onFocus:"请输入内容"}).inputValidator({min:1,max:500,onErrorMin:"不能为空",onError:"不能超过500字符"});
	});
	
	/**
	 * 表单提交
	 */
	function sbt(){
		$("#form_input").submit();
	}
	
	/**
	 * 关闭当前窗口
	 */
    function clsWin(){
    	//parent.$('#inputWin').window({open:false});
    	$('.myui-window-obj').window('close');
    }
</script>
</head>
<body>

<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
	        <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="msgboard_typ"/>：</li>
					<li>
						<input id="typ" style="width:160px"/>
					</li>
					<li class="tipli"><div id="typTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><b>* </b><s:text name="msgboard_content"/>：</li>
					<li><textarea id="content" name="content" maxlength="80" class="myui-textarea"></textarea></li>
					<li class="tipli"><div id="contentTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_phonenum"/>：</li>
					<li><input id="phonenum" name="phonenum" maxlength="20" class="myui-text"/></li>
					<li class="tipli"><div id="phonenumTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<li class="desc"><s:text name="sysauth_sysuser_email"/>：</li>
					<li><input id="email" name="email" maxlength="80" class="myui-text"/></li>
					<li class="tipli"><div id="emailTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<a class="button" href="javascript:void(0);" onclick="sbt()">提交</a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">取消</a>
	</div>
</div>

</body>
</html>

