/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.appcase.builtin.sso.action;

import java.util.Locale;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.framework.action.BaseAction;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParam;
import com.mingyoutech.mybi.pim.util.CookieUtil;
import com.opensymphony.xwork2.ActionContext;

/**
 * @description:全局入口
 * @author hjz
 * @date:2014-05-09
 */
@Controller
@Scope("prototype")
@Namespace("/")
@ParentPackage("basicStack")
//@ResultPath("/WEB-INF/mybi")
@ResultPath("/")
public class StartSsoAction extends BaseAction {

  /**  */
  private static final long serialVersionUID = 3977808967013123188L;
  
  /**
   * @description:全局入口
   * @return String 
   */
  @SuppressWarnings("unchecked")
  @Action(
      results = {@Result(name = "loginpage", location = "appcase/login-sso.jsp")
      })
  public String execute() {
    
    request.setAttribute("sysname", (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("SYSNAME")).getPval());
    request.setAttribute("sysname_eg", (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("SYSNAME_EG")).getPval());
    request.setAttribute("sysmarker", (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("SYSMARKER")).getPval());
    
    return "loginpage";
  }

  /**
   * @description:语言切换
   * @return String 
   */
  public String changeLang() {
    Map<String, Object> session = ActionContext.getContext().getSession();
    
    String flag = request.getParameter("flag");
    if (flag == null || flag.equals("1")) {   
      CookieUtil.setCookie(response, "com.mingyoutech.cookie.i18n", "zh", 365 * 24 * 60 * 60);
      
      ActionContext.getContext().setLocale(new Locale("zh", "CN"));
      
      session.put("i18nDefault", "zh"); // 默认显示语言
    } else if (flag.equals("2")) {     
      CookieUtil.setCookie(response, "com.mingyoutech.cookie.i18n", "en", 365 * 24 * 60 * 60);
      
      ActionContext.getContext().setLocale(new Locale("en", "US"));
      
      session.put("i18nDefault", "en"); // 默认显示语言
    }      
      
    JSONObject jsonObj = new JSONObject();
    jsonObj.put("message", "succ");
    Struts2Utils.renderText(jsonObj.toString());
    return NONE;
  }
  
}
