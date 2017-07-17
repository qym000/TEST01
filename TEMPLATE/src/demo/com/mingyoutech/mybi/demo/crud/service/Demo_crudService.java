/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.crud.service;

import java.util.List;
import java.util.Map;

import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.demo.crud.domain.Demo_crud;

/**
 * @description:CRUD Service接口层
 * @author:hjz
 * @date:2016-01-01
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Demo_crudService {

	/**
	 * @description:系统初始调用(服务启动时)时更新信息
	 * 				更新内容：更新最后修改日期为当前时间
	 * @param:
	 * @return:
	 */
	public void updateOrgidtForSysInitCall();
	
	/**
	 * @description:分页查询CRUD
	 * @param:obj CRUD对象
	 * @param:currentpage 当前页
	 * @param:limitpage 每页显示记录数
	 * @return:Pager<Demo_crud> CRUD分页对象
	 */
	public Pager<Demo_crud> findCrudPager(Demo_crud obj, int currentpage, int limitpage);
    
    /**
     * @description:查询所有CRUD列表数量
     * @param:obj
     * @return:int 数量
     */
    public int findCrudCount(Demo_crud obj);
    
    /**
     * @description:查询所有CRUD列表
     * @param:obj
     * @return:List<Demo_crud> CRUD列表
     */
    public List<Demo_crud> findCrudList(Demo_crud obj);
	
	/**
	 * @description:根据某属性查询CRUD对象:根据ID,nam
	 * @param:map 其key值可以是CRUD属性中的id,nam
	 * @return:Demo_crud CRUD对象
	 */
	public Demo_crud findCrudObj(Map<String,String> map);
    
	/**
	 * @description:添加CRUD
	 * @param:obj CRUD对象
	 * @return:
	 */
	public void saveCrudObj(Demo_crud obj);
	
	/**
	 * @description:修改CRUD
	 * @param:obj CRUD对象
	 * @return:
	 */
	public void updateCrudObj(Demo_crud obj);
	
	/**
	 * @description:删除CRUD
	 * @param:map
	 * @return:
	 */
	public void deleteCrudList(Map<String,Object> map);
	
}
