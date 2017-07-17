/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 * 
 * 项目名称：版本管理平台
 * 创建日期：20150504
 * 修改历史：
 *    1. 创建文件by lvzhenjun, 20150504
 */
package com.mingyoutech.mybi.pim.vm.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.digest.DigestUtils;

/**
 * 文件MD5工具类
 * @author june,2014-05-09
 */
public class FileMD5Util {

  /** 构造参数私有化 */
  private FileMD5Util() { }
  
  /** MD5变量声明 */
  static MessageDigest MD5 = null;

  static {
    try {
      MD5 = MessageDigest.getInstance("MD5");
    } catch (NoSuchAlgorithmException ne) {
      ne.printStackTrace();
    }
  }

  /**
   * 对一个文件获取md5值
   * @param file 文件对象
   * @return md5串
   */
  public static String getMD5(File file) {
    FileInputStream fileInputStream = null;
    try {
      fileInputStream = new FileInputStream(file);
      byte[] buffer = new byte[8192];
      int length;
      while ((length = fileInputStream.read(buffer)) != -1) {
        MD5.update(buffer, 0, length);
      }
      return new String(Hex.encodeHex(MD5.digest()));
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      return null;
    } catch (IOException e) {
      e.printStackTrace();
      return null;
    } finally {
      try {
        if (fileInputStream != null)
          fileInputStream.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }

  /**
   * 对一个文件输入流获取MD5值
   * @param inputStream 文件输入流
   * @return MD5串
   */
  public static String getInputStreamMD5(InputStream inputStream) {
    try {
      byte[] buffer = new byte[8192];
      int length;
      while ((length = inputStream.read(buffer)) != -1) {
        MD5.update(buffer, 0, length);
      }
      return new String(Hex.encodeHex(MD5.digest()));
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      return null;
    } catch (IOException e) {
      e.printStackTrace();
      return null;
    } finally {
      try {
        if (inputStream != null)
          inputStream.close();
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
  
  /**
   * 求一个字符串的md5值
   * @param target 文件路径字符串
   * @return md5 value 文件的MD5
   */
  public static String getMD5(String target) {
    return DigestUtils.md5Hex(target);
  }
  
  /**
   * 获取zip包内每个文件的MD5，支持中文
   * @param file 文件路径
   * @return List<String> 每个文件的MD5
   * @throws Exception 抛出异常
   */
  @SuppressWarnings("rawtypes")
  public static List<String> getZipFileMD5(String file) throws Exception {
    List<String> list = new ArrayList<String>();
    org.apache.tools.zip.ZipFile zf = new org.apache.tools.zip.ZipFile(file, "GBK");
    org.apache.tools.zip.ZipEntry ze;
    Enumeration entries = zf.getEntries();
    while (entries.hasMoreElements()) {
      ze = (org.apache.tools.zip.ZipEntry) entries.nextElement();
      if (ze.isDirectory()) {
        continue;
      } else {
        long size = ze.getSize();
        if (size > 0) {
          list.add(ze.getName() + "=" + getInputStreamMD5(zf.getInputStream(ze)));
        }
      }
    }
    zf.close();
    return list;
  }

  /**
   * main主方法 测试
   * @param args 参数
   * @throws Exception 
   */
  public static void main(String[] args) throws Exception {
    //long beginTime = System.currentTimeMillis();
    //File fileZIP = new File("D:\\软件安装包\\AdobePhotoshop17-mul_x64.zip");
    //String md5 = getMD5(fileZIP);
    //long endTime = System.currentTimeMillis();
    //System.out.println("MD5:" + md5 + "\n time:" + ((endTime - beginTime) / 1000) + "s");
    List<String> list = FileMD5Util.getZipFileMD5("D://MYBI.zip");
    FileWriter fw = new FileWriter(new File("D://version.txt"));
    for (String string : list) {
      fw.write(string + "\t\n");
    }
    fw.flush();
    fw.close();
  }
}
