/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-coding-1.0.0
 * 创建日期：2016-3-18
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-18
 */
package com.mingyoutech.mybi.demo.coding.core.util;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 文本处理工具类
 * @author John Xi, 2016-3-18
 */
public class TextUtil {
  
  /**
   * 对工具类隐藏构造器
   */
  private TextUtil() { }

  /**
   * 返回一个换行符
   * @return 返回一个换行符
   */
  public static String lineSeparator() {
    return System.getProperty("line.separator");
  }
  
  /**
   * 输入一个字符串，在其结尾添加换行符后返回
   * @param message 目标字符串
   * @return 在结尾追加字符串的字符串
   */
  public static String lineSeparator(String message) {
    return message + lineSeparator();
  }

  /**
   * 以字符形式表示当天日期
   * @return 当前日期字符串（yyyy-MM-dd）
   */
  public static String getStringDate() {
    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    return df.format(new Date(System.currentTimeMillis()));
  }
  


}
