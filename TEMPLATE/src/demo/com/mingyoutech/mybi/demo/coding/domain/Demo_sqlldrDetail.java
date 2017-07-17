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
public class Demo_sqlldrDetail extends BaseDomain {

  /**  */
  private static final long serialVersionUID = -8054665772301992160L;

  private String skip;
  private String errors;
  private String rows;
  private String bindsize;
  private String readsize;
  private String direct;
  private String is_trim_function;
  private String fields_treminated;
  private String load_mode;
  private String data_file;
  private String is_col_comments;
  
  public String getSkip() {
    return skip;
  }
  public void setSkip(String skip) {
    this.skip = skip;
  }
  public String getErrors() {
    return errors;
  }
  public void setErrors(String errors) {
    this.errors = errors;
  }
  public String getRows() {
    return rows;
  }
  public void setRows(String rows) {
    this.rows = rows;
  }
  public String getBindsize() {
    return bindsize;
  }
  public void setBindsize(String bindsize) {
    this.bindsize = bindsize;
  }
  public String getReadsize() {
    return readsize;
  }
  public void setReadsize(String readsize) {
    this.readsize = readsize;
  }
  public String getDirect() {
    return direct;
  }
  public void setDirect(String direct) {
    this.direct = direct;
  }
  public String getIs_trim_function() {
    return is_trim_function;
  }
  public void setIs_trim_function(String is_trim_function) {
    this.is_trim_function = is_trim_function;
  }
  public String getFields_treminated() {
    return fields_treminated;
  }
  public void setFields_treminated(String fields_treminated) {
    this.fields_treminated = fields_treminated;
  }
  public String getLoad_mode() {
    return load_mode;
  }
  public void setLoad_mode(String load_mode) {
    this.load_mode = load_mode;
  }
  public String getData_file() {
    return data_file;
  }
  public void setData_file(String data_file) {
    this.data_file = data_file;
  }
  public String getIs_col_comments() {
    return is_col_comments;
  }
  public void setIs_col_comments(String is_col_comments) {
    this.is_col_comments = is_col_comments;
  }
  
  

}
