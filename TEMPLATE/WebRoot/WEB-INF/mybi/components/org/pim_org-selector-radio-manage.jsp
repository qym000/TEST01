<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<title></title>
	<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
	<link href="${ctx}/mybi/pim/themes/${apptheme}/pim_org-selector.css" rel="stylesheet" type="text/css"/>
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
	<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<script type="text/javascript">
		var targetid = '${targetid}', framename = '${framename}', winnam = '${winnam}';
		var tabname = "${tabname}", rootnode = "${rootnode}", withAuth = "${withAuth}";
		$(function(){
			
			//初始化选中的机构
			initSelectedOrg();
			
			$('.orglvl_extend').click(function(){
	            var liTop = $(this).offset().top;
	            var liLeft = $(this).offset().left + $(this).width();
	            $(this).next('.orglvl_extend_opts').show().css({'left':liLeft+'px',top:liTop+'px'});
	            $(this).addClass('focus');
	            $(this).css('border-right','0');
	            $("body").bind("mousedown", onBodyDown);
	        });
			
			getOrgidtList("", "${userorglvl}", "", "", "");
			$("input").eq(0).focus();
		});
		
		function cx(){
			var orgidt = $("#orgidt").val();
			var orglvl = "";
			var orglvlobj = document.getElementsByName("radioitem");
			var length = orglvlobj.length;
			
			for (var i = 0; i < length; i++){
				if(orglvlobj[i].checked == true){
				  	orglvl += orglvlobj[i].value + ",";
				}
			}
			
			if(orglvl == ""){
	    		return;
			}
			
			$(".orglvl-style input:checked").each(function(item){
				this.checked = !this.checked;
			});

			$("#drillLocation").empty();
			getOrgidtList(orgidt, orglvl, "", "", "");
		}
		
	  /**
        * 文档点击事件
        */
       function onBodyDown(event) {
    	   if (!($(event.target).hasClass("orglvl_extend_opts")) && !($(event.target).hasClass("options"))) {
	    	 $('.orglvl_extend').next('.orglvl_extend_opts').hide();
	    	 $('.orglvl_extend').removeClass('focus');
	    	 $('.orglvl_extend').css({"border":"1"});
	         $("body").unbind("mousedown", onBodyDown);
	       }
       }
		
		function fuzzySelOrg(){
			var orgidt = $("#orgidt").val();
			var orglvl = "";
			var orglvlobj = document.getElementsByName("radioitem");
			var length = orglvlobj.length;
			
			for (var i = 0; i < length; i++){
				if(orglvlobj[i].checked == true){
				  	orglvl += orglvlobj[i].value + ",";
				}
			}
			
			$(".orglvl-style input:checked").each(function(item){
				this.checked = !this.checked;
			});

			$("#drillLocation").empty();
			getOrgidtList(orgidt, "", "", "", "");
		}
		
		/**
		 * 清空所选的全部机构
		 */
		function clearSelectedOrgidts(){
			$("input:checked[name*='orglvl']").each(function(item){
				this.checked = !this.checked;
			});
			$(".orglvl-style input:checked").each(function(item){
				this.checked = !this.checked;
			});
			//$("#selected_orgidts_nam").html("");
			//orgnamarr.length = 0;
			orgarr.splice(0, orgarr.length);
		}
		
		/**
		 * 钻取机构
		 */
		function drillDown(uporg){
			var orglvlobj = document.getElementsByName("radioitem");
			var length = orglvlobj.length;
			var orgidt = $("#orgidt").val();
			
			//添加机构导航
			var orgnam = $("input[name*='orglvl'][value="+uporg+"]").parent().text();
			var drillOrgidt = $("input[name*='orglvl'][value="+uporg+"]").val();
			var extcols = "";
			addOrgidtNav(orgnam, drillOrgidt);
			
			var allchildorg = ""; //下辖机构是否选中
			$(".orglvl_extend_opts input:checked").each(function(item){
				if($(this).attr("name") != "allchildorg"){
					extcols += " AND " + $(this).attr("name") + " = 1 "
				} else {
					allchildorg = "1";
				}
			});
			
			getOrgidtList("", "", uporg, extcols, allchildorg);
		}
		
		/**
	  	 * 添加机构导航
	  	 */
	  	function addOrgidtNav(orgnam,orgidt){
	  		if($("#drillLocation").parent().find("span[class=superlink]").length > 0){
	  			$("#drillLocation").append("<span class='superlink' idadd='"+orgidt+"' onclick='delAfterNav(\""+orgnam+"\",\""+orgidt+"\");'>&nbsp;>"+orgnam+"</span>");
	     	}else{
	     		$("#drillLocation").append("<span class='superlink' idadd='"+orgidt+"' onclick='delAfterNav(\""+orgnam+"\",\""+orgidt+"\");'>"+orgnam+"</span>");
	     	}
	  	}
		  	
	  	/**
	  	 * 删除机构导航
	  	 */
	  	 function delAfterNav(orgnam,orgidt){
			$("span[idadd='"+orgidt+"']").nextAll().remove();
			drillDown(orgidt);
	  	 }
		
		
		//获取机构数据列表
		function getOrgidtList(orgidt, orglvl, uporg, extcols, allchildorg){
			$("tbody[id^=orglvl][id$=html]").html("");
			$("tr[id^=orglvl][id$=title]").hide();
			add_onload();
			
			var param = {
					orgidt:orgidt, 
					orglvl:orglvl, 
					withAuth:withAuth, 
					uporg:uporg, 
					tabname:tabname, 
					rootnode:rootnode, 
					extcols:extcols,
					allchildorg:allchildorg
			};
			$.getJSON("pim_org-selector!getOrgidtList.action", param, function(data){
				if(data.orgidtlist.length > 0){
					var length = data.orgidtlist.length;
					var datalist = data.orgidtlist;
					
					//渲染数据
					appendOrgDataToTable(0, length, datalist);
					
					$("tbody[id^=orglvl][id$=html] tr td input:radio").click(function(){
						getSelectedOrgidts(this, true);
					});
					
					//选中数组中存在的机构
					if(orgarr.length > 0){
						for(var i = 0; i < orgarr.length; i++){
							$("tbody[id^=orglvl][id$=html] tr td input:radio[value="+orgarr[i]+"]").attr("checked","true");
						}
					}
				}else{
					clean_onload();
				}
			});
		}
		
		
		/**
		 * 将机构数据渲染到表格
		 */
		function appendOrgDataToTable(val, length, datalist){
			for(var j = val; j < length; j++){
				var item = datalist[j];
				$("#orglvl"+item["ORGLVL"]+"title").show();
				var trobj = $("#orglvl"+item["ORGLVL"]+"html").find("tr");
				var trlen = $("#orglvl"+item["ORGLVL"]+"html").find("tr").length;
				if(trlen == 0){
					$("#orglvl"+item["ORGLVL"]+"html").append("<tr><td width=34%><input type=radio value="+item["ORGIDT"]+" orgnam="+item["ORGNAM"]+" name=orglvlcheckitem >&nbsp;<span class='superlink' onclick=drillDown('"+item["ORGIDT"]+"');>["+ item["ORGIDT"] +"]"+item["ORGNAM"]+"</span></input></td></tr>");
				}else{
					for(var i = 0; i < trlen; i++){
						var tdlen = trobj.eq(i).find("td").length;
						if(tdlen < 3){
							trobj.eq(i).append("<td><input type=radio value="+item["ORGIDT"]+" orgnam="+item["ORGNAM"]+" name=orglvlcheckitem>&nbsp;<span class='superlink' onclick=drillDown('"+item["ORGIDT"]+"');>["+ item["ORGIDT"] +"]"+item["ORGNAM"]+"</span></input></td>");
						}else if(tdlen == 3){
							if(trlen == (i + 1)){//循环到最后一行
								$("#orglvl"+item["ORGLVL"]+"html").append("<tr><td width=34%><input type=radio value="+item["ORGIDT"]+" orgnam="+item["ORGNAM"]+" name=orglvlcheckitem >&nbsp;<span class='superlink' onclick=drillDown('"+item["ORGIDT"]+"');>["+ item["ORGIDT"] +"]"+item["ORGNAM"]+"</span></input></td></tr>");
							}
						}
					}
				}
				
				if(val != 0 && (val % 150 == 0 || val == length - 1)){
					window.setTimeout(function(){
						appendOrgDataToTable(++j, length, datalist);
					}, 3);
			        break;
				}else{
					appendOrgDataToTable(++j, length, datalist);
					break;
				}
			}
			
			if(val == length - 1){
				clean_onload();
			}
	 	}
		
		//获取选中的机构填充到下方已选机构
		var orgarr = [];
		var orgnamarr = [];
		function getSelectedOrgidts(obj, flag){

			//选中
			if($("input:radio[value="+$(obj).val()+"]").is(':checked')) {
				//var orgnam ="["+ $(obj).val() +"]" + $(obj).attr("orgnam");
				var orgidt = $(obj).val();
				//放入数组
				pushOrgInArr(orgidt, flag);
			}else{
				//取消选中
				//var orgnam ="["+ $(obj).val() +"]" + $(obj).attr("orgnam");
				var orgidt = $(obj).val();
				//移出数组
				pullOrgFromArr(orgidt, flag);
			}
		}
		
		/**
		 * 把机构放入数组中
		 */
		 function pushOrgInArr(org, flag){
		 	var selectedorgidts = "";
		 	orgarr.length = 0;
		 	//orgnamarr.length = 0;
		 	
			orgarr.push(org);
			//orgnamarr.push(orgnam);
			
			if(flag){
				//机构去重
				orgarr = orgarr.unique();
				//orgnamarr = orgnamarr.unique();
				//for(var i = 0; i < orgnamarr.length; i++){
				//	selectedorgidts += "<span><img src='"+delpng+"' style='vertical-align:middle;margin-left:8px;cursor:pointer;' code="+orgarr[i]+" orgnam="+orgnamarr[i]+" onclick=delOneSelectedOrg(this);>"+orgnamarr[i]+"</img></span>";
				//}
				//$("#selected_orgidts_nam").html("").html(selectedorgidts);
			}
		 }
		
		/**
		 * 把机构从数组中移除
		 */
		 function pullOrgFromArr(org, orgnam, flag){
			var selectedorgidts = "";
			orgarr.remove(org);
			//orgnamarr.remove(orgnam);
			
			//if(flag){
			//	for(var i = 0; i < orgnamarr.length; i++){
			//		selectedorgidts += "<span><img src='"+delpng+"' style='vertical-align:middle;margin-left:8px;cursor:pointer;' code="+orgarr[i]+" orgnam="+orgnamarr[i]+" onclick=delOneSelectedOrg(this);>"+orgnamarr[i]+"</img></span>";
			//	}
			//	$("#selected_orgidts_nam").html("").html(selectedorgidts);
			//}
		 }
		
		 Array.prototype.indexOf = function(val) {               
			 for (var i = 0; i < this.length; i++) {   
			        if (this[i] == val) return i;   
			 }   
			 return -1;   
		 };   

		 Array.prototype.remove = function(val) {   
		     var index = this.indexOf(val);   
				if (index > -1) {   
					this.splice(index, 1);   
			 	}   
		 };
		
		 Array.prototype.unique = function(){
		 	this.sort();
		 	var ary = [this[0]];
		 	for(var i = 1; i < this.length; i++){
		 		if( this[i] !== ary[ary.length-1]){
		 			ary.push(this[i]);
		 		}
		 	}
		 	return ary;
		 }

   		/**
   		 * 复选框全选
   		 */
   	    function checkAll(str){   
			var a = document.getElementsByName(str);  
			var n = a.length;   
			for (var i = 0; i < n; i++){
				if(a[i].disabled==false){
				  	a[i].checked = window.event.srcElement.checked;
				}
			}
			cx();
		}
	  
	  	/**
	   	 * 关闭当前窗口
	   	 */
      	function clsWin(){
    		parent.$('#'+ winnam).window({open:false});
      	}
	  
	  	/**
	  	 * 提交
	  	 */
	  	function sbt(){
	  		var orglvl = "";
			var orglvlobj = document.getElementsByName("radioitem");
			var length = orglvlobj.length;
			
			for (var i = 0; i < length; i++){
				if(orglvlobj[i].checked == true){
				  	orglvl += orglvlobj[i].value + ",";
				}
			}
				  		
		  	var orgidts = "";
		  	if(orgarr.length == 0 && length > 0){
		  	}else{
		  		orgidts = orgarr.join(",");
		  	}
		  	
		  	//保存临时数据
		  	//var selectedorgnam = orgnamarr.join(",");
		  	$.ajaxSettings.async = false;
		  	$.post("pim_org-selector!saveTmpData.action",{selectedorg:orgidts},function(data){});
		  	clsWin();
	  	}
	  	
	  	/**
	  	 * 初始化选中的机构
	  	 */
	  	function initSelectedOrg(){
	  		
	  		//初始化选中的机构
	  		var orgidts = '<%=session.getAttribute("selectedorg")%>';
	  		if(orgidts != null && orgidts != "null" && orgidts != "" && orgidts.indexOf("=") == -1){
				//var selectedorgnam = '<%=session.getAttribute("selectedorgnam")%>';
				//if(selectedorgnam != null && selectedorgnam != "" && selectedorgnam != "null"){orgnamarr = selectedorgnam.split(",");}
				//var selectedorgidts = "";
				orgarr = orgidts.split(",");
		  		//for(var i = 0; i < orgnamarr.length; i++){
				//	selectedorgidts += "<span><img src='"+delpng+"' style='vertical-align:middle;margin-left:8px;cursor:pointer;' code="+orgarr[i]+" orgnam="+orgnamarr[i]+" onclick=delOneSelectedOrg(this);>"+orgnamarr[i]+"</img></span>";
				//}
				//$("#selected_orgidts_nam").html("").html(selectedorgidts);
		  	}
	  	}
	</script>
	</head>
	<body>
		<table class="orglvl_table">
			<tr>
				<td colspan="2" style="line-height:20px;width:100%;"><s:text name="org_selector_orglvl"/>：&nbsp;&nbsp;
					<s:iterator value="%{#request.orglvllist}" id="r">
						<s:if test="#r.ORGLVL == #request.userorglvl">
							<input style="vertical-align:middle;" type="radio" id="${ORGLVL}" value="${ORGLVL}" onclick="cx();" name="radioitem" checked="checked" />
							<label style="cursor:pointer;vertical-align:middle;" for="${ORGLVL}">${ORGLVLNAM}</label>&nbsp;
						</s:if>
						<s:else>
							<input style="vertical-align:middle;" type="radio" id="${ORGLVL}" value="${ORGLVL}" onclick="cx();" name="radioitem" />
							<label style="cursor:pointer;vertical-align:middle;" for="${ORGLVL}">${ORGLVLNAM}</label>&nbsp;
						</s:else>
					</s:iterator>
					
					<s:if test="#request.extlist != null && #request.extlist.size > 0">
						<span class="orglvl_extend" onselectstart="return false;"><s:text name="org_selector_more"/></span>
						<div class="orglvl_extend_opts">
							<input type="checkbox" value="1" name="allchildorg" class="options">&nbsp;下辖机构</input><br/>
							<s:iterator value="%{#request.extlist}" id="r">
								<input type="checkbox" value="1" name="${r.colcode}" class="options">&nbsp;${r.colnam}</input><br/>
							</s:iterator>
						</div>
					</s:if>	
					
					<span style="width:150px;margin-left:50px;" class="myui-search-outer">
						<input type="text" id="orgidt" class="myui-text" style="width:120px;" title="<s:text name="common_msg_fuzzy_query"/>">
						<a class="myui-search-ico" href="javascript:void(0);" onclick="fuzzySelOrg();"></a>
					</span>				
				</td>
				<td>
					<span class="container">
						<a href="javascript:void(0);" onclick="sbt();" class="myui-button-query-main" style="display:inline-block; position: relative;left:4px;top:1px;color:white;"><s:text name="common_action_submit"/></a>
						<a href="javascript:void(0);" onclick="clearSelectedOrgidts();" class="myui-button-query" style="display:inline-block; position: relative;left:4px;top:1px;"><s:text name="org_selector_clear"/></a>
					</span>
				</td>
			</tr>
			<tr><td colspan="5" style="border-top: 2px #A71E32 solid;"></td></tr>
			<tr><td colspan="5"><s:text name="org_selector_path"/>：<span class='superlink' onclick="cx();"><s:text name="org_selector_home"/></span><span id="drillLocation"></span></td></tr>
		</table>
		
		<div class="orgidt_show_area">
			<table width="100%" cellspacing="12">
				<s:iterator value="%{#request.orglvllist}" id="item">
					<tr id="orglvl${ORGLVL}title">
						<td colspan="3" class="orglvl-style">&nbsp;${ORGLVLNAM}</td>
					</tr>
					<tbody id="orglvl${ORGLVL}html"></tbody>
				</s:iterator>
			</table>
		</div>
		<!-- 
		<div class="selected_orgidts_operate">
			<div style="float: left;"><s:text name="org_selector_checked"/>：</div>
			<div id="selected_orgidts_nam" class="selected_orgidts_nam"></div>
		</div>
		<div id="selected_org_div" class="selected_org_div">
			<table>
			</table>
		</div>
		 -->
	</body>
	<script type="text/javascript">
	
		/**
		 * 删除单个选中的机构
		 */
		 function delOneSelectedOrg(obj){
			var selectedorgidts = "";
			var orgidt = $(obj).attr("code");
			var orgnam = $(obj).attr("orgnam");
			
			orgarr.remove(orgidt);
			orgnamarr.remove(orgnam);
			for(var i = 0; i < orgnamarr.length; i++){
				selectedorgidts += "<span><img src='"+delpng+"' style='vertical-align:middle;margin-left:8px;cursor:pointer;' code="+orgarr[i]+" orgnam="+orgnamarr[i]+" onclick=delOneSelectedOrg(this);>"+orgnamarr[i]+"</img></span>";
			}
			$("#selected_orgidts_nam").html("").html(selectedorgidts);
			$("input:checked[name*='orglvl'][value="+$(obj).attr("code")+"]").attr("checked",false);
		 }
		
		 var delpng = "${ctx}/mybi/common/themes/${apptheme}/images/delete.png";
	</script>
</html>