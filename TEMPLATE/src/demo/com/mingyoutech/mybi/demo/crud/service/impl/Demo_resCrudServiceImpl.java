/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.crud.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.mybi.demo.crud.domain.Demo_crud;
import com.mingyoutech.mybi.demo.crud.service.Demo_resCrudService;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRes;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRole;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRoleSysResMap;

/**
 * @description:CRUD资源Serivce实现层
 * @author:hjz
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@SuppressWarnings("unchecked")
@Service
public class Demo_resCrudServiceImpl extends BaseServiceImpl<Pim_sysRoleSysResMap> implements Demo_resCrudService{

	/**
	 * @description:查询CRUD，这些角色共有的CRUD资源的checked的属性置为true
	 * @param:map 
	 * @return:List<Demo_crud> CRUD列表
	 */
	public List<Demo_crud> findResCrudList(Map<String,Object> map){
		return this.find("com.mingyoutech.mybi.demo.domain.ResCrud.findResCrudList", map);
	}
	
	/**
	 * @description:分配
	 * @param:roleList 系统角色列表
	 * @param:crudList CRUD列表
	 * @return:
	 */
	public void assignResList(List<Pim_sysRole> roleList,List<Pim_sysRes> objList) throws SQLException{
		//先删除这些角色之间共有的CRUD资源
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("restypCode", "RES_CRUD");
		map.put("roleList",roleList);
		map.put("resList",objList);
		this.update("com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRoleSysResMap.deleteSysRoleSysResMapObj", map);
		
		//给这些角色增加新的CRUD资源
		//添加CRUD资源
		Pim_sysRoleSysResMap roleRes=null;
		for(Pim_sysRole role:roleList){
			for(Pim_sysRes obj:objList){
				roleRes=new Pim_sysRoleSysResMap();
				roleRes.setRoleId(role.getId());
				roleRes.setResId(obj.getId());
				roleRes.setRestypCode("RES_CRUD");
				this.update("com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRoleSysResMap.saveSysRoleSysResMapObj", roleRes);
			}
		}
		//回收CRUD资源
		this.update("com.mingyoutech.mybi.pim.sysauth.domain.ResSysMenu.withdrawRes", "RES_CRUD");
	}
	
}
