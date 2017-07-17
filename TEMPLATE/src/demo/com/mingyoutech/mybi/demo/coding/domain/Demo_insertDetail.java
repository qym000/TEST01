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
public class Demo_insertDetail extends BaseDomain {

  /**  */
  private static final long serialVersionUID = -7839209086141874815L;

 
  private String retract;
  private String is_append;
  
  public String getRetract() {
    return retract;
  }
  public void setRetract(String retract) {
    this.retract = retract;
  }
  public String getIs_append() {
    return is_append;
  }
  public void setIs_append(String is_append) {
    this.is_append = is_append;
  }
  
  

}
