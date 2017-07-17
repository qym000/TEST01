<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title></title>
<link href="${ctx}/mybi/common/scripts/syntaxHighlighter/styles/shCoreEclipse.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"	rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/demo/themes/${apptheme}/demo-myui.css"	rel="stylesheet" type="text/css" />
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shCore.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJScript.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushXml.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJava.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	$(function() {
	    SyntaxHighlighter.all();
	    parent.clean_onload();
	});
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="tabs" style="width:960px;height:672px;" position="right" title="使用模板(请参照CRUD中的流程表单)">
		<div class="tabcontent" title="JSP" selected="true">
<h2>表单父页面</h2>
<pre class="brush:js;">
	// 转向流程表单修改；
	function toStepFormUpt() {
		var objsChecked=$("input[name='checkboxitem']:checked");
    	if(objsChecked.length&lt;=0){
    		$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_noselect"/>','info');//没有选择记录
    		return;
    	}
    	if(objsChecked.length>1){
    		$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_singleselect"/>','info');//只能选择一条记录
    		return;
    	}
    	
    	var str=$(objsChecked[0]).val();
		$("#inputWin").window({
			open : true,
			headline:'流程表单修改',
			content:'&lt;iframe id="stepFormUpt" name="stepFormUpt" src=demo_step-form!uptFormController.action?step=1&id='+str+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:600,
			panelHeight:300
		});
	}
</pre>
<h2>步骤1表单修改</h2>
<pre class="brush:html;">
&lt;%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
&lt;%@ page language="java" pageEncoding="UTF-8"%>
&lt;%@ taglib prefix="s" uri="/struts-tags"%>
&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
&lt;html xmlns="http://www.w3.org/1999/xhtml">
&lt;head>
&lt;title>&lt;/title>
&lt;link href="\${ctx}/mybi/common/themes/\${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
&lt;link href="\${ctx}/mybi/demo/themes/\${apptheme}/demo-stepform.css" rel="stylesheet" type="text/css"/>
&lt;link href="\${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.js">&lt;/script> 
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.myui.all.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/pim/scripts/jquery.pim.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js">&lt;/script>
&lt;script type="text/javascript">
</pre>
<pre class="brush:js;">
	$(function(){
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param={
					"userObj.id" : "\${obj.id}" ,
					"userObj.nam" : $.trim($("#nam").val()) ,
					"userObj.orgidt" : $.trim($("#orgidt").val()),
					step : "\${request.step}"
				};
				add_onload();//开启蒙板层
				$.post("demo_step-form!updateUserObj.action",param,function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_updatesucc"/>','info');
					}else if(data.result=="fail"){
						$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_updatefail"/>','info');
					}
					
					clean_onload();//关闭蒙板层
			    },"json");
			}
		});
		$("#nam").formValidator().inputValidator({min:1,onError:'&lt;s:text name="common_msg_formvalidte_required"/>'})//不能为空
		.functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "demo_crud!isCrudNamUnique.action",
			type : "POST",
			data: {nam:$("#nam").val()},
			success : function(data){
				if (data == "false") {
					return '&lt;s:text name="common_msg_formvalidte_alreadyexist"/>';  //已经存在
                } else {  
                    return true;  
                }  
			},
			onError : '&lt;s:text name="common_msg_formvalidte_alreadyexist"/>',//已经存在
			onWait : '&lt;s:text name="common_msg_formvalidte_validating"/>'//校验中
		});
		var temp_orgidt=null;
		$("#orgidt").formValidator().inputValidator({min:1,onError:'&lt;s:text name="common_msg_formvalidte_required"/>'})
		.functionValidator({fun:isHasSpecialChar})
		.ajaxValidator({
			dataType : "text",
			url : "pim_org!isCdeorgOrgidtValid.action",
			type : "POST",
			data: {orgidt:$("#orgidt").val()},
			success : function(data){
				temp_orgidt=data;
				if (data == "noExist") {
					return '&lt;s:text name="org_orgidt_noExist"/>';  //机构不存在
                } else if (data == "noAuth") {
                	return '&lt;s:text name="org_orgidt_noAuth"/>';  //机构不在权限范围内
                } else {  
                    return true;  
                }  
			},
			onError : function(val,dom){
				if (temp_orgidt == "noExist") {
					return '&lt;s:text name="org_orgidt_noExist"/>';  //机构不存在
                } else if (temp_orgidt == "noAuth") {
                	return '&lt;s:text name="org_orgidt_noAuth"/>';  //机构不在权限范围内
                } 
			},
			onWait : '&lt;s:text name="common_msg_formvalidte_validating"/>'//校验中
		});
	});
	
	//提交
	function sbt(){
		$("#form_input").submit();
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
	
	// 切换选项卡页面
	function chgUpdPage(obj, step){
		var flag = $(obj).find("li").eq(2).hasClass("right2");
		if(flag){
			return false;
		}
		window.location.href = "demo_step-form!uptFormController.action?id="+'\${obj.id}'+"&step=" + step;	
	}
</pre>
<pre class="brush:html;">
&lt;/script>
&lt;/head>
&lt;body>
&lt;div class="myui-form">
	&lt;div class="stepFormTitleBg">
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 1);">
			&lt;li class="left">&lt;/li>&lt;li class="center">基本信息&lt;/li>&lt;li class="right2">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 2);">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">个人信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 3);">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">其他信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
	&lt;/div>
	&lt;div class="form">
		&lt;form id="form_input" method="post">
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>姓名：&lt;/li>
					&lt;li>&lt;input id="nam" name="nam" value="\${obj.nam}" maxlength="30" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="namTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>所属机构：&lt;/li>
					&lt;li>&lt;input id="orgidt" name="orgidt" value="\${obj.orgidt}" maxlength="30" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="orgidtTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
		 &lt;/form>
	&lt;/div>
	&lt;div class="operate">
		&lt;a class="main_button" href="javascript:void(0);" onclick="sbt();">&lt;s:text name="common_action_submit"/>&lt;/a>
		&lt;a class="button" href="javascript:void(0);" onclick="clsWin();" style="margin-right:20px;">&lt;s:text name="common_action_cancle"/>&lt;/a>
	&lt;/div>
&lt;/div>

&lt;/body>

&lt;/html>
</pre>
<h2>步骤2表单修改</h2>
<pre class="brush:html;">
&lt;%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
&lt;%@ page language="java" pageEncoding="UTF-8"%>
&lt;%@ taglib prefix="s" uri="/struts-tags"%>
&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
&lt;html xmlns="http://www.w3.org/1999/xhtml">
&lt;head>
&lt;title>&lt;/title>
&lt;link href="\${ctx}/mybi/common/themes/\${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
&lt;link href="\${ctx}/mybi/demo/themes/\${apptheme}/demo-stepform.css" rel="stylesheet" type="text/css"/>
&lt;link href="\${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.js">&lt;/script> 
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.myui.all.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/pim/scripts/jquery.pim.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js">&lt;/script>
&lt;script type="text/javascript">
</pre>
<pre class="brush:js;">
	$(function(){
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param={
					"userObj.id" : "\${obj.id}" ,
					"userObj.birthday" : $("#birthday").datebox("getValue") ,
					"userObj.position" : $.trim($("#position").val()) ,
					"userObj.phoneNum" : $.trim($("#phoneNum").val()) ,
					"userObj.address" : $.trim($("#address").val()),
					step : "\${request.step}"
				};
				add_onload();//开启蒙板层
				$.post("demo_step-form!updateUserObj.action",param,function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_updatesucc"/>','info');
					}else if(data.result=="fail"){
						$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_updatefail"/>','info');
					}
					
					clean_onload();//关闭蒙板层
				},"json");
			}
		});
		$("#birthday").formValidator().inputValidator({min:1,onError:'&lt;s:text name="common_msg_formvalidte_required"/>'});
		$("#position").formValidator().inputValidator({min:1,onError:'&lt;s:text name="common_msg_formvalidte_required"/>'});
		$("#phoneNum").formValidator().functionValidator({
			fun:function(val) {
				var reg = /^[0-9]*$/;
				if (!reg.test(val)) {
					return "请输入数字";
				}
				return true;
			}
		});
	});
	
	//提交
	function sbt(){
		$("#form_input").submit();
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
	
 	// 切换选项卡页面
	function chgUpdPage(obj, step){
		var flag = $(obj).find("li").eq(2).hasClass("right2");
		if(flag){
			return false;
		}
		window.location.href = "demo_step-form!uptFormController.action?id="+'\${obj.id}'+"&step=" + step;	
	}
</pre>
<pre class="brush:html;">
&lt;/script>
&lt;/head>
&lt;body>
&lt;div class="myui-form">
	&lt;div class="stepFormTitleBg">
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 1);">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">基本信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 2);">
			&lt;li class="left">&lt;/li>&lt;li class="center">个人信息&lt;/li>&lt;li class="right2">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 3);">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">其他信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
	&lt;/div>
	&lt;div class="form">
		&lt;form id="form_input" method="post">
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>出生日期：&lt;/li>
					&lt;li>&lt;input id="birthday" name="birthday" value="\${obj.birthday}" maxlength="8" class="myui-datebox" style="width:200px;"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="birthdayTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>职位：&lt;/li>
					&lt;li>&lt;input id="position" name="position" value="\${obj.position}" maxlength="30" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="positionTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">联系方式：&lt;/li>
					&lt;li>&lt;input id="phoneNum" name="phoneNum" value="\${obj.phoneNum}" maxlength="11" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="phoneNumTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">地址：&lt;/li>
					&lt;li>&lt;input id="address" name="address" value="\${obj.address}" maxlength="80" class="myui-text" style="width:200px;"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="addressTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
		 &lt;/form>
	&lt;/div>
	&lt;div class="operate">
		&lt;a class="main_button" href="javascript:void(0);" onclick="sbt();">&lt;s:text name="common_action_submit"/>&lt;/a>
		&lt;a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">&lt;s:text name="common_action_cancle"/>&lt;/a>
	&lt;/div>
&lt;/div>

&lt;/body>

&lt;/html>
</pre>
<h2>步骤3表单修改</h2>
<pre class="brush:html;">
&lt;%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
&lt;%@ page language="java" pageEncoding="UTF-8"%>
&lt;%@ taglib prefix="s" uri="/struts-tags"%>
&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
&lt;html xmlns="http://www.w3.org/1999/xhtml">
&lt;head>
&lt;title>&lt;/title>
&lt;link href="\${ctx}/mybi/common/themes/\${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
&lt;link href="\${ctx}/mybi/demo/themes/\${apptheme}/demo-stepform.css" rel="stylesheet" type="text/css"/>
&lt;link href="\${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.js">&lt;/script> 
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.myui.all.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/pim/scripts/jquery.pim.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js">&lt;/script>
&lt;script type="text/javascript">
</pre>
<pre class="brush:js;">
	$(function(){
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				var param = {
					"userObj.id" : "\${obj.id}" ,
					"userObj.remark" : $.trim($("#remark").val()),
					step : "\${request.step}"
				}
				add_onload();//开启蒙板层
				$.post("demo_step-form!updateUserObj.action",param,function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_updatesucc"/>','info');
					}else if(data.result=="fail"){
						$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_updatefail"/>','info');
					}
					
					clean_onload();//关闭蒙板层
				},"json");
			}
		});
		$("#remark").formValidator().inputValidator({max:80,onError:'&lt;s:text name="common_msg_formvalidte_nomorethan">&lt;s:param>80&lt;/s:param>&lt;/s:text>'});//不能超过80字符
	});
	
	//提交
	function sbt(){
		$("#form_input").submit();
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
	
 	// 切换选项卡页面
	function chgUpdPage(obj, step){
		var flag = $(obj).find("li").eq(2).hasClass("right2");
		if(flag){
			return false;
		}
		window.location.href = "demo_step-form!uptFormController.action?id="+'\${obj.id}'+"&step=" + step;	
	}
</pre>
<pre class="brush:html;">
&lt;/script>
&lt;/head>
&lt;body>
&lt;div class="myui-form">
	&lt;div class="stepFormTitleBg">
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 1);">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">基本信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 2);">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">个人信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur" style="cursor: pointer;" onclick="chgUpdPage(this, 3);">
			&lt;li class="left">&lt;/li>&lt;li class="center">其他信息&lt;/li>&lt;li class="right2">&lt;/li>
		&lt;/ul>
	&lt;/div>
	&lt;div class="form">
		&lt;form id="form_input" method="post">
			&lt;div class="item">
				&lt;ul>
					&lt;li class="desc">备注：&lt;/li>
					&lt;li>&lt;textarea id="remark" name="remark" maxlength="80" class="myui-textarea" style="width:200px;">\${obj.remark }&lt;/textarea>&lt;/li>
					&lt;li class="tipli">&lt;div id="remarkTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
		&lt;/form>
	&lt;/div>
	&lt;div class="operate">
		&lt;a class="main_button" href="javascript:void(0);" onclick="sbt()">提交&lt;/a>
		&lt;a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">&lt;s:text name="common_action_cancle"/>&lt;/a>
	&lt;/div>
&lt;/div>

&lt;/body>

&lt;/html>
</pre>
		</div>
		<div class="tabcontent" title="Action">
<pre class="brush:java;">
	/**
	 * @description:流程表单修改转向控制
	 * @return:
	 */
	public String uptFormController() {
		Demo_user obj = demo_stepFormService.findUserObjById(id);
		request.setAttribute("obj", obj);
		request.setAttribute("step", step);
		return "FORM_STEP" + step + "_UPT";
	}
	
	/**
	 * @description:修改用户对象
	 * @return:
	 */
	public String updateUserObj() {
		userObj.setModuid(((Pim_sysUser)session.getAttribute("loginUserObj")).getId());
		JSONObject jsonObj = new JSONObject();
		try{
			demo_stepFormService.updateUserObj(step, userObj);
			jsonObj.put("result", "succ");
			jsonObj.put("callbackCondition", userObj.getId());
		}catch(Exception e){
			e.printStackTrace();
			jsonObj.put("result", "fail");
		}
		Struts2Utils.renderText(jsonObj.toString());
		
		return NONE;
	}
</pre>		
		</div>
		<div class="tabcontent" title="Domain">
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.demo.stepform.domain;

import org.apache.ibatis.type.Alias;

import com.mingyoutech.framework.domain.BaseDomain;

/**
 * @description：DEMO_USER Domain对象
 * @author： gzh
 * @date：2016-03-03
 * 
 * @modify content：
 * @modifier：
 * @modify date:
 */
@Alias("Demo_user")
public class Demo_user extends BaseDomain {

	private static final long serialVersionUID = -2928816663401235280L;
	
	// ID
	private String id;
	//名称
	private String nam;
	//机构
	private String orgidt;
	//机构名称
	private String orgnam;
	//最后修改人id
	private String moduid;
	//最后修改人登录编号
	private String modlogid;
	//最后修改人名称
	private String modnam;
	//最后修改日期
	private String modate;
	//备注
	private String remark;
	//电话
	private String phoneNum;
	//地址
	private String address;
	//职位
	private String position;
	//生日
	private String birthday;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNam() {
		return nam;
	}
	public void setNam(String nam) {
		this.nam = nam;
	}
	public String getOrgidt() {
		return orgidt;
	}
	public void setOrgidt(String orgidt) {
		this.orgidt = orgidt;
	}
	public String getOrgnam() {
		return orgnam;
	}
	public void setOrgnam(String orgnam) {
		this.orgnam = orgnam;
	}
	public String getModuid() {
		return moduid;
	}
	public void setModuid(String moduid) {
		this.moduid = moduid;
	}
	public String getModlogid() {
		return modlogid;
	}
	public void setModlogid(String modlogid) {
		this.modlogid = modlogid;
	}
	public String getModnam() {
		return modnam;
	}
	public void setModnam(String modnam) {
		this.modnam = modnam;
	}
	public String getModate() {
		return modate;
	}
	public void setModate(String modate) {
		this.modate = modate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getPhoneNum() {
		return phoneNum;
	}
	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getBirthday() {
		return birthday;
	}
	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	
}
</pre>
		</div>
		<div class="tabcontent" title="Service">
		<h2>Service</h2>
<pre class="brush:java;">
	/**
	 * @description:根据ID查询用户对象
	 * @param:id 用户ID
	 * @return:用户对象
	 */
	public Demo_user findUserObjById(String id);
	
	/**
	 * @description:修改用户对象
	 * @param:obj 用户对象 step 步骤数
	 * @return:
	 */
	public void updateUserObj(String step, Demo_user obj);
</pre>
		<h2>ServiceImpl</h2>
<pre class="brush:java;">
	/**
	 * @description:根据ID查询用户对象
	 * @param:id 用户ID
	 * @return:用户对象
	 */
	@Override
	public Demo_user findUserObjById(String id) {
		return (Demo_user) this.findForObject("com.mingyoutech.mybi.demo.stepForm.domain.Demo_user.findUserObjById", id);
	}
	
	/**
	 * @description:修改用户对象
	 * @param:obj 用户对象 step 步骤数
	 * @return:
	 */
	@Override
	public void updateUserObj(String step, Demo_user obj) {
		this.update("com.mingyoutech.mybi.demo.stepForm.domain.Demo_user.updateUserObj" + step, obj);
	}
</pre>
		</div>
		<div class="tabcontent" title="SQL-Map">
<pre class="brush:xml;">
	&lt;!-- 根据用户ID查询用户对象 -->
	&lt;select id="findUserObjById" parameterType="string" resultType="Demo_user">
		SELECT
			id id,
			nam nam,
			orgidt orgidt,
			moduid moduid,
			TO_CHAR(modate,'YYYY-MM-DD HH24:mi:ss') modate,
			remark remark,
			phone_num phoneNum,
			address address,
			position position,
			birthday birthday
		FROM tp_demo_crud
		WHERE id = \#{id}
	&lt;/select>
	
	&lt;!-- 修改用户对象基本信息 -->
	&lt;update id="updateUserObj1" parameterType="Demo_user">
		UPDATE tp_demo_crud 
		SET nam = \#{nam},
			orgidt = \#{orgidt},
			moduid = \#{moduid},
			modate = sysdate
		WHERE id = \#{id}
	&lt;/update>
	
	&lt;!-- 修改用户对象个人信息 -->
	&lt;update id="updateUserObj2" parameterType="Demo_user">
		UPDATE tp_demo_crud 
		SET phone_num = \#{phoneNum,jdbcType=VARCHAR},
			address = \#{address,jdbcType=VARCHAR},
			position = \#{position},
			birthday = \#{birthday,jdbcType=NUMERIC},
			moduid = \#{moduid},
			modate = sysdate
		WHERE id = \#{id}
	&lt;/update>
	
	&lt;!-- 修改用户对象其他信息 -->
	&lt;update id="updateUserObj3" parameterType="Demo_user">
		UPDATE tp_demo_crud 
		SET remark = \#{remark,jdbcType=VARCHAR},
			moduid = \#{moduid},
			modate = sysdate
		WHERE id = \#{id}
	&lt;/update>
</pre>
		</div>
	</div>
</div>

</body>
</html>