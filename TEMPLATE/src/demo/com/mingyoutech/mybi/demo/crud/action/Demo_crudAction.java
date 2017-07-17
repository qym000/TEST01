/*
 * Copyright (c) MINGYOUTECH Co. Ltd.
 */
package com.mingyoutech.mybi.demo.crud.action;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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

import com.mingyoutech.framework.file.impl.ExcelFileExportImpl;
import com.mingyoutech.framework.util.DateUtil;
import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.demo.crud.domain.Demo_crud;
import com.mingyoutech.mybi.demo.crud.domain.Demo_test;
import com.mingyoutech.mybi.demo.crud.service.Demo_crudService;
import com.mingyoutech.mybi.pim.common.action.SysBaseAction;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;

/**
 * @description:CRUD Action层
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
@Action(results = {
    @Result(name = "manage", location = "demo/crud/demo_crud-manage.jsp"),
    @Result(name = "input", location = "demo/crud/demo_crud-input.jsp"),
    @Result(name = "update", location = "demo/crud/demo_crud-update.jsp"),
    @Result(name = "detail", location = "demo/crud/demo_crud-detail.jsp"),
    @Result(name = "exportCrudList", type = "stream", params = { "contentType",
        "application/octet-stream;charset=iso-8859-1", "inputName",
        "crudInputStream", "contentDisposition",
        "attachment;filename=${exportCrudFileName}", "bufferSize", "2048" }) })
public class Demo_crudAction extends SysBaseAction {

  private static final long serialVersionUID = -6552486533454831298L;

  private Demo_test testObj;

  // CRUD对象
  private Demo_crud obj;

  // id
  private String id;
  // 名称
  private String nam;
  // ID（多个ID逗号分隔）
  private String ids_crud;

  @Autowired
  private Demo_crudService demo_crudService;

  /**
   * @description:转向CRUD管理页面
   * @param:
   * @return:String 转向地址demo/crud/demo_crud-manage.jsp
   */
  public String toManage() {
    return MANAGE;
  }

  /**
   * @description:分页查询CRUD
   * @param:
   * @return:
   */
  public String findCrudPager() {
    obj.setAuth_userid(((Pim_sysUser) session.getAttribute("loginUserObj"))
        .getId());// 权限过滤使用
    obj.setAuth_roleid((String) session.getAttribute("authRoleId"));// 权限过滤使用
    obj.setOrderBy("".equals(sort) ? null : sort, "".equals(order) ? null
        : order);// 表头排序
    Pager<Demo_crud> p = demo_crudService.findCrudPager(obj, page,
        Integer.parseInt(getSysParam("PAGESIZE").getPval()));
    Struts2Utils.renderText(getJson4Pager(p));

    return NONE;
  }

  /**
   * @description:查询CRUD对象
   * @param:
   * @return:
   */
  public String findCrudObjById() {
    Map<String, String> map = new HashMap<String, String>();
    map.put("id", obj.getId());
    obj = demo_crudService.findCrudObj(map);
    JSONObject jsonObj = new JSONObject();
    jsonObj.put("obj", obj);
    Struts2Utils.renderText(jsonObj.toString());

    return NONE;
  }

  /**
   * @description:查询CRUD nam是否唯一；添加、修改时通用
   * @param:
   * @return:true表示唯一，false表示不唯一
   * @throws UnsupportedEncodingException
   */
  public String isCrudNamUnique() throws UnsupportedEncodingException {

    // 如果nam为空则直接返回false
    if (nam == null || nam.trim().equals("")) {
      Struts2Utils.renderText("false");
      return NONE;
    }

    String nam_tmp = request.getParameter("nam_tmp");

    // 添加时，如果nam不为空；修改时，如果nam不为空，nam_tmp不为空，且nam与nam_tmp不相同，则进一步查询数据库进行判断
    if (((nam_tmp == null || nam_tmp.trim().equals("")) && (nam != null && !nam
        .trim().equals("")))
        || (nam != null && nam_tmp != null && !nam.equals("")
            && !nam_tmp.equals("") && !nam.equals(nam_tmp))) {
      Map<String, String> map = new HashMap<String, String>();
      map.put("nam", nam);

      // 如果查询到对象，则返回false，表示nam不唯一；反之，表示唯一
      if (demo_crudService.findCrudObj(map) != null) {
        Struts2Utils.renderText("false");
      } else {
        Struts2Utils.renderText("true");
      }
    } else {
      Struts2Utils.renderText("true");
    }

    return NONE;
  }

  /**
   * @description:转向CRUD添加页面
   * @param:
   * @return:String 转向地址demo/crud/demo_crud-input.jsp
   */
  public String toCrudObjInput() {
    return INPUT;
  }

  /**
   * @description:添加CRUD
   * @param:
   * @return:
   */
  public String saveCrudObj() {
    String id = UUID.randomUUID().toString().replace("-", "");
    obj.setId(id);
    obj.setModuid(((Pim_sysUser) session.getAttribute("loginUserObj")).getId());
    JSONObject jsonObj = new JSONObject();
    try {
      demo_crudService.saveCrudObj(obj);
      jsonObj.put("result", "succ");
      jsonObj.put("callbackCondition", id);
    } catch (Exception e) {
      e.printStackTrace();
      jsonObj.put("result", "fail");
    }
    Struts2Utils.renderText(jsonObj.toString());

    return NONE;
  }

  /**
   * @description:转向CRUD修改页面
   * @param:
   * @return:String 转向地址demo/crud/demo_crud-update.jsp
   */
  public String toCrudObjUpdate() {
    Map<String, String> map = new HashMap<String, String>();
    map.put("id", id);
    Demo_crud obj = demo_crudService.findCrudObj(map);
    request.setAttribute("obj", obj);

    return UPDATE;
  }

  /**
   * @description:修改CRUD
   * @param:
   * @return:
   */
  public String updateCrudObj() {
    JSONObject jsonObj = new JSONObject();
    try {
      demo_crudService.updateCrudObj(obj);
      jsonObj.put("result", "succ");
      jsonObj.put("callbackCondition", obj.getId());
    } catch (Exception e) {
      e.printStackTrace();
      jsonObj.put("result", "fail");
    }
    Struts2Utils.renderText(jsonObj.toString());

    return NONE;
  }

  /**
   * @description:删除多个CRUD
   * @param:
   * @return:
   */
  public String deleteCrudList() {
    List<Demo_crud> objList = new ArrayList<Demo_crud>();
    if (ids_crud != null && !ids_crud.trim().equals("")) {
      for (String r : ids_crud.split(",")) {
        objList.add(new Demo_crud(r));
      }
    }

    JSONObject jsonObj = new JSONObject();
    try {
      Map<String, Object> map = new HashMap<String, Object>();
      map.put("objList", objList);
      demo_crudService.deleteCrudList(map);
      jsonObj.put("result", "succ");
    } catch (Exception e) {
      e.printStackTrace();
      jsonObj.put("result", "fail");
    }
    Struts2Utils.renderText(jsonObj.toString());

    return NONE;
  }

  /**
   * @description:转向CRUD详情页面
   * @param:
   * @return:String 转向地址demo/crud/demo_crud-detail.jsp
   */
  public String toCrudObjDetail() {
    Map<String, String> map = new HashMap<String, String>();
    map.put("id", id);
    Demo_crud obj = demo_crudService.findCrudObj(map);
    request.setAttribute("obj", obj);

    appendLocation("详情", "detail", "demo_crud!toCrudObjDetail.action?id=" + id);

    return "detail";
  }

  /**
   * @description:查询CRUD数量：导出时使用
   * @param:
   * @return:
   */
  public String findCrudCount() {
    Demo_crud obj = new Demo_crud();
    obj.setAuth_userid(((Pim_sysUser) session.getAttribute("loginUserObj"))
        .getId());// 权限过滤使用
    obj.setAuth_roleid((String) session.getAttribute("authRoleId"));// 权限过滤使用
    int count = demo_crudService.findCrudCount(obj);
    JSONObject jsonObj = new JSONObject();
    if (count > getExportMostRecord(exportFileType)) {
      jsonObj.put("exportStatus", "overrun");
    } else {
      jsonObj.put("exportStatus", "ready");
    }
    Struts2Utils.renderText(jsonObj.toString());

    return NONE;
  }

  /**
   * @description:导出Crud列表:入口
   * @param:
   * @return NONE
   */
  public String exportCrudList() {
    return "exportCrudList";
  }

  /**
   * @description:导出系统用户列表:输入流
   * @param:
   * @return InputStream 输入流
   */
  @SuppressWarnings({ "unchecked", "rawtypes" })
  public InputStream getCrudInputStream() {
    session.setAttribute("exportStatus", "exporting");
    InputStream inputStream = null;
    try {
      ExcelFileExportImpl excelExport = new ExcelFileExportImpl(Demo_crud.class);

      // 查询CRUD列表
      Demo_crud obj = new Demo_crud();
      obj.setAuth_userid(((Pim_sysUser) session.getAttribute("loginUserObj"))
          .getId());// 权限过滤使用
      obj.setAuth_roleid((String) session.getAttribute("authRoleId"));// 权限过滤使用
      obj.setOrderBy("".equals(sort) ? null : sort, "".equals(order) ? null
          : order);// 表头排序
      List<Demo_crud> objList = demo_crudService.findCrudList(obj);

      StringBuffer bf = new StringBuffer();
      bf.append("nam:align#left:name#" + getText("crud_nam"));
      bf.append(",");
      bf.append("orgidt:align#center:name#" + getText("crud_orgidt"));
      bf.append(",");
      bf.append("orgnam:align#center:name#" + getText("crud_orgnam"));
      bf.append(",");
      bf.append("remark:align#center:name#" + getText("crud_remark"));

      excelExport.setCustom_col(bf.toString());
      // 如果国际化用中文
      if (((String) session.getAttribute("i18nDefault")).equals("zh")) {
        // 导出
        inputStream = excelExport.exportFile(objList,
            getExportFileName_suffix(exportFileType), "Crud列表");
        // 如果国际化是英文
      } else {
        // 导出
        inputStream = excelExport.exportFile(objList,
            getExportFileName_suffix(exportFileType), "crud list");
      }
    } catch (Exception e) {
      session.setAttribute("exportStatus", "exception");
      e.printStackTrace();
    }
    session.setAttribute("exportStatus", "exported");
    return inputStream;
  }

  /**
   * @description:导出系统用户列表:文件名
   * @param:
   * @return NONE
   */
  public String getExportCrudFileName() {
    String downloadFileName = null;
    if (((String) session.getAttribute("i18nDefault")).equals("en")) {
      downloadFileName = "Crud"
          + DateUtil.getSysDateStringByDateFormat("yyyyMMddHHmmss") + "."
          + getExportFileName_suffix(exportFileType);
    } else {
      downloadFileName = "Crud"
          + DateUtil.getSysDateStringByDateFormat("yyyyMMddHHmmss") + "."
          + getExportFileName_suffix(exportFileType);
    }

    try {
      downloadFileName = new String(downloadFileName.getBytes("gbk"),
          "ISO8859-1");
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
      return "Crud" + DateUtil.getSysDateStringByDateFormat("yyyyMMddHHmmss")
          + "." + getExportFileName_suffix(exportFileType);
    }
    return downloadFileName;
  }

  public String formSubmit() {
    JSONObject jsonObj = new JSONObject();
    System.out.println(testObj.toString());
    System.out.println(id);
    jsonObj.put("result", "succ");
    Struts2Utils.renderText(jsonObj.toString());
    return NONE;
  }

  public String checkName() {
    if (testObj.getName().equals("333")) {
      Struts2Utils.renderText("1");
    } else {
      Struts2Utils.renderText("0");
    }
    return NONE;
  }

  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public String getNam() {
    return nam;
  }

  public void setNam(String nam) {
    this.nam = nam;
  }

  public String getIds_crud() {
    return ids_crud;
  }

  public void setIds_crud(String ids_crud) {
    this.ids_crud = ids_crud;
  }

  public Demo_crud getObj() {
    return obj;
  }

  public void setObj(Demo_crud obj) {
    this.obj = obj;
  }

  public Demo_test getTestObj() {
    return testObj;
  }

  public void setTestObj(Demo_test testObj) {
    this.testObj = testObj;
  }

}