//获取上下文
function getContextPath() {
	var obj = window.location;
	return obj.pathname.split("/")[1];
}

// 写cookies
function setCookie(name, value) {
	var Days = 30;
	var exp = new Date();
	exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
	document.cookie = name + "=" + escape(value) + ";expires="+ exp.toGMTString();
}

// 读取cookies
function getCookie(name) {
	var arr, reg = new RegExp("(^| )" + name + "=([^;]*)(;|$)");

	if (arr = document.cookie.match(reg)){
		return unescape(arr[2]);
	}else{
		return null;
	}
}

// 删除cookies
function delCookie(name) {
	var exp = new Date();
	exp.setTime(exp.getTime() - 1);
	var cval = getCookie(name);
	if (cval != null) {
		document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
	}
}

//动作权限过滤
function actionAuthFilter(){
	
	//如果不涉及权限则直接退出
	if($("*[actionCode]").length == 0) {
		return false;
	}
	//隐藏所有属性中带actionCode
	$("*[actionCode]").hide();
	//显示有权限的
	$.post("main-portal!getSysActionJSONArrayWithAuth.action",{},function(data){ 
		if(data.datalist.length>0){
    		$.each(data.datalist,function(idx,item){
    			$("*[actionCode="+item.code+"]").show();
			});
		}
    },"json");
}

//动作权限过滤(以前的版本)
function actionAuthFilter2(actionlist){
	var obj = $.parseJSON(actionlist); 
  　　	for(var i=0;i<obj.length;i++){
  　　		$("*[actionCode="+obj[i].code+"]").show();
  　　	}
}

//导航路径
function loadLocationLeading(authMenuId,lang){
	var locationHTML="<ul class='index'>";
	/*if(lang=="zh"){
		locationHTML+="<li>导航路径：</li>";  
	}else{
		locationHTML+="<li>Navigate：</li>";  
	}*/
	$.post("main-portal!getLocationListJSONArray.action",{authMenuId:authMenuId},function(data){ 
		if(data.datalist.length>0){
			locationHTML+=arr2liStr(data.datalist,lang);
		}
		locationHTML+="</ul>";
		locationHTML+= "<li class='border'>&nbsp;</li>";
		$("div.myui-template-top-location").html(locationHTML);
		$("div.myui-template-top-location").find('.border').css('height', $('body').height() - 31);
    },"json");
	
}

//生成导航中径html代码
function arr2liStr(locArr,lang){
	var _str="";
	$.each(locArr,function(idx,item){
		if(item.url!=""){
			if(idx==locArr.length-1){
				_str+="<li class='liindex"+idx+"'>";
    	  		if(idx>=1){
    	  			_str+=" > ";
    	  		}
    	  		if(lang=="en"){
    	  			_str+=item.namEg;
				}else{
					_str+=item.nam;
				}
    	  		_str+="&nbsp;</li>";
			}else{
				if(item.url.indexOf("?")!=-1){
					_str+="<li class='index_current liindex"+idx+"'>";
    	  	 		if(idx>=1){
    	  	 			_str+=" > ";
    	  	 		}	
    	  	 		_str+="<a href='javascript:void(0);' onclick='locationClick("+"\""+item.id+"\",\""+item.url+"\","+idx+")' >";
					if(lang=="en"){
						_str+=item.namEg;
    				}else{
    					_str+=item.nam;
    				}
					_str+="</a>&nbsp;</li>";
				}else{
					_str+="<li class='index_current liindex"+idx+"'>";
					if(idx>=1){
						_str+=" > ";
    	  	 		}
					_str+="<a href='javascript:void(0);' onclick='locationClick("+"\""+item.id+"\",\""+item.url+"\","+idx+")' >";
    				if(lang=="en"){
    					_str+=item.namEg;
    				}else{
    					_str+=item.nam;
    				}
    				_str+="</a>&nbsp;</li>";
				}
			}
		}else{
			_str+="<li class='liindex"+idx+"'>";
			if(idx>=1){
				_str+=" > ";
			}
			if(lang=="en"){
				_str+=item.namEg;
			}else{
				_str+=item.nam;
			}
		}
	});
	return _str;
}

//点击导航路径中的连接
function locationClick(id,url,idx){
	if(id!=null && id!=""){//真实的菜单
		if(url.indexOf("?")!=-1){
			location.href=url+"&authTyp=menu&authMenuId="+id;
		}else{
			location.href=url+"?authTyp=menu&authMenuId="+id;
		}
	}else{
		$.post("main-portal!removeUnneedLocation.action",{idx:idx},function(data){ 
			location.href=url;
	    },"json");
	}
}

/**
 * 监控数据是否导出完毕
 */
 function monitorExportStatus(url) {
	 //进行中
	 tmp_component_before_load("datagrid");
	 
	 //定义一个定时器每个2秒访问后台导出状态，导出状态为exported时，为导出完毕，清空定时器，关闭遮罩层
	 //导出状态为exception时出现异常，清空定时器，关闭遮罩层
	 loadingInterval = window.setInterval(function(){
		 $.get(url, {}, function(data){
			if(data == 'exported') {
				tmp_component_after_load("datagrid");
				window.clearInterval(loadingInterval);
			} else if(data=="exception") {
				//导出失败
				$.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_exportfail"/>','info');
				tmp_component_after_load("datagrid");
				window.clearInterval(loadingInterval);
			}
		});
	}, 1500);
}
 
 /**
  * @description: fusioncharts图表导出
  * @param: filetyp：要导出的图片格式JPG|PNG|PDF 
  * @param: chartobj：目标图表的引用
  * @author:june
  * @date:2014-12-25
  * @modify content:
  * @modifier:
  * @modify date:
  */
 function exportChart(filetyp,chartobj){  
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
 
 /**
  * @description:导出Excel时页码和数据的定制，防止数据量过大，内存溢出
  * @param:
  * @author:june
  * @date:2014-12-25
  * @modify content:
  * @modifier:
  * @modify date:
  */
 function exportExcelMadePageRows(){
 	$("#export_data_made_page_rows").window({
 		title:'导出页码和导出条数定制',
 		content: '<iframe src="excel-export!toPageRowsMade.action" scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
 		width:400,
 		height:200,
 		modal:true
 	});
 }

/* *//**
  * 页面自适应这里要匹配所有easyui-layout布局的div
  * 所以用class选择器匹配，不用为每个div指定id了
  *//*
 $(window).resize(function(){
 	//$(".easyui-layout").layout();
 });*/
 
 /**
  * @description: 生成机构导航,使用此函数需定义全局变量orgloc(必须为此名)和钻取请求函数,
  * 				 并且将该函数加在请求$.post中;
  * @param: element：String类型要生成的导航所在页面的元素(比如<span id="#navipath">中的"#navipath")
  *         orgidt: 从请求返回的json变量机构号;
  *         orgnam: 从请求返回的json变量机构名称;
  *         funcNam: String需响应的钻取函数名称;
  * @author: gzh
  * @date:2015-01-25
  * @modify content:
  * @modifier:
  * @modify date:
  * 
  * 	      使用范例:
  * 			// 机构导航路径存储变量
  *			var orgloc;
  *			
  *			// 请求Chart数据
  *	        function selObj(paramObj){
  *		        var url = "${ctx}/personal-dep-proportion!getPersonalDepPropChartXml.action";
  *
  *		        // 显示遮罩层
  *		        $.messager.progress({text:'数据加载中...'});
  *		        $.post(url,paramObj,function (data){
  *			    	tmpOrgidt = data.orgidt;
  *			    	tmpOrgnam = data.orgnam;
  *			    	tmpCendat = data.cendat;
  *			    	var dataZone = $("#dataZone").css("display");
  *			    	if(dataZone == "none"){
  *			    		if (data.timeScope == 'TIME') {
  *				        	chartRef = FusionCharts("chartId");
  *					    }else if (data.timeScope == 'DAVG') {
  *					    	chartRef = FusionCharts("chartId2");
  *						}
  *			    		//获取Chart引用	
  *					    chartRef.setXMLData(data.chartXml); 
  *					    chartRef.render("chart1"); 
  *			    	}else {
  *			    		window.dataGrid.refresh();
  *			    	}
  *
  * 			    	//机构导航生成
  *			    	putOrglocation("#navipath",data.orgidt,data.orgnam,"drillOrg");
  *
  *			    	// 关闭遮罩层;
  *			    	$.messager.progress('close');
  *			    },"json");
  *			}
  *			
  *			// 机构钻取
  *			function drillOrg(paramsStr){
  *				var arr = paramsStr.split(",");
  *				var _selParams = beforeSel();
  *				var _drillParams = {
  *						orgidt : arr[0],
  *						orgnam : arr[1],
  *						curcde : _selParams.curcde,
  *						cendat : _selParams.cendat,
  *						timeScope : _selParams.timeScope,
  *						orderCol : _selParams.orderCol
  *					};
  *				var url = "${ctx}/personal-dep-proportion!getPersonalDepPropChartXml.action";
  *				$.messager.progress({text:'数据加载中...'});
  *				$.post(url,_drillParams,function(data){
  *					tmpOrgidt = data.orgidt;
  *		     		tmpOrgnam = data.orgnam;
  *		     		tmpCendat = data.cendat;
  *					var dataZone = $("#dataZone").css("display");
  *			    	if(dataZone == "none"){
  *			    		if (data.timeScope == 'TIME') {
  *				        	chartRef = FusionCharts("chartId");
  *					    }else if (data.timeScope == 'DAVG') {
  *					    	chartRef = FusionCharts("chartId2");
  *						}
  *			    		//获取Chart引用	
  *					    chartRef.setXMLData(data.chartXml); 
  *					    chartRef.render("chart1"); 
  *			    	}else {
  *			    		window.dataGrid.refresh();
  *			    	}
  *
  *			    	//机构导航生成
  *			    	putOrglocation("#navipath",data.orgidt,data.orgnam,"drillOrg");
  *		     		
  *					$.messager.progress('close');
  *	  			},"json");
  *			}	
  *			
  *			//机构钻取函数drillOrg(paramsStr)中参数paramsStr为字符串即fusionchartsXML中
  *			//link='j-drillOrg-A0006,内蒙古分行'的"A0006,内蒙古分行",其中link的格式必须为此.函数名可不相同;
  * 			
  */
 function putOrglocation(element,orgidt,orgnam,funcNam) {
 	//生成新的机构导航;
 	if (orgloc == undefined){

 		//若第一次进入无导航条则创建个数组用于存储导航
 		orgloc = new Array();
 		var obj = {orgidt:orgidt,orgnam:orgnam};
 		orgloc.push(obj);

 		//生成导航
 		var params = orgidt+","+orgnam;
 		$(element).append("&nbsp;&nbsp;&nbsp;机构导航：" + "<a href='#' onclick='"+funcNam+"(\""+params+"\")'>"+orgnam+"</a>");
 	}else if (orgloc != undefined){
 		
     	//若不是第一次进入已有导航
     	var loc;
     	for (var i = 0; i < orgloc.length; i++){

         	//钻取的是机构导航中已有的机构则记录导航数组的index
 			if (orgloc[i].orgidt == orgidt){
 				loc = i;
 				break;
 			}
 		}

 		//loc不为空则表示并loc所指的机构是导航数组中已有的机构
     	if (loc != undefined){

         	//重设置导航数组已保持最新状态
 			orgloc.splice(loc+1,orgloc.length-loc);

 			//生成机构导航;
 			$(element).html('');
 			for (var i = 0; i < orgloc.length; i++){
 				var params = orgloc[i].orgidt+","+orgloc[i].orgnam;
 				if (i == 0){
 					$(element).append("&nbsp;&nbsp;&nbsp;机构导航：" + "<a href='#' onclick='"+funcNam+"(\""+params+"\")'>"+orgloc[i].orgnam+"</a>");
 				}else {
 					$(element).append(">><a href='#' onclick='"+funcNam+"(\""+params+"\")'>"+orgloc[i].orgnam+"</a>");
 				}
 			}
 		}else {
 			//否则直接在已有机构导航追加机构;
 			var obj = {orgidt:orgidt,orgnam:orgnam};
 			orgloc.push(obj);
 			var params = orgidt+","+orgnam;
 			$(element).append(">><a href='#' onclick='"+funcNam+"(\""+params+"\")'>"+orgnam+"</a>");
 		}
     }
 }
 
 
 /**
  * @description: 从后台获取展现给页面(格式化日期YYYYMMDD为YYYY-MM-DD、YY/DD/YYYY)
  * @param: cendat：日期参数
  * @author:
  * @date:2014-12-25
  * @modify content:
  * @modifier:
  * @modify date:
  */
 function transCendat(cendat){
 	var i18n=getCookie("com.mingyoutech.cookie.i18n");
 	if(cendat!=null&&cendat!=""){
 		if(i18n==null || i18n=="zh"){
     		return cendat.substring(0,4) + "-" +cendat.substring(4,6)+"-" +
     		cendat.substring(6,8);
     	}else{
     		return cendat.substring(4,6) + "/" +cendat.substring(6,8) + "/" 
     		+ cendat.substring(0,4);
     	}
 	}
 }

 /**
  * @description: 前台传日期给后台时格式化日期(YYYY-MM-DD或MM/DD/YYYY转为YYYYMMDD)
  * @param: cendat：日期参数
  * @author:
  * @date:2014-12-25
  * @modify content:
  * @modifier:
  * @modify date:
  */
 function getCendat(cendat){
 	var i18n=getCookie("com.mingyoutech.cookie.i18n");
 	var t = [];
 	var d,m,y;// 日，月，年
 	if(cendat!=null&&cendat!=""){
 		if(i18n==null || i18n=="zh"){
     		return cendat.replace(/-/g,"");
     	}else{
     		t = cendat.split("/");
     		d = t[1];
     		m = t[0];
     		y = t[2];
     		if(parseInt(m)<10){
     			m = "0" + m;
     		}
     		if(parseInt(d)<10){
     			d = "0" + d;
     		}
     		return y+m+d;
     	}
 	}
 }
 
 /**
  * @description: 去除多余空格
  * @author: gaozhenhan
  * @date:2014-12-25
  * @modify content:
  * @modifier:
  * @modify date:
  */
function trim(str){
	return str.replace(/(^\s*)|(\s*$)/g, "");  
}



$(document).ready(function(){
    $.ajaxSetup({ 
	    error: function(XMLHttpRequest, textStatus, errorThrown){
				if(XMLHttpRequest.status==403){
					alert('error');
					return false;
				}
		},  
        complete:function(XMLHttpRequest,textStatus){   
       	    var sessionstatus=XMLHttpRequest.getResponseHeader("sessionstatus");
            if(sessionstatus=='async_session_timeout'){  
                window.location.href = 'mybi/common/sessionerror.jsp';  
       	    }else if(sessionstatus=='async_noAuth'){
       	    	window.location.href = 'mybi/common/573.jsp';  
       	    }   
        }   
    }); 
    
});