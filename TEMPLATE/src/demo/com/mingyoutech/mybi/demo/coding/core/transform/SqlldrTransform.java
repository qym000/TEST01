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
 * sqlldr相关的数据类型转换
 * @author John Xi, 2016-3-21
 */
public class SqlldrTransform {

  /**
   * 隐藏公有构造器
   */
  private SqlldrTransform() { }
  
  /**
   * 将字典表中查到的数据类型信息，转换为sqlldr control文件中的数据类型
   * @param dataType USER_TAB_USER.DATA_TYPE
   * @param dataLength USER_TAB_USER.DATA_LENGTH
   * @param dataPrecision USER_TAB_USER.DATA_PRECISION
   * @param dataScale USER_TAB_USER.DATA_SCALE
   * @return control 文件中的数据类型
   */
  public static String findControlDataType(String dataType, int dataLength, int dataPrecision, int dataScale) {
    
    String str = "";

    if ("VARCHAR2".equals(dataType) || "CHAR".equals(dataType)) {
      str = "CHAR(" + dataLength + ")";
    } else if ("NVARCHAR2".equals(dataType)) {
      str = "CHAR(" + dataLength * 2 + ")";
    } else if ("NUMBER".equals(dataType)) {
      if (dataPrecision == 0) {
        str = "INTEGER EXTERNAL";
      } else {
        str = "DECIMAL EXTERNAL";
      }
    } else if ("COLB".equals(dataType)) {
      str = "CHAR(10000)";
    } else if ("DATE".equals(dataType)) {
      str = "DATE \"yyyy-mm-dd hh24:mi:ss\"";
    } else if (dataType.indexOf("TEMPSTAMP") > 0) {
      str = "TIMESTAMP \"yyyy-mm-dd hh24:mi:ss.ff\"";
    } else {
      str = "unknown data type ...";
    }
    return str;
  }
}
