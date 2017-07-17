<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ include file="/mybi/gdp/scripts/gdp.constants.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<title></title>
	<link href="${ctx}/mybi/etl/themes/${apptheme}/etl.css" rel="stylesheet" type="text/css"/>
	<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
	<script type="text/javascript">
	$(function(){
		var data = cycleObj["CYCLE"];
		
		$("#cycleHolidayUnit").combo({
			mode:'local',
			valueField:'id',
			textField:'nam',
			data : data,
			isCustom:false,
			panelHeight:185,
			// 选择触发
		    onSelect:function(r) {
		        if(r.id == "D"){
		        	data = cycleObj["D"];
		        }else if(r.id == "W"){
		        	data = cycleObj["W"];
		        }else if(r.id == "X"){
		        	data = cycleObj["X"];
		        }else if(r.id == "M"){
		        	data = cycleObj["M"];
		        }else if(r.id == "Q"){
		        	data = cycleObj["Q"];
		        }else if(r.id == "R"){
		        	data = cycleObj["R"];
		        }else if(r.id == "S"){
		        	data = cycleObj["S"];
		        }else if(r.id == "Y"){
		        	data = cycleObj["Y"];
		        }
		        $("#cycleHolidayDetail").combo("loadData", data);
		    }
		});
		
		$("#cycleHolidayDetail").combo({
			mode:'local',
			valueField:'id',
			textField:'nam',
			data : [{id:"D0", nam:"<s:text name='etl_holiday_day_first'/>"}],
			isCustom:false,
			panelHeight:185,
			onSelect:function(r){
				addCycleHoliday();
			}
		});
	});
	
	/**
	 * 表单提交
	 */
	function sbt(){
		$("#cycle", parent.document).val(getCycleholiday());
		//$("#cycle", parent.document).focus();//添加完后获得焦点，删除不能为空的提示
		clsWin();
	}
	
	/**
	 * 关闭当前窗口
	 */
    function clsWin(){
    	parent.$('#inputWin').window('close');
    }
	
	/**
	 * 添加周期
	 */
	 var cycle_holiday = "";
	 function addCycleHoliday(){
		 var text = $.trim($("#cycleHolidayDetail").val());
		 var val = $.trim($("#cycleHolidayDetail").combo("getValue"));
		 
		 if(val == null || val == ""){
			 return false;
		 }
		 
		 var html = "<tr><td value="+val+" width='92%'>"+text+"</td><td><img src='${ctx}/mybi/gdp/themes/${apptheme}/images/delete.png' class='cycle_del' onclick='delCurRow(this);'/></td></tr>";
		 var $tbodydata = $("#cycleHolidayTbody tr");
		 if($tbodydata.length > 0){
			 var flag = false;
			 $tbodydata.each(function(){
				 if($(this).find("td").eq(0).attr("value") == val){//如果已经添加过了，那么不在添加
					 flag = true;
					 return false;
				 }
			 });
			 
			 if(!flag){
				 $("#cycleHolidayTbody").append(html);
			 }
			 
		 }else{
			 $("#cycleHolidayTbody").append(html);
		 }
	 }
	
	/**
	 * 删除周期
	 */
	function delCurRow(obj){
		$(obj).parent().parent().remove();
	}
	
	/**
	 * 获得周期字符串
	 */
	function getCycleholiday(){
		cycle_holiday = "";
		var $tbodydata = $("#cycleHolidayTbody tr");
		if($tbodydata.length > 0){
			$tbodydata.each(function(){
				cycle_holiday += $(this).find("td").eq(0).attr("value") + "|";
			});
			return cycle_holiday;
		}else{
			return "";
		}
	}
	</script>
	</head>
	<body>
		<div class="myui-form">
			<div class="form" style="height:340px;">
				<form id="form_input" method="post">
					 <div class="item">
						<ul>
							<li class="desc">周期：</li>
							<li>
								<input id="cycleHolidayUnit" class="myui-text" style="width:120px;"/>
								<input id="cycleHolidayDetail" class="myui-text" style="width:150px;"/>
							</li>
							<li><img src="${ctx}/mybi/gdp/themes/${apptheme}/images/add.png" style="vertical-align:middle;" class="add_ico" onclick="addCycleHoliday();"/></li>
						</ul>
					 </div>
					 <div class="item">
						<ul>
							<li class="desc">&nbsp;</li>
							<li>
								<div style="width:275px;border:1px #D2D2D2 solid;background-color:#FBFBFB;height:150px;">
									<table width="100%">
										<tbody id="cycleHolidayTbody">${cycle}</tbody>
									</table>
								</div>	
							</li>
						</ul>
					 </div>
				 </form>
			</div>
			<div class="operate">
				<a class="button" href="javascript:void(0);" onclick="sbt();"><s:text name="common_action_submit"/></a>
				<a class="button" href="javascript:void(0);" onclick="clsWin();" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
			</div>
		</div>
	</body>
</html>