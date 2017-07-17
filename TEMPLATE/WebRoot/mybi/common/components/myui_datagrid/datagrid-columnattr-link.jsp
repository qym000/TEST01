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
	var v_moObj;
	$(function(){
		v_winParam = parent.window.v_winParam;
		
		if(v_winParam.link) {
			v_moObj = JSON.parse(v_winParam.link);
		}
		
		initParam(v_moObj);
		
	});
	
    function initParam(p_obj){
    	var d_addcoltr = $('<tr class="addParamtr"></tr>').appendTo($('.chkbody table'));
		var d_addcoltd = $('<td colspan=3 style="text-align:center"><span class="addParam"><i class="fa fa-plus-square fa-lg"></i>&nbsp;添加参数</span></td>').appendTo(d_addcoltr);
		$(d_addcoltd).find('span').click(function(){
			addParam();
		})
	/*	$("#query").popselector({
			type : "radio",
			oneLineCount : 2,
			url : '${ctx}/query_online!getQuery.action',
		    valueField : 'id',
		    textField : 'name',
		    winTop : '0px',
		    winHeight : 215,
		    searchable : true
		});  */
		
		var v_defval;
		if(p_obj) {
			v_defval = p_obj.query;
		}
		$("#query").combo({
			url : '${ctx}/query_online!getQuery.action',
		    valueField : 'id',
		    textField : 'name',
		    defaultValue : v_defval
		});
		
		if(p_obj) {
			$(p_obj.params).each(function(v_idx, v_obj){
				addParam(v_obj);
			})
		}
    }
    
    function addParam(p_paramobj){
    	var d_tr = $('<tr class="paramTr"><td class="name"></td><td class="value"></td><td class="oper"></td></tr>');
    	$('.addParamtr').before($(d_tr));
    	var v_colseq = Math.floor(Math.random()*10000);
    	var d_parnam = $('<input class="myui-text parnam" id="parnam'+v_colseq+'">').appendTo($(d_tr).find('.name'));
    	var d_parval = $('<input class="myui-text parval" id="parval'+v_colseq+'">').appendTo($(d_tr).find('.value'));
    	var d_pardel = $('<i class="fa fa-minus-square pardel"></i>').appendTo($(d_tr).find('.oper'));
    	$(d_parval).combo({
			    mode : "local",
			    data : v_winParam.collist,
			    panelHeight : 90,
			    isCustom : true,
			    valueField : 'name',
			    textField : 'desc'
			});
    	
    	$(d_pardel).click(function(){
    		$(this).parent().parent().remove();
    	})
    	
    	
    	if(p_paramobj) {
    		$(d_parnam).val(p_paramobj.name);
    		$(d_parval).combo('setValue', p_paramobj.col);
    	}
    }
	
    function getForm(){
    	var v_query = $('#query').combo('getValue');
    	if(!v_query || v_query == ''){
			$.messager.alert('<s:text name="common_msg_info"/>','请选择链接查询','info'); //操作失败
			return false;
		}
    	var v_link_param = [];
    	var v_isvalidparam = false;
    	
    	$('.chkbody table').find('.paramTr').each(function(v_idx){
    		var v_paramname = $(this).find('.parnam').val();
    		var v_paramcol = $(this).find('.parval').combo('getValue');
    		if(!v_paramname || v_paramname == ''){
    			$.messager.alert('<s:text name="common_msg_info"/>','第'+(v_idx + 1)+'行参数名称不能为空','info'); //操作失败
    			v_isvalidparam = true;
    			return false;
    		}
    		v_link_param.push({
    			name  : v_paramname, 
    			col   : v_paramcol
    		})
    	})
    	if(v_isvalidparam) {
    		return false;
    	}
    	
    	return {
    		 query  : v_query,
    		 colidx : v_winParam.colidx,
    		 params : v_link_param
    	}
    	
    }
    
</script>
<style type="text/css">
.myui-form{height: 270px;overflow-x:auto}
.chkbody{width: 450px;padding: 10px 0px 0 20px}
.chkbody table{border-collapse: collapse;width: 450px;}
.chkbody table tr{border: 1px solid #CCC;}
.chkbody table td{vertical-align:middle;text-align: left;color:#333;height: 30px;font-family:"微软雅黑";font-size: 14px;padding-left: 10px;border:1px solid #E0DFDF;}
.chkbody table th{background-color: #EEE;color:#666;height: 25px;font-family:"微软雅黑";font-size: 14px;}
.chkbody table .title .name{width:170px}
.chkbody table .title .value{width:230px}	
.addParam,.pardel{color:#374fff;cursor: pointer;}
.paramTr td .parnam{width:150px}
.paramTr td .parval{width:210px}
.col-tips{font-size: 9px;margin: 0 0 5px 10px}
</style>
</head>
<body>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			<div class="item">
				<ul>
					<li class="desc">链接查询：</li>
					<li><input id="query" name="query" class="myui-text"/></li>
				</ul>
			 </div>
			 <div class="chkbody">
			 	<div class="col-tips"><i class="fa fa-lightbulb-o fa-2x"></i>&nbsp;提示:参数名称请与链接查询中的字段名称相同</div>
				<table>
					<tr class="title">
						<th class='name'>参数名称</th>
						<th class='value'>参数值</th>
						<th class='oper'>操作</th>
					</tr>
				</table>
			 </div>
			 
		 </form>
	</div>
</div>
</body>
</html>