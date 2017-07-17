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
	$(function(){
		initColum();
	});
	
	//分页查询
    function initColum(){
    	var target = parent.$('.myui-datagrid2');
		var opts = parent.$('.myui-datagrid2').datagrid2('options');
	/*	var vis_field = $(target).datagrid2('getVisableColumn');
		
		var visfs = vis_field.split("###")[0].split(",");
		var visfdescs = vis_field.split("###")[1].split(",");*/
		var opts = parent.$('.myui-datagrid2').datagrid2('options');
		var allcol = opts.allColumns;
		
		if(opts.filterColumnList){
			var filterColumns = opts.filterColumnList.split(',');
			
			for(var i=0; i<filterColumns.length; i++){
				if(filterColumns[i]){
					var filterColumn =filterColumns[i].split('###');
					if(filterColumn.length == 4){
						var colattr = parent.$('.myui-datagrid2').datagrid2('getColumnAttr',filterColumn[0]+",datatype");
						addCondition(filterColumn[0],filterColumn[3],filterColumn[1],filterColumn[2],colattr);
					}
				}
			}
		}
		
	/*	for(var i=0;i<visfs.length;i++){
			if(visfs[i] && visfdescs[i]){
				var tmpli = $("<li></li>").appendTo($(".collist"));
				$(tmpli).append("+&nbsp<label class='col' name='"+visfs[i]+"'>"+visfdescs[i]+"</label>");
				$(tmpli).bind("click",function(){
					var colattr = parent.$('.myui-datagrid2').datagrid2('getColumnAttr',$(this).find('.col').attr('name')+",datatype");
					addCondition($(this).find('.col').attr('name'), $(this).find('label').html(),null,null,colattr);
				});
			}
		}*/
		
		for(var i=0;i<allcol.length;i++){
			var col = allcol[i];
			if(!col.checkbox && !col.hidden){
				var tmpli = $("<li></li>").appendTo($(".collist"));
				$(tmpli).append("<i class='fa fa-plus-square'></i>&nbsp<label class='col' name='"+col.field+"'>"+col.title+"</label>");
				$(tmpli).bind("click",function(){
					var colattr = parent.$('.myui-datagrid2').datagrid2('getColumnAttr',$(this).find('.col').attr('name')+",datatype");
					addCondition($(this).find('.col').attr('name'), $(this).find('label').html(),null,null,colattr);
				});
			}
		}
	}
	
	function addCondition(p_col, p_coldes, p_colcompare, p_colval,p_colattr){
		var conli = $("<li></li>").appendTo($('.conditonlist'));
		$(conli).append("<input class='col' type='text' name='"+p_col+"' disabled=true value='"+p_coldes+"'>");
		var consel=$('<select class="compare"/>',{name:"consel"}); 
		
		$('<option />',{ 
			val:"=", 
			text:"等于" , 
			selected:"selected"
		}).appendTo(consel); 
		$('<option />',{ 
			val:"!=", 
			text:"不等于" , 
		}).appendTo(consel); 
		if(p_colattr != 'number'){
			$('<option>',{ 
				val:"like", 
				text:"包含"
			}).appendTo(consel);
		}
		
		if(p_colattr == 'number'  ||　p_colattr == 'date'){
			$('<option>',{ 
				val:">", 
				text:"大于"
			}).appendTo(consel);  
			$('<option>',{ 
				val:">=", 
				text:"大于等于"
			}).appendTo(consel);  
			$('<option>',{ 
				val:"<", 
				text:"小于"
			}).appendTo(consel);   
			$('<option>',{ 
				val:"<=", 
				text:"小于等于"
			}).appendTo(consel);   
		}
		
		
		if(p_colcompare){
			$(consel).val(p_colcompare);
		}
		
		$(conli).append(consel);
		//$(conli).append('<input  class="val" type="text">');
		var input_val = $('<input  class="val" type="text">').appendTo($(conli));
		if(p_colval){
			$(input_val).val(p_colval);
		}
		var conimg = $('<i class="fa fa-trash fa-lg"></i>').appendTo($(conli));
		$(conimg).bind('click',function(){
			$(this).parent().remove();
		});
	}
	
	//表单提交
	function sbt(){
		var rst = '';
		$('.conditonlist').find('li').each(function(){
			var cond_col = $(this).find('.col').attr("name");
			var cond_coldes = $(this).find('.col').val();
			var cond_compare = $(this).find('.compare').val();
			var cond_val = $(this).find('.val').val();
			if(cond_val){
				rst += cond_col + "###" + cond_compare + "###" + cond_val + "###" + cond_coldes + "," ;
			}
		})
		clsWin();
		parent.$('.myui-datagrid2').datagrid2('filterColumn', rst);
	}
	
	
    //关闭当前窗口
    function clsWin(){
    	parent.$('#showFiltersWin').window('close');
    }
</script>
<style type="text/css">
.form{width:670px;border:0px}
.myui-layout{padding-left:10px;border:0px;margin-top: 10px}
.myui-layout .conditonlist{margin-top: 10px;margin-left: 10px;}
.myui-layout .conditonlist li{margin-bottom: 5px;}
.myui-layout .conditonlist li select{margin-left: 5px;width:80px}
.myui-layout .conditonlist li input{margin-left: 5px;width:138px;}
.myui-layout .conditonlist li i{margin-left:5px;width: 12px;height: 15px;vertical-align: middle;cursor: pointer;}
.myui-layout .conditonlist li i:HOVER{color:red}
.myui-layout .collist{margin-top: 5px}
.myui-layout .collist li{padding-top: 5px;padding-left: 5px;cursor: pointer;}
.myui-layout .collist li label{cursor: pointer;}
.myui-layout .collist li:hover{background-color: #E0ECFF;border-color: #E0ECFF;}
</style>
</head>
<body>
<div class="myui-form">
	<div class="form" style="overflow-x:hidden;">
		<form id="form_input" method="post">
			<div class="myui-layout">
				<div class="rowgroup">
					<div class="content" headline="字段" style="width: 210px;height: 315px">
						<ul class="collist">
						</ul>
					</div>
					<div class="content" headline="条件" style="width: 440px;height: 315px">
						<ul class="conditonlist">
						</ul>
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