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
		var v_opts = parent.$('#showTableJoinWin').window('options');
		v_winParam  = v_opts.param;
		
		//初始化添加按钮
		var d_addtr = $('<tr class="addTabJointr"></tr>').appendTo($('.chkbody table'));
		$(d_addtr).append($('<td colspan="4" style="text-align:center"><span class="addTabJoin"><i class="fa fa-plus-square fa-lg"></i>&nbsp;添加表关联关系</span></td>'));
		$(d_addtr).find('.addTabJoin').click(function(){
			toAddTabJoin();
		});
		if(v_winParam.joinCols){
			$(JSON.parse(v_winParam.joinCols)).each(function(idx, obj){
				createTabJoinRow(obj);
			})
		}
	});
	
	function toAddTabJoin(p_obj){
		var v_param = {
				"editObj"  :  p_obj,
				"joinTabs" :  v_winParam.joinTabs
		}
		$("#addTabJoinWin").window({
			open : true,
			headline:'添加关联信息',
			param : v_param,
			content:'<iframe id="myframe" src="${ctx}/query_online!toAddTableJoin.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			top : 0,
			panelWidth:600,
			panelHeight:400
		}); 
	}
	
	/**
	 * 参数格式： {"tab1nam":"TP_PIM_ORG","tab1col":"ORGIDT","tab2nam":"TP_PIM_USER","tab2col":"ORGIDT","jointype":"inner"}
	 *
	 */
	function createTabJoinRow(joinObj){
		$.post('${ctx}/query_dataset!getDatasetNamAndColnam.action', {"query_dataset.id" : joinObj.tab1qsid,"query_dataset.src" : joinObj.tab1col, "query_dataset1.id" : joinObj.tab2qsid,"query_dataset1.src" : joinObj.tab2col}, function(data){
			var jsondata = JSON.parse(data);
			if(jsondata.result == 'succ'){
				
				var d_tabjointr = $('<tr class="tabJointr"></tr>');
				$('.chkbody table .addTabJointr').before($(d_tabjointr));
			 	$(d_tabjointr).append('<td class="tab1"></td><td  class="tab2"></td><td  class="joinType"></td><td  class="oper"></td>');
			 	var v_param = $.extend(jsondata, joinObj);
				saveOrUpdaterow(v_param, d_tabjointr);
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','获取信息失败','error', function(){
					clsWin();
				});
			}
		})
	}
	
	 function updateTabJoinRow(p_joinObj, p_dataidx){
		 var d_tabjointr = $('#form_input table tr').eq(p_dataidx);
		 $(d_tabjointr).empty();
		 $(d_tabjointr).append('<td class="tab1"></td><td  class="tab2"></td><td  class="joinType"></td><td  class="oper"></td>');
		 saveOrUpdaterow(p_joinObj, d_tabjointr);
	 }
	 
	 function saveOrUpdaterow(p_joinObj, d_tabjointr){
			$(d_tabjointr).find('.tab1').attr('tab1qsid', p_joinObj.tab1qsid);
			$(d_tabjointr).find('.tab2').attr('tab2qsid', p_joinObj.tab2qsid);
			$(d_tabjointr).find('.tab1').attr('tab1col', p_joinObj.tab1col);
			$(d_tabjointr).find('.tab2').attr('tab2col', p_joinObj.tab2col);
			$(d_tabjointr).find('.tab1').append(p_joinObj.tab1des + "(" + p_joinObj.tab1coldes + ")");
			$(d_tabjointr).find('.tab2').append(p_joinObj.tab2des + "(" + p_joinObj.tab2coldes + ")");
			var jointypestr = "内连接";
			var jointype = "inner";
			
			if (p_joinObj.jointype == 'left'){
				jointypestr = "左外连接"
			}else if (p_joinObj.jointype == 'right'){
				jointypestr = "右外连接"
			}
			
			$(d_tabjointr).find('.joinType').append('<span>'+jointypestr+'</span>');
			$(d_tabjointr).find('.joinType').val(p_joinObj.jointype);
			
			var conEditImg = $('<i class="fa fa-edit  fa-lg"></i>').appendTo($(d_tabjointr).find('.oper'));
			$(d_tabjointr).find('.oper').append('&nbsp;');
			
			$(conEditImg).click(function(){
				var v_cur_tr = $(this).parent().parent();
				var v_obj = {
					"tab1qsid" : $(v_cur_tr).find('.tab1').attr('tab1qsid'),
					"tab1col"  : $(v_cur_tr).find('.tab1').attr('tab1col'),
					"tab2qsid" : $(v_cur_tr).find('.tab2').attr('tab2qsid'),
					"tab2col"  : $(v_cur_tr).find('.tab2').attr('tab2col'),
					"jointype" : $(v_cur_tr).find('.joinType').attr('value'),
					"dataidx"  : $(v_cur_tr).index()
				}
				toAddTabJoin(v_obj);
			})
			
			var conDelimg = $('<i class="fa fa-trash  fa-lg"></i>').appendTo($(d_tabjointr).find('.oper'));
			$(conDelimg).click(function(){
				$(this).parent().parent().remove();
			})
	 }
	 
	 function sbt(){
		 var v_joinArr = [];
		 $('.tabJointr').each(function(){
			 v_joinArr.push({
				"tab1qsid" : $(this).find('.tab1').attr('tab1qsid'),
			 	"tab2qsid" : $(this).find('.tab2').attr('tab2qsid'),
			 	"tab1col"  : $(this).find('.tab1').attr('tab1col'),
			 	"tab2col"  : $(this).find('.tab2').attr('tab2col'),
			 	"jointype" : $(this).find('.joinType').val()
			 })
		 })
		 
		 var v_rst = {
			 "tableJoin" :　JSON.stringify(v_joinArr)
		 }
		 parent.window.updateTableJoin(v_rst);
		 clsWin();
	 }
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#showTableJoinWin').window('close');
    }
</script>
<style type="text/css">
.chkbody{width: 698px;padding: 10px 10px 0 10px}
.chkbody table{border-collapse: collapse;width: 678px;}
.chkbody table tr{border: 1px solid #CCC;}
.chkbody table td{vertical-align:middle;text-align: left;color:#333;height: 30px;font-family:"微软雅黑";font-size: 14px;padding-left: 10px;border:1px solid #E0DFDF;}
.chkbody table th{background-color: #EEE;color:#666;height: 25px;font-family:"微软雅黑";font-size: 14px;}
.addTabJoin{color:#374fff;cursor: pointer;}
i{cursor: pointer;}
i:hover{color:red}
</style>
</head>
<body>
<div id="addTabJoinWin"></div>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
			<div class="chkbody">
				<table>
					<tr class="title">
						<th class='tab1'>关联表1(字段)</th>
						<th class='tab2'>关联表2(字段)</th>
						<th class='joinType'>关联方式 </th>
						<th class='oper'>操作 </th>
					</tr>
				</table>
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