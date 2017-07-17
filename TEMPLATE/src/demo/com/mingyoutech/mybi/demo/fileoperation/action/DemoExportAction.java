package com.mingyoutech.mybi.demo.fileoperation.action;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.List;

import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.apache.struts2.convention.annotation.ResultPath;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.mingyoutech.framework.action.BaseAction;
import com.mingyoutech.framework.file.impl.ExcelFileExportImpl;
import com.mingyoutech.mybi.demo.fileoperation.domain.Demo_fileOperate;
import com.mingyoutech.mybi.demo.fileoperation.service.Demo_fileOperateService;

/**
 * @description:file opreration
 * @author:ian shan
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
@Action(
        results={@Result(name="manage", location="demo/fileoperation/export.jsp"),
                @Result(name="rptdown", location="demo/tmp/rptdown.jsp"),
                @Result(name="indval", location="demo/tmp/indval.jsp"),
                @Result(name="indinfo", location="demo/tmp/index-info.jsp"),
                @Result(name = "exportDemo", type = "stream", params = { "contentType", "application/octet-stream;charset=iso-8859-1", "inputName", "inputStream", "contentDisposition",
                         "attachment;filename=${exportFileName}", "bufferSize", "2048" }) 
        }
)
public class DemoExportAction extends BaseAction{
    /**
     * @description:转向DEMO导出管理页面
     * @param:
     * @return:String 转向地址demo/fileoperation/export.jsp
     */
    @Autowired
    public Demo_fileOperateService fileOperateService;
    public String toManage()  {
        return "manage";
    }
    
    public String toRptDown()
    {
        return "rptdown";
    }
    
    public String toIndVal()
    {
        return "indval";
    }
    
    public String toIndInfo()
    {
        return "indinfo";
    }
    /**
     * @description:非利息收入各机构占比excel文件的名称
     * @param:
     * @return NONE
     */
    public String getExportFileName() {
        String name = "测试.txt";
        try {
            return new String(name.getBytes("gbk"), "ISO8859-1");
        } catch (UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return "nullName";
        }
    }
    
    /**
     * @description:导出非利息收入各机构占比excel的输入流
     * @param:
     * @return InputStream 输入流
     */
    public InputStream getInputStream() throws Exception {
        InputStream inputStream = null;
        try {
            ExcelFileExportImpl excelExport= new ExcelFileExportImpl(Demo_fileOperate.class);
            Demo_fileOperate dm = new Demo_fileOperate();
            List list = fileOperateService.getList(dm);
          //  excelExport.setCustom_col("numCol:A,strCol:B");
         //   inputStream = excelExport.exportFile(list, "csv", "测试");
            inputStream =   excelExport.exportTxtFile(list, "|", "开始-----", "结束---");
        }catch(Exception e)
        {
            e.printStackTrace();
        }
        return inputStream;
    }   
    
    public String exportDemo() {
        return "exportDemo";
    }
}
