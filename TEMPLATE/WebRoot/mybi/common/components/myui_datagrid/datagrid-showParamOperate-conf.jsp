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
	//关闭当前窗口
    function clsWin(){
    	parent.$('#showParamOperateConfWin').window('close');
    }
	
	var v_colid;
	
	$(function(){
		var v_opts = parent.$('#showParamOperateConfWin').window('options');
		v_colid  = v_opts.param;
		var v_colli = parent.$('#' + v_colid).parent();
		var v_partyp = $(v_colli).children('.paramType').val();
		var v_partypdesc = $(v_colli).children('.paramType').find("option:selected").text();
		var v_colinput = $(v_colli).children('.col');
		var v_colname = $(v_colinput).attr('name');
		var v_coldesc = $(v_colinput).attr('value');
		
		var d_formobj = $('#form_input');
		
		//条件字段以及控件类型区域
		var d_item1 = $('<div class="item"></div>').appendTo(d_formobj);
		var d_itemul1 = $('<ul></ul>').appendTo(d_item1);
		d_itemul1.append('<li class="desc"  style="width:80px;">条件字段：</li>');
		d_itemul1.append('<li><input disabled=true value="'+v_coldesc+'" style="width:150px;" class="myui-text"/></li>');
		d_itemul1.append('<li class="desc"  style="width:80px;">控件类型：</li>');
		d_itemul1.append('<li><input disabled=true value="'+v_partypdesc+'" style="width:150px;" class="myui-text"/></li>');
		
		//别名以及默认值区域
		var d_item2 = $('<div class="item"></div>').appendTo(d_formobj);
		var d_itemul2 = $('<ul></ul>').appendTo(d_item2);
		d_itemul2.append('<li class="desc"  style="width:80px;">别名：</li>');
		var d_itemul2alias = $('<li><input id="alias" value="'+v_coldesc+'" style="width:150px;" class="myui-text"/></li>').appendTo(d_itemul2);
		d_itemul2.append('<li class="desc"  style="width:80px;">默认值：</li>');
		
		var d_itemul2defaultVal = $('<li><input id="defaultVal" style="width:150px;" class="myui-text"/></li>').appendTo(d_itemul2);
		var d_sysparamwin  =$('<li>&nbsp;<i class="fa fa-cog"></i></li>').appendTo(d_itemul2);
		$(d_sysparamwin).click(function(){
			$("#systemParamWin").window({
				open : true,
				param : {id : 'defaultVal', val : $('#defaultVal').val()},
				headline:'选择系统参数',
				content:'<iframe id="systemParamFreame" src="${ctx}/mybi/common/components/myui_datagrid/datagrid-systemParam.jsp" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:250,
				top : "10",
				panelHeight:220
			});
		})
		
		if(v_partyp == 'date'){
			$(d_itemul2defaultVal).find('input').datebox();			
		}
		
		//设置别名的默认值
		if($(v_colinput).attr('alias')){
			$(d_itemul2alias).find('input').val($(v_colinput).attr('alias'));
		}
		
		//设置默认值的默认值
		if($(v_colinput).attr('defaultVal')){
			$(d_itemul2defaultVal).find('input').val($(v_colinput).attr('defaultVal'));
		}
		
		if(v_partyp == 'select' || v_partyp =='popradio' ||　v_partyp == 'popcheckbox'){
			createSelectArea($(v_colinput).attr('valtyp'), $(v_colinput).attr('ctrlValue'));
		}else if (v_partyp == 'poptree-radio' ||　v_partyp == 'poptree-checkbox'){
			createTreeArea( $(v_colinput).attr('ctrlValue'));
		}
		
	});
	
	//创建选择区域
	function createTreeArea(p_ctrlValue){
		var d_formobj = $('#form_input');
		$('.spclConfArea').remove();
		var v_spclConfArea = $('<div class="spclConfArea" style="margin: auto;text-align:center;"></div>').appendTo(d_formobj);
		
		var d_item3 = $('<div class="item"></div>').appendTo(v_spclConfArea);
		var d_itemul3 = $('<ul></ul>').appendTo(d_item3);
		var d_itemulli3 = $('<li style="margin-left:25px;margin-bottom:5px"></li>').appendTo(d_itemul3);
		$(d_itemulli3).append('sql:');
		
		
		var v_sqlarea = $('<div class="sqlarea"><textarea id="param_sql" maxlength="80" class="myui-textarea" style="width:450px;height:120px;"></textarea></div>');
		var v_sqlcolarea = $('<div class="item"></div>');
		/*var v_sqlcolareaul = $('<ul></ul>').appendTo(v_sqlcolarea);
		v_sqlcolareaul.append('<li class="desc"  style="width:60px;">ID：</li>');
		v_sqlcolareaul.append('<li><input style="width:90px;"  id="param_sqlid" class="myui-text"/></li>');
		v_sqlcolareaul.append('<li class="desc"  style="width:60px;">显示值：</li>');
		v_sqlcolareaul.append('<li><input style="width:90px;"  id="param_sqlname"  class="myui-text"/></li>');
		v_sqlcolareaul.append('<li class="desc"  style="width:60px;">父ID：</li>');
		v_sqlcolareaul.append('<li><input style="width:90px;"  id="param_sqlpid"  class="myui-text"/></li>');*/
		$(v_spclConfArea).append(v_sqlarea); 
//		$(v_spclConfArea).append(v_sqlcolarea);
		
		setSelectValue("tree", p_ctrlValue);
	}
	
	function setSelectValue(p_type, p_ctrlValue){
		
			//设置定值选项默认值
			if(p_ctrlValue){
				var v_ctrlValue = JSON.parse(p_ctrlValue);
				$(v_ctrlValue).each(function() {
					var v_obj = $(this)[0];
					if(p_type == 'sql'){
						$('.spclConfArea').find('#param_sql').val(v_obj.sql);
						$('.spclConfArea').find('#param_sqlkey').val(v_obj.sqlkey);
						$('.spclConfArea').find('#param_sqlvalue').val(v_obj.sqlvalue);
					}else if(p_type == 'tree'){
						$('.spclConfArea').find('#param_sql').val(v_obj.sql);
						$('.spclConfArea').find('#param_sqlid').val(v_obj.treeid);
						$('.spclConfArea').find('#param_sqlname').val(v_obj.treename);
						$('.spclConfArea').find('#param_sqlpid').val(v_obj.treepid);
					}else if(v_obj.key){
						addLocalTabRow(v_obj.key, v_obj.value);
					}
				});
			}
	}
	
	//创建选择区域
	function createSelectArea(p_type, p_ctrlValue){
		var d_formobj = $('#form_input');
		$('.spclConfArea').remove();
		var v_spclConfArea = $('<div class="spclConfArea" style="margin: auto;text-align:center;"></div>').appendTo(d_formobj);
		var d_item3 = $('<div class="item"></div>').appendTo(v_spclConfArea);
		var d_itemul3 = $('<ul></ul>').appendTo(d_item3);
		var d_itemulli3 = $('<li style="margin-left:25px;margin-bottom:5px"></li>').appendTo(d_itemul3);
		var valtyplocal = $('<INPUT type="radio" id="valtyplocal" name="valtyp" value="local">');
		var valtypsql = $('<INPUT type="radio" id="valtypsql" name="valtyp" value="sql">');
		$(d_itemulli3).append(valtyplocal);
		$(d_itemulli3).append('&nbsp;定值&nbsp;&nbsp;&nbsp;&nbsp;');
		$(d_itemulli3).append(valtypsql);
		$(d_itemulli3).append('&nbsp;sql');
		
		$(v_spclConfArea).find('input[name="valtyp"]').change(function(){
			createSelectArea($(this).val());
			setSelectValue($(this).val(), parent.$('#' + v_colid).parent().children('.col').attr('ctrlValue'));
		});
		
		if(p_type && p_type == 'sql'){
			$(valtypsql).attr("checked",'checked');
			
			var v_sqlarea = $('<div class="sqlarea"><textarea id="param_sql" maxlength="80" class="myui-textarea" style="width:450px;height:120px;"></textarea></div>');
			var v_sqlcolarea = $('<div class="item"></div>');
			var v_sqlcolareaul = $('<ul></ul>').appendTo(v_sqlcolarea);
			v_sqlcolareaul.append('<li class="desc"  style="width:80px;">实际值：</li>');
			v_sqlcolareaul.append('<li><input style="width:150px;"  id="param_sqlkey"  class="myui-text"/></li>');
			v_sqlcolareaul.append('<li class="desc"  style="width:80px;">显示值：</li>');
			v_sqlcolareaul.append('<li><input style="width:150px;"  id="param_sqlvalue"  class="myui-text"/></li>');
			$(v_spclConfArea).append(v_sqlarea);
			$(v_spclConfArea).append(v_sqlcolarea);
		}else{
			$(valtyplocal).attr("checked",'checked');
			var v_dg = $('<div class="myui-datagrid"><table  style="width:450px"><tr></tr></table></div>');
			var v_dgtable = $(v_dg).find('table');
			var v_dgtr = $(v_dg).find('tr');
			$(v_dgtr).append('<th width="210px">实际值</th>');
			$(v_dgtr).append('<th>显示值</th>');
			
			var v_dgoptr = $('<tr class="dgplustr"><td colspan=2></td></tr>');
			var v_dgoptrplus = $("<span class='add_staticval'><i class='fa fa-plus-square fa-lg'></i>&nbsp添加值</span>");
			$(v_dgoptr).children('td').append(v_dgoptrplus);
			$(v_dgtable).append(v_dgoptr);
			$(v_dgoptrplus).click(function(){
				var idx = $('.myui-datagrid').find('tr').length - 1 ;
				addLocalTabRow('key' + idx, 'value' + idx);
			});
			$(v_spclConfArea).append(v_dg);
		}

		setSelectValue(p_type, p_ctrlValue);
	}
	
	//添加定值选项
	function addLocalTabRow(p_key, p_value){
		var v_dgaddtr = $('<tr name="localSel"></tr>');
		var v_dgaddtdkey = $('<td></td>');
		var v_dgaddtdval = $('<td></td>');
		v_dgaddtr.append(v_dgaddtdkey);
		v_dgaddtr.append(v_dgaddtdval);
		var v_dgoptrminus = $('<i class="fa fa-trash  fa-lg"></i>');
		$(v_dgaddtdkey).append('<input type="text" name="localkey" value="'+p_key+'"  class="myui-text">');
		$(v_dgaddtdval).append('<input type="text" name="localval" value="'+p_value+'"  class="myui-text">');
		$(v_dgaddtdval).append(v_dgoptrminus);
		$('.myui-datagrid').find('.dgplustr').before(v_dgaddtr);
		$(v_dgoptrminus).click(function(){
			$(this).parent().parent().remove();
		});
	}
	
	function sbt(){
		var v_colinput = parent.$('#' + v_colid);
		$(v_colinput).attr('alias', $('#alias').val());
		$(v_colinput).attr('defaultVal', $('#defaultVal').val());
		var v_partyp = $(v_colinput).parent().children('.paramType').val();
		
		if(v_partyp && (v_partyp =='select' || v_partyp =='popradio' ||　v_partyp == 'popcheckbox')){
			var v_valtyp = $('#form_input input[name="valtyp"]:checked').val();
			var ctrlValue = [];
			if(v_valtyp == 'sql'){
				var v_param_sql = $('.spclConfArea').find('#param_sql').val();
				var v_param_sqlkey = $('.spclConfArea').find('#param_sqlkey').val();
				var v_param_sqlvalue = $('.spclConfArea').find('#param_sqlvalue').val();
				ctrlValue.push({
					sql : v_param_sql,
					sqlkey : v_param_sqlkey,
					sqlvalue : v_param_sqlvalue
				});
			}else{
				$('.myui-datagrid').find('tr[name="localSel"]').each(function(idx){
					var v_curkey = $(this).find('input[name="localkey"]').val();
					var v_curval = $(this).find('input[name="localval"]').val();
					ctrlValue.push({
						key : v_curkey,
						value : v_curval
					});
				});
			}
			$(v_colinput).attr('ctrlValue', JSON.stringify(ctrlValue));
			$(v_colinput).attr('valtyp', v_valtyp);
		}else if (v_partyp == 'poptree-radio' ||　v_partyp == 'poptree-checkbox'){
			var v_param_sql = $('.spclConfArea').find('#param_sql').val();
		//	var v_param_sqlid = $('.spclConfArea').find('#param_sqlid').val();
		//	var v_param_sqlname = $('.spclConfArea').find('#param_sqlname').val();
		//	var v_param_sqlpid = $('.spclConfArea').find('#param_sqlpid').val();
			var ctrlValue = [];
			ctrlValue.push({
				sql : v_param_sql
			});
			$(v_colinput).attr('ctrlValue', JSON.stringify(ctrlValue));
			$(v_colinput).attr('valtyp', v_valtyp);
		}
		clsWin();
	}
</script>
<style type="text/css">
.fa-trash{margin-left:5px;vertical-align: middle;cursor: pointer;}
.fa-trash:HOVER{color:red}
.add_staticval,.fa{color:#374fff;cursor: pointer;}
</style>
</head>
<body>
<div id="systemParamWin"></div>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
		 </form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>

