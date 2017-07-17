<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
    <link href="${ctx}/mybi/pim/themes/${apptheme}/orgmaintain.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
    <script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
    <script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
    <script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
    <script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
    <script type="text/javascript">
      $(function(){
        //动作权限过滤
        actionAuthFilter();
        
        $("#orglvl").combo({
          mode:'local',
          valueField:'ORGLVL',
          textField:'ORGLVLNAM',
          data:${request.orglvllist},
          isCustom:false,
          defaultValue:'${request.obj.orglvl}',
          panelHeight:150
        });  
        
        $("#status").combo({
          mode:'local',
          valueField:'value',
          textField:'text',
          panelHeight:100,
          data : [{value:'',text:'<s:text name="org_combo_please_select"/>'},{value:'1',text:'<s:text name="org_status_combo1"/>'},{value:'2',text:'<s:text name="org_status_combo2"/>'}],
          isCustom:false,
          defaultValue:'${request.obj.status}',
          panelHeight:80
        });
        
        $("#isstop").combo({
          mode:'local',
          valueField:'value',
          textField:'text',
          panelHeight:100,
          data : [{value:'',text:'<s:text name="org_combo_please_select"/>'},{value:'1',text:'<s:text name="org_common_yes"/>'},{value:'0',text:'<s:text name="org_common_no"/>'}],
          isCustom:false,
          defaultValue:'${request.obj.isstop}',
          panelHeight:80
        });
        
        $("#isbrh").combo({
          mode:'local',
          valueField:'value',
          textField:'text',
          panelHeight:100,
          data : [{value:'',text:'<s:text name="org_combo_please_select"/>'},{value:'1',text:'<s:text name="org_common_yes"/>'},{value:'0',text:'<s:text name="org_common_no"/>'}],
          isCustom:false,
          defaultValue:'${request.obj.isbrh}',
          panelHeight:80
        });
        
        $("#isbusdept").combo({
          mode:'local',
          valueField:'value',
          textField:'text',
          panelHeight:100,
          data : [{value:'',text:'<s:text name="org_combo_please_select"/>'},{value:'1',text:'<s:text name="org_common_yes"/>'},{value:'0',text:'<s:text name="org_common_no"/>'}],
          isCustom:false,
          defaultValue:'${request.obj.isbusdept}',
          panelHeight:80
        });
        
        $("#iscontry").combo({
          mode:'local',
          valueField:'value',
          textField:'text',
          panelHeight:100,
          data : [{value:'',text:'<s:text name="org_combo_please_select"/>'},{value:'1',text:'<s:text name="org_common_yes"/>'},{value:'0',text:'<s:text name="org_common_no"/>'}],
          isCustom:false,
          defaultValue:'${request.obj.iscontry}',
          panelHeight:80
        });
        
        $("#isimport").combo({
          mode:'local',
          valueField:'value',
          textField:'text',
          panelHeight:100,
          data : [{value:'',text:'<s:text name="org_combo_please_select"/>'},{value:'1',text:'<s:text name="org_common_yes"/>'},{value:'0',text:'<s:text name="org_common_no"/>'}],
          isCustom:false,
          defaultValue:'${request.obj.isimport}',
          panelHeight:80
        });
        
        $("#manauto").combo({
          mode:'local',
          valueField:'value',
          textField:'text',
          panelHeight:100,
          data : [{value:'0',text:'<s:text name="org_common_no"/>'}, {value:'1',text:'<s:text name="org_common_yes"/>'}],
          isCustom:false,
          defaultValue:'${request.obj.manauto}',
          panelHeight:80
        });
        
        $("#effdate").datebox({
          dateFormat : 'YYYYMMDD',
          defaultDate : '${obj.effdate}'
        });
        
        $("#enddate").datebox({
          dateFormat : 'YYYYMMDD',
          defaultDate : '${obj.enddate}'
        });
        
        $.formValidator.initConfig({formID:"form_input",
          //onError:function(){
            //return false;
          //},
          onError:function(msg){$.messager.alert('<s:text name="common_msg_info"/>', msg, 'info');},
          onSuccess:function(){
            
            var param = $("#form_input").serialize();
            var orglvl = $.trim($("#orglvl").combo("getValue"));
            var up_orgidt = $.trim($("#up_orgidt").val());
            orglvl = ((orglvl == "null" || orglvl == null) ? "" : orglvl);
            param += "&orgInfoObj.orglvl=" + orglvl;
            param += "&orgInfoObj.status=" + $("#status").combo("getValue");
            param += "&orgInfoObj.isstop=" + $("#isstop").combo("getValue");
            param += "&orgInfoObj.isbrh=" + $("#isbrh").combo("getValue");
            param += "&orgInfoObj.isbusdept=" + $("#isbusdept").combo("getValue");
            param += "&orgInfoObj.iscontry=" + $("#iscontry").combo("getValue");
            param += "&orgInfoObj.isimport=" + $("#isimport").combo("getValue");
            
            if(up_orgidt != "${obj.up_orgidt}"){
              $("#manauto").combo("setValue", "1");
              param += "&orgInfoObj.manauto=1";
              
              $.messager.confirm("提示", "调整上级机构将会把此机构由自动化转为手工维护，是否确认？", function(){
                add_onload();//开启蒙板层
                $.post("pim_org-info!updOrgInfo.action",param,function(data){ 
                  if(data.result=="succ"){
                    parent.loadZTree($("#orgidt").val());
                  }else if(data.result=="fail"){
                    $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info');
                  }
                  clean_onload();//关闭蒙板层
                  },"json");
              });
            }else{
              param += "&orgInfoObj.manauto=" + $("#manauto").combo("getValue");
              add_onload();//开启蒙板层
              $.post("pim_org-info!updOrgInfo.action",param,function(data){ 
                if(data.result=="succ"){
                  parent.loadZTree($("#orgidt").val());
                }else if(data.result=="fail"){
                  $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info');
                }
                clean_onload();//关闭蒙板层
                },"json"); 
            }
          }
        });
        
        $("#orgnam").formValidator({onFocus:""}).inputValidator({min:1,onError:"<s:text name='org_column_orgnam'/><s:text name='org_validate_required_field'/>"});
        $("#up_orgidt").formValidator({onFocus:""}).inputValidator({min:1,onError:"<s:text name='org_column_up_orgidt'/><s:text name='org_validate_required_field'/>"});
      
        findExtendCols("${orgidt}");
      });  
      
      /**
       * 查询扩展字段
       */
       function findExtendCols(orgidt){
        var param ={"orgInfoObj.orgidt":orgidt};
        $.getJSON("pim_org-info!findExtendCols.action", param, function(data){
          if(data.extcol.length > 0){
            var obj = data.obj;
            var datahtml = '';
            
            $(data.extcol).each(function(idx, item){
              if(idx % 2 == 0){
                datahtml += "<div class=item>";
              }
              var prop = obj[item.COL_CODE];
              datahtml += "<ul>";
              datahtml += "<li class=desc>" + item.COL_I18N + "：</li>";
              datahtml += "<li><input class=myui-text id=" + item.COL_CODE + " name=orgInfoObj." + item.COL_CODE + " maxlength=" + item.MAXLEN + "  value=" + prop + "></input></li>";
              datahtml += "</ul>";
              datahtml += "<ul><li style='width:90px;'>&nbsp;</li></ul>";
              
              if(idx % 2 == 1){
                datahtml += "</div>";
              }
            });
            
            $("#form_input").append(datahtml);
          }
        });  
       }
      
      /**
       * 根据输入的机构来模糊匹配机构并显示到下拉列表
       */
       function fuzzyMatchOrgByInput(obj){
        var org_input_offset = $(obj).offset();
        $("#org_fuzzy_match_div").css({left:org_input_offset.left + "px", top:org_input_offset.top + 24 + "px"}).show("fast");
        $("body").bind("mousedown", onBodyDown);
        
        var param = {"orgidt":$(obj).val()};
        $.getJSON("pim_org-info!fuzzyMatchOrgByInput.action", param,function(data){
          var html = "";
          if(data.datalist.length > 0){
            $(data.datalist).each(function(idx, item){
              html += "<option VALUE="+item["ORGIDT"]+" SHORTNAM="+item["SHORTNAM"]+">["+item["ORGIDT"]+"]"+item["ORGNAM"]+"</option>"
            });
          }
          $("#org_fuzzy_match_div SELECT").html(html);
        }).error(function(xhr,errorText,errorType){
              
          //关闭蒙板层
            tmp_component_after_load("datagrid");
          $.messager.alert('<s:text name="common_msg_info"/>',xhr.responseText,'info');//没有选择记录
            });
       }
      
       /**
         * 文档点击事件
         */
        function onBodyDown(event) {
        if (!(event.target.id == "org_fuzzy_match_div" || $(event.target).parents("#org_fuzzy_match_div").length > 0)) {
          $("#org_fuzzy_match_div").hide();
          $("body").unbind("mousedown", onBodyDown);
        }
        }
       
       /**
        * 隐藏机构联想div
        */
        function hideOrgDiv(obj){
          $("#up_orgidt").val($(obj).val());
          $("#org_fuzzy_match_div").hide();
          $("#org_fuzzy_match_div SELECT").html("");
        }
      
      /**
       * 表单提交
       */
      function sbt(){
        $("#form_input").submit();
      }
    </script>
  </head>
    <body class="orginfo_body">
      <div class="myui-form" style="height:650px;">
        <div class="form" style="height:100%;width:860px;overflow: auto;">
          <form id="form_input" method="post">
             <input type="hidden" id="orgidt" name="orgInfoObj.orgidt" value="${obj.orgidt}"/>
             <div class="item">
              <ul>
                <%--<li class="desc"><b>*</b>机构号：</li>--%>
                <li class="desc"><b>*</b><s:text name="org_column_orgidt"/>：</li>
                <li><input maxlength="16" readonly="readonly" disabled="disabled" value="${obj.orgidt}" class="myui-text"/></li>
              </ul>
              <ul><li style="width:90px;">&nbsp;</li></ul>
              <ul>
                <!-- <li class="desc"><b>*</b>机构名称：</li> -->
                <li class="desc"><b>*</b><s:text name="org_column_orgnam"/>：</li>
                <li><input id="orgnam" name="orgInfoObj.orgnam" maxlength="100" value="${obj.orgnam}" class="myui-text"/></li>
              </ul>
             </div>
             <div class="item">
              <ul>
                <!-- <li class="desc"><b>*</b>机构简称：</li> -->
                <li class="desc"><s:text name="org_column_short_nam"/>：</li>
                <li><input id="short_nam" name="orgInfoObj.short_nam" maxlength="100" value="${obj.short_nam}" class="myui-text"/></li>
              </ul>
              <ul><li style="width:90px;">&nbsp;</li></ul>
              <ul>
                <!-- <li class="desc"><b>*</b>上级机构：</li> -->
                <li class="desc"><b>*</b><s:text name="org_column_up_orgidt"/>：</li>
                <li><input id="up_orgidt" name="orgInfoObj.up_orgidt" maxlength="10" class="myui-text" value="${obj.up_orgidt}" onkeyup="fuzzyMatchOrgByInput(this);"/></li>
              </ul>
             </div>
             <div class="item">
              <ul>
                <!-- <li class="desc">机构层级：</li> -->
                <li class="desc"><b>*</b><s:text name="org_column_orglvl"/>：</li>
                <li><input id="orglvl" maxlength="4" class="myui-text"/></li>
                <li class="tipli"><div id="orglvlTip"></div></li>
              </ul>
              <ul><li style="width:90px;">&nbsp;</li></ul>
              <ul>
                <!-- <li class="desc">机构状态：</li> -->
                <li class="desc"><s:text name="org_column_status"/>：</li>
                <li><input id="status" maxlength="2" class="myui-text"/></li>
                <li class="tipli"><div id="statusTip"></div></li>
              </ul>
             </div>
             <div class="item">
              <ul>
                <!-- <li class="desc">生效日期：</li> -->
                <li class="desc"><s:text name="org_column_effdate"/>：</li>
                <li><input id="effdate" name="orgInfoObj.effdate" maxlength="8" value="${obj.effdate}" class="myui-text" style="height:22px;background-color: #FBFBFB;border: 1px #D2D2D2 SOLID;"/></li>
                <li class="tipli"><div id="effdateTip"></div></li>
              </ul>
              <ul><li style="width:90px;">&nbsp;</li></ul>
              <ul>
                <!-- <li class="desc">失效日期：</li> -->
                <li class="desc"><s:text name="org_column_enddate"/>：</li>
                <li><input id="enddate" name="orgInfoObj.enddate" maxlength="8" value="${obj.enddate}" class="myui-text" style="height:22px;background-color: #FBFBFB;border: 1px #D2D2D2 SOLID;"/></li>
                <li class="tipli"><div id="enddateTip"></div></li>
              </ul>
             </div>
             <div class="item">
              <ul>
                <!-- <li class="desc">是否停业：</li> -->
                <li class="desc"><s:text name="org_column_isstop"/>：</li>
                <li><input id="isstop" maxlength="2" class="myui-text"/></li>
                <li class="tipli"><div id="isstopTip"></div></li>
              </ul>
              <ul><li style="width:90px;">&nbsp;</li></ul>
              <ul>
                <!-- <li class="desc">是否为营业部：</li> -->
                <li class="desc"><s:text name="org_column_isbusdept"/>：</li>
                <li><input id="isbusdept" maxlength="2" class="myui-text"/></li>
                <li class="tipli"><div id="isbusdeptTip"></div></li>
              </ul>
             </div>
             <div class="item">
              <ul>
                <!-- <li class="desc">是否县支行：</li> -->
                <li class="desc"><s:text name="org_column_iscontry"/>：</li>
                <li><input id="iscontry" maxlength="2" class="myui-text"/></li>
                <li class="tipli"><div id="iscontryTip"></div></li>
              </ul>
              <ul><li style="width:90px;">&nbsp;</li></ul>
              <ul>
                <!-- <li class="desc">是否重点支行：</li> -->
                <li class="desc"><s:text name="org_column_isimport"/>：</li>
                <li><input id="isimport" maxlength="2" class="myui-text"/></li>
                <li class="tipli"><div id="isimportTip"></div></li>
              </ul>
             </div>
             <div class="item">
              <ul>
                <!-- <li class="desc">是否网点：</li> -->
                <li class="desc"><s:text name="org_column_isbrh"/>：</li>
                <li><input id="isbrh" maxlength="2" class="myui-text"/></li>
                <li class="tipli"><div id="isbrhTip"></div></li>
              </ul>
              <ul><li style="width:90px;">&nbsp;</li></ul>
              <ul>
                <!-- <li class="desc">维护类型：</li>  -->
                <li class="desc"><s:text name="org_column_auto" />：</li>
                <li><input id="manauto" class="myui-text"/></li>
                <li class="tipli"><div id="manautoTip"></div></li>
              </ul>
             </div>
             <br/>
             
             <!-- 扩展信息维护 -->
             <div class="orginfo_extinfo_div">&nbsp;&nbsp;<s:text name="org_info_extend_info_maintain"/></div>
               <div class="item">
                <ul>
                  <!-- <li class="desc">网点类型：</li> -->
                  <li class="desc"><s:text name="org_column_brhtyp"/>：</li>
                  <li><input id="brhtyp" name="orgInfoObj.brhtyp" maxlength="2" value="${obj.brhtyp}" class="myui-text"/></li>
                  <li class="tipli"><div id="brhtypTip"></div></li>
                </ul>
                <ul><li style="width:90px;">&nbsp;</li></ul>
                <ul>
                  <!-- <li class="desc">网点等级：</li> -->
                  <li class="desc"><s:text name="org_column_brhlvl"/>：</li>
                  <li><input id="brhlvl" name="orgInfoObj.brhlvl" maxlength="2" value="${obj.brhlvl}" class="myui-text"/></li>
                  <li class="tipli"><div id="brhlvlTip"></div></li>
                </ul>
               </div>
               <div class="item">
                 <ul>
                  <!-- <li class="desc">地区：</li> -->
                  <li class="desc"><s:text name="org_column_area"/>：</li>
                  <li><input id="area" name="orgInfoObj.area" maxlength="16" value="${obj.area}" class="myui-text"/></li>
                  <li class="tipli"><div id="areaTip"></div></li>
                </ul>
                <ul><li style="width:90px;">&nbsp;</li></ul>
                <ul>
                  <!-- <li class="desc">片区：</li> -->
                  <li class="desc"><s:text name="org_column_zone"/>：</li>
                  <li><input id="zone" name="orgInfoObj.zone" maxlength="16" value="${obj.zone}" class="myui-text"/></li>
                  <li class="tipli"><div id="zoneTip"></div></li>
                </ul>
               </div>
               <div class="item">
                <ul>
                  <!-- <li class="desc">考核分组：</li> -->
                  <li class="desc"><s:text name="org_column_eval_group"/>：</li>
                  <li><input id="eval_group" name="orgInfoObj.eval_group" maxlength="16" value="${obj.eval_group}" class="myui-text"/></li>
                  <li class="tipli"><div id="eval_groupTip"></div></li>
                </ul>
                <ul><li style="width:90px;">&nbsp;</li></ul>
                <ul>
                  <!-- <li class="desc">人行编码：</li> -->
                  <li class="desc"><s:text name="org_column_pboc_code"/>：</li>
                  <li><input id="pboc_code" name="orgInfoObj.pboc_code" maxlength="32" value="${obj.pboc_code}" class="myui-text"/></li>
                  <li class="tipli"><div id="pboc_codeTip"></div></li>
                </ul>
               </div>
               <div class="item">
                <ul>
                  <!-- <li class="desc">人行机构代码：</li> -->
                  <li class="desc"><s:text name="org_column_pboc_orgcde"/>：</li>
                  <li><input id="pboc_orgcde" name="orgInfoObj.pboc_orgcde" maxlength="32" value="${obj.pboc_orgcde}" class="myui-text"/></li>
                  <li class="tipli"><div id="pboc_orgcdeTip"></div></li>
                </ul>
                <ul><li style="width:90px;">&nbsp;</li></ul>
                <ul>
                  <!-- <li class="desc">人行机构名称：</li> -->
                  <li class="desc"><s:text name="org_column_pboc_orgnam"/>：</li>
                  <li><input id="pboc_orgnam" name="orgInfoObj.pboc_orgnam" maxlength="100" value="${obj.pboc_orgnam}" class="myui-text"/></li>
                  <li class="tipli"><div id="pboc_orgnamTip"></div></li>
                </ul>
               </div>
               <div class="item">
                <ul>
                  <!-- <li class="desc">城市代码：</li> -->
                  <li class="desc"><s:text name="org_column_citcde"/>：</li>
                  <li><input id="citcde" name="orgInfoObj.citcde" maxlength="10" value="${obj.citcde}" class="myui-text"/></li>
                  <li class="tipli"><div id="citcdeTip"></div></li>
                </ul>
                <ul><li style="width:90px;">&nbsp;</li></ul>
                <ul>
                  <!-- <li class="desc">地址：</li> -->
                  <li class="desc"><s:text name="org_column_addr"/>：</li>
                  <li><input id="addr" name="orgInfoObj.addr" maxlength="100" value="${obj.addr}" class="myui-text"/></li>
                  <li class="tipli"><div id="addrTip"></div></li>
                </ul>
               </div>
               <div class="item">
                <ul>
                  <!-- <li class="desc">邮编：</li> -->
                  <li class="desc"><s:text name="org_column_postcode"/>：</li>
                  <li><input id="postcode" name="orgInfoObj.postcode" maxlength="16" value="${obj.postcode}" class="myui-text"/></li>
                  <li class="tipli"><div id="postcodeTip"></div></li>
                </ul>
                <ul><li style="width:90px;">&nbsp;</li></ul>
                <ul>
                  <!-- <li class="desc">地图坐标X：</li> -->
                  <li class="desc"><s:text name="org_column_mapx"/>：</li>
                  <li><input id="mapx" name="orgInfoObj.mapx" maxlength="16" value="${obj.mapx}" class="myui-text"/></li>
                  <li class="tipli"><div id="mapxTip"></div></li>
                </ul>
               </div>
               <div class="item">
                <ul>
                  <!-- <li class="desc">地图坐标Y：</li> -->
                  <li class="desc"><s:text name="org_column_mapy"/>：</li>
                  <li><input id="mapy" name="orgInfoObj.mapy" maxlength="16" value="${obj.mapy}" class="myui-text"/></li>
                  <li class="tipli"><div id="mapyTip"></div></li>
                </ul>
                <ul><li style="width:90px;">&nbsp;</li></ul>
                <ul>
                  <!-- <li class="desc">地图标签位置：</li> -->
                  <li class="desc"><s:text name="org_column_maplabpos"/>：</li>
                  <li><input id="maplabpos" name="orgInfoObj.maplabpos" maxlength="16" value="${obj.maplabpos}" class="myui-text"/></li>
                  <li class="tipli"><div id="maplabposTip"></div></li>
                </ul>
               </div>
               <div class="item">
                <ul>
                  <!-- <li class="desc">地图区域标识：</li> -->
                  <li class="desc"><s:text name="org_column_mapfieno"/>：</li>
                  <li><input id="mapfieno" name="orgInfoObj.mapfieno" maxlength="16" value="${obj.mapfieno}" class="myui-text"/></li>
                  <li class="tipli"><div id="mapfienoTip"></div></li>
                </ul>
                <ul><li style="width:90px;">&nbsp;</li></ul>
                <ul>
                  <!-- <li class="desc">地图信息3：</li>-->
                  <li class="desc"><s:text name="org_column_mapinfo3"/>：</li>
                  <li><input id="mapinfo3" name="orgInfoObj.mapinfo3" maxlength="16" value="${obj.mapinfo3}" class="myui-text"/></li>
                  <li class="tipli"><div id="mapinfo3Tip"></div></li>
                </ul>
              </div>
           </form>
        </div>
        <div class="operate" style="display:none;" actionCode="ACTION_ORGMGE_UPDINFO">
          <a class="myui-button-query-main" href="javascript:void(0);" onclick="sbt();"><s:text name="common_action_submit"/></a>
        </div>
      </div>
      
      <!-- 机构下拉联想列表 -->
      <div id="org_fuzzy_match_div" class="orginfo_fuzzy_match_div">
        <select size="10" onclick="hideOrgDiv(this);"></select>
      </div>
    </body>
</html>  