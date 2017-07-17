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
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	$(function(){
		// 初始化页面元素及表单验证
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		// 方案类型下拉列表初始化
		$("#schemeType").combo({
			mode : "local",
			data : [{text:"<s:text name='gdp_common_varLength'/>",value:"0"}, // 单个方案
			        {text:"<s:text name='gdp_common_varLengthGroup'/>",value:"1"}, // 复合方案
					{text:"<s:text name='gdp_common_erms'/>",value:"2"},
					{text:"定长表方案",value:"3"}], //ERMS报表方案
			panelHeight : 110,
			onSelect : function(item){
				// 选择定长的时候显示单元输入框,否则隐藏;
				if (item.value == "3") {
					$("#unitInputDiv").show();
					$("#unit").unFormValidator(false);
				}else {
					$("#unitInputDiv").hide();
					$("#unit").unFormValidator(true);
				}
			}
		});
		// 所属分类下拉列表初始化
		$("#classId").combo({
			mode : "local",
			data : ${request.classList},
			isCustom : true,
			customData : [{classId : "", className : "<s:text name='gdp_common_pleaseSelect'/>"}],
			textField : "className",
			valueField : "classId",
			panelHeight : 150
		});
		// 动作列表下拉初始化
		$("#actcde").combo({
			comboType : "normal-multi",
			mode : "local",
			data : ${request.actList},
			textField : "ACTNAM",
			valueField : "ACTCDE",
			panelWidth : 200
		});
		// 表单验证初始化
		$.formValidator.initConfig({formID:"form_input",
			onError:function(){
				return false;
			},
			onSuccess:function(){
				// 参数对象
				var paramObj = {
					"schemeObj.schemeName" : $.trim($("#schemeName").val()),
					"schemeObj.schemeType" : $("#schemeType").combo("getValue"),
					"schemeObj.unit" : $("#schemeType").combo("getValue")!="2"?null:$.trim($("#unit").val()),
					"schemeObj.schemeDesc" : $.trim($("#schemeDesc").val()),
					"schemeObj.classId" : $("#classId").combo("getValue"),
					"schemeObj.dateType" : $("#dateType .option_selected").attr("val"),
					"interconfObj.actcde" : $("#actcde").combo("getValues").join(),
					"interconfObj.fqName" : $.trim($("#fqName").val())
				}
				// 开启蒙板层
				add_onload();
				$.post("${ctx}/gdp_scheme!saveSchemeObj.action",paramObj,function(data){ 
					// 关闭蒙板层
					clean_onload();
					if(data.result=="succ"){
						// 回显刚才操作的记录
						parent.findListById(data.callbackCondition);	
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',clsWin);
					}else if(data.result=="fail"){
						$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
					}
			    },"json");
			}
		});
		// 方案名称不能为空
		$("#schemeName").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"});
		// 单位非空正整数
		$("#unit").formValidator().inputValidator({min:1,onError:"<s:text name='gdp_common_cannotBeEmpty'/>"})
			.regexValidator({regExp:"^[1-9]\\d*$",onError:"<s:text name='gdp_common_mustInteger'/>"});
		// 方案描述不可超过100个字符
		$("#schemeDesc").formValidator().inputValidator({max:100,onError:"<s:text name='gdp_common_noMoreThan'><s:param>100</s:param></s:text>"});
		// 不选择定长时不验证
		$("#unit").unFormValidator(true);
	}
	
	// 表单提交
	function sbt(){
		$("#form_input").submit();
	}
	
	// 关闭当前窗口
    function clsWin(){
    	parent.$("#inputWin").window('close');
    }
	
</script>
</head>
<body>

<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<!-- 方案名称 -->
					<li class="desc" style="width:120px;"><b>* </b><s:text name="gdp_scheme_schemeName"/>：</li>
					<li><input id="schemeName" name="schemeName" maxlength="50" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="schemeNameTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 方案类型 -->
					<li class="desc" style="width:120px;"><s:text name="gdp_scheme_schemeType"/>：</li>
					<li><input id="schemeType" name="schemeType" style="width:160px;"/></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 所属分类 -->
					<li class="desc" style="width:120px;"><s:text name="gdp_scheme_belongClass"/>：</li>
					<li><input id="classId" name="classId" style="width:160px;"/></li>
				</ul>
			 </div>
			 <div class="item">
			 	<ul><li class="desc" style="width:120px;"><s:text name="gdp_scheme_dateType"/>：</li></ul>
				<ul id="dateType" class="seltile">
					<!-- 数据日期类型 -->
					<li class="option_selected" val="0" ><s:text name="gdp_scheme_byDay"/></li>
					<li class="option" val="1" ><s:text name="gdp_scheme_byMonth"/></li>
				</ul>
			 </div>
			 <div class="item" id="unitInputDiv" style="display:none;">
				<ul>
					<!-- 定长时单位 -->
					<li class="desc" style="width:120px;"><b>* </b><s:text name="gdp_scheme_unit"/>：</li>
					<li><input id="unit" name="unit" value="1" maxlength="10" class="myui-text" style="width:160px;"/></li>
					<li class="tipli"><div id="unitTip"></div></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 拦截动作 -->
					<li class="desc" style="width:120px;"><s:text name="gdp_scheme_interceptAct"/>：</li>
					<li><input id="actcde" name="actcde" style="width:160px;"/></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 处理类全限定名 -->
					<li class="desc" style="width:120px;"><s:text name="gdp_scheme_fqName"/>：</li>
					<li><input id="fqName" name="fqName" class="myui-text" maxlength="200" style="width:160px;"/></li>
				</ul>
			 </div>
			 <div class="item">
				<ul>
					<!-- 方案描述 -->
					<li class="desc" style="width:120px;"><s:text name="gdp_scheme_schemeDesc"/>：</li>
					<li><textarea id="schemeDesc" name="schemeDesc" class="myui-textarea" style="width:160px;"></textarea></li>
					<li class="tipli"><div id="schemeDescTip"></div></li>
				</ul>
			 </div>
		 </form>
	</div>
	<div class="operate">
		<!-- 提交 -->
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<!-- 取消 -->
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>
