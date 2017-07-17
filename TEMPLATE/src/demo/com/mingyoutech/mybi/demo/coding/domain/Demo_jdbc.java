/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-template-2.2.1
 * 创建日期：2016-3-23
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-23
 */
package com.mingyoutech.mybi.demo.coding.domain;

import com.mingyoutech.framework.domain.BaseDomain;

/**
 * @author John Xi, 2016-3-23
 */
public class Demo_jdbc extends BaseDomain {

  /**  */
  private static final long serialVersionUID = 7937294801663477303L;

  // 连接ID
  private String connectId;

  // 链接方案描述
  private String connectDesc;

  // 服务器IP
  private String ip;

  // 服务器IP
  private String port;

  // 实例名
  private String sid;

  // 用户名
  private String username;

  // 密码
  private String password;

  // 备注
  private String remark;

  public Demo_jdbc() {

  }

  public Demo_jdbc(String id) {
    this.connectId = id;
  }

  public String getConnectId() {
    return connectId;
  }

  public void setConnectId(String connectId) {
    this.connectId = connectId;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }

  public String getSid() {
    return sid;
  }

  public void setSid(String sid) {
    this.sid = sid;
  }

  public String getUsername() {
    return username;
  }

  public void setUsername(String username) {
    this.username = username;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public String getConnectDesc() {
    return connectDesc;
  }

  public void setConnectDesc(String connectDesc) {
    this.connectDesc = connectDesc;
  }

  public String getPort() {
    return port;
  }

  public void setPort(String port) {
    this.port = port;
  }
}
