/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.stepform.service.impl;

import org.springframework.stereotype.Service;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.mybi.demo.stepform.domain.Demo_user;
import com.mingyoutech.mybi.demo.stepform.service.Demo_stepFormService;

/**
 * @description:流程表单 Service实现层
 * @author:gzh
 * @date:2016-03-03
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@SuppressWarnings("unchecked")
@Service
public class Demo_stepFormServiceImpl extends BaseServiceImpl<Demo_user> implements
		Demo_stepFormService {
	
	/**
	 * @description:添加用户对象
	 * @param:obj 用户对象
	 * @return:
	 */
	@Override
	public void saveUserObj(Demo_user obj) {
		this.update("com.mingyoutech.mybi.demo.stepForm.domain.Demo_user.saveUserObj", obj);
	}
	
	/**
	 * @description:根据ID查询用户对象
	 * @param:id 用户ID
	 * @return:用户对象
	 */
	@Override
	public Demo_user findUserObjById(String id) {
		return (Demo_user) this.findForObject("com.mingyoutech.mybi.demo.stepForm.domain.Demo_user.findUserObjById", id);
	}
	
	/**
	 * @description:修改用户对象
	 * @param:obj 用户对象 step 步骤数
	 * @return:
	 */
	@Override
	public void updateUserObj(String step, Demo_user obj) {
		this.update("com.mingyoutech.mybi.demo.stepForm.domain.Demo_user.updateUserObj" + step, obj);
	}

}
