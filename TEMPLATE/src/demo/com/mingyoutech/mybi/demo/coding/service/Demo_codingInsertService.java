/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.coding.service;

import com.mingyoutech.mybi.demo.coding.domain.Demo_insertDetail;



/**
 * @description:Etl 作业与数据库连接配置Service接口层
 * @author:june
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Demo_codingInsertService {
  
  /**
   * 获取sqlldr默认的高级参数
   * @return
   */
  Demo_insertDetail getDefaultInsertDetail();

  /**
   * 保存sqlldr高级参数，
   * 实际保存在session中，在此保存一遍是为了验证参数在逻辑上是否合法
   * @throws Exception
   */
  boolean saveInsertDetail(Demo_insertDetail insertDetail);

  /**
   * @return
   */
  String getTemplate(String connectId, String tableName, Demo_insertDetail detail); 

}