/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-coding-1.0.0
 * 创建日期：2016-3-18
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-18
 */
package com.mingyoutech.mybi.demo.coding.core.template.sqlldr;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.mingyoutech.mybi.demo.coding.core.builder.AbstractTemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.Parameter;
import com.mingyoutech.mybi.demo.coding.core.builder.Parameter.Type;
import com.mingyoutech.mybi.demo.coding.core.entity.TableColumn;
import com.mingyoutech.mybi.demo.coding.core.entity.TableDescription;
import com.mingyoutech.mybi.demo.coding.core.transform.SqlldrTransform;
import com.mingyoutech.mybi.demo.coding.core.transform.TableTransform;
import com.mingyoutech.mybi.demo.coding.core.util.TextUtil;

/**
 * sqlldr创建模板
 * @author John Xi, 2016-3-18
 */
public class SqlldrBuilder extends AbstractTemplateBuilder implements ItemplateBuilder {
  
  /**
   * 要跳过的逻辑记录的数目
   * <li>默认 0</li>
   */
  @Parameter(type = Type.Integer, value = "0")
  public static final String SKIP = "skip";

  /**
   * 允许的错误的数目
   * <li>sqlldr默认：50</li>
   * <li>本模板中，默认0</li>
   */
  @Parameter(type = Type.Integer, value = "0")
  public static final String ERRORS = "errors";

  /**
   * 常规路径绑定数组中或直接路径保存数据间的行数
   * <li>sqlldr默认：常规路径 64, 所有直接路径</li>
   * <li>本模板中，默认1000</li>
   * <li>注意bindsize, readsize和rows三个参数的匹配</li>
   */
  @Parameter(type = Type.Integer, value = "1000")
  public static final String ROWS = "rows";

  /**
   * 常规路径绑定数组的大小 (以字节计)
   * <li>默认256000</li>
   * <li>注意bindsize, readsize和rows三个参数的匹配</li>
   */
  @Parameter(type = Type.Integer, value = "256000")
  public static final String BINDSIZE = "bindsize";

  /**
   * 读取缓冲区的大小
   * <li>默认 1048576</li>
   * <li>注意bindsize, readsize和rows三个参数的匹配</li>
   */
  @Parameter(type = Type.Integer, value = "1048576")
  public static final String READSIZE = "readsize";

  /**
   * 使用直接路径
   * <li>默认false</li>
   */
  @Parameter(type = Type.Boolean, value = "false")
  public static final String DIRECT = "direct";

  /**
   * 指定是否在模板中添加trim()函数。
   * <li>本模板中，默认"false"</li>
   * <li>可选"true"或"false"</li>
   */
  @Parameter(type = Type.Boolean, value = "false")
  public static final String IS_TRIM_FUNCTION = "is_trim_function";

  /**
   * 指定字段分隔符
   * <li>本模板中，默认" | "</li>
   * <li>可按照实际需求填写</li>
   */
  @Parameter(type = Type.String, value = " | ")
  public static final String FIELDS_TERMINATED = "fields_treminated";

  /**
   * 数据载入方式
   * <li>本模板中，默认"TRUNCATE"</li>
   * <li>可选"APPEND", "INSERT", "REPLACE", "TRUNCATE"</li>
   * <li>APPEND: 原先的表有数据 就加在后面</li>
   * <li>INSERT: 装载空表，如果原先的表有数据，sqlloader会停止(为sqlldr工具默认值)</li>
   * <li>REPLACE: 原先的表有数据，原先的数据会全部删除</li>
   * <li>TRUNCATE: 指定的内容和replace的相同，会用truncate语句删除现存数据</li>
   */
  @Parameter(type = Type.String, value = "TRUNCATE")
  public static final String LOAD_MODE = "load_mode";

  /**
   * 数据文件名称
   * <li>本模板中，默认"demo.dat"</li>
   * <li>可按照实际需求设置</li>
   */
  @Parameter(type = Type.String, value = "demo.dat")
  public static final String DATA_FILE = "data_file";

  /**
   * 是否为字段添加注释
   * <li>本模板中，默认"true"</li>
   * <li>可选"true", "false"</li>
   */
  @Parameter(type = Type.Boolean, value = "true")
  public static final String IS_COL_COMMENTS = "is_col_comments";
  
  /**
   * 字段名称
   */
  private static final int COLUMN_NAME = 0;
  
  /**
   * 字段类型
   */
  private static final int COLUMN_TYPE = 1;
  
  /**
   * 字段处理函数
   */
  private static final int COLUMN_FUNCTION = 2;
  
  /**
   * 字段注释
   */
  private static final int COLUMN_COMMENTS = 3;
  
  /**
   * 需要生成sqlldr模板的表
   */
  private TableDescription table;
  

  
  
  @Override
  public String getCodingTemplate(Object obj) throws Exception {
    
    // 检查传入的对象是否合法
    if (obj instanceof TableDescription) {
      table = (TableDescription) obj;
    } else {
      throw new Exception("生成sqlldr模板需传入TableDescription对象。");
    }
    
    StringBuffer buffer = new StringBuffer();
    
    // option
    buffer.append("OPTIONS (");
    buffer.append(SKIP + "=" + getParm(SKIP) + ", ");
    buffer.append(ERRORS + "=" + getParm(ERRORS) + ", ");
    buffer.append(ROWS + "=" + getParm(ROWS) + ", ");
    buffer.append(BINDSIZE + "=" + getParm(BINDSIZE) + ", ");
    buffer.append(READSIZE + "=" + getParm(READSIZE) + ", ");
    buffer.append(DIRECT + "=" + getParm(DIRECT) + ")" + TextUtil.lineSeparator());
    
    // head
    buffer.append(TextUtil.lineSeparator("LOAD DATA"));
    buffer.append(TextUtil.lineSeparator("--INFILE " + getParm(DATA_FILE)));
    buffer.append(TextUtil.lineSeparator("${infile}   -- myetl中使用此符号代替数据文件"));
    buffer.append(TextUtil.lineSeparator((String) getParm(LOAD_MODE)));
    buffer.append(TextUtil.lineSeparator("INTO TABLE " + table.getName()));
    buffer.append(TextUtil.lineSeparator("WHEN (1:5) <> '|||||'  --需要忽略的数据(可选或自定义)"));
    buffer.append(TextUtil.lineSeparator("FIELDS TERMINATED BY '" + getParm(FIELDS_TERMINATED) + "'"));
    buffer.append(TextUtil.lineSeparator("TRAILING NULLCOLS"));
    
    // columns
    buffer.append(TextUtil.lineSeparator("("));
    buffer.append(findColumnScript());
    buffer.append(TextUtil.lineSeparator(")"));
    
    return buffer.toString();
  }

  /**
   * 打印每个字段的表达式
   * @return 所有字段的表达式
   */
  private String findColumnScript() {
    
    StringBuffer buffer = new StringBuffer();
    List<Map<Integer, String>> elements = findColumnElements(table.getColumnList());
    Map<Integer, String> formatMap = findElementFormat(elements);
    int lastColumnPression = elements.size() - 1; // 最后一个字段位于list中的位置
    Map<Integer, String> map = null;
    
    for (int i = 0; i <= lastColumnPression; i++) {
      
      map = elements.get(i);
      
      // 字段名
      buffer.append(String.format(formatMap.get(COLUMN_NAME), map.get(COLUMN_NAME)));
      
      
      // 数据类型
      buffer.append("  ");
      buffer.append(String.format(formatMap.get(COLUMN_TYPE), map.get(COLUMN_TYPE)));
      
      //trim()函数
      if ((Boolean) getParm(IS_TRIM_FUNCTION)) {
        buffer.append("  ");
        buffer.append(String.format(formatMap.get(COLUMN_FUNCTION), map.get(COLUMN_FUNCTION)));
      }
      
      // 字段结尾的逗号
      if (i < lastColumnPression) {
        buffer.append(",");
      } else {
        buffer.append(" ");
      }
      
      // 注释
      if ((Boolean) getParm(IS_COL_COMMENTS)) {
        buffer.append("  ");
        buffer.append("-- " + map.get(COLUMN_COMMENTS));
      }
      
      // 换行
      buffer.append(TextUtil.lineSeparator());
    }

    
    return buffer.toString();
  }

  /**
   * 生成脚本元素的打印格式，主要针对列对其等。
   * Map中存放一个字段元素的打印格式（所有的字段都是一样的）
   * @param elements 用于打印的脚本元素
   * @return 打印格式(COLUMN_NAME, COLUMN_TYPE, COLUMN_FUNCTION)
   */
  private Map<Integer, String> findElementFormat(List<Map<Integer, String>> elements) {
    
    Map<Integer, String> formatMap = new HashMap<Integer, String>();
    
    int maxNameLength = 0;  // 字段名称的最大长度
    int maxDataTypeLength = 0;  // 数据类型的最大长度
    int maxTrimLength = 0;  // trim函数的最大长度 
    
    // 遍历需要打印的长度，找出各个最大长度
    for (Map<Integer, String> map : elements) {
      if (map.get(COLUMN_NAME).length() > maxNameLength) {
        maxNameLength = map.get(COLUMN_NAME).length();
      }
      if (map.get(COLUMN_TYPE).length() > maxDataTypeLength) {
        maxDataTypeLength = map.get(COLUMN_TYPE).length();
      }
      if (map.get(COLUMN_FUNCTION).length() > maxTrimLength) {
        maxTrimLength = map.get(COLUMN_FUNCTION).length();
      }
    }
    
    formatMap.put(COLUMN_NAME, "%-" + maxNameLength + "s");
    formatMap.put(COLUMN_TYPE, "%-" + maxDataTypeLength + "s");
    formatMap.put(COLUMN_FUNCTION, "%-" + maxTrimLength + "s");

    return formatMap;
  }

  /**
   * 查找所有表字段的脚本元素，用于打印字段脚本。
   * Map中存放一个字段的若干元素，包括字段名称、字段类型等。
   * @param columnList 表中的所有字段
   * @return 所有字段的脚本元素
   */
  private List<Map<Integer, String>> findColumnElements(List<TableColumn> columnList) {
    
    List<Map<Integer, String>> list = new LinkedList<Map<Integer, String>>();
    String comments = "";
    
    for (TableColumn col : columnList) {
      
      Map<Integer, String> map = new HashMap<Integer, String>();
      
      // 字段名称
      map.put(COLUMN_NAME, col.getName());
      // 数据类型
      map.put(COLUMN_TYPE, SqlldrTransform.findControlDataType(col.getDataType(), col.getDataLength(), col.getDataPrecision(), col.getDataScale()));
      // trim()函数
      map.put(COLUMN_FUNCTION, "\"trim(:" + col.getName() + ")\"");
      // 添加注释
      if (col.getComments() == null || "".equals(col.getComments())) {
        comments = "";
      } else {
        comments = ", " + col.getComments();
      }
      map.put(COLUMN_COMMENTS, TableTransform.findTableDataType(col.getDataType(), col.getDataLength(), col.getDataPrecision(), col.getDataScale())
          + comments);
      
      list.add(map);
    }
    
    return list;
  }

}
