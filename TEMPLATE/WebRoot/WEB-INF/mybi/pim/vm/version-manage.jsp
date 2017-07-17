<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<link rel="shortcut icon" href="${ctx}/appcase/builtin/images/ico.ico" type="image/x-icon" />
		<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css" rel="stylesheet" type="text/css"/>
		<link href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css" rel="stylesheet" type="text/css"/>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.js"></script> 
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/formValidatorRegex.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
		<script type="text/javascript" src="${ctx}/mybi/common/scripts/jQuery.md5.js"></script>
		<style type="text/css">
		.superlink {
			color: #0066cc;
			text-decoration: underline;
			cursor: pointer;
			text-align: left;
		}
		
		.superlink:hover {
			color: #eb6100;
		}
		</style>
		<script type="text/javascript">
		$(function(){
			//菜单导航
			loadLocationLeading("${authMenuId}","${session.i18nDefault}");
			chkVersion();
		});
		
		/**
		 * 获取已安装组件清单
		 */
		 function getInstalledVersion(datalist){
			//开启蒙板层
			tmp_component_before_load("datagrid");
			var html = "";
			$.each(datalist, function(idx, item){
				html += "<tr>";
				html += "<td id=" + item.code + ">" + item.name + "</td>";
				html += "<td>" + item.version + "</td>";
				html += "<td align='center'><span class='superlink' onclick='toComponentUpdateManage(\""+item.id+"\", \""+item.code+"\");'>升级</span>";
				html += "&nbsp;&nbsp;&nbsp;";
				html += "<span class='superlink' onclick='updLog(\""+item.id+"\", \""+item.code+"\");'>升级记录</span>"; 
				html += "&nbsp;&nbsp;&nbsp;";
				html += "<span class='superlink' onclick='backuplog(\""+item.id+"\", \""+item.code+"\");'>备份</span>";
				html += "&nbsp;&nbsp;&nbsp;";
				html += "<span class='superlink' onclick='toRecoveryManage(\""+item.id+"\", \""+item.code+"\");'>回退版本</span>";
				if(item.code != "template"){
					html += "&nbsp;&nbsp;&nbsp;";
					html += "<span class='superlink' onclick='uninstall(\""+item.id+"\", \""+item.code+"\");'>卸载</span>";
				}
				html += "</td>";
				html += "</tr>";
			});
			$("#databody").html(html);
			setTableColor("version_table", "", "", "#FFFF66");
			$("#databody tr").click(function(){
				var code = $(this).find("td:eq(0)").attr("id");
				chkFileVersion(code, code);
			});
			
			$(".superlink").click(function(event){
				event.stopPropagation();
			});
			tmp_component_after_load("datagrid");
		 }

	  /**
        *table变色方法 
        *@param tableId 需要设置变色的table的ID
        *@param overColor 鼠标经过(悬浮在此行上)的颜色
        *@param outColor 鼠标离开此行后的颜色
        *@param clickColor 鼠标单击此行的颜色
        */
        function setTableColor(tableId, overColor,outColor, clickColor) {
           //获取此table里的tr数组
           var trs = document.getElementById(tableId).getElementsByTagName("tr");
           //单击行
           var clickTR=null;
           //遍历tr数组
           for ( var i = 0; i < trs.length; i++) {
              //绑定单击事件
              trs[i].onclick = function() {
                      //this.x这里的isClick是自己指定的,只是为了标识此行是否被单击过了true为单击了,false为未单击
                      if (this.isClick != true) {
                              //如果此行为单击,则设置为已单击
                              this.isClick=true;
                              //clickTR是之前单击行的对象,判断是否为空(即该table未被单击过),是否是当前对象(单击的是否是已单击过的)
                              if(clickTR!=null&&clickTR!=this){
	                               //如果都不是,则设置clickTR颜色为背景色(鼠标离开行的颜色),并且是指此行为未单击
	                               clickTR.isClick=false;
	                               clickTR.style.backgroundColor = outColor;
                              }
                              //设置this(当前单击行对象)的背景色为指定的单击颜色
                              this.style.backgroundColor = clickColor;
                              //保存当前单击对象
                              clickTR=this;
                      } else {
                              //如果单击的是已经单击的对象,则视为取消单击
                              this.isClick=false;
                      }
              }
              //绑定鼠标悬浮行事件
              trs[i].onmouseover = function() {
                   if (this.isClick!=true)//如果是未单击则设置背景色为鼠标悬浮行颜色
                           this.style.backgroundColor = overColor;
              }
              //鼠标离开行事件
              trs[i].onmouseout = function() {
                  if (this.isClick!=true)//如果是未单击则设置背景色为鼠标离开行颜色
                          this.style.backgroundColor = outColor;
              }
           }
        }
		
		/**
		 * 检测工作空间路径是否为空
		 */
		function chkWorkspacePath(){
			var workspace = $.trim($("#workspace").val());
			if(workspace == null || workspace == ""){
				$.messager.alert("提示", "当前工作空间路径不能为空", "info");
				return false;
			}else{
				return true;
			}
		}
		
		/**
		 * 检测版本号
		 */
		 function chkVersion(){
			 var flag = chkWorkspacePath();
			 if(flag){
				 var workspace = $.trim($("#workspace").val());
				 var param = {
						 "obj.workspace" : workspace
				 };
				 add_onload();
				 $.post("vm_version!chkVersion.action", param, function(data){
					 if(data.result == "succ"){
						 getInstalledVersion(data.list);
					 }else{
						 $.messager.alert("提示", "检测版本失败", "info");
					 }
					 clean_onload();
				 }, "json").error(function(xhr, errorText, errorType){
					clean_onload();
				  	$.messager.alert("提示", xhr.responseText||errorText, "info");
		         });
			 }
		}
		
		/**
		 * 安装升级
		 */
		 function toComponentUpdateManage(id, code){
			var workspace = $.trim($("#workspace").val());
			var param = {
					"obj.id":id,
					"obj.code":code,
					"obj.workspace":workspace
			};
			var url = "vm_version!toComponentUpdateManage.action?" + $.param(param);
			 $("#inputWin").window({
			    open : true,
			    headline:'选择安装包',
			    content:'<iframe id="myframe" src='+url+' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
			    panelWidth:430,
			    panelHeight:260
			 });
		 }
		
		/**
		 * 校验文件版本
		 */
		 function chkFileVersion(id, code){
			if(code == "myetl"){
				$("#inputWin").window({
					open : true,
					headline:'升级日志',
					content:'<iframe id="myframe" src=vm_version!toUpdLogManage.action?log.code=' + code + ' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
					panelWidth:800,
					panelHeight:600
				});
			}else{
				var flag = chkWorkspacePath();
				if(!flag) return false;
				var workspace = $.trim($("#workspace").val());
				var param = {
						"obj.id":id,
						"obj.code":code,
						"obj.workspace":workspace
				};
				var html = "";
				tmp_component_before_load("datagrid");
				$.post("vm_version!chkFileVersion.action", param, function(data){
					if (data.result == "succ") {
						$.messager.alert("提示", "校验完毕，版本相符", "info", function(){
							$("#databody2").html("<tr><td>当前版本相符</td></tr>");
						});
					} else {
						$.messager.alert("提示", "校验完毕，有" + data.cnt + "个文件版本不符", "info");
						$.each(data.filemap, function(key, val){
							html += "<tr><td>" + val + "</td></tr>";
						});
						$("#databody2").html(html);
					}
					tmp_component_after_load("datagrid");
				}, "json").error(function(xhr, errorText, errorType){
					$.messager.alert('提示', xhr.responseText, "info", function(){
						$("#databody2").html(html);
						tmp_component_after_load("datagrid");
					});
	            });
			}
		 }
		
		/**
		 * 升级记录
		 */
		 function updLog(id, code){
			 $("#inputWin").window({
				open : true,
				headline:'升级日志',
				content:'<iframe id="myframe" src=vm_version!toUpdLogManage.action?log.code=' + code + ' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:800,
				panelHeight:600
			});
		 }
		
		/**
		 * 升级选中的文件
		 */
		 function updVersionFile() {
			var chkeditem = $("input[name='checkboxitem']:checked");
			if(chkeditem.length == 0){
				$.messager.alert("提示", "未选中任何文件", "info");
				return false;
			}
			
			$.messager.confirm("提示", "确认升级选中的文件吗？", function(){
				var workspace = $.trim($("#workspace").val());
				var ids = getIdFieldsOfChecked();
				var param = {
						"obj.code":$("#updbtn").attr("code"),
						"obj.workspace":workspace,
						"ids":ids
				};
				add_onload();
				$.post("vm_version!updVersionFile.action", param, function(data){
					if(data.result == "succ"){
						$.messager.alert("提示", "升级成功", "info", function(){
							chkVersion();
							$("#databody3").html("");
						});
					}else{
						$.messager.alert("提示", "升级失败", "info");
					}
					clean_onload();
				}, "json").error(function(xhr, errorText, errorType){
					clean_onload();
					$.messager.alert('提示', xhr.responseText, "info");
				});
		 	});
		}
		
		/**
		 * 项目版本与安装包版本对比结果
		 */
		 function compareResult(obj){
			var html = "";
			if(Object.keys(obj).length > 0){
				$.each(obj, function(key, value){
					if(value == "del"){
						html += "<tr><td><input type='checkbox' name='checkboxitem' checked value='" + key + "=" + value + "'></td><td>" + key + "</td><td>删除</td></tr>"
					}else if(value == "upd"){
						html += "<tr><td><input type='checkbox' name='checkboxitem' checked value='" + key + "=" + value + "'></td><td>" + key + "</td><td>修改</td></tr>"
					}else if(value == "new"){
						html += "<tr><td><input type='checkbox' name='checkboxitem' checked value='" + key + "=" + value + "'></td><td>" + key + "</td><td>新增</td></tr>"
					}
				});
			} else {
				html += "<tr><td colspan='3'>未检测出要升级的文件</td></tr>";
			}
			$("#databody3").html(html);
		 }
		
		 /**
		  * 备份日志填写
		  */
		  function backuplog(id, code){
			 var param = {
					 "obj.id":id,
					 "obj.code":code
			 };
			 
			 $("#inputWin").window({
				open : true,
				headline:'备份日志填写',
				content:'<iframe id="myframe" src=vm_version!toBackupLogManage.action?' + $.param(param) + ' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:600,
				panelHeight:270
			});
		  }
		 
		 /**
		  * 备份版本
		  */
		  function bakup(id, code, baklog){
			  var workspace = $.trim($("#workspace").val());
			  var param = {
					"obj.id":id,
					"obj.code":code,
					"obj.workspace":workspace,
					"obj.baklog":baklog
			  };
			  
			  $.messager.confirm("提示", "确认备份当前版本吗?", function(){
				$('#inputWin').window('close');
				add_onload();
			 	$.post("vm_version!bakup.action", param, function(data){
				 	if(data.result == "succ"){
				 		$.messager.alert("提示", "备份成功", "info", chkVersion);
				 	}else{
				 		$.messager.alert("提示", "备份失败", "info");
				 	}
				 	clean_onload();
			 	}, "json").error(function(xhr, errorText, errorType){
			 		clean_onload();
					$.messager.alert('提示', xhr.responseText, "info");
	            });
			});
		 }
		 
		 /**
		  * 打开要恢复的版本选择界面
		  */
		 function toRecoveryManage(id, code){
			 var param = {
				"obj.id":id,
				"obj.code":code
			 };
			 
			 $("#inputWin").window({
				open : true,
				headline:'版本恢复选择',
				content:'<iframe id="myframe" src=vm_version!toRecoveryManage.action?' + $.param(param) + ' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:500,
				panelHeight:500
			});
		 }
		 
		 /**
		  * 恢复版本
		  */
		  function recovery(id, code, bakpath){
			  var workspace = $.trim($("#workspace").val());
			  var param = {
					"obj.id":id,
					"obj.code":code,
					"obj.workspace":workspace,
					"obj.timestamp":bakpath
			  };
			  
			  $("#inputWin").window("close");
			  add_onload();
		 	  $.post("vm_version!recovery.action", param, function(data){
			 	if(data.result == "succ"){
			 		$.messager.alert("提示", "恢复成功，请刷新您的项目", "info", chkVersion);
			 	}
			 	clean_onload();
		 	  }, "json").error(function(xhr, errorText, errorType){
		 		clean_onload();
				$.messager.alert('提示', xhr.responseText, "info");
             });
		  }
		 
		 /**
		  * 卸载
		  */
		 function uninstall(id, code){
			var workspace = $.trim($("#workspace").val());
			var param = {
					"obj.id":id,
					"obj.code":code,
					"obj.workspace":workspace
			};
			$.messager.confirm("提示", "确认卸载吗?", function(){
				add_onload();
			 	$.post("vm_version!uninstall.action", param, function(data){
				 	if(data.result == "succ"){
				 		$.messager.alert("提示", "卸载成功，请刷新您的项目", "info", chkVersion);
				 	}else{
				 		$.messager.alert("提示", "卸载失败", "info");
				 	}
				 	clean_onload();
			 	}, "json").error(function(xhr, errorText, errorType){
			 		clean_onload();
					$.messager.alert('提示', xhr.responseText, "info");
	            });
			});
		 }
		 
		 /**
		  * 组件注册
		  */
		 function versionRegeidt(){
			 $("#inputWin").window({
				open : true,
				headline:'组件注册',
				content:'<iframe id="myframe" src=vm_version!componentRegeidt.action scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
				panelWidth:600,
				panelHeight:300
			});
		 }
		 
		//得到表中选中的记录
		function getIdFieldsOfChecked(){
			var ids="";
			var objsChecked=$("input[name='checkboxitem']:checked");
			if(objsChecked.length>=1){
				for(var i=0;i<objsChecked.length;i++){
					ids+=$(objsChecked[i]).val()+",";
				}
			}
			return ids;
		}
		</script>
	</head>
	<body style="height:700px;overflow:hidden;">
		<div class="myui-template-top-location"></div>
		<div class="myui-layout">
			<div class="rowgroup">
				<div class="content" style="width:650px;height:570px;margin-left:8px;" title="已安装组件清单">
					<div class="myui-template-condition" style="width:640px;">
					   <ul>
					      <li class="desc" style="width:120px;">workspace目录：</li>
					      <li style="width:500px;">
						  	 <input type="text" id="workspace" style="width:500px;" value="${workspace}" />
						  </li>
						  <li style="width:150px;">
						  	<a href="javascript:void(0);" class="myui-button-query-main" style="color:white;line-height:18px;margin-top:3px;" onclick="chkVersion();">组件检测</a>
						  	<a href="javascript:void(0);" class="myui-button-query-main" style="color:white;line-height:18px;margin-top:3px;" onclick="versionRegeidt();">组件注册</a>
						  </li>
					   </ul>
					</div>
					<div class="myui-datagrid" style="width:640px;">
						<table style="width:640px;" id="version_table">
							<tr>
								<th>组件</th>
								<th>版本号</th>
								<th>操作</th>
							</tr>
							<tbody id="databody">
							</tbody>
						</table>
					</div>
				</div>
				<!-- linegroup用于上下纵向排列布局 -->
		        <div class="linegroup">
		            <div class="content" style="width:560px;height:230px;overflow: hidden;font-family:微软雅黑;" title="校验结果">
						<div class="myui-datagrid" style="width:550px;">
							<table style="width:540px;">
								<tr>
									<th>文件路径</th>
								</tr>
								<tbody id="databody2">
								</tbody>
							</table>
						</div>
					</div>
		            <div class="content" style="width:560px;height:330px;overflow: hidden;font-family:微软雅黑;" title="升级文件清单">
						<a href="javascript:void(0);" class="myui-button-query-main" onclick="updVersionFile();" id="updbtn">升级</a>
						<div class="myui-datagrid" style="width:550px;height:260px;overflow: auto;">
							<table style="width:540px;">
								<tr>
									<th><input type="checkbox" name="all" checked="checked" onclick="checkAll('checkboxitem')" /></th>
									<th>升级文件</th>
									<th>升级类型</th>
								</tr>
								<tbody id="databody3">
								</tbody>
							</table>
						</div>
					</div>
		        </div>
			</div>
		</div>
		<div id="inputWin"></div>
	</body>
</html>