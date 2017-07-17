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
//流程表单临时参数对象
var stepParam = {};
// 转向流程表单；
function toStepForm() {
	stepParam = {};
	$("#inputWin").window({
		open : true,
		headline:'流程表单',
		content:'&lt;iframe id="formS1" name="formS2" src=demo_step-form!stepFormController.action?step=1 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
		panelWidth:600,
		panelHeight:300
	});
}
</pre>
<h2>步骤1表单</h2>
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
		if (parent.stepParam != null) {
			$("#nam").val(parent.stepParam.nam);
			$("#orgidt").val(parent.stepParam.orgidt==undefined?"${session.orgcdeObj.orgidt}":parent.stepParam.orgidt);
		} 
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				parent.stepParam.nam = $.trim($("#nam").val());
				parent.stepParam.orgidt = $.trim($("#orgidt").val());
				parent.$("#inputWin").window("close");
		    	parent.$("#inputWin").window({
					open : true,
					content:'&lt;iframe id="formS2" name="formS2" src=demo_step-form!stepFormController.action?step=2 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				});
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
	
	//下一步
	function next(){
		$("#form_input").submit();
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
</pre>
<pre class="brush:html;">
&lt;/script>
&lt;/head>
&lt;body>
&lt;div class="myui-form">
	&lt;div class="stepFormTitleBg">
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left"/>&lt;li class="center">基本信息&lt;/li>&lt;li class="right"/>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">个人信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">其他信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
	&lt;/div>
	&lt;div class="form">
		&lt;form id="form_input" method="post">
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>姓名：&lt;/li>
					&lt;li>&lt;input id="nam" name="nam" maxlength="30" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="namTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>所属机构：&lt;/li>
					&lt;li>&lt;input id="orgidt" name="orgidt" maxlength="30" value="\${session.orgcdeObj.orgidt}" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="orgidtTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
		 &lt;/form>
	&lt;/div>
	&lt;div class="operate">
		&lt;a class="main_button" href="javascript:void(0);" onclick="next()">下一步&lt;/a>
		&lt;a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">&lt;s:text name="common_action_cancle"/>&lt;/a>
	&lt;/div>
&lt;/div>

&lt;/body>

&lt;/html>
</pre>
<h2>步骤2表单</h2>
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
		if (parent.stepParam != null) {
			$("#birthday").datebox("setValue",parent.stepParam.birthday);
			$("#position").val(parent.stepParam.position);
			$("#phoneNum").val(parent.stepParam.phoneNum);
			$("#address").val(parent.stepParam.address);
		}
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				parent.stepParam.birthday = $.trim($("#birthday").datebox("getValue"));
				parent.stepParam.position = $.trim($("#position").val());
				parent.stepParam.phoneNum = $.trim($("#phoneNum").val());
				parent.stepParam.address = $.trim($("#address").val());
				parent.$("#inputWin").window("close");
		    	parent.$("#inputWin").window({
					open : true,
					content:'&lt;iframe id="formS3" name="formS3" src=demo_step-form!stepFormController.action?step=3 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				});
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
	
	//上一步
	function back(){
		parent.$("#inputWin").window("close");
    	parent.$("#inputWin").window({
			open : true,
			content:'&lt;iframe id="formS1" name="formS1" src=demo_step-form!stepFormController.action?step=1 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
		});
	}
	
	//下一步
	function next(){
		$("#form_input").submit();
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
</pre>
<pre class="brush:html;">
&lt;/script>
&lt;/head>
&lt;body>
&lt;div class="myui-form">
	&lt;div class="stepFormTitleBg">
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left-normal"/>&lt;li class="center-normal">基本信息&lt;/li>&lt;li class="right-normal"/>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left">&lt;/li>&lt;li class="center">个人信息&lt;/li>&lt;li class="right">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">其他信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
	&lt;/div>
	&lt;div class="form">
		&lt;form id="form_input" method="post">
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>出生日期：&lt;/li>
					&lt;li>&lt;input id="birthday" name="birthday" maxlength="8" class="myui-datebox" style="width:200px;"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="birthdayTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>职位：&lt;/li>
					&lt;li>&lt;input id="position" name="position" maxlength="30" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="positionTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">联系方式：&lt;/li>
					&lt;li>&lt;input id="phoneNum" name="phoneNum" maxlength="11" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="phoneNumTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">地址：&lt;/li>
					&lt;li>&lt;input id="address" name="address" maxlength="80" class="myui-text" style="width:200px;"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="addressTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
		 &lt;/form>
	&lt;/div>
	&lt;div class="operate">
		&lt;a class="button" href="javascript:void(0);" onclick="back()">上一步&lt;/a>
		&lt;a class="main_button" href="javascript:void(0);" onclick="next()">下一步&lt;/a>
		&lt;a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;">&lt;s:text name="common_action_cancle"/>&lt;/a>
	&lt;/div>
&lt;/div>

&lt;/body>

&lt;/html>
</pre>
<h2>步骤3表单</h2>
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
		if (parent.stepParam != null) {
			$("#remark").val(parent.stepParam.remark);
		}
		
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				parent.stepParam.remark = $.trim($("#remark").val());
				var param = {
					"userObj.nam" : parent.stepParam.nam,
					"userObj.orgidt" : parent.stepParam.orgidt,
					"userObj.birthday" : parent.stepParam.birthday,
					"userObj.position" : parent.stepParam.position,
					"userObj.phoneNum" : parent.stepParam.phoneNum,
					"userObj.address" : parent.stepParam.address,
					"userObj.remark" : parent.stepParam.remark
				}
				add_onload();//开启蒙板层
				$.post("demo_step-form!saveUserObj.action",param,function(data){ 
					if(data.result=="succ"){
						parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_addsucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('&lt;s:text name="common_msg_info"/>','&lt;s:text name="common_msg_addfail"/>','info');
					}
					
					clean_onload();//关闭蒙板层
			    },"json");
			}
		});
		$("#remark").formValidator().inputValidator({max:80,onError:'&lt;s:text name="common_msg_formvalidte_nomorethan">&lt;s:param>80&lt;/s:param>&lt;/s:text>'});//不能超过80字符
	});
	
	//上一步
	function back(){
		parent.$("#inputWin").window("close");
    	parent.$("#inputWin").window({
			open : true,
			content:'&lt;iframe id="formS2" name="formS2" src=demo_step-form!stepFormController.action?step=2 scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
		});
	}
	
	//下一步
	function sbt(){
		$("#form_input").submit();
	}
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
</pre>
<pre class="brush:html;">
&lt;/script>
&lt;/head>
&lt;body>
&lt;div class="myui-form">
	&lt;div class="stepFormTitleBg">
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left-normal"/>&lt;li class="center-normal">基本信息&lt;/li>&lt;li class="right-normal"/>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left-normal">&lt;/li>&lt;li class="center-normal">个人信息&lt;/li>&lt;li class="right-normal">&lt;/li>
		&lt;/ul>
		&lt;ul class="stepFormTitleCur">
			&lt;li class="left">&lt;/li>&lt;li class="center">其他信息&lt;/li>&lt;li class="right">&lt;/li>
		&lt;/ul>
	&lt;/div>
	&lt;div class="form">
		&lt;form id="form_input" method="post">
			&lt;div class="item">
				&lt;ul>
					&lt;li class="desc">备注：&lt;/li>
					&lt;li>&lt;textarea id="remark" name="remark" maxlength="80" class="myui-textarea" style="width:200px;">&lt;/textarea>&lt;/li>
					&lt;li class="tipli">&lt;div id="remarkTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
		&lt;/form>
	&lt;/div>
	&lt;div class="operate">
		&lt;a class="button" href="javascript:void(0);" onclick="back()">上一步&lt;/a>
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
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.demo.stepform.action;

import java.util.UUID;

import net.sf.json.JSONObject;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.mybi.demo.stepform.domain.Demo_user;
import com.mingyoutech.mybi.demo.stepform.service.Demo_stepFormService;
import com.mingyoutech.mybi.pim.common.action.SysBaseAction;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;

/**
 * @description:流程表单 Action层
 * @author:gzh
 * @date:2016-03-03
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("privilegeStack")
@ResultPath("/WEB-INF/mybi")
@Action(
	    results={
	    	@Result(name="FORM_STEP1", location="demo/stepform/demo_stepform-step1.jsp"),
	    	@Result(name="FORM_STEP2", location="demo/stepform/demo_stepform-step2.jsp"),
	    	@Result(name="FORM_STEP3", location="demo/stepform/demo_stepform-step3.jsp")
	    }
)
public class Demo_stepFormAction extends SysBaseAction {

	private static final long serialVersionUID = -4868448875899684228L;
	
	// 步骤数
	private String step;
	
	// 用户对象
	private Demo_user userObj;
	
	// 流程表单Service
	@Autowired
	private Demo_stepFormService demo_stepFormService;
	
	/**
	 * @description:流程表单转向控制
	 * @return:
	 */
	public String stepFormController() {
		return "FORM_STEP" + step;
	}
	
	/**
	 * @description:保存用户对象
	 * @return:
	 */
	public String saveUserObj() {
		String id = UUID.randomUUID().toString().replace("-", "");
		userObj.setId(id);
		userObj.setModuid(((Pim_sysUser)session.getAttribute("loginUserObj")).getId());
		JSONObject jsonObj = new JSONObject();
		try{
			demo_stepFormService.saveUserObj(userObj);
			jsonObj.put("result", "succ");
			jsonObj.put("callbackCondition", id);
		}catch(Exception e){
			e.printStackTrace();
			jsonObj.put("result", "fail");
		}
		Struts2Utils.renderText(jsonObj.toString());
		
		return NONE;
	}

	public String getStep() {
		return step;
	}

	public void setStep(String step) {
		this.step = step;
	}

	public Demo_user getUserObj() {
		return userObj;
	}

	public void setUserObj(Demo_user userObj) {
		this.userObj = userObj;
	}
	
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
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.demo.stepform.service;

import com.mingyoutech.mybi.demo.stepform.domain.Demo_user;

/**
 * @description:流程表单 Service接口层
 * @author:gzh
 * @date:2016-03-03
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Demo_stepFormService {
	
	/**
	 * @description:添加用户对象
	 * @param:obj 用户对象
	 * @return:
	 */
	public void saveUserObj(Demo_user obj);
	
}

</pre>
		<h2>ServiceImpl</h2>
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.demo.stepform.service.impl;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.mybi.demo.stepform.domain.Demo_user;
import com.mingyoutech.mybi.demo.stepform.service.Demo_stepFormService;

/**
 * @description:流程表单 Service实现层
 * @author:gzh
 * @date:2016-03-03
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@SuppressWarnings("unchecked")
@Service
public class Demo_stepFormServiceImpl extends BaseServiceImpl&lt;Demo_user> implements
		Demo_stepFormService {
	
	/**
	 * @description:添加用户对象
	 * @param:obj 用户对象
	 * @return:
	 */
	@Override
	public void saveUserObj(Demo_user obj) {
		this.update("com.mingyoutech.mybi.demo.stepForm.domain.Demo_user.saveUserObj", obj);
	}

}

</pre>
		</div>
		<div class="tabcontent" title="SQL-Map">
<pre class="brush:xml;">
&lt;?xml version="1.0" encoding="UTF-8" ?>
&lt;!--Copyright (c) MINGYOUTECH Co. Ltd.-->
&lt;!DOCTYPE mapper PUBLIC 
    "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

&lt;mapper namespace="com.mingyoutech.mybi.demo.stepForm.domain.Demo_user">
	
	&lt;!-- 添加CRUD -->
	&lt;insert id="saveUserObj" parameterType="Demo_user">
		INSERT INTO tp_demo_crud(
			id,nam,orgidt,moduid,modate,remark,phone_num,address,position,birthday
		)VALUES(
			\#{id},\#{nam},\#{orgidt,jdbcType=VARCHAR},\#{moduid},sysdate,\#{remark,jdbcType=VARCHAR},
			\#{phoneNum,jdbcType=VARCHAR},\#{address,jdbcType=VARCHAR},
			\#{position,jdbcType=VARCHAR},\#{birthday,jdbcType=NUMERIC}
		)
	&lt;/insert>
	
&lt;/mapper>
</pre>
		</div>
	</div>
</div>

</body>
</html>