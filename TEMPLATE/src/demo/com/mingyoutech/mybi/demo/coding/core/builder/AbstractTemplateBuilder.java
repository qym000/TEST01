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

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import com.mingyoutech.mybi.demo.coding.core.builder.Parameter.Type;




/**
 * （抽象类）代码模板生成器
 * <li>实现setParm(), getParm()等方法。</li>
 * @author John Xi, 2016-3-18
 */
public abstract class AbstractTemplateBuilder implements ItemplateBuilder {
  
  /**
   * 用于存储自定义的参数
   */
  private Map<String, Object> map = new HashMap<String, Object>();

  @Override
  public abstract String getCodingTemplate(Object obj) throws Exception;

  @Override
  public void setParm(String name, String parm) throws Exception {
    
    Parameter p = findParameterByName(name);
    
    if (p.type() == Type.Boolean) {  // 布尔型
            
      // 对参数进行简单验证，只能是true或者false
      if (!("true".equals(parm) || "false".equals(parm))) {
        throw new Exception("参数类型为布尔型，参数值只能为\"true\"或\"false\"，当前为" + parm + "。");
      }
      
      map.put(name, "true".equals(parm));
      
    } else if (p.type() == Type.Integer) {  // 整型
      
      Integer i = null;
      
      // 对参数进行简单验证，必须可被成功转换为整型
      try {
        i = Integer.parseInt(parm);
      } catch (Exception e) {
        throw new Exception("参数类型为整型，参数值只能为整型，当前为" + parm + "。");
      }
      
      map.put(name, i);
      
    } else {  // 字符型
      
      map.put(name, parm);
      
    }
  }

  /**
   * 根据参数名称，获取相应的Parameter注解
   * @param name 参数名称
   * @return 带有注解的属性
   * @throws Exception 获取field的值发生错误时抛出此异常
   */
  private Parameter findParameterByName(String name) throws Exception {
    
    Field[] fields = this.getClass().getDeclaredFields();
    String fieldValue = "";
    Parameter parameter = null;
    
    for (Field f : fields) {
      // 只查找带有"Parameter"注解的
      if (f.getAnnotation(Parameter.class) instanceof Parameter) {
        
        try {
          fieldValue = (String) f.get(this);
        } catch (IllegalArgumentException e) {
          throw new Exception(e);
        } catch (IllegalAccessException e) {
          throw new Exception(e);
        }
        
        // 找到指定的参数名称
        if (fieldValue.equals(name)) {
          parameter = f.getAnnotation(Parameter.class);
          break;
        }
      }
    }
    
    return parameter;
  }

  @Override
  public Object getParm(String name) {
    
    Object obj = map.get(name);
    
    if (obj == null) {  // 参数未自定义或不存在，返回默认值
      return getParmDefault(name);
    } else {  // 返回自定义值
      return obj;
    }
    
  }

  @Override
  public Object getParmDefault(String name) {
    
    Parameter p = null;
    try {
      p = findParameterByName(name);
    } catch (Exception e) {
      // 如果无法获取注解则返回null
      return null;
    }
    
    Object obj = null;
    String value = p.value();
    
    if (p.type() == Type.Boolean) { // 布尔型
      obj = "true".equals(value) ? true : false;
    } else if (p.type() == Type.Integer) {  // 整型
      obj = Integer.parseInt(value);
    } else {  // 字符型
      obj = value;
    }
    
    return obj;
  }
  
  @Override
  public String getParmDefaultString(String name) {
    
    Parameter p = null;
    try {
      p = findParameterByName(name);
    } catch (Exception e) {
      // 如果无法获取注解则返回null
      return "";
    }
    
    return p.value();
  }



}
