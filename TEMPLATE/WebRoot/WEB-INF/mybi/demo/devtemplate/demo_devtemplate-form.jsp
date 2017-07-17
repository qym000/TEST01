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
	<div class="tabs" style="width:960px;height:672px;" position="right" title="使用模板（以PIM的参数修改为例）">
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
&lt;link href="\${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" 
	rel="stylesheet" type="text/css"/>
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.js">&lt;/script> 
&lt;script type="text/javascript" src="\${ctx}/mybi/common/scripts/jquery.myui.all.js">&lt;/script>
&lt;script type="text/javascript" src="\${ctx}/mybi/pim/scripts/jquery.pim.js">&lt;/script>
&lt;script type="text/javascript" 
	src="\${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js">&lt;/script>
&lt;script type="text/javascript" 
	src="\${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js">&lt;/script>
&lt;script type="text/javascript">
</pre>
<pre class="brush:js;">
$(function(){
	//参数类型combo
	$("#paramtypId").combo({
		mode:'local',
		valueField:'id',
		textField:'nam',
		data : ${request.paramtypList},
		defaultValue : '${request.obj.paramtypId}'
	});
		
	$.formValidator.initConfig({formID:"form_input",
		onError:function(){
			return false;
		},
		onSuccess:function(){
			var param={
					"obj.paramtypId" : $("#paramtypId").combo('getValue') ,	
					"obj.id" : $("#id").val() ,	
					"obj.pkey" : $.trim($("#pkey").val()) ,
					"obj.pval" : $.trim($("#pval").val()) ,
					"obj.pdesc" : $.trim($("#pdesc").val())
			};
				
			add_onload();//开启蒙板层
			$.post("pim_sys-param!updateSysParamObj.action",param,function(data){ 
				if(data.result=="succ"){
					parent.findList(data.callbackCondition);	//回显刚才操作的记录
					$.messager.alert('提示','修改成功','info',clsWin);
				}else if(data.result=="fail"){
					$.messager.alert('提示','修改失败','info');
				}
				clean_onload();//关闭蒙板层
			},"json");
		}
	});
	$("#pval").formValidator({onFocus:""}).inputValidator({min:1,onError:'不能为空'});
	//不能超过80字符
	$("#pdesc").formValidator({onFocus:""}).inputValidator({max:80,onError:'不能超过80个字符'});
});
	
//表单提交
function sbt(){
	$("#form_input").submit();
}
	
//关闭当前窗口
function clsWin(){
    parent.$('#inputWin').window('close');
}
</pre>
<pre class="brush:html;">
&lt;/script>
&lt;/head>
&lt;body>

&lt;div class="myui-form">
	&lt;div class="form">
		&lt;form id="form_input" method="post">
			&lt;input type="hidden" id="id" name="obj.id"  value="\${request.obj.id}"/>
	        &lt;input type="hidden" id="pkey" name="obj.pkey"  value="\${request.obj.pkey}"/>
	        &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">参数类型：&lt;/li>
					&lt;li>
						&lt;input id="paramtypId" style="width:200px"/>
					&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 
	        &lt;s:if test='#session.loginUserObj.id.equals("0")'>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">标识：&lt;/li>
					&lt;li&lt;\${request.obj.pkey}&lt;/li>
					&lt;li>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;/s:if>	
			
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">&lt;b>* &lt;/b>值：&lt;/li>
					&lt;li>&lt;input value="\${request.obj.pval}" id="pval" name="obj.pval" 
						maxlength="80" class="myui-text"/>&lt;/li>
					&lt;li class="tipli">&lt;div id="pvalTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
			 &lt;div class="item">
				&lt;ul>
					&lt;li class="desc">描述：&lt;/li>
					&lt;li>&lt;textarea id="pdesc" name="obj.pdesc" maxlength="80" class="myui-textarea" 
						style="width:200px">\${request.obj.pdesc}&lt;/textarea>&lt;/li>
					&lt;li class="tipli">&lt;div id="pdescTip">&lt;/div>&lt;/li>
				&lt;/ul>
			 &lt;/div>
		 &lt;/form>
	&lt;/div>
	&lt;div class="operate">
		&lt;a class="main_button" href="javascript:void(0);" onclick="sbt()">提交&lt;/a>
		&lt;a class="button" href="javascript:void(0);" onclick="clsWin()" 
			style="margin-right:20px;">取消&lt;/a>
	&lt;/div>
&lt;/div>

&lt;/body>

&lt;/html>
</pre>
		</div>
		<div class="tabcontent" title="Action">
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.pim.para.action;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.pim.common.action.SysBaseAction;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParam;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParamtyp;
import com.mingyoutech.mybi.pim.para.service.Pim_sysParamService;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;

/**
 * @description:系统参数Action控制层
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
    results = { 
                  @Result(name = "manage", location = "pim/para/pim_sys-param-manage.jsp"), 
                  @Result(name = "update", location = "pim/para/pim_sys-param-update.jsp") 
              }
)
public class Pim_sysParamAction extends SysBaseAction {

	private static final long serialVersionUID = -6552486533454831298L;
	//系统参数对象
	private Pim_sysParam obj;
	// id
	private String id;
	// 标识
	private String pkey;

	// 系统参数Service对象变量
	@Autowired
	private Pim_sysParamService pim_sysParamService;

	/**
	 * @description:转向系统参数管理页面
	 * @param:
	 * @return:String 转向地址sysmanage/para/sys-param-manage.jsp
	 */
	public String toManage() {
		//参数类型列表
		List&lt;Pim_sysParamtyp> paramtypList=pim_sysParamService.findSysParamtypList();
		JSONArray jsonArr=JSONArray.fromObject(paramtypList);
        request.setAttribute("paramtypList", jsonArr.toString());
		
		return MANAGE;
	}

	/**
	 * @description:分页查询系统参数
	 * @param:
	 * @return:
	 */
    public String findSysParamPager() {
		Pim_sysUser loginUserObj = (Pim_sysUser)session.getAttribute("loginUserObj");
		obj.setAuthUserId(loginUserObj.getId());
		Pager&lt;Pim_sysParam> p = pim_sysParamService.findSysParamPager(obj, page, 
			Integer.parseInt(getSysParam("PAGESIZE").getPval()));// 获取pager对象
		Struts2Utils.renderText(getJson4Pager(p));
        
		return NONE;
	}

	/**
	 * @description:查询系统参数对象
	 * @param:
	 * @return:
	 */
	public String findSysParamObjByPkey() {
		obj = pim_sysParamService.findSysParamObjByPkey(obj.getPkey());
		JSONObject jsonObj = new JSONObject();
        jsonObj.put("obj", obj);
        Struts2Utils.renderText(jsonObj.toString());
        
		return NONE;
	}

	/**
	 * @description:转向系统参数修改页面
	 * @param:
	 * @return:String 转向地址sysmanage/para/sys-param-update.jsp
	 */
	public String toSysParamObjUpdate() {
        //参数对象
		Pim_sysParam obj = pim_sysParamService.findSysParamObjByPkey(pkey);
		request.setAttribute("obj", obj);
		
		//参数类型列表
	    List&lt;Pim_sysParamtyp> paramtypList=pim_sysParamService.findSysParamtypList();
	    JSONArray jsonArr=JSONArray.fromObject(paramtypList);
        request.setAttribute("paramtypList", jsonArr.toString());
		
		return UPDATE;
	}

	/**
	 * @description:修改系统参数
	 * @param:
	 * @return:
	 */
	public String updateSysParamObj() {
		JSONObject jsonObj = new JSONObject();
		try {
			pim_sysParamService.updateSysParamObj(obj);
			
			// 更新application里的系统参数
			updateSysParamInApplication(obj);
			jsonObj.put(AJAX_RESULT, AJAX_SUCC);
			jsonObj.put("callbackCondition", obj.getPkey());
		} catch (Exception e) {
			e.printStackTrace();
			jsonObj.put(AJAX_RESULT, AJAX_FAIL);
		}

		Struts2Utils.renderText(jsonObj.toString());
		
		return NONE;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPkey() {
		return pkey;
	}

	public void setPkey(String pkey) {
		this.pkey = pkey;
	}

	public Pim_sysParam getObj() {
		return obj;
	}

	public void setObj(Pim_sysParam obj) {
		this.obj = obj;
	}

}
</pre>		
		</div>
		<div class="tabcontent" title="Domain">
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.pim.para.domain;

import org.apache.ibatis.type.Alias;
import com.mingyoutech.framework.domain.BaseDomain;

/**
 * @description：系统参数Domain对象
 * @author： hjz
 * @date：2014-05-09
 * 
 * @modify content：
 * @modifier：
 * @modify date:
 */
@Alias("Pim_sysParam")
public class Pim_sysParam extends BaseDomain {

    private static final long serialVersionUID = 7336359368297341399L;
    
    //类型ID
    private String paramtypId;
    //类型名称
    private String paramtypNam;
    
    // ID
    private String id;
    // 标识
    private String pkey;
    // 值
    private String pval;
    // 描述
    private String pdesc;
    // 是否开发专用(1是0否)
    private String isdevuse;
    
    // 扩展属性：
    private String authUserId;

    /**
     * @description:flag在页面展示的信息
     * @param:
     * @return:String 显示信息
     */
    public String getIsdevuseShow() {
        if (isdevuse == null || isdevuse.trim().equals("")) {
            return "";
        } else if (isdevuse.trim().equals("1")) {
            return "是";
        } else if (isdevuse.trim().equals("0")) {
            return "否";
        } else {
            return "";
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPkey() {
        return pkey;
    }

    public void setPkey(String pkey) {
        this.pkey = pkey;
    }

    public String getPval() {
        return pval;
    }

    public void setPval(String pval) {
        this.pval = pval;
    }

    public String getPdesc() {
        return pdesc;
    }

    public void setPdesc(String pdesc) {
        this.pdesc = pdesc;
    }

    public String getIsdevuse() {
        return isdevuse;
    }

    public void setIsdevuse(String isdevuse) {
        this.isdevuse = isdevuse;
    }

    public String getAuthUserId() {
        return authUserId;
    }

    public void setAuthUserId(String authUserId) {
        this.authUserId = authUserId;
    }

    public String getParamtypId() {
        return paramtypId;
    }

    public void setParamtypId(String paramtypId) {
        this.paramtypId = paramtypId;
    }

    public String getParamtypNam() {
        return paramtypNam;
    }

    public void setParamtypNam(String paramtypNam) {
        this.paramtypNam = paramtypNam;
    }

}
</pre>
		</div>
		<div class="tabcontent" title="Service">
		<h2>Service</h2>
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.pim.para.service;

import java.util.List;

import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParam;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParamtyp;

/**
 * @description:系统参数Service接口层
 * @author:hjz
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Pim_sysParamService {

	/**
	 * @description:分页查询系统参数
	 * @param:obj 参数对象
	 * @param:currentpage 当前页
	 * @param:limitpage 每页显示记录数
	 * @return:Pager&lt;Pim_sysParam> 系统参数分页对象
	 */
	public Pager&lt;Pim_sysParam> findSysParamPager(Pim_sysParam obj, int currentpage,
			int limitpage);

	/**
	 * @description:列表查询系统参数
	 * @param:obj 参数对象
	 * @return:List&lt;Pim_sysParam> 系统参数列表
	 */
	public List&lt;Pim_sysParam> findSysParamList(Pim_sysParam obj);

	/**
	 * @description:根据pkey查询系统参数
	 * @param:pkey 参数对象的pkey
	 * @return:Pim_sysParam 系统参数
	 */
	public Pim_sysParam findSysParamObjByPkey(String pkey);

	/**
	 * @description:修改系统参数
	 * @param:obj 系统参数对象
	 * @return:
	 */
	public void updateSysParamObj(Pim_sysParam obj);
	
	/**
     * @description:列表查询系统参数类型
     * @return:List&lt;Pim_sysParamtyp> 系统参数类型列表
     */
    public List&lt;Pim_sysParamtyp> findSysParamtypList();

}
</pre>
		<h2>ServiceImpl</h2>
<pre class="brush:java;">
/** Copyright (c) MINGYOUTECH Co. Ltd.*/
package com.mingyoutech.mybi.pim.para.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParam;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParamtyp;
import com.mingyoutech.mybi.pim.para.service.Pim_sysParamService;

/**
 * @description:系统参数Service实现层
 * @author:hjz
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@SuppressWarnings("unchecked")
@Service
public class Pim_sysParamServiceImpl extends BaseServiceImpl&lt;Pim_sysParam> implements Pim_sysParamService{
	
	/**
	 * @description:分页查询系统参数
	 * @param:obj 参数对象
	 * @param:currentpage 当前页
	 * @param:limitpage 每页显示记录数
	 * @return:Pager&lt;Pim_sysParam> 系统参数分页对象
	 */
	public Pager&lt;Pim_sysParam> findSysParamPager(Pim_sysParam obj, int currentpage, int limitpage){
		return this.pagedQuery("com.mingyoutech.mybi.pim.para.domain.Pim_sysParam.findSysParamPager", obj, currentpage, limitpage);
	}
	
	/**
	 * @description:列表查询系统参数
	 * @param:obj 参数对象
	 * @return:List&lt;Pim_sysParam> 系统参数列表
	 */
	public List&lt;Pim_sysParam> findSysParamList(Pim_sysParam obj){
		return this.find("com.mingyoutech.mybi.pim.para.domain.Pim_sysParam.findSysParamList", obj);
	}
	
	/**
	 * @description:根据pkey查询系统参数
	 * @param:pkey 参数对象的pkey
	 * @return:Pim_sysParam 系统参数
	 */
	public Pim_sysParam findSysParamObjByPkey(String pkey){
		return  (Pim_sysParam) this.findForObject("com.mingyoutech.mybi.pim.para.domain.Pim_sysParam.findSysParamObjByPkey", pkey);
	}
	
	/**
	 * @description:修改系统参数
	 * @param:obj 参数对象
	 * @return:
	 */
	public void updateSysParamObj(Pim_sysParam obj){
		this.update("com.mingyoutech.mybi.pim.para.domain.Pim_sysParam.updateSysParamObj", obj);
	}
	
	   /**
     * @description:列表查询系统参数类型
     * @param:obj 参数类型对象
     * @return:List&lt;Pim_sysParamtyp> 系统参数类型列表
     */
    public List&lt;Pim_sysParamtyp> findSysParamtypList(){
        return this.find("com.mingyoutech.mybi.pim.para.domain.Pim_sysParam.findSysParamtypList", null);
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

&lt;mapper namespace="com.mingyoutech.mybi.pim.para.domain.Pim_sysParam">
	
	&lt;!-- 查询系统参数，分页查询之数据集列表 -->
	&lt;select id="findSysParamPager" resultType="Pim_sysParam" parameterType="Pim_sysParam">
	    SELECT typ.id paramtypId,typ.nam paramtypNam,p.id,p.pkey,p.pval,p.pdesc,p.isdevuse 
	    FROM tp_pim_param p 
	    LEFT JOIN tp_pim_paramtyp typ
	    ON p.paramtyp_id=typ.id
	    WHERE (
	    		  upper(p.pkey) like upper('%'||\#{pdesc}||'%') 
		          OR upper(p.pval) like upper('%'||\#{pdesc}||'%')
		          OR upper(p.pdesc) like upper('%'||\#{pdesc}||'%') 
	    	  )
		      &lt;if test="paramtypId != null and paramtypId != ''">
				 AND p.paramtyp_id = \#{paramtypId}
			  &lt;/if>	 
		      &lt;if test='authUserId != null and authUserId!="0"'>
		    	 AND p.isdevuse='0'
		      &lt;/if>
	&lt;/select>
	
	&lt;!-- 查询系统参数，分页查询之数据集数量 -->
	&lt;select id="findSysParamPagerCount" resultType="int" parameterType="Pim_sysParam">
	    SELECT count(*)
	    FROM tp_pim_param p 
	    LEFT JOIN tp_pim_paramtyp typ
	    ON p.paramtyp_id=typ.id
	    WHERE (
	    		  upper(p.pkey) like upper('%'||\#{pdesc}||'%') 
		          OR upper(p.pval) like upper('%'||\#{pdesc}||'%')
		          OR upper(p.pdesc) like upper('%'||\#{pdesc}||'%')  
	          )
		      &lt;if test="paramtypId != null and paramtypId != ''">
				 AND p.paramtyp_id = \#{paramtypId}
			  &lt;/if>
		      &lt;if test='authUserId != null and authUserId!="0"'>
		    	 AND p.isdevuse='0'
		      &lt;/if>
	&lt;/select>
	
	&lt;!-- 查询系统参数列表 -->
	&lt;select id="findSysParamList" resultType="Pim_sysParam" parameterType="Pim_sysParam">
	    SELECT typ.id paramtypId,typ.nam paramtypNam,p.id,p.pkey,p.pval,p.pdesc,p.isdevuse 
	    FROM tp_pim_param p 
	    LEFT JOIN tp_pim_paramtyp typ
	    ON p.paramtyp_id=typ.id
	&lt;/select>

    &lt;!-- 查询系统参数，根据pkey -->
    &lt;select id="findSysParamObjByPkey" resultType="Pim_sysParam"  parameterType="string">
    	SELECT typ.id paramtypId,typ.nam paramtypNam,p.id,p.pkey,p.pval,p.pdesc,p.isdevuse 
	    FROM tp_pim_param p 
	    LEFT JOIN tp_pim_paramtyp typ
	    ON p.paramtyp_id=typ.id
    	WHERE  p.pkey = \#{pkey}
    &lt;/select>
    
    &lt;!-- 修改系统参数-->
	&lt;update id="updateSysParamObj" parameterType="Pim_sysParam">
		UPDATE tp_pim_param
		SET
			paramtyp_id=\#{paramtypId},
			pval=\#{pval , jdbcType=VARCHAR},
			pdesc=\#{pdesc , jdbcType=VARCHAR}
		WHERE id=\#{id}	
	&lt;/update>
	
	&lt;!-- 查询系统参数类型列表 -->
	&lt;select id="findSysParamtypList" resultType="Pim_sysParamtyp" parameterType="Pim_sysParamtyp">
	    SELECT id,nam
	    FROM tp_pim_paramtyp
	&lt;/select>
	
&lt;/mapper>
</pre>
		</div>
	</div>
</div>

</body>
</html>