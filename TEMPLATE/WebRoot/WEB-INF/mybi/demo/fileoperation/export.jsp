<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<style>
#component {
 margin: auto;
 width: 80%;
 height: 20px;
 font-family:"微软雅黑"; 
 font-size:12px;
 background: #FBFBFB;
 padding: 10px;
 border: 1px solid  #D2D2D2;
 overflow: hidden;
}
#key {
 color: red;
 float: right;
}
#key img{
  height: 16px;
  width: 16px;
}
#component .title li{
  float:left;
  list-style-type:none;
}
#component .title .desc{
  margin-top:5px;
}
#key{cursor:pointer;}
#component li{
  list-style-type:none;
}

#component .code .code-desc{
   background-color:#DBDBDB;
   clear:both;
   height:25px;
   border: 1px solid  #646464;
}
#component .code .code-content{
   border: 1px solid  #646464;
} 
pre {text-align:left;}
pre .cha{color:red;}
.pretable {
   border: 1px solid  #646464;
   border-collapse:collapse;
}
.pretable th,.pretable  td{
   border: 1px solid  #646464;
   
}
</style>
<script>
var s=100;
var isopen=1;
var minheight=20;
var maxheight=1500;
function shoppingcat(){
  var content=document.getElementById("component");
  var key = document.getElementById("key");
  var t=content.style;
  if(t.height==""||t.height==0)
    t.height=minheight;
  var h=parseInt(t.height);
  if(isopen){
    h+=s;
    t.height=h+"px";
    if(h<maxheight){
      setTimeout("shoppingcat();",1);
    }else{
  isopen=0
      key.innerHTML="<img src='${ctx}/mybi/common/themes/default/images/arrow_up.png'>";
    }
  }else{
    h-=s;
    t.height=h+"px";
    if(h>minheight){
      setTimeout("shoppingcat();",1);
    }else{
   isopen=1
      key.innerHTML="<img src='${ctx}/mybi/common/themes/default/images/arrow_down.png'>";
    }
  }
}

</script>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css"  rel="stylesheet" type="text/css">
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>

</head>
<body style="height:1550px;">


	


 <div id="component"> 
 <div id="key" onclick="shoppingcat();"><img src="${ctx}/mybi/common/themes/default/images/arrow_down.png"></div>
 
<div class="title">
	<ul>
		<li class="desc">功能名称：excel导出&nbsp;</li>
		<li><a href="demo-export!exportDemo.action" class="myui-button-query" >导出</a></li>
	</ul>
</div>
<div class="code">
	<ul>
		<li class="code-desc">JSP代码</li>
		<li class="code-content">
			<pre>&lt;a href=&quot;demo-export!exportDemo.action&quot;  class=&quot;myui-button-query&quot; &gt;导出&lt;/a&gt;
			</pre>
		</li>
	</ul>
</div>

<div class="code">
	<ul>
		<li class="code-desc">JAVA代码</li>
		<li class="code-content">
			<pre>注意：<span class="cha">红色为需替换</span>
@Action 标签中添加：@Result(name = "<span class="cha">resultname</span>", type = "stream", params = { "contentType", 
"application/octet-stream;charset=iso-8859-1", "inputName", "<span class="cha">inputStream</span>", "contentDisposition", 
"attachment;filename=<span class="cha"> $ {exportFileName}</span>", "bufferSize", "2048" }) 
    /**
     * @description:测试导出excel名称,要与上面配置的红色$ {exportFileName}相同
     * @param:
     * @return NONE
     */
    public String getExportFileName() {
        /*  后缀名为：xls为excel2003、xlsx为excel2007、csv为csv
         */
        String name = "测试.xlsx";
        try {
            return new String(name.getBytes("gbk"), "ISO8859-1");
        } catch (UnsupportedEncodingException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return "nullName";
        }
    }
    
    /**
     * @description:测试导出excel输入流,要与上面配置的红色inputStream相同
     * @param:
     * @return InputStream 输入流
     */
    public InputStream getInputStream() throws Exception {
        InputStream inputStream = null;
        try {
            ExcelFileExportImpl excelExport= new ExcelFileExportImpl(Demo_fileOperate.class);
            List list = fileOperateService.getList(null);
           /*传入参数：
            *   第一个参数：数据列表（其中list中的实体需要配置了实体标签）     
            *   第二个参数：导出类型（系统支持3中导出类型  、xls为excel2003、xlsx为excel2007、csv为csv
            *   第三个参数：sheet页名称
            */
            inputStream = excelExport.exportFile(list, "xlsx", "测试");
        }catch(Exception e)
        {
            e.printStackTrace();
        }
        return inputStream;
    }   
    
    public String exportAction() {
        return "resultname";
    }
			</pre>
		</li>
	</ul>
</div>

<div class="code">
	<ul>
		<li class="code-desc">实体类</li>
		<li class="code-content">
			<pre>
在实体类中配置属性：
使用@ExcelVOAttribute标注方式配置
一、包含属性：      
1、name       导出到Excel中的名字
2、column     配置列的名称,对应A,B,C,D....
3、combo      设置只能选择不能输入的列内容.
4、isExport   是否导出数据,应对需求:有时我们需要导出一份模板,这是标题需要但内容需要用户手工填写.
5、fieldType  导出字段类型,默认为string,number、date
6、align      对齐方式，包含left、right、center；（默认字符串左对齐，日期居中，数字右对齐）
7、width      导出字段宽度，最大为250，默认宽度为16能放下6个字标题
8、format     数据格式                                   
         
<table class="pretable">
	<tr>
		<th colspan="2" style="background-color: #DDF1EA">数字类型</th>
	</tr>
	<tr style="background-color: #DBDBDB">
		<th>描述</th>
		<th> 值 </th>
	</tr>
	<tr>
		<td>整数</td>
		<td>1</td>
	</tr>
	<tr>
		<td>带小数点</td>
		<td>2</td>
	</tr>
	<tr>
		<td>整数逗号分隔</td>
		<td>3</td>
	</tr>
	<tr>
		<td>带小数点逗号分隔</td>
		<td>4</td>
	</tr>
	<tr>
		<td>百分比整数</td>
		<td>5</td>
	</tr>
	<tr>
		<td>带小数百分比</td>
		<td>6</td>
	</tr>
	<tr>
		<th colspan="2" style="background-color: #DDF1EA">日期格式</th>
	</tr>
	<tr>
		<td colspan="2">使用yyyymmdd组合日期，hhmmss组合时间，例如：yyyy年mm月dd日 hh:mm:ss， 默认日期显示格式为 yyyy-mm-dd</td>
	</tr>
	
</table>
二、案例（在实体类的字段中配置，一下是案例）：
<table>
	<tr>
		<td colspan="2">
@ExcelVOAttribute(name = "字符串列", isExport = true, column = "B")
private String strCol ;
@ExcelVOAttribute(name = "数字列", isExport = true, column = "C", fieldType="number", format="3")
private Integer numCol;
@ExcelVOAttribute(name = "浮点数列", isExport = true, column = "D", fieldType="number", format="4")
private Double floatCol;
@ExcelVOAttribute(name = "字符日期列", isExport = true, align = "center", column = "E")
private String datestrCol;
@ExcelVOAttribute(name = "日期列", isExport = true, column = "F", align = "center", width=26, <br>fieldType="date", format="yyyy-mm-dd hh:mm:ss" )
private Date dateCol;
@ExcelVOAttribute(name = "枚举列", isExport = true, column = "G", align = "center",  <br>combo = "1##是,2##否,3##都可以")
private String enumCol;
</td>
	</tr>
	
</table>


   
			</pre>
		</li>
	</ul>
</div>

</div>
</body>

</html>

