/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.coding.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingTemplateService;

/**
 * @description:Etl 作业与数据库连接配置Service实现层
 * @author:june
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@SuppressWarnings("unchecked")
@Service
public class Demo_codingTemplateServiceImpl extends BaseServiceImpl<Demo_jdbc> implements Demo_codingTemplateService{

  @Override
  public List<Demo_jdbc> findJdbcList() {
    return this.find("com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc.findJdbcList", null);
  }




}