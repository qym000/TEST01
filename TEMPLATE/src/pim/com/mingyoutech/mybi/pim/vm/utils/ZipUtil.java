/*
 * 杭州明佑电子有限公司
 * Copyright (c) MINGYOUTECH Co. Ltd.
 * 
 * 项目名称：
 * 创建日期：20150504
 * 修改历史：
 *    1. 创建文件by lvzhenjun, 20150504
 */
package com.mingyoutech.mybi.pim.vm.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.tools.zip.ZipEntry;
import org.apache.tools.zip.ZipFile;
import org.apache.tools.zip.ZipOutputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
/**
 * ZIP解压缩工具类
 * @author june,2014-05-09
 */
public class ZipUtil {
  
  /**
   * 构造参数私有化，防止外部创建实例 
   */
  private ZipUtil() { }

  /** 日志 */
  static Logger logger = LoggerFactory.getLogger(ZipUtil.class);

  //private static final String ENCODE = System.getProperty("sun.jnu.encoding");
  /** 编码 */
  static final String ENCODE = "GBK";
  
  /** 压缩包后缀 */
  static final String ZIP = ".zip";
  
  /** 缓冲区 */
  static final int BUFFER_SIZE = 512000; // 500KB

  /**
   * 将一个文件或目录压缩成一个zip文件
   * 
   * @param srcPath
   *          文件或目录路径
   * @param destPath
   *          目标路径
   * @throws IOException IOException
   */
  public static void compress(String srcPath, String destPath) throws IOException {
    compress(new File(srcPath), new File(destPath), null, null);
  }

  /**
   * 将一个文件或目录压缩成一个zip文件
   * 
   * @param srcPath
   *          文件或目录路径
   * @param destPath
   *          目标路径
   * @param comment
   *          压缩包注释
   * @throws IOException IOException
   */
  public static void compress(String srcPath, String destPath, String comment) throws IOException {
    compress(new File(srcPath), new File(destPath), comment, null);
  }

  /**
   * 将一个文件或目录压缩成一个zip文件
   * 
   * @param srcFile
   *          文件或目录
   * @param destFile
   *          目标文件
   * @param comment
   *          压缩包注释
   * @throws IOException IOException
   */
  public static void compress(File srcFile, File destFile, String comment) throws IOException {
    compress(srcFile, destFile, comment, null);
  }

  /**
   * 将一个文件或目录压缩成一个zip文件
   * 
   * @param srcFile
   *          文件或目录
   * @param destFile
   *          目标文件
   * @param comment
   *          压缩包注释
   * @param filter
   *          过滤文件(正则表达式)
   * @throws IOException IOException
   */
  public static void compress(File srcFile, File destFile, String comment, List<String> filter) throws IOException {
    List<File> fileList = new ArrayList<File>();
    fileList.add(srcFile);
    compress(fileList, destFile, comment, filter, false);
  }

  /**
   * 将一组文件或目录压缩成一个zip文件
   * 
   * @param fileList
   *          文件或目录列表
   * @param destFile
   *          目标文件
   * @param comment
   *          压缩包注释
   * @param filter
   *          过滤文件(正则表达式)
   * @throws IOException IOException
   */
  public static void compress(List<File> fileList, File destFile, String comment, List<String> filter) throws IOException {
    compress(fileList, destFile, comment, filter, false);
  }

  /**
   * 将一组文件或目录压缩成一个zip文件
   * 
   * @param fileList
   *          文件或目录列表
   * @param destFile
   *          目标文件
   * @param comment
   *          压缩包注释
   * @param filter
   *          过滤文件(正则表达式)
   * @param ignoreError
   *          忽略错误
   * @throws IOException IOException
   */
  public static void compress(List<File> fileList, File destFile, String comment, List<String> filter, boolean ignoreError) throws IOException {
    if (destFile.isDirectory()) {
      String name = destFile.getName() + ZIP;
      destFile = new File(destFile, name);
      if (filter != null) {
        filter = new ArrayList<String>();
      }
      filter.add(name);
    }
    ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(destFile));
    try {
      zos.setEncoding(ENCODE);
      for (File file : fileList) {
        if (fileList.size() == 1) {
          compress(zos, file, "", comment, filter, ignoreError);
        } else {
          compress(zos, file, file.getName(), comment, filter, ignoreError);
        }
      }
    } finally {
      zos.flush();
      zos.close();
    }
  }

  /**
   * 添加文件到压缩包中
   * @param zipFile 压缩文件
   * @param files 待压缩的文件数组
   * @param entryPath entry路径
   * @param withDir 是否包含父文件夹
   * @throws IOException IOException
   */
  public static void addFileToZip(File zipFile, File[] files, String entryPath, boolean withDir) throws IOException {
    File tempFile = File.createTempFile(zipFile.getName(), null);
    tempFile.delete();
    boolean renameOk = zipFile.renameTo(tempFile);
    if (!renameOk) {
      throw new RuntimeException("could not rename the file " + zipFile.getAbsolutePath() + " to " + tempFile.getAbsolutePath());
    }
    addFileToZip(tempFile, zipFile, files, entryPath, withDir);
  }
  
  /**
   * 添加压缩文件到压缩包中
   * 
   * @param srcZip 压缩文件
   * @param destZip 待压缩的压缩文件数组
   * @param files 待压缩的文件数组
   * @param entryPath entry路径
   * @param withDir 是否包含父文件夹
   * @throws IOException IOException
   */
  public static void addFileToZip(File srcZip, File destZip, File[] files, String entryPath, boolean withDir) throws IOException {
    byte[] buffer = new byte[BUFFER_SIZE];
    ZipFile zipFile = new ZipFile(srcZip, ENCODE);
    ZipOutputStream out = new ZipOutputStream(new FileOutputStream(destZip));
    try {
      out.setEncoding(ENCODE);
      Enumeration<?> e = zipFile.getEntries();
      while (e.hasMoreElements()) {
        ZipEntry entry = (ZipEntry) e.nextElement();
        String name = entry.getName();
        boolean notInFiles = true;

        for (int i = 0; i < files.length; i++) {
          File file = files[i];
          if ((entryPath + "/" + file.getName()).equals(name)) {
            notInFiles = false;
            break;
          }
        }
        if (notInFiles) {
          out.putNextEntry(new ZipEntry(name));
          InputStream is = zipFile.getInputStream(entry);
          int length = 0;
          while ((length = is.read(buffer, 0, BUFFER_SIZE)) != -1) {
            out.write(buffer, 0, length);
          }
        }
      }

      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        if (file.isDirectory()) {
          if (withDir) {
            compress(out, file, entryPath + "/" + file.getName(), "", null, false);
          } else {
            compress(out, file, entryPath, "", null, false);
          }
        } else {
          if (entryPath.endsWith("/") || entryPath.endsWith("\\")) {
            compress(out, file, entryPath + "" + file.getName(), "", null, false);
          } else {
            compress(out, file, entryPath + "/" + file.getName(), "", null, false);
          }
        }
      }
    } finally {
      zipFile.close();
      out.flush();
      out.close();
    }
  }

  /**
   * 添加文件到压缩包中
   * @param zipFile 压缩文件
   * @param file 待压缩的文件
   * @param entryPath entry路径
   * @throws IOException IO异常
   */
  public static void addFileToZip(File zipFile, File file, String entryPath) throws IOException {
    addFileToZip(zipFile, new File[] {file}, new String[] {entryPath});
  }

  /**
   * 添加文件到压缩包中
   * @param zipFile 压缩文件
   * @param files 待压缩的文件数组
   * @param entryPaths entry路径数组
   * @throws IOException IOException
   */
  public static void addFileToZip(File zipFile, File[] files, String[] entryPaths) throws IOException {
    File tempFile = File.createTempFile(zipFile.getName(), null);
    tempFile.delete();
    boolean renameOk = zipFile.renameTo(tempFile);
    if (!renameOk) {
      throw new RuntimeException("could not rename the file " + zipFile.getAbsolutePath() + " to " + tempFile.getAbsolutePath());
    }
    addFileToZip(tempFile, zipFile, files, entryPaths);
  }
  
  /**
   * 添加压缩文件到压缩包中
   * 
   * @param srcZip 压缩文件
   * @param destZip 待压缩的压缩文件数组
   * @param files 待压缩的文件数组
   * @param entryPaths entry路径
   * @throws IOException IOException
   */
  public static void addFileToZip(File srcZip, File destZip, File[] files, String[] entryPaths) throws IOException {
    byte[] buffer = new byte[BUFFER_SIZE];
    ZipFile zipFile = new ZipFile(srcZip, ENCODE);
    ZipOutputStream out = new ZipOutputStream(new FileOutputStream(destZip));
    try {
      out.setEncoding(ENCODE);
      Enumeration<?> e = zipFile.getEntries();
      while (e.hasMoreElements()) {
        ZipEntry entry = (ZipEntry) e.nextElement();
        String name = entry.getName();
        boolean notInFiles = true;

        String entryName = "";
        for (int i = 0; i < files.length; i++) {
          File file = files[i];
          if (entryPaths != null && i < entryPaths.length) {
            entryName = entryPaths[i];
          }
          if ((entryName + "/" + file.getName()).equals(name)) {
            notInFiles = false;
            break;
          }
        }
        if (notInFiles) {
          out.putNextEntry(new ZipEntry(name));
          InputStream is = zipFile.getInputStream(entry);
          int length = 0;
          while ((length = is.read(buffer, 0, BUFFER_SIZE)) != -1) {
            out.write(buffer, 0, length);
          }
        }
      }
      String entryName = "";
      for (int i = 0; i < files.length; i++) {
        File file = files[i];
        if (entryPaths != null && i < entryPaths.length) {
          entryName = entryPaths[i];
        }
        if (file.isDirectory()) {
          compress(out, file, entryName, "", null, false);
        } else {
          if (entryName.endsWith("/") || entryName.endsWith("\\")) {
            compress(out, file, entryName + "" + file.getName(), "", null, false);
          } else {
            compress(out, file, entryName + "/" + file.getName(), "", null, false);
          }
        }
      }
    } finally {
      zipFile.close();
      out.flush();
      out.closeEntry();
      out.close();
    }
  }

  /**
   * 将一组文件或目录压缩到一个Zip输出流中
   * 
   * @param out
   *          zip输出流
   * @param srcFile
   *          文件或目录
   * @param name
   *          压缩包中的名称
   * @param comment
   *          压缩包注释
   * @param filter
   *          过滤文件(正则表达式)
   * @param ignoreError
   *          忽略错误
   * @throws IOException IOException
   */
  private static void compress(ZipOutputStream out, File srcFile, String name, String comment, List<String> filter, boolean ignoreError) throws IOException {
    if (!srcFile.exists()) {
      throw new IOException(srcFile.getAbsolutePath() + "文件不存在。");
    }
    try {
      if (srcFile.isDirectory()) {
        File[] files = srcFile.listFiles();
        name = name.length() == 0 ? "" : name + "/";
        if (!isFilter(name, filter) && name.length() != 0) {
          out.putNextEntry(new ZipEntry(name));
        }
        for (File file : files) {
          compress(out, file, name + file.getName(), comment, filter, ignoreError);
        }
      } else {
        if (!isFilter(name, filter)) {
          name = name.length() == 0 ? srcFile.getName() : name;
          ZipEntry zipEntry = new ZipEntry(name);
          zipEntry.setComment(comment);
          out.putNextEntry(zipEntry);
          FileInputStream in = null;
          try {
            in = new FileInputStream(srcFile);
            int length = 0;
            byte[] buffer = new byte[BUFFER_SIZE];
            while ((length = in.read(buffer, 0, BUFFER_SIZE)) != -1) {
              out.write(buffer, 0, length);
            }
          } finally {
            in.close();
          }
        }
      }
    } catch (IOException e) {
      if (ignoreError) {
        logger.warn("compress zip ignore error: ");
        logger.warn(e.getMessage(), e);
      } else {
        throw e;
      }
    }
  }

  /**
   * 指定的名称是否被过滤
   * 
   * @param base 基目录
   * @param filter
   *          过滤列表(正则表达式)
   * @return 指定的名称是否被过滤
   */
  private static boolean isFilter(String base, List<String> filter) {
    if (filter != null && !filter.isEmpty()) {
      for (int i = 0; i < filter.size(); i++) {
        Pattern pat = Pattern.compile(filter.get(i));
        Matcher mat = pat.matcher(base);
        if (mat.find()) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * 将一个zip文件中指定的文件解压到一个目录
   * 
   * @param srcPath
   *          压缩包路径
   * @param destDir
   *          解压位置
   * @param deskFile
   *          zip包中指定的文件
   * @param deleteFile
   *          是否删除
   * @throws IOException IOException
   */
  public static void uncompress(String srcPath, String destDir, String deskFile, boolean deleteFile) throws IOException {
    uncompress(new File(srcPath), new File(destDir), new File(deskFile), deleteFile);
  }
  
  /**
   * 将一个zip文件解压到一个目录
   * 
   * @param srcFile
   *          压缩包文件
   * @param destDir
   *          解压位置
   * @param deskFile
   *          zip包中指定的文件
   * @param deleteFile
   *          是否删除
   * @throws IOException IOException
   */
  public static void uncompress(File srcFile, File destDir, File deskFile, boolean deleteFile) throws IOException {
    if (!srcFile.exists()) {
      throw new IOException(srcFile.getAbsolutePath() + "文件不存在");
    }
    
    if (destDir.isFile()) {
      throw new IOException("压缩路径不能是文件");
    }
    
    ZipFile zipFile = null;
    try {
      zipFile = new ZipFile(srcFile, ENCODE);
      Enumeration<?> e = zipFile.getEntries();
      while (e.hasMoreElements()) {
        ZipEntry zipEntry = (ZipEntry) e.nextElement();
        if (zipEntry.getName().indexOf(deskFile.getName()) == -1) {
          continue;
        }
        
        if (zipEntry.isDirectory()) {
          String name = zipEntry.getName();
          name = name.substring(0, name.length() - 1);
          File f = new File(destDir, name);
          f.mkdirs();
        } else {
          File f = new File(destDir, zipEntry.getName());
          f.getParentFile().mkdirs();
          f.createNewFile();
          InputStream is = null;
          FileOutputStream fos = null;
          try {
            is = zipFile.getInputStream(zipEntry);
            fos = new FileOutputStream(f);
            int length = 0;
            byte[] buffer = new byte[BUFFER_SIZE];
            while ((length = is.read(buffer, 0, BUFFER_SIZE)) != -1) {
              fos.write(buffer, 0, length);
            }
          } finally {
            fos.close();
          }
        }
      }
    } finally {
      zipFile.close();
    }
    if (deleteFile) {
      srcFile.deleteOnExit();
    }
  }
  
  
  /**
   * 将一个zip文件解压到一个目录
   * 
   * @param srcPath
   *          压缩包路径
   * @param destDir
   *          解压位置
   * @param deleteFile
   *          是否删除
   * @throws IOException IOException
   */
  public static void uncompress(String srcPath, String destDir, boolean deleteFile) throws IOException {
    uncompress(new File(srcPath), new File(destDir), deleteFile);
  }

  /**
   * 将一个zip文件解压到一个目录
   * 
   * @param srcFile
   *          压缩包文件
   * @param destDir
   *          解压位置
   * @param deleteFile
   *          是否删除
   * @throws IOException IOException
   */
  public static void uncompress(File srcFile, File destDir, boolean deleteFile) throws IOException {
    if (!srcFile.exists()) {
      throw new IOException(srcFile.getAbsolutePath() + "文件不存在");
    }
    if (destDir.isFile()) {
      throw new IOException("压缩路径不能是文件");
    }
    ZipFile zipFile = null;
    try {
      zipFile = new ZipFile(srcFile, ENCODE);
      Enumeration<?> e = zipFile.getEntries();
      while (e.hasMoreElements()) {
        ZipEntry zipEntry = (ZipEntry) e.nextElement();
        if (zipEntry.isDirectory()) {
          String name = zipEntry.getName();
          name = name.substring(0, name.length() - 1);
          File f = new File(destDir, name);
          f.mkdirs();
        } else {
          File f = new File(destDir, zipEntry.getName()); //如果是事先建好压缩包，往里拖文件夹压缩的话，zipentry会把文件夹当初文件
          f.getParentFile().mkdirs();
          if (f.isDirectory()) {
            continue;
          }
          f.createNewFile();
          InputStream is = null;
          FileOutputStream fos = null;
          try {
            is = zipFile.getInputStream(zipEntry);
            fos = new FileOutputStream(f);
            int length = 0;
            byte[] buffer = new byte[BUFFER_SIZE];
            while ((length = is.read(buffer, 0, BUFFER_SIZE)) != -1) {
              fos.write(buffer, 0, length);
            }
          } finally {
            if (fos != null) {
              fos.flush();
              fos.close();
            }
            
            if (is != null) {
              is.close();
            }
          }
        }
      }
    } finally {
      if (zipFile != null) {
        zipFile.close();
      }
    }
    
    if (deleteFile) {
      srcFile.delete();
    }
  }

  /**
   * 读取压缩包的注释
   * 
   * @param filePath 文件路径
   * @return 注释
   * @throws IOException IOException
   */
  public static String getZipComment(String filePath) throws IOException {
    ZipFile zipFile = null;
    try {
      zipFile = new ZipFile(filePath, ENCODE);
      Enumeration<?> e = zipFile.getEntries();
      String comment = "";
      while (e.hasMoreElements()) {
        ZipEntry ze = (ZipEntry) e.nextElement();
        comment = ze.getComment();
        if (comment != null && !comment.equals("") && !comment.equals("null")) {
          break;
        }
      }
      return comment;
    } finally {
      zipFile.close();
    }
  }

  // 功能和效率与compress方法类似
  // /**
  // * 将一个文件或目录压缩成一个zip文件
  // * @param srcPath 源文件路径
  // * @param destPath 目标路径
  // * @throws IOException
  // */
  // public static void zip(String srcPath, String destPath) throws IOException
  // {
  // zip(srcPath, destPath, null, null);
  // }
  //
  // /**
  // * 将一个文件或目录压缩成一个zip文件
  // * @param srcPath 源文件路径
  // * @param destPath 目标路径
  // * @param include 包含规则
  // * @param exclude 排序规则
  // * @throws IOException
  // */
  // public static void zip(String srcPath, String destPath, String include,
  // String exclude) throws IOException {
  // zip(new File(srcPath), new File(destPath), include, exclude);
  // }
  //
  // /**
  // * 将一个文件或目录压缩成一个zip文件
  // * @param srcFile 源文件
  // * @param destFile 目标文件
  // * @throws IOException
  // */
  // public static void zip(File srcFile, File destFile) throws IOException {
  // zip(srcFile, destFile, null, null);
  // }
  //
  // /**
  // * 将一个文件或目录压缩成一个zip文件
  // * @param srcFile 源文件
  // * @param destFile 目标文件
  // * @param include 包含规则
  // * @param exclude 排序规则
  // * @throws IOException
  // */
  // public static void zip(File srcFile, File destFile, String include, String
  // exclude) throws IOException {
  // if (!srcFile.exists()) {
  // throw new IOException(srcFile.getAbsolutePath() + Msg.E_FILE_NOT_EXISTS);
  // }
  // if (destFile.isDirectory()) {
  // String name = destFile.getName() + ZIP;
  // destFile = new File(destFile, name);
  // }
  // Project project = new Project();
  // FileSet fileSet = new FileSet();
  // fileSet.setProject(project);
  // // 判断是目录还是文件
  // if (srcFile.isDirectory()) {
  // fileSet.setDir(srcFile);
  // } else {
  // fileSet.setFile(srcFile);
  // }
  // if (AssertUtil.isNotEmpty(include)) {
  // fileSet.setIncludes(include);// 包括哪些文件或文件夹
  // }
  // if (AssertUtil.isNotEmpty(exclude)) {
  // fileSet.setExcludes(exclude); // 排除哪些文件或文件夹
  // }
  //
  // Zip zip = new Zip();
  // zip.setProject(project);
  // zip.setDestFile(destFile);
  // zip.addFileset(fileSet);
  // zip.setEncoding(ENCODE);
  //
  // zip.execute();
  // }
  //
  // /**
  // * 解压缩
  // * @param srcPath 压缩包
  // * @param destDir 解压位置
  // * @throws IOException
  // */
  // public static void unzip(String srcPath, String destDir) throws IOException
  // {
  // unzip(new File(srcPath), new File(destDir));
  // }
  //
  // /**
  // * 解压缩
  // * @param srcFile 压缩包
  // * @param destDir 解压位置
  // * @throws IOException
  // */
  // public static void unzip(File srcFile, File destDir) throws IOException {
  // if (!srcFile.exists()) {
  // throw new IOException(srcFile.getAbsolutePath() + Msg.E_FILE_NOT_EXISTS);
  // }
  // if (destDir.isFile()) {
  // throw new IOException(Msg.E_ZIPUTIL_UNZIPPATHCANNOTFILE);
  // }
  // Project project = new Project();
  // Expand expand = new Expand();
  // expand.setProject(project);
  // expand.setTaskType("unzip");
  // expand.setTaskName("unzip");
  // expand.setEncoding(ENCODE);
  //
  // expand.setSrc(srcFile);
  // expand.setDest(destDir);
  //
  // expand.execute();
  // }
}
