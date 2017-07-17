/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 *
 * 项目名称：mybi-pim-2.2.2
 * 创建日期：2016-4-12
 * 修改历史：
 *    1. 创建文件。by GaoZhenHan, 2016-4-12
 */
package com.mingyoutech.mybi.demo.crud.domain;

import com.mingyoutech.framework.domain.BaseDomain;

/**
 * @author GaoZhenHan, 2016-4-12
 */
public class Demo_test extends BaseDomain{
  
  private static final long serialVersionUID = -7939301418656804270L;

  private String name;
  
  private String orgnam;
 
  private Integer age;
  
  private String gender;
  
  private String hobby;
  
  private String desc;
  
  private String birthday;
  
  private String work;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getOrgnam() {
    return orgnam;
  }

  public void setOrgnam(String orgnam) {
    this.orgnam = orgnam;
  }

  public Integer getAge() {
    return age;
  }

  public void setAge(Integer age) {
    this.age = age;
  }

  public String getGender() {
    return gender;
  }

  public void setGender(String gender) {
    this.gender = gender;
  }

  public String getHobby() {
    return hobby;
  }

  public void setHobby(String hobby) {
    this.hobby = hobby;
  }

  public String getDesc() {
    return desc;
  }

  public void setDesc(String desc) {
    this.desc = desc;
  }

  public String getBirthday() {
    return birthday;
  }

  public void setBirthday(String birthday) {
    this.birthday = birthday;
  }

  public String getWork() {
    return work;
  }

  public void setWork(String work) {
    this.work = work;
  }

  @Override
  public String toString() {
    return "Demo_test [name=" + name + ", orgnam=" + orgnam + ", age=" + age + ", gender=" + gender + ", hobby=" + hobby + ", desc=" + desc + ", birthday=" + birthday + ", work=" + work + "]";
  }
  
}
