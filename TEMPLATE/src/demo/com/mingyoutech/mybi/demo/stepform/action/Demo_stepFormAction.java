/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.stepform.action;

import java.util.UUID;

import net.sf.json.JSONObject;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.mybi.demo.stepform.domain.Demo_user;
import com.mingyoutech.mybi.demo.stepform.service.Demo_stepFormService;
import com.mingyoutech.mybi.pim.common.action.SysBaseAction;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;

/**
 * @description:流程表单 Action层
 * @author:gzh
 * @date:2016-03-03
 * 
 * @modify content:
 * @modifier:
 * @modify date:
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("privilegeStack")
@ResultPath("/WEB-INF/mybi")
@Action(
	    results={
	    	@Result(name="FORM_STEP1", location="demo/stepform/demo_stepform-step1.jsp"),
	    	@Result(name="FORM_STEP2", location="demo/stepform/demo_stepform-step2.jsp"),
	    	@Result(name="FORM_STEP3", location="demo/stepform/demo_stepform-step3.jsp"),
	    	@Result(name="FORM_STEP1_UPT", location="demo/stepform/demo_stepform-step1_upt.jsp"),
	    	@Result(name="FORM_STEP2_UPT", location="demo/stepform/demo_stepform-step2_upt.jsp"),
	    	@Result(name="FORM_STEP3_UPT", location="demo/stepform/demo_stepform-step3_upt.jsp"),
	    }
)
public class Demo_stepFormAction extends SysBaseAction {

	private static final long serialVersionUID = -4868448875899684228L;
	
	// 步骤数
	private String step;
	
	// 用户对象ID
	private String id;
	
	// 用户对象
	private Demo_user userObj;
	
	// 流程表单Service
	@Autowired
	private Demo_stepFormService demo_stepFormService;
	
	/**
	 * @description:流程表单转向控制
	 * @return:
	 */
	public String stepFormController() {
		return "FORM_STEP" + step;
	}
	
	/**
	 * @description:保存用户对象
	 * @return:
	 */
	public String saveUserObj() {
		String id = UUID.randomUUID().toString().replace("-", "");
		userObj.setId(id);
		userObj.setModuid(((Pim_sysUser)session.getAttribute("loginUserObj")).getId());
		JSONObject jsonObj = new JSONObject();
		try{
			demo_stepFormService.saveUserObj(userObj);
			jsonObj.put("result", "succ");
			jsonObj.put("callbackCondition", id);
		}catch(Exception e){
			e.printStackTrace();
			jsonObj.put("result", "fail");
		}
		Struts2Utils.renderText(jsonObj.toString());
		
		return NONE;
	}
	
	/**
	 * @description:流程表单修改转向控制
	 * @return:
	 */
	public String uptFormController() {
		Demo_user obj = demo_stepFormService.findUserObjById(id);
		request.setAttribute("obj", obj);
		request.setAttribute("step", step);
		return "FORM_STEP" + step + "_UPT";
	}
	
	/**
	 * @description:修改用户对象
	 * @return:
	 */
	public String updateUserObj() {
		userObj.setModuid(((Pim_sysUser)session.getAttribute("loginUserObj")).getId());
		JSONObject jsonObj = new JSONObject();
		try{
			demo_stepFormService.updateUserObj(step, userObj);
			jsonObj.put("result", "succ");
			jsonObj.put("callbackCondition", userObj.getId());
		}catch(Exception e){
			e.printStackTrace();
			jsonObj.put("result", "fail");
		}
		Struts2Utils.renderText(jsonObj.toString());
		
		return NONE;
	}
	
	public String getStep() {
		return step;
	}

	public void setStep(String step) {
		this.step = step;
	}

	public Demo_user getUserObj() {
		return userObj;
	}

	public void setUserObj(Demo_user userObj) {
		this.userObj = userObj;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
}
