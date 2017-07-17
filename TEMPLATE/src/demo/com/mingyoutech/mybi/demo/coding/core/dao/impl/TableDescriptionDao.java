/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-template-2.2.1
 * 创建日期：2016-3-25
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-25
 */
package com.mingyoutech.mybi.demo.coding.core.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedList;
import java.util.List;

import com.mingyoutech.mybi.demo.coding.core.dao.ItableDescriptionDao;
import com.mingyoutech.mybi.demo.coding.core.entity.TableColumn;
import com.mingyoutech.mybi.demo.coding.core.entity.TableDescription;
import com.mingyoutech.mybi.demo.coding.core.util.JdbcUtil;

/**
 * @author John Xi, 2016-3-25
 */
public class TableDescriptionDao implements ItableDescriptionDao {
  
  private String url;
  private String userName;
  private String password;
  
  /**
   * 
   * @param url IP地址
   * @param userName 用户名
   * @param password 密码
   */
  public TableDescriptionDao(String url, String userName, String password) {
    this.url = url;
    this.userName = userName;
    this.password = password;
  }

  @Override
  public TableDescription findTableDescriptionByName(String tableName) throws Exception {
    
    String sql = "SELECT A.TABLE_NAME, " +
                        "NVL(B.COMMENTS, '') AS COMMENTS " +
                   "FROM USER_TABLES       A, " +
                        "USER_TAB_COMMENTS B " +
                  "WHERE B.TABLE_NAME(+) = A.TABLE_NAME " +
                    "AND A.TABLE_NAME    = ?";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    TableDescription tab = null;
    
    try {
      conn = JdbcUtil.getConnection(url, userName, password);
      stmt = conn.prepareStatement(sql);
      stmt.setString(1, tableName);
      rs = stmt.executeQuery();
      
      while (rs.next()) {
        tab = new TableDescription();
        tab.setName(rs.getString("TABLE_NAME"));
        if (rs.getString("COMMENTS") != null && !"".equals(rs.getString("COMMENTS"))) {
          tab.setComments(rs.getString("COMMENTS").trim());
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
      throw new Exception("查找JDBC资源时发生异常。" + e.getMessage());
    } finally {
      JdbcUtil.close(rs, stmt, conn);
    }
    
    if (tab != null) {
     tab.setColumnList(findTableColumnListByName(tableName)); 
    }
    
    return tab;
  }

  @Override
  public List<TableColumn> findTableColumnListByName(String tableName) throws Exception {
    
    String sql = "SELECT A.COLUMN_ID, " +
    		                "A.COLUMN_NAME, " +
    		                "TRIM(B.COMMENTS) AS COMMENTS, " +
    		                "A.DATA_TYPE, " +
    		                "A.DATA_LENGTH, " +
    		                "NVL(A.DATA_PRECISION, 0) AS DATA_PRECISION, " +
    		                "NVL(A.DATA_SCALE, 0) AS DATA_SCALE, " +
    		                "A.NULLABLE " +
    		           "FROM USER_TAB_COLS     A, " +
    		                "USER_COL_COMMENTS B " +
    		          "WHERE B.TABLE_NAME(+)  = A.TABLE_NAME " +
    		            "AND B.COLUMN_NAME(+) = A.COLUMN_NAME " +
    		            "AND A.TABLE_NAME     = ?";
    
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    List<TableColumn> list = new LinkedList<TableColumn>();
    
    try {
      conn = JdbcUtil.getConnection(url, userName, password);
      stmt = conn.prepareStatement(sql);
      stmt.setString(1, tableName);
      rs = stmt.executeQuery();
      
      while(rs.next()) {
        TableColumn col = new TableColumn();
        col.setId(rs.getInt("COLUMN_ID"));
        col.setName(rs.getString("COLUMN_NAME"));
        col.setComments(rs.getString("COMMENTS"));
        col.setDataType(rs.getString("DATA_TYPE"));
        col.setDataLength(rs.getInt("DATA_LENGTH"));
        col.setDataPrecision(rs.getInt("DATA_PRECISION"));
        col.setDataScale(rs.getInt("DATA_SCALE"));
        col.setNullable(rs.getString("NULLABLE"));
        
        list.add(col);
      }
    } catch (Exception e) {
      e.printStackTrace();
      throw new Exception("查找JDBC资源时发生异常。" + e.getMessage());
    } finally {
      JdbcUtil.close(rs, stmt, conn);
    }
    
    return list;
  }

}
