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
	    parent.clean_onload();
	});
</script>
</head>
<body style="height: 1024px;">
<div class="myui-layout">
	<div class="tabs" style="width:960px;height:672px;" position="right" title="使用模板（以PIM的系统日志查询为例）">
		<div class="tabcontent" title="JSP" selected="true">
			<pre class="brush:html;">
&lt;%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
&lt;%@ page language="java" pageEncoding="UTF-8"%>
&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
&lt;html xmlns="http://www.w3.org/1999/xhtml">
&lt;head>
&lt;title>&lt;/title>
&lt;link href="\${ctx}/mybi/common/themes/\${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.js">&lt;/script> 
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.myui.all.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/pim/scripts/jquery.pim.js">&lt;/script>
&lt;script type="text/javascript">	
			</pre>
			<pre class="brush:js;">
$(function(){
	//动作权限过滤
	actionAuthFilter();
	//导航
	loadLocationLeading("\${authMenuId}","\${session.i18nDefault}");
	
	// 起始日期初始化，最大值为截止日期值
	$("#oprDate1").datebox({
		dateFormat : 'YYYYMMDD',
		defaultDate : '\${startDate}',
		range:{max:{type:'selector',value:'#oprDate2'}}
	});
	// 截止日期初始化，最小值为起始日期值
	$("#oprDate2").datebox({
		dateFormat : 'YYYYMMDD',
		defaultDate : '\${endDate}',
		range:{min:{type:'selector',value:'#oprDate1'}}
	});
});
	
//分页查询
function cx(page){
	var oprDate1=$("#oprDate1").val();
	var oprDate2=$("#oprDate2").val();
	//参数
	var param={
		"obj.oprDate1" : oprDate1 ,	
		"obj.oprDate2" : oprDate2 ,	
		"obj.userId" : $.trim($("#userId").val()) ,
		"obj.menuId" : $.trim($("#menuId").val()) ,
		"obj.ip" : $.trim($("#ip").val()) ,
		page : page // 要显示的页码
	};
		
	//开启蒙板层
	tmp_component_before_load("datagrid");
	//提交
	$.post("pim_sys-log!findSysLogPager.action",param,function(data){ 
    	$(".myui-datagrid-pagination").html(data.datapage);
    	var _data="";
    	if(data.datalist.length>0){
	    	$.each(data.datalist,function(idx,item){
	    		_data+="&lt;tr>";
	    		_data+="&lt;td align=center>"+item.oprDate+"&lt;/td>";
	    		_data+="&lt;td align=center>"+item.userLogid+"&lt;/td>";
	    		_data+="&lt;td>"+item.userNam+"&lt;/td>";
	    		_data+="&lt;td>"+item.oprDetail+"&lt;/td>";
	    		_data+="&lt;td>"+item.ip+"&lt;/td>";
	    		_data+="&lt;/tr>";
			});
    	}else{
    		   //没有符合要求的记录！
    		_data+="&lt;tr>&lt;td 
    			colspan="+$(".myui-datagrid table tr th").length+">没有数据&lt;/td>&lt;/tr>";
    	}
		$("#databody").html(_data);
			
		//关闭蒙板层
		tmp_component_after_load("datagrid");
    },"json"); 	
}
			</pre>
			<pre class="brush:html;">
&lt;/script>
&lt;/head>
&lt;body style="height:660px;">

&lt;div class="myui-template-top-location">&lt;/div>

&lt;div class="myui-template-condition">
   &lt;ul>
      &lt;li class="desc" style="width: 45px;">日期：&lt;/li>
      &lt;li>
	  	 &lt;input id="oprDate1" name="oprDate1" style="width:86px"> 
	  	 - &lt;input id="oprDate2" name="oprDate2" style="width:86px">
	  &lt;/li>
	  &lt;li class="desc" style="width: 45px;">用户：&lt;/li>
      &lt;li>
	  	 &lt;input type="text" id="userId" name="userId" title='支持模糊查询'/>
	  &lt;/li>
   &lt;/ul>
&lt;/div>

&lt;div class="myui-template-condition">
   &lt;ul>
      &lt;li class="desc" style="width: 45px;">功能：&lt;/li>
      &lt;li>
	  	 &lt;input type="text" id="menuId" name="menuId" title='支持模糊查询'/>
	  &lt;/li>
	  &lt;li class="desc" style="width: 45px;">IP：&lt;/li>
      &lt;li>
	  	 &lt;input type="text" id="ip" name="ip" title='支持模糊查询'/>
	  &lt;/li>
	  
   &lt;/ul>
&lt;/div>

&lt;div class="myui-template-operating">
	&lt;div class="baseop">
		&lt;ul>
			&lt;li>&lt;a href="javascript:void(0);" onclick="cx(1)" 
				class="myui-button-query-main" actionCode="ACTION_PIM_LOG_SEL">查询&lt;/a>&lt;/li>
		&lt;/ul>
	&lt;/div>
&lt;/div>

&lt;div  class="myui-datagrid">	
	&lt;table>
		&lt;tr>
			&lt;th>操作时间&lt;/th>
			&lt;th>登陆编号&lt;/th>
			&lt;th>名称&lt;/th>
			&lt;th>操作&lt;/th>
			&lt;th>IP&lt;/th>
		&lt;/tr>
		&lt;tbody id="databody">
		&lt;/tbody>		
	&lt;/table>
&lt;/div>

&lt;div class="myui-datagrid-pagination">&lt;/div>

&lt;/body>

&lt;/html>	
			</pre>
		</div>
		<div class="tabcontent" title="Action">
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.pim.log.action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.framework.util.DateUtil;
import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.pim.common.action.SysBaseAction;
import com.mingyoutech.mybi.pim.log.domain.Pim_sysLog;
import com.mingyoutech.mybi.pim.log.service.Pim_sysLogService;

/**
 * @description:系统日志Action层
 * @author:hjz
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("privilegeStack")
@ResultPath("/WEB-INF/mybi")
@Action(
	    results={
	    		@Result(name="manage", location="pim/log/pim_sys-log-manage.jsp")
	    }
)
public class Pim_sysLogAction extends SysBaseAction {

	private static final long serialVersionUID = -6552486533454831298L;
	
	//系统日志对象
	private Pim_sysLog obj;
	
	// 系统日志Service对象变量
	@Autowired
	private Pim_sysLogService pim_sysLogService;
	
	/**
	 * @description:转向系统日志管理页面
	 * @param:
	 * @return:String 转向地址log/pim_sys-log-manage.jsp
	 */
	public String toManage()  {
        //功能加载时给日期条件赋初始值
		String endDate=DateUtil.getCurrDateStr2();
        String startDate=DateUtil.getNDateAround(-30);
        request.setAttribute("endDate", endDate);
        request.setAttribute("startDate", startDate);
		
		return MANAGE;
	}
	
	/**
	 * @description:分页查询系统日志
	 * @param:
	 * @return:
	 */
	public String findSysLogPager(){
		// 获取pager对象
		Pager&lt;Pim_sysLog> p = pim_sysLogService.findSysLogPager(obj, page, 
				Integer.parseInt(getSysParam("PAGESIZE").getPval()));
        Struts2Utils.renderText(getJson4Pager(p));
        
        return NONE;
	}
	
	public Pim_sysLog getObj() {
		return obj;
	}

	public void setObj(Pim_sysLog obj) {
		this.obj = obj;
	}

}
</pre>		
		</div>
		<div class="tabcontent" title="Domain">
<pre class="brush:java;">
/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.pim.log.domain;

import org.apache.ibatis.type.Alias;

import com.mingyoutech.framework.domain.BaseDomain;

/**
 * @description：系统日志Domain对象
 * @author： hjz
 * @date：2014-05-09
 * 
 * @modify content：
 * @modifier：
 * @modify date:
 */
@Alias("Pim_sysLog")
public class Pim_sysLog extends BaseDomain {

	private static final long serialVersionUID = -2989348244985638505L;
	
	//id
	private String id;
	//菜单id
	private String menuId;
	//菜单中文名称
	private String menuNam;
	//菜英文名称
	private String menuNamEg;
	//动作id
	private String actionId;
	//动作中文名称
	private String actionNam;
	//动作英文名称
	private String actionNamEg;
	//用户id
	private String userId;
	//用户登录编号
	private String userLogid;
	//用户名
	private String userNam;
	//操作日期
	private String oprDate;
	//ip
	private String ip;
	//oprDetail
	private String oprDetail;
	//oprDetailEg
	private String oprDetailEg;
	
	//web查询使用的变量
	private String oprDate1;
	//web查询使用的变量
	private String oprDate2;
	
	public String getOprDetail(){
		return oprDetail;
	}
	
	public String getOprDetailEg(){
		return oprDetailEg;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMenuId() {
		return menuId;
	}
	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}
	public String getMenuNam() {
		return menuNam;
	}
	public void setMenuNam(String menuNam) {
		this.menuNam = menuNam;
	}
	public String getMenuNamEg() {
		return menuNamEg;
	}
	public void setMenuNamEg(String menuNamEg) {
		this.menuNamEg = menuNamEg;
	}
	public String getActionId() {
		return actionId;
	}
	public void setActionId(String actionId) {
		this.actionId = actionId;
	}
	public String getActionNam() {
		return actionNam;
	}
	public void setActionNam(String actionNam) {
		if(null!=actionNam  &&  "LOG_LOGIN".equals(actionNam)){
			this.actionNam = "登录";
		}else if(null!=actionNam  &&  "PWD_UPT".equals(actionNam)){
			this.actionNam = "密码修改";
		}else{
			this.actionNam = actionNam;
		}
		
		if(getMenuNam()!=null && !getMenuNam().equals("")){
			this.oprDetail= "在 “"+getMenuNam()+"” 功能下，进行了 “"+getActionNam()+"” 操作";
		}else{
			this.oprDetail= "进行了 “"+getActionNam()+"” 操作";
		}
	}
	public String getActionNamEg() {
		return actionNamEg;
	}
	public void setActionNamEg(String actionNamEg) {
		if(null!=actionNamEg  &&  "LOG_LOGIN".equals(actionNamEg)){
			this.actionNamEg = "LOGIN";
		}else if(null!=actionNamEg  &&  "PWD_UPT".equals(actionNamEg)){
			this.actionNamEg = "Password Update";
		}else{
			this.actionNamEg = actionNamEg;
		}
		
		if(getMenuNamEg()!=null && !getMenuNamEg().equals("")){
			this.oprDetailEg=  "under \""+getMenuNamEg()+"\" menu，do \""+getActionNamEg()+"\" action";
		}else{
			this.oprDetailEg=  "do \""+getActionNamEg()+"\" action";
		}
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserLogid() {
		return userLogid;
	}
	public void setUserLogid(String userLogid) {
		this.userLogid = userLogid;
	}
	public String getUserNam() {
		return userNam;
	}
	public void setUserNam(String userNam) {
		this.userNam = userNam;
	}
	public String getOprDate() {
		return oprDate;
	}
	public void setOprDate(String oprDate) {
		this.oprDate = oprDate;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getOprDate1() {
		return oprDate1;
	}
	public void setOprDate1(String oprDate1) {
		this.oprDate1 = oprDate1;
	}
	public String getOprDate2() {
		return oprDate2;
	}
	public void setOprDate2(String oprDate2) {
		this.oprDate2 = oprDate2;
	}

}
</pre>
		</div>
		<div class="tabcontent" title="Service">
		<h2>Service</h2>
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.pim.log.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.pim.log.domain.Pim_sysLog;

/**
 * @description:系统日志Service接口层
 * @author:hjz
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Pim_sysLogService {

	/**
	 * @description:分页查询系统日志
	 * @param:obj 系统日志对象
	 * @param:currentpage 当前页
	 * @param:limitpage 每页显示记录数
	 * @return:Pager&lt;SysLog> 系统日志分页对象
	 */
	public Pager&lt;Pim_sysLog> findSysLogPager(Pim_sysLog obj, int currentpage, int limitpage);
	
	/**
	 * @description:查询系统日志列表
	 * @param:obj 系统日志对象
	 * @return:List&lt;SysLog> 系统日志列表
	 */
	public List&lt;Pim_sysLog> findSysLogList(Pim_sysLog obj);
	
	/**
	 * @description:查询系统日志数量
	 * @param:obj 系统日志对象
	 * @return: int 系统日志数量
	 */
	public int findSysLogCount(Pim_sysLog obj);
	
	/**
	 * @description:添加系统日志
	 * @param:obj 系统日志对象
	 * @return:
	 */
	public void saveSysLogObj(Pim_sysLog obj) throws SQLException;
	
	/**
	 * @description:删除某用户的系统日志
	 * @param:map
	 * @return:
	 */
	public void deleteSysLogListByUserList(Map&lt;String,Object> map) throws SQLException;
	
}

</pre>
		<h2>ServiceImpl</h2>
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.pim.log.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.pim.log.domain.Pim_sysLog;
import com.mingyoutech.mybi.pim.log.service.Pim_sysLogService;

/**
 * @description:系统日志Service实现层
 * @author:hjz
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@SuppressWarnings("unchecked")
@Service
public class Pim_sysLogServiceImpl extends BaseServiceImpl&lt;Pim_sysLog> implements Pim_sysLogService{

	/**
	 * @description:分页查询系统日志
	 * @param:obj 系统日志对象
	 * @param:currentpage 当前页
	 * @param:limitpage 每页显示记录数
	 * @return:Pager&lt;SysLog> 系统日志分页对象
	 */
	public Pager&lt;Pim_sysLog> findSysLogPager(Pim_sysLog obj, int currentpage, int limitpage){
		return this.pagedQuery("com.mingyoutech.mybi.pim.log.domain.Pim_sysLog.findSysLogPager", obj, currentpage, limitpage);
	}
	
	/**
	 * @description:查询系统日志列表
	 * @param:obj 系统日志对象
	 * @return:List&lt;SysLog> 系统日志列表
	 */
	public List&lt;Pim_sysLog> findSysLogList(Pim_sysLog obj){
		return this.find("com.mingyoutech.mybi.pim.log.domain.Pim_sysLog.findSysLogList", obj);
	}
	
	/**
	 * @description:查询系统日志数量
	 * @param:obj 系统日志对象
	 * @return: int 系统日志数量
	 */
	public int findSysLogCount(Pim_sysLog obj){
		return (Integer)this.findForObject("com.mingyoutech.mybi.pim.log.domain.Pim_sysLog.findSysLogPagerCount", obj);
	}
	
	/**
	 * @description:添加系统日志
	 * @param:obj 系统日志对象
	 * @return:
	 */
	public void saveSysLogObj(Pim_sysLog obj) throws SQLException{
		this.update("com.mingyoutech.mybi.pim.log.domain.Pim_sysLog.saveSysLogObj", obj);
	}
	
	/**
	 * @description:删除某用户的系统日志
	 * @param:map
	 * @return:
	 */
	public void deleteSysLogListByUserList(Map&lt;String,Object> map) throws SQLException{
		this.update("com.mingyoutech.mybi.pim.log.domain.Pim_sysLog.deleteSysLogListByUserList", map);
	}
}

</pre>
		</div>
		<div class="tabcontent" title="SQL-Map">
<pre class="brush:xml;">
&lt;?xml version="1.0" encoding="UTF-8" ?>
&lt;!--Copyright (c) MINGYOUTECH Co. Ltd.-->
&lt;!DOCTYPE mapper PUBLIC 
    "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

&lt;mapper namespace="com.mingyoutech.mybi.pim.log.domain.Pim_sysLog">
	
	&lt;sql id="whereCondition">
		&lt;trim prefix="WHERE" prefixOverrides="AND |OR ">
		    &lt;if test="userId != null and userId != ''">
				AND (userLogid like '%'||\#{userId}||'%' or userNam like '%'||\#{userId}||'%')
			&lt;/if>
			&lt;if test="menuId != null and menuId != ''">
				AND (upper(menuNam) like '%'||upper(\#{menuId})||'%')
			&lt;/if>
			&lt;if test="actionId != null and actionId != ''">
				AND (upper(actionNam) like '%'||upper(\#{actionId})||'%')
			&lt;/if>
			&lt;if test="ip != null and ip != ''">
				AND (ip like '%'||\#{ip}||'%')
			&lt;/if>
			&lt;if test="oprDate1 != null and oprDate1 != ''">
				AND tmpDate >= \#{oprDate1}
			&lt;/if>
			&lt;if test="oprDate2 != null and oprDate2 != ''">
				AND tmpDate &lt;= \#{oprDate2}
			&lt;/if>
		&lt;/trim>
	&lt;/sql>
	
	&lt;!-- 查询系统日志，分页查询之数据集列表 -->
	&lt;select id="findSysLogPager" resultType="Pim_sysLog" parameterType="Pim_sysLog">
	    SELECT * FROM (
	    	SELECT log.id,log.menu_id as menuId,menu.nam as menuNam,menu.nam_eg as menuNamEg,
		       log.action_id as actionId,
		       decode(log.action_id,'LOG_LOGIN','LOG_LOGIN','PWD_UPT','PWD_UPT',action.nam) as actionNam, 
		       decode(log.action_id,'LOG_LOGIN','LOG_LOGIN','PWD_UPT','PWD_UPT',action.nam_eg) as actionNamEg, 
			   log.user_id as userId,u.logid as userLogid,u.nam as userNam,
			   log.ip , 
			   to_char(log.opr_date,'YYYYMMDD hh24:mi') as oprDate,
			   to_char(log.opr_date,'YYYYMMDD') as tmpDate
		    FROM tp_pim_log log
		    INNER JOIN tp_pim_user u ON log.user_id=u.id
		    LEFT JOIN tp_pim_menu menu ON log.menu_id=menu.id
		    LEFT JOIN tp_pim_action action ON log.action_id=action.id
	    )
		&lt;include refid="whereCondition"/>
		ORDER BY oprDate DESC
	&lt;/select>
	
	&lt;!-- 查询系统日志，分页查询之数据集数量 -->
	&lt;select id="findSysLogPagerCount" resultType="int" parameterType="Pim_sysLog">
	    SELECT count(1) FROM (
	    	SELECT log.id,log.menu_id as menuId,menu.nam as menuNam,menu.nam_eg as menuNamEg,
		       log.action_id as actionId,
		       decode(log.action_id,'LOG_LOGIN','LOG_LOGIN','PWD_UPT','PWD_UPT',action.nam) as actionNam, 
		       decode(log.action_id,'LOG_LOGIN','LOG_LOGIN','PWD_UPT','PWD_UPT',action.nam_eg) as actionNamEg, 
			   log.user_id as userId,u.logid as userLogid,u.nam as userNam,
			   log.ip , 
			   to_char(log.opr_date,'YYYYMMDD hh24:mi') as oprDate,
			   to_char(log.opr_date,'YYYYMMDD') as tmpDate
		    FROM tp_pim_log log
		    INNER JOIN tp_pim_user u ON log.user_id=u.id
		    LEFT JOIN tp_pim_menu menu ON log.menu_id=menu.id
		    LEFT JOIN tp_pim_action action ON log.action_id=action.id
	    )
		&lt;include refid="whereCondition"/>
	&lt;/select>
	
	&lt;!-- 查询系统日志列表 -->
	&lt;select id="findSysLogList" resultType="Pim_sysLog" parameterType="Pim_sysLog">
	    SELECT * FROM (
	    	SELECT log.id,log.menu_id as menuId,menu.nam as menuNam,menu.nam_eg as menuNamEg,
		       log.action_id as actionId,
		       decode(log.action_id,'LOG_LOGIN','LOG_LOGIN','PWD_UPT','PWD_UPT',action.nam) as actionNam, 
		       decode(log.action_id,'LOG_LOGIN','LOG_LOGIN','PWD_UPT','PWD_UPT',action.nam_eg) as actionNamEg, 
			   log.user_id as userId,u.logid as userLogid,u.nam as userNam,
			   log.ip , 
			   to_char(log.opr_date,'YYYYMMDD hh24:mi') as oprDate,
			   to_char(log.opr_date,'YYYYMMDD') as tmpDate
		    FROM tp_pim_log log
		    INNER JOIN tp_pim_user u ON log.user_id=u.id
		    LEFT JOIN tp_pim_menu menu ON log.menu_id=menu.id
		    LEFT JOIN tp_pim_action action ON log.action_id=action.id
	    )
		&lt;include refid="whereCondition"/>
		ORDER BY oprDate DESC
	&lt;/select>
	
	&lt;!-- 添加系统日志 -->
	&lt;insert id="saveSysLogObj" parameterType="Pim_sysLog">
		INSERT INTO tp_pim_log(
			id,menu_id,action_id,user_id,ip
		)VALUES(
			sys_guid(),
			\#{menuI\#{, jdbcType=VARCHAR},
			\#{actionId , jdbcType=VARCHAR},
			\#{userId , jdbcType=VARCHAR},
			\#{ip , jdbcType=VARCHAR}
		) 
	&lt;/insert>
	
	&lt;!-- 删除某用户的系统日志 -->
	&lt;delete id="deleteSysLogListByUserList" parameterType="map">
		DELETE FROM tp_pim_log
	    WHERE user_id IN(
			&lt;foreach collection="userList" item="obj" separator=",">
				\#{obj.id}
			&lt;/foreach>
		)
	&lt;/delete>
	
&lt;/mapper>
</pre>
		</div>
	</div>
</div>

</body>
</html>