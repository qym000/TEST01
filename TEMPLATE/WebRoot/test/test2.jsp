<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
        $(function(){
                $("#scop").datebox({
                        calendarType : "quarter",
                        defaultDate : '${lastQuarter}'
                });
                //渲染开始日期控件
                $("#startdate").datebox({
                        dateFormat:'YYYYMMDD',
                        scrollTarget :'body'
                });
                //渲染结束日期控件
                $("#enddate").datebox({
                        dateFormat:'YYYYMMDD'
                });
                
                $("#monedorgs").orgselector({
                        targetid:"monedorgs",
                        winnam:"orgwin",
                        //defaultValue:'${defaultOrgidt}',
                        isMultiple:true,
                        withAuth:true
                });
                $.formValidator.initConfig({formID:"form_input",
                        onError:function(){
                                return false;
                        },
                        onSuccess:function(){
                                var param={
                                                "obj.tasknam":$.trim($("#tasknam").val()),
                                                "obj.scop":$("#scop").datebox("getValue"),
                                                "obj.cycle":$($("input[type=radio][checked]")[0]).val(),
                                                "obj.startdate" : $("#startdate").val(),
                                                "obj.enddate" : $("#enddate").val() 
                                };
                                add_onload();//开启蒙板层
                                $.post("mon-task!saveMonTaskObj.action",param,function(data){ 
                                        if(data.result=="succ"){
                                                parent.findObj(data.callbackCondition); //回显刚才操作的记录
                                                parent.initPage();
                                                $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addsucc"/>','info',clsWin);
                                        }else if(data.result=="fail"){
                                                $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_addfail"/>','info');
                                        }
                                        
                                        clean_onload();//关闭蒙板层
                            },"json");
                        }
                });
                $("#tasknam").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
                $("#scop").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
                $("#startdate").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
                $("#enddate").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
                $("#monedorgs").formValidator({onFocus:""}).inputValidator({min:1,onError:'<s:text name="common_msg_formvalidte_required"/>'});
        });
        
        //表单提交
        function sbt(){
                $("#form_input").submit();
        }
        
        //
        function cycleChg(){
                var cycle = $($("input[name='cycle']:checked")[0]).val();
                if("Q" == cycle){
                        //渲染开始日期控件
                        $("#scop").datebox({
                                dateFormat:'YYYYMMDD'
                        });
                }else if("H" == cycle){
                        //渲染开始日期控件
                        $("#scop").datebox({
                                calendarType : "halfyear",
                                buttons : true
                        });
                }else if("Y" == cycle){
                        alert("Y");     
                }  
        }
        
        //关闭当前窗口
    function clsWin(){
        parent.$('#inputWin').window('close');
    }
</script>
</head>
<body>

<div class="myui-form">
        <div class="form">
                <form id="form_input" method="post">
                         <div class="item">
                                <ul>
                                        <li class="desc"><b>* </b>任务名称：</li>
                                        <li><input id="tasknam" name="tasknam" maxlength="30" class="myui-text"/></li>
                                        <li class="tipli"><div id="tasknamTip"></div></li>
                                </ul>
                         </div>
                         <div class="item">
                                <ul>
                                        <li class="desc"><b>* </b>检查频度：</li>
                                        <li><input  type=radio name="cycle" value="Q" checked onclick="javascript:cycleChg();"/>季  <input  type=radio name="cycle" value="H" onclick="javascript:cycleChg();"/>半年  <input  type=radio name="cycle" value="Y" onclick="javascript:cycleChg();"/>年</li>
                                        <li class="tipli"><div id="cycleTip"></div></li>
                                </ul>
                         </div>  
                         <div class="item">
                                <ul>
                                        <li class="desc"><b>* </b>数据范围：</li>
                                        <li><input id="scop" name="scop" class="myui-text"/></li>
                                        <li class="tipli"><div id="scopTip"></div></li>
                                </ul>
                         </div>
                         <div class="item">
                                <ul>
                                        <li class="desc"><b>* </b>开始日期：</li>
                                        <li><input id="startdate" name="startdate"  value="" maxlength="30" class="myui-text" /></li>
                                        <li class="tipli"><div id="startdateTip"></div></li>
                                </ul>
                         </div>
                         <div class="item">
                                <ul>
                                        <li class="desc"><b>* </b>结束日期：</li>
                                        <li><input id="enddate" name="enddate"  value="" maxlength="30" class="myui-text" /></li>
                                        <li class="tipli"><div id="enddateTip"></div></li>
                                </ul>
                         </div>
                         <div class="item">
                                <ul>
                                        <li class="desc"><b>* </b>被检查机构：</li>
                                        <li><input id="monedorgs" name="monedorgs"  value="" maxlength="30" class="myui-text" /><div id="orgwin"></li>
                                        <li class="tipli"><div id="monedorgsTip"></div></li>
                                </ul>
                         </div>
                 </form>
        </div>
        <div class="operate">
                <a class="main_button" href="javascript:void(0);" onclick="sbt()"><s:text name="common_action_submit"/></a>
                <a class="button" href="javascript:void(0);" onclick="clsWin()" style="margin-right:20px;"><s:text name="common_action_cancle"/></a>
        </div>
</div>

</body>

</html>