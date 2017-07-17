/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 * 
 * 项目名称：版本管理平台
 * 创建日期：20150504
 * 修改历史：
 *    1. 创建文件by lvzhenjun, 20150504
 */
package com.mingyoutech.mybi.pim.vm.action;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.Cookie;

import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springside.modules.web.struts2.Struts2Utils;

import com.mingyoutech.appcase.SysConstant;
import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.pim.common.action.SysBaseAction;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;
import com.mingyoutech.mybi.pim.vm.domain.Vm_component;
import com.mingyoutech.mybi.pim.vm.domain.Vm_updlog;
import com.mingyoutech.mybi.pim.vm.service.Vm_versionService;
import com.mingyoutech.mybi.pim.vm.utils.ZipUtil;

/**
 * 版本Action层
 * 
 * @author june,2014-05-09
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("privilegeStack")
@ResultPath("/WEB-INF/mybi/pim/")
@Action(results = { 
    @Result(name = "manage", location = "vm/version-manage.jsp"), 
    @Result(name = "update", location = "vm/version-update-manage.jsp"),
    @Result(name = "updLogManage", location = "vm/version-updlog-manage.jsp"), 
    @Result(name = "regeidt", location = "vm/version-regeidt-manage.jsp"),
    @Result(name = "backuplog", location = "vm/version-backuplog-manage.jsp"), 
    @Result(name = "recoveryManage", location = "vm/version-recovery-manage.jsp")
    })
public class Vm_versionAction extends SysBaseAction {

  /** 序列化ID */
  private static final long serialVersionUID = -6552486533454831298L;

  /** 组件对象 */
  private Vm_component obj;

  /** 升级日志 */
  private Vm_updlog log;

  /** 注入Service */
  @Autowired
  private Vm_versionService vm_versionService;

  /** 安装包 */
  private File install_pkg;

  /** 要上传的文件类型 */
  private String install_pkgContentType;

  /** 文件名称 */
  private String install_pkgFileName;

  /**
   * 版本管理组件升级界面
   * 
   * @return Manage
   */
  public String toManage() {
    Cookie[] ck = request.getCookies();
    String workspace = null;
    for (Cookie c : ck) {
      if (c.getName().equals("workspace")) {
        workspace = c.getValue();
        request.setAttribute("workspace", workspace.replaceAll("#", "\\\\"));
        break;
      }
    }
    return MANAGE;
  }

  /**
   * 检测各组件版本
   * 
   * @param args
   * @return NONE
   */
  public String chkVersion() {
    JSONObject jsn = new JSONObject();
    try {
      List<Vm_component> list = vm_versionService.findComponentList(obj, request);
      setCookie("workspace", obj.getWorkspace().replaceAll("\\\\|/", "#"), 30 * 24 * 60 * 60);
      jsn.put(AJAX_RESULT, AJAX_SUCC);
      jsn.put("list", list);
      Struts2Utils.renderText(jsn.toString());
    } catch (Exception e) {
      e.printStackTrace();
      Struts2Utils.renderText(e.getMessage());
    }
    return NONE;
  }

  /**
   * 校验某个组件各个文件版本
   * 
   * @return NONE
   */
  public String chkFileVersion() {
    JSONObject jsn = new JSONObject();
    try {
      Map<String, String> map = vm_versionService.chkFileVersion(obj, request);
      if (map.size() == 0) {
        jsn.put(AJAX_RESULT, AJAX_SUCC);
      } else {
        jsn.put(AJAX_RESULT, AJAX_FAIL);
        jsn.put("cnt", map.size());
        jsn.put("filemap", JSONObject.fromObject(map));
      }
      Struts2Utils.renderText(jsn.toString());
    } catch (Exception e) {
      e.printStackTrace();
      Struts2Utils.renderText(e.getLocalizedMessage());
    }
    return NONE;
  }

  /**
   * 打开安装包升级界面
   * 
   * @return NONE
   */
  public String toComponentUpdateManage() {
    request.setAttribute("obj", obj);
    return UPDATE;
  }

  /**
   * 上传升级安装包
   * 
   * @return NONE
   */
  public String uploadUpdPkgFile() {
    JSONObject jsn = new JSONObject();
    obj.setWorkspace(getCookieValue("workspace").replaceAll("#", "\\\\"));
    String mybi_updpath = getSysParam("MYVM_VERSION_UPD_TMP").getPval();
    try {
      if (!this.install_pkgFileName.equals("mybi-" + obj.getCode() + "-setup.zip")) {
        throw new Exception("请选择正确的安装包：mybi-" + obj.getCode() + "-setup.zip");
      }

      String srcFilePath = mybi_updpath + "/" + this.install_pkgFileName;
      File srcFile = new File(srcFilePath);
      File oldDir = new File(mybi_updpath + "/mybi-" + obj.getCode() + "-setup");
      if (oldDir.exists()) {
        FileUtils.deleteDirectory(oldDir);
      }
      FileUtils.copyFile(this.install_pkg, srcFile);
      // 校验版本依赖
      ZipUtil.uncompress(srcFilePath, mybi_updpath + "/mybi-" + obj.getCode() + "-setup/", true);
      // 获取当前已注册的所有组件版本
      Map<String, String> versionMap = vm_versionService.getComponentVersion(obj, request);
      // 获取当前要升级版本的自身版本
      Map<String, String> selfVersionMap = vm_versionService.getUpdPkgSelfVersion(obj.getCode(), srcFilePath.replaceAll(".zip", ""));
      // 校验版本号确定是否能进行升级
      vm_versionService.chkWhetherUpdate(selfVersionMap, versionMap, obj);
      // 获取升级包依赖的版本信息
      Map<String, String> dependVersionMap = vm_versionService.getUpdpkgDependVersion(obj.getCode(), srcFilePath.replaceAll(".zip", ""));
      for (Entry entry : dependVersionMap.entrySet()) {
        if (versionMap.containsKey(entry.getKey())) { // 如果已安装的组件包含此版本依赖组件
          if (!versionMap.get(entry.getKey()).toString().equals(entry.getValue())) {
            throw new Exception(obj.getCode() + "组件升级依赖" + entry.getKey() + "-" + entry.getValue() + "，当前项目中的版本是" + entry.getKey() + "-" + versionMap.get(entry.getKey()));
          }
        } else {
          throw new Exception("当前项目缺少组件" + entry.getKey() + "-" + entry.getValue() + "不能进行升级");
        }
      }

      // 获取当前项目组件的各文件版本
      Map<String, String> origiMap = vm_versionService.getCurrComponentFileVersion(obj, request);
      // 获取升级包内的各个文件版本
      Map<String, String> newMap = vm_versionService.getUpdPkgFileVersion(obj, request, mybi_updpath);
      // 对比项目中版本和升级包差异
      Map<String, String> resultMap = vm_versionService.getDifference4Map(origiMap, newMap);
      jsn.put("resultMap", resultMap);
      jsn.put(AJAX_RESULT, AJAX_SUCC);
      Struts2Utils.renderText(jsn.toString());
    } catch (Exception e) {
      e.printStackTrace();
      jsn.put(AJAX_RESULT, e.getLocalizedMessage());
      Struts2Utils.renderText(jsn.toString());
    }
    return NONE;
  }

  /**
   * 开始进行升级
   * 
   * @return NONE
   */
  public String updVersionFile() {
    JSONObject jsn = new JSONObject();
    String mybi_updpath = getSysParam("MYVM_VERSION_UPD_TMP").getPval();
    try {
      Pim_sysUser user = (Pim_sysUser) session.getAttribute(SysConstant.SESSION_USER_DATA);
      vm_versionService.updVersionFile(obj, request, request.getParameter("ids"), user, mybi_updpath);
      jsn.put(AJAX_RESULT, AJAX_SUCC);
      Struts2Utils.renderText(jsn.toString());
    } catch (Exception e) {
      e.printStackTrace();
      Struts2Utils.renderText(e.getLocalizedMessage());
    }
    return NONE;
  }

  /**
   * 卸载版本
   * 
   * @return NONE
   */
  public String uninstall() {
    JSONObject jsn = new JSONObject();
    try {
      String basepath = obj.getWorkspace() + request.getContextPath();
      vm_versionService.uninstall(basepath, obj);
      jsn.put(AJAX_RESULT, AJAX_SUCC);
      Struts2Utils.renderText(jsn.toString());
    } catch (IOException e) {
      e.printStackTrace();
      Struts2Utils.renderText(e.getLocalizedMessage());
    }
    return NONE;
  }

  /**
   * 打开备份日志填写界面
   * 
   * @return backuplog
   */
  public String toBackupLogManage() {
    String bakpath = getSysParam("MYVM_VERSION_BACKUP").getPval();
    request.setAttribute("bakpath", bakpath);
    request.setAttribute("obj", obj);
    return "backuplog";
  }

  /**
   * 备份版本
   * 
   * @return NONE
   */
  public String bakup() {
    JSONObject jsn = new JSONObject();
    try {
      String bakpath = getSysParam("MYVM_VERSION_BACKUP").getPval();
      vm_versionService.bakup(obj, request, bakpath);
      jsn.put(AJAX_RESULT, AJAX_SUCC);
      Struts2Utils.renderText(jsn.toString());
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      Struts2Utils.renderText(e.getLocalizedMessage() != null ? e.getLocalizedMessage() : "备份失败");
    } catch (Exception e) {
      e.printStackTrace();
      Struts2Utils.renderText(e.getLocalizedMessage() != null ? e.getLocalizedMessage() : "备份失败");
    }
    return NONE;
  }

  /**
   * 版本恢复选择界面
   * 
   * @return NONE
   */
  public String toRecoveryManage() {
    String bakpath = getSysParam("MYVM_VERSION_BACKUP").getPval();
    request.setAttribute("bakpath", bakpath);
    request.setAttribute("obj", obj);
    File file = new File(bakpath + "/bakup_" + obj.getCode() + "/");
    Map<String, String> map = new HashMap<String, String>();
    if (file.exists()) {
      File[] bakFiles = file.listFiles();
      for (File bakFile : bakFiles) {
        String baklog = bakFile.getAbsolutePath() + "\\baklog.txt";
        File baklogFile = new File(baklog);
        try {
          if (baklogFile.exists()) {
            BufferedReader bf = new BufferedReader(new InputStreamReader(new FileInputStream(baklogFile), "UTF-8"));
            String line = "";
            while ((line = bf.readLine()) != null) {
              map.put(bakFile.getName(), line);
            }
          } else {
            map.put(bakFile.getName(), "没有备份日志");
          }
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }
    request.setAttribute("bakMap", JSONObject.fromObject(map).toString());
    return "recoveryManage";
  }

  /**
   * 版本恢复
   * 
   * @return NONE
   */
  public String recovery() {
    JSONObject jsn = new JSONObject();
    try {
      String bakpath = getSysParam("MYVM_VERSION_BACKUP").getPval();
      vm_versionService.recovery(obj, request, bakpath);
      jsn.put(AJAX_RESULT, AJAX_SUCC);
      Struts2Utils.renderText(jsn.toString());
    } catch (Exception e) {
      e.printStackTrace();
      Struts2Utils.renderText(e.getLocalizedMessage());
    }
    return NONE;
  }

  /**
   * 打开升级日志窗口
   * 
   * @return NONE
   */
  public String toUpdLogManage() {
    request.setAttribute("log", log);
    return "updLogManage";
  }

  /**
   * 查询组件升级日志
   * 
   * @return NONE
   */
  public String findUpdLogPager() {
    try {
      Pager<Vm_updlog> p = vm_versionService.findUpdLogPager(log, page, Integer.parseInt(getSysParam("PAGESIZE").getPval()));
      Struts2Utils.renderText(getJson4Pager(p));
    } catch (Exception e) {
      e.printStackTrace();
    }
    return NONE;
  }

  /**
   * 组件注册
   * 
   * @return NONE
   */
  public String componentRegeidt() {
    return "regeidt";
  }

  /**
   * 注册组件
   * 
   * @return NONE
   */
  public String componentRegeidtInstall() {
    JSONObject jsn = new JSONObject();
    try {
      String srcFilePath = obj.getWorkspace() + "\\" + this.install_pkgFileName;
      File srcFile = new File(srcFilePath);
      FileUtils.copyFile(this.install_pkg, srcFile);
      // 解压当前压缩包
      ZipUtil.uncompress(srcFilePath, obj.getWorkspace() + "\\" + this.install_pkgFileName.replaceAll(".zip", ""), true);
      // 获取当前项目已注册的各个组件版本
      Map<String, String> versionMap = vm_versionService.getComponentVersion(obj, request);

      // 获取升级包依赖的版本信息
      String code = this.install_pkgFileName.split("-")[1].replaceAll("web", "");
      Map<String, String> dependVersionMap = vm_versionService.getUpdpkgDependVersion(code, srcFilePath.replaceAll(".zip", ""));
      // 开始校验依赖信息
      for (Entry entry : dependVersionMap.entrySet()) {
        if (versionMap.containsKey(entry.getKey())) { // 如果已安装的组件包含此版本依赖组件
          if (!versionMap.get(entry.getKey()).toString().equals(entry.getValue())) {
            throw new Exception(code + "组件升级依赖" + entry.getKey() + "-" + entry.getValue() + "，当前项目中的版本是" + entry.getKey() + "-" + versionMap.get(entry.getKey()));
          }
        } else {
          throw new Exception("当前项目缺少组件" + entry.getKey() + "-" + entry.getValue() + "不能进行升级");
        }
      }
      // 依赖校验通过，开始进行安装
      vm_versionService.regeidtComponent(obj, request, this.install_pkgFileName);
      jsn.put(AJAX_RESULT, AJAX_SUCC);
      Struts2Utils.renderText(jsn.toString());
    } catch (Exception e) {
      e.printStackTrace();
      jsn.put(AJAX_RESULT, e.getLocalizedMessage());
      Struts2Utils.renderText(jsn.toString());
    }
    return NONE;
  }

  public File getInstall_pkg() {
    return install_pkg;
  }

  public void setInstall_pkg(File install_pkg) {
    this.install_pkg = install_pkg;
  }

  public String getInstall_pkgContentType() {
    return install_pkgContentType;
  }

  public void setInstall_pkgContentType(String install_pkgContentType) {
    this.install_pkgContentType = install_pkgContentType;
  }

  public String getInstall_pkgFileName() {
    return install_pkgFileName;
  }

  public void setInstall_pkgFileName(String install_pkgFileName) {
    this.install_pkgFileName = install_pkgFileName;
  }

  public Vm_component getObj() {
    return obj;
  }

  public void setObj(Vm_component obj) {
    this.obj = obj;
  }

  public Vm_updlog getLog() {
    return log;
  }

  public void setLog(Vm_updlog log) {
    this.log = log;
  }
}
