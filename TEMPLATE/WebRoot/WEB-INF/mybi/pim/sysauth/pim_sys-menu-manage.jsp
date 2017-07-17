<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"	rel="stylesheet" type="text/css" />
<link rel="stylesheet"	href="${ctx}/mybi/common/scripts/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css" />
<link	href="${ctx}/mybi/common/scripts/formvalidator/themes/Default/style/style.css"	rel="stylesheet" type="text/css" />
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.core-3.2.min.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/zTree/js/jquery.ztree.excheck-3.2.min.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/formvalidator/formValidator-4.1.3.min.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/formvalidator/formValidatorRegex.js"></script>
<script type="text/javascript"	src="${ctx}/mybi/common/scripts/formvalidator/themes/Default/js/theme.js"></script>
<script type="text/javascript">
	var setting2 = {
		view : {
			showIcon : false,
			selectedMulti : false
		},
		callback : {
			onClick : zTreeOnClick,
			onAsyncSuccess : zTreeOnAsyncSuccess
		},
		async : {
			enable : true,
			url : "pim_sys-menu!findSysMenuTreeWithoutAuth.action",
			autoParam : [ "id" ],
			dataFilter : filter
		}
	};
	$(function() {
		add_onload();//开启蒙板层

		$.fn.zTree.init($("#menuTree"), setting2);

		clean_onload();//关闭蒙板层

		$.formValidator.initConfig({
			formID : "form_input",
			onError : function(msg) {
				$.messager.alert('<s:text name="common_msg_info"/>', msg,
						'info');
			},
			onSuccess : function() {
				var param = "menuObj.id=" + $("#id").val();
				param += "&menuObj.id_tmp=" + $.trim($("#id_tmp").val());
				param += "&menuObj.nam=" + $.trim($("#nam").val());
				param += "&menuObj.namEg=" + $.trim($("#namEg").val());
				param += "&menuObj.url=" + $.trim($("#url").val());
				param += "&menuObj.actcls=" + $.trim($("#actcls").val());
				var isdevuse = "0";
				if ($("input[id='isdevuse']:checked").length == 1) {
					isdevuse = "1";
				}
				param += "&menuObj.isdevuse=" + isdevuse;
				param += "&menuObj.ord=" + $.trim($("#ord").val());
				add_onload();//开启蒙板层
				$.post("pim_sys-menu!updateSysMenuObj.action", param, function(
						data) {
					if (data.result == "succ") {
						//parent.findList(data.callbackCondition);	//回显刚才操作的记录
						$.messager.alert('<s:text name="common_msg_info"/>',
								'<s:text name="common_msg_updatesucc"/>',
								'info', function() {
									$("#id_tmp").val($("#id").val());
									//$("#btn_upt").attr("disabled",true);
									reloadSelfTree();
								});
					} else if (data.result == "fail") {
						$.messager.alert('<s:text name="common_msg_info"/>',
								'<s:text name="common_msg_updatefail"/>',
								'info');
					}
					clean_onload();//关闭蒙板层
				}, "json");

			}
		});

		$("#nam")
				.formValidator({
					onFocus : ""
				})
				.inputValidator(
						{
							min : 1,
							onError : '<s:text name="sysauth_sysMenu_nam2"/><s:text name="common_msg_formvalidte_required"/>'
						});//不能为空
		$("#namEg")
				.formValidator({
					onFocus : ""
				})
				.inputValidator(
						{
							min : 1,
							onError : '<s:text name="sysauth_sysMenu_namEg"/><s:text name="common_msg_formvalidte_required"/>'
						});//不能为空
		$("#ord")
				.formValidator({
					onFocus : ""
				})
				.regexValidator(
						{
							regExp : "intege1",
							dataType : "enum",
							onError : '<s:text name="sysauth_sysMenu_ord"/><s:text name="common_msg_formvalidte_onlyinteger"/>'
						});//只能输入正整数
	});

	//zTree专用filter
	function filter(treeId, parentNode, childNodes) {
		if (!childNodes)
			return null;
		for ( var i = 0, l = childNodes.length; i < l; i++) {
			childNodes[i].name = childNodes[i].name.replace('', '');
		}
		return childNodes;
	}

	//zTree节点点击触发
	function zTreeOnClick(event, treeId, treeNode) {
		$
				.post(
						"pim_sys-menu!findDataBySysMenuId.action",
						{
							id : treeNode.id
						},
						function(data) {
							//属性
							if (data.sysMenuObj != null) {
								$("#id").val(treeNode.id);
								$("#id_tmp").val(treeNode.id);
								//$("#id_show").html(treeNode.id);
								$("#nam").val(data.sysMenuObj.nam);
								$("#namEg").val(data.sysMenuObj.namEg);
								$("#url").val(data.sysMenuObj.url);
								$("#actcls").val(data.sysMenuObj.actcls);
								$("#ord").val(data.sysMenuObj.ord);
								if (data.sysMenuObj.isdevuse == "1") {
									$("#isdevuse").attr("checked", true);
								} else {
									$("#isdevuse").attr("checked", false);
								}
								$("#btn_upt").attr("disabled", false);
							} else {
								$("#id").val("");
								$("#id_tmp").val("");
								//$("#id_show").html(treeNode.id);
								$("#nam").val("");
								$("#namEg").val("");
								$("#url").val("");
								$("#actcls").val("");
								$("#ord").val("");
								$("#isdevuse").attr("checked", false);
								$("#btn_upt").attr("disabled", true);
							}

							//清空之前动作列表
							$('#databody').html('');
							//显示选中的菜单动作列表
							if (data.sysActionList.length > 0) {
								$
										.each(
												data.sysActionList,
												function(idx, item) {
													var _data = "";
													$
															.each(
																	data.sysActionList,
																	function(
																			idx,
																			item) {
																		_data += "<tr>";
																		_data += "<td align='center'><input type='checkbox' name='checkboxitem' value='"+item.id+"'></td>";
																		_data += "<td>"
																				+ item.nam
																				+ "</td>";
																		_data += "<td>"
																				+ item.namEg
																				+ "</td>";
																		_data += "<td>"
																				+ item.code
																				+ "</td>";
																		_data += "<td align='center'>"
																				+ item.isdevuseShow
																				+ "</td>";
																		_data += "</tr>";
																	});
													$("#databody").html(_data);
												});
							}
						}, "json");
	}

	//加载菜单信息及菜单下动作列表
	function findDataBySysMenuId(menuId) {
		$
				.post(
						"pim_sys-menu!findDataBySysMenuId.action",
						{
							id : menuId
						},
						function(data) {
							//属性
							if (data.sysMenuObj != null) {
								$("#id").val(menuId);
								$("#id_tmp").val(menuId);
								//$("#id_show").html(treeNode.id);
								$("#nam").val(data.sysMenuObj.nam);
								$("#namEg").val(data.sysMenuObj.namEg);
								$("#url").val(data.sysMenuObj.url);
								$("#actcls").val(data.sysMenuObj.actcls);
								$("#ord").val(data.sysMenuObj.ord);
								if (data.sysMenuObj.isdevuse == "1") {
									$("#isdevuse").attr("checked", true);
								} else {
									$("#isdevuse").attr("checked", false);
								}
								$("#btn_upt").attr("disabled", false);
							}

							//清空之前动作列表
							$('#databody').html('');
							//显示选中的菜单动作列表
							if (data.sysActionList.length > 0) {
								$
										.each(
												data.sysActionList,
												function(idx, item) {
													var _data = "";
													$
															.each(
																	data.sysActionList,
																	function(
																			idx,
																			item) {
																		_data += "<tr>";
																		_data += "<td align='center'><input type='checkbox' name='checkboxitem' value='"+item.id+"'></td>";
																		_data += "<td>"
																				+ item.nam
																				+ "</td>";
																		_data += "<td>"
																				+ item.namEg
																				+ "</td>";
																		_data += "<td>"
																				+ item.code
																				+ "</td>";
																		_data += "<td align='center'>"
																				+ item.isdevuseShow
																				+ "</td>";
																		_data += "</tr>";
																	});
													$("#databody").html(_data);
												});
							}
						}, "json");
	}

	//重新加载
	function reloadSelfTree() {
		var treeObj = $.fn.zTree.getZTreeObj("menuTree");
		//treeObj.reAsyncChildNodes(null, "refresh");

		$.fn.zTree.init($("#menuTree"), setting2);
	}

	//提交
	function sbt() {
		$("#form_input").submit();
	}

	//添加功能
	function openMenuInputWin() {
		var zTree = $.fn.zTree.getZTreeObj("menuTree");
		var nodes = zTree.getSelectedNodes();
		if (nodes.length == 0) {
			$.messager.alert('<s:text name="common_msg_info"/>',
					'<s:text name="sysauth_sysMenu_msg_noselect"/>', 'info');//没有选择功能
			return;
		}
		var nid = nodes[0].id;
		$("#inputWin")
				.window(
						{
							open : true,
							headline : '<s:text name="common_action_add"/><s:text name="sysauth_sysMenu"/>',
							content : '<iframe id="myframe" src=pim_sys-menu!toSysMenuObjInput.action?pid='
									+ nid
									+ ' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
							panelWidth : 510,
							panelHeight : 340
						});
	}

	//删除功能
	function delMenu() {
		var zTree = $.fn.zTree.getZTreeObj("menuTree");
		var nodes = zTree.getSelectedNodes();
		if (nodes.length == 0) {
			$.messager.alert('<s:text name="common_msg_info"/>',
					'<s:text name="sysauth_sysMenu_msg_noselect"/>', 'info');//没有选择功能
			return;
		}
		var nid = nodes[0].id;
		if (nid == "-1") {
			$.messager.alert('<s:text name="common_msg_info"/>',
					'<s:text name="sysauth_sysMenu_msg_nodelete"/>'); //该功能不允许删除
			return;
		}

		$.messager.confirm2('<s:text name="common_msg_info"/>',
				'<s:text name="common_msg_confirmdelete"/>', function() {
					$.post("pim_sys-menu!deleteSysMenuObj.action", {
						id : $("#id_tmp").val()
					}, function(data) {
						if (data.result == "succ") {
							$.messager.alert(
									'<s:text name="common_msg_info"/>',
									'<s:text name="common_msg_succ"/>', 'info',
									function() {
										$("#id").val('');
										$("#id_tmp").val('');
										$("#id_show").html('');
										$("#nam").val('');
										$("#namEg").val('');
										$("#url").val('');
										$("#actcls").val('');
										$("#remark").val('');
										$("#isdevuse").attr("checked", false);

										$("#btn_upt").attr("disabled", true);
										reloadSelfTree();

										//清空之前动作列表
										$('#databody').html('');
									});
						} else if (data.result == "fail") {
							$.messager.alert(
									'<s:text name="common_msg_info"/>',
									'<s:text name="common_msg_fail"/>');
						}
					}, "json");
				}, function() {

				});
	}

	//动作添加
	function openActionInputWin() {

		var zTree = $.fn.zTree.getZTreeObj("menuTree");
		var nodes = zTree.getSelectedNodes();
		if (nodes.length == 0) {
			$.messager.alert('<s:text name="common_msg_info"/>',
					'<s:text name="sysauth_sysMenu_msg_noselect"/>', 'info');//没有选择功能
			return;
		}
		
		var nid = nodes[0].id;
		if (nid == "-1") {
			$.messager.alert('<s:text name="common_msg_info"/>',
					'<s:text name="sysauth_sysMenu_msg_noaddaction"/>'); //该功能下不允许添加动作
			return;
		}

		$("#inputWin")
				.window(
						{
							open : true,
							headline : '<s:text name="common_action_add"/><s:text name="sysauth_sysAction"/>',
							content : '<iframe id="myframe" src=pim_sys-menu!toSysActionObjInput.action?menuId='
									+ nid
									+ ' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
							panelWidth : 650,
							panelHeight : 280
						});
	}

	//动作修改
	function openActionUpdateWin() {
		var objsChecked = $("input[name='checkboxitem']:checked");
		if (objsChecked.length <= 0) {
			$.messager.alert('<s:text name="common_msg_info"/>',
					'<s:text name="common_msg_noselect"/>', 'info');//没有选择记录
			return;
		}
		if (objsChecked.length > 1) {
			$.messager.alert('<s:text name="common_msg_info"/>',
					'<s:text name="common_msg_singleselect"/>', 'info');//只能选择一条记录
			return;
		}

		var id = $(objsChecked[0]).val();

		$("#inputWin")
				.window(
						{
							open : true,
							headline : '<s:text name="common_action_update"/><s:text name="sysauth_sysAction"/>',
							content : '<iframe id="myframe" src=pim_sys-menu!toSysActionObjUpdate.action?actionObj.id='
									+ id
									+ ' scrolling="no" frameborder="0" style="width:100%;height:100%;overflow:hidden;" />',
							panelWidth : 650,
							panelHeight : 280
						});
	}

	//动作删除
	function deleteActionObj() {
		var objsChecked = $("input[name='checkboxitem']:checked");
		if (objsChecked.length <= 0) {
			$.messager.alert('<s:text name="common_msg_info"/>',
					'<s:text name="common_msg_noselect"/>', 'info');//没有选择记录
			return;
		}
		var ids_action = getIdFieldsOfChecked();
		$.messager
				.confirm2(
						'<s:text name="common_msg_info"/>',
						'<s:text name="common_msg_confirmdelete"/>',
						function() {
							$
									.post(
											"pim_sys-menu!deleteSysActionList.action",
											{
												ids_action : ids_action
											},
											function(data) {
												if (data.result == "succ") {
													$.messager
															.alert(
																	'<s:text name="common_msg_info"/>',
																	'<s:text name="common_msg_succ"/>',
																	'info',
																	function() {
																		var zTree = $.fn.zTree
																				.getZTreeObj("menuTree");
																		var nodes = zTree
																				.getSelectedNodes();
																		if (nodes.length == 0) {
																			$.messager
																					.alert(
																							'<s:text name="common_msg_info"/>',
																							'<s:text name="sysauth_sysMenu_msg_noselect"/>',
																							'info');//没有选择功能
																			return;
																		}
																		var nid = nodes[0].id;

																		findDataBySysMenuId(nid);
																	});
												} else if (data.result == "fail") {
													$.messager
															.alert(
																	'<s:text name="common_msg_info"/>',
																	'<s:text name="common_msg_fail"/>');
												}
											}, "json");
						}, function() {

						});
	}

	//功能树加载成功后执行    
	function zTreeOnAsyncSuccess() {
		if ($("#id").val() != "") {
			var treeObj = $.fn.zTree.getZTreeObj("menuTree");
			var node = treeObj.getNodeByParam("id", $("#id").val(), null);
			treeObj.selectNode(node);
		}
	}

	//得到表中选中的记录
	function getIdFieldsOfChecked() {
		var ids = "";
		var objsChecked = $("input[name='checkboxitem']:checked");
		if (objsChecked.length >= 1) {
			for ( var i = 0; i < objsChecked.length; i++) {
				ids += $(objsChecked[i]).val() + ",";
			}
		}
		return ids;
	}
</script>
</head>
<body style="height: 1024px;">
	<div class="myui-layout">
		<div class="rowgroup">
			<div class="content" style="width:250px;height:472px;" title="功能列表">
				<div class="operate">
					<ul>
						<li><a href="#" onclick="openMenuInputWin()"><s:text name="common_action_add"/></a></li>
						<li> <a href="#" onclick="delMenu()"><s:text name="common_action_delete"/></a></li>
					</ul>
				</div>
				<div style="width:230px;">
					<ul id="menuTree" class="ztree"></ul>
				</div>
			</div>
			<div class="linegroup">
				<div class="content" style="width:960px;height:225px"  title="功能信息">
					<div class="myui-titlform">
						<form id="form_input" method="post">
							<input type="hidden" id="id" name="id" value="" /> 
							<input type="hidden" id="id_tmp" name="id_tmp" value="" />
							<div class="item">
								<ul>
									<li class="desc"><b style="color:#F00;">*</b>
									<s:text name="sysauth_sysMenu_nam2" />：</li>
									<li><input id="nam" name="nam" class="myui-text"
										style="width:300px; height:20px;">
									</li>
									<li class="desc"><b style="color:#F00;">*</b>
									<s:text name="sysauth_sysMenu_namEg" />：</li>
									<li><input id="namEg" name="namEg" class="myui-text"
										style="width:300px; height:20px;">
									</li>
								</ul>
							</div>

							<div class="item">
								<ul>
									<li class="desc">URL：</li>
									<li><input id="url" name="url" maxlength="300"
										class="myui-text" style="width:707px;" class="myui-text">
									</li>
								</ul>
							</div>

							<div class="item">
								<ul>
									<li class="desc"><s:text name="sysauth_sysMenu_relation" />
										Action：</li>
									<li><input id="actcls" name="actcls" maxlength="300"
										class="myui-text" style="width:707px;" class="myui-text">
									</li>
								</ul>
							</div>

							<div class="item">
								<ul>
									<li class="desc"><s:text name="sysauth_sysMenu_ord" />：</li>
									<li><input id="ord" name="ord" class="myui-text"
										style="width:300px; height:20px;">
									</li>
									<li class="desc"><s:text name="sysauth_sysMenu_isdevuse" />：</li>
									<li><input id="isdevuse" type="checkbox" value="1">
									</li>
								</ul>
							</div>
							<div class="operate">
								<a class="myui-button-query-main" id="btn_upt"	href="javascript:void(0);" onclick="sbt()" disabled="disabled"><s:text name="common_action_submit" /></a>
							</div>
						</form>
						
					</div>

				</div>
				<div class="content" style="width:960px;height:237px"  title="动作列表">
					<div class="operate">
						<ul>
							<li><a href="#" onclick="openActionInputWin()"><s:text name="common_action_add"/></a></li>
							<li><a href="#" onclick="openActionUpdateWin()"><s:text name="common_action_update"/></a></li>
							<li><a href="#" onclick="deleteActionObj()"><s:text name="common_action_delete"/></a></li>
						</ul>
					</div>
					<div class="myui-datagrid" style="width: 910px;margin-top: 10px;">
						<table style="width: 910px">
							<tr>
								<th style="width:20px;"></th>
								<th style="width:80px;"><s:text name="sysauth_sysAction_nam2" />
								</th>
								<th style="width:80px;"><s:text name="sysauth_sysAction_namEg" />
								</th>
								<th style="width:80px"><s:text name="sysauth_sysAction_code" />
								</th>
								<th style="width:80px;"><s:text name="sysauth_sysAction_typ" />
								</th>
							</tr>
							<tbody id="databody"></tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
<div id="inputWin">
</div>
</body>
</html>