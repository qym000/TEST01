function forwardToMenu(fun_url){
	 $(".level3_menu_div").hide();
	 if(fun_url != '' && fun_url != '#' && fun_url.substr(0,1) != '?' && fun_url.indexOf("undefined") == -1){
		 $("#content").attr("src",fun_url);
	 }
}

var level1_menu = "";
var menuobj = null;
var langObj = {"en":"namEg", "zh":"nam"};
function generateLevel1Menu(url, lang){
	$.ajaxSettings.async = false;
	$.getJSON(url, function(data){
		menuobj = data;
		$.each(data, function(index, item){
			var joiner = '?';
			var url = "";
			if(item["url"] !=null && item["url"] != "") {
				if(item["url"].indexOf('?') != -1){
					url = item["url"] + "&authTyp=menu&authMenuId=" + item["id"];
				}else{
					url = item["url"] + "?authTyp=menu&authMenuId=" + item["id"];
				}
			}
			level1_menu += "<ul><li>&nbsp;</li><li onclick=\"switchMenu('" + index + "', '" + lang + "', '" + url + "', this);\">"+item[langObj[lang]]+"</li><li>&nbsp;</li></ul>";
		});
	});   
	$(".level1_menu_div").html(level1_menu);
	//默认选中第一个一级菜单
	$(".level1_menu_div ul").eq(0).find("li").eq(1).trigger("click");
	$.ajaxSettings.async = true;
}

/**
 * 切换一级功能
 */
function switchMenu(index, lang, url, curObj){
	
	//首先移除之前选中菜单的样式
	$(".level1_menu_div ul li").each(function(){
		$(this).removeClass("level1_selected_left");
		$(this).removeClass("level1_selected_center");
		$(this).removeClass("level1_selected_right");
	});
	
	//为选中的一级菜单增加样式
	$(curObj).prev().addClass("level1_selected_left");
	$(curObj).addClass("level1_selected_center");
	$(curObj).next().addClass("level1_selected_right");
	
	//为选中的一级菜单生成二级菜单
	var data = menuobj[index]["subSysMenuList"];
	
	var defaulturl = url;
	if(defaulturl == null || defaulturl == ""){
		defaulturl = getDefaultUrl(data);
	}
	forwardToMenu(defaulturl);//转向指定的url地址
	
	generateLevel2Menu(data, lang);//生成对应的二级菜单
}

/**
 * 生成二级菜单
 */
 var level3_menu_obj = {};
 function generateLevel2Menu(data, lang){
 		level3_menu_obj = {};
 		var level2_menu = "";
 		//首先清空之前的二级菜单
 		$(data).each(function(idx, item){
 			var joiner = '?';
			if(item["url"] !=null && item["url"].indexOf('?') != -1) {
				joiner = '&';
			}
 			var url = item["url"] + joiner +"authTyp=menu&authMenuId=" + item["id"];
 			
 			var level3_menu_data = item["subSysMenuList"];
 			if(level3_menu_data.length > 0){//有三级菜单的话，显示下拉箭头图标
 				level2_menu += "<ul><li onclick=\"generateLevel3Menu('" + item["id"] + "', '" + lang + "', '" + url + "', this);\">"+item[langObj[lang]]+"<span class=\"arrow-ico\">&nbsp;</span></li></ul><div class=\"split-line\">&nbsp;</div>";	

 				//将三级菜单存储到三级菜单对象内
 				level3_menu_obj[item["id"]] = level3_menu_data;
 			}else{//无三级菜单的话不显示下拉箭头图标
 				level2_menu += "<ul><li onclick=\"generateLevel3Menu('', '" + lang + "', '" + url + "', this);\">"+item[langObj[lang]]+"</li></ul><div class=\"split-line\">&nbsp;</div>";
 			}
 		});
 		$(".level2_menu_div").html(level2_menu);
 }

/**
 * 生成三级菜单
 */
 function generateLevel3Menu(menuid, lang, url, curObj){
 		//清空之前的三级菜单内容
 		$(".level3_menu_div").html("");
 		
 		$(".level2_menu_div ul li.center-selected").removeClass();//移除二级菜单选中的样式
 		$(".level2_menu_div ul li span.arrow-ico-selected").attr('class','arrow-ico');//移除二级菜单选中的样式
 		$(".splitline-selected").removeClass().addClass("split-line");//移除选中时的分割线样式
 		
 		$(curObj).addClass("center-selected");//给当前选中二级菜单加选中样式
 		$(curObj).children('span').addClass("arrow-ico-selected");//给当前选中二级菜单加选中样式
 		$(curObj).parent().next().removeClass().addClass("splitline-selected");//给右边的分割线加样式
 		$(curObj).parent().prev().removeClass().addClass("splitline-selected");
 		
 		if(menuid == null || menuid == ""){//没有三级菜单，直接跳转到页面
 			forwardToMenu(url);
 		}else{
 			var level3_menu = "<ul><li class=\"placeholder-li-top\">&nbsp;</li>";
 			
 			var data = level3_menu_obj[menuid];
 			$(data).each(function(idx, item){
	 				var joiner = '?';
					if(item["url"] !=null && item["url"].indexOf('?') != -1) {
						joiner = '&';
					}
		 			var url = item["url"] + joiner +"authTyp=menu&authMenuId=" + item["id"];
 				
 					level3_menu += "<li onclick=\"forwardToMenu('" + url + "');\">" + item[langObj[lang]] + "</li>";
 			});
 			level3_menu += "<li class=\"placeholder-li-bottom\">&nbsp;</li><li class=\"last-radius-bg\">&nbsp;</li></ul>";
 			$(".level3_menu_div").html(level3_menu);
 			//调整三级菜单显示位置
 			var leftPos = $(curObj).position().left;
			if(leftPos >= 828){//如果二级菜单在最右边距左边宽度超过828后，那么控制不能错位
				leftPos = 818;
			}
 			$(".level3_menu_div").css({left:leftPos});
 			//显示三级菜单
 			$(".level3_menu_div").stop(true,true).slideDown(50);
 		}
 		
 		//绑定鼠标移入移出事件
 		$(".level3_menu_div ul li:not(.placeholder-li-top, .placeholder-li-bottom, .last-radius-bg)").mouseenter(function(){
			$(this).addClass("selected");
		}).mouseleave(function(){
			$(this).removeClass("selected");
		});
		
 		$(".level3_menu_div").mouseleave(function(){
			$(".level3_menu_div").slideUp("300");//隐藏3级菜单
			//$(".level2_menu_div ul li.center-selected").removeClass();//移除二级菜单选中的样式
			//$(".splitline-selected").removeClass().addClass("split-line");//移除选中时的分割线样式
 		});
 		
		$("body").bind("mousedown", onBodyDown);
		$(document.frames['content'].document.body).bind("mousedown", onBodyDown);
 }

 /**
  * 获取默认显示的第一个url
  */
 function getDefaultUrl(data){
	 var url = "";
	 $(data).each(function(idx, item){
		var joiner = '?';
		if(url == "" && $.trim(item["url"]) != null && $.trim(item["url"]) != "") {
			if($.trim(item["url"]).indexOf('?') != -1){
				url = item["url"] + "&authTyp=menu&authMenuId=" + item["id"];
			}else{
				url = item["url"] + "?authTyp=menu&authMenuId=" + item["id"];
			}
		}else{
			var level3_menu_data = item["subSysMenuList"];
			$(level3_menu_data).each(function(idx3, item3){
				var joiner = '?';
				if(url == "" && $.trim(item3["url"]) != null && $.trim(item3["url"]) != "") {
					if($.trim(item3["url"]).indexOf('?') != -1){
						url = item3["url"] + "&authTyp=menu&authMenuId=" + item3["id"];
					}else{
						url = item3["url"] + "?authTyp=menu&authMenuId=" + item3["id"];
					}
					return false;
				}else{
					return true;
				}
			});
		}
	});
	return url;
 }
 
 
/**
 * 文档点击事件
 */
function onBodyDown(event) {
	if (!($(event.target).hasClass("level3_menu_div") || $(event.target).parents(".level3_menu_div").length > 0)) {
		$(".level3_menu_div").hide();//隐藏3级菜单
		//$(".level2_menu_div ul li.center-selected").removeClass();//移除二级菜单选中的样式
		//$(".splitline-selected").removeClass().addClass("split-line");//移除选中时的分割线样式
		$("body").unbind("mousedown", onBodyDown);
	}
}

/**
 * 返回顶部
 */
$(function(){
	// 返回顶部
	if($("meta[name=toTop]").attr("content")=="true"){
		$("<div id='toTop'><img src='mybi/common/themes/default/images/to-top.png'></div>").appendTo('body');
		$("#toTop").css({
			width: '50px',
			height: '50px',
			bottom:'10px',
			right:'15px',
			position:'fixed',
			cursor:'pointer',
			zIndex:'999999'
		});
		
		if($(this).scrollTop()==0){
			$("#toTop").hide();
		}
		
		$(window).scroll(function(event) {
			/* Act on the event */
			if($(this).scrollTop()<100){
				$("#toTop").hide();
			}
			if($(this).scrollTop()>=100){
				$("#toTop").show();
			}
		});	
		
		$("#toTop").click(function(event) {
			/* Act on the event */
			$("html,body").animate({
				scrollTop:"0px"},
				400
				)
		});
	}
});