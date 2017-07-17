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
	/*	$.ajaxSetup({   
            async : false  
        });*/ 
		var v_opts = parent.$('#addTabJoinWin').window('options');
		v_winParam  = v_opts.param;
		var v_joinTabs = v_winParam.joinTabs;
		var v_editObj = v_winParam.editObj;
		
		var tab1qsid = v_joinTabs[0];
		var tab2qsid = v_joinTabs[1];
		
		if (v_winParam.editObj) {
			tab1qsid = v_winParam.editObj.tab1qsid;
			tab2qsid = v_winParam.editObj.tab2qsid;
		}
		
		loadTable(tab1qsid, 'table1');
		loadTable(tab2qsid, 'table2');
		
		
		$.post("${ctx}/query_dataset!getDatasetObjs.action", {"query_dataset.id": v_winParam.joinTabs.join(",")},function(data){
			var dataJson = JSON.parse(data);
			if(v_joinTabs.length > 2) {
				var tabsel1=$('<select />',{class:"table1sel"}); 
				var tabsel2=$('<select />',{class:"table2sel"}); 
				var tab1nam = '';
				var tab2nam = '';
				for(var i=0; i<dataJson.length; i++) {
					var qds = dataJson[i];
					$('<option />',{ 
						val: qds.id, 
						text: qds.srcdes
					}).appendTo(tabsel1);
					$('<option />',{ 
						val: qds.id, 
						text: qds.srcdes
					}).appendTo(tabsel2);

					if(qds.id == tab1qsid){
						tab1nam = qds.srcdes;
					}else if(qds.id == tab2qsid){
						tab2nam = qds.srcdes;
					}
					
				}
				tabsel1.val(tab1qsid);
				tabsel2.val(tab2qsid);
				$('.myui-layout').find('.table1').append(tabsel1);
				$('.myui-layout').find('.table2').append(tabsel2);
				
				//设置默认值
				$('.table1col').attr('qsid', $(tabsel1).val());
				$('.table1col').attr('tabnam', tab1nam);
				$('.table2col').attr('qsid', $(tabsel2).val());
				$('.table2col').attr('tabnam', tab2nam);
				
				$(tabsel1).change(function(){
					$('.table1list').empty();
					loadTable($(this).val(), 'table1');
					$('.table1col').attr('qsid', $(this).val());
					$('.table1col').attr('tabnam', $(this).children('option[value="'+$(this).val()+'"]').html());
				})
				
				$(tabsel2).change(function(){
					$('.table2list').empty();
					loadTable($(this).val(), 'table2');
					$('.table2col').attr('qsid', $(this).val());
					$('.table2col').attr('tabnam', $(this).children('option[value="'+$(this).val()+'"]').html());
				})
				
			}else{
				var tab1nam = '';
				var tab2nam = '';
				for(var i=0; i<dataJson.length; i++) {
					var qds = dataJson[i];
					if(qds.id == tab1qsid){
						tab1nam = qds.srcdes;
					}else if(qds.id == tab2qsid){
						tab2nam = qds.srcdes;
					}
				}
				
				$('.myui-layout').find('.table1').html(tab1nam);
				$('.myui-layout').find('.table1').attr('qsid', tab1qsid);
				$('.myui-layout').find('.table2').html(tab2nam);
				$('.myui-layout').find('.table2').attr('qsid', tab2qsid);
				
				//设置默认值
				$('.table1col').attr('qsid', tab1qsid);
				$('.table1col').attr('tabnam', tab1nam);
				$('.table2col').attr('qsid', tab2qsid);
				$('.table2col').attr('tabnam', tab2nam);
			}
			
			
		})
		
		
		//设置默认值
		if (v_winParam.editObj) {
			$('#joinType'+v_winParam.editObj.jointype).attr('checked',true);
		}
	});
	
	function loadTable(p_dsid, p_tab) {
		$.post("${ctx}/query_dataset!getTabinfoAndColumnListByDatasetId.action", {"query_dataset.id": p_dsid},function(data){
			var dataJson = JSON.parse(data);
		//	$('.myui-layout').find('.'+p_tab).html(dataJson.tabInfo.srcdes);
		//	$('.myui-layout').find('.'+p_tab).attr('qsid', dataJson.tabInfo.id);
			createTabCols(dataJson.colInfo, p_tab);
			
			$('.'+p_tab +'col').removeAttr('col');
			$('.'+p_tab +'col').removeAttr('colnam');
			
			//设置默认值
			if (v_winParam.editObj) {
				var v_obj;
			   if (p_dsid == v_winParam.editObj.tab1qsid && p_tab == 'table1') {
				   v_obj = $('.'+p_tab +'list').find('label[name="' + v_winParam.editObj.tab1col + '"]')
			   } else if (p_dsid == v_winParam.editObj.tab2qsid  && p_tab == 'table2') {
				   v_obj = $('.'+p_tab +'list').find('label[name="' + v_winParam.editObj.tab2col + '"]');
			   }
			   
			   if (v_obj) {
				    $(v_obj).parent().siblings().removeClass('select');
					$(v_obj).parent().addClass('select');
					$('.'+p_tab +'col').attr('col',  $(v_obj).parent().find('label').attr('name'));
					$('.'+p_tab +'col').attr('colnam', $(v_obj).parent().find('label').html());
			   }
			}
		})
	}
	
	/**
	 * 描述   创建表字段
	 * 参数    p_cols : 字段JSON
	 *     p_tab  : 添加表，table1 左边 ， table2 右边
	 */
	function createTabCols(p_cols, p_tab){
		$(p_cols).each(function(idx, obj){
			var v_coldesc =  !obj.srcdes ? obj.src : obj.srcdes
			var conli = $("<li></li>").appendTo($('.'+p_tab +'list'));
			$(conli).append("<i class='fa fa-plus-square'></i>&nbsp<label class='col' name='"+obj.src+"'>"+v_coldesc+"</label>");
			
			$(conli).click(function(){
				$(this).siblings().removeClass('select');
				$(this).addClass('select');
				$('.'+p_tab +'col').attr('col', $(this).find('label').attr('name'));
				$('.'+p_tab +'col').attr('colnam', $(this).find('label').html());
			})
		})
	}
	
	function sbt(){
		var tab1qsid = $('.table1col').attr('qsid');
		var tab2qsid = $('.table2col').attr('qsid');
		var tab1col = $('.table1col').attr('col');
		var tab2col = $('.table2col').attr('col');
		var tabjoin = $('input[name="joinType"]:checked').val();
		var tab1coldes = $('.table1col').attr('colnam');
		var tab1des = $('.table1col').attr('tabnam');
		var tab2coldes = $('.table2col').attr('colnam');
		var tab2des = $('.table2col').attr('tabnam');
		if(!tab1col){
			$.messager.alert('<s:text name="common_msg_info"/>','请选择<'+tab1des+'>表字段','error');
			return false;
		}
		if(!tab2col){
			$.messager.alert('<s:text name="common_msg_info"/>','请选择<'+tab2des+'>表字段','error');
			return false;
		}
		var v_rst = {
			"tab1qsid" : tab1qsid,
			"tab1col"  : tab1col,
			"tab2qsid" : tab2qsid,
			"tab2col"  : tab2col,
			"jointype" : tabjoin,
			"tab1coldes"   : tab1coldes,
			"tab1des"   : tab1des,
			"tab2coldes"   : tab2coldes,
			"tab2des"   : tab2des
		};
		
		//判断是修改还是添加
		if (v_winParam.editObj) {
			parent.window.updateTabJoinRow(v_rst, v_winParam.editObj.dataidx);
		} else {
			parent.window.createTabJoinRow(v_rst);
		}
		
		clsWin();
	}
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#addTabJoinWin').window('close');
    }
</script>
<style type="text/css">
.form{width:580px;border:0px}
.myui-layout{padding-left:10px;border:0px;margin-top: 10px}
.myui-layout .collist{margin-top: 5px}
.myui-layout .collist li{padding-top: 5px;padding-left: 5px;cursor: pointer;}
.myui-layout .collist li label{cursor: pointer;}
.myui-layout .collist li:hover{background-color: #E0ECFF;border-color: #E0ECFF;}
.myui-layout .collist li.select{background-color: #99CCFF;border-color: #99CCFF;}
.table1sel,.table2sel{width: 200px;height: 25px;margin-top: 5px}
.select
</style>
</head>
<body>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
			<div class="myui-layout">
				<div class="rowgroup">
					<div class="content" headline="<div class='table1'></div>" style="width: 280px;height: 260px">
						<ul class="collist table1list">
						</ul>
					</div>
					<div class="content" headline="<div class='table2'></div" style="width: 280px;height: 260px">
						<ul class="collist table2list">
						</ul>
					</div>
				</div>
			</div>
			<div class="item">
				<ul>
					<li style="margin-left: 20px">连接方式：</li>
					<li><INPUT type="radio" id="joinTypeinner" name="joinType" checked=true value="inner">&nbsp;内连接&nbsp;&nbsp; 
						<INPUT type="radio" id="joinTypeleft" name="joinType" value="left">&nbsp;左外连接&nbsp;&nbsp;
						<INPUT type="radio" id="joinTyperight" name="joinType" value="right">&nbsp;右外连接&nbsp;&nbsp;
					</li>
			 </div>
		</form>
	</div>
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>
<input type="text" class="table1col">
<input type="text" class="table2col">
</body>
</html>