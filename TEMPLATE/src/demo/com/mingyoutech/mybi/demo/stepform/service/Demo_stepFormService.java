/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.stepform.service;

import com.mingyoutech.mybi.demo.stepform.domain.Demo_user;

/**
 * @description:流程表单 Service接口层
 * @author:gzh
 * @date:2016-03-03
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
public interface Demo_stepFormService {
	
	/**
	 * @description:添加用户对象
	 * @param:obj 用户对象
	 * @return:
	 */
	public void saveUserObj(Demo_user obj);
	
	/**
	 * @description:根据ID查询用户对象
	 * @param:id 用户ID
	 * @return:用户对象
	 */
	public Demo_user findUserObjById(String id);
	
	/**
	 * @description:修改用户对象
	 * @param:obj 用户对象 step 步骤数
	 * @return:
	 */
	public void updateUserObj(String step, Demo_user obj);
	
}
