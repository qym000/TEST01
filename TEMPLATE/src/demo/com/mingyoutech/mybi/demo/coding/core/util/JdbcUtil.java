/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-template-2.2.1
 * 创建日期：2016-3-25
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-25
 */
package com.mingyoutech.mybi.demo.coding.core.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * 用于连接JDBC资源库
 * @author John Xi, 2016-3-25
 */
public class JdbcUtil {

  /**
   * 指定参数，获取Connection。
   * @param url IP地址
   * @param userName 用户名
   * @param passWord 密码
   * @return Connection
   * @throws Exception
   */
  public static Connection getConnection(String url, String userName, String passWord) throws Exception {
    
    Connection conn = null;
    
    try {
      Class.forName("oracle.jdbc.driver.OracleDriver");
      conn = DriverManager.getConnection(url, userName, passWord);
    } catch (Exception e) {
      throw new Exception(e);
    }
    
    return conn;
  }
  
  /**
   * 关闭连接
   * @param rs ResultSet
   * @param stmt Statement
   * @param conn Connection
   */
  public static void close(ResultSet rs, Statement stmt, Connection conn) {
    
    try {
      if (rs != null) {
        rs.close();
        rs = null;
      }
    } catch (Exception e) {
    }
    
    try {
      if (stmt != null) {
        stmt.close();
        stmt = null;
      }
    } catch (Exception e) {
    }
    
    try {
      if (conn != null) {
        conn.close();
        conn = null;
      }
    } catch (Exception e) {
    }
  }
}
