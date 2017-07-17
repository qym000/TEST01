function changeFun(fun_url){
	 if(fun_url != '' && fun_url != '#' && fun_url.substr(0,1) != '?' && fun_url.indexOf("undefined") == -1){
		 $("#content").attr("src",fun_url);
		 hideFlag = true;
		 hideMenu();
	 }	 
	 return false;
 }

var menu1 = "";
var menuobj = null;
var default_url = "";
var langObj = {"en":"namEg", "zh":"nam"};
var i18nmore = {"en":"More+", "zh":"更多+"};
function renderfun(url,lang){
	$.ajaxSettings.async = false;
	$.getJSON(url,function(data){
		menuobj = data;
		menu1 += "<ul class='menu'>"
		$.each(data, function(index, item){
			var joiner = '?';
			if(item["url"]!=null && item["url"].indexOf('?') != -1) {
				joiner = '&';
			}
    		
			if(item["childsize"] == "0"){//没有叶子节点
				menu1 += '<li><a href="#" onclick=changeFun("'+item["url"]+joiner+'authTyp=menu&authMenuId='+item["id"]+'") onmouseover=generateSubMenu("'+index+'","'+lang+'");>'+item[langObj[lang]]+'</a></li>';
			}else{//有叶子节点
				menu1 += '<li><a href="#" onmouseleave="removeSubMenu();" onclick=changeFun("'+item["url"]+joiner+'authTyp=menu&authMenuId='+item["id"]+'") onmouseover=generateSubMenu("'+index+'","'+lang+'"); >'+item[langObj[lang]]+'</a></li>';
			}
		});
		menu1 += "</ul>";
	});   
	$(".nav_main").html(menu1);
	$.ajaxSettings.async = true;
	
}

/**
 * 生成二级子菜单
 */
function generateSubMenu(index, lang){
	//移除之前的菜单
	hideMenu(true);
	hideFlag = false;
	
	var data = menuobj[index]["subSysMenuList"];
	
	//如果没有二级菜单直接return
	if(data.length == 0){
		return;
	}
	var length = 5*144;
	if(data.length <= 5){//判断二级菜单个数是否<=5
		length = 5*144;
	}else{// 
		length = (((data.length % 5 == 0) ? (data.length*144 + (Math.floor(data.length / 5))*260) : ((Math.ceil(data.length / 5))*5*144 + (Math.ceil(data.length / 5))*260)) - 150);
	}
	
	//重新调整鼠标箭头索引位置
	var event = window.event;
	var relleft = $(event.srcElement).parent().position().left;//当前相对位置
	var menuwidth = $(event.srcElement).parent().css("width").replace("px","");
	var absleft = relleft + menuwidth / 2 + 23;
	
	var left_div = "";
	var right_div = "";
	var menu2 = '<i class="boc2013_a_hover" style="position:absolute;left:'+absleft+'px"></i><div class="sub_menu" onmouseenter="unRemoveSubMenu(event);" onmouseleave="removeSubMenu(event);"><div class="sub_area" style="width:'+length+'px">';
	//翻页图标
	if(data.length > 5){
		left_div = '<div class="left_ico" onmouseenter="chgHideFlag(event);" onmouseleave="chgHideFlag2(event);" onclick="moveLeft();"></div>';
		right_div = '<div class="right_ico" onmouseenter="chgHideFlag(event);" onmouseleave="chgHideFlag2(event);" onclick="moveRight();"></div>';
	}
	
	//遍历某个一级菜单下的二级菜单
	$.each(data, function(index, item){
		var joiner = '?';
		if(item["url"]!=null && item["url"].indexOf('?') != -1) {
			joiner = '&';
		}
		
		menu2 += '<ul class="sub_nav"><li class="fun2"><a href="#" onclick=changeFun("'+item["url"]+joiner+'authTyp=menu&authMenuId='+item["id"]+'")>'+item[langObj[lang]]+'</a></li>';
		if(item["childsize"] > 0){
			$.each(item["subSysMenuList"], function(index3, item3){
				var joiner = '?';
				if(item3["url"]!=null && item3["url"].indexOf('?') != -1) {
					joiner = '&';
				}
				
				if(index3 < 3){
					menu2 +=	'<li class="fun3"><a href="#" onclick=changeFun("'+item3["url"]+joiner+'authTyp=menu&authMenuId='+item3["id"]+'")>'+item3[langObj[lang]]+'</a></li>';
					if(index3 == (item["subSysMenuList"].length - 1)){
						menu2 += '</ul>';
					}
				}else if( index3 > 2 && index3 < 6){
					menu2 +=	'<li class="fun3 '+item["id"]+'" style="display:none;"><a href="#" onclick=changeFun("'+item3["url"]+joiner+'authTyp=menu&authMenuId='+item3["id"]+'")>'+item3[langObj[lang]]+'</a></li>';
					if(index3 == (item["subSysMenuList"].length - 1)|| index3 == 5){
						menu2 += '<li class="fun3more '+item["id"]+'fun3more"><a href="#" class="superlink" onclick=showMoreMenu("'+item["id"]+'");>'+i18nmore[lang]+'</a></li>'
						menu2 += '</ul>';
					}
				}else if(index3 > 5 ){
					if((index3 + 1) % 6 == 1 && index3 == (item["subSysMenuList"].length - 1)){
						menu2 += '<ul class="sub_nav '+item["id"]+'sub_nav" style="display:none;"><li class="fun2"><a href="#">&nbsp;</a></li>';
						menu2 += '<li class="fun3"><a href="#" onclick=changeFun("'+item3["url"]+joiner+'authTyp=menu&authMenuId='+item3["id"]+'")>'+item3[langObj[lang]]+'</a></li>';
						menu2 += '</ul>';
					}else if((index3 + 1) % 6 == 1 && index3 != (item["subSysMenuList"].length - 1)){
						menu2 += '<ul class="sub_nav '+item["id"]+'sub_nav" style="display:none;"><li class="fun2"><a href="#">&nbsp;</a></li>';
						menu2 += '<li class="fun3"><a href="#" onclick=changeFun("'+item3["url"]+joiner+'authTyp=menu&authMenuId='+item3["id"]+'")>'+item3[langObj[lang]]+'</a></li>';
					}else if(index3 == (item["subSysMenuList"].length - 1)){
						menu2 += '<li class="fun3"><a href="#" onclick=changeFun("'+item3["url"]+joiner+'authTyp=menu&authMenuId='+item3["id"]+'")>'+item3[langObj[lang]]+'</a></li>';
						menu2 += '</ul>';
					}else{
						menu2 += '<li class="fun3"><a href="#" onclick=changeFun("'+item3["url"]+joiner+'authTyp=menu&authMenuId='+item3["id"]+'")>'+item3[langObj[lang]]+'</a></li>';
						if((index3 + 1) % 6 == 0){
							menu2 += '</ul>';
						}
					}
				}
			});
		}else{
			menu2 += '</ul>';						
		}
		
		if((index + 1)%5 == 0){
			menu2 += '<ul class="sub_sep"><li>&nbsp;</li></ul>';
		}
			
	});
	menu2 += "</div></div>"
		
	var result = left_div + menu2 + right_div;
	$(".nav_main").append(result);
}

/**
 * 鼠标离开时移除二级三级菜单
 */
 function removeSubMenu(e){
	hideFlag = true;
	setTimeout("hideMenu();", 100);
 }

/**
 *鼠标进入二级三级菜单区域时将hideFlag置为false
 */
function unRemoveSubMenu(e){
	hideFlag = false;
}

/**
 * 解决事件冲突，150毫秒后执行
 */
function hideMenu(){
	if(hideFlag){
		$(".boc2013_a_hover").remove();
		$(".sub_menu").remove();
		$(".left_ico").remove();
		$(".right_ico").remove();
		count_tmp = 0;
	}
}

/**
 * 解决事件冲突，通过hideFlag来隐藏菜单
 * 鼠标进入的时候改变样式
 */
var hideFlag = true;
function chgHideFlag(event){
	if($(event.srcElement).attr("class") == "left_ico" || $(event.srcElement).attr("class") == "right_ico"){
		hideFlag = 	false;
	}
	
	var cls = $(event.srcElement).attr("class");
	$(event.srcElement).removeClass().addClass("red_" + cls);
}

/**
 * 解决事件冲突，通过hideFlag来隐藏菜单
 * 鼠标离开的时候恢复样式
 */
function chgHideFlag2(event){
	if($(event.srcElement).attr("class") == "red_left_ico" || $(event.srcElement).attr("class") == "red_right_ico"){
		hideFlag = 	true;
	}
	
	var cls = $(event.srcElement).attr("class").replace("red_","");
	$(event.srcElement).removeClass().addClass(cls);
}
/**
 * 显示隐藏的菜单
 */
var count_tmp = 0;
function showMoreMenu(menuid){
	var count = $("." + menuid + "fun3more").prevAll().length - 1;
	count = (count <= count_tmp ? count_tmp : count);
	if(count == 6){
		$(".sub_menu").css({"height":"220"});
	}else if(count == 5){
		$(".sub_menu").css({"height":"190"});
	}else if(count == 4){
		$(".sub_menu").css({"height":"170"});
	}else{
		$(".sub_menu").css({"height":"220"});
	}
	count_tmp = count;
	
	$("." + menuid + "fun3more").hide();
	$("." + menuid).show();
	$("." + menuid + "sub_nav").show();
	
	//重新调整宽度
	var data = $(".sub_nav:visible");
	
	var length = 5*144;
	if(data.length <= 5){//判断二级菜单个数是否<=5
		length = 5*144;
	}else{
		length = (((data.length % 5 == 0) ? (data.length*144 + (Math.floor(data.length / 5))*260) : ((Math.ceil(data.length / 5))*5*144 + (Math.ceil(data.length / 5))*260)) - 150);
		
		$(".sub_area").css({"width":length});
		data.parent().find(".sub_sep").remove();
		data.each(function(index){
			if((index + 1) % 5 == 0){
				$(this).after('<ul class="sub_sep"><li>&nbsp;</li></ul>');	
			}	
		});
		
		//显示翻页图标
		left_div = '<div class="left_ico" onmouseenter="chgHideFlag(event);" onmouseleave="chgHideFlag2(event);" onclick="moveLeft();"></div>';
		right_div = '<div class="right_ico" onmouseenter="chgHideFlag(event);" onmouseleave="chgHideFlag2(event);" onclick="moveRight();"></div>';
		$(".nav_main").append(left_div).append(right_div);
	}
}

/**
 * 向左移动
 */
function moveLeft(){
	if(!$(".sub_menu").is(":animated")){
		$(".sub_menu").animate({scrollLeft:($(".sub_menu").scrollLeft() - 980)},700,'swing');
	}
}

/**
 * 向右移动
 */
function moveRight(){
	if(!$(".sub_menu").is(":animated")){
		$(".sub_menu").animate({scrollLeft:($(".sub_menu").scrollLeft() + 980)},700,'swing');
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