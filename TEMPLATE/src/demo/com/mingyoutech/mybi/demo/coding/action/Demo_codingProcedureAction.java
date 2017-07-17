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

import com.mingyoutech.mybi.demo.coding.domain.Demo_procedureDetail;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingProcedureService;
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
		@Result(name="detail", location="demo/coding/demo_codingtemplate-procedure-detail.jsp")
	}
)
public class Demo_codingProcedureAction extends SysBaseAction{

	private static final long serialVersionUID = -2877589155629636391L;

	private Demo_procedureDetail procedureDetail;

	
	@Autowired
	private Demo_codingProcedureService demo_codingprocedureService;
	
	/**
	 * 跳转到sqlldr模板高级设置页面
	 * @return 跳转到页面demo/coding/demo_codingtemplate-sqlldr-detail.jsp
	 */
	public String toProcedureDetailInput() {
	  return "detail";
	}
	
	/**
	 * 保存高级参数
	 * @return
	 */
	public String saveDetail() {
	  
	  JSONObject jsonObj = new JSONObject();

	  if (demo_codingprocedureService.saveProcedureDetail(procedureDetail)) {
	    session.setAttribute(Demo_codingTemplateAction.DEMO_02, procedureDetail);
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
	  
	  procedureDetail = demo_codingprocedureService.getDefaultProcedureDetail();
	  session.setAttribute(Demo_codingTemplateAction.DEMO_02, procedureDetail);
	  
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
	  Demo_procedureDetail detail = (Demo_procedureDetail) session.getAttribute(Demo_codingTemplateAction.DEMO_02);

    jsonObj.put("template", demo_codingprocedureService.getTemplate(detail));
    jsonObj.put("result", "succ");

	  Struts2Utils.renderText(jsonObj.toString());
	  return NONE;
	}

  public Demo_procedureDetail getProcedureDetail() {
    return procedureDetail;
  }

  public void setProcedureDetail(Demo_procedureDetail procedureDetail) {
    this.procedureDetail = procedureDetail;
  }

  public Demo_codingProcedureService getDemo_codingprocedureService() {
    return demo_codingprocedureService;
  }

  public void setDemo_codingprocedureService(
      Demo_codingProcedureService demo_codingprocedureService) {
    this.demo_codingprocedureService = demo_codingprocedureService;
  }





}
