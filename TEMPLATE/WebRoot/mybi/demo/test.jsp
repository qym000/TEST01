<%--Copyright (c) MINGYOUTECH Co. Ltd.--%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<link href="${ctx}/mybi/common/themes/${apptheme}/myui.css"
	rel="stylesheet" type="text/css" />
<link
	href="${ctx}/mybi/common/scripts/font-awesome/css/font-awesome.min.css"
	rel="stylesheet" type="text/css">
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/common/scripts/jquery.myui.all.js"></script>
	<script type="text/javascript"
		src="${ctx}/mybi/pim/scripts/jquery.pim.js"></script>
</head>
<body style="height:900px;">

	<div class="myui-layout">
		<div class="rowgroup">
			<div class="linegroup">
				<div class="content" style="width: 350px;height: 145px">
				<div class="operate">
						<ul>
							<li><a href="#" onclick="openActionInputWin()"><s:text name="common_action_add"/></a></li>
							<li><a href="#" onclick="openActionUpdateWin()"><s:text name="common_action_update"/></a></li>
							<li><a href="#" onclick="deleteActionObj()"><s:text name="common_action_delete"/></a></li>
						</ul>
					</div>
				</div>
				<div class="content" style="width: 350px;height: 145px"></div>
			</div>
			<div class="content" style="width: 350px;height: 300px"></div>
			
			<div class="tabs">
				<div class="tabcontent" style="width: 350px;height: 145px"></div>
				<div class="tabcontent" title="测试2" style="width: 350px;height: 145px"></div>
			</div>
		
		</div>
		<div class="rowgroup">
			<div class="content" style="width: 350px;height: 300px">
			<div class="operate">
						<ul>
							<li><a href="#" onclick="openActionInputWin()"><s:text name="common_action_add"/></a></li>
							<li><a href="#" onclick="openActionUpdateWin()"><s:text name="common_action_update"/></a></li>
							<li><a href="#" onclick="deleteActionObj()"><s:text name="common_action_delete"/></a></li>
						</ul>
					</div>
			</div>
			<div class="content" style="width: 350px;height: 300px"></div>
			<div class="content" style="width: 350px;height: 300px"></div>
		
		</div>
		<div class="rowgroup">
			<div class="linegroup">
				<div class="content" style="width: 350px;height: 95px"></div>
				<div class="content" style="width: 350px;height: 95px"></div>
				<div class="content" style="width: 350px;height: 95px"></div>
			</div>
			
			<div class="content" style="width: 350px;height: 300px"></div>
			<div class="content" style="width: 350px;height: 300px">
			<div class="operate">
						<ul>
							<li><a href="#" onclick="openActionInputWin()"><s:text name="common_action_add"/></a></li>
							<li><a href="#" onclick="openActionUpdateWin()"><s:text name="common_action_update"/></a></li>
							<li><a href="#" onclick="deleteActionObj()"><s:text name="common_action_delete"/></a></li>
						</ul>
					</div>
			</div>
		
		</div>
	</div>
	

</body>

</html>

