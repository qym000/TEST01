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
import com.mingyoutech.mybi.demo.crud.service.Demo_spresCrudService;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysRes;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;

/**
 * @description:CRUD资源(特例)Action层
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
	    		 @Result(name="assign", location="demo/crud/demo_spres-crud-assign.jsp")
	    }
)
public class Demo_spresCrudAction extends BaseAction {

	private static final long serialVersionUID = -8236915413979565912L;
	
	private String ids_user;
	private String ids_crud;
	
	@Autowired
	private Demo_spresCrudService demo_spresCrudService;
	
	/**
	 * @description:转向资源分配页面
	 * @param:
	 * @return:String 转向地址demo/crud/demo_spres-crud-assign.jsp
	 */
	public  String  toAssign(){
		return "assign";
	}
	
	/**
	 * @description:获取资源
	 * @param:
	 * @return:String 
	 */
	public  String  findSpresList(){
		//选中的用户列表
		List<Pim_sysUser> userList=new ArrayList<Pim_sysUser>();
		if(null!=ids_user && !"".equals(ids_user.trim())){
			Pim_sysUser user=null;
			for(String r:ids_user.split(",")){
				if(null!=r && !"".equals(r.trim())){
					user=new Pim_sysUser();
					user.setId(r);
					userList.add(user);
				}
			}
		}
		//获取系统菜单资源
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("restypCode", "RES_CRUD");
		map.put("userList",userList);
		map.put("authUserId",((Pim_sysUser)session.getAttribute("loginUserObj")).getId());//权限过滤使用
		map.put("authRoleId", (String)session.getAttribute("authRoleId"));//权限过滤使用
		List<Demo_crud>  objList=demo_spresCrudService.findSpresCrudList(map);
			
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
	public  String  assignSpresList(){
		//选中的用户列表
		List<Pim_sysUser> userList=new ArrayList<Pim_sysUser>();
		if(null!=ids_user && !"".equals(ids_user.trim())){
			Pim_sysUser user=null;
			for(String r:ids_user.split(",")){
				if(null!=r && !"".equals(r.trim())){
					user=new Pim_sysUser();
					user.setId(r);
					userList.add(user);
				}
			}
		}
		//菜单列表
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
			demo_spresCrudService.assignSpresList(userList, objList);
			jsonObj.put("result", "succ");
		} catch (SQLException e) {
			e.printStackTrace();
			jsonObj.put("result", "fail");
		}
		
		Struts2Utils.renderText(jsonObj.toString());
		return NONE;
	}


	public String getIds_user() {
		return ids_user;
	}

	public void setIds_user(String ids_user) {
		this.ids_user = ids_user;
	}

	public String getIds_crud() {
		return ids_crud;
	}

	public void setIds_crud(String ids_crud) {
		this.ids_crud = ids_crud;
	}

}
