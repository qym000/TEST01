/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.appcase.builtin.sso.action;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.Cookie;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.mingyoutech.mybi.pim.common.action.SysBaseAction;
import com.mingyoutech.mybi.pim.org.service.Pim_orgService;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParam;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysAction;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysMenu;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;
import com.mingyoutech.mybi.pim.sysauth.service.Pim_sysMenuService;
import com.mingyoutech.mybi.pim.sysauth.service.Pim_sysUserService;
import com.opensymphony.xwork2.ActionContext;

/**
 * @description:sso登录Action层
 * @author hjz
 * @date:2014-05-09
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("basicStack")
//@ResultPath("/WEB-INF/mybi")
@ResultPath("/")
@Action(
    results = {
       @Result(name = "sso", location = "main-sso.action" , type = "redirectAction"),
       @Result(name = "loginpage", location = "index.jsp"),
       @Result(name = "999", location = "/mybi/common/999.jsp")
    })
public class LoginSsoAction extends SysBaseAction {

  /**  */  
  private static final long serialVersionUID = -1334882891944767478L;
  
  /**  登录编号*/
  private String logid;
  
  /**  登录密码*/
  private String passwd;
  
  /**  系统用户Service对象变量*/ 
  @Autowired
  private Pim_sysUserService pim_sysUserService;
  
  /**  系统菜单Service对象变量*/ 
  @Autowired
  private Pim_sysMenuService pim_sysMenuService;
  
  /**  机构Service对象变量*/ 
  @Autowired
  private Pim_orgService pim_orgService;

  /**
   * @description:登录：编号密码登录
   * @param:
   * @return String
   */
  public String ssoLogin() {
    //System.out.println("============================易慧登陆==============================="); 
    String ticket = request.getParameter("ticket");
    String entranceURL = request.getParameter("returnurl");
    if (entranceURL == null) {
      entranceURL = "";
    }
    
    //application.setAttribute("entranceURL", entranceURL);
    //删除cookie
    setCookie("com.mingyoutech.cookie.entranceURL", null, 0);
    
    Cookie cookie = new Cookie("com.mingyoutech.cookie.entranceURL", getSysParam("URL_SSOLOGIN").getPval());
    cookie.setMaxAge(365 * 24 * 60 * 60);
    cookie.setPath("/");
    response.addCookie(cookie);
    
    //String ehr_id = null;
    if (ticket != null) {
      try {
      //获取从单点登陆平台转向来的用户的登陆编号uid_ssologin  
        String uid_ssologin = "";
        Map<String, String> map = new HashMap<String, String>();
        map.put("logid", uid_ssologin);
        Pim_sysUser tmpUser = pim_sysUserService.findSysUserObj(map);
        if (tmpUser != null) {
          setSessionResOnLoginSucc(tmpUser);
        } else {
          request.setAttribute("info", "用户不存在,请联系管理员!");
          return "999";
        } 
      
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    
    return "sso";
  }
  
  /**
   * @description:设置Cookie
   * @param cookieName String
   * @param cookieValue String
   * @param cookieAge int
   */
  public void setCookie(String cookieName, String cookieValue, int cookieAge) {
    Cookie cookie = new Cookie(cookieName, cookieValue);
    cookie.setMaxAge(cookieAge);
    cookie.setPath("/");
    response.addCookie(cookie);
  }
  
  /**
   * @description:登录成功后设置session存放的资源
   * @param user Pim_sysUser
   * @return:
   */
  public void setSessionResOnLoginSucc(Pim_sysUser user) {
    //当前登陆的用户对象
    session.setAttribute("loginUserObj", user);
    
    Map<String, String> m = new HashMap<String, String>();
    m.put("authUserId", user.getId());
    
    //查询当前用户是否有“超级管理员”这个角色
    int i = pim_sysUserService.isHaveSuperAdminRole(user.getId());
    
    //如果有“超级管理员”这个角色
    if (i > 0) {
      m.put("authRoleId", "0");
      session.setAttribute("authRoleId", "0");
    }
    
    //功能列表存入session
    List<Pim_sysMenu> sysMenuListWithAuth = pim_sysMenuService.findSysMenuListWithAuth(m);
    session.setAttribute("sysMenuListWithAuth", sysMenuListWithAuth);
    
    //动作列表存入session
    List<Pim_sysAction> sysActionListWithAuth = pim_sysMenuService.findSysActionListWithAuth(m);
    session.setAttribute("sysActionListWithAuth", sysActionListWithAuth);
    
    //将所有动作的编号组合起来，如：ACTION_PIM_USER_SAV,ACTION_PIM_USER_UPT，且存入session
    String sysActionStringWithAuth = "";
    if (sysActionListWithAuth != null && sysActionListWithAuth.size() > 0) {
      for (Pim_sysAction act:sysActionListWithAuth) {
        sysActionStringWithAuth += act.getCode() + ",";
      }
    }
    if (sysActionStringWithAuth.endsWith(",")) {
      sysActionStringWithAuth = sysActionStringWithAuth.substring(0, sysActionStringWithAuth.length() - 1);
    }
    session.setAttribute("sysActionStringWithAuth", sysActionStringWithAuth);
    
    //当前用户所归属的机构对象存入session
    if (user.getOrgidt() != null) {
      session.setAttribute("orgcdeObj", pim_orgService.findOrgObjByOrgidt(user.getOrgidt()));
    }
  }
  
  /**
   * @description:退出系统
   * @param:
   * @return String
   */
  @SuppressWarnings("unchecked")
  public String sysauthLogout() {
    Pim_sysUser user = (Pim_sysUser) session.getAttribute("loginUserObj"); 
    if (user != null) { 
      Map<String, String> loginUserMap = (Map<String, String>) application.getAttribute("loginUserMap"); 
      if (loginUserMap != null) {
        loginUserMap.remove(user.getLogid()); 
        application.setAttribute("loginUserMap", loginUserMap); 
      }
    } 
    
    Map<String, Object> sessionMap = ActionContext.getContext().getSession();
    Set<Map.Entry<String, Object>> s = sessionMap.entrySet();
    for (Iterator<Map.Entry<String, Object>> it = s.iterator(); it.hasNext();) {
      Map.Entry<String, Object> entry = (Map.Entry<String, Object>) it.next();
      sessionMap.remove(entry.getKey());
    }
    Cookie[] cookies = request.getCookies();
    if (null != cookies) {
      for (Cookie cookie : cookies) {
        if (cookie.getName() != null && cookie.getName().equals("com.mingyoutech.cookie.logid")) {
          request.setAttribute("logid", cookie.getValue());
        }
        if (cookie.getName() != null && cookie.getName().equals("com.mingyoutech.cookie.passwd")) {
          request.setAttribute("passwd", cookie.getValue());
        }
      }
    }
    request.setAttribute("sysname", (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("SYSNAME")).getPval());
    request.setAttribute("sysname_eg", (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("SYSNAME_EG")).getPval());
    request.setAttribute("sysmarker", (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("SYSMARKER")).getPval());
    return "loginpage";
  }

  /**
   * @description:转向欢迎页
   * @return String
   */
  public String toSysWelcome() {
    return "welcome";
  }

  public String getLogid() {
    return logid;
  }

  public void setLogid(String logid) {
    this.logid = logid;
  }

  public String getPasswd() {
    return passwd;
  }

  public void setPasswd(String passwd) {
    this.passwd = passwd;
  }

  public Pim_sysUserService getPim_sysUserService() {
    return pim_sysUserService;
  }

  public void setPim_sysUserService(Pim_sysUserService pim_sysUserService) {
    this.pim_sysUserService = pim_sysUserService;
  }

  public Pim_sysMenuService getPim_sysMenuService() {
    return pim_sysMenuService;
  }

  public void setPim_sysMenuService(Pim_sysMenuService pim_sysMenuService) {
    this.pim_sysMenuService = pim_sysMenuService;
  }
}
