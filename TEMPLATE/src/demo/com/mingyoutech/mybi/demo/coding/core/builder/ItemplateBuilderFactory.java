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
 * (接口)代码模板生成器的工厂类
 * @author John Xi, 2016-3-18
 */
public interface ItemplateBuilderFactory {

  /**
   * 工厂类，用于创建代码模板生成器
   * @return 代码模板生成器
   */
  ItemplateBuilder create();
}
