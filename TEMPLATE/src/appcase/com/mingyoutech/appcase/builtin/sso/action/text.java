package com.mingyoutech.appcase.builtin.sso.action;
 
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
 
/**
 * @author 码农小江
 * H20121012.java
 * 2012-10-12下午11:40:21
 */
public class text {
    /**
     * 功能：Java读取txt文件的内容
     * 步骤：1：先获得文件句柄
     * 2：获得文件句柄当做是输入一个字节码流，需要对这个输入流进行读取
     * 3：读取到输入流后，需要读取生成字节流
     * 4：一行一行的输出。readline()。
     * 备注：需要考虑的是异常情况
     * @param filePath String
     */
  public static void readTxtFile(String filePath) {
    try {
      String encoding = "GBK";
      File file = new File(filePath);
      if (file.isFile() && file.exists()) { //判断文件是否存在
        InputStreamReader read = new InputStreamReader(new FileInputStream(file), encoding); //考虑到编码格式
        BufferedReader bufferedReader = new BufferedReader(read);
        String lineTxt = null;
        while ((lineTxt = bufferedReader.readLine()) != null) {
          System.out.println(lineTxt);
        }
        read.close();
      } else {
        System.out.println("找不到指定的文件");
      }
    } catch (Exception e) {
      System.out.println("读取文件内容出错");
      e.printStackTrace();
    }
  }
  
  /**
   * 
   * @param filePath String
   * @return String
   */
  public String readFileByByte(String filePath) {
    long beginTime = System.currentTimeMillis();
    StringBuffer stringBuffer = new StringBuffer();
    byte[] buffer = new byte[2048];
    int count = 0;
    File file = new File(filePath);
    try {
      InputStream inputStream = new FileInputStream(file);
      while (-1 != (count = inputStream.read(buffer))) {
        stringBuffer.append(new String(buffer, 0, count));
      }
      inputStream.close();
    } catch (IOException ex) {
      ex.printStackTrace();
    }
    long endTime = System.currentTimeMillis();
    System.out.println(this.getClass().getName() + ",readFileByByte method costs :" + (endTime - beginTime));
    System.out.println(this.getClass().getName() + ",readFileByByte size :" + (stringBuffer.toString().length()));
    System.out.println(this.getClass().getName() + ",readFileByByte size :" + (stringBuffer.toString()));
    return null;
  }
  
  /**
   * 
   * @param argv String
   */
  public static void main(String []argv) {
    String filePath = "D:\\test.txt";
//      "res/";
 //       readTxtFile(filePath);
        
    (new text()).readFileByByte(filePath);
  }
}
