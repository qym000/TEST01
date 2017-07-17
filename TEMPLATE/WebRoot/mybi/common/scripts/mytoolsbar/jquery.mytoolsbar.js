/**
 * @description: jquery.mytoolsbar 明佑电子图/表工具条
 * 		********************************************
 * 		*       已实现:							   
 * 		*       enlargedView---放大视图工具         
 * 		*		dataSwitcher---图表切换工具         
 *      *       exportHandler--图表导出工具         
 *      *       sortHandler----chart排序工具
 *      *
 *      *       待实现:
 *      *       helper ----    帮助工具
 *      *		orgnavi ------ 机构导航工具
 *      ********************************************
 *      *		欢迎完善与扩展!
 *      ********************************************
 * @author:gzh
 * @date:2015-01-25
 * @modify content:
 * @modifier:
 * @modify date:
 */
(function($) {
	/**
	 * @description: jquery.mytoolsbar.enlargedView 放大视图工具
	 * @author:gzh
	 * @date:2015-01-25
	 * @modify content:
	 * @modifier:
	 * @modify date:
	 */
	$.fn.enlargedView = function(options) {
		
		// 默认配置项
		$.fn.enlargedView.defaults = {
			targetId : '', //必要,指定一个隐藏浮动div的id,不要和其他div的id重名.
			exportable: false, //需要导出时为true
			switchable : false, //需要图表切换时为true
			helper:false, //需要帮助时为true
			dataContent : '', // switchable为true时必要
			exportLoadingUrl : '',//需要导出Excel时必要
			exportExcelUrl : '', //需要导出Excel时必要
			chartId : '', //需要导出时必要
			paramsFunc : $.noop, //导出Excel和渲染datagrid的参数返回方法;
			chartImgType : 'JPG', //导出chart的图片类型(支持JPG/PNG),导出chart时必要.
			onOpened : $.noop, // 打开放大视图后时触发
			onClose : $.noop // 关闭放大视图前触发
		};
		
		// 变量设置;
		var opts = $.extend( {}, $.fn.enlargedView.defaults, options );
		var body = $("body");
		var base = this;
		
		// 初始化html
		initDiv();
		
		var hiddenDiv = $("#" + opts.targetId);
		
		// 放大视图工具按钮绑定事件;
		$(base).click(function(e){
		    var state = $(hiddenDiv).css("display");
			if (state == 'none') {
				$(".enlarged-view_mask").show();
				var absLeft = $(body).width() * 0.05;
				var absTop = $(body).height() * 0.05;
				var tWidth = $(body).width() * 0.9;
				var tHeight = $(body).height() * 0.9;
				$(hiddenDiv).css("width",tWidth);
				$(hiddenDiv).css("height",tHeight);
				$(hiddenDiv).show().stop().animate({
					top: absTop,
					left: absLeft
				}, 300);
				opts.onOpened();
			}
		});
		
		// 放大视图中的工具按钮--关闭;
		$(hiddenDiv).find("#enlargedView_closer").click(function (e){
			opts.onClose();
		    $(hiddenDiv).hide("300");
		    $(".enlarged-view_mask").hide();
		});
		
		// 放大视图中的工具按钮--图表切换;
		if (opts.switchable) {
			$(hiddenDiv).find("#enlargedView_switcher").click(function (){
				var chartObj,dataObj;
				$.each($(hiddenDiv).find("div"),function(){
					var tmp = $(this).attr("id").substring(0,1);
					if (tmp == 'c') {
						chartObj = $(this);
					}else {
						dataObj = $(this);
					}
				});
				var state = $(chartObj).css("display");
				if (state != 'none') {
					$(chartObj).hide();
					$(dataObj).show();
					if ($(dataObj).find("iframe").length > 0) {
						var params = opts.paramsFunc()
						$(dataObj).find("iframe")[0].contentWindow.refresh(params);
					}
				}else {
					$(dataObj).hide();
					$(chartObj).show();
					var ref = FusionCharts(opts.chartId);
				}
			});
		}
		
		// 放大视图中的工具按钮--导出;
		if (opts.exportable) {
			$(hiddenDiv).find("#enlargedView_exporter").click(function() {
				var chartObj,dataObj;
				$.each($(hiddenDiv).find("div"),function(){
					var tmp = $(this).attr("id").substring(0,1);
					if (tmp == 'c') {
						chartObj = $(this);
					}else {
						dataObj = $(this);
					}
				});
				if (opts.switchable) {
					var state = $(chartObj).css("display");
					if (state == 'none') {
						showExportLoading(opts.exportLoadingUrl);
						var params = opts.paramsFunc();
						var str = '';
						for(var p in params){  
						   // p 为属性名称，obj[p]为对应属性的值 
						   str += ("&"+ p + "=" + params[p]);
						}
						str = "?" + str.substring(1, str.length);
						window.location.href = opts.exportExcelUrl + str;
					}else {
						exportChart(opts.chartImgType,opts.chartId);
					}
				}else {
					var state = $(dataObj).css("display");
					if (state == 'none') {
						exportChart(opts.chartImgType,opts.chartId);
					}
				}
			});
		}
		
		// 初始化放大视图的html代码;
		function initDiv() {
			// 生成一个随机数,作为id的后缀;
			var timestamp = ((new Date()).valueOf()+"").substring(7);
			var num = Math.floor(Math.random() * ( 100 + 1));
			var random = timestamp + num;
			
			// 拼html代码;
			var string = '<div id="' + opts.targetId +'" class="enlarged-view" >';
			string += '<table align="center" width="100%" cellpadding="0" cellspacing="0" class="list-table">';
			string += '<tr><td height="5%" align="right" class="hidenDivTitle th2">';
			
			if (opts.switchable) {
				string += '<a href=### id="enlargedView_switcher" class="tools_switch" title="图/表切换"/>';
			}
			
			if (opts.exportable) {
				string += '<a href=### id="enlargedView_exporter" class="tools_export" title="导出"/>';
			}
			
			if (opts.helper) {
				string += '<a href=### id="enlargedView_helper" class="tools_help" title="帮助"/>';
			}
			
			string += '<a href=### id="enlargedView_closer" class="tools_close" title="关闭"/>';
			
			string += '</td></tr><tr><td height="95%">';
			string += '<div id="'+'c'+ random+'" style="width:100%;height:100%;"></div>';
			string += '<div id="'+'d'+ random+'" style="width:100%;height:100%;display:none;">';
			string += opts.dataContent;
			string += '</div></td></tr></table></div>';
			
			$(body).append(string);
			
			// 查看当前body是否有遮罩层div,没有给一个
			var flag = false;
			$.each($(body).find("div"), function(){
				if ($(this).hasClass("enlarged-view_mask")) {
					flag = true;
					return;
				}
			});
			
			if (!flag) {
				$(body).append('<div class="enlarged-view_mask"></div>');
			}
	
		}
		
		function exportChart(filetyp,chartId){
			var chartobj = FusionCharts(chartId);
			if(chartobj.hasRendered && chartobj.hasRendered()){
				//jsp文件中获取项目url的方式
				//var exportHandler = "${pageContext.request.scheme}://${pageContext.request.localAddr}:${pageContext.request.localPort}${pageContext.request.contextPath}/FCExporter";
				  
				//以下是js中获取方式
				var contextPath = window.location.pathname.split("/")[1];
				var basePath = window.location.protocol+"//"+window.location.host+"/"+contextPath;
				var exportHandler=basePath+"/FCExporter";
				chartobj.exportChart({
			   		exportFormat:filetyp,
			   		exportHandler:exportHandler,
			   		exportAction:"download"
			   	});
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','请在图表渲染完成后执行导出操作','warning');
			}
		}
		
		function showExportLoading(url) {
			 $.messager.progress({text:'数据导出中...'});
			 
			 //定义一个定时器每个2秒访问后台导出状态，导出状态为exported时，为导出完毕，清空定时器，关闭遮罩层
			 //导出状态为exception时出现异常，清空定时器，关闭遮罩层
			 loadingInterval = window.setInterval(function(){
				 $.get(url, {}, function(data){
					if(data == 'exported') {
						$.messager.progress('close');
						window.clearInterval(loadingInterval);
					} else if(data=="exception") {
						$.messager.alert('<s:text name="common_msg_info"/>','导出失败','warning');
						$.messager.progress('close');
						window.clearInterval(loadingInterval);
					}
				});
			}, 1500);
		}
		
		// 公开的方法之显示chart,targetId为传入的隐藏div的id,ref为图表引用,dataXml为chart的XML数据;
		$.fn.enlargedView.showChart = function(targetId,chartId,dataXml) {  
			var chartDivId = "";
			$.each($("#"+targetId).find("div"),function(){
				var tmp = $(this).attr("id").substring(0,1);
				if (tmp == 'c') {
				    $(this).css("display","block");
					chartDivId = $(this).attr("id");
				}else {
					$(this).css("display","none");
				}
			});
			var ref = FusionCharts(chartId);
			ref.setXMLData(dataXml);
		    ref.render(chartDivId);   
		    return;
		}; 
		
		// 公开的方法之显示数据表格,targetId为传入的隐藏div的id;
		$.fn.enlargedView.showDatagrid = function(targetId,params) {
			var dataDivId = "";
			$.each($("#"+targetId).find("div"),function(){
				var tmp = $(this).attr("id").substring(0,1);
				if (tmp == 'd') {
					$(this).css("display","block");
					dataDivId = $(this).attr("id");
				}else {
					$(this).css("display","none");
				}
			});
			if ($("#"+dataDivId).find("iframe").length > 0) {
				$("#"+dataDivId).find("iframe")[0].contentWindow.refresh(params);
			}
			
		};
		
	}
})(jQuery);

(function($) {
	/**
	 * @description: jquery.mytoolsbar.dataSwitcher 图/表切换工具
	 * @author:gzh
	 * @date:2015-01-25
	 * @modify content:
	 * @modifier:
	 * @modify date:
	 */
	$.fn.dataSwitcher = function(options) {
		
		// 默认配置项
		$.fn.dataSwitcher.defaults = {
			chartDiv : null,
			dataDiv : null,
			dataContent : '',
			chartLoadFunc : $.noop,
			onBeforeSwitch : $.noop,
			onAfterSwitch : $.noop,
			paramsFunc : $.noop
		};
		
		// 变量设置;
		var opts = $.extend( {}, $.fn.dataSwitcher.defaults, options );
		var base = this;
		var dataContent = opts.dataContent;
		var chartDiv = opts.chartDiv;
		var dataDiv = opts.dataDiv;
		
		initDiv();
		
		// 图标切换按钮事件绑定;
		$(base).click(function(e){
			opts.onBeforeSwitch();
		    var state = $(dataDiv).css("display");
			if (state == 'none') {
				$(chartDiv).hide();
				$(dataDiv).show();
				var params = opts.paramsFunc();
				if ($(dataDiv).find("iframe").length > 0) {
					$(dataDiv).find("iframe")[0].contentWindow.refresh(params);
				}
			}else {
				$(dataDiv).hide();
				$(chartDiv).show();
				opts.chartLoadFunc();
			}
			opts.onAfterSwitch();
		});
		
		// 初始化图表切换的html代码;
		function initDiv() {
			$(dataDiv).html(dataContent);
		}
		
		// 公开的方法之获取选择的项,targetId为初始化中的targetId;
		$.fn.dataSwitcher.refresh = function(dataDiv,params) {  
			if ($(dataDiv).find("iframe").length > 0) {
				$(dataDiv).find("iframe")[0].contentWindow.refresh(params);
			}
		};
		
	}
})(jQuery);

(function($) {
	/**
	 * @description: jquery.mytoolsbar.exportHandler 图/表导出工具
	 * @author:gzh
	 * @date:2015-01-25
	 * @modify content:
	 * @modifier:
	 * @modify date:
	 */
	$.fn.exportHandler = function(options) {
		
		// 默认配置项
		$.fn.exportHandler.defaults = {
			mode : "fit",// 可选项fit,chart,data;
			chartDiv : null,// fit时必选
			dataDiv : null,// fit时必须
			exportLoadingUrl : '',//需要导出Excel时必要
			exportExcelUrl : '', //需要导出Excel时必要
			exportChartId : 'chartId1', //需要导出chart时必要
			chartImgType : 'JPG', //导出chart的图片类型(支持JPG/PNG),导出chart时必要.
			exportParamsFunc : $.noop//导出excel要传入的参数初始化函数,return参数集对象;
		};
		
		// 变量设置;
		var opts = $.extend( {}, $.fn.exportHandler.defaults, options );
		var base = this;
		
		// 图表导出按钮事件绑定;
		$(base).click(function(e){
			if (opts.mode == 'fit') {
				var chartObj = $(opts.chartDiv);
				var dataObj = $(opts.dataDiv);
				var state = $(chartObj).css("display");
				if (state == 'none') {
					showExportLoading(opts.exportLoadingUrl);
					var params = opts.exportParamsFunc();
					var str = '';
					for(var p in params){  
					   // p 为属性名称，obj[p]为对应属性的值 
					   str += ("&"+ p + "=" + params[p]);
					}
					str = "?" + str.substring(1, str.length);
					window.location.href = opts.exportExcelUrl + str;
				}else {
					exportChart(opts.chartImgType,opts.exportChartId);
				}
			}else if (opts.mode == 'chart') {
				exportChart(opts.chartImgType,opts.exportChartId);
			}else if (opts.mode == 'data') {
				showExportLoading(opts.exportLoadingUrl);
				var params = opts.exportParamsFunc();
				var str = '';
				for(var p in params){  
				   // p 为属性名称，obj[p]为对应属性的值 
				   str += ("&"+ p + "=" + params[p]);
				}
				str = "?" + str.substring(1, str.length);
				window.location.href = opts.exportExcelUrl + str;
			}
		});
		
		function exportChart(filetyp,chartId){
			var chartobj = FusionCharts(chartId);
			if(chartobj.hasRendered && chartobj.hasRendered()){
				//jsp文件中获取项目url的方式
				//var exportHandler = "${pageContext.request.scheme}://${pageContext.request.localAddr}:${pageContext.request.localPort}${pageContext.request.contextPath}/FCExporter";
				  
				//以下是js中获取方式
				var contextPath = window.location.pathname.split("/")[1];
				var basePath = window.location.protocol+"//"+window.location.host+"/"+contextPath;
				var exportHandler=basePath+"/FCExporter";
				chartobj.exportChart({
			   		exportFormat:filetyp,
			   		exportHandler:exportHandler,
			   		exportAction:"download"
			   	});
			}else{
				$.messager.alert('<s:text name="common_msg_info"/>','请在图表渲染完成后执行导出操作','warning');
			}
		} 
		
		function showExportLoading(url) {
			 $.messager.progress({text:'数据导出中...'});
			 
			 //定义一个定时器每个2秒访问后台导出状态，导出状态为exported时，为导出完毕，清空定时器，关闭遮罩层
			 //导出状态为exception时出现异常，清空定时器，关闭遮罩层
			 loadingInterval = window.setInterval(function(){
				 $.get(url, {}, function(data){
					if(data == 'exported') {
						$.messager.progress('close');
						window.clearInterval(loadingInterval);
					} else if(data=="exception") {
						$.messager.alert('<s:text name="common_msg_info"/>','导出失败','warning');
						$.messager.progress('close');
						window.clearInterval(loadingInterval);
					}
				});
			}, 1500);
		}
		
	}
})(jQuery);

(function($) {
	/**
	 * @description: jquery.mytoolsbar.sortHandler 图形排序工具
	 * @author:gzh
	 * @date:2015-01-25
	 * @modify content:
	 * @modifier:
	 * @modify date:
	 */
	$.fn.sortHandler = function(options) {
		
		// 默认配置项
		$.fn.sortHandler.defaults = {
			targetId : "",
			sortArray : ["按机构","按金额"],
			defaultIndex : 0,
			scrollDiv : $("body"),
			onOpened : $.noop,
			onSelected : $.noop
		};
		
		// 变量设置;
		var opts = $.extend( {}, $.fn.sortHandler.defaults, options );
		var base = this;
		var body = $("body");
		var scrollDiv = opts.scrollDiv;
		
		initDiv();
		var targetDiv = $("#subSelecter_" + opts.targetId);
		var targetDivSorter = $("#subSelecter_" + opts.targetId + " .sub_sorter");
		
		
		$(base).click(function(e){
			var state = $(targetDiv).css("display");
			if (state == 'none') {
				var absLeft = e.pageX;
				var tmp = absLeft + $(targetDiv).width();
				if (tmp > $(body).width()) {
					absLeft = absLeft - $(targetDiv).width();
				}
				var scrollHeight = $(scrollDiv).scrollTop();
				var absTop = e.pageY;
				$(targetDiv).show().stop().animate({
					top: absTop,
					left: absLeft
				}, 10);
				$.each($(targetDiv).find("div"),function(){
					if ($(this).hasClass("sub_sorter")) {
						$(this).show();
					}
				});
				opts.onOpened();
			}else {
				$(targetDiv).find("div").hide();
				$(targetDiv).hide();
			}
		});
		
		$(targetDivSorter).find("a").click(function(e) {
			var tmpObj = $(this);
			$.each($(targetDivSorter).find("a"),function(){
				if ($(this).hasClass("selected")) {
					$(this).removeClass("selected").addClass("normal");
				}
			});
			$(tmpObj).removeClass("normal").addClass("selected");
			$(targetDiv).find("div").hide();
			$(targetDiv).hide();
			opts.onSelected();
		});
		
		
		// 初始化图表切换的html代码;
		function initDiv() {
			// 查看当前body是否有选择隐藏div,没有给一个
			var flag = false;
			var id = "subSelecter_" + opts.targetId;
			$.each($(body).find("div"), function(){
				if ($(this).attr("id") == id) {
					flag = true;
					return;
				}
			});
			
			if (!flag) {
				$(body).append('<div id="'+id+'" class="subSelecter"></div>');
			}
			
			// 检查是否有排序选择div,没有给一个,有了重新初始化;
			flag = false;
			$.each($("#"+id).find("div"), function(){
				if ($(this).hasClass("sub_sorter")) {
					flag = true;
					return;
				}
			});
			
			var str = '';
			var arr = opts.sortArray;
			var index = opts.defaultIndex;
			if (index > arr.length-1) {
				index = 0;
			}
			
			if (flag) {
				var obj = $("#" + id + " .sub_sorter");
				$(obj).find("a").remove();
				if (arr.length > 0) {
					for (var i = 0; i < arr.length; i++) {
						if ( i == index) {
							str += '<a class="selected">' + arr[i] + '</a>';
						}else {
							str += '<a class="normal">' + arr[i] + '</a>';
						}
					}
				}
				$(obj).append(str);
			}else {
				var obj = $("#"+id);
				str += '<div class="sub_sorter" style="display:none;">';
				str += '<p>排序:</p>';
				if (arr.length > 0) {
					for (var i = 0; i < arr.length; i++) {
						if ( i == index) {
							str += '<a class="selected">' + arr[i] + '</a>';
						}else {
							str += '<a class="normal">' + arr[i] + '</a>';
						}
					}
				}
				str += '</div>';
				$(obj).append(str);
			}
			
		}
		
		// 公开的方法之获取选择的项,targetId为初始化中的targetId;
		$.fn.sortHandler.getSelected = function(targetId) {  
			var targetDiv = $("#subSelecter_" + targetId);
			var targetDivSorter = $(targetDiv).find(".sub_sorter");
			var tmp;
			$.each($(targetDivSorter).find("a"),function(){
				if ($(this).hasClass("selected")) {
					tmp = $(this).text();
				}
			});
		    return tmp;
		}; 
	}
})(jQuery);

