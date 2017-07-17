<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <title></title>
  <link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
  <link href="${ctx}/mybi/pim/themes/${apptheme}/orgmaintain.css" rel="stylesheet" type="text/css"/>
  <link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
  <script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
  <script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
  <script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
  <link rel="stylesheet" href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
  <script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.core-3.2.min.js"></script>
  <script type="text/javascript" src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.exedit-3.2.min.js"></script>
  <script type="text/javascript">
    //ztree相关js
    var setting = {
      view: {
        dblClickExpand: false,
        selectedMulti:true,
        showIcon:true
      },
        
      edit: {
        enable: true,
        showRemoveBtn: false,
        showRenameBtn: false
      },
      
      data: {
        simpleData: {
          enable: true
        }
      },
      
      callback: {
        beforeDrag: beforeDrag,
        beforeDrop: beforeDrop
      }
    };

    var beforeDragTreeId = "";
    function beforeDrag(treeId, treeNodes) {
      beforeDragTreeId = treeId;
      for (var i=0,l=treeNodes.length; i<l; i++) {
        if (treeNodes[i].drag === false) {
          return false;
        }
      }
      return true;
    }
    
    function beforeDrop(treeId, treeNodes, targetNode, moveType) {
      if(treeId == "srcorgTree" && beforeDragTreeId != "srcorgTree"){
        //重新刷新源系统机构树
        refreshSrcOrgTree(maporgTree.transformToArray(treeNodes));
      }
    }
    
    /**
     * 刷新源系统机构树
     */
     function refreshSrcOrgTree(treeNodes){
       add_onload();//开启蒙板层
      
      //treeNodes是拖拽到来源系统机构树里机构对象数组，如果treeNodes里的机构和allNodes里的机构相同，那么排除在外
       var allNodes = maporgTree.transformToArray(maporgTree.getNodes());//取得映射框机构树下的全部节点
       var maporg = "";
       var nodes_tmp = new Array();

       for(var i = 0; i < allNodes.length; i++){   
             var flag = true;   
             for(var j = 0; j < treeNodes.length; j++){   
                 if(allNodes[i].id == treeNodes[j].id)   
                   flag = false;   
                 }   
             if(flag)nodes_tmp.push(allNodes[i].id);   
         }   
       
       for(var i = 0; i < nodes_tmp.length; i++){
         maporg += nodes_tmp[i] + ",";
       }
       
       var param = {
             orgidt:maporg, 
             "orgSrcSysObj.tabname":tabnameobj.TABNAME, 
             "orgSrcSysObj.rootnode":tabnameobj.ROOTNODE
          };
       $.post("pim_org-info!refreshSrcOrgTree.action", param, function(data){
         $.fn.zTree.init($("#srcorgTree"), setting, data);  
         clean_onload();//关闭蒙板层
       }, "json");
     }
    
    /**
     * 检索源系统机构
     */
     function selSrcsysOrg(){
      add_onload();//开启蒙板层
      if(tabnameobj == null || tabnameobj == ""){
        $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="org_please_select_srcsys"/>','info');
        clean_onload();//开启蒙板层
        return false;
      }
      
      var allNodes = maporgTree.transformToArray(maporgTree.getNodes());//取得树下的全部节点
      var maporg = "";
      for(var i = 0; i < allNodes.length; i++){
        maporg += allNodes[i].id + ",";
      }

      var param = {
            orgidt:maporg, 
            "orgSrcSysObj.tabname":tabnameobj.TABNAME, 
            "orgSrcSysObj.rootnode":tabnameobj.ROOTNODE 
          };
      $.post("pim_org-info!fuzzySelSrcOrg.action", param, function(data){
        $.fn.zTree.init($("#srcorgTree"), setting, data);  
        clean_onload();//关闭蒙板层
      }, "json");
     }
  </script>
  
  <script type="text/javascript">
    var tabnameobj = null;
    $(function(){
      $.ajaxSettings.async = false;
      //动作权限过滤
      actionAuthFilter();
      $.ajaxSettings.async = true;
      
      if(parent.getSelectedNode().manauto == "1"){
        $("div [actionCode=ACTION_ORGMAP_UPDMAP]").show();
      }else{
        $("div [actionCode=ACTION_ORGMAP_UPDMAP]").hide();
      }
      
      $("#tabname").combo({
        mode:'local',
        valueField:'SRCSYS',
        textField:'SYSDES',
        data : ${request.srcsysList},
        isCustom:true,
        customData:[{SRCSYS:'',SYSDES:'<s:text name="org_combo_please_select"/>'}],
        defaultValue:'${session.srcsys}',
        panelWidth:190,
        panelHeight:120,
        // 选择触发
          onSelect : function(r) {
            $.post("pim_org-info!saveTmpData.action",{srcsys:r.SRCSYS},function(data){});
            tabnameobj = r;
              //获取数据，初始化左侧ztree
              initSrcsysZtree(r, parent.getSelectedOrg());
          },
         
          // 数据加载成功触发
          onLoadSuccess : function(r){
            var objarr = $("#tabname").combo("getData");// 返回数据列表
            if($("#tabname").combo("getValue") != null && $("#tabname").combo("getValue") != "" && objarr.length > 0){
              for(var i = 0; i < objarr.length; i++){
                if(objarr[i]["SRCSYS"] == $("#tabname").combo("getValue")){
                  tabnameobj = objarr[i];
                  //获取数据，初始化左侧ztree
                    initSrcsysZtree(objarr[i], parent.getSelectedOrg());
                }
              }
            }
          }
      });
      
      $("#current_opt_org").html("<s:text name='org_map_current_org'/>：" + parent.getSelectedNode().name);
      
       //初始化机构控件
       $("#srcorg").orgselector({
	        targetid:"srcorg",
	        rootnode:getRootNode,
	        tabname : getTabnam,
	        framename: 'maintain_map_page', 
	        isMultiple : true, 
	        onBeforeClick: onBeforeClick,
	        onCallback:"refreshSrcorg"
      });
       
      $("#srcorg").keyup(function(event){
    	  if(event.keyCode == "13"){
    		  selSrcsysOrg();
    	  }
      });
      
      $.fn.zTree.init($("#srcorgTree"), setting);
      $.fn.zTree.init($("#maporgTree"), setting);
    });
    
    /**
     * 初始化源系统机构ztree和映射机构ztree
     */
     var srcorgTree, maporgTree;
     function initSrcsysZtree(obj, orgidt){
       if(obj.SRCSYS)add_onload();//开启蒙板层
       var param = {
           "orgSrcSysObj.srcsys":obj.SRCSYS,
           "orgSrcSysObj.rootnode":obj.ROOTNODE, 
           "orgSrcSysObj.tabname":obj.TABNAME, 
           "orgSrcSysObj.orgidt":orgidt
        };
       $.post("pim_org-info!getSrcsysOrgTree.action", param,function(data){
         $.fn.zTree.init($("#srcorgTree"), setting, data.srcorgtree);
         $.fn.zTree.init($("#maporgTree"), setting, data.maporgtree);
         srcorgTree = $.fn.zTree.getZTreeObj("srcorgTree");
         maporgTree = $.fn.zTree.getZTreeObj("maporgTree");
         clean_onload();//关闭蒙板层
       }, "json");
     }
     
     /**
      * 保存映射关系
      */
      function saveOrgMapRelation(){
        var orgidt = parent.getSelectedNode().id;
        var orgnam = parent.getSelectedNode().name;
        var allNodes = maporgTree.transformToArray(maporgTree.getNodes());//取得树下的全部节点
        var srcsys = $("#tabname").combo('getValue');
        var srcorg = "";
        for(var i = 0; i < allNodes.length; i++){
          srcorg += allNodes[i].id + "|";
        }
        
        var param = {
          "orgMapObj.srcsys":srcsys,
          "orgMapObj.tabnam":getTabnam(),
          "orgMapObj.orgidt":orgidt,
          "orgMapObj.srcorg":srcorg,
          "orgMapObj.orgnam":orgnam
        };
        
        $.messager.confirm("提示", "调整机构映射关系将会把此机构由自动化映射永久转为手工映射，是否确认？", function(){
          add_onload();//开启蒙板层
          $.post("pim_org-info!saveOrgMapRelation.action", param, function(data){
            if(data.result == "succ"){
              if(tabnameobj){
              	initSrcsysZtree(tabnameobj, parent.getSelectedOrg());
              }
              $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_succ"/>','info'); //操作成功
            }else{
              $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="common_msg_fail"/>','info'); //操作失败
            }
            clean_onload();//关闭蒙板层
          }, "json");
        });
      }
     
     /**
      * 模糊查映射机构
      */
      function selMapOrg(orgidt){
        orgidt = orgidt.toUpperCase();
        maporgTree.cancelSelectedNode();//取消当前所有选中的节点
        var allNodes = maporgTree.transformToArray(maporgTree.getNodes());//取得树下的全部节点
        if(orgidt != null && orgidt != ""){
          for(var i = 0; i < allNodes.length; i++){
          if(allNodes[i].id.indexOf(orgidt) > -1 || allNodes[i].name.indexOf(orgidt) > -1){
            maporgTree.selectNode(allNodes[i], true);
          }
          }
        }
      }
     
     /**
      * 弹出窗前执行的函数
      */
      function onBeforeClick(){
        if(getTabnam() == "" || typeof(getTabnam()) == "undefined"){
          $.messager.alert('<s:text name="common_msg_info"/>','<s:text name="org_please_select_srcsys"/>','info');
          return false;
        }else{
          return true;
        }
      }
    
     /**
      * 左移：源机构移动到映射机构
      */
      function moveLeft(){
        var nodes = srcorgTree.getSelectedNodes();
        if(nodes.length > 0){
          for(var i = 0; i < nodes.length; i++){
            srcorgTree.removeNode(nodes[i], false);
          }
          maporgTree.addNodes("", nodes, "");
        }
      }
     
     /**
      * 右移：映射机构移动到源机构
      */
      function moveRight(){
        var nodes = maporgTree.getSelectedNodes();
        if(nodes.length > 0){
          for(var i = 0; i < nodes.length; i++){
            maporgTree.removeNode(nodes[i], false);
          }
          srcorgTree.addNodes("", nodes, "");
          refreshSrcOrgTree(srcorgTree.transformToArray(srcorgTree.getNodes()));
        }
      }
     
      /**
       * 获取根节点机构
       */
      function getRootNode(){
        if(tabnameobj != null){
           return tabnameobj.ROOTNODE;
        }else{
          return "";
        }
      }
      
      /**
       * 获取表名
       */
      function getTabnam(){
        if(tabnameobj != null){
          return tabnameobj.TABNAME;
        }else{
          return "";
        }
      }
  </script>
  <style type="text/css">

  </style>
  </head>
  <body class="orgmap_body">
    <div class="myui-template-condition" style="width:850px;">
      <div class="orgmap_condition_div">
        <ul>
          <li style="width:18px;">&nbsp;</li>
          <li class="desc" id="current_opt_org" style="width:260px;text-align:left;"></li>
          <li class="desc" style="text-align:left;margin-left:117px;"><s:text name="org_map_srcsys"/>：</li>
          <li><input id="tabname" class="myui-text" style="width:190px;"/></li>
        </ul>
      </div>
    </div>
    <!-- 映射机构查询框 -->
    <div class="orgmap_sel_input">
      <span class="orgdesc2"><s:text name="org_map_orgmap"/>：</span>
      <span style="width:195px;" class="myui-search-outer">
        <input id="mapOrgInput" style="width:165px;" class="myui-text" title="<s:text name="org_map_support_orgororgnam_likesel"/>" />
        <a class="myui-search-ico" href="javascript:void(0);" onclick="selMapOrg($.trim($('#mapOrgInput').val()));"></a>
      </span>
    </div>
    <!-- 来源机构查询框 --
    <div class="orgmap_srcsys_input">
      <span class="orgdesc2"><s:text name="org_map_orgfrom"/>：</span>
      <span style="width:195px;" class="myui-search-outer">
        <input id="srcorg" class="myui-text" style="width:165px;" />
        <a class="myui-search-ico" href="javascript:void(0);" onclick="selSrcsysOrg();"></a>
      </span>
    </div>
    -->
    <div class="orgmap_srcsys_input">
      <span class="orgdesc2"><s:text name="org_map_orgfrom"/>：</span>
      <input id="srcorg" class="myui-text" style="width:195px;" />
    </div>
    <div class="content_wrap">
      <div class="orgdesc" style="margin-left: 20px;"></div>
      <div class="left">
        <ul id="maporgTree" class="ztree orgmap"></ul>
      </div>
      <div class="middle">
        <input type="button" class="move_left" onclick="moveLeft();" value="&nbsp;&nbsp;&nbsp;&nbsp;<s:text name='org_map_addmap'/>"/>
        <br/><br/>
        <input type="button" class="move_right" onclick="moveRight();" value="<s:text name='org_map_removemap'/>&nbsp;&nbsp;&nbsp;&nbsp;"/>
      </div>
      <div class="orgdesc" style="margin-left: 50px;"></div>
      <div class="right">
        <ul id="srcorgTree" class="ztree orgmap"></ul>
      </div>
    </div>
    
    <div class="myui-form">
      <div class="form">
        <div class="operate" style="display:none;" actionCode="ACTION_ORGMAP_UPDMAP">
          <a class="main_button" href="javascript:void(0);" onclick="saveOrgMapRelation();" style="margin-right:14px;"><s:text name="common_action_submit"/></a>
        </div>
      </div>
    </div>
  </body>
</html>