/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-coding-1.0.0
 * 创建日期：2016-3-21
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-21
 */
package com.mingyoutech.mybi.demo.coding.core.template.insertTable;

import com.mingyoutech.mybi.demo.coding.core.builder.AbstractTemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.Parameter;
import com.mingyoutech.mybi.demo.coding.core.builder.Parameter.Type;
import com.mingyoutech.mybi.demo.coding.core.entity.TableColumn;
import com.mingyoutech.mybi.demo.coding.core.entity.TableDescription;
import com.mingyoutech.mybi.demo.coding.core.transform.TableTransform;
import com.mingyoutech.mybi.demo.coding.core.util.TextUtil;



/**
 * 表插入模板
 * @author John Xi, 2016-3-21
 */
public class InsertTableBuilder extends AbstractTemplateBuilder implements ItemplateBuilder {
  
  /**
   * 脚本整体缩进几个空格
   * <li>默认0缩进，一般为偶数</li>
   */
  @Parameter(type = Type.Integer, value = "0")
  public static final String RETRACT = "retract";
  
  /**
   * 是否使用Append Hint
   * <li>默认"false"</li>
   */
  @Parameter(type = Type.Boolean, value = "false")
  public static final String IS_APPEND = "is_append";
  
  /**
   * 表结构
   */
  private TableDescription table;
  
  /**
   * 缩进
   */
  private String retract;

  @Override
  public String getCodingTemplate(Object obj) throws Exception {
    
    if (obj instanceof TableDescription) {
      table = (TableDescription) obj;
    } else {
      throw new Exception("生成表插入模板需传入TableDescription对象。");
    }
    
    retract = findRetract();
    String hint = (Boolean) getParm(IS_APPEND) ? "/*+append */ " : "";
    
    StringBuffer buffer = new StringBuffer();
    
    buffer.append(format("/* 加工: " + table.getComments() + " */"));
    buffer.append(format("insert into " + hint + table.getName().toLowerCase()));
    buffer.append(format("            ("));
    buffer.append(findTableColumns());
    buffer.append(format("            )"));
    buffer.append(retract + "select ");
    buffer.append(findInsertColumns());
    buffer.append(retract + "  from dual;");
    
    return buffer.toString();
  }

  /**
   * 展示插入的字段
   * @return 插入的字段
   */
  private String findInsertColumns() {
    
    StringBuffer buffer = new StringBuffer();
    int size = table.getColumnList().size() - 1;
    TableColumn col = null;
    
    for (int i = 0; i <= size; i++) {
      
      col = table.getColumnList().get(i);
      
      // 缩进
      if (i != 0) {
        buffer.append(retract + "       ");
      }
      
      // 字段
      buffer.append("'' as " + col.getName().toLowerCase());
      
      // 逗号
      if (i != size) {
        buffer.append(",");
      }
      
      // 换行
      buffer.append(TextUtil.lineSeparator());
    }
    
    return buffer.toString();
  }

  /**
   * 展示目标表中的所有字段，包含注释等
   * @return 目标表中的所有字段
   */
  private String findTableColumns() {
  
    StringBuffer buffer = new StringBuffer();
    int size = table.getColumnList().size() - 1;
    TableColumn col = null;
    String comments = "";
    
    for (int i = 0; i <= size; i++) {
      
      col = table.getColumnList().get(i);

      // 名称
      buffer.append(retract + "            " + col.getName().toLowerCase());
      
      // 逗号
      if (i != size) {
        buffer.append(",");
      } else {
        buffer.append(" ");
      }
     
      // comments
      if (col.getComments() == null || "".equals(col.getComments())) {
        comments = "";
      } else {
        comments = ", " + col.getComments();
      }
      
      // 注释
      buffer.append("  -- " + TableTransform.findTableDataType(col.getDataType(), col.getDataLength(), col.getDataPrecision(), col.getDataScale()) + comments);
     
      //换行 
      buffer.append(TextUtil.lineSeparator());
    }
    
    return buffer.toString();
  }

  /**
   * 格式化一行的脚本：前缩进，后空格
   * @param message 一行脚本
   * @return 格式化后的一行脚本
   */
  private String format(String message) {
    return TextUtil.lineSeparator(retract + message);
  }
  
  /**
   * 生成缩进样式（其实就是若干个空格）
   * @return 需要缩进的空格
   */
  private String findRetract() {
    
    StringBuffer buffer = new StringBuffer();
    
    for (int i = 0; i < (Integer) getParm(RETRACT); i++) {
      buffer.append(" ");
    }
    
    return buffer.toString();
  }

}
