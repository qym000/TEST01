/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.appcase;

/**
 * @description:常量定义
 * @author hjz
 * @date:2014-05-09
 */
public interface SysConstant {
  //设置系统名称
  //static final String SYSNAME="明佑BI平台";
  //设置系统英文名称
  //static final String SYSNAME_EN="MY DEV Platform";
  //是否启用IP绑定机制,1是0否
   // static final String IP_BIND="0";
  //设置首页，如果是门户为portal，如果是应用系统的登录页面为sysauth
  //如果上面启用了IP绑定则门户直接为portalmg,应用系统直接登录sysauthmg
  //static final String INDEXPAGE="sysauth";
  //注销后的页面,如果是门户为portal，如果是应用系统的登录页面为sysauth
  //static final String LOGOUTPAGE="sysauth";
  //设置应用系统的架构，可设置值为
  //sysauth_arch3_mega --菜单三级，位置上方
  //easyui
  //dwz
  //static final String APPSYA_ARCHITECTURE="easyui";
  //设置门户的架构，可设置值为
  //static final String PORTAL_ARCHITECTURE="default";  
    
    
  //甲方
  //static String OWNER="中国银行内蒙古自治区分行";
  //默认密码
  //static String DEFAULT_PASSWORD="888888";
  
  /**
   * 
   */
  String SESSION_USER_DATA = "loginUserObj";
  
  //设置系统管理的登录页面:sysauth-login.jsp
  //static String LOGINPAGE="sys-login.jsp";
  
  //static String MAINPAGE="main-easyui.jsp";
  
  //动作权限过滤:1过滤0不过滤（开发阶段可以设置为0）
  //static String ISACTIONFILTER="1";
  
  //语言切换
  //static String LANG_CHANGE="0";
  //默认显示语言en_US/zh_CN
  //static String LANG_DEFAULT="en_US";
  
  
  
  
  //设置应用系统的登录页面的样式，可设置值为
  //default --默认
  //static String SYSAUTHLOGINSKIN="default";
  //设置应用系统的管理页面的样式，可设置值为 
  //default --默认
  //static String SYSAUTHMGSKIN="new2014";
  //设置门户页面的样式，可设置值为 
  //default --默认
  //static String PORTALSKIN="default";
}
