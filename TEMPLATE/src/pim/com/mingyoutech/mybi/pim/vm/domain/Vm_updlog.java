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
 * Vm_updlog Domain对象
 * @author june,2016-01-01
 */
@Alias("Vm_updlog")
public class Vm_updlog extends BaseDomain {

  /** 序列化 */
  private static final long serialVersionUID = 2155862845919529900L;

  /** id */
  private String id;

  /** 升级日期 */
  private String cendat;
  
  /** 文件名称 */
  private String filename;

  /** code */
  private String code;
  
  /** 更新类型 */
  private String updtyp;
  
  /** 用户ID  */
  private String userid;
  
  /** 主机 */
  private String host;
  
  /** ip */
  private String ip;

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getCendat() {
    return cendat;
  }

  public void setCendat(String cendat) {
    this.cendat = cendat;
  }

  public String getFilename() {
    return filename;
  }

  public void setFilename(String filename) {
    this.filename = filename;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getUpdtyp() {
    return updtyp;
  }

  public void setUpdtyp(String updtyp) {
    this.updtyp = updtyp;
  }

  public String getUserid() {
    return userid;
  }

  public void setUserid(String userid) {
    this.userid = userid;
  }

  public String getHost() {
    return host;
  }

  public void setHost(String host) {
    this.host = host;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }
}
