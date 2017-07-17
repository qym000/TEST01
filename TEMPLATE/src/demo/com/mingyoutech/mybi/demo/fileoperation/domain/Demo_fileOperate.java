package com.mingyoutech.mybi.demo.fileoperation.domain;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import com.mingyoutech.framework.domain.BaseDomain;
import com.mingyoutech.framework.file.vo.ExcelVOAttribute;
/**
 * 
 * @author ian shan
 * 
 */
@Alias("Demo_fileOperate")
public class Demo_fileOperate extends BaseDomain {
    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    //字符串1
    @ExcelVOAttribute(name = "字符串列", isExport = true, column = "B")
    private String strCol ;
    @ExcelVOAttribute(name = "数字列", isExport = true, column = "C", fieldType="number", format="3")
    private Integer numCol;
    @ExcelVOAttribute(name = "浮点数列", isExport = true, column = "D", fieldType="number", format="4")
    private Double floatCol;
    @ExcelVOAttribute(name = "字符日期列", isExport = true, align = "center", column = "E")
    private String datestrCol;
    @ExcelVOAttribute(name = "日期列", isExport = true, column = "F", align = "center", width=26, fieldType="date", format="yyyy-mm-dd hh:mm:ss" )
    private Date dateCol;
    @ExcelVOAttribute(name = "枚举列", isExport = true, column = "G", align = "center",  combo = "1##是,2##否,3##都可以")
    private String enumCol;
    public String getStrCol() {
        return strCol;
    }
    public void setStrCol(String strCol) {
        this.strCol = strCol;
    }
    public Integer getNumCol() {
        return numCol;
    }
    public void setNumCol(Integer numCol) {
        this.numCol = numCol;
    }
    public Double getFloatCol() {
        return floatCol;
    }
    public void setFloatCol(Double floatCol) {
        this.floatCol = floatCol;
    }
    public String getDatestrCol() {
        return datestrCol;
    }
    public void setDatestrCol(String datestrCol) {
        this.datestrCol = datestrCol;
    }
    public Date getDateCol() {
        return dateCol;
    }
    public void setDateCol(Date dateCol) {
        this.dateCol = dateCol;
    }
    public String getEnumCol() {
        return enumCol;
    }
    public void setEnumCol(String enumCol) {
        this.enumCol = enumCol;
    }
    
}
