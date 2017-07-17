package com.mingyoutech.mybi.demo.myuiapi.action;

import java.io.File;
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
		@Result(name="manage", location="demo/myui/demo_myui-manage.jsp"),
		@Result(name="MYUI", location="demo/myui/demo_myui-summary.jsp"),
		@Result(name="DEMO_01", location="demo/myui/demo_myui-combo.jsp"),
		@Result(name="DEMO_02", location="demo/myui/demo_myui-combosd.jsp"),
		@Result(name="DEMO_03", location="demo/myui/demo_myui-inputbox.jsp"),
		@Result(name="DEMO_04", location="demo/myui/demo_myui-datebox.jsp"),
		@Result(name="DEMO_05", location="demo/myui/demo_myui-fileupload.jsp"),
		@Result(name="DEMO_06", location="demo/myui/demo_myui-orgselector.jsp"),
		@Result(name="DEMO_07", location="demo/myui/demo_myui-window.jsp"),
		@Result(name="DEMO_08", location="demo/myui/demo_myui-messager.jsp"),
		@Result(name="DEMO_09", location="demo/myui/demo_myui-datagridsort.jsp"),
		@Result(name="DEMO_10", location="demo/myui/demo_myui-layout.jsp"),
		@Result(name="DEMO_11", location="demo/myui/demo_myui-popselector.jsp"),
		@Result(name="DEMO_12", location="demo/myui/demo_myui-multinput.jsp"),
		@Result(name="DEMO_13", location="demo/myui/demo_myui-multinput2.jsp"),
		@Result(name="DEMO_14", location="demo/myui/demo_myui-cycle.jsp"),
		@Result(name="DEMO_15", location="demo/myui/demo_myui-tooltip.jsp"),
		@Result(name="DEMO_16", location="demo/myui/demo_myui-msgpusher.jsp")
	}
)
public class Demo_myuiAction extends SysBaseAction{

	private static final long serialVersionUID = -2246660108519379608L;
	
	private static HashMap<String,Object> demoMap;
	
	private String id;
	
	private File my;
	private String myFileName;
	private String myContentType;
	
	static {
		demoMap = new LinkedHashMap<String,Object>();
		demoMap.put("DEMO_01", "combo下拉选择控件");
		demoMap.put("DEMO_02", "comboSD自定义下拉选择控件");
		demoMap.put("DEMO_03", "inputbox多功能输入控件");
		demoMap.put("DEMO_04", "datebox日期控件");
		demoMap.put("DEMO_05", "fileupload文件上传控件");
		demoMap.put("DEMO_06", "orgselector机构控件");
		demoMap.put("DEMO_07", "window窗口控件");
		demoMap.put("DEMO_08", "messager弹出提示控件");
		demoMap.put("DEMO_09", "datagrid排序控件");
		demoMap.put("DEMO_10", "layout布局器");
		demoMap.put("DEMO_11", "popselector弹出选择控件");
		demoMap.put("DEMO_12", "multinput自增行多值输入控件");
		demoMap.put("DEMO_13", "multinput2弹出层多值输入控件");
		demoMap.put("DEMO_14", "cycle周期控件");
		demoMap.put("DEMO_15", "tooltip悬浮提示控件");
		demoMap.put("DEMO_16", "msgpusher右下角弹出信息控件");
	}
	
	/**
	 * 获取Demo选择树
	 * @return NONE
	 */
	public String getDemoTree() {
		List<Map<String,Object>> demoTreeList = new ArrayList<Map<String,Object>>();
		Map<String,Object> map = null;
		map = new HashMap<String,Object>();
		map.put("id", "MYUI");
		map.put("name", "MYUI控件");
		map.put("pId", "-1");
		map.put("open", true);
		demoTreeList.add(map);
		for (Map.Entry<String, Object> entry : demoMap.entrySet()) {
			map = new HashMap<String,Object>();
			map.put("id", entry.getKey());
			map.put("name", entry.getValue());
			map.put("pId", "MYUI");
			demoTreeList.add(map);
		}
		Struts2Utils.renderText(JSONArray.fromObject(demoTreeList).toString());
		return NONE;
	}
	
	/**
	 * 跳转到相应控件的api
	 * @return NONEs
	 */
	public String toApiContent() {
		return id;
	}
	
	/**
	 * 上传文件demo
	 * @return NONEs
	 */
	public String uploadMyFile() {
		System.out.println(my.getPath());
		System.out.println(myFileName);
		System.out.println(myContentType);
		return NONE;
	}
	
	/**
	 * 获取popselector远程数据
	 * @return 无转向
	 */
	public String genPopselectorData() {
    List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
    Map<String, Object> map = new HashMap<String, Object>();
    map.put("name", "国内产品");
    map.put("nocheck", true);
    map.put("id", "C");
    map.put("pId", null);
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "国外产品");
    map.put("id", "I");
    map.put("pId", null);
    map.put("nocheck", true);
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "诺基亚");
    map.put("id", "01");
    map.put("pId", "I");
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "小米");
    map.put("id", "02");
    map.put("pId", "C");
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "苹果");
    map.put("id", "03");
    map.put("pId", "I");
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "华为");
    map.put("id", "04");
    map.put("pId", "C");
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "魅族");
    map.put("id", "05");
    map.put("pId", "C");
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "OPPO");
    map.put("id", "06");
    map.put("pId", "C");
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "HTC");
    map.put("id", "07");
    map.put("pId", "I");
    mapList.add(map);
    map = new HashMap<String,Object>();
    map.put("name", "三星");
    map.put("id", "08");
    map.put("pId", "I");
    mapList.add(map);
    Struts2Utils.renderText(JSONArray.fromObject(mapList).toString());
    return NONE;
  }

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public File getMy() {
		return my;
	}

	public void setMy(File my) {
		this.my = my;
	}

	public String getMyFileName() {
		return myFileName;
	}

	public void setMyFileName(String myFileName) {
		this.myFileName = myFileName;
	}

	public String getMyContentType() {
		return myContentType;
	}

	public void setMyContentType(String myContentType) {
		this.myContentType = myContentType;
	}
	
}
