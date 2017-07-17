/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.crud.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.demo.crud.domain.Demo_crud;
import com.mingyoutech.mybi.demo.crud.service.Demo_crudService;
import com.mingyoutech.mybi.pim.sysauth.service.Pim_resService;
import com.mingyoutech.mybi.pim.sysauth.service.Pim_spresService;

/**
 * @description:CRUD Service实现层
 * @author:hjz
 * @date:2016-01-01
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@SuppressWarnings("unchecked")
@Service
public class Demo_crudServiceImpl extends BaseServiceImpl<Demo_crud> implements Demo_crudService{
	@Autowired
	private Pim_resService pim_resService;
	@Autowired 
	private Pim_spresService pim_spresService;
	/**
	 * @description:系统初始调用(服务启动时)时更新信息
	 * 				更新内容：更新最后修改日期为当前时间
	 * @param:
	 * @return:
	 */
	public void updateOrgidtForSysInitCall(){
		this.update("com.mingyoutech.mybi.demo.crud.domain.Demo_crud.updateOrgidtForSysInitCall", null);
	}
	
	/**
	 * @description:分页查询CRUD
	 * @param:obj CRUD对象
	 * @param:currentpage 当前页
	 * @param:limitpage 每页显示记录数
	 * @return:Pager<Demo_crud> CRUD分页对象
	 */
	public Pager<Demo_crud> findCrudPager(Demo_crud obj, int currentpage, int limitpage){
		return this.pagedQuery("com.mingyoutech.mybi.demo.crud.domain.Demo_crud.findCrudPager", obj, currentpage, limitpage);
	}
	
    /**
     * @description:查询所有CRUD列表数量
     * @param:obj
     * @return:int 数量
     */
    public int findCrudCount(Demo_crud obj){
    	return  (Integer) this.findForObject("com.mingyoutech.mybi.demo.crud.domain.Demo_crud.findCrudPagerCount", obj);
    }
	
	/**
     * @description:查询所有CRUD列表
     * @param:obj
     * @return:List<Demo_crud> CRUD列表
     */
    public List<Demo_crud> findCrudList(Demo_crud obj){
        return this.find("com.mingyoutech.mybi.demo.crud.domain.Demo_crud.findCrudList", obj);
    }
    
    /**
	 * @description:根据某属性查询CRUD对象:根据ID,nam
	 * @param:map 其key值可以是CRUD属性中的id,nam
	 * @return:Demo_crud CRUD对象
	 */
	public Demo_crud findCrudObj(Map<String,String> map){
		return  (Demo_crud) this.findForObject("com.mingyoutech.mybi.demo.crud.domain.Demo_crud.findCrudObj", map);
	}
    
	/**
	 * @description:添加CRUD
	 * @param:obj CRUD对象
	 * @return:
	 */
	public void saveCrudObj(Demo_crud obj){
		//添加CRUD对象
		this.update("com.mingyoutech.mybi.demo.crud.domain.Demo_crud.saveCrudObj", obj);
		//增加该用户对该资源的特例
		pim_spresService.assignSpres(obj.getModuid(),"RES_CRUD",obj.getId());
	}
	
	/**
	 * @description:修改CRUD
	 * @param:obj CRUD对象
	 * @return:
	 */
	public void updateCrudObj(Demo_crud obj){
		this.update("com.mingyoutech.mybi.demo.crud.domain.Demo_crud.updateCrudObj", obj);
	}
	
	/**
	 * @description:删除CRUD
	 * @param:map
	 * @return:
	 */
	public void deleteCrudList(Map<String,Object> map){
		//删除CRUD对象
		this.update("com.mingyoutech.mybi.demo.crud.domain.Demo_crud.deleteCrudList", map);
		
		//删除资源
		List<Demo_crud> objList=(List<Demo_crud>)map.get("objList");
		if(objList!=null && objList.size()>0){
			for(Demo_crud obj:objList){
				pim_spresService. deleteSpres("RES_CRUD",obj.getId());
				pim_resService. deleteSpres("RES_CRUD",obj.getId());
			}
		}

	}
	
}
