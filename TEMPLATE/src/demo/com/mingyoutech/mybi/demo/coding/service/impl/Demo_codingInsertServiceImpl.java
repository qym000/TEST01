/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.coding.service.impl;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.framework.util.PasswordUtil;
import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilderFactory;
import com.mingyoutech.mybi.demo.coding.core.dao.ItableDescriptionDao;
import com.mingyoutech.mybi.demo.coding.core.dao.impl.TableDescriptionDao;
import com.mingyoutech.mybi.demo.coding.core.entity.TableDescription;
import com.mingyoutech.mybi.demo.coding.core.template.insertTable.InsertTableBuilder;
import com.mingyoutech.mybi.demo.coding.core.template.insertTable.InsertTableBuilderFactory;
import com.mingyoutech.mybi.demo.coding.domain.Demo_insertDetail;
import com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingInsertService;

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
public class Demo_codingInsertServiceImpl extends BaseServiceImpl<Demo_jdbc> implements Demo_codingInsertService{
  
  private ItemplateBuilderFactory factory = new InsertTableBuilderFactory();
  private ItemplateBuilder builder = factory.create();
  
  @Override
  public Demo_insertDetail getDefaultInsertDetail() {
    
    Demo_insertDetail detail = new Demo_insertDetail();
    
    detail.setRetract(builder.getParmDefaultString(InsertTableBuilder.RETRACT));
    detail.setIs_append(builder.getParmDefaultString(InsertTableBuilder.IS_APPEND));
    
    return detail;
  }

  @Override
  public boolean saveInsertDetail(Demo_insertDetail detail) {
    
    try {
      
      builder.setParm(InsertTableBuilder.RETRACT, detail.getRetract());
      builder.setParm(InsertTableBuilder.IS_APPEND, detail.getIs_append());

    } catch (Exception e) {
      log.error(e);
      return false;
    }
    
    return true;
    
  }

  @Override
  public String getTemplate(String connectId, String tableName, Demo_insertDetail detail) {
    
    Demo_jdbc parm = new Demo_jdbc();
    parm.setConnectId(connectId);
    
    Demo_jdbc jdbc = (Demo_jdbc) this.findForObject("com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc.findJdbcByConnectId", parm);
    // 反编译密码
    jdbc.setPassword(PasswordUtil.ciphertextToPassword(jdbc.getPassword()));
    
    //jdbc:oracle:thin:@10.0.0.205:1521:ora11g
    String url = "jdbc:oracle:thin:@" + jdbc.getIp() + ":" + jdbc.getPort() + ":" + jdbc.getSid();
    ItableDescriptionDao dao = new TableDescriptionDao(url, jdbc.getUsername(), jdbc.getPassword());
    
    ItemplateBuilderFactory factory = new InsertTableBuilderFactory();
    ItemplateBuilder builder = factory.create();

    String message = "";
    try {
      // 获取表结构
      TableDescription table = dao.findTableDescriptionByName(tableName.toUpperCase().trim());
      
      if (table == null) {
        throw new Exception("未获取到名为" + tableName + "的表。");
      }
      
      // 设置参数
      builder.setParm(InsertTableBuilder.RETRACT, detail.getRetract());
      builder.setParm(InsertTableBuilder.IS_APPEND, detail.getIs_append());

      
      message = builder.getCodingTemplate(table);
    } catch (Exception e) {
      message = "创建代码模板时发生异常：" + e.getMessage();
    }
    
    return message;
  }






}