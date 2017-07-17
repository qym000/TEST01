package com.mingyoutech.mybi.demo.coding.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingInsertService;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingProcedureService;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingSqlldrService;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingTemplateService;
import com.mingyoutech.mybi.pim.common.action.SysBaseAction;

/**
 * @description:MYUI控件Demo Action层
 * @author:gzh
 * @date:2015-12-30
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
		@Result(name="manage", location="demo/coding/demo_codingtemplate-manage.jsp"),
		@Result(name="DEMO_01", location="demo/coding/demo_codingtemplate-sqlldr.jsp"),
		@Result(name="DEMO_02", location="demo/coding/demo_codingtemplate-procedure.jsp"),
		@Result(name="DEMO_03", location="demo/coding/demo_codingtemplate-insert.jsp")
	}
)
public class Demo_codingTemplateAction extends SysBaseAction{

	private static final long serialVersionUID = -2877589155629636391L;

	private static HashMap<String,Object> demoMap;
	
	private Demo_jdbc demo_jdbc;
	
	@Autowired
	private Demo_codingTemplateService demo_codingTemplateService;
	
	@Autowired
	private Demo_codingSqlldrService demo_codingSqlldrService;
	
	@Autowired
	private Demo_codingProcedureService demo_codingProcedureService;
	
	@Autowired
	private Demo_codingInsertService demo_codingInsertService;
	
	
	
	private String id;
	
	/**
	 * 存入session的sqlldr模板高级设置的名称
	 */
	public static final String DEMO_01 = "Demo_sqlldrObj";
	
	/**
	 * 存入session的procedure模板高级设置的名称
	 */
	public static final String DEMO_02 = "Demo_procedureObj";
	
	/**
	 * 存入session的insert模板高级设置的名称
	 */
	public static final String DEMO_03 = "Demo_insertObj";
	
	static {
		demoMap = new LinkedHashMap<String,Object>();
		demoMap.put("DEMO_01", "sqlldr导入模板");
		demoMap.put("DEMO_02", "存储过程模板");
		demoMap.put("DEMO_03", "单表加工模板");
	}
	
	/**
	 * 获取Demo选择树
	 * @return NONE
	 */
	public String getDemoTree() {
		List<Map<String,Object>> demoTreeList = new ArrayList<Map<String,Object>>();
		Map<String,Object> map = null;
		for (Map.Entry<String, Object> entry : demoMap.entrySet()) {
			map = new HashMap<String,Object>();
			map.put("id", entry.getKey());
			map.put("name", entry.getValue());
			map.put("pId", "-1");
			demoTreeList.add(map);
		}
		Struts2Utils.renderText(JSONArray.fromObject(demoTreeList).toString());
		return NONE;
	}
	
	/**
	 * 数据库连接的下拉列表
	 * @return
	 */
	public String selConnectSelect() {
	  List<Demo_jdbc> list = demo_codingTemplateService.findJdbcList();
    JSONArray jsonArray = JSONArray.fromObject(list);
      Struts2Utils.renderText(jsonArray.toString());
	  return NONE;
	}
	
	/**
	 * 跳转到相应模板内容
	 * @return NONE
	 */
	public String toContent() {
	  
	  // 初始化高级设置
	  if ("DEMO_01".equals(id)) {
	    if (session.getAttribute(DEMO_01) == null) {
	      session.setAttribute(DEMO_01, demo_codingSqlldrService.getDefaultSqlldrDetail());
	    }
	  } else if ("DEMO_02".equals(id)) {
	    if (session.getAttribute(DEMO_02) == null) {
	      session.setAttribute(DEMO_02, demo_codingProcedureService.getDefaultProcedureDetail());
	    }
	  } else if ("DEMO_03".equals(id)) {
	    if (session.getAttribute(DEMO_03) == null) {
	      session.setAttribute(DEMO_03, demo_codingInsertService.getDefaultInsertDetail());
	    }
	  }
	  
		return id;
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

  public Demo_jdbc getDemo_jdbc() {
    return demo_jdbc;
  }

  public void setDemo_jdbc(Demo_jdbc demo_jdbc) {
    this.demo_jdbc = demo_jdbc;
  }

  public Demo_codingTemplateService getDemo_codingTemplateService() {
    return demo_codingTemplateService;
  }

  public void setDemo_codingTemplateService(
      Demo_codingTemplateService demo_codingTemplateService) {
    this.demo_codingTemplateService = demo_codingTemplateService;
  }

  public Demo_codingSqlldrService getDemo_codingSqlldrService() {
    return demo_codingSqlldrService;
  }

  public void setDemo_codingSqlldrService(
      Demo_codingSqlldrService demo_codingSqlldrService) {
    this.demo_codingSqlldrService = demo_codingSqlldrService;
  }

  public Demo_codingProcedureService getDemo_codingProcedureService() {
    return demo_codingProcedureService;
  }

  public void setDemo_codingProcedureService(
      Demo_codingProcedureService demo_codingProcedureService) {
    this.demo_codingProcedureService = demo_codingProcedureService;
  }

  public Demo_codingInsertService getDemo_codingInsertService() {
    return demo_codingInsertService;
  }

  public void setDemo_codingInsertService(
      Demo_codingInsertService demo_codingInsertService) {
    this.demo_codingInsertService = demo_codingInsertService;
  }
	
}
