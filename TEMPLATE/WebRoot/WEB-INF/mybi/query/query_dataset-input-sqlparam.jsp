<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.all-3.2.min.js"></script>
<script type="text/javascript">

	//字段值信息
	var v_colval;
	
	//window传来的参数
	var v_winParam;
	
	function sbt(){
		var v_rst = new Array();
		$('#collist table tbody .data').each(function(){
			v_rst.push({
				param   : $(this).find('.param').html(),
				desc    : $(this).find('.desc input').val(),
				defval  : $(this).find('.defval input').val()
			});
		})
		parent.window.v_sqlparam_arr = v_rst;
		clsWin();
	}
	
	$(function(){
		var v_opts = parent.$('#setSqlParamWin').window('options');
		v_winParam  = v_opts.param;
		for(var i=0; i< v_winParam.length; i++) {
			var d_tr = $('<tr class="data"></tr>').appendTo($('#collist table tbody'));
			var v_defval = v_winParam[i].defval;
			if (!v_defval) {
				v_defval = '';
			}
			var v_param_defvalid = 'param_defval' + i;
			$(d_tr).append($('<td class="param">'+v_winParam[i].param+'</td><td class="desc"><input class="myui-text" value="'+v_winParam[i].desc+'"/></td><td class="defval"><input id="'+v_param_defvalid+'" class="myui-text" value="'+v_defval+'"/></td>'));
			
			var d_sysparamwin  =$('&nbsp;<i class="fa fa-cog"></i>').appendTo($(d_tr).find('.defval'));
			$(d_sysparamwin).click(function(){
				var v_tmpparam = {id  : $(this).parent().find('.myui-text').attr('id'),
						          val : $(this).parent().find('.myui-text').val()}
				$("#systemParamWin").window({
					open : true,
					param : v_tmpparam,
					headline:'选择系统参数',
					content:'<iframe id="systemParamFreame" src="${ctx}/mybi/common/components/myui_datagrid/datagrid-systemParam.jsp" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
					panelWidth:250,
					top : "10",
					panelHeight:220
				});
			})
			
		}
	})
	
	//关闭当前窗口
    function clsWin(){
    	parent.$('#setSqlParamWin').window('close');
    }
	
</script>
<style>
#collist {margin-top: 10px;}
#collist table{width:420px;}
#collist table .myui-text{width: 160px}
#collist table tr .param{width: 150px}
#collist table tr .desc{width: 250px}
.fa{color:#374fff;cursor: pointer;}
</style>
</head>
<body>
<div id="systemParamWin"></div>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="myui-datagrid" id="collist">
				<table>
					<tbody>
						<tr>
						    <th>参数</th>
						    <th>描述</th>
						    <th>默认值</th>
						</tr>
					</tbody>
				</table>
			</div>
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" enter="false" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button cancel" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
</body>
</html>