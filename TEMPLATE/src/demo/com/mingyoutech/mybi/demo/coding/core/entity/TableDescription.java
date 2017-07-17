/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-coding-1.0.0
 * 创建日期：2016-3-18
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-18
 */
package com.mingyoutech.mybi.demo.coding.core.entity;

import java.util.List;

/**
 * 表结构实体类
 * @author John Xi, 2016-3-18
 */
public class TableDescription {

  /**
   * 表名
   */
  private String name;
  
  /**
   * 表注释
   */
  private String comments;
  
  /**
   * 表字段
   */
  private List<TableColumn> columnList;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getComments() {
    return comments;
  }

  public void setComments(String comments) {
    this.comments = comments;
  }

  public List<TableColumn> getColumnList() {
    return columnList;
  }

  public void setColumnList(List<TableColumn> columnList) {
    this.columnList = columnList;
  }

  @Override
  public String toString() {
    return "TableDescription [name=" + name + ", comments=" + comments + "]";
  }
  
}
