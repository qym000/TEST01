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

/**
 * (接口)代码模板生成器。
 * <li>用于生成代码模板，及查询、获取参数等。</li>
 * @author John Xi, 2016-3-18
 */
public interface ItemplateBuilder {

  /**
   * 输入原始对象，获取代码模板
   * @param obj 用于生成代码模板的原始对象
   * @return 代码模板
   * @throws Exception 当生成代码模板发生错误时，抛出异常
   */
  String getCodingTemplate(Object obj) throws Exception;
  
  /**
   * 设置生成代码模板所需的参数。首次设置会覆盖默认值，重复设置会保留最后一次。
   * @param name 参数名称
   * @param parm 参数值（不论何种参数值，都用String类型输入）
   * @throws Exception 当参数设置不成功（如不存在的参数名等），或设置错误时，抛出异常
   */
  void setParm(String name, String parm) throws Exception;
  
  /**
   * 获取参数值。参数值可以是整型，字符型或布尔型。
   * @param name 参数名称
   * @return 如果参数未被自定义，则返回默认值。否则，返回被设置的值。
   */
  Object getParm(String name);
  
  /**
   * 无论该参数是否被设置，都返回默认的参数值。
   * @param name 参数名称
   * @return 默认的参数值
   */
  Object getParmDefault(String name);
  
  /**
   * 无论该参数是否被设置，都返回默认的参数值。以字符形式返回，布尔型的返回"true"或者"false"字符。
   * @param name
   * @return
   */
  String getParmDefaultString(String name);
}
