/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 * 
 * 项目名称：版本管理平台
 * 创建日期：20150504
 * 修改历史：
 *    1. 创建文件by lvzhenjun, 20150504
 */
package com.mingyoutech.mybi.pim.vm.domain;

import org.apache.ibatis.type.Alias;

import com.mingyoutech.framework.domain.BaseDomain;

/**
 * Vm_component Domain对象
 * @author june,2016-01-01
 */
@Alias("Vm_component")
public class Vm_component extends BaseDomain {

  /** 序列化 */
  private static final long serialVersionUID = 2155862845919529900L;

  /** id */
  private String id;

  /** name */
  private String name;
  
  /** 版本号 */
  private String version;

  /** code */
  private String code;
  
  /** 工作空间 */
  private String workspace;
  
  /** 备份日志 */
  private String baklog;
  
  /** 安装包 */
  private String install_pkg;
  
  /** 日期戳 */
  private String timestamp;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getVersion() {
    return version;
  }

  public void setVersion(String version) {
    this.version = version;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getWorkspace() {
    return workspace;
  }

  public void setWorkspace(String workspace) {
    this.workspace = workspace;
  }

  public String getBaklog() {
    return baklog;
  }

  public void setBaklog(String baklog) {
    this.baklog = baklog;
  }

  public String getInstall_pkg() {
    return install_pkg;
  }

  public void setInstall_pkg(String install_pkg) {
    this.install_pkg = install_pkg;
  }

  public String getTimestamp() {
    return timestamp;
  }

  public void setTimestamp(String timestamp) {
    this.timestamp = timestamp;
  }
}
