<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title></title>
<link href="${ctx}/mybi/common/scripts/syntaxHighlighter/styles/shCoreEclipse.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"	rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/demo/themes/${apptheme}/demo-myui.css"	rel="stylesheet" type="text/css" />
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shCore.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJScript.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushXml.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushJava.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript">
	$(function() {
	    SyntaxHighlighter.all();
	});
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="content" style="width:960px;height:672px;" title="datagrid数据列表排序使用文档">
	</br>
<pre class="pre-text">
	    数据表格排序指的是在数据列表查询页面中，将按字段排序添加到datagrid中，要实现这一功能需要在JSP和JAVA中添加相应接口代码，我们以缺口数据
    平台myui-gdp的方案管理页面查询为例进行说明
</pre>
	<h3>JSP部分</h3>
<pre class="pre-text">
	    首先在页面的HTML的myui-datagrid的表头定义中需要指定两个属性field和sortable，field属性指的是需要排序的字段名称，该名称对应domain对象
    的java属性，sortable指定是开启排序，若要排序需要将属性值设置为true,若不需要排序可以不指定这两个属性。
</pre>
<pre class="brush:html;">
&lt;div class="myui-datagrid">
	&lt;table>
		&lt;tr>
			&lt;th>&lt;input type="checkbox" name="all" onclick="checkAll('checkboxitem')" />&lt;/th>
			&lt;th field="schemeName" sortable="true">方案名称 &lt;/th>
			&lt;th field="schemeType" sortable="true">方案类型&lt;/th>
			&lt;th field="classId" sortable="true">所属分类&lt;/th>
			&lt;th field="dateType" sortable="true">数据日期类型&lt;/th>
			&lt;th field="isValid" sortable="true">状态&lt;/th>
			&lt;th>操作&lt;/th>
		&lt;/tr>
		&lt;tbody id="databody">
		&lt;/tbody>		
	&lt;/table>
&lt;/div>
</pre>
<pre class="pre-text">
	    在指定排序字段后，需要在列表查询主方法中将sort和order两个参数传到Action中，在SysBaseAction已封装了这两个参数，无需开发人员在Action中
    定义。
</pre>
<pre class="brush:js;">
	// 请求查询
	function cx(page) {
		// 查询参数;
		var paramObj = {
			"schemeObj.schemeName" : $.trim($("#schemeName").val()),
			"schemeObj.schemeType" : $("#schemeType").combo("getValue"),
			"schemeObj.classId" : $("#classId").combo("getValue"),
			page : page,
			sort : $("input[name='sort']").val(),
			order : $("input[name='order']").val()
		};
		// 开启蒙板层
		tmp_component_before_load("datagrid");
		$.post("${ctx}/gdp_scheme!findSchemePager.action",paramObj,function(data){
			$(".myui-datagrid-pagination").html(data.datapage);
			var htm = "";
			var tmp = "";
			if (data.datalist != null && data.datalist.length > 0) {
				$.each(data.datalist, function(idx,item){
					// 方案类型(0:普通变长,1:分组变长 2:定长)
					if (item.schemeType == 0) {
						tmp = "普通变长";
					}else if (item.schemeType == 1) {
						tmp = "分组变长";
					}else {
						tmp = "定长";
					}
					htm += "&lt;tr>";
	    			htm += "&lt;td>&lt;input type='checkbox' name='checkboxitem' value='"
	    				+item.schemeId+"'>&lt;/td>";
	    			htm += "&lt;td>"+item.schemeName+"&lt;/td>";
	    			htm += "&lt;td align='center'>"+ tmp +"&lt;/td>";
	    			htm += "&lt;td>"+item.className+"&lt;/td>";
	    			// 数据日期类型:按月/按日
	    			htm += "&lt;td align='center'>" + (item.dateType=="1"?"按月":"按日") + "&lt;/td>";
	    			// 有效/无效
	    			htm += "&lt;td align='center'>" + (item.isValid=="1"?"有效":"无效") + "&lt;/td>";
	    			// 配置操作
	    			htm += "&lt;td align='center'>&lt;a href='javascript:void(0)' class='link-style' 
	    				actionCode='ACTION_GDP_SCHEME_CONF' 
	    				onclick='configScheme(\""+item.schemeId+"\")'>方案配置&lt;/a>&lt;/td>"
	    			htm += "&lt;/tr>";
				});
			}else {
				// 没有数据
				htm += "&lt;tr>&lt;td colspan='6'>没有数据&lt;/td>&lt;/tr>"
			}
			$("#databody").html(htm);
			actionAuthFilter();
			//关闭蒙板层
			tmp_component_after_load("datagrid");
		},"json");
	}
</pre>
<pre class="pre-text">
	   在整个页面初始化主方法中需要添加渲染排序方法,传入的参数为你的主查询方法。
</pre>
<pre class="brush:js;">
// 渲染排序
$(function(){
	myui_datagrid_renderOrder(cx);
});
</pre>
		<h3>JAVA部分</h3>
<pre class="pre-text">
	   最后在Action中使用Service查询出数据前，需要对排序字段处理一下。
</pre>
<pre class="brush:java;">
/**
 * @description:分页查询方案列表
 * @return:NONE
 */
public String findSchemePager() {
	// 表头排序
	schemeObj.setOrderBy("".equals(sort)?null:sort, "".equals(order)?null:order);
	// 权限控制
	schemeObj.setAuth_roleid((String)session.getAttribute("authRoleId"));
	schemeObj.setAuth_userid(((Pim_sysUser)session.getAttribute("loginUserObj")).getId());
    Pager&lt;Gdp_scheme> p = gdp_schemeService.findSchemePager(schemeObj, page, 
    	Integer.parseInt(getSysParam("PAGESIZE").getPval()));
    Struts2Utils.renderText(this.getJson4Pager(p));
    return NONE;
}
</pre>
	</div>
</div>

</body>
</html>