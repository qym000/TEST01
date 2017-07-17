/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-coding-1.0.0
 * 创建日期：2016-3-18
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-18
 */
package com.mingyoutech.mybi.demo.coding.core.builder;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * （注解）用于标注代码模板生成器中的参数，包括“数据类型”和“参数值”。
 * <li>其数据类型包含整型、布尔型和字符型，用枚举Type表示。</li>
 * @author John Xi, 2016-3-18
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Parameter {

  /**
   * 用于表示参数类型的枚举
   * @author John Xi, 2016-3-18
   */
  public enum Type {
    /**
     * 整型
     */
    Integer,
    /**
     * 布尔型
     */
    Boolean,
    /**
     * 字符型
     */
    String
  }
  
  /**
   * 参数值
   */
  String value();
  
  /**
   * 参数类型
   */
  Type type();
}
