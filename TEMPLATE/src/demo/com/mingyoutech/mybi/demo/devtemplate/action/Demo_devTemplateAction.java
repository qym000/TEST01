package com.mingyoutech.mybi.demo.devtemplate.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.mybi.pim.common.action.SysBaseAction;

/**
 * @description:MYUI控件Demo Action层
 * @author:gzh
 * @date:2015-12-30
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
		@Result(name="manage", location="demo/devtemplate/demo_devtemplate-manage.jsp"),
		@Result(name="DEMO_01", location="demo/devtemplate/demo_devtemplate-datagrid.jsp"),
		@Result(name="DEMO_02", location="demo/devtemplate/demo_devtemplate-form.jsp"),
		@Result(name="DEMO_03", location="demo/devtemplate/demo_devtemplate-stepform.jsp"),
		@Result(name="DEMO_04", location="demo/devtemplate/demo_devtemplate-stepformupt.jsp")
	}
)
public class Demo_devTemplateAction extends SysBaseAction{

	private static final long serialVersionUID = -2877589155629636391L;

	private static HashMap<String,Object> demoMap;
	
	private String id;
	
	static {
		demoMap = new LinkedHashMap<String,Object>();
		demoMap.put("DEMO_01", "数据列表开发模板");
		demoMap.put("DEMO_02", "普通表单开发模板");
		demoMap.put("DEMO_03", "流程表单开发模板");
		demoMap.put("DEMO_04", "流程表单的修改");
	}
	
	/**
	 * 获取Demo选择树
	 * @return NONE
	 */
	public String getDemoTree() {
		List<Map<String,Object>> demoTreeList = new ArrayList<Map<String,Object>>();
		Map<String,Object> map = null;
		for (Map.Entry<String, Object> entry : demoMap.entrySet()) {
			map = new HashMap<String,Object>();
			map.put("id", entry.getKey());
			map.put("name", entry.getValue());
			map.put("pId", "-1");
			demoTreeList.add(map);
		}
		Struts2Utils.renderText(JSONArray.fromObject(demoTreeList).toString());
		return NONE;
	}
	
	/**
	 * 跳转到相应模板内容
	 * @return NONE
	 */
	public String toContent() {
		return id;
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
}
