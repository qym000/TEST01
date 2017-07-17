/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 * 
 * 项目名称：版本管理平台
 * 创建日期：20150504
 * 修改历史：
 *    1. 创建文件by lvzhenjun, 20150504
 */
package com.mingyoutech.mybi.pim.vm.utils;

/**
 * 模板工程src/conf目录文件清单
 * 
 * @author june,2014-05-09
 */
public class TemplateConfUtil {

  /**
   * 私有化构造器，防止外部创建实例
   */
  private TemplateConfUtil() {
  }

  /**
   * 获取src/conf目录需要备份的清单
   * 
   * @return src/conf目录需要备份的清单
   */
  public static String[] getSrcConfFile() {
    String[] confFile = {
        "src/conf/daf_demo.properties", 
        "src/conf/i18nResources_en_US.properties", 
        "src/conf/i18nResources_zh_CN.properties", 
        "src/conf/jdbc.properties",
        "src/conf/log4j.properties", 
        "src/conf/resource.properties", 
        "src/conf/skip_access_control.properties", 
        "src/conf/struts.xml", 
        "WebRoot/index.jsp", 
        "WebRoot/index.html",
        "WebRoot/WEB-INF/mybi/beforeportal.jsp", 
        "WebRoot/WEB-INF/mybi/main-portal1.jsp", 
        "WebRoot/WEB-INF/mybi/main-portal.jsp", 
        "WebRoot/WEB-INF/web.xml" 
        };
    return confFile;
  }
}
