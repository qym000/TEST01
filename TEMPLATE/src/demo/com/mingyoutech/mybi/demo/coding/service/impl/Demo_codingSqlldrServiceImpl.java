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
import com.mingyoutech.mybi.demo.coding.core.template.sqlldr.SqlldrBuilder;
import com.mingyoutech.mybi.demo.coding.core.template.sqlldr.SqlldrBuilderFactory;
import com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc;
import com.mingyoutech.mybi.demo.coding.domain.Demo_sqlldrDetail;
import com.mingyoutech.mybi.demo.coding.service.Demo_codingSqlldrService;

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
public class Demo_codingSqlldrServiceImpl extends BaseServiceImpl<Demo_jdbc> implements Demo_codingSqlldrService{
  
  private ItemplateBuilderFactory factory = new SqlldrBuilderFactory();
  private ItemplateBuilder builder = factory.create();
  
  @Override
  public Demo_sqlldrDetail getDefaultSqlldrDetail() {
    
    Demo_sqlldrDetail detail = new Demo_sqlldrDetail();
    
    detail.setSkip(builder.getParmDefaultString(SqlldrBuilder.SKIP));
    detail.setErrors(builder.getParmDefaultString(SqlldrBuilder.ERRORS));
    detail.setRows(builder.getParmDefaultString(SqlldrBuilder.ROWS));
    detail.setBindsize(builder.getParmDefaultString(SqlldrBuilder.BINDSIZE));
    detail.setReadsize(builder.getParmDefaultString(SqlldrBuilder.READSIZE));
    detail.setDirect(builder.getParmDefaultString(SqlldrBuilder.DIRECT));
    detail.setIs_trim_function(builder.getParmDefaultString(SqlldrBuilder.IS_TRIM_FUNCTION));
    detail.setFields_treminated(builder.getParmDefaultString(SqlldrBuilder.FIELDS_TERMINATED));
    detail.setLoad_mode(builder.getParmDefaultString(SqlldrBuilder.LOAD_MODE));
    detail.setData_file(builder.getParmDefaultString(SqlldrBuilder.DATA_FILE));
    detail.setIs_col_comments(builder.getParmDefaultString(SqlldrBuilder.IS_COL_COMMENTS));
    
    return detail;
  }

  @Override
  public boolean saveSqlldrDetail(Demo_sqlldrDetail detail) {
    
    try {
      builder.setParm(SqlldrBuilder.SKIP, detail.getSkip());
      builder.setParm(SqlldrBuilder.ERRORS, detail.getErrors());
      builder.setParm(SqlldrBuilder.ROWS, detail.getRows());
      builder.setParm(SqlldrBuilder.BINDSIZE, detail.getBindsize());
      builder.setParm(SqlldrBuilder.READSIZE, detail.getReadsize());
      builder.setParm(SqlldrBuilder.DIRECT, detail.getDirect());
      builder.setParm(SqlldrBuilder.IS_TRIM_FUNCTION, detail.getIs_trim_function());
      builder.setParm(SqlldrBuilder.FIELDS_TERMINATED, detail.getFields_treminated());
      builder.setParm(SqlldrBuilder.LOAD_MODE, detail.getLoad_mode());
      builder.setParm(SqlldrBuilder.DATA_FILE, detail.getData_file());
      builder.setParm(SqlldrBuilder.IS_COL_COMMENTS, detail.getIs_col_comments());
    } catch (Exception e) {
      log.error(e);
      return false;
    }
    
    return true;
    
  }

  @Override
  public String getTemplate(String connectId, String tableName, Demo_sqlldrDetail detail) {
    
    Demo_jdbc parm = new Demo_jdbc();
    parm.setConnectId(connectId);
    
    Demo_jdbc jdbc = (Demo_jdbc) this.findForObject("com.mingyoutech.mybi.demo.coding.domain.Demo_jdbc.findJdbcByConnectId", parm);
    // 反编译密码
    jdbc.setPassword(PasswordUtil.ciphertextToPassword(jdbc.getPassword()));
    
    //jdbc:oracle:thin:@10.0.0.205:1521:ora11g
    String url = "jdbc:oracle:thin:@" + jdbc.getIp() + ":" + jdbc.getPort() + ":" + jdbc.getSid();
    ItableDescriptionDao dao = new TableDescriptionDao(url, jdbc.getUsername(), jdbc.getPassword());
    
    ItemplateBuilderFactory factory = new SqlldrBuilderFactory();
    ItemplateBuilder builder = factory.create();

    String message = "";
    try {
      // 获取表结构
      TableDescription table = dao.findTableDescriptionByName(tableName.toUpperCase().trim());
      
      if (table == null) {
        throw new Exception("未获取到名为" + tableName + "的表。");
      }
      
      // 设置参数
      builder.setParm(SqlldrBuilder.SKIP, detail.getSkip());
      builder.setParm(SqlldrBuilder.ERRORS, detail.getErrors());
      builder.setParm(SqlldrBuilder.ROWS, detail.getRows());
      builder.setParm(SqlldrBuilder.BINDSIZE, detail.getBindsize());
      builder.setParm(SqlldrBuilder.READSIZE, detail.getReadsize());
      builder.setParm(SqlldrBuilder.DIRECT, detail.getDirect());
      builder.setParm(SqlldrBuilder.IS_TRIM_FUNCTION, detail.getIs_trim_function());
      builder.setParm(SqlldrBuilder.FIELDS_TERMINATED, detail.getFields_treminated());
      builder.setParm(SqlldrBuilder.LOAD_MODE, detail.getLoad_mode());
      builder.setParm(SqlldrBuilder.DATA_FILE, detail.getData_file());
      builder.setParm(SqlldrBuilder.IS_COL_COMMENTS, detail.getIs_col_comments());
      
      message = builder.getCodingTemplate(table);
    } catch (Exception e) {
      message = "创建代码模板时发生异常：" + e.getMessage();
    }
    
    return message;
  }






}