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

	//ctrl点击
	var v_isCtrlKeyup;
	
	//字段个数
	var colCnt;
    
    //选择的td
    var v_selectheader = new Array();
    
	$(function(){
		var data = parent.$('.myui-datagrid2').datagrid2('data');
		var dc = data.dc;
		var opts = data.options;
		var v_frcnt = opts.frozenCnt;
		//alert($(dc.list).find('table').eq(1).find('.header-row').html());
		var v_loopObj = $(dc.list).find('table').eq(1).find('.header-row');
	//	var v_loopObj = $(dc.header1).find('.list-header-table tbody tr');
	//	if($(v_loopObj).length == 0) {
	//		v_loopObj = $(dc.header2).find('.list-header-table tbody tr');
	//	}
		
		var v_htmlStr = $('<tbody></tbody>');
		$(v_loopObj).each(function(idx, obj){
			var vd_headertr = $('<tr class="header-row"></tr>').appendTo($(v_htmlStr));
			$(vd_headertr).append($(this).html());
			$(vd_headertr).find('td').addClass('datacell');
			$(vd_headertr).find('td .list-cell span').remove();
		});
	/*	$(v_loopObj).each(function(idx, obj){
			
			var vt_header1 = $(dc.header1).find('.list-header-table tbody tr');
			var vt_header2 = $(dc.header2).find('.list-header-table tbody tr');
			var vd_headertr = $('<tr class="header-row"></tr>').appendTo($(v_htmlStr));
			
			if($(vt_header1).length > 0 && $(vt_header1).eq(idx)) {
				$(vd_headertr).append($(vt_header1).eq(idx).html());
				$(vd_headertr).find('td').attr('frozen',true);
			}
			
			if($(vt_header2).length > 0 && $(vt_header2).eq(idx)) {
				$(vd_headertr).append($(vt_header2).eq(idx).html());
			}
			$(vd_headertr).find('td').addClass('datacell');
			$(vd_headertr).find('td .list-cell span').remove();
		})*/
		
		$('.chkbody table').append($(v_htmlStr).html());
		$('.chkbody').find('.list-cell').css('width', '100px');
		var d_addrowtd = $('<tr><th colspan=100 class="addrowtd"><span class="addrowspan"><i class="fa fa-plus-square fa-lg"></i>&nbsp;增加一行</span>&nbsp&nbsp<span class="replyHeader"><i class="fa fa-reply-all fa-lg"></i>恢复单表头</span>&nbsp&nbsp<span class="mergespan-disable"><i class="fa fa-link fa-lg"></i>合并单元格</span></th></tr>').prependTo($('.chkbody table'));
		$(d_addrowtd).find('.mergespan-disable').click(function(){
			mergeCell($(this));
		})
		
		$(d_addrowtd).find('.replyHeader').click(function(){
			replyHeader();
		})
		
		var fieldCnt = 0;
		$('.chkbody table .header-row').each(function(){
			addDelBtn($(this));
			$(this).find('.datacell').each(function(){
				if($(this).attr('field')) {
					if($(this).is(":visible")) {
						fieldCnt = fieldCnt + 1
					}
				} else {
					var v_val = $(this).find('.list-cell').html();
					$(this).find('.list-cell').empty();
					
					$(this).find('.list-cell').append($('<input type="text" class="cust-header" value="'+ v_val +'" />'));
					$(this).find('.list-cell input').change(function(){
						$(this).attr('value', $(this).val());
					})
				}
				if($(this).attr('colspan')) {
					$(this).find('.list-cell').css('width', (Number($(this).attr('colspan')) * 100) +'px');
				}
			})
		})
		
		addLock($('.chkbody').find('.datacell .list-cell'));
		/*var d_header_lock = $("<span class='header-lock'>&nbsp;<i class='fa fa-lock fa'></i></span>").appendTo($('.chkbody').find('.datacell .list-cell'));
		$(d_header_lock).click(function(){
			$(this).toggleClass('header-lock-sel');
			if ($(this).hasClass('header-lock-sel')) {
				$(this).parent().parent().attr('forzen','true');	
			} else {
				$(this).parent().parent().removeAttr('forzen');
			}
			
		})*/
		$('.chkbody table .header-row').find("td[frozen='true']").find('.header-lock').addClass('header-lock-sel');
		
		$('.chkbody table .header-row').last().find('.delrow').remove();
		
		$(d_addrowtd).find('.addrowspan').click(function(){
			var d_addTr = $('<tr class="header-row"></tr>');
			for(var i=0; i < fieldCnt; i++) {
				//$(d_addTr).append($('<td class="datacell"><div class="list-cell" style="width: 100px;"><input id="input_' + i + '" name="input_' + i + '" type="text" class="cust-header" value="123"/></div></td>'));
				var d_tmptd = $('<td class="datacell"><div class="list-cell" style="width: 100px;"></div></td>').appendTo($(d_addTr));
				$(d_tmptd).find('.list-cell').append($('<input type="text" class="cust-header" value="自定义表头"/>'))
				$(d_tmptd).find('.list-cell input').change(function(){
					$(this).attr('value', $(this).val());
				})
				
				addLock($(d_tmptd).find('.list-cell'));
				/*var d_header_lock = $("<span class='header-lock'>&nbsp;<i class='fa fa-lock fa'></i></span>").appendTo($(d_tmptd).find('.list-cell'));
				$(d_header_lock).click(function(){
					$(this).toggleClass('header-lock-sel');
					if ($(this).hasClass('header-lock-sel')) {
						$(this).parent().parent().attr('forzen','true');	
					} else {
						$(this).parent().parent().removeAttr('forzen');
					}
				})*/
				$(d_tmptd).find('input').change(function(){
					$(this).attr('value', $(this).val());
				})
			}
		//	var d_addTr = $($(this).parent().parent().next().prop("outerHTML"));
			//$(d_addTr).children().removeAttr('field');
			//$(d_addTr).find('.list-cell').html('<input class="cust-header" type="text" value="自定义表头"/>');
			$(d_addTr).insertAfter($(this).parent().parent());
			if($(d_addTr).find('.delrow').length == 0) {
				addDelBtn($(d_addTr));
			}
			
			addMouseEvent($(d_addTr));
		})
		
		$(window).keydown(function(e){
            if(e.keyCode == 17){
              v_isCtrlKeyup=true;
            }
        }).keyup(function(e){
        	if(e.keyCode == 17){
        	  v_isCtrlKeyup=false;
        	}
        	
        });
		addMouseEvent();
	});
	
	function addLock(p_obj) {
		var d_header_lock = $("<span class='header-lock'>&nbsp;<i class='fa fa-lock fa'></i></span>").appendTo($(p_obj));
		$(d_header_lock).click(function(){
			$(this).toggleClass('header-lock-sel');
			if ($(this).hasClass('header-lock-sel')) {
				$(this).parent().parent().attr('frozen','true');	
			} else {
				$(this).parent().parent().removeAttr('frozen');
			}
			
		})
	}
	
/*	function getLockSpan(isSel) {
		
		var v_rst = '<div></div>'; 
		if (!isSel) {
			$(v_rst).find('span').addClass("lock_unsel");
		}
		return $(v_rst).html();
	}*/
	
	function addDelBtn(p_tr){
		var d_delBtn = $('<td class="delrow"><i class="fa fa-trash fa-lg"></i></td>').appendTo($(p_tr));
		
		$(d_delBtn).find('i').click(function(){
			
			//设置上级tr的rowspan减1
			var v_curtridx = $('.chkbody table tr').index($(this).parent().parent());
			$('.chkbody table tr').each(function(idx) {
				if (idx < v_curtridx) {
					if ($(this).hasClass('.header-row') || $(this).hasClass('.header-row-tdselect')) {
						$(this).children().each(function(){
							var vt_tdrowspan = $(this).attr('rowspan');
							if(vt_tdrowspan && vt_tdrowspan>1) {
								 $(this).attr('rowspan', Number(vt_tdrowspan) - 1);
							}
						})
					}
				} else {
					return false;
				}
			})
			$(this).parent().parent().remove();
		})
	}
	
	
	
	function mergeCell(p_target){
		if ($(p_target).attr('class') == 'mergespan-disable') {
			return false;
		}
		
		var v_fieldCnt = 0;
		
		//是否含有冻结和普通列
		var v_hasFrozenAndnormal = false;
		
		//设置无效
		var v_invalid = false;
		
		//设置无效
		var v_invalid_msg = false;
		
		var v_firstmergeobj = null;
		
		var v_taboper_deltd = new Array();
		var v_taboper_rsttd = new Object(); 
		v_taboper_rsttd.colspan = 0;
		var v_befrowidx = null;
		var v_befmaxRowspan = 1;
		var v_befidx;
		
		var v_strowidx;
		var v_endrowidx;
		
		//用于验证合并单元格每列行数的数组
		var v_validMergearr = new Array();
		
		$('.header-row-tdselect').parent().each(function(tridx, trobj){
			var v_trobj = $(trobj);
			var v_beffrozen = null;
			var v_befcellidx = null;
			var v_maxRowspan = 1;
			var v_rowidx = $(v_trobj).parent().children('.header-row').index($(v_trobj));
			var v_ftdarr = new Array();
			var v_cntcolspan = 0;
			$(v_trobj).children('.header-row-tdselect').each(function(tdidx, tdobj){
				var v_tdrowspan = 1;
				if($(this).attr('rowspan')) {
					v_tdrowspan = $(this).attr('rowspan');
				}
				
				var v_tdcolspan = 1;
				if($(this).attr('colspan')) {
					v_tdcolspan = $(this).attr('colspan');
				}

				//处理如果数列跨行的情况则需要加上个tr的rowspan下标
				var v_rowSpanidx = 0;
				
				if(v_befrowidx != null && v_befrowidx != (Number(v_rowidx) - 1)) {
					v_rowSpanidx = v_validMergearr.length - tridx;
				}

				for (var i = 0 ;i < v_tdrowspan; i++) {
					var v_arridx = tridx + i + v_rowSpanidx;
					if(!v_validMergearr[v_arridx]) {
						v_validMergearr[v_arridx] = 0;
					}
					v_validMergearr[v_arridx] = Number(v_validMergearr[v_arridx]) + Number(v_tdcolspan);
				}
				
				var v_cellidx = $(v_trobj).children('.datacell').index($(this));
				if($(this).attr('field')) {
					v_taboper_rsttd.obj = $(this);
					v_fieldCnt = v_fieldCnt + 1;
				}
				
				if(v_tdrowspan > v_maxRowspan) {
					v_maxRowspan = $(this).attr('rowspan');
				}
				
				var v_curfrozen  = $(this).attr('frozen');
				if(!$(this).attr('frozen')) {
					v_curfrozen = false;
				}
				if(v_beffrozen != null && v_beffrozen && v_beffrozen != v_curfrozen) {
					v_invalid_msg = '冻结列与非冻结列不可合并';
					v_invalid = true;
					return false;
				}
				v_beffrozen = v_curfrozen;
				
				if(v_fieldCnt > 1) {
					v_invalid_msg = '合并单元格中只能出现一个数据项';
					v_invalid = true;
					return false;
				}
				
				if (v_befcellidx != null && v_befcellidx != (v_cellidx - 1)) {
					v_invalid_msg = '横向单元格中不连续，无法进行合并';
					v_invalid = true;
					return false;
				}
				v_befcellidx = v_cellidx;
				
				if(tridx == 0 && tdidx == 0) {
					v_strowidx = v_rowidx;
					v_firstmergeobj = $(this);
					v_taboper_rsttd.obj = $(this);
					v_taboper_rsttd.rowidx = v_rowidx;
					v_taboper_rsttd.cellidx = v_cellidx;
				/*	v_taboper_rsttd.rowspan = $('.header-row-tdselect').parent().length;
					var v_colspan = $(this).parent().children('.header-row-tdselect').length;
					if($(this).attr('colspan')) {
						v_colspan = Number($(this).attr('colspan')) + Number(v_colspan) - 1;
					}
					v_taboper_rsttd.colspan = v_colspan;*/
				} else {
				    v_taboper_deltd.push($(this));
				}
				
				v_cntcolspan = Number(v_tdcolspan) + Number(v_cntcolspan);
			})
			
			if (v_befrowidx != null && (Number(v_befrowidx) + Number(v_befmaxRowspan)) < v_rowidx) {
				v_invalid_msg = '纵向单元格中不连续，无法进行合并';
				v_invalid = true;
			}
			if(v_taboper_rsttd.colspan < v_cntcolspan) {
				v_taboper_rsttd.colspan = v_cntcolspan;
			}
			v_befrowidx = v_rowidx;
			v_befmaxRowspan = v_maxRowspan;
			v_endrowidx = v_rowidx;
			if (tridx == ($('.header-row-tdselect').parent().length - 1) && v_maxRowspan != 1) {
				v_endrowidx = Number(v_rowidx) + Number(v_maxRowspan) - 1;
			}
			
			if(v_invalid) {
			   return false;
			}
			
		})
		
		
		v_taboper_rsttd.rowspan = Number(v_endrowidx) - Number(v_strowidx) + 1;
		
		for(var i=1; i<v_validMergearr.length;i++) {
			if(v_validMergearr[i] != v_validMergearr[i-1]) {
				v_invalid_msg = '选择合并的单元格有误，请重新选择';
				v_invalid = true;
				break;
			}
		}
		
		//合并问题处理
		if(v_invalid){
			$.messager.alert('<s:text name="common_msg_info"/>', v_invalid_msg, 'info'); //导出数量超限
			return false;
		}
		
		if(v_taboper_rsttd) {
			$(v_firstmergeobj).html($(v_taboper_rsttd.obj).html());
			
			if($(v_taboper_rsttd.obj).attr('field')) {
				$(v_firstmergeobj).attr('field', $(v_taboper_rsttd.obj).attr('field'))
			}
			$(v_firstmergeobj).attr('colspan', v_taboper_rsttd.colspan);
			$(v_firstmergeobj).attr('rowspan', v_taboper_rsttd.rowspan);
			$(v_firstmergeobj).removeClass('header-row-tdselect');
			$(v_firstmergeobj).find('.header-lock').remove();
			addLock($(v_firstmergeobj).find('.list-cell'));
			$(v_firstmergeobj).find('.list-cell').css('width', (Number(v_taboper_rsttd.colspan) * 100) +'px');
			for(var i = 0; i < v_taboper_deltd.length; i++) {
				$(v_taboper_deltd[i]).remove();
			}
			
			$(v_firstmergeobj).find('.list-cell input').change(function(){
				$(this).attr('value', $(this).val());
			})
		}
		
		
		$('.chkbody tbody tr').each(function(tridx, trobj){

			var v_rsArr = new Array();
			var v_rscnt = 1;
			var v_isColspansame = true;
			$(this).find('.datacell').each(function(v_idx, v_obj){
				var v_tdrs = 1;
				if ($(this).attr('rowspan')) {
					v_tdrs = $(this).attr('rowspan');
				}
				if (v_idx == 0) {
					if(v_tdrs == 1) {
						v_isColspansame = false;
						return false;
					}
					v_rscnt = v_tdrs;
				} else {
					if (v_tdrs != v_rscnt) {
						v_isColspansame = false;
						return false;
					}
				}
			})
			
			if (v_isColspansame) {
				$(this).find('td').attr('rowspan', 1);
				var v_tmpnexttr = $(this).next();
				for(var i=0; i< v_rscnt - 1; i++) {
					$(v_tmpnexttr).remove();
					v_tmpnexttr = $(v_tmpnexttr).next();
				}
			}
		});
		
	}
	
	function addMouseEvent(p_tr){
		var d_header = $('.chkbody').find('.header-row');
		if(p_tr) {
			 d_header = $(p_tr);
		}
		
		$(d_header).children('.datacell').click(function(){
			if(v_isCtrlKeyup) {
			  $(this).toggleClass("header-row-tdselect");
			}
			if($('.header-row-tdselect').length > 1) {
				$('.mergespan-disable').addClass('mergespan');
				$('.mergespan-disable').removeClass('mergespan-disable');
			} else {
				$('.mergespan').addClass('mergespan-disable');
				$('.mergespan').removeClass('mergespan');
			}
		})
		
		$(d_header).children('.datacell').find('input').click(function(){
			if(v_isCtrlKeyup) {
			  $(this).parent().parent().toggleClass("header-row-tdselect");
			}
			if($('.header-row-tdselect').length > 1) {
				$('.mergespan-disable').addClass('mergespan');
				$('.mergespan-disable').removeClass('mergespan-disable');
			} else {
				$('.mergespan').addClass('mergespan-disable');
				$('.mergespan').removeClass('mergespan');
			}
		})
	}
	
	
	//表单提交
	function sbt(){
		if ($('.chkbody').find('.header-row').length <= 1) {
			parent.$('.myui-datagrid2').datagrid2('operateMultiHeaderColumn', {
				frozenCnt : $('.chkbody').find('.header-row').find(".header-lock-sel").length
			});
		} else {
			var d_allHeader = $('<tbody></tbody>');
			var d_header = $('<tbody></tbody>');
			var d_forzenHeader = $('<tbody></tbody>');
			
			$('.chkbody tbody tr').each(function(){
				if($(this).hasClass('header-row')) {
				  $(d_allHeader).append($(this).prop("outerHTML"));
				}
			})
			$(d_allHeader).find('.datacell').each(function(idx, obj){
				if($(this).attr('field')) {
					$(this).attr('myui-options', 'field:\'' + $(this).attr('field') + '\'');
					$(this).removeAttr('field');
					$(this).append($(this).find('.list-cell').html());
					$(this).find('.list-cell').remove();
				} else {
					$(this).find('input').parent().parent().append($(this).find('input').val());
					$(this).find('.list-cell').remove();
				}
			})
			
			$(d_allHeader).find('td').removeClass('datacell');
			$(d_allHeader).find('.list-cell').removeAttr('style');
			$(d_allHeader).find('.delrow').remove();
			$(d_allHeader).find('.header-row-tdselect').removeClass('header-row-tdselect');
			
			//$('.chkbody tbody').html($(d_allHeader).html());
			$(d_forzenHeader).append($(d_allHeader).html());
			$(d_forzenHeader).find("td:not([frozen='true'])").remove();
			$(d_forzenHeader).find('td').removeAttr('frozen');
			$(d_forzenHeader).find('.header-lock').remove();
			$(d_header).append($(d_allHeader).html());
			$(d_header).find("td[frozen='true']").remove();
			$(d_header).find('.header-lock').remove();
			if(!validFrozenHeader($(d_forzenHeader).html())) {
			     return false;
			}
			
			parent.$('.myui-datagrid2').datagrid2('operateMultiHeaderColumn', {
				frheader : $(d_forzenHeader),
				header   : $(d_header)
			});
			
		}
		clsWin();
	}
	
	function validFrozenHeader(p_frozenHeader){
		
		var v_cellCntArr = new Array();
		var v_invalid = false;
		var v_invalid_msg;
		if ($(p_frozenHeader).find('td').length == 0) {
			return true;
		}
		
		$(p_frozenHeader).each(function(tridx, trobj){
			var v_cellCnt = 0;
			$(this).find('td').each(function(){
				
				var v_tdrowspan = 1;
				if($(this).attr('rowspan')) {
					v_tdrowspan = $(this).attr('rowspan');
				}
				
				var v_tdcolspan = 1;
				if($(this).attr('colspan')) {
					v_tdcolspan = $(this).attr('colspan');
				}
				
				for (var i = 0 ;i < v_tdrowspan; i++) {
					var v_arridx = tridx + i;
					if(!v_cellCntArr[v_arridx]) {
						v_cellCntArr[v_arridx] = 0;
					}
					v_cellCntArr[v_arridx] = Number(v_cellCntArr[v_arridx]) + Number(v_tdcolspan);
				}
			})
		})
		
		
		$('.chkbody tbody .header-lock-sel').parent().parent().parent().each(function(v_trcnt, v_trobj){
			var v_rowidx = $(v_trobj).parent().children('.header-row').index($(v_trobj));
			var v_befcellidx = null;
			$(v_trobj).find('.header-lock-sel').parent().parent().each(function(v_tdcnt, v_tdobj){
				var v_cellidx = $(v_trobj).children('.datacell').index($(this));
				
				if (v_trcnt == 0 && v_tdcnt == 0) {
					if(v_rowidx != 0 || v_cellidx != 0) {
				      v_invalid_msg = '请从左边第一行/列开始选择冻结列';
					  v_invalid = true;
					  return false;
					}
				}
				
				if (v_befcellidx != null && v_befcellidx != (v_cellidx - 1)) {
					v_invalid_msg = '横向单元格中不连续，无法进行冻结';
					v_invalid = true;
					return false;
				}
				v_befcellidx = v_cellidx;
			})
			
			if(v_invalid) {
				return false;
			}
		})
		
		
		for(var i=1; i<v_cellCntArr.length;i++) {
			if(v_cellCntArr[i] != v_cellCntArr[i-1]) {
				v_invalid_msg = '选择冻结的单元格有误，请重新选择';
				v_invalid = true;
				break;
			}
		}
		
		if(v_cellCntArr.length != $(p_frozenHeader).length) {
			v_invalid_msg = '请选择纵向一整列进行冻结';
			v_invalid = true;
		}
		
		if(v_invalid) {
			$.messager.alert('<s:text name="common_msg_info"/>', v_invalid_msg, 'info'); 
			return false;
		}
		
		return true;
	}
	
	function replyHeader(){
		var v_tr = $('<tr class="header-row"></tr>');
		$('.chkbody tbody').find('.datacell').each(function(){
			if($(this).attr('field')) {
				$(v_tr).append($(this).prop('outerHTML'));
			}
		})
		$(v_tr).find('.datacell').attr('colspan',1);
		$(v_tr).find('.datacell').attr('rowspan',1);
		$(v_tr).find('.header-lock').remove();
		var data = parent.$('.myui-datagrid2').datagrid2('data');
		var opts = data.options;
		
		var v_sorttr = $('<tr class="header-row"></tr>');
		for(var i=0; i<opts.allColumns.length; i++) {
			$(v_sorttr).append($(v_tr).find('td[field="'+opts.allColumns[i].field+'"]').prop('outerHTML'));
		}

		$('.chkbody tbody').find('.datacell').parent().remove();
		$('.chkbody tbody').append($(v_sorttr));
		addLock($('.chkbody tbody').find('.datacell .list-cell'));
		$('.chkbody tbody').find("td[frozen='true']").find('.header-lock').addClass('header-lock-sel');
		addMouseEvent($(v_sorttr));
	}
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#showMultiHeaderWin').window('close');
    }
</script>
<style type="text/css">
.cust-header{width: 80px;margin-top: 2px;font-family:"微软雅黑";font-size: 10px;text-indent: 4px;background:#F8F6ED;border:1px solid #E0DFDF;}
.chkbody{width: 588px;padding: 10px 10px 0 10px}
.chkbody table{border-collapse: collapse;width: 568px;}
.header-row{height:30px;background:#F8F6ED;}
.chkbody td{color:#333;}
.list-cell{height: 23px;line-height: 23px;}
.chkbody table .delrow{text-align: center;padding: 0px;width: 20px;}
.chkbody table td,.chkbody table th{text-align:center;vertical-align:middle;color:#333;height: 25px;font-family:"微软雅黑";font-size: 12px;padding-left: 10px;border:1px solid #E0DFDF;}
.addrowspan,.mergespan,.fa-trash,.replyHeader{color:#374fff;cursor: pointer;}
.mergespan-disable{color: #ddd;}
.header-row-tdselect{background:#E0ECFF;}
.datacell{text-align: center}
.header-lock{color: #ddd;cursor: pointer;}
.header-lock-sel{color: #333;}
body{
-moz-user-select: none;
}
.col-tips{font-size: 9px;margin: 0 0 5px 10px}
</style>
</head>
<body onselectstart="return false;">
<div id="addCustomColWin"></div>
<div class="myui-form">
	<div class="form" style="overflow-x:auto;">
		<form id="form_input" method="post">
			<div class="chkbody">
				<table>
					
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