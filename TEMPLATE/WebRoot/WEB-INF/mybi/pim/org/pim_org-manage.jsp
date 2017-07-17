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
    <link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.core-3.2.min.js"></script>
    <script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.exedit-3.2.min.js"></script>
    <script type="text/javascript">
      //ztree相关的js
      var setting = {
        view: {
          dblClickExpand: false,
          selectedMulti:false,
          showIcon:true
        },
        
        data: {
          simpleData: {
            enable: true
          }
        },
        
        edit:{
          enable:false,
          showRemoveBtn:false,
          showRenameBtn:false,
          drag:{
            isMove:false
          }
        },
        
        callback: {
          onClick: onClick,
          beforeDrag: beforeDrag,
          beforeDrop: beforeDrop
        }
      };
      
      /**
       *功能检索
       */
       function selOrgFromOrgTree(orgidt){
        zTree.cancelSelectedNode();//取消当前所有选中的节点
        var allNodes = zTree.transformToArray(zTree.getNodes());//取得树下的全部节点
        for(var i = 0; i < allNodes.length; i++){
          if(orgidt != null && orgidt != "" && allNodes[i].id == orgidt){
            zTree.selectNode(allNodes[i], true);
            treeNode_ = allNodes[i];
            setting.callback.onClick();
          }
        }
       }
      
      /**
       * 获取选中的机构
       */
       function getSelectedOrg(){
        return zTree.getSelectedNodes()[0].id;
       }
      
       /**
        * 获取选中的机构
        */
       function getSelectedNode(){
        return zTree.getSelectedNodes()[0];
       }
      
      /**
       * 拖拽前
       */
       function beforeDrag(treeId, treeNodes) {
        if(treeNodes.length > 1){
          $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="org_please_select_one_org"/>','info');
          return false;
        }
        
        if (treeNodes[0].drag === false) {
          return false;
        }
        return true;
      }
      
      /**
       * 放下前
       */
       function beforeDrop(treeId, treeNodes, targetNode, moveType) {
        if(treeNodes[0].pId == targetNode.id){
          return false;
        }else{
          $.getJSON("pim_org-info!updOneOrgUporg.action",{orgidt:treeNodes[0].id, old_up_orgidt:treeNodes[0].pId, up_orgidt:targetNode.id, orgnam:treeNodes[0].name},function(data){});
        }
      }
      
      /**
       * 点击事件
       */
      var treeNode_ = null;
      function onClick(e, treeId, treeNode) {
        treeNode_ = treeNode;
        nodes = zTree.getSelectedNodes();
        var tabsel = $(".tab-selected").length;
        if(tabsel){
          var origsrc = $(".tabs iframe").eq(0).attr("src");
          if(origsrc.indexOf("?") > 0){
            origsrc = origsrc.substr(0, (origsrc.indexOf("?") + 1)) + "orgInfoObj.orgidt=" + nodes[0].id;
          }else{
            origsrc = origsrc + "?orgInfoObj.orgidt=" + nodes[0].id;
          }
          $(".tabs iframe").eq(0).attr("src", origsrc);
        }else{
          //默认选中第一个
          //设置选中
          validOrgTreeNodeIsChecked("orgwh");
          setTabSelectedByTab($("#orgwh"));
        }
      }
      
      /**
       * 添加机构
       */
       function addOrg(){
         if(treeNode_ == null){
            $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="org_please_select_one_org"/>','info');
            return false;
         }else{
           $("#inputWin").window({
            open : true,
            headline:'<s:text name="org_info_add_headline"/>',
            content:'<iframe id="myframe" src=pim_org-info!toaddOrgPage.action?up_orgidt='+treeNode_.id+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
            panelWidth:550,
            panelHeight:350
           });
        }
       }
      
      /**
       * 删除某个机构
       */
       function delOrg(){
        if(treeNode_ == null){
          $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="org_please_select_one_org"/>','info');
          return false;
        }
        
        if(typeof(treeNode_.children) != "undefined" && treeNode_.children.length > 0){
          $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="org_please_del_child_org"/>','info');
          return false;
        }else{
           $.messager.confirm('<s:text name="common_msg_info"/>', '<s:text name="org_confirm_del_selected_org"/>', function(){
             add_onload();//开启蒙板层
             var param = {
                      "orgInfoObj.orgidt":treeNode_.id,
                      "orgInfoObj.orgnam":treeNode_.name
                    }; 
             $.post("pim_org-info!delOrgInfoObj.action", param,function(data){ 
                if(data.result=="succ"){
                  	var allNodes = zTree.transformToArray(zTree.getNodes());//取得树下的全部节点
                  	if(allNodes.length){
                  		treeNode_ = allNodes[0];
                  		loadZTree(allNodes[0]["id"]);
                  	}else{
                  		loadZTree("");
                  	}
                  	clean_onload();
	              }else if(data.result=="fail"){
	                  clean_onload();
	                  $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info'); //操作失败
	              }
             },"json");
          });
        }
       }
      
      /**
       * 加载机构树
       */
      var zTree;
      function loadZTree(orgidt){
        add_onload();//开启蒙板层
        
        var param = {
            "orgInfoObj.manauto":$("#seltyp").combo("getValue")
        };
        $.getJSON("pim_org-info!getOrgidtTree.action", param, function(data){
          $.fn.zTree.init($("#orgTreeContainer"), setting, data);
          zTree = $.fn.zTree.getZTreeObj("orgTreeContainer");
          zTree.cancelSelectedNode();//取消当前所有选中的节点
          
          if(orgidt != null && orgidt != ""){
            //检索到该机构
            selOrgFromOrgTree(orgidt);
          }
          clean_onload();//关闭蒙板层
        });
      }
      
      $(document).ready(function(){
        //功能导航
        loadLocationLeading("${authMenuId}","${session.i18nDefault}");
        
        //动作权限过滤
        actionAuthFilter();
        
        $("#seltyp").combo({
          mode : "local",
          data : [{text:"全部",value:""},{text:"手工维护",value:"1"}],
          panelHeight : 50,
          isCustom : true,
          onSelect:function(r){
            loadZTree("");
          }
        });
        
        loadZTree("");
      });
    </script>
    
    <script type="text/javascript">
      /**
       * 判断机构树是否选中某个机构
       */
       function validOrgTreeNodeIsChecked(type){
        var nodes = zTree.getSelectedNodes();
        if(nodes.length != 1){
          $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="org_please_select_one_org"/>','info');
          return false;
        }else{
          var url = "pim_org-info!toOrgMaintainManage.action?authMenuId=${authMenuId}&orgInfoObj.orgidt=" + nodes[0].id;
          if(type == "orgwh"){
            url = "pim_org-info!toOrgMaintainManage.action?authMenuId=${authMenuId}&orgInfoObj.orgidt=" + nodes[0].id;
          }else if(type == "orgmap"){
            url = "pim_org-info!toOrgMapManage.action?authMenuId=${authMenuId}&";
          }
          
          //$(event.target).parent().parent().parent().children('.tabcontent').eq($(event.target).attr('ind')).children('iframe').attr('src', url);
          var obj = $("#"+type);
          //获取对象
          var conttt = getContentByTab(obj);
          $(conttt).children("iframe").attr("src",url);
          return true;
        }
      }
      
      /**
       * 根据输入的机构来模糊匹配机构并显示到下拉列表
       */
       function fuzzyMatchOrgByInput(obj){
        var org_input_offset = $(obj).offset();
        $("#org_fuzzy_match_div").css({left:org_input_offset.left + "px", top:org_input_offset.top + 24 + "px"}).show("fast");
        $("body").bind("mousedown", onBodyDown);
        
        $.getJSON("pim_org-info!fuzzyMatchOrgByInput.action",{orgidt:$(obj).val()},function(data){
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
          $("#orgidt").val($(obj).val());
          $("#org_fuzzy_match_div").hide();
          $("#org_fuzzy_match_div SELECT").html("");
          selOrgFromOrgTree($("#orgidt").val());
        }
       
       /**
        * 导出机构数据
        */
        function expOrgData(){
         //监控导出状态
           monitorExportStatus('pim_sys-user!monitorExportStatus.action');
         window.location.href = "pim_org-exp-imp!expOrgData.action"; 
        }
       
       /**
        * 刷新源系统机构树
        */
       function refreshSrcorg(){
         //window.maintain_map_page.selSrcsysOrg();
         document.getElementById('maintain_map_page').contentWindow.selSrcsysOrg();
       }
       
       /**
        * 导入数据
        */
        function impOrgData(){
         $("#inputWin").window({
          open : true,
          headline:'<s:text name="org_info_imp_headline"/>',
          content:'<iframe id="myframe" src=pim_org-exp-imp!toImpOrgManage.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
          panelWidth:550,
          panelHeight:300
         });
        }
    </script>
  </head>
    <body style="overflow: hidden;">
      <!-- 添加窗口 -->
      <div id="inputWin"></div>
      
      <!-- 机构选择窗口 -->
      <div id="orgSelectorWin"></div>
      
      <!-- 机构智能匹配列表 -->
      <div id="org_fuzzy_match_div" class="org_fuzzy_match_div">
        <select size="10" onclick="hideOrgDiv(this);"></select>
      </div>
      
      <div class="myui-layout">
        <div class="rowgroup">
          <div class="content" style="width:350px;height:730px;" title="<s:text name='org_manage'/>">
            <div class="operate">
              <ul>
                <li><a href="javascript:void(0);" onclick="addOrg();" actionCode="ACTION_ORGMGE_SAV" style="display:none;"><s:text name="org_info_add"/></a></li>
                      <li><a href="javascript:void(0);" onclick="delOrg();" actionCode="ACTION_ORGMGE_DEL" style="display:none;"><s:text name="org_info_del"/></a></li>
                      <li><a href="javascript:void(0);" onclick="expOrgData();" actionCode="ACTION_ORGMGE_EXP" style="display:none;"><s:text name="org_info_exp"/></a></li>
                      <li><a href="javascript:void(0);" onclick="impOrgData();" actionCode="ACTION_ORGMGE_IMP" style="display:none;"><s:text name="org_info_imp"/></a></li>
              </ul>
            </div>
              
            <div class="orgidt_input_select_input_div">
              <input id="seltyp" class="myui-text" style="width:80px;"/>
              <span style="width: 255px;" class="myui-search-outer">
                <input id="orgidt" class="myui-text" style="width:225px;" onkeyup="zTree.expandAll(false);fuzzyMatchOrgByInput(this);" />
                <a class="myui-search-ico" href="javascript:void(0);" onclick="loadZTree($('#orgidt').val());"></a>
              </span>
              
            </div>
            <div style="width:345px;height:665px;margin-top:3px;overflow: auto;">
              <ul id="orgTreeContainer" class="ztree""></ul>
            </div>
          </div>
          
          <div class="tabs" style="width:866px;height:730px;overflow: hidden;">
            <div id="orgwh" class="tabcontent" onclick="validOrgTreeNodeIsChecked('orgwh');" title="<s:text name='org_info'/>">
              <iframe src="" frameborder="0" scrolling="no"></iframe>
            </div>
            <div id="orgmap" class="tabcontent" onclick="validOrgTreeNodeIsChecked('orgmap');" title="<s:text name='org_map_info'/>">
              <iframe id="maintain_map_page" name="maintain_map_page" src="" frameborder="0" scrolling="no"></iframe>
            </div>
            <div id="orglog" class="tabcontent" title="<s:text name='org_chglog'/>">
              <iframe src="pim_org-chglog!toManage.action" frameborder="0" scrolling="no"></iframe>
            </div>
          </div>
        </div>
      </div>
  </body>
</html>  