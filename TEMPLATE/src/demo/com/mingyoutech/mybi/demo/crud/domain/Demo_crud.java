/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.crud.domain;

import org.apache.ibatis.type.Alias;

import com.mingyoutech.framework.domain.BaseDomain;
import com.mingyoutech.framework.file.vo.ExcelVOAttribute;

/**
 * @description：CRUD Domain对象
 * @author： hjz
 * @date：2016-01-01
 * 
 * @modify content：
 * @modifier：
 * @modify date:
 */
@Alias("Demo_crud")
public class Demo_crud extends BaseDomain {

	private static final long serialVersionUID = 2155862845919529900L;
	
	//id
	private String id;
	//名称
	@ExcelVOAttribute(name = "名称", isExport = true, column = "A")
	private String nam;
	//机构
	@ExcelVOAttribute(name = "所属机构号", isExport = true, column = "B")
	private String orgidt;
	//机构名称
	@ExcelVOAttribute(name = "所属机构名称", isExport = true, column = "C")
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
	@ExcelVOAttribute(name = "备注", isExport = true, column = "D")
	private String remark;
	
	//扩展属性：
	private String isChecked;
	
	public Demo_crud(){
	}
	
	public Demo_crud(String id){
		this.id=id;
	}
	
	public Demo_crud(String id,String orgidt){
		this.id=id;
		this.orgidt=orgidt;
	}
	
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

	public String getModnam() {
		return modnam;
	}

	public void setModnam(String modnam) {
		this.modnam = modnam;
	}

	public void setModlogid(String modlogid) {
		this.modlogid = modlogid;
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

	public String getIsChecked() {
		return isChecked;
	}

	public void setIsChecked(String isChecked) {
		this.isChecked = isChecked;
	}

}
