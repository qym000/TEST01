<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@ include file="/mybi/common/include/js.jsp" %>
	<script type="text/javascript" src="${ctx}/mybi/common/script/lib/fusioncharts/FusionCharts.js"></script>
	<script type="text/javascript">
		<!--
			var myChart = new FusionCharts("${ctx}/mybi/common/script/lib/fusioncharts/MSColumn2D.swf", "chartId1", "100%", "100%", "0", "1");
			myChart.configure({"InvalidXMLText":"无效数据","ChartNoDataText":"没有数据","ParsingDataText":"数据加载中……"});
			var myChart2 = new FusionCharts("${ctx}/mybi/common/script/lib/fusioncharts/Column2D.swf", "chartId2", "100%", "100%", "0", "1");
			myChart2.configure({"InvalidXMLText":"无效数据","ChartNoDataText":"没有数据","ParsingDataText":"数据加载中……"});
		    $(document).ready(function(){
		    	$('#ch').accordion({
		    	    onSelect:function(title){
		    	    	if (title == '<s:text name="logals_dayViews"/>'){
			    	    	$.ajax({
				    	    	url : "${ctx}/pim_sys-log-analysis!findSysMenuTimePoint.action",
				    	    	async : true,
				    	    	data : {firstLvlMenuId:"${firstLvlMenuId}",
					    	    		subMenuId:"${subMenuId}",
						    	    	menuName:"${menuName}"
				    	    			},
	    	    				success : function (data){
				    	    				var chartRef = FusionCharts("chartId1");
				    	    				chartRef.setXMLData(data);        
				    	    				chartRef.render("chart1");
				    	    			},
				    	    	datatype : 'text'
				    	    });
			    	    }else if (title == '<s:text name="logals_periodViews"/>'){
			    	    	$.ajax({
				    	    	url : "${ctx}/pim_sys-log-analysis!findSysMenuMonView.action",
				    	    	async : true,
				    	    	data : {firstLvlMenuId:"${firstLvlMenuId}",
					    	    		subMenuId:"${subMenuId}",
						    	    	menuName:"${menuName}"
				    	    			},
	    	    				success : function (data){
				    	    				var chartRef = FusionCharts("chartId1");
				    	    				chartRef.setXMLData(data);        
				    	    				chartRef.render("chart2");
				    	    			},
				    	    	datatype : 'text'
				    	    });
				    	}else if (title == '<s:text name="logals_monthViews"/>') {
				    		$.ajax({
				    	    	url : "${ctx}/pim_sys-log-analysis!findSysMenuEveryMonsView.action",
				    	    	async : true,
				    	    	data : {firstLvlMenuId:"${firstLvlMenuId}",
					    	    		subMenuId:"${subMenuId}",
						    	    	menuName:"${menuName}"
				    	    			},
	    	    				success : function (data){
				    	    				var chartRef = FusionCharts("chartId2");
				    	    				chartRef.setXMLData(data);        
				    	    				chartRef.render("chart3");
				    	    			},
				    	    	datatype : 'text'
				    	    });
				    	}
		    	    }
		    	}); 
		    	$('#ch').accordion("select","<s:text name='logals_dayViews'/>");
		    });

		    function drillLog(params){
			    var arr = params.split(",");
			    var selType = arr[0];
			    var temp = arr[1];
			    window.location.href="${ctx}/pim_sys-log-analysis!toLoglist.action?firstLvlMenuId=${firstLvlMenuId}&subMenuId=${subMenuId}&selType="+selType+"&temp="+temp+"&menuName=${menuName}";
			}

			function forwardTo(id){
				if (id == 1){
					window.location.href="${ctx}/pim_sys-log-analysis!toDatalist.action";	
				}
			}
		    
		// -->
	</script>
</head>
<body style="margin:0px 0px;margin:0px 0px;overflow:visible;">
<div class="easyui-layout" data-options="fit:true">
    <div  data-options="region:'center',border:false">
    	<div id="ch" class="easyui-accordion" data-options="iconCls:'icon-ok',fit:true" style="border-bottom: none;">
			<div title="<s:text name='logals_dayViews'/>" data-options="iconCls:'icon-ok'" style="overflow:auto;padding:10px;">
				<div id="chart1" style="width: 80%; height: 350px;">
				</div>
			</div>
			<div title="<s:text name='logals_periodViews'/>" data-options="iconCls:'icon-ok',selected:true" style="overflow:auto;padding:10px;">
				<div id="chart2" style="width: 80%; height: 350px;">
				</div>
			</div>
			<div title="<s:text name='logals_monthViews'/>" data-options="iconCls:'icon-ok'" style="overflow:auto;padding:10px;">
				<div id="chart3" style="width: 80%; height: 350px;">
				</div>
			</div>
		</div>
    </div>
</div>

</body>
</html>	