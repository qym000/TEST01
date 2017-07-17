<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/scripts/syntaxHighlighter/styles/shCoreEclipse.css" rel="stylesheet" type="text/css" />
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shCore.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/syntaxHighlighter/scripts/shBrushCpp.js"></script>
<style type="text/css">
h3{font-family:"微软雅黑";margin-left:15px;margin-top:20px;margin-bottom:10px;}
.pre-text {font-family:微软雅黑;font-size:14px;}
</style>
<script type="text/javascript">
	$(function(){
		// 初始化页面元素及表单验证
		initPage();
	});
	
	// 初始化页面元素
	function initPage() {
		SyntaxHighlighter.all();
		$("body").unbind();
	}
	
	// 关闭当前窗口
    function clsWin(){
    	parent.$("#inputWin").window('close');
    }
	
</script>
</head>
<body>

<div class="myui-form">
	<div class="form" style="overflow:auto;">
		<h3>配置ERMS报表方案</h3>
		<pre class="pre-text">
           在ERMS报表方案配置中，需要先通过AWK脚本将ERMS报表模板解析为类似CSV格式的文件（逗号或其他分隔符分隔的数据文本文件），然后再像【单个方案】中的配
    置方法一样进行字段映射配置。请注意，如果在点击【方案配置选项】中的【解析字段】按钮之前并没有对ERMS报表模板进行解析，则会弹出【请先将ERMS报表文件解析
    为CSV文件】的提示信息。
           常用的类CSV分割符有(均为英文半角)：
          【竖线】 |
          【冒号】 :
          【逗号】 ,
          【句号】 .
          【星号】 *
          【尖号】 ^
		</pre>
		<h3>解析ERMS报表文件成为CSV文件</h3>
		<pre class="pre-text">
       该部分请在【ERMS报表解析】区域操作：
       1.上传或直接编辑AWK脚本文件；
       2.上传txt格式的ERMS报表文件，请注意文件不需要太大，只需上传包含格式和少量数据的模板文件即可。
       3.点击【解析】按钮直到提示【解析成功】即可，在弹出的提示信息后点击【确定】按钮可以看到解析后的文件预览。
		</pre>
		<h3>AWK脚本文件的编辑</h3>
		<pre class="pre-text">
       请注意在编辑AWK脚本文件时，不需要添加其他的Shell等系统命令，生成的结果文件该功能会自动保存。一个正确可用的AWK脚本文件内容应当如下：
		</pre>
		<pre class="brush:cpp">
BEGIN{
  // BEGIN语句块在awk开始从输入流中读取行之前被执行，这是一个可选的语句块，
  // 比如变量初始化、打印输出表格的表头等语句通常可以写在BEGIN语句块中
}
{
  // pattern语句块中的通用命令是最重要的部分，它也是可选的。如果没有提供pattern语句块，则默认执行{ print }，
  // 即打印每一个读取到的行，awk读取的每一行都会执行该语句块
}
END{
  // END语句块在awk从输入流中读取完所有的行之后即被执行，
  // 比如打印所有行的分析结果这类信息汇总都是在END语句块中完成，它也是一个可选语句块。
}
		</pre>
		<pre class="pre-text">
		一个简单的实例：
		</pre>
		<pre class="brush:cpp">
BEGIN{
  // 该部分一般进行变量初始化；
  FLAG=0; // 是否输出标识，当FLAG = 1时输出，FLAG = 0时跳过
  ROWCNT=0; // 行计数器,该文件第6行为表头，我们只需要输出一行表头信息并以竖线分割
  // 下面全是字段变量；
  ORGNAM=""; 
  CENDAT="";
  CURNAM="";
  APCCDE=""
  GXZIDT=""
  GXFLAG=""
  XZCDE="";
  GXZBAL="";
  YSGZBAL="";
  GZBAL="";
  DFZH="";
  GZDATE="";
  JYCDE="";
  LSIDT="";
  JBGY="";
  GZORG="";
  ZY="";
}
{   
  ROWCNT++;
  if (ROWCNT == 6) {
    GXZIDT=substr($0,3,5);// substr函数截取字符串
    GXFLAG=substr($0,16,4);
    XZCDE=substr($0,26,3);
    GXZBAL=substr($0,47,5);
    YSGZBAL=substr($0,68,6);
    GZBAL=substr($0,86,4);
    DFZH=substr($0,100,4);
    GZDATE=substr($0,110,4);
    JYCDE=substr($0,117,4);
    LSIDT=substr($0,124,3);
    JBGY=substr($0,130,4);
    GZORG=substr($0,137,6);
    ZY=substr($0,146,2);
    // 已竖线分割格式化输出；
    printf("%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n",
      "机构","日期","币种","核算码",GXZIDT,GXFLAG,XZCDE,GXZBAL,YSGZBAL,GZBAL,DFZH,GZDATE,JYCDE,LSIDT,JBGY,GZORG,ZY)
  }
  if(index($0, "挂销账账号 ")){
    FLAG=1;
  }else if (substr($0,1,1)=="1"){
    FLAG=0;
  }else if (index($0, "挂账余额  余额合计 :")){
    FLAG=0;
  }else if (index($0,"机构 :")){
  	ORGNAM=substr($0,9,20);
   	CENDAT=substr($0,41,10);
   	CURNAM=substr($0,73,3);
   	APCCDE=substr($0,101,4);
  }else if (FLAG==1 && $0 !~/^$/){ //表达式$0 !~/^$/表示不是空行时匹配
   	GXZIDT=substr($0,3,16);
   	GXFLAG=substr($0,21,2);
   	XZCDE=substr($0,30,14);
   	GXZBAL=substr($0,45,25);
   	YSGZBAL=substr($0,71,25);
   	GZBAL=substr($0,97,23);
   	DFZH=substr($0,121,17);
   	GZDATE=substr($0,139,12);
   	JYCDE=substr($0,154,6);
   	LSIDT=substr($0,161,9);
   	JBGY=substr($0,172,7);
   	GZORG=substr($0,192,8);
   	ZY=substr($0,200);	
    printf("%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n",
      ORGNAM,CENDAT,CURNAM,APCCDE,GXZIDT,GXFLAG,XZCDE,GXZBAL,YSGZBAL,GZBAL,DFZH,GZDATE,JYCDE,LSIDT,JBGY,GZORG,ZY)
  }
}
		</pre>
		<h3>附录：常用AWK内置变量</h3>
		<pre class="pre-text">
	$n 当前记录的第n个字段，比如n为1表示第一个字段，n为2表示第二个字段。 
	$0 这个变量包含执行过程中当前行的文本内容。 [N] ARGC 命令行参数的数目。 
	[G] ARGIND 命令行中当前文件的位置（从0开始算）。 
	[N] ARGV 包含命令行参数的数组。 
	[G] CONVFMT 数字转换格式（默认值为%.6g）。 
	[P] ENVIRON 环境变量关联数组。 
	[N] ERRNO 最后一个系统错误的描述。 
	[G] FIELDWIDTHS 字段宽度列表（用空格键分隔）。 
	[A] FILENAME 当前输入文件的名。 
	[P] FNR 同NR，但相对于当前文件。 
	[A] FS 字段分隔符（默认是任何空格）。 
	[G] IGNORECASE 如果为真，则进行忽略大小写的匹配。 
	[A] NF 表示字段数，在执行过程中对应于当前的字段数。 
	[A] NR 表示记录数，在执行过程中对应于当前的行号。 
	[A] OFMT 数字的输出格式（默认值是%.6g）。 
	[A] OFS 输出字段分隔符（默认值是一个空格）。 
	[A] ORS 输出记录分隔符（默认值是一个换行符）。 
	[A] RS 记录分隔符（默认是一个换行符）。 
	[N] RSTART 由match函数所匹配的字符串的第一个位置。 
	[N] RLENGTH 由match函数所匹配的字符串的长度。 
	[N] SUBSEP 数组下标分隔符（默认值是34）。
	说明：[A][N][P][G]表示第一个支持变量的工具，[A]=awk、[N]=nawk、[P]=POSIXawk、[G]=gawk
		</pre>
		
	</div>
	<div class="operate">
		<!-- 关闭 -->
		<a class="main_button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_close"/></a>
	</div>
</div>

</body>
</html>
