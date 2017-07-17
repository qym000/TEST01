/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.crud.action;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
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

import com.mingyoutech.framework.action.BaseAction;
import com.mingyoutech.mybi.demo.crud.domain.Demo_crud;
import com.mingyoutech.mybi.demo.crud.service.Demo_resCrudService;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRes;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRole;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;

/**
 * @description:CRUD资源Action层
 * @author:hjz
 * @date:2014-05-09
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
	    		 @Result(name="assign", location="demo/crud/demo_res-crud-assign.jsp")
	    }
)
public class Demo_resCrudAction extends BaseAction {

	private static final long serialVersionUID = -8236915413979565912L;
	
	@Autowired
	private Demo_resCrudService demo_resCrudService;
	private String ids_role;
	private String ids_crud;
	
	/**
	 * @description:转向资源分配页面
	 * @param:
	 * @return:String 转向地址demo/crud/demo_res-crud-assign.jsp
	 */
	public  String  toAssign(){
		return "assign";
	}
	
	/**
	 * @description:获取资源
	 * @param:
	 * @return:String 
	 */
	public  String  findResList(){
		//选中的角色列表
		List<Pim_sysRole> roleList=new ArrayList<Pim_sysRole>();
		if(null!=ids_role && !"".equals(ids_role.trim())){
			Pim_sysRole role=null;
			for(String r:ids_role.split(",")){
				if(null!=r && !"".equals(r.trim())){
					role=new Pim_sysRole();
					role.setId(r);
					roleList.add(role);
				}
			}
		}
		//获取CRUD资源
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("restypCode", "RES_CRUD");
		map.put("roleList",roleList);
		map.put("authUserId",((Pim_sysUser)session.getAttribute("loginUserObj")).getId());//权限过滤使用
		map.put("authRoleId", (String)session.getAttribute("authRoleId"));//权限过滤使用
		List<Demo_crud>  objList=demo_resCrudService.findResCrudList(map);
			
		List<Map<String, Object>> objListTree=generateResTree(objList);
		JSONArray jsonArray = JSONArray.fromObject(objListTree);
    	Struts2Utils.renderText(jsonArray.toString());
		return NONE;
	}
	
	/**
	 * @description:生成资源树
	 * @param:
	 * @return:List<Map<String, Object>> 
	 */
  public List<Map<String, Object>> generateResTree(List<Demo_crud> objList){
    	Map<String, Object> childrenmap = null;
    	List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
    	
    	if(objList!=null && objList.size()>0){
    		for(Demo_crud obj:objList){
    			childrenmap = new HashMap<String, Object>();
				childrenmap.put("id", obj.getId());
				childrenmap.put("pId", "-1");
    			childrenmap.put("name", obj.getNam());
    			if(obj.getIsChecked()!=null && obj.getIsChecked().equals("1")){
    				childrenmap.put("checked",true);
    			}
    			childrenmap.put("open",true);
    			mapList.add(childrenmap);
    		}
    	}
    	
    	return mapList;
    }
	
	/**
	 * @description:分配资源
	 * @param:
	 * @return:String 
	 */
	public  String  assignResList(){
		//选中的角色列表
		List<Pim_sysRole> roleList=new ArrayList<Pim_sysRole>();
		if(ids_role!=null && !ids_role.trim().equals("")){
			Pim_sysRole role=null;
			for(String r:ids_role.split(",")){
				if(null !=r && !"".equals(r.trim())){
					role=new Pim_sysRole();
					role.setId(r);
					roleList.add(role);
				}
			}
		}
		//CRUD列表
		List<Pim_sysRes> objList=new ArrayList<Pim_sysRes>();
		if(ids_crud!=null && !ids_crud.trim().equals("")){
			Pim_sysRes obj=null;
			for(String r:ids_crud.split(",")){
				if(null !=r && !"".equals(r.trim())){
					obj=new Pim_sysRes();
					obj.setId(r);
					objList.add(obj);
				}
			}
		}
		//分配
		JSONObject jsonObj = new JSONObject();
		try {
			demo_resCrudService.assignResList(roleList, objList);
			jsonObj.put("result", "succ");
		} catch (SQLException e) {
			e.printStackTrace();
			jsonObj.put("result", "fail");
		}
		
		Struts2Utils.renderText(jsonObj.toString());
		return NONE;
	}

	public String getIds_role() {
		return ids_role;
	}

	public void setIds_role(String ids_role) {
		this.ids_role = ids_role;
	}

	public String getIds_crud() {
		return ids_crud;
	}

	public void setIds_crud(String ids_crud) {
		this.ids_crud = ids_crud;
	}

}
