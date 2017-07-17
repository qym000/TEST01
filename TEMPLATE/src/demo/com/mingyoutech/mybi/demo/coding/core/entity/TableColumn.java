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

/**
 * 表字段实体类
 * @author John Xi, 2016-3-18
 */
public class TableColumn {

  /**
   * USER_TAB_USER.COLUMN_ID
   */
  private int id;
  
  /**
   * USER_TAB_USER.COLUMN_NAME
   */
  private String name;
  
  /**
   * USER_TAB_COMMENTS.COMMENTS
   */
  private String comments;
  
  /**
   * USER_TAB_USER.DATA_TYPE
   */
  private String dataType;
  
  /**
   * USER_TAB_USER.DATA_LENGTH
   */
  private int dataLength;
  
  /**
   * USER_TAB_USER.DATA_PRECISION
   */
  private int dataPrecision;
  
  /**
   * USER_TAB_USER.DATA_SCALE
   */
  private int dataScale;
  
  /**
   * USER_TAB_USER.NULLABLE
   */
  private String nullable;

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

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

  public String getDataType() {
    return dataType;
  }

  public void setDataType(String dataType) {
    this.dataType = dataType;
  }

  public int getDataLength() {
    return dataLength;
  }

  public void setDataLength(int dataLength) {
    this.dataLength = dataLength;
  }

  public int getDataPrecision() {
    return dataPrecision;
  }

  public void setDataPrecision(int dataPrecision) {
    this.dataPrecision = dataPrecision;
  }

  public int getDataScale() {
    return dataScale;
  }

  public void setDataScale(int dataScale) {
    this.dataScale = dataScale;
  }

  public String getNullable() {
    return nullable;
  }

  public void setNullable(String nullable) {
    this.nullable = nullable;
  }

  @Override
  public String toString() {
    return "TableColumn [id=" + id + ", name=" + name + ", comments="
        + comments + ", dataType=" + dataType + ", dataLength=" + dataLength
        + ", dataPrecision=" + dataPrecision + ", dataScale=" + dataScale
        + ", nullable=" + nullable + "]";
  }
  
  
}
