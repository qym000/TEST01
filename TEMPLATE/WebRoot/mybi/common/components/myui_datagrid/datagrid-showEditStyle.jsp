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
  parent.$('#showEditStyleWin').window('close');
}

$(function(){
	var v_dsJson = window.parent.parent.dsJson;
	var v_dsJson_opts = v_dsJson.opts;
	var p_dsJson_cols = v_dsJson.cols;
	var opts = parent.$('.myui-datagrid2').datagrid2('options');
	var frozenCnt = 0;
	if(opts.frozenColumns[0]){
	  frozenCnt = opts.frozenColumns[0].length;
	}
	if(v_dsJson_opts.width)
		$("#dg_width").val(v_dsJson_opts.width);
	if(v_dsJson_opts.height)
		$("#dg_height").val(v_dsJson_opts.height);
	if(v_dsJson_opts.showColumn)
		$("#dg_showColumn").attr("checked", true);
	if(v_dsJson_opts.showFilters)
		$("#dg_showFilters").attr("checked", true);
	if(v_dsJson_opts.snapshot)
		$("#dg_snapshot").attr("checked", true);
	if(v_dsJson_opts.pagestyle){
		$("#dg_pager").val(v_dsJson_opts.pagestyle);
	}
	
	if(v_dsJson_opts.pagesize)
		$("#dg_pagesize").val(v_dsJson_opts.pagesize);
	else 
		$("#dg_pagesize").val(15);
		
	if(v_dsJson_opts.showExport){
		$("#dg_showExport").attr("checked", true);
		$("#dg_exportFileName").attr('readonly', false);
		$("#dg_selectMaxExportCnt").attr('readonly', false);
		$('#dg_exportpass').attr('readonly', false);
		if(v_dsJson_opts.exportFileName)
			$("#dg_exportFileName").val(v_dsJson_opts.exportFileName);
		if(v_dsJson_opts.selectMaxExportCnt)
			$("#dg_selectMaxExportCnt").val(v_dsJson_opts.selectMaxExportCnt);
		if(v_dsJson_opts.exportpass)
			$("#dg_exportpass").val(v_dsJson_opts.exportpass);
	}
	
	$('#dg_paramcnt').combo({
		mode : "local",
		data : [{key:'一列', value:1},
		         {key:'两列', value:2},
		         {key:'三列', value:3},
		         {key:'四列', value:4}],
	    valueField : 'value',
	    textField : 'key',
	    defaultValue : '2'
	});
	
	if(v_dsJson_opts.paramLineCnt)
		 $("#dg_paramcnt").combo('setValue', v_dsJson_opts.paramLineCnt);
	
	$("#dg_showExport").change(function() { 
		if($(this).attr('checked')){
			$("#dg_exportFileName").attr('readonly', false);
			$("#dg_selectMaxExportCnt").attr('readonly', false);
			$("#dg_exportpass").attr('readonly', false);
			$("#dg_exportFileName").val('列表导出 ');
			$("#dg_selectMaxExportCnt").val(0);
		}else{
			$("#dg_exportFileName").attr('readonly', true);
			$("#dg_selectMaxExportCnt").attr('readonly', true);
			$("#dg_exportpass").attr('readonly', true);
			$("#dg_exportFileName").val('');
			$("#dg_selectMaxExportCnt").val('');
			$("#dg_exportpass").val('');
		}
	}); 
	
	for(var i=0; i<p_dsJson_cols.length; i++){
		var v_dsObj = p_dsJson_cols[i];
		
		var v_datatype = "string";
		if(v_dsObj.datatype){
			v_datatype = v_dsObj.datatype;
		}
		
		var v_dataformat = "";
		if(v_dsObj.dataformat){
			v_dataformat = v_dsObj.dataformat;
		}
		
		var v_width = "150";
		if(v_dsObj.width){
			v_width = v_dsObj.width;
		}
		
		var v_align = "left";
		if(v_dsObj.align){
			v_align = v_dsObj.align;
		}
		
		var d_tr = $('<tr></tr>').appendTo($('#databody'));
		
		var v_coldes_display = v_dsObj.coldesc;
		if(v_coldes_display.length > 22) {
			v_coldes_display = v_coldes_display.substr(0, 25) + '...';
		}
		$(d_tr).append('<td class="baseAttr" coldesc="'+v_dsObj.coldesc+'" colname="'+v_dsObj.colname+'" colname_ognl="'+v_dsObj.colname_ognl+'" dsid="'+v_dsObj.dsid+'"><input style="width:340px" class="coldesc myui-text" value="'+v_dsObj.coldesc+'"/></td>');
		//$(d_tr).append('<td class="baseAttr" coldesc="'+v_dsObj.coldesc+'" colname="'+v_dsObj.colname+'" colname_ognl="'+v_dsObj.colname_ognl+'" dsid="'+v_dsObj.dsid+'"><span title="'+v_dsObj.coldesc+'">'+v_coldes_display+'</span></td>');
		$(d_tr).append('<td class="inputAttr"><input class="autowidth" type="checkbox"/>&nbsp;<input class="width myui-text" type="text" value="'+v_width+'"></td>');
		
	/*	if (frozenCnt > i ) {
			$(d_tr).find('.inputAttr .width').show();
			$(d_tr).find('.inputAttr .width').css('width', '90px');
			$(d_tr).find('.inputAttr .autowidth').remove();
		} else {*/
			if(v_dsObj.autowidth == false) {
				$(d_tr).find('.inputAttr .width').show();
			} else {
				$(d_tr).find('.inputAttr .autowidth').attr('checked', 'true');
				$(d_tr).find('.inputAttr .width').hide();
			}
			
			$(d_tr).find('.inputAttr .autowidth').change(function(){
			    if($(this).is(':checked')) {
			    	$(this).parent().find('.width').hide();
			    } else {
			    	$(this).parent().find('.width').show();
			    }
			})
	//	}
		
		
		var datatypesel=$('<select class="datatype myui-text"/>',{name:"datatype"}); 
		$('<option />',{ 
			val:"string", 
			text:"字符类型" , 
			selected:"selected"
		}).appendTo(datatypesel); 
		$('<option>',{ 
			val:"number", 
			text:"数字类型"
		}).appendTo(datatypesel);
		$('<option>',{ 
			val:"date", 
			text:"日期类型"
		}).appendTo(datatypesel);
		var v_td = $('<td class="inputAttr"></td>').appendTo($(d_tr));
		$(v_td).append($(datatypesel));
		$(datatypesel).val(v_datatype);
		$(datatypesel).attr('disabled',true);
		
		
		
		var dataformatsel=$('<select class="dataformat myui-text"/>',{name:"dataformat"});
		$('<option>',{ 
			val:"", 
			text:"正常显示"
		}).appendTo(dataformatsel);
		
		if($(datatypesel).val() == 'number') {
			$('<option>',{ 
				val:"num-ths", 
				text:"千分位分隔"
			}).appendTo(dataformatsel);
		}
		
		var v_td = $('<td class="inputAttr"></td>').appendTo($(d_tr));
		$(dataformatsel).val(v_dataformat);
		$(v_td).append($(dataformatsel));
	    
		/* 编辑字段格式，此处暂时注释掉，不要删除，引用页面datagrid-editColFormat.jsp
	    var editColFormat = $('&nbsp;<span class="editColFormat"> <i class="fa fa-edit"></i>格式 </span>&nbsp;');
		$(v_td).append($(editColFormat));
		$(editColFormat).click(function(){
			var d_tmptr = $(this).parent().parent();
			var v_param = {
					"type" : $(d_tmptr).find('.inputAttr select').val(),
					"desc" :　$(d_tmptr).find('.baseAttr').html(),
					"name" : $(d_tmptr).find('.baseAttr').attr('colname_ognl')
			}
			
			$("#editColFormatWin").window({
				open : true,
				param : v_param,
				headline:'编辑字段（'+ $(d_tmptr).find('.baseAttr').html() +'）数据格式',
				content:'<iframe id="addCustomColframe" src="${ctx}/mybi/common/components/myui_datagrid/datagrid-editColFormat.jsp" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:600,
				top : "10",
				panelHeight:350
			});
		}) */
		
		var alignsel=$('<select class="align myui-text"/>',{name:"align"}); 
		$('<option />',{ 
			val:"left", 
			text:"左对齐" , 
			selected:"selected"
		}).appendTo(alignsel); 
		$('<option>',{ 
			val:"center", 
			text:"居中"
		}).appendTo(alignsel);
		$('<option>',{ 
			val:"right", 
			text:"右对齐"
		}).appendTo(alignsel);
		var v_td_align = $('<td class="inputAttr"></td>').appendTo($(d_tr));
		$(v_td_align).append($(alignsel));
		
		$(alignsel).val(v_align);
	}
})

//关闭当前窗口
function sbt(){
	var cols = [];
	$("#databody").children().each(function(){
		cols.push({
			"datatype" : $(this).find('.datatype').val(),
			"width"    : $(this).find('.width').val(),
			"autowidth"    : $(this).find('.autowidth').is(':checked'),
			"align"    : $(this).find('.align').val(),
			"dsid"    : $(this).find('.baseAttr').attr('dsid'),
			"colname"  : $(this).find('.baseAttr').attr('colname'),
			"colname_ognl" : $(this).find('.baseAttr').attr('colname_ognl'),
			"coldesc"  : $(this).find('.baseAttr').find('.coldesc').val(),
			"dataformat" :  $(this).find('.dataformat').val()
		});
	})
	
	var opts = { opts: {
						width              : $("#dg_width").val(),
						height             : $("#dg_height").val(),
						showColumn         : $("#dg_showColumn").is(':checked') ,
						showFilters        : $("#dg_showFilters").is(':checked') ,
						snapshot           : $("#dg_snapshot").is(':checked') ,
						pagestyle          : $("#dg_pager").val(),
						showExport         : $("#dg_showExport").is(':checked'),
						exportFileName     : $("#dg_exportFileName").val(),
						selectMaxExportCnt : $("#dg_selectMaxExportCnt").val(),
						exportpass         : $("#dg_exportpass").val(),
						paramLineCnt       : $("#dg_paramcnt").combo('getValue'),
						pagesize           : $("#dg_pagesize").val()
						
					},
				 cols : cols
	}
	$.extend(window.parent.parent.dsJson, opts);
	window.parent.reloadQuery();
	clsWin();
}
</script>
<style>
#collist {margin-top: 10px}
#collist table{width:780px;}
.myui-text{width:100px}
.width{width:70px}
.editColFormat {color:#374fff;cursor: pointer;font-size: 12px}
.col-tips{font-size: 9px;margin: 0 0 5px 20px}
#collist table .baseAttr{width:354px}
#collist table .inputAttr{width: 105px}
</style>
</head>
<body>
<div id="editColFormatWin"></div>
<div class="myui-form">
	<div class="form">
		<form id="form_input" method="post">
			 <div class="item">
				<ul>
					<li style="margin-left: 20px">表格高度：</li>
					<li><input id="dg_height" name="dg_height" style="width:110px" class="myui-text"/></li>
					<li style="margin-left: 10px">表格宽度：</li>
					<li><input id="dg_width" name="dg_width" style="width:110px" class="myui-text"/></li>
				<!-- /ul>
			 </div>
			 <div class="item">
				<ul -->
					<li style="margin-left: 10px">每页显示：</li>
					<li><input id="dg_pagesize" name="dg_pagesize" style="width:110px" class="myui-text"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
					<li style="margin-left: 10px">查询条件：</li>
					<li><input id="dg_paramcnt" name="dg_paramcnt" style="width:108px" class="myui-text"/></li>
					</ul>
			 </div>
			<!-- div class="item">
				<ul>
					<li style="margin-left: 20px">表格宽度：</li>
					<li><input id="dg_height" name="dg_height" style="width:100px" class="myui-text"/>&nbsp;px</li>
				</ul>
			 </div-->
			 <div class="item">
				<ul>
					<li style="margin-left: 20px">显示按钮：</li>
					<li><input type="checkbox" id="dg_showColumn" name="dg_showColumnWin"/>&nbsp;选择列
					&nbsp;<input type="checkbox" id="dg_showFilters" name="dg_showFiltersWin"/>&nbsp;列筛选
					&nbsp;<input type="checkbox" id="dg_snapshot" name="dg_snapshot"/>&nbsp;快照
					</li>
					<li>&nbsp;&nbsp;
					<select id="dg_pager" class="dataformat myui-text"><option value="default">默认分页</option><option value="hide">不显示</option><option value="style1">样式1</option></select>
					</li>
				<!-- /ul>
			 </div>
			 <div class="item">
				<ul -->
					<li style="margin-left: 10px"><input type="checkbox" id="dg_showExport" name="dg_showExport" value="true"/>&nbsp;导出
					</li>
					<li style="margin-left: 10px">文件名&nbsp;</li>
					<li><input style="width:85px;" readonly="readonly" id="dg_exportFileName" name="dg_exportFileName"  class="myui-text"/></li>
					<li style="margin-left: 10px">最大条数&nbsp;</li>
					<li><input style="width:50px;" readonly="readonly" id="dg_selectMaxExportCnt" name="dg_selectMaxExportCnt"  class="myui-text"/></li>
					<li style="margin-left: 10px">密码&nbsp;</li>
					<li><input style="width:50px;" readonly="readonly" id="dg_exportpass" name="dg_exportpass"  class="myui-text"/></li>
					
				</ul>
			 </div>
		 </form>
		 
	<div class="myui-datagrid" id="collist">
	    <div class="col-tips"><i class="fa fa-lightbulb-o fa-2x"></i>&nbsp;提示:‘宽度’列默认为自适应宽度，取消多选框则可以进行固定宽度的设置</div>
		<table>
			<tr>
				<th>字段</th>
				<th>宽度</th> 
				<th>数据类型</th>
				<th>显示格式</th>
				<th>对齐方式</th>
			</tr>
			<tbody id="databody">
			</tbody>
		</table>

	</div>
	</div>
	
	<div class="operate">
		<a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
		<a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
	</div>
</div>

</body>
</html>

