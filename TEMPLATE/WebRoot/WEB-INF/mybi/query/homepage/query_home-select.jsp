<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/query/themes/${apptheme}/buttons.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<style type="text/css">
.myui-datagrid {padding:0;margin:0;}
.myui-datagrid .list-container td {padding:0;margin:0;border:none;}
.myui-datagrid .list-title th {border:none;color:#666;background-color:#EEE}
.myui-datagrid .list-record td {border:none;border-bottom:1px solid #EFEFEF;height:35px;}
.myui-datagrid .list-record tr:hover {background-color:#F0F4F8}
.myui-datagrid .myui-datagrid-tr-odd {background-color:#FFFFFF}
.myui-datagrid .myui-datagrid-tr-even {background-color:#F0F0F0}
.gridbtn {text-decoration:none;padding:3px 8px;border:1px solid #FFF;border-radius:5px;-webkit-border-radius: 5px;-moz-border-radius: 5px;}
.gridbtn:hover {border:1px solid #FFF;background-color:#FFF;}
.link-style {text-decoration:none;cursor:pointer;}
.link-style:hover {color:#AE6E6E}
#queryTitle {height:25px;font-size:20px;padding-left:15px;font-family:微软雅黑;color:#555;}
#recordCnt {margin-top:8px;display:inline-block;padding-left:10px;font-size:13px;font-family:微软雅黑;color:#555;}
</style>
<script type="text/javascript">
$(function(){
	$("#queryTitle").text(parent.queryTitle);
	renderOrder(findList);
	findList();
});

function findList() {
	var paramObj = {
		keyword : parent.keyword,
		parentId : parent.parentId,
		sort : $("input[name='sort']").val(),
        order : $("input[name='order']").val()
	};
	add_onload();
	$.post("${ctx}/query_homepage!findQuerySchemeList.action",paramObj,function(data){
		var htm = "";
		if (data.dataList != null && data.dataSize > 0) {
			$.each(data.dataList, function(idx,item){
				if (idx % 2 == 0) {
					htm += "<tr class='myui-datagrid-tr-odd'>";
				}else {
					htm += "<tr class='myui-datagrid-tr-even'>";
				}
				htm += "<td width='100' align='center'><a href='javascript:void(0)' onclick='switchFav(\"" + item.ID +"\", this)' class='gridbtn' style='color:#AE6E6E'>";
				if (item.ISFAV == "1") {
					htm += "<i class='fa fa-star'></i></a></td>";
				} else {
					htm += "<i class='fa fa-star-o'></i></a></td>";
				}
				htm += "<td width='300'><span class='link-style'>"+ item.NAME + "</span></td>";
				htm += "<td width='150' align='center'>" + item.ADDDATE + "</td>";
				htm += "<td width='200' align='center'>" + item.ADDUSERNAM + "</td>";
				htm += "<td width='150' align='center'><a href='javascript:void(0)' onclick='toQuery(\""+item.ID+"\")' class='gridbtn' style='color:#AE6E6E'><i class='fa fa-search-plus fa-fw'></i></a>";
				htm += "<a href='javascript:void(0)' onclick='toEdit(\""+item.ID+"\")' class='gridbtn' style='color:#AE6E6E'><i class='fa fa-edit fa-fw'></i></a></td><tr>";
			});
		}else {
			htm += "<tr><td colspan='6'>没有记录</td></tr>";
		}
		$(".list-record").html(htm);
		$("#recordCnt").html("已找到相关记录" + data.dataSize + "条");
		clean_onload();
	},"json");
}

function switchFav(id, target) {
	paramObj = {
		"obj.restypCode" : "RES_QUERY",	
		"obj.resId" : id
	};
	if ($(target).find("i").hasClass("fa-star")) {
		add_onload();
		$.post("${ctx}/pim_favorite!deleteFavorite.action", paramObj, function(data){
			clean_onload();
			if (data.result == "succ") {
				$(target).find("i").removeClass("fa-star").addClass("fa-star-o");
				if (parent.parentId == "0") {
					findList();
				}
			}else {
				$.messager.alert("提示", "取消收藏失败", "info");
			}
		}, "json");
	}else if ($(target).find("i").hasClass("fa-star-o")){
		add_onload();
		$.post("${ctx}/pim_favorite!addFavorite.action", paramObj, function(data){
			clean_onload();
			if (data.result == "succ") {
				$(target).find("i").removeClass("fa-star-o").addClass("fa-star");
			}else {
				$.messager.alert("提示", "添加收藏失败", "info");
			}
		}, "json");
	}
}

function toQuery(id) {
	var a = document.getElementById("queryLink");
	a.href = "${ctx}/query_homepage!toQuery.action?id="+id;
	a.setAttribute("onclick","");
	a.click("return false");
}

function toEdit(id) {
	var a = document.getElementById("queryLink");
	a.href = "${ctx}/query_homepage!toQueryDesign.action?id=" + id;
	a.setAttribute("onclick","");
	a.click("return false");
}

function toQueryDesign() {
	var a = document.getElementById("queryLink");
	a.href = "${ctx}/query_homepage!toQueryDesign.action";
	a.setAttribute("onclick","");
	a.click("return false");
}

function backToWelcom() {
	window.location.href="${ctx}/query_homepage!toWelcome.action";
}

function renderOrder(func) {
	$("input[name='sort']").remove();
	$("input[name='order']").remove();
	var sort = $('<input type="hidden" name="sort"> ').insertAfter($(".myui-datagrid"));
	var order = $('<input type="hidden" name="order"> ').insertAfter($(".myui-datagrid"));
	$(".myui-datagrid  th[sortable$='true']").each(function(ind) {
		var fieldcolum = $(this).attr("field");	
		$(this).mouseenter(function(e){
			$(this).css("background","#E0ECFF").css("cursor","pointer");
		}).mouseleave(function(e){
			$(this).css("background","#EEE").css("cursor","normal");
		});
		$(this).bind("click", function(e){
			var currentname = $(this).html();
			 if(currentname.indexOf("↓")>=0) 
			{
				$(this).html(currentname.replace("↓","↑"));
				if(sort.val().indexOf(",") == -1)
				{
					order.val("ASC");
				}else
				{
					var ind = myui_tools_getStrCnt(sort.val(),fieldcolum,",")-1;
					order.val(myui_tools_array_getStr4Sign(myui_tools_array_replace4Index(order.val().split(","),"ASC",ind),","));
				}
				
			}else if(currentname.indexOf("↑")>=0)
			{
				$(this).html(currentname.replace("↑","").replace(" ",""));
					if(sort.val().indexOf(",") == -1)
					{
						sort.val("");
						order.val("");
					}else
					{
						var ind = myui_tools_getStrCnt(sort.val(),fieldcolum,",")-1;
						sort.val(sort.val().replace(","+fieldcolum,"").replace(fieldcolum+",",""));
						order.val(myui_tools_array_getStr4Sign(myui_tools_array_remove4Index(order.val().split(","),ind),","));
					}
			}else
			{
				$(this).append(" ↓");
				if(sort.val() == '')
				{
					sort.val(fieldcolum);
					order.val("DESC");
				}else
				{
					sort.val(sort.val() + ","+fieldcolum)
					order.val(order.val() + ",DESC");
				}
				
			}
			if (func && (typeof func == 'function')) {
				func(1);
			}
		})
	});
	
}

</script>
</head>
<body style="height:655px;">
<div class="myui-layout">
  <div class="content" style="width:915px;height:660px;" title="检索">
    <div class="operate">
      <ul>
        <li>
          <button class="button button-square myui-tooltip" content="返回主页" css="width:50px;" style="height:30px;color:#AE6E6E" onclick="backToWelcom()"><i class="fa fa-home"></i></button>
        </li>
      </ul>
    </div>

    <div id="queryTitle">
    </div>
    
    <div class="myui-template-operating" style="width:913px;">
      <div class="baseop">
        <ul><li><span id="recordCnt"></span></li></ul>
      </div>
      <div class="tableop" style="margin-right:15px;">
        <ul>
          <li><a href="javascript:void(0);" onclick="toQueryDesign()" style="color:#666;"><i class="fa fa-file-text-o fa-fw"></i>新建</a></li>
        </ul>
      </div>
    </div>
    
    <div class="myui-datagrid" style="width:913px;border:none;padding:0;margin:0">
      <table class="list-container" style="width:910px;border:none;" cellpadding="0" cellspacing="0" border="1">
        <tr>
          <td>
            <table class="list-title" style="table-layout:fixed;width:910px;">
              <tr>
                <th width="100" sortable="true" field="isFav">收藏</th>
                <th width="300" sortable="true" field="name">名称</th>
                <th width="150" sortable="true" field="adddate">添加日期</th>
                <th width="200" sortable="true" field="addusernam">修改人</th>
                <th width="150">操作</th>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td>
            <div style="overflow-y:auto;overflow-x:hidden; width:910px; height:501px;">
              <table class="list-record" style="table-layout:fixed;width:910px;" cellspacing="0" cellpadding="0" border="0">
              </table>
            </div>
          </td>
        </tr>
      </table>
	</div>

	<div class="myui-datagrid-pagination"></div>
  </div>
</div>
</div>
<a id="queryLink" target="_blank" style="display:none;"></a>
</body>
</html>