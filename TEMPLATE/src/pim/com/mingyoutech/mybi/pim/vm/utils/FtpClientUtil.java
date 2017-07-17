package com.mingyoutech.mybi.pim.vm.utils;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;

public class FtpClientUtil {
  private static final FtpClientUtil ftpClientUtil = new FtpClientUtil();

  public static FtpClientUtil newInstance() {
    return ftpClientUtil;
  }

  public InputStream getFileByFtp(String ftpserver, int port, String user, String pwd, String mode, String filepath) throws FileNotFoundException {
    InputStream is = null;
    try {
      filepath = "ftp://" + user + ":" + pwd + "@" + ftpserver + "/" + filepath;
      FTPClient ftpClient = new FTPClient();
      ftpClient.connect(ftpserver, port);
      ftpClient.login(user, pwd);
      ftpClient.setControlEncoding("UTF-8");
      if ((mode != null) && (!"".equals(mode))) {
        if (mode.equals("0")) {
          ftpClient.enterLocalActiveMode();
        } else if (mode.equals("1")) {
          ftpClient.enterLocalPassiveMode();
        }
      }

      int reply = ftpClient.getReplyCode();

      if (!FTPReply.isPositiveCompletion(reply)) {
        ftpClient.disconnect();
        System.err.println("Server Refused connection!");
      }

      System.out.println("Open FTP Success:" + ftpserver + "; port:" + port + "; name:" + user);
      URL url = new URL(filepath);
      is = url.openStream();
      closeFtpConnect(ftpClient);
    } catch (MalformedURLException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }
    return is;
  }

  public static boolean uploadFile(String ip, int port, String username, String password, String mode, String path, String filename, InputStream input) {
    boolean success = false;
    FTPClient ftp = new FTPClient();
    try {
      ftp.connect(ip, port);

      ftp.login(username, password);
      int reply = ftp.getReplyCode();
      if (!FTPReply.isPositiveCompletion(reply)) {
        ftp.disconnect();
        boolean bool1 = success;
        return bool1;
      }
      ftp.makeDirectory(path);
      ftp.changeWorkingDirectory(path);
      ftp.setFileType(2);
      if ((mode != null) && (!"".equalsIgnoreCase(mode))) {
        if (mode.equals("0")) {
          ftp.enterLocalActiveMode();
        } else if (mode.equals("1")) {
          ftp.enterLocalPassiveMode();
        }
      }
      ftp.storeFile(filename, input);

      input.close();
      ftp.logout();
      success = true;
    } catch (IOException e) {
      e.printStackTrace();

      if (ftp.isConnected()) {
        try {
          ftp.disconnect();
        } catch (IOException localIOException2) {
        }
      }

      if (ftp.isConnected()) {
        try {
          ftp.disconnect();
        } catch (IOException localIOException3) {
        }
      }
    } finally {
      if (ftp.isConnected()) {
        try {
          ftp.disconnect();
        } catch (IOException localIOException4) {
        }
      }
    }
    return success;
  }

  public void closeFtpConnect(FTPClient ftpClient) {
    if (ftpClient != null) {
      try {
        ftpClient.disconnect();
        System.out.println("Close Ftp Connection Success! ");
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }

  public static void testUpLoadFromDisk() {
    try {
      FileInputStream in = new FileInputStream(new File("D:\\test.txt"));
      boolean flag = uploadFile("10.0.0.99", 21, "etl", "etl", "0", "/home/etl/rep/model2", "test.txt", in);
      System.out.println(flag);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
  }

  public static void testUpLoadFromString() throws InterruptedException {
    try {
      InputStream input = new ByteArrayInputStream("test ftp".getBytes("utf-8"));
      boolean flag = uploadFile("10.0.0.99", 21, "etl", "etl", "0", "D:/ftp", "test.txt", input);
      System.out.println(flag);
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    }
  }

  public static void main(String[] args) throws FileNotFoundException {
  }
}
