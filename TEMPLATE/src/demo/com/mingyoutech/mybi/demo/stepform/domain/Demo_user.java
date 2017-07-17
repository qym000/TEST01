/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.stepform.domain;

import org.apache.ibatis.type.Alias;

import com.mingyoutech.framework.domain.BaseDomain;

/**
 * @description：DEMO_USER Domain对象
 * @author： gzh
 * @date：2016-03-03
 * 
 * @modify content：
 * @modifier：
 * @modify date:
 */
@Alias("Demo_user")
public class Demo_user extends BaseDomain {

	private static final long serialVersionUID = -2928816663401235280L;
	
	// ID
	private String id;
	//名称
	private String nam;
	//机构
	private String orgidt;
	//机构名称
	private String orgnam;
	//最后修改人id
	private String moduid;
	//最后修改人登录编号
	private String modlogid;
	//最后修改人名称
	private String modnam;
	//最后修改日期
	private String modate;
	//备注
	private String remark;
	//电话
	private String phoneNum;
	//地址
	private String address;
	//职位
	private String position;
	//生日
	private String birthday;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNam() {
		return nam;
	}
	public void setNam(String nam) {
		this.nam = nam;
	}
	public String getOrgidt() {
		return orgidt;
	}
	public void setOrgidt(String orgidt) {
		this.orgidt = orgidt;
	}
	public String getOrgnam() {
		return orgnam;
	}
	public void setOrgnam(String orgnam) {
		this.orgnam = orgnam;
	}
	public String getModuid() {
		return moduid;
	}
	public void setModuid(String moduid) {
		this.moduid = moduid;
	}
	public String getModlogid() {
		return modlogid;
	}
	public void setModlogid(String modlogid) {
		this.modlogid = modlogid;
	}
	public String getModnam() {
		return modnam;
	}
	public void setModnam(String modnam) {
		this.modnam = modnam;
	}
	public String getModate() {
		return modate;
	}
	public void setModate(String modate) {
		this.modate = modate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getPhoneNum() {
		return phoneNum;
	}
	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getBirthday() {
		return birthday;
	}
	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	
}
