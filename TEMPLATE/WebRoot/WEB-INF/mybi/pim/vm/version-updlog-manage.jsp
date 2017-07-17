<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
		<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
		<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidatorRegex.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/jQuery.md5.js"></script>
		<style type="text/css">
		.superlink {
			color: #0066cc;
			text-decoration: underline;
			cursor: pointer;
			text-align: left;
		}
		
		.superlink:hover {
			color: #eb6100;
		}
		</style>
		<script type="text/javascript">
		$(function(){
			cx(1);
		});
		
		/**
		 * 初始化所有組件
		 */
	    function cx(page){
			//参数
			var param={
					"log.code" : "${log.code}",
					page : page
			};
			
			//开启蒙板层
			tmp_component_before_load("datagrid");
			//提交
			$.post("vm_version!findUpdLogPager.action",param,function(data){ 
	    		$(".myui-datagrid-pagination").html(data.datapage);
	    		var _data="";
	    		if(data.datalist.length>0){
		    		$.each(data.datalist,function(idx,item){
		    			_data+="<tr>";
		    			_data+="<td>"+item.filename+"</td>";
		    			_data+="<td>"+item.updtyp+"</td>";
		    			_data+="<td>"+item.cendat+"</td>";
		    			_data+="<td>"+item.userid+"</td>";
		    			_data+="</tr>";
					});
	    		}else{
	    			_data+="<tr><td colspan="+$(".myui-datagrid table tr th").length+">"+"没有数据"+"</td></tr>";   //没有符合要求的记录！
	    		}
				$("#databody").html(_data);
				
				//关闭蒙板层
				tmp_component_after_load("datagrid");
	        },"json"); 	
		}
		</script>
	</head>
	<body>
		<div class="myui-datagrid" style="width:790px;height:520px;">
			<table style="width:780px;">
				<tr>
					<th>文件名称</th>
					<th>变动类型</th>
					<th>升级时间</th>
					<th>操作用户</th>
				</tr>
				<tbody id="databody"></tbody>
			</table>
			<div class="myui-datagrid-pagination"></div>
		</div>
	</body>
</html>