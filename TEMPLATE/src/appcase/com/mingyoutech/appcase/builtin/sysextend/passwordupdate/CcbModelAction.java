/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.appcase.builtin.sysextend.passwordupdate;

import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import com.mingyoutech.framework.action.BaseAction;

/**
 * @description:建设银行密码安全性较验Action层
 * @author hjz
 * @date:2014-05-09
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("basicStack")
@ResultPath("/WEB-INF/mybi")
public class CcbModelAction extends BaseAction {

  /**  */
  private static final long serialVersionUID = -1334882891944767478L;
    
    /**
   * @description:密码较验
   * @return none
   */
  public String execute() {
    return NONE;
  } 
    
    
   
}
