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
import com.mingyoutech.mybi.demo.crud.service.Demo_spresCrudService;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRes;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUserSysResMap;

/**
 * @description:CRUD资源(特例)Serivce实现层
 * @author:hjz
 * @date:2014-05-09
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@SuppressWarnings("unchecked")
@Service
public class Demo_spresCrudServiceImpl extends BaseServiceImpl<Pim_sysUserSysResMap> implements Demo_spresCrudService{

	/**
	 * @description:查询CRUD，这些角色共有的CRUD资源的checked的属性置为true
	 * @param:map 
	 * @return:List<Demo_crud> CRUD列表
	 */
	public List<Demo_crud> findSpresCrudList(Map<String,Object> map){
		return this.find("com.mingyoutech.mybi.pim.sysauth.domain.SpresSysMenu.findSpresCrudList", map);
	}
	
	/**
	 * @description:分配
	 * @param:userList 系统用户列表
	 * @param:crudList CRUD列表
	 * @return:
	 */
	public void assignSpresList(List<Pim_sysUser> userList,List<Pim_sysRes> objList) throws SQLException{
		//先删除这些角色之间共有的菜单资源
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("restypCode", "RES_CRUD");
		map.put("userList",userList);
		map.put("resList",objList);
		this.update("com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUserSysResMap.deleteSysUserSysResMapObj", map);
		
		//给这些角色增加新的菜单/动作资源
		//添加菜单资源
		Pim_sysUserSysResMap userRes=null;
		for(Pim_sysUser user:userList){
			for(Pim_sysRes obj:objList){
				userRes=new Pim_sysUserSysResMap();
				userRes.setUserId(user.getId());
				userRes.setResId(obj.getId());
				userRes.setRestypCode("RES_CRUD");
				this.update("com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUserSysResMap.saveSysUserSysResMapObj", userRes);
			}
		}
		//回收菜单资源
		//this.update("com.mingyoutech.mybi.pim.sysauth.domain.ResSysMenu.withdrawRes", "RES_SYSMENU");
	}
	
	
}
