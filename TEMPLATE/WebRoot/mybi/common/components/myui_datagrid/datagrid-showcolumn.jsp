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

	//是否存在checkbox，datagrid中默认将checkbox放在了锁定列中，如果存在checkbox则默认要将锁定列跳过1，并且在传参数将锁定列+1
	var haveCheckbox = false; 

	$(function(){
		initColum();
		$('#checkall').bind('click', function(){
			if($(this).attr('checked')){
				$("input[name='checkboxitem']").attr('checked',true);
			}else{
				$("input[name='checkboxitem']").attr('checked',false);
			}
			
			if($(this).attr('checked')){
				$("select[name^='mergesel']").attr('disabled',false);
			}else{
				$("select[name^='mergesel']").attr('disabled',true);
			}
			
		});
		
		$("input[name='checkboxitem']").change(function(){
			if($(this).attr('checked')){
				$("select[name='mergesel_"+$(this).attr('value')+"']").attr('disabled',false);
			}else{
				$("select[name='mergesel_"+$(this).attr('value')+"']").attr('disabled',true);
			}
		});
	});
	
	//分页查询
    function initColum(){
		
		//在线查询可以使用自定义列
    	if(parent.window.location.href.indexOf("query_online!query.action") > 0) {
	    	var addcoltr = $('<tr class="addCustomColtr"></tr>').appendTo($('.chkbody table'));
			var addcoltd = $('<td colspan=4 style="text-align:center"><span class="addCustomCol"><i class="fa fa-plus-square fa-lg"></i>&nbsp;添加自定义列</span></td>').appendTo(addcoltr);
			$(addcoltd).find('span').click(function(){
				custWin(null);
			})
    	}
    	var target = parent.$('.myui-datagrid2');
		var opts = parent.$('.myui-datagrid2').datagrid2('options');
		var allcol = opts.allColumns;
		var frozenCnt = 0;
		if(opts.frozenColumns[0]){
			frozenCnt = opts.frozenColumns[0].length;
		}
		
		
		//绑定列的点击事件
		$(allcol).each(function(ind){
			var col_opts = allcol[ind];
			var filed_label = col_opts.title;
			
			if(col_opts.checkbox){
				haveCheckbox = true;	
			}else if(col_opts.field != null ){
				var coltr;
				if(col_opts.expr){
					coltr = createColumn(col_opts.field, filed_label, col_opts.datatype, true, col_opts.expr, col_opts.link);
				}else{
					coltr = createColumn(col_opts.field, filed_label, col_opts.datatype, false, null, col_opts.link);
				}
				
				var colcheck = $(coltr).find('input[name="checkboxitem"]');
				var mergesel = $(coltr).find('input[name="mergesel_'+col_opts.field+'"]');
				
				
				if(col_opts.hidden){
					$(colcheck).attr('checked',false);
					$(mergesel).attr('disabled',true);
				}else{
					$(colcheck).attr('checked',true);
					$(mergesel).attr('disabled',false);
					
					//判断如果有聚合则进行值的设置，代码有些冗余需要优化
					if(opts.mergeColumnList){
						var mergeval = '';
						var colsarr = opts.showColumnList.split(",");
						$(colsarr).each(function(idx){
							if(colsarr[idx] == col_opts.field){
								mergeval = opts.mergeColumnList.split(",")[idx];
							}
						});
						$("select[name='mergesel_"+col_opts.field+"']").val(mergeval);
					}
				}
							
			}
		});

		//创建页面排序
		loadColunmSort();
		
		//加载表头锁定
		loadFrozenSort(frozenCnt,$(allcol).length);
		
	}
	
	function custWin(p_param){ 
		$("#addCustomColWin").window({
			open : true,
			param : p_param,
			headline:'自定义列',
			content:'<iframe id="addCustomColframe" src="${ctx}/mybi/common/components/myui_datagrid/datagrid-addCustomCol.jsp" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			panelWidth:550,
			top : "10",
			panelHeight:400
		});
	}
	
	function updateColumn(p_title, p_datatype, p_expr, p_rowidx){
		var row_tr = $('.chkbody table tr:eq('+p_rowidx+')');
		$(row_tr).find('.chk input').attr('datatype', p_datatype);
		$(row_tr).find('.chk input').attr('expr', p_expr);
		$(row_tr).find('.name label').html(p_title);
	}
	
	function createColumn(p_field, p_title, p_datatype, p_iscustom, p_expr, p_link){
		var custCol = "";
		if(p_iscustom)
			custCol = " custCol";
		
		var coltr = $('<tr class="dataRow'+custCol+'"></tr>');
		
		//如果存在自定义列则在其前面加入，否则直接添加在列表最下方
		if( $('.addCustomColtr').length > 0) {
		    $('.addCustomColtr').before($(coltr));
		} else {
			$('.chkbody table').append($(coltr));
		}
		
		
		var coltd1 = $('<td  class="chk"></td>').appendTo(coltr);

		var coltd2 = $('<td class="name"></td>').appendTo(coltr);
		
	//	var coltd3 = $('<td class="type"></td>').appendTo(coltr);
		
		var coltd4 = $('<td class="group"></td>').appendTo(coltr);
		
		var coltd5 = $('<td class="oper"></td>').appendTo(coltr);
		
		var colcheck = $('<input />',{
				 type:"checkbox",
	 				 name:"checkboxitem",
				 val:p_field
 				});
		$(colcheck).attr('datatype', p_datatype);
		coltd1.append(colcheck);
		
		var colchecklabel = $('<label>',{
			 	text:' ' + p_title
			 });
		
		coltd2.append(colchecklabel);
		
		if(p_link) {
			$(colcheck).attr('link', JSON.stringify(p_link));
			$(colchecklabel).addClass('linkcol');
		}
		
		$(colchecklabel).click(function(){
			
			var v_tmp_collist = [];
			$('.chkbody').find('.dataRow').each(function(){
				v_tmp_collist.push({
					name : $(this).find('.chk input').attr('value'),
					desc :$(this).find('.name label').html()
				});
			})
			var v_tmp_param = {
					colidx : $(this).parent().parent().parent().children().index($(this).parent().parent()),
					collist : v_tmp_collist
			}
			
			if($(this).hasClass('linkcol')) {
				v_tmp_param.link = $(this).parent().prev().find('input').attr('link');
			}
			
			$("#editColumnAttrWin").window({
				open : true,
				headline:'字段('+$(this).html()+')属性配置',
				content:'<iframe id="myframe" src="${ctx}/mybi/common/components/myui_datagrid/datagrid-columnattr.jsp" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:500,
				param : v_tmp_param,
				top : 10,
				panelHeight:370
			});
		})
		
		var mergesel=$('<select />',{name:"mergesel_"+p_field}); 
		$('<option />',{ 
			val:"normal", 
			text:"正常显示" , 
			selected:"selected"
		}).appendTo(mergesel);
		
		if(p_datatype && p_datatype == 'number'){
			$('<option>',{ 
				val:"sum", 
				text:"和"
			}).appendTo(mergesel);   
			$('<option>',{ 
				val:"avg", 
				text:"平均"
			}).appendTo(mergesel); 
			$('<option>',{ 
				val:"count", 
				text:"计数"
			}).appendTo(mergesel); 
		} 
		$('<option>',{ 
			val:"max", 
			text:"最大值"
		}).appendTo(mergesel);  
		$('<option>',{ 
			val:"min", 
			text:"最小值"
		}).appendTo(mergesel);  
		
		coltd4.append(mergesel);
		
		if(p_iscustom){
			$(coltd5).append();
			var v_rcc_btn = $('<a href="###" class="removeCustCol"><i class="fa fa-trash"></i></a>').appendTo($(coltd5));
			var v_ecc_btn = $('<a href="###" class="editCustCol"><i class="fa fa-edit"></i></a>').appendTo($(coltd5));
			$(v_rcc_btn).click(function(){
				$(this).parent().parent().remove();
				parent.$('.myui-datagrid2').datagrid2('deleteCustColumnByField', $(this).parent().parent().find('.chk input').val());
				loadColunmSort();
			});
			$(colcheck).attr('expr', p_expr);
			$(colcheck).attr('checked',true);
			$(v_ecc_btn).click(function(){
				var v_cust_param = {
						"colVal"    : $(this).parent().parent().find('.chk input').attr('expr'),
						"title"     : $(this).parent().parent().find('.name label').html(),
						"datatype"  : $(this).parent().parent().find('.chk input').attr('datatype'),
						"rowidx"    : $(coltr).index()
						
				}
				custWin(v_cust_param);
			})
		}
		
		return $(coltr);
	}
	
	//锁定表头设置
	function loadFrozenSort(p_frozenCnt, p_allCnt){
		var forzenCntSpan = $('<span></span>');
		
		//如果存在多选框则跳过
		if(haveCheckbox){
			p_frozenCnt--;
			p_allCnt--;
		}
		
		
		var frozenCntsel=$('<select />',{id:"frozenCnt"}); 
		$('<option />',{ 
			val:0, 
			text:0 , 
			selected:"selected"
		}).appendTo(frozenCntsel); 
		for(var i=0;i<p_allCnt;i++){
			$('<option />',{ 
				val:i+1, 
				text:i+1
			}).appendTo(frozenCntsel); 
		}
		
		$(frozenCntsel).change(function(){
			setThLock($(this).val());
		});
		
		$(frozenCntsel).val(p_frozenCnt);
		$(".title").children('.oper').append($(forzenCntSpan));
		$(forzenCntSpan).append('<span>锁定前&nbsp;');
		$(forzenCntSpan).append($(frozenCntsel));
		$(forzenCntSpan).append('&nbsp;列</span>');
		
		setThLock(p_frozenCnt);
	}
	
	function setThLock(p_frozenCnt){
		$(".lockTh").remove();
		for(var i=0;i<p_frozenCnt; i++){
			var lockTh = $('<img class="lockTh" src="${ctx}/mybi/common/themes/${apptheme}/images/icons/lock.png"></img>');
			$(".dataRow").eq(i).find('.oper').append($(lockTh));
		}
	}
	
	function loadColunmSort(){
		
		var rowCnt = $('.chkbody table .dataRow').length;
		$('.chkbody table .dataRow').each(function(ind){
			var curtd = $(this).find('.oper');
			$(this).find('.sortColUp').remove();
			$(this).find('.sortColDown').remove();
			
			var sortColUp = $('<a href="###" class="sortColUp"><i class="fa fa-arrow-up"></i></a>');
			$(sortColUp).click(function(){
				var curtr = $(this).parent().parent();
				var pretr = $(curtr).prev();
				$(curtr).insertBefore($(pretr));
				loadColunmSort();
				setThLock($('#frozenCnt').val());
			});
			var sortColDown = $('<a href="###" class="sortColDown"><i class="fa fa-arrow-down"></i> </a>');
			$(sortColDown).click(function(){
				var curtr = $(this).parent().parent();
				$(curtr).insertAfter($(curtr).next());
				loadColunmSort();
				setThLock($('#frozenCnt').val());
			});

			if(ind < (rowCnt - 1 )){
				$(curtd).prepend($(sortColDown));
			}
			if(ind > 0){
				$(curtd).prepend($(sortColUp));
			}
		})
	}
	
	//表单提交
	function sbt(){
		var ids = 	getIdFieldsOfChecked();
		if(ids ==''){
			ids = ',';
		}
		var ids_array = ids.split(',');
		
		var all_col = [];
		$("input[name='checkboxitem']").each(function(){
			all_col.push($(this).val());
		})
		
		//存储所有字段聚合类型，用逗号隔开的方式
		var merges = '';
		
		$(ids_array).each(function(idx){
			if(ids_array[idx]){
				merges += $("select[name='mergesel_"+ids_array[idx]+"']").val() + ",";
			}
		});
		
		var ismerge = merges.replaceAll('normal,','');
		if(ismerge == '' || ismerge == null){
			merges = '';
		}
		
		var frozenCnt = $('#frozenCnt').val();
		
		//如果存在多选框，datagrid中默认为锁定列所以需要+1
		if(haveCheckbox){
			frozenCnt++;
		}
		
		var custExpr = [];
		$('.custCol').each(function(){
			if($(this).find('.chk input').attr('checked')){
				var v_custCol = {
						"field"    : $(this).find('.chk input').val(),
						"title"    : $(this).find('.name label').html(),
						"datatype" : $(this).find('.chk input').attr('datatype'),
						"expr"     : $(this).find('.chk input').attr('expr'),
						"width"    : "120"
				}
				parent.$('.myui-datagrid2').datagrid2('saveOrUpdateCustColumn', v_custCol);
				custExpr.push(v_custCol);
				//custExpr += $(this).find('.chk input').val() + "@@@" +$(this).find('.chk input').attr('expr') + ",";
			}
		})
		
		
		var v_colstyles = [];
		$('.chkbody .linkcol').each(function(){
			v_colstyles.push({
				col : $(this).parent().prev().find('input').attr('value'),
				link : JSON.parse($(this).parent().prev().find('input').attr('link'))
			});
		})
		
		parent.$('.myui-datagrid2').datagrid2('operateColumn',ids + "###" + merges + "###" + frozenCnt + "###" + JSON.stringify(custExpr) + "###" + all_col.join(',') + "###" + JSON.stringify(v_colstyles));
		clsWin();
	}
	
	
	
    //得到表中选中的记录
	function getIdFieldsOfChecked(){
		var ids="";
		var objsChecked=$("input[name='checkboxitem']:checked");
		if(objsChecked.length>=1){
			var custcnt = 1;
			for(var i=0;i<objsChecked.length;i++){
				var v_val = $(objsChecked[i]).val();
				
				//处理自定义字段
			/*	if(v_val == ''){
					var v_custfield = "customcol"+ custcnt;
					ids += v_custfield + ",";
					$(objsChecked[i]).val(v_custfield);
					$(objsChecked[i]).parent().parent().find('.group select').attr('name', 'mergesel_'+v_custfield);
					custcnt++;
				}else{*/
					ids += v_val +",";	
				//}
				
			}
		}
		return ids;
	}
    
    function setColLink(p_obj){
    	$('.chkbody').find('table tr').eq(p_obj.colidx).find('.chk input').attr('link', JSON.stringify(p_obj));
    	$('.chkbody').find('table tr').eq(p_obj.colidx).find('.name label').addClass('linkcol');
    }
    
    function removeColLink(p_colidx){
    	$('.chkbody').find('table tr').eq(p_colidx).find('.chk input').removeAttr('link');
    	$('.chkbody').find('table tr').eq(p_colidx).find('.name label').removeClass('linkcol');
    }
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#showColumnWin').window('close');
    }
</script>
<style type="text/css">
.chkbody{width: 588px;padding: 10px 10px 0 10px}
.chkbody table{border-collapse: collapse;width: 568px;}
.chkbody table tr{border: 1px solid #CCC;}
.chkbody table td{vertical-align:middle;text-align: left;color:#333;height: 30px;font-family:"微软雅黑";font-size: 14px;padding-left: 10px;border:1px solid #E0DFDF;}
.chkbody table td select{font-family:"微软雅黑";font-size: 12px;width: 100px}
.chkbody table th{background-color: #EEE;color:#666;height: 25px;font-family:"微软雅黑";font-size: 14px;}
.chkbody table .chk{width: 20px;text-align: left;padding-left: 5px;}
.chkbody table .name{width: 220px;}
.chkbody table .type{width: 200px;}
.chkbody table .group{width: 120px;}
.chkbody table td.oper a{margin-left:5px;}
.chkbody table .oper input{width: 30px;}
.chkbody table .oper span{font-size: 12px;font-weight: normal;}
.addCustomCol{color:#374fff;cursor: pointer;}
.linkcol{color:#374fff;}
.chkbody table i:HOVER{color:red;cursor: pointer;}
.chkbody table .dataRow label:HOVER{color:#374fff;cursor: pointer;}
</style>
</head>
<body>
<div id="addCustomColWin"></div>
<div id="editColumnAttrWin"></div>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
			<div class="chkbody">
				<table>
					<tr class="title">
						<th class='chk'><input type="checkbox" id="checkall"/></th>
						<th class='name'>显示字段</th>
						<!-- th class='type'>字段类型</th -->
						<th class='group'>聚合</th>
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