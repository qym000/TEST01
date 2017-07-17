/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 * 
 * 项目名称：mybi-pim-2.2.2
 * 创建日期：2016-5-5
 * 修改历史：
 *    1. 创建文件。by GaoZhenhan, 2016-5-5
 */
package com.mingyoutech.mybi.demo.crud.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.mingyoutech.mybi.pim.common.action.SysBaseAction;

/**
 * 动态图表Excel的导出例子
 * @author GaoZhenhan, 2016-5-5
 */
@Scope("prototype")
@Controller
@Namespace("/")
@ParentPackage("privilegeStack")
@ResultPath("/WEB-INF/mybi")
@Action(
      results = {
           @Result(name = "exportChartExcel", type = "stream", params = { "contentType", "application/octet-stream;charset=iso-8859-1", "inputName", "inputStream", "contentDisposition",
                          "attachment;filename=${exportFileName}", "bufferSize", "2048" })
      }
)
public class Demo_chartExcelAction extends SysBaseAction {

  private static final long serialVersionUID = -8285462176420933716L;
  
  /**期限*/
  public static String[] terms = {"On Demand", "1d", "2d", "3d", "4d", "5d", "6d", "7d", "1w-2w", "2w-3w", "3w-1m", "1-3m", "3-6m", "6-12m", "1-2y", "2-3y", "3-5y", ">5y"};
  
  /**
   * 导出入口
   * @return
   */
  public String exportChartExcel() {
    return "exportChartExcel";
  }
  
  /**
   * 导出文件名
   */
  public String getExportFileName() {
    String name = "法兰克福流动性导出.xlsx";
    try {
        return new String(name.getBytes("gbk"), "ISO8859-1");
    } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
        return "unknown";
    }
  }
  
  /**
   * excel导出输入流
   * @return
   * @throws IOException 
   */
  public InputStream getInputStream() throws IOException {
    String currentClassPath =this.getClass().getResource("").getPath();  
    String projectPath = currentClassPath.substring(0, currentClassPath.indexOf("WEB-INF"));
    String templatePath = projectPath + "/mybi/demo/法兰克福流动性导出模板.xlsx";
    File templateFile = new File(templatePath);
    File newFile = null;
    FileInputStream fis = null;
    FileOutputStream fos = null;
    try {
      List<Map<String, Object>> dataList = this.getRandomData();
      newFile = new File(projectPath + "/mybi/demo/法兰克福流动性导出.xlsx");
      if (newFile.exists()) {
        newFile.delete();
      }
      FileUtils.copyFile(templateFile, newFile);
      fis = new FileInputStream(newFile);
      XSSFWorkbook wb = new XSSFWorkbook(fis);
      XSSFSheet sheet = wb.getSheetAt(0);
      for (int i = 0; i < dataList.size(); i++) {
        XSSFRow row = sheet.createRow(i + 30);
        XSSFCell cell = row.createCell(0);
        cell.setCellValue((String) dataList.get(i).get("TERM"));
        XSSFCell cell2 = row.createCell(1);
        cell2.setCellValue(Double.valueOf((String) dataList.get(i).get("VALUE")));
      }
      fis.close();
      fos = new FileOutputStream(newFile);
      wb.write(fos);
      fos.close();
      return new FileInputStream(newFile);
    } catch (IOException e) {
      e.printStackTrace();
    } finally {
      if (fis != null) {
        try {
          fis.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
      if (fos != null) {
        try {
          fos.close();
        } catch (IOException e) {
          e.printStackTrace();
        }
      }
    }
    return null;
  }
  
  /**
   * 获取随机数据
   * @return 随机数据List
   */
  private List<Map<String, Object>> getRandomData() {
    List<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
    Map<String, Object> map = null;
    for (String term : terms) {
      map = new HashMap<String, Object>();
      map.put("TERM", term);
      map.put("VALUE", Math.floor((Math.random()*1000000 + 1)) + "");
      dataList.add(map);
    }
    return dataList;
  }
  
}
