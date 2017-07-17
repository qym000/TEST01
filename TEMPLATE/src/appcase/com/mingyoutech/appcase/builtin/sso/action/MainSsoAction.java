/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.appcase.builtin.sso.action;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;

import net.sf.json.JSONArray;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.mybi.pim.common.action.SysBaseAction;
import com.mingyoutech.mybi.pim.para.domain.Pim_sysParam;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysMenu;
import com.mingyoutech.mybi.pim.util.CookieUtil;
import com.opensymphony.xwork2.ActionContext;

/**
 * @description:登录成功后进入系统主页面
 * @author hjz
 * @date:2014-05-09
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("privilegeStack")
@ResultPath("/WEB-INF/appcase")
@Action(
      results = {
       @Result(name = "mainpage", location = "builtin/sso/main-sso.jsp")
      })
public class MainSsoAction extends SysBaseAction {

  /**  */  
  private static final long serialVersionUID = -1334882891944767478L;
    
  /**  */ 
  private String pid;
    
    /**
   * @description:验证成功，转向应用系统架构页面
   * @param:
   * @return String 转向地址
   */
  @SuppressWarnings("unchecked")
  public String execute() {
    Map<String, Object> session = ActionContext.getContext().getSession();
    Cookie[] cookies = request.getCookies();
    boolean isHasCookie = false;
    String cookieVal = "";
    if (null != cookies) {
      Cookie ck = CookieUtil.getCookie(request, "com.mingyoutech.cookie.i18n");
      if (ck != null) {
        cookieVal = ck.getValue();
        isHasCookie = true;
      }
      
      if (!isHasCookie) {
        String lang = getSysParam("I18N_DEFAULT").getPval();
        if (lang == null || "".equals(lang) || "zh".equals(lang)) {
          CookieUtil.setCookie(response, "com.mingyoutech.cookie.i18n", "zh", 365 * 24 * 60 * 60);
          session.put("i18nDefault", "zh"); // 默认显示语言
        } else if ("en".equals(lang)) {
          CookieUtil.setCookie(response, "com.mingyoutech.cookie.i18n", "en", 365 * 24 * 60 * 60);
          session.put("i18nDefault", "en"); // 默认显示语言
        }
      } else {
        if (cookieVal != null && cookieVal.equals("en")) {
          session.put("i18nDefault", "en"); // 默认显示语言
        } else {
          session.put("i18nDefault", "zh"); // 默认显示语言
        }
      }
    }
      
    if (session.get("i18nDefault") == null || String.valueOf(session.get("i18nDefault")) == null || String.valueOf(session.get("i18nDefault")).trim().equals("")) {
      if (ActionContext.getContext().getLocale().getLanguage().equals("en")) {
        session.put("i18nDefault", "en"); // 默认显示语言
      } else {
        session.put("i18nDefault", "zh"); // 默认显示语言
      }
    }
    
    List<Pim_sysMenu>  sysMenuList_session = (List<Pim_sysMenu>) session.get("sysMenuListWithAuth");
    List<Pim_sysMenu> sysMenuList = generateMenuListForShow(sysMenuList_session, "-1");
    
    if (sysMenuList != null && sysMenuList.size() > 0) {
      Pim_sysMenu defultMenu = findFirstMenu(sysMenuList);
      if (defultMenu != null) {
        String defaultUrl = defultMenu.getUrl();
        if (defaultUrl.contains("?")) {
          defaultUrl += "&authTyp=menu&authMenuId=" + defultMenu.getId();
        } else {
          defaultUrl += "?authTyp=menu&authMenuId=" + defultMenu.getId();
        }
        request.setAttribute("defaultUrl", defaultUrl);
      }
    }
    
    //如果系统参数ISHAVE_HOMEPAGE值不为0，则需要增加一个功能“首页”
    String isHasHomepage = (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("ISHAVE_HOMEPAGE")).getPval();
    request.setAttribute("isHasHomepage", isHasHomepage);
    
    String i18nSwitch = (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("I18N_SWITCH")).getPval();
    session.put("i18nSwitch", i18nSwitch);
    
    return "mainpage";
  }
    
    /**
     * @description:生成符合系统菜单展现要求的格式列表
     * @param sysMenuList List
     * @param pid StringS
     * @return List<Map<String, Object>> 
     */
  public List<Pim_sysMenu> generateMenuListForShow(List<Pim_sysMenu> sysMenuList, String pid) {
    List<Pim_sysMenu> mapList = new ArrayList<Pim_sysMenu>();
    if (sysMenuList != null && sysMenuList.size() > 0) {
      for (Pim_sysMenu menu:sysMenuList) {
        if (menu.getPid().equals(pid)) {
          menu.setSubSysMenuList(generateMenuListForShow(sysMenuList, menu.getId()));
          mapList.add(menu);
        }
      }
    }
    return mapList;
  }
    
    /**
   * @description:查找第一个URL非空的默认功能（默认功能是当系统没有首页时才加载）
   * @param sysMenuList List
   * @return null
   */
  public Pim_sysMenu findFirstMenu(List<Pim_sysMenu> sysMenuList) {
    for (Pim_sysMenu menu:sysMenuList) {
      if (menu.getUrl() != null && !menu.getUrl().trim().equals("")) {
        return menu;
      } else if (menu.getSubSysMenuList() != null && menu.getSubSysMenuList().size() > 0) {
        Pim_sysMenu m = findFirstMenu(menu.getSubSysMenuList());
        if (m != null) {
          return m;
        }
      }
    }
    return null;
  }
    
    /**
      * @description:转向系统的主管理页面
      * @return String 
      */
  public String toMainManage() {
    return "mainpage";
  }
  
  /**
   *    
   * @return none
   */
  @SuppressWarnings("unchecked")
  public String findAllMenu() {
    List<Pim_sysMenu> tmpList = new ArrayList<Pim_sysMenu>();
    //储存在session中的功能列表
    List<Pim_sysMenu>  sysMenuList_session = (List<Pim_sysMenu>) session.getAttribute("sysMenuListWithAuth");
    if (sysMenuList_session != null && sysMenuList_session.size() > 0) {
      for (Pim_sysMenu m:sysMenuList_session) {
        tmpList.add(m);
      }
    }
    //如果系统参数ISHAVE_HOMEPAGE值不为0，则需要增加一个功能“首页”
    String isHasHomepage = (((Map<String, Pim_sysParam>) application.getAttribute("sysParamMap")).get("ISHAVE_HOMEPAGE")).getPval();
    if (null != isHasHomepage && !"0".equals(isHasHomepage)) {
      Pim_sysMenu homeMenu = new Pim_sysMenu();
      homeMenu.setId("HOME");
      homeMenu.setNam("首页");
      homeMenu.setNamEg("Home");
      homeMenu.setPid("-1");
      homeMenu.setUrl("homepage!toHomepage.action");
      homeMenu.setChildsize(0);
      homeMenu.setIsdevuse("0");
      homeMenu.setLvl(1);
      homeMenu.setOrd(-1);
      tmpList.add(0, homeMenu);
    }
    
    //List<Pim_sysMenu> sysMenuList=generateEasyuiWestList(sysMenuList_session,"-1");
    JSONArray actionArray = JSONArray.fromObject(tmpList);   
    
    Struts2Utils.renderText(actionArray.toString());
    return NONE;
  }
    
  /**
   * @description:转向默认欢迎页
   * @return String 
   */
  public String toSysWelcome() {
    return "welcome";
  }

  public String getPid() {
    return pid;
  }

  public void setPid(String pid) {
    this.pid = pid;
  }
    
}
