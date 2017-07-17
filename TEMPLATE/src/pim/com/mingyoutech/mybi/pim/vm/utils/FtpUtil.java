package com.mingyoutech.mybi.pim.vm.utils;

import java.io.File;
import java.io.FileInputStream;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;

public class FtpUtil {
  private FTPClient ftp;

  public boolean connect(String path, String addr, int port, String username, String password) throws Exception {
    boolean result = false;
    this.ftp = new FTPClient();

    this.ftp.connect(addr, port);
    this.ftp.login(username, password);
    this.ftp.setFileType(2);
    int reply = this.ftp.getReplyCode();
    if (!FTPReply.isPositiveCompletion(reply)) {
      this.ftp.disconnect();
      return result;
    }
    this.ftp.changeWorkingDirectory(path);
    result = true;
    return result;
  }

  public void upload(File file) throws Exception {
    if (file.isDirectory()) {
      this.ftp.makeDirectory(file.getName());
      this.ftp.changeWorkingDirectory(file.getName());
      String[] files = file.list();
      for (int i = 0; i < files.length; i++) {
        File file1 = new File(file.getPath() + "\\" + files[i]);
        if (file1.isDirectory()) {
          upload(file1);
          this.ftp.changeToParentDirectory();
        } else {
          File file2 = new File(file.getPath() + "\\" + files[i]);
          FileInputStream input = new FileInputStream(file2);
          this.ftp.storeFile(file2.getName(), input);
          input.close();
        }
      }
    } else {
      File file2 = new File(file.getPath());
      FileInputStream input = new FileInputStream(file2);
      this.ftp.storeFile(file2.getName(), input);
      input.close();
    }
  }
}
