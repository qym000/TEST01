/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-coding-1.0.0
 * 创建日期：2016-3-21
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-21
 */
package com.mingyoutech.mybi.demo.coding.core.transform;

/**
 * 和建表相关的数据类型转换
 * @author John Xi, 2016-3-21
 */
public class TableTransform {

  /**
   * 隐藏公有构造器
   */
  private TableTransform() { }
  
  /**
   * 将字典表中查到的数据类型信息，转换为表中的数据类型
   * @param dataType USER_TAB_USER.DATA_TYPE
   * @param dataLength USER_TAB_USER.DATA_LENGTH
   * @param dataPrecision USER_TAB_USER.DATA_PRECISION
   * @param dataScale USER_TAB_USER.DATA_SCALE
   * @return Oracle 表中的数据类型
   */
  public static String findTableDataType(String dataType, int dataLength, int dataPrecision, int dataScale) {
    
    String str = "";

    if ("VARCHAR2".equals(dataType) || "CHAR".equals(dataType)) {
      str = "VARCARH2(" + dataLength + ")";
    } else if ("NVARCHAR2".equals(dataType)) {
      str = "NVARCHAR2(" + dataLength + ")";
    } else if ("NUMBER".equals(dataType)) {
      if (dataPrecision == 0) {
        str = "INTEGER";
      } else {
        if (dataScale == 0) {
          str = "NUMBER" + "(" + dataPrecision + ")";
        } else {
          str = "NUMBER" + "(" + dataPrecision + ", " + dataScale + ")";
        }
      }
    } else if ("COLB".equals(dataType)) {
      str = "COLB";
    } else if ("DATE".equals(dataType)) {
      str = "DATE";
    } else if (dataType.indexOf("TEMPSTAMP") > 0) {
      str = dataType;
    } else {
      str = "unknown data type ...";
    }
    return str;
  }
}
