package com.mingyoutech.mybi.demo.coding.action;

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

import com.mingyoutech.mybi.demo.coding.domain.Demo_insertDetail;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingInsertService;
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
		@Result(name="detail", location="demo/coding/demo_codingtemplate-insert-detail.jsp")
	}
)
public class Demo_codingInsertAction extends SysBaseAction{

	private static final long serialVersionUID = -2877589155629636391L;

	private Demo_insertDetail insertDetail;
	
	private String connectId;
	private String tableName;
	
	@Autowired
	private Demo_codingInsertService demo_codigInsertService;
	
	/**
	 * 跳转到sqlldr模板高级设置页面
	 * @return 跳转到页面demo/coding/demo_codingtemplate-sqlldr-detail.jsp
	 */
	public String toInsertDetailInput() {
	  return "detail";
	}
	
	/**
	 * 保存高级参数
	 * @return
	 */
	public String saveDetail() {
	  
	  JSONObject jsonObj = new JSONObject();

	  if (demo_codigInsertService.saveInsertDetail(insertDetail)) {
	    session.setAttribute(Demo_codingTemplateAction.DEMO_03, insertDetail);
	    jsonObj.put("result", "succ");
	  } else {
	    jsonObj.put("result", "fail");
	  }
	  Struts2Utils.renderText(jsonObj.toString());
	  
	  return NONE;
	}
	
	/**
	 * 将参数恢复为默认值
	 * @return
	 */
	public String toDefault() {
	  JSONObject jsonObj = new JSONObject();
	  
	  insertDetail = demo_codigInsertService.getDefaultInsertDetail();
	  session.setAttribute(Demo_codingTemplateAction.DEMO_03, insertDetail);
	  
	  jsonObj.put("result", "succ");
	  Struts2Utils.renderText(jsonObj.toString());
	  
	  return NONE;
	}
	
	/**
	 * 获取代码模板
	 * @return
	 */
	public String getTemplate() {
	  JSONObject jsonObj = new JSONObject();
	  Demo_insertDetail detail = (Demo_insertDetail) session.getAttribute(Demo_codingTemplateAction.DEMO_03);
          
    jsonObj.put("template", demo_codigInsertService.getTemplate(connectId, tableName, detail));
    jsonObj.put("result", "succ");

	  Struts2Utils.renderText(jsonObj.toString());
	  return NONE;
	}

  public Demo_insertDetail getInsertDetail() {
    return insertDetail;
  }

  public void setInsertDetail(Demo_insertDetail insertDetail) {
    this.insertDetail = insertDetail;
  }

  public Demo_codingInsertService getDemo_codigInsertService() {
    return demo_codigInsertService;
  }

  public void setDemo_codigInsertService(
      Demo_codingInsertService demo_codigInsertService) {
    this.demo_codigInsertService = demo_codigInsertService;
  }

  public String getConnectId() {
    return connectId;
  }

  public void setConnectId(String connectId) {
    this.connectId = connectId;
  }

  public String getTableName() {
    return tableName;
  }

  public void setTableName(String tableName) {
    this.tableName = tableName;
  }

}
