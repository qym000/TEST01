/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 * 
 * 项目名称：版本管理平台
 * 创建日期：20150504
 * 修改历史：
 *    1. 创建文件by lvzhenjun, 20150504
 */
package com.mingyoutech.mybi.pim.vm.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mingyoutech.framework.service.impl.BaseServiceImpl;
import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.framework.utils.DateUtil;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;
import com.mingyoutech.mybi.pim.vm.domain.Vm_component;
import com.mingyoutech.mybi.pim.vm.domain.Vm_updlog;
import com.mingyoutech.mybi.pim.vm.service.Vm_versionService;
import com.mingyoutech.mybi.pim.vm.utils.FileMD5Util;
import com.mingyoutech.mybi.pim.vm.utils.TemplateConfUtil;

/**
 * 版本升级service实现层
 * 
 * @author june,2014-05-09
 */
@SuppressWarnings({ "unchecked", "rawtypes" })
@Service
@Transactional
public class Vm_versionServiceImpl extends BaseServiceImpl implements Vm_versionService {

  /** 日志 */
  private final Logger logger = Logger.getLogger("");

  /**
   * 查询所有组件清单
   * 
   * @param request
   *          HttpServletRequet
   * @param obj
   *          版本对象
   * @return List<Vm_component> 已安装组件清单
   * @throws Exception
   *           Exception
   */
  public List<Vm_component> findComponentList(Vm_component obj, HttpServletRequest request) throws Exception {
    String versionDirPath = obj.getWorkspace() + "\\" + request.getContextPath() + "\\WebRoot\\META-INF\\version";
    List<Vm_component> vmList = new ArrayList<Vm_component>();
    List<String> list = new ArrayList<String>();
    getFileList(versionDirPath, list, "selfversion");
    BufferedReader bf = null;
    if (list != null && list.size() > 0) {
      for (String path : list) {
        Vm_component vm_component = new Vm_component();
        try {
          File versionFile = new File(path);
          if (versionFile.exists()) {
            bf = new BufferedReader(new InputStreamReader(new FileInputStream(versionFile), "UTF-8"));
            String line = "";
            while ((line = bf.readLine()) != null) {
              if (!"".equals(line.trim())) {
                String[] arr = line.split("=");
                vm_component.setId(arr[0]);
                vm_component.setCode(arr[0]);
                vm_component.setName(arr[1]);
                vm_component.setVersion(arr[2]);
              }
            }
            vmList.add(vm_component);
            bf.close();
          } else {
            throw new Exception("文件不存在" + path);
          }
        } catch (Exception e) {
          throw new Exception(e);
        } finally {
          try {
            if (bf != null) {
              bf.close();
            }
          } catch (IOException e) {
            throw new Exception(e);
          }
        }
      }
    }
    return vmList;
  }

  /**
   * 校验各个文件版本
   * 
   * @param obj
   *          组件版本对象
   * @param request
   *          HttpServletRequest
   * @return Map<String, String> 返回版本不一致的文件清单
   * @throws Exception
   *           Exception
   */
  public Map<String, String> chkFileVersion(Vm_component obj, HttpServletRequest request) throws Exception {
    String localpath = obj.getWorkspace() + "\\" + request.getContextPath();
    String versionDirPath = localpath + "\\WebRoot\\META-INF\\version";
    String versionFile = versionDirPath + "\\" + obj.getCode() + "\\version";
    Map<String, String> map = new HashMap<String, String>();
    BufferedReader bf = null;
    try {
      if (!new File(versionFile).exists()) {
        throw new Exception("版本文件不存在");
      }

      if (obj.getCode().equals("template")) {
        bf = new BufferedReader(new InputStreamReader(new FileInputStream(versionFile), "UTF-8"));
        String line = "";
        String localfile = "";
        while ((line = bf.readLine()) != null) {
          if (!"".equals(line.trim())) {
            String[] linearr = line.split("=");
            String file = linearr[0];
            String md5 = linearr[1];
            localfile = localpath + "\\" + file;
            if (!FileMD5Util.getMD5(new File(localfile)).equals(md5)) {
              map.put(file.replaceAll("\\\\|/", "\\\\"), localfile.substring(localfile.indexOf(request.getContextPath().substring(1))));
            }
          }
        }
        bf.close();
      } else {
        bf = new BufferedReader(new InputStreamReader(new FileInputStream(versionFile), "UTF-8"));
        String line = "";
        while ((line = bf.readLine()) != null) {
          if (!"".equals(line.trim())) {
            String[] linearr = line.split("=");
            String file = linearr[0];
            String md5 = linearr[1];
            String localfile = "";
            if (file.indexOf(obj.getCode() + "/themes") > -1) { // 主題
              localfile = localpath + "\\WebRoot\\mybi\\" + obj.getCode() + file.replaceAll(obj.getCode() + "/themes", "");
            } else if (line.indexOf(obj.getCode() + "/jsp") > -1) { // 頁面
              localfile = localpath + "\\WebRoot\\WEB-INF\\mybi\\" + obj.getCode() + file.replaceAll(obj.getCode() + "/jsp", "");
            } else if (line.indexOf(obj.getCode() + "/lib") > -1) { // jar包
              localfile = localpath + "\\WebRoot\\WEB-INF\\lib\\mybi\\" + obj.getCode() + file.replaceAll(obj.getCode() + "/lib", "");
            } else {
              continue;
            }
  
            if (!FileMD5Util.getMD5(new File(localfile)).equals(md5)) {
              map.put(file.replaceAll("\\\\|/", "\\\\"), localfile.substring(localfile.indexOf(request.getContextPath().substring(1))));
            }
          }
        }
        bf.close();
      }
    } catch (Exception e) {
      throw new Exception(e);
    } finally {
      if (bf != null) {
        try {
          bf.close();
        } catch (IOException e) {
          throw new Exception(e);
        }
      }
    }
    return map;
  }

  /**
   * 获取各个组件的版本
   * 
   * @param obj
   *          版本对象
   * @param request
   *          HttpServletRequest
   * @return 组件版本信息
   * @throws Exception
   *           Exception
   */
  public Map<String, String> getComponentVersion(Vm_component obj, HttpServletRequest request) throws Exception {
    String versionDirPath = obj.getWorkspace() + request.getContextPath() + "\\WebRoot\\META-INF\\version\\";
    BufferedReader bf = null;
    Map<String, String> versionMap = new HashMap<String, String>();
    try {
      File file = new File(obj.getWorkspace());
      if (file.exists()) {
        List<Vm_component> list = this.findComponentList(obj, request);
        for (Vm_component dir : list) {
          if (dir.getCode().equals("myetl")) {
            continue;
          }

          File versionFile = new File(versionDirPath + dir.getCode() + "\\selfversion");
          if (!versionFile.exists()) {
            versionMap.put(dir.getCode(), "未安装");
            continue;
          }
          bf = new BufferedReader(new InputStreamReader(new FileInputStream(versionFile), "UTF-8"));
          String line = "";
          while ((line = bf.readLine()) != null) {
            versionMap.put(dir.getCode(), line.split("=")[2]);
          }
          bf.close();
        }
      } else {
        throw new Exception(obj.getWorkspace() + "工作空间不存在");
      }
    } catch (FileNotFoundException e) {
      throw new Exception(e);
    } catch (IOException e) {
      throw new Exception(e);
    } finally {
      try {
        if (bf != null) {
          bf.close();
        }
      } catch (Exception e) {
        throw new Exception(e);
      }
    }
    return versionMap;
  }

  /**
   * 获取升级版依赖版本
   * 
   * @param key
   *          组件标识
   * @param path
   *          升级包路径
   * @return 依赖组件版本信息
   * @throws Exception
   *           Exception
   */
  public Map<String, String> getUpdpkgDependVersion(String key, String path) throws Exception {
    BufferedReader bf = null;
    Map<String, String> versionMap = new HashMap<String, String>();
    try {
      File file = new File(path);
      if (file.exists()) {
        File versionFile = new File(file, "/" + key + "/version/depend");
        if (key.equals("template")) { // 模板工程
          versionFile = new File(file, "/" + key + "/WebRoot/META-INF/version/template/depend");
        }
        bf = new BufferedReader(new InputStreamReader(new FileInputStream(versionFile), "UTF-8"));
        String line = "";
        while ((line = bf.readLine()) != null) {
          if (!"".equals(line.trim())) {
            versionMap.put(line.split("=")[0], line.split("=")[1]);
          }
        }
        bf.close();
      }
    } catch (FileNotFoundException e) {
      throw new Exception(e);
    } catch (IOException e) {
      throw new Exception(e);
    } finally {
      if (bf != null) {
        bf.close();
      }
    }
    return versionMap;
  }

  /**
   * 卸载版本
   * 
   * @param basepath
   *          项目路径
   * @param obj
   *          版本对象
   * @throws IOException
   *           IOException
   */
  public void uninstall(String basepath, Vm_component obj) throws IOException {
    // 删除conf下对应的文件
    File conf = new File(basepath + "/src/conf/daf_" + obj.getCode() + ".properties");
    if (conf.exists()) {
      FileUtils.forceDelete(conf);
    }
    // 删除themes下的文件
    File themes = new File(basepath + "/WebRoot/mybi/" + obj.getCode());
    FileUtils.deleteDirectory(themes);
    // 删除jsp
    File jsp = new File(basepath + "/WebRoot/WEB-INF/mybi/" + obj.getCode());
    FileUtils.deleteDirectory(jsp);
    // 删除版本文件
    File version = new File(basepath + "/WebRoot/META-INF/version/" + obj.getCode());
    FileUtils.deleteDirectory(version);
    // 删除sql脚本
    File sql = new File(basepath + "/WebRoot/sqlscript/" + obj.getCode());
    FileUtils.deleteDirectory(sql);
    // 删除jar包
    File jar = new File(basepath + "/WebRoot/WEB-INF/lib/mybi/" + obj.getCode());
    FileUtils.deleteDirectory(jar);
    
    rebuildClassPath(basepath);
  }

  /**
   * 备份版本
   * 
   * @param obj
   *          版本对象
   * @param bakpath
   *          备份路径
   * @param request
   *          HttpServletRequest
   * @throws Exception
   *           Exception
   */
  public void bakup(Vm_component obj, HttpServletRequest request, String bakpath) throws Exception {
    String basepath = obj.getWorkspace() + request.getContextPath();
    // 首先创建mybi-xxx-setup文件夹，在mybi-xxx-setup下创建xxx文件夹
    String bakDate = bakpath + "/bakup_" + obj.getCode() + "/" + DateUtil.toChar(DateUtil.getCurrDate(), "yyyyMMddHHmmss");
    File dir = new File(bakDate + "/mybi-" + obj.getCode() + "-setup/" + obj.getCode());
    // FileUtils.deleteDirectory(dir);
    dir.mkdirs();

    try {
      if (obj.getCode().equals("template")) {
        String[] confFiles = TemplateConfUtil.getSrcConfFile();
        // 备份零散的单独的文件
        for (String conf : confFiles) {
          File confFile = new File(basepath + "/" + conf);
          if (confFile.exists()) {
            FileUtils.copyFile(confFile, new File(dir, "/" + conf));
          }
        }

        // 备份src/demo
        File srcDemo = new File(basepath + "/src/demo/");
        FileUtils.copyDirectory(srcDemo, new File(dir, "src/demo/"));
        // 备份WebRoot\mybi\common\
        File webRootMybiCommon = new File(basepath + "/WebRoot/mybi/common/");
        FileUtils.copyDirectory(webRootMybiCommon, new File(dir, "/WebRoot/mybi/common/"));
        // 备份WebRoot\mybi\demo\
        File webRootMybiDemo = new File(basepath + "/WebRoot/mybi/demo/");
        FileUtils.copyDirectory(webRootMybiDemo, new File(dir, "/WebRoot/mybi/demo/"));
        // 备份WebRoot\WEB-INF\mybi\components\
        File webInfMybiComponents = new File(basepath + "/WebRoot/WEB-INF/mybi/components/");
        FileUtils.copyDirectory(webInfMybiComponents, new File(dir, "/WebRoot/WEB-INF/mybi/components/"));
        // WebRoot\WEB-INF\mybi\demo\
        File webInfMybiDemo = new File(basepath + "/WebRoot/WEB-INF/mybi/demo/");
        FileUtils.copyDirectory(webInfMybiDemo, new File(dir, "/WebRoot/WEB-INF/mybi/demo/"));
        // 备份版本文件
        File version = new File(basepath + "/WebRoot/META-INF/version/template");
        FileUtils.copyDirectory(version, new File(dir, "/WebRoot/META-INF/version/template"));
        // 备份sql脚本
        File sql = new File(basepath + "/WebRoot/sqlscript/template/");
        FileUtils.copyDirectory(sql, new File(dir, "/WebRoot/sqlscript/template/"));

        FileWriter fw = new FileWriter(new File(bakDate + "/baklog.txt"));
        fw.write(obj.getBaklog());
        fw.flush();
        fw.close();
      } else {
        // 备份conf下对应的文件
        File conf = new File(basepath + "/src/conf/daf_" + obj.getCode() + ".properties");
        if (conf.exists()) {
          FileUtils.copyFile(conf, new File(dir, "conf/daf_" + obj.getCode() + ".properties"));
        }
        // 备份themes下的文件
        File themes = new File(basepath + "/WebRoot/mybi/" + obj.getCode());
        FileUtils.copyDirectory(themes, new File(dir, "themes"));
        // 备份jsp
        File jsp = new File(basepath + "/WebRoot/WEB-INF/mybi/" + obj.getCode());
        FileUtils.copyDirectory(jsp, new File(dir, "jsp"));
        // 备份版本文件
        File version = new File(basepath + "/WebRoot/META-INF/version/" + obj.getCode());
        FileUtils.copyDirectory(version, new File(dir, "version"));
        // 备份sql脚本
        File sql = new File(basepath + "/WebRoot/sqlscript/" + obj.getCode());
        FileUtils.copyDirectory(sql, new File(dir, "sqlscript"));
        // 备份jar包
        File lib = new File(basepath + "/WebRoot/WEB-INF/lib/mybi/" + obj.getCode());
        FileUtils.copyDirectory(lib, new File(dir, "lib"));

        OutputStreamWriter out = new OutputStreamWriter(new FileOutputStream(new File(bakDate + "/baklog.txt")), "UTF-8");
        out.write(obj.getBaklog());
        out.flush();
        out.close();
        // FileWriter fw = new FileWriter(new File(bakDate + "/baklog.txt"));
        // fw.write(obj.getBaklog());
        // fw.flush();
        // fw.close();
      }
    } catch (FileNotFoundException e) {
      File bakDir = new File(bakDate);
      if (bakDir.exists()) {
        FileUtils.deleteDirectory(bakDir);
      }
      throw new Exception(e);
    } catch (Exception e) {
      File bakDir = new File(bakDate);
      if (bakDir.exists()) {
        FileUtils.deleteDirectory(bakDir);
      }
      throw new Exception(e);
    }
  }

  /**
   * 版本恢复
   * @param obj
   *          版本对象
   * @param bakpath
   *          备份路径
   * @param request
   *          HttpServletRequest
   * @throws Exception
   *           Exception
   */
  public void recovery(Vm_component obj, HttpServletRequest request, String bakpath) throws Exception {
    File dir = new File(bakpath + "/bakup_" + obj.getCode() + "/" + obj.getTimestamp() + "/mybi-" + obj.getCode() + "-setup/" + obj.getCode());
    String basepath = obj.getWorkspace() + request.getContextPath();
    if (!dir.exists()) {
      throw new Exception("指定的文件目录不存在。" + dir.getAbsolutePath());
    } else {
      if (obj.getCode().equals("template")) {
        String[] confFiles = TemplateConfUtil.getSrcConfFile();
        // 恢复零散的单独的文件
        for (String conf : confFiles) {
          File confFile = new File(basepath + "/" + conf);
          if (confFile.exists()) {
            FileUtils.copyFile(new File(dir, "/" + conf), confFile);
          }
        }

        // 恢复src/demo
        File srcDemo = new File(basepath + "/src/demo/");
        FileUtils.copyDirectory(new File(dir, "src/demo/"), srcDemo);
        // 恢复WebRoot\mybi\common\
        File webRootMybiCommon = new File(basepath + "/WebRoot/mybi/common/");
        FileUtils.copyDirectory(new File(dir, "/WebRoot/mybi/common/"), webRootMybiCommon);
        // 恢复WebRoot\mybi\demo\
        File webRootMybiDemo = new File(basepath + "/WebRoot/mybi/demo/");
        FileUtils.copyDirectory(new File(dir, "/WebRoot/mybi/demo/"), webRootMybiDemo);
        // 恢复WebRoot\WEB-INF\mybi\components\
        File webInfMybiComponents = new File(basepath + "/WebRoot/WEB-INF/mybi/components/");
        FileUtils.copyDirectory(new File(dir, "/WebRoot/WEB-INF/mybi/components/"), webInfMybiComponents);
        // WebRoot\WEB-INF\mybi\demo\
        File webInfMybiDemo = new File(basepath + "/WebRoot/WEB-INF/mybi/demo/");
        FileUtils.copyDirectory(new File(dir, "/WebRoot/WEB-INF/mybi/demo/"), webInfMybiDemo);
        // 恢复版本文件
        File version = new File(basepath + "/WebRoot/META-INF/version/template");
        FileUtils.copyDirectory(new File(dir, "/WebRoot/META-INF/version/template"), version);
        // 恢复sql脚本
        File sql = new File(basepath + "/WebRoot/sqlscript/template/");
        FileUtils.copyDirectory(new File(dir, "/WebRoot/sqlscript/template/"), sql);
      } else {
        // 先卸载之前的版本
        this.uninstall(basepath, obj);
        // 恢复conf下对应的文件
        File conf = new File(basepath + "/src/conf/daf_" + obj.getCode() + ".properties");
        if (conf.exists()) {
          FileUtils.copyFile(new File(dir, "conf/daf_" + obj.getCode() + ".properties"), conf);
        }
        // 恢复themes下的文件
        File themes = new File(basepath + "/WebRoot/mybi/" + obj.getCode());
        FileUtils.copyDirectory(new File(dir, "themes"), themes);
        // 恢复jsp
        File jsp = new File(basepath + "/WebRoot/WEB-INF/mybi/" + obj.getCode());
        FileUtils.copyDirectory(new File(dir, "jsp"), jsp);
        // 恢复版本文件
        File version = new File(basepath + "/WebRoot/META-INF/version/" + obj.getCode());
        FileUtils.copyDirectory(new File(dir, "version"), version);
        // 恢复sql脚本
        File sql = new File(basepath + "/WebRoot/sqlscript/" + obj.getCode());
        FileUtils.copyDirectory(new File(dir, "sqlscript"), sql);
        // 恢复jar包
        File lib = new File(basepath + "/WebRoot/WEB-INF/lib/mybi/" + obj.getCode());
        FileUtils.copyDirectory(new File(dir, "lib"), lib);
      }
    }
    
    rebuildClassPath(basepath);
  }

  /**
   * 获取当前项目组件中个文件版本
   * 
   * @param obj
   *          版本对象
   * @param request
   *          HttpServletRequest
   * @return Map<String, String> 各文件版本
   * @throws Exception
   *           Exception
   */
  public Map<String, String> getCurrComponentFileVersion(Vm_component obj, HttpServletRequest request) throws Exception {
    Map<String, String> map = new HashMap<String, String>();
    String projectPath = obj.getWorkspace() + "\\" + request.getContextPath().substring(1) + "\\";
    File file = new File(projectPath);
    if (!file.exists()) {
      throw new Exception("指定的文件或目录不存在" + projectPath);
    }

    if (obj.getCode().equals("myetl")) {
      return map;
    } else if (obj.getCode().equals("template")) {
      // conf下的文件
      List<String> list = new ArrayList<String>();
      for (String singleFile : TemplateConfUtil.getSrcConfFile()) {
        list.add(projectPath + singleFile.replaceAll("/", "\\\\"));
      }
      getFileList(projectPath + "src\\demo", list); // demo
      getFileList(projectPath + "WebRoot\\mybi\\common", list); // webroot//mybi//common
      getFileList(projectPath + "WebRoot\\mybi\\demo", list); // webroot//mybi//demo
      getFileList(projectPath + "WebRoot\\WEB-INF\\mybi\\components", list); //
      getFileList(projectPath + "WebRoot\\WEB-INF\\mybi\\demo", list); //
      getFileList(projectPath + "WebRoot\\WEB-INF\\mybi\\components", list); //
      getFileList(projectPath + "WebRoot\\WEB-INF\\lib\\mybi\\common", list); //

      String projectName = request.getContextPath().substring(1);
      for (String deskFile : list) {
        map.put(deskFile.substring(deskFile.indexOf(projectName) + projectName.length() + 1).replaceAll("\\\\", "/"), FileMD5Util.getInputStreamMD5(new FileInputStream(new File(deskFile))));
      }

    } else {
      // conf
      File confFile = new File(file, "src\\conf\\daf_" + obj.getCode() + ".properties");
      if (confFile.exists()) {
        map.put(obj.getCode() + "/conf/daf_" + obj.getCode() + ".properties", FileMD5Util.getInputStreamMD5(new FileInputStream(confFile)));
      }

      // themes
      List<String> fileList = new ArrayList<String>();
      getFileList(obj.getWorkspace() + "\\" + request.getContextPath() + "\\WebRoot\\mybi\\" + obj.getCode(), fileList);
      for (String path : fileList) {
        map.put(path.substring(path.indexOf("mybi") + 5).replaceAll("\\\\", "/").replaceAll(obj.getCode() + "/", obj.getCode() + "/themes/"),
            FileMD5Util.getInputStreamMD5(new FileInputStream(new File(path))));
      }

      // jsp
      fileList = new ArrayList<String>();
      getFileList(obj.getWorkspace() + "\\" + request.getContextPath() + "\\WebRoot\\WEB-INF\\mybi\\" + obj.getCode(), fileList);
      for (String path : fileList) {
        map.put(path.substring(path.indexOf("mybi") + 5).replaceAll("\\\\", "/").replaceAll(obj.getCode() + "/", obj.getCode() + "/jsp/"),
            FileMD5Util.getInputStreamMD5(new FileInputStream(new File(path))));
      }

      // lib
      fileList = new ArrayList<String>();
      getFileList(obj.getWorkspace() + "\\" + request.getContextPath() + "\\WebRoot\\WEB-INF\\lib\\mybi\\" + obj.getCode(), fileList);
      for (String path : fileList) {
        map.put(path.substring(path.indexOf("mybi") + 5).replaceAll("\\\\", "/").replaceAll(obj.getCode() + "/", obj.getCode() + "/lib/"),
            FileMD5Util.getInputStreamMD5(new FileInputStream(new File(path))));
      }
      
      // sql
      fileList = new ArrayList<String>();
      getFileList(obj.getWorkspace() + "\\" + request.getContextPath() + "\\WebRoot\\sqlscript\\" + obj.getCode(), fileList);
      for (String path : fileList) {
        //gdp/sqlscript/update.sql
        map.put(obj.getCode() + "/" + path.substring(path.indexOf("sqlscript")).replaceAll("\\\\", "/").replaceAll(obj.getCode() + "/", ""),
            FileMD5Util.getInputStreamMD5(new FileInputStream(new File(path))));
      }
    }
    return map;
  }

  /**
   * 获取升级包内的个文件版本
   * 
   * @param obj
   *          版本对象
   * @param mybi_upd_path
   *          升级包路径
   * @param request
   *          HttpServletRequest
   * @return Map<String, String> 升级包版本清单
   * @throws Exception
   *           Exception
   */
  public Map<String, String> getUpdPkgFileVersion(Vm_component obj, HttpServletRequest request, String mybi_upd_path) throws Exception {
    Map<String, String> map = new HashMap<String, String>();
    if (obj.getCode().equals("myetl")) {
      return map;
    } else {
      String versionFile = "";
      if (obj.getCode().equals("template")) {
        versionFile = mybi_upd_path + "\\mybi-" + obj.getCode() + "-setup\\" + obj.getCode() + "\\WebRoot\\META-INF\\version\\template\\version";
      } else {
        versionFile = mybi_upd_path + "\\mybi-" + obj.getCode() + "-setup\\" + obj.getCode() + "\\version\\version";
      }
      BufferedReader bf = null;
      try {
        if (!new File(versionFile).exists()) {
          throw new Exception("版本文件不存在");
        }
        bf = new BufferedReader(new InputStreamReader(new FileInputStream(versionFile), "UTF-8"));
        String line = "";
        while ((line = bf.readLine()) != null) {
          if (!"".equals(line)) {
            String[] linearr = line.split("=");
            String file = linearr[0];
            String md5 = linearr[1];
            if (file.indexOf("/version/version") > -1) {
              continue;
            } else {
              map.put(file, md5);
            }
          }
        }
        bf.close();
      } catch (Exception e) {
        throw new Exception(e);
      } finally {
        if (bf != null) {
          try {
            bf.close();
          } catch (IOException e) {
            throw new Exception(e);
          }
        }
      }
    }
    return map;
  }

  /**
   * 比较当前版本与安装包内版本的差异并返回差异的文件
   * 
   * @param origiMap
   *          当前项目中文件
   * @param newMap
   *          安装包内文件
   * @return 有差异的文件
   */
  public Map<String, String> getDifference4Map(Map<String, String> origiMap, Map<String, String> newMap) {
    Map<String, String> resultMap = new HashMap<String, String>();
    for (Entry entry : newMap.entrySet()) {
      if (origiMap.containsKey(entry.getKey())) { // 文件存在的化比较文件MD5
        if (!String.valueOf(origiMap.get(entry.getKey())).equals(String.valueOf(entry.getValue()))) {
          // 文件由修改
          resultMap.put(String.valueOf(entry.getKey()), "upd");
        }
      } else { // 新版本中新增文件
        resultMap.put(String.valueOf(entry.getKey()), "new");
      }
    }

    for (Entry entry : origiMap.entrySet()) {
      if (!newMap.containsKey(entry.getKey())) { // 说明删除了文件
        resultMap.put(String.valueOf(entry.getKey()), "del");
      }
    }
    return resultMap;
  }

  /**
   * 开始升级
   * 
   * @param obj
   *          版本对象
   * @param request
   *          HttpServletRequest
   * @param mybi_updpath
   *          升级包路径
   * @param user
   *          操作用户
   * @param parameter
   *          文件清单
   * @throws IOException
   *           IOException
   */
  public void updVersionFile(Vm_component obj, HttpServletRequest request, String parameter, Pim_sysUser user, String mybi_updpath) throws IOException {
    String workspace = obj.getWorkspace() + "/" + request.getContextPath();
    String srcPath = mybi_updpath + "/mybi-" + obj.getCode() + "-setup/";
    if (obj.getCode().equals("template")) {
      // 升级template
      String[] fileList = parameter.split(",");
      for (String file : fileList) {
        String[] fileArr = file.split("=");
        if (fileArr[1].equals("del")) { // 从当前项目中删除
          FileUtils.forceDelete(new File(workspace + "/" + fileArr[0]));
        } else if (fileArr[1].equals("upd") || fileArr[1].equals("new")) { // 覆盖当前项目文件
          FileUtils.copyFile(new File(srcPath + "/template/" + fileArr[0]), new File(workspace + "/" + fileArr[0]));
        }
      }
    } else {
      String[] fileList = parameter.split(",");
      for (String file : fileList) {
        //file的值如下形式：gdp/sqlscript/update.sql=del
        String[] fileArr = file.split("=");
        if (fileArr[1].equals("del")) { // 从当前项目中删除
          if (fileArr[0].indexOf(obj.getCode() + "/conf") > -1) {
            FileUtils.forceDelete(new File(workspace + "/src/conf/" + fileArr[0].substring(fileArr[0].lastIndexOf("/") + 1)));
          } else if (fileArr[0].indexOf(obj.getCode() + "/jsp") > -1) {
            FileUtils.forceDelete(new File(workspace + "/WebRoot/WEB-INF/mybi/" + fileArr[0].replaceAll("/jsp", "")));
          } else if (fileArr[0].indexOf(obj.getCode() + "/themes/") > -1) {
            FileUtils.forceDelete(new File(workspace + "/WebRoot/mybi/" + fileArr[0].replaceAll(obj.getCode() + "/themes", obj.getCode())));
          } else if (fileArr[0].indexOf(obj.getCode() + "/lib") > -1) {
            FileUtils.forceDelete(new File(workspace + "/WebRoot/WEB-INF/lib/mybi/" + fileArr[0].replaceAll("/lib", "")));
          } else if (fileArr[0].indexOf("/sqlscript") > -1) {
            //gdp/sqlscript/mybi-gdp-data.sql
            FileUtils.forceDelete(new File(workspace + "/WebRoot/sqlscript/" + fileArr[0].replaceAll("/sqlscript", "")));
          }
        } else if (fileArr[1].equals("upd") || fileArr[1].equals("new")) { // 覆盖当前项目文件
          if (fileArr[0].indexOf(obj.getCode() + "/conf") > -1) {
            FileUtils.copyFile(new File(srcPath + fileArr[0]), new File(workspace + "/src/conf" + fileArr[0].substring(fileArr[0].lastIndexOf("/") + 1)));
          } else if (fileArr[0].indexOf(obj.getCode() + "/jsp") > -1) {
            FileUtils.copyFile(new File(srcPath + fileArr[0]), new File(workspace + "/WebRoot/WEB-INF/mybi/" + fileArr[0].replaceAll("/jsp", "")));
          } else if (fileArr[0].indexOf(obj.getCode() + "/themes/") > -1) {
            FileUtils.copyFile(new File(srcPath + fileArr[0]), new File(workspace + "/WebRoot/mybi/" + fileArr[0].replaceAll(obj.getCode() + "/themes", obj.getCode())));
          } else if (fileArr[0].indexOf(obj.getCode() + "/lib") > -1) {
            FileUtils.copyFile(new File(srcPath + fileArr[0]), new File(workspace + "/WebRoot/WEB-INF/lib/mybi/" + fileArr[0].replaceAll("/lib", "")));
          } else if (fileArr[0].indexOf(obj.getCode() + "/sqlscript") > -1) {
            // FileUtils.forceDelete(new File(workspace +
            // "WebRoot/WEB-INF/lib/mybi/" + fileArr[0].replaceAll("/lib",
            // "")));
            //gdp/sqlscript/update.sql
            FileUtils.copyFile(new File(srcPath + fileArr[0]), new File(workspace + "/WebRoot/sqlscript/" + fileArr[0].replaceAll("/sqlscript", "")));
          }
        }
      }

      // 覆盖version、depend、selfversion
      FileUtils.copyFile(new File(srcPath + "/" + obj.getCode() + "/version/version"), new File(workspace + "/WebRoot/META-INF/version/" + obj.getCode() + "/version/"));
      FileUtils.copyFile(new File(srcPath + "/" + obj.getCode() + "/version/selfversion"), new File(workspace + "/WebRoot/META-INF/version/" + obj.getCode() + "/selfversion/"));
      FileUtils.copyFile(new File(srcPath + "/" + obj.getCode() + "/version/depend"), new File(workspace + "/WebRoot/META-INF/version/" + obj.getCode() + "/depend/"));
      // 添加sql
      //FileUtils.copyDirectory(new File(srcPath + "/" + obj.getCode() + "/sqlscript/"), new File(workspace + "WebRoot/sqlscript/" + obj.getCode()));
    }

    // 保存升级日志
    String[] fileList = parameter.split(",");
    Map<String, String> map = new HashMap<String, String>();
    map.put("userid", user.getLogid());
    map.put("code", obj.getCode());
    map.put("ip", request.getRemoteAddr());
    map.put("host", request.getRemoteHost());
    for (String file : fileList) {
      String[] fileArr = file.split("=");
      map.put("filename", fileArr[0]);
      map.put("updtyp", fileArr[1]);
      this.update("com.mingyoutech.mybi.pim.vm.domain.Vm_component.saveUpdLog", map);
    }
    
    rebuildClassPath(workspace);
  }

  /**
   * 查询组件升级日志
   * 
   * @param log
   *          日志对象
   * @param page
   *          页码
   * @param pagesize
   *          每页多少条
   * @return NONE
   */
  public Pager<Vm_updlog> findUpdLogPager(Vm_updlog log, int page, int pagesize) {
    return this.pagedQuery("com.mingyoutech.mybi.pim.vm.domain.Vm_component.findUpdLogPager", log, page, pagesize);
  }

  /**
   * 组件注册
   * 
   * @param obj
   *          版本对象
   * @param request
   *          HttpServletRequest
   * @param install_pkgFileName
   *          安装包
   * @throws Exception
   *           Exception
   */
  public void regeidtComponent(Vm_component obj, HttpServletRequest request, String install_pkgFileName) throws Exception {
    String code = install_pkgFileName.split("-")[1].replaceAll("web", "");
    obj.setCode(code);
    File dir = new File(obj.getWorkspace() + "\\" + install_pkgFileName.replaceAll(".zip", "") + "\\" + obj.getCode());
    String basepath = obj.getWorkspace() + request.getContextPath();
    if (!dir.exists()) {
      throw new Exception("文件或目录不存在：" + dir.getAbsolutePath());
    } else {
      // 恢复conf下对应的文件
      File conf = new File(basepath + "/src/conf/daf_" + obj.getCode() + ".properties");
      if (conf.exists()) {
        FileUtils.copyFile(new File(dir, "conf/daf_" + obj.getCode() + ".properties"), conf);
      }

      // 恢复themes下的文件
      File themes = new File(basepath + "/WebRoot/mybi/" + obj.getCode());
      FileUtils.copyDirectory(new File(dir, "themes"), themes);
      // 恢复jsp
      File jsp = new File(basepath + "/WebRoot/WEB-INF/mybi/" + obj.getCode());
      FileUtils.copyDirectory(new File(dir, "jsp"), jsp);
      // 恢复版本文件
      File version = new File(basepath + "/WebRoot/META-INF/version/" + obj.getCode());
      FileUtils.copyDirectory(new File(dir, "version"), version);
      // 恢复sql脚本
      File sql = new File(basepath + "/WebRoot/sqlscript/" + obj.getCode());
      FileUtils.copyDirectory(new File(dir, "sqlscript"), sql);
      // 恢复jar包
      File lib = new File(basepath + "/WebRoot/WEB-INF/lib/mybi/" + obj.getCode());
      FileUtils.copyDirectory(new File(dir, "lib"), lib);
      // 删除解压后的安装包目录
      FileUtils.deleteDirectory(new File(obj.getWorkspace() + "\\" + install_pkgFileName.replaceAll(".zip", "")));
    }
    
    rebuildClassPath(basepath);
  }

  /**
   * 获取当前要升级版本的自身版本
   * 
   * @param path
   *          升级包路径
   * @param key
   *          组件code
   * @return 当前升级包版本
   * @throws Exception
   *           Exception
   */
  public Map<String, String> getUpdPkgSelfVersion(String key, String path) throws Exception {
    BufferedReader bf = null;
    Map<String, String> versionMap = new HashMap<String, String>();
    try {
      File file = new File(path);
      if (file.exists()) {
        File versionFile = new File(file, "/" + key + "/version/selfversion");
        if (key.equals("template")) { // 模板工程
          versionFile = new File(file, "/" + key + "/WebRoot/META-INF/version/template/selfversion");
        }
        bf = new BufferedReader(new InputStreamReader(new FileInputStream(versionFile), "UTF-8"));
        String line = "";
        while ((line = bf.readLine()) != null) {
          versionMap.put(line.split("=")[0], line.split("=")[2]);
        }
        bf.close();
      }
    } catch (FileNotFoundException e) {
      throw new Exception(e);
    } catch (IOException e) {
      throw new Exception(e);
    } finally {
      if (bf != null) {
        bf.close();
      }
    }
    return versionMap;
  }

  /**
   * 校验当前项目使用的版本和要升级的版本确认是佛可以进行升级
   * 
   * @param selfVersionMap
   *          要升级的版本
   * @param versionMap
   *          当前项目种版本
   * @param obj
   *          组件对象
   * @throws Exception
   *           Exception
   */
  public void chkWhetherUpdate(Map<String, String> selfVersionMap, Map<String, String> versionMap, Vm_component obj) throws Exception {
    if (versionMap.containsKey(obj.getCode())) {
      String updversion = selfVersionMap.get(obj.getCode()); // 要升級的版本
      String curversion = versionMap.get(obj.getCode()); // 當前項目中安裝版本

      String[] upd = updversion.split("\\.");
      String[] cur = curversion.split("\\.");
      if (updversion.equals(curversion)) {
        throw new Exception("当前项目中的版本和要升级的版本一致，无需升级");
      } else {
        if (Integer.parseInt(upd[0]) > Integer.parseInt(cur[0])) { 
          throw new Exception("版本之间跨度太大，不能进行升级");
        } else if (Integer.parseInt(upd[0]) < Integer.parseInt(cur[0])) {
          throw new Exception("当前项目中的版本高于要升级的版本，不能升级");
        } else {
          if (Integer.parseInt(upd[1]) < Integer.parseInt(cur[1])) { 
            throw new Exception("当前项目中的版本高于要升级的版本，不能升级");
          } else if (Integer.parseInt(upd[1]) == Integer.parseInt(cur[1])) {
            if (Integer.parseInt(upd[2]) < Integer.parseInt(cur[2])) {
              throw new Exception("当前项目中的版本高于要升级的版本，不能升级");
            }
          }
        }
      }
    }
  }

  /**
   * 重新构建classpath路径
   * 
   * @param projectPath
   *          项目路径
   * @throws IOException
   *           IOException
   */
  private void rebuildClassPath(String projectPath) throws IOException {
    // 开始重写classpath文件
    logger.info("重写模板工程classpath文件");
    File clspath = new File(projectPath + "//.classpath");
    FileWriter fw = new FileWriter(clspath);

    fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
    fw.write("<classpath>\r\n");
    fw.write("<classpathentry kind=\"src\" path=\"src/appcase\" />\r\n");
    fw.write("<classpathentry kind=\"src\" path=\"src/conf\" />\r\n");
    fw.write("<classpathentry kind=\"src\" path=\"src/demo\" />\r\n");
    fw.write("<classpathentry kind=\"con\" path=\"com.genuitec.runtime.library/com.genuitec.generic_5.0\" />\r\n");

    List<String> list = new ArrayList<String>();
    getFileList(projectPath + "/WebRoot/WEB-INF/lib", list);
    for (String jarFile : list) {
      fw.write("<classpathentry kind=\"lib\" path=\"" + jarFile.substring(jarFile.indexOf("WebRoot")).replaceAll("\\\\", "\\/") + "\" />\r\n");
    }
    fw.write("<classpathentry kind=\"con\" path=\"org.eclipse.jst.j2ee.internal.web.container\" />\r\n");
    fw.write("<classpathentry kind=\"con\" path=\"org.eclipse.jst.j2ee.internal.module.container\" />\r\n");
    fw.write("<classpathentry kind=\"con\" path=\"org.eclipse.jdt.launching.JRE_CONTAINER\" />\r\n");
    fw.write("<classpathentry kind=\"output\" path=\"WebRoot/WEB-INF/classes\" />\r\n");
    fw.write("</classpath>");
    fw.flush();
    fw.close();
    logger.info("重写模板工程classpath文件完毕");
  }

  /**
   * 递归遍历某个文件夹下的文件
   * 
   * @param path
   *          要遍历的文件夹
   * @param list
   *          文件清单集合
   * @return 所有的文件清单
   */
  public List<String> getFileList(String path, List<String> list) {
    File dir = new File(path);
    File[] files = dir.listFiles();
    if (files != null) {
      for (int i = 0; i < files.length; i++) {
        if (files[i].isDirectory()) {
          getFileList(files[i].getAbsolutePath(), list);
        } else {
          list.add(files[i].getAbsolutePath());
        }
      }
    }
    return list;
  }

  /**
   * 递归遍历某个文件夹下的文件
   * 
   * @param path
   *          要遍历的文件夹
   * @param list
   *          文件清单集合
   * @param specialFile
   *          指定文件
   * @return 所有的文件清单
   */
  public List<String> getFileList(String path, List<String> list, String specialFile) {
    File dir = new File(path);
    File[] files = dir.listFiles();
    if (files != null) {
      for (int i = 0; i < files.length; i++) {
        if (files[i].isDirectory()) {
          getFileList(files[i].getAbsolutePath(), list, specialFile);
        } else {
          if (files[i].getName().equals(specialFile)) {
            list.add(files[i].getAbsolutePath());
          }
        }
      }
    }
    return list;
  }
}
