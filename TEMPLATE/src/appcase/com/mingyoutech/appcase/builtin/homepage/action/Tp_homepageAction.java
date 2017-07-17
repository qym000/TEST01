/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.appcase.builtin.homepage.action;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.mingyoutech.mybi.pim.common.action.SysBaseAction;

/**
 * @description:首页Action层
 * @author hjz
 * @date:2014-05-09
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("privilegeStack")
@Action(
      results = {@Result(name = "homepage", location = "builtin/homepage/homepage.jsp")
      })
public class Tp_homepageAction extends SysBaseAction {

  /**  */
  private static final long serialVersionUID = -6552486533454831298L;
  
  /**
   * @description:转向首页
   * @return String 转向地址homepage/homepage.jsp
   */
  public String toHomepage()  {
    return "homepage";
  }
}
