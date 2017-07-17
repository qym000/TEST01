/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.coding.service.impl;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilderFactory;
import com.mingyoutech.mybi.demo.coding.core.template.procedure.ProcedureBuilder;
import com.mingyoutech.mybi.demo.coding.core.template.procedure.ProcedureBuilderFactory;
import com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc;
import com.mingyoutech.mybi.demo.coding.domain.Demo_procedureDetail;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingProcedureService;

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
public class Demo_codingProcedureServiceImpl extends BaseServiceImpl<Demo_jdbc> implements Demo_codingProcedureService{
  
  private ItemplateBuilderFactory factory = new ProcedureBuilderFactory();
  private ItemplateBuilder builder = factory.create();
  
  @Override
  public Demo_procedureDetail getDefaultProcedureDetail() {
    
    Demo_procedureDetail detail = new Demo_procedureDetail();
    detail.setRetract(builder.getParmDefaultString(ProcedureBuilder.RETRACT));
    detail.setName(builder.getParmDefaultString(ProcedureBuilder.NAME));
    detail.setAuthor(builder.getParmDefaultString(ProcedureBuilder.AUTHOR));

    return detail;
  }

  @Override
  public boolean saveProcedureDetail(Demo_procedureDetail detail) {
    
    try {
      builder.setParm(ProcedureBuilder.RETRACT, detail.getRetract());
      builder.setParm(ProcedureBuilder.NAME, detail.getName());
      builder.setParm(ProcedureBuilder.AUTHOR, detail.getAuthor());

    } catch (Exception e) {
      log.error(e);
      return false;
    }
    
    return true;
    
  }

  @Override
  public String getTemplate(Demo_procedureDetail detail) {
    
    ItemplateBuilderFactory factory = new ProcedureBuilderFactory();
    ItemplateBuilder builder = factory.create();

    String message = "";
    
    try {
      
      // 设置参数
      builder.setParm(ProcedureBuilder.RETRACT, detail.getRetract());
      builder.setParm(ProcedureBuilder.NAME, detail.getName());
      builder.setParm(ProcedureBuilder.AUTHOR, detail.getAuthor());

      
      message = builder.getCodingTemplate(null);
    } catch (Exception e) {
      message = "创建代码模板时发生异常：" + e.getMessage();
    }
    
    return message;
  }






}