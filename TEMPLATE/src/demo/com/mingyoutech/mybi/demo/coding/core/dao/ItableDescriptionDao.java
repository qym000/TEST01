/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-template-2.2.1
 * 创建日期：2016-3-25
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-25
 */
package com.mingyoutech.mybi.demo.coding.core.dao;

import java.util.List;

import com.mingyoutech.mybi.demo.coding.core.entity.TableColumn;
import com.mingyoutech.mybi.demo.coding.core.entity.TableDescription;

/**
 * @author John Xi, 2016-3-25
 */
public interface ItableDescriptionDao {
  
  
  /**
   * 根据表名获取表结构
   * @param tableName 表名
   * @return 表结构
   * @throws Exception 查询数据库时发生异常
   */
  TableDescription findTableDescriptionByName(String tableName) throws Exception;

  /**
   * 根据表名，获取所有的表字段
   * @param tableName 表名
   * @return 所有的表字段
   * @throws Exception 查询数据库时发生异常
   */
  List<TableColumn> findTableColumnListByName(String tableName) throws Exception;

}
