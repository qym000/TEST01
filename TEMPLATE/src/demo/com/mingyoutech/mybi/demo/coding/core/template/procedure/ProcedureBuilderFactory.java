/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-coding-1.0.0
 * 创建日期：2016-3-21
 * 修改历史：
 *    1. 创建文件。by John Xi, 2016-3-21
 */
package com.mingyoutech.mybi.demo.coding.core.template.procedure;

import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilder;
import com.mingyoutech.mybi.demo.coding.core.builder.ItemplateBuilderFactory;

/**
 * @author John Xi, 2016-3-21
 */
public class ProcedureBuilderFactory implements ItemplateBuilderFactory {

  @Override
  public ItemplateBuilder create() {
    return new ProcedureBuilder();
  }

}
