/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.crud.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.mingyoutech.mybi.demo.crud.domain.Demo_crud;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRes;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRole;

/**
 * @description:CRUD资源Serivce接口层
 * @author:hjz
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Demo_resCrudService {

	/**
	 * @description:查询CRUD，这些角色共有的CRUD资源的checked的属性置为true
	 * @param:map 
	 * @return:List<Demo_crud> CRUD列表
	 */
	public List<Demo_crud> findResCrudList(Map<String,Object> map);
	
	/**
	 * @description:分配
	 * @param:roleList 系统角色列表
	 * @param:crudList CRUD列表
	 * @return:
	 */
	public void assignResList(List<Pim_sysRole> roleList,List<Pim_sysRes> objList) throws SQLException;
	
}
