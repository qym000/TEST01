/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 * 
 * 项目名称：版本管理平台
 * 创建日期：20150504
 * 修改历史：
 *    1. 创建文件by lvzhenjun, 20150504
 */
package com.mingyoutech.mybi.pim.vm.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.mingyoutech.framework.util.Pager;
import com.mingyoutech.mybi.pim.sysauth.domain.Pim_sysUser;
import com.mingyoutech.mybi.pim.vm.domain.Vm_component;
import com.mingyoutech.mybi.pim.vm.domain.Vm_updlog;

/**
 * 版本升级service层
 * 
 * @author june,2014-05-09
 */
public interface Vm_versionService {

  /**
   * 查询所有组件清单
   * @param request HttpServletRequet
   * @param obj 版本对象
   * @return List<Vm_component> 已安装组件清单
   * @throws Exception 
   */
  List<Vm_component> findComponentList(Vm_component obj, HttpServletRequest request) throws Exception;

  /**
   * 校验各个文件版本
   * @param obj 组件版本对象
   * @param request HttpServletRequest
   * @return Map<String, String> 返回版本不一致的文件清单
   * @throws Exception 
   */
  Map<String, String> chkFileVersion(Vm_component obj, HttpServletRequest request) throws Exception;
  
  /**
   * 获取各个组件的版本 
   * @param obj 版本对象
   * @param request HttpServletRequest
   * @return 组件版本信息
   * @throws Exception 
   */
  Map<String, String> getComponentVersion(Vm_component obj, HttpServletRequest request) throws Exception;
  
  /**
   * 获取升级版依赖版本
   * @param key 组件标识
   * @param path 升级包路径
   * @return 依赖组件版本信息
   * @throws Exception 
   */
  Map<String, String> getUpdpkgDependVersion(String key, String path) throws Exception;
  
  /**
   * 卸载版本
   * @param basepath 项目路径
   * @param obj 版本对象
   * @throws IOException IOException
   */
  void uninstall(String basepath, Vm_component obj) throws IOException;

  /**
   * 备份版本
   * @param obj 版本对象
   * @param bakpath 备份路径
   * @param request HttpServletRequest
   * @throws IOException IOException
   * @throws Exception Exception
   */
  void bakup(Vm_component obj, HttpServletRequest request, String bakpath) throws IOException, Exception;

  /**
   * @param obj 版本对象
   * @param bakpath 備份路徑
   * @param request HttpServletRequest
   * @throws Exception 
   */
  void recovery(Vm_component obj, HttpServletRequest request, String bakpath) throws Exception;

  /**
   * @param obj 版本对象
   * @param request HttpServletRequest
   * @return Map<String, String> 各个文件版本
   * @throws Exception 
   */
  Map<String, String> getCurrComponentFileVersion(Vm_component obj, HttpServletRequest request) throws Exception;

  /**
   * 获取升级包内的个文件版本
   * @param obj 版本对象
   * @param request HttpServletRequest
   * @param mybi_updpath 升级包路径
   * @return Map<String, String> 升级包版本清单
   * @throws Exception 
   */
  Map<String, String> getUpdPkgFileVersion(Vm_component obj, HttpServletRequest request, String mybi_updpath) throws Exception;

  /**
   * 比较当前版本与安装包内版本的差异并返回差异的文件
   * @param origiMap 当前项目中文件
   * @param newMap 安装包内文件
   * @return 有差异的文件
   */
  Map<String, String> getDifference4Map(Map<String, String> origiMap, Map<String, String> newMap);

  /**
   * 开始升级
   * @param obj 版本对象
   * @param request HttpServletRequest
   * @param parameter 文件清单
   * @param user 操作用户
   * @param mybi_updpath 升级包lujing
   * @throws IOException 
   */
  void updVersionFile(Vm_component obj, HttpServletRequest request, String parameter, Pim_sysUser user, String mybi_updpath) throws IOException;

  /**
   * 查询组件升级日志
   * @param log 日志对象
   * @param page 页码
   * @param pagesize 每页多少条
   * @return NONE
   */
  Pager<Vm_updlog> findUpdLogPager(Vm_updlog log, int page, int pagesize);

  /**
   * 组件注册
   * @param obj 版本对象
   * @param request HttpServletRequest
   * @param install_pkgFileName 安装包
   * @throws Exception 
   */
  void regeidtComponent(Vm_component obj, HttpServletRequest request, String install_pkgFileName) throws Exception;

  /**
   * 获取当前要升级版本的自身版本
   * @param path 升级包路径
   * @param code 组件code
   * @return 当前升级包版本
   * @throws Exception Exception
   */
  Map<String, String> getUpdPkgSelfVersion(String code, String path) throws Exception;

  /**
   * 校验当前项目使用的版本和要升级的版本确认是佛可以进行升级
   * @param selfVersionMap 要升级的版本
   * @param versionMap 当前项目种版本
   * @param obj 组件对象
   * @throws Exception Exception 
   */
  void chkWhetherUpdate(Map<String, String> selfVersionMap, Map<String, String> versionMap, Vm_component obj) throws Exception;
}
