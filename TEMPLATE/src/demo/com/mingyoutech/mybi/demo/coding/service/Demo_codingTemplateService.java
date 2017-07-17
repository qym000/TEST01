/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.coding.service;

import java.util.List;

import com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc;


/**
 * @description:Etl 作业与数据库连接配置Service接口层
 * @author:june
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Demo_codingTemplateService {

  /**
   * 获取已配置的JDBC连接
   * @return
   */
  List<Demo_jdbc> findJdbcList();



}