/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.coding.service;

import com.mingyoutech.mybi.demo.coding.domain.Demo_procedureDetail;



/**
 * @description:Etl 作业与数据库连接配置Service接口层
 * @author:june
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Demo_codingProcedureService {
  
  /**
   * 获取sqlldr默认的高级参数
   * @return
   */
  Demo_procedureDetail getDefaultProcedureDetail();

  /**
   * 保存sqlldr高级参数，
   * 实际保存在session中，在此保存一遍是为了验证参数在逻辑上是否合法
   * @throws Exception
   */
  boolean saveProcedureDetail(Demo_procedureDetail sqlldrDetail);

  /**
   * @return
   */
  String getTemplate(Demo_procedureDetail detail); 

}