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
	
	//字段列表，逗号隔开
	var v_allcolstr;
	
	//字段类型列表，逗号隔开
	var v_allcoltypstr;
	
	$(function(){
		initColum();
	});
	
	function initColum(){
		var opts = parent.parent.parent.$('.myui-datagrid2').datagrid2('options');
		var allcol = opts.allColumns;
		
		for(var i=0;i<allcol.length;i++){
			var col = allcol[i];
			if(!col.checkbox && !col.hidden && !col.expr){
				v_allcolstr += "," + col.field;
				v_allcoltypstr += "," +　col.datatype;
				var tmpli = $("<li></li>").appendTo($(".collist"));
				$(tmpli).append("<i class='fa fa-plus-square'></i>&nbsp<label class='col' name='"+col.field+"'>"+col.title+"</label>");
				$(tmpli).bind("click",function(){
					var v_fil = $(this).find('.col').attr('name') + " ";
					if($('.cust_colVal').hasClass('cust_col_blank')){
						$('.cust_colVal').val(v_fil);
						$('.cust_colVal').removeClass('cust_col_blank');
					}else{
						$('.cust_colVal').val($('.cust_colVal').val() + v_fil);
					}
				});
			}
		}
		
		var colVal = $('.cust_colVal').val();
		if(!$('.cust_colVal').val() || $('.cust_colVal').val() == ''){
			$('.cust_colVal').val('请在此处编写公式，也可以点击左侧字段加入字段...');
			$('.cust_colVal').addClass('cust_col_blank');
		}
		
		$('.cust_colVal').focus(function(){
			if($(this).hasClass('cust_col_blank')){
				$(this).val('');
				$(this).removeClass('cust_col_blank');
			}
		});
		
		$('.cust_colVal').blur(function (){
			if($(this).val() == ''){
				$(this).val('请在此处编写公式，也可以点击左侧字段加入字段...');
				$('.cust_colVal').addClass('cust_col_blank');
			}else{
				$(this).removeClass('cust_col_blank');
			}
		});
		
		$("#datatype").combo({
		    mode : "local",
		    data : [{"key":"string","value":"字符串"},{"key":"number","value":"数字"},{"key":"date","value":"日期"}],
		    panelHeight : 90,
		    valueField : 'key',
		    textField : 'value'
		});
		
		var v_opts = parent.$('#addCustomColWin').window('options');
		v_winParam  = v_opts.param;
		if(v_winParam){
			if (v_winParam.val) {
				$('.cust_colVal').val(v_winParam.val);
				$('.cust_colVal').removeClass('cust_col_blank');
			}
		}
	}
	
	function sbt(){
		var v_val = $('.cust_colVal').val();
		if($('.cust_colVal').hasClass('cust_col_blank') || v_val == ''){
			$.messager.alert('<s:text name="common_msg_info"/>', '公式不能为空','info');
			return false;
		}
		
		$.post("${ctx}/query_online!validCustColExpr.action", {custCol_allColstr:v_allcolstr,custCol_expr:v_val,custCol_allColtypstr:v_allcoltypstr},function(data){
			var jsondata = JSON.parse(data);
			if(jsondata.result == 'succ'){
				parent.$('#'+v_winParam.id).val(v_val);
				clsWin();
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','公式配置有问题，请检查公式（参照提示）','error', function(){
				});
			}
		});
		
		
	}
	
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#addCustomColWin').window('close');
    }
</script>
<style type="text/css">
.form{width:500px;border:0px}
.myui-layout{padding-left:10px;border:0px;margin-top: 10px}
.myui-layout .content .cust_colVal{width: 99%;height:99%;border: 0px;font-size: 14px;font-family: "微软雅黑";text-indent:3px;}
.cust_col_blank{color:#CCC;font-size: 14px;}
.myui-layout .collist{margin-top: 5px}
.myui-layout .collist li{padding-top: 5px;padding-left: 5px;cursor: pointer;}
.myui-layout .collist li label{cursor: pointer;}
.myui-layout .collist li:hover{background-color: #E0ECFF;border-color: #E0ECFF;}
.exprTip{position: absolute;left:300px;top:18px}
.exprTip i{font-size: 18px;cursor: pointer;z-index: 100}
.exprTip i:HOVER{color:red}
</style>
</head>
<body>
<!-- 处理焦点问题，勿删除 -->
<input type="text" style="display: none"/>
<div class="exprTip"><i class="fa fa-question-circle fa-la myui-tooltip" content="公式编辑窗口<br>支持 + - * /操作,eg.COL1+COL2<br>支持||字符串拼接,eg.COL1||COL2<br>(请点击左侧字段添加字段)"></i></div>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
		 
			<div class="myui-layout">
				<div class="rowgroup">
					<div class="content" headline="字段" style="width: 200px;height: 200px">
						<ul class="collist">
						</ul>
					</div>
					<div class="content" headline="公式编辑" style="width: 270px;height: 200px">
						<textarea class="cust_colVal" class="myui-text"></textarea>						
					</div>
				</div>
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