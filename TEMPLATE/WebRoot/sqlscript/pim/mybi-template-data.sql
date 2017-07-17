--Copyright (c) MINGYOUTECH Co. Ltd.--
--version 2.1.0--

insert into TP_PIM_PARAMTYP (ID, NAM)
values ('PARAMTYP_APP', '应用参数');
insert into TP_PIM_PARAMTYP (ID, NAM)
values ('PARAMTYP_SYS', '系统参数');
insert into TP_PIM_PARAMTYP (ID, NAM)
values ('PARAMTYP_PAGE', '页面参数');
commit;

insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM003', 'ISACTIONFILTER', '1', '是否开启系统动作过滤操作（开发阶段建议设置为0）', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM004', 'SWITCH_IPLOGIN', '0', '是否启用IP绑定登录（1是0否）', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM006', 'SYSNAME', '明佑开发平台', '系统名称（中文名称）', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM007', 'SYSNAME_EG', 'MY DEV Platform', '系统名称（英文名称）', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM008', 'DEFAULTPASSWORD', '888888', '新添加用户默认密码', '0');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM009', 'GLOBAL_TOP_ORGIDT', '00000', '中国银行总行最高权限机构编码', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM010', 'GLOBAL_TOP_ORGNAM', '中国银行', '中国银行总行最高权限机构名称', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM011', 'LOCAL_TOP_ORGIDT', 'A0013', '当前省级分行机构编码', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM012', 'LOCAL_TOP_ORGNAM', '安徽省分行', '当前省级分行机构名称', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM016', 'LOG_KEEP_DAYS', '90', '日志保留天数', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_PAGE', 'PIM017', 'I18N_SWITCH', '0', '语是否显示言切换1是0否', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_PAGE', 'PIM018', 'I18N_DEFAULT', 'zh', '默认语言en/zh', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_PAGE', 'PIM021', 'APPTHEME', 'default', '主题', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_PAGE', 'PIM022', 'ISHAVE_HOMEPAGE', '0', '是否有默认的欢迎页面(1是0否)，如果没有系统会默认加载排序最靠前且URL非空的菜单', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_PAGE', 'PIM024', 'EXPMOSTRECORD_CSV', '100', 'CSV导出最大数量（单位：万）', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_PAGE', 'PIM025', 'EXPMOSTRECORD_EXCEL2007', '10', 'EXCEL2007导出最大数量（单位：万）', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_PAGE', 'PIM026', 'EXPMOSTRECORD_EXCEL2003', '6', 'EXCEL2003导出最大数量（单位：万）', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_PAGE', 'PIM001', 'PAGESIZE', '15', '分页属性中每页记录数', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM099', 'DEVUSER', 'my,202CB962AC59075B964B07152D234B70', '维护人LOGID,PWD(逗号分隔)', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM100', 'COOKIEAGE', '30*24*60*60', 'COOKIE有效时长', '1');
insert into tp_pim_param (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM101', 'CENDAT', '20150701', '系统最新数据日期', '0');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM102', 'MAINPORTALSTYLE', '0', '进入系统后的主框架样式(0是黑红1素白)', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM103', 'PASSWDEXPIREDATE', '90', '密码过期天数', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM104', 'PASSWDEXPIREMUSTUPDATE', '1', '密码过期是否强制修改密码(1是0否)', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM105', 'PASSWDERRORINPUTLOCK', '9', '密码输错次数限制（超过该次数将被锁定）', '1');
insert into TP_PIM_PARAM (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM106', 'LOGIDPASSWDERRORINPUTVCODE', '3', '帐号密码不匹配多少次后出现验证码', '1');
commit;

insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM', '公共信息管理', 'PIM', '-1', null, 9999, '0', '公共信息管理', null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM01', '权限管理', 'Auth MG', 'PIM', null, 2, '0', null, null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM0101', '用户管理', 'User MG', 'PIM01', 'pim_sys-user!toManage.action', 3, '0', '用户管理', 'Pim_spresSysMenuAction,Pim_spresOrgAction');
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM0102', '角色管理', 'Role MG', 'PIM01', 'pim_sys-role!toManage.action', 4, '0', '角色管理', 'Pim_resSysMenuAction,Pim_resOrgAction');
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM0103', '功能管理', 'Menu MG', 'PIM01', 'pim_sys-menu!toManage.action', 5, '1', '功能管理', null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM03', '系统管理', 'System MG', 'PIM', null, 9, '0', null, null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM0301', '系统日志', 'Syslog MG', 'PIM03', 'pim_sys-log!toManage.action', 10, '0', '系统日志', null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM04', '参数管理', 'Param MG', 'PIM03', 'pim_sys-param!toManage.action', 12, '0', '参数管理', null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM0303', 'FTP主机管理', 'Ftp MG', 'PIM03', 'pim_ftp!toManage.action', 13, '0', 'FTP主机管理', null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM0304', 'JDBC连接管理', 'Jdbc MG', 'PIM03', 'pim_jdbc!toManage.action', 14, '0', 'JDBC连接管理', null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM0305', '主机连接管理', 'Host MG', 'PIM03', 'pim_host!toManage.action', 15, '0', '主机连接管理', null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('PIM02', '机构管理', 'Org Manage', 'PIM', 'pim_org-info!toManage.action', 99, '0', '机构管理', 'Pim_orgAction,Pim_orgChglogAction,Pim_orgExpImpAction,Pim_orgSelectorAction');

insert into TP_PIM_MENU (id, nam, nam_eg, pid, url, ord, isdevuse, remark, actcls)
values ('DEMO', 'DEMO', 'DEMO', '-1', null, 998, '1', 'DEMO管理', null);
insert into TP_PIM_MENU (id, nam, nam_eg, pid, url, ord, isdevuse, remark, actcls)
values ('DEMO01', 'MYUI控件', 'MYUI-API', 'DEMO', 'demo_myui!toManage.action', 1, '1', 'MYUI控件', null);
insert into TP_PIM_MENU (id, nam, nam_eg, pid, url, ord, isdevuse, remark, actcls)
values ('DEMO02', '开发模板', 'Develop Template', 'DEMO', 'demo_dev-template!toManage.action', 2, '1', '开发模板', null);
insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('DEMO03', 'CRUD', 'CRUD', 'DEMO', 'demo_crud!toManage.action', 4, '0', 'CRUD', 'Demo_resCrudAction,Demo_spresCrudAction');
insert into tp_pim_menu (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK, ACTCLS)
values ('DEMO04', '代码助手', 'coding temp', 'DEMO', 'demo_coding-template!toManage.action', 3, '0', null, null);
commit;



--insert into TP_PIM_MENU (ID, NAM, NAM_EG, PID, URL, ORD, ISDEVUSE, REMARK)
--values ('PIM05', '系统建议', 'System Improve', 'PIM03', 'pim_sys-improve!toManage.action', 13, '0', '系统建议');

insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010101', 'ACTION_PIM_USER_SEL', '查询', 'Select', 'PIM0101', 'pim_sys-user!findSysUserPager.action', 1, '0', '1');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010102', 'ACTION_PIM_USER_SAV', '添加', 'Add', 'PIM0101', 'pim_sys-user!saveSysUserObj.action', 2, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010103', 'ACTION_PIM_USER_UPT', '修改', 'Update', 'PIM0101', 'pim_sys-user!updateSysUserObj.action', 3, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010104', 'ACTION_PIM_USER_ASSIGN', '角色分配', 'Role Assign', 'PIM0101', 'pim_sys-user!saveSysUserSysRoleMapList.action', 4, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010105', 'ACTION_PIM_USER_SPRES_ASSIGN', '特例资源分配', 'Special res assign', 'PIM0101', 'pim_sys-user!toSpResAssign.action', 5, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010111', 'ACTION_PIM_USER_INITIMPORT', '初始数据导入', 'Initimport', 'PIM0101', 'pim_sys-user!initimportSysUser.action', 11, '1', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010112', 'ACTION_PIM_USER_EXP', '导出', 'Export', 'PIM0101', 'pim_sys-user!exportSysUserList.action', 12, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010113', 'ACTION_PIM_USER_DEL', '删除', 'Delete', 'PIM0101', 'pim_sys-user!deleteSysUserList.action', 13, '1', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010201', 'ACTION_PIM_ROLE_SEL', '查询', 'Select', 'PIM0102', 'pim_sys-role!findSysRolePager.action', 1, '0', '1');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010202', 'ACTION_PIM_ROLE_SAV', '添加', 'Add', 'PIM0102', 'pim_sys-role!saveSysRoleObj.action', 2, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010203', 'ACTION_PIM_ROLE_UPT', '修改', 'Update', 'PIM0102', 'pim_sys-role!updateSysRoleObj.action', 3, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010204', 'ACTION_PIM_ROLE_ASSIGN', '资源分配', 'Res Assign', 'PIM0102', 'pim_sys-role!toResAssign.action', 4, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM010205', 'ACTION_PIM_ROLE_DEL', '删除', 'Delete', 'PIM0102', 'pim_sys-role!deleteSysRoleList.action', 5, '1', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030101', 'ACTION_PIM_LOG_SEL', '查询', 'Select', 'PIM0301', 'pim_sys-log!findSysLogPager.action', 1, '0', '1');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030102', 'ACTION_PIM_LOG_EXP', '导出', 'Export', 'PIM0301', 'pim_sys-log!exportSysLogList.action', 2, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM0401', 'ACTION_PIM_PARAM_SEL', '查询', 'Select', 'PIM04', 'pim_sys-param!findSysParamPager.action', 1, '0', '1');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM0402', 'ACTION_PIM_PARAM_UPT', '修改', 'Update', 'PIM04', 'pim_sys-param!updateSysParam.action', 2, '0', '0');
--insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
--values ('PIM0501', 'ACTION_PIM_IMPROVE_SEL', '查询', 'Select', 'PIM05', 'pim_sys-improve!findSysImprovePager.action', 1, '0', '1');

insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030301', 'ACTION_PIM_FTP_SEL', '查询', 'Select', 'PIM0303', 'pim_ftp!findFtpPager.action', 1, '0', '1');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030302', 'ACTION_PIM_FTP_SAV', '添加', 'Add', 'PIM0303', 'pim_ftp!saveFtpObj.action', 2, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030303', 'ACTION_PIM_FTP_UPT', '修改', 'Update', 'PIM0303', 'pim_ftp!updateFtpObj.action', 3, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030304', 'ACTION_PIM_FTP_DEL', '删除', 'Delete', 'PIM0303', 'pim_ftp!deleteFtpList.action', 4, '1', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030401', 'ACTION_PIM_JDBC_SEL', '查询', 'Select', 'PIM0304', 'pim_jdbc!findJdbcPager.action', 1, '0', '1');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030402', 'ACTION_PIM_JDBC_SAV', '添加', 'Add', 'PIM0304', 'pim_jdbc!saveJdbcObj.action', 2, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030403', 'ACTION_PIM_JDBC_UPT', '修改', 'Update', 'PIM0304', 'pim_jdbc!updateJdbcObj.action', 3, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030404', 'ACTION_PIM_JDBC_DEL', '删除', 'Delete', 'PIM0304', 'pim_jdbc!deleteJdbcList.action', 4, '1', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030501', 'ACTION_PIM_HOST_SEL', '查询', 'Select', 'PIM0304', 'pim_host!findHostPager.action', 1, '0', '1');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030502', 'ACTION_PIM_HOST_SAV', '添加', 'Add', 'PIM0304', 'pim_host!saveHostObj.action', 2, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030503', 'ACTION_PIM_HOST_UPT', '修改', 'Update', 'PIM0304', 'pim_host!updateHostObj.action', 3, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('PIM030504', 'ACTION_PIM_HOST_DEL', '删除', 'Delete', 'PIM0304', 'pim_host!deleteHostList.action', 4, '1', '0');

insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('DEMO0301', 'ACTION_DEMO_CRUD_SEL', '查询', 'Select', 'DEMO03', 'demo_crud!findCrudPager.action', 1, '0', '1');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('DEMO0302', 'ACTION_DEMO_CRUD_SAV', '添加', 'Add', 'DEMO03', 'demo_crud!saveCrudObj.action', 2, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('DEMO0303', 'ACTION_DEMO_CRUD_UPT', '修改', 'Update', 'DEMO03', 'demo_crud!updateCrudObj.action', 3, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('DEMO0304', 'ACTION_DEMO_CRUD_DEL', '删除', 'Delete', 'DEMO03', 'demo_crud!deleteCrudList.action', 4, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('DEMO0305', 'ACTION_DEMO_CRUD_DETAIL', '详情', 'Detail', 'DEMO03', 'demo_crud!toCrudObjDetail.action', 5, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('DEMO0306', 'ACTION_DEMO_CRUD_ASSIGN', '权限分配', 'Auth assign', 'DEMO03', 'pim_res2roleuser!toManage.action', 6, '0', '0');
insert into TP_PIM_ACTION (ID, CODE, NAM, NAM_EG, MENU_ID, URL, ORD, ISDEVUSE, ISDEFAULT)
values ('DEMO0308', 'ACTION_DEMO_CRUD_EXPORT', '导出', 'Export', 'DEMO03', 'demo_crud!exportCrudList.action', 8, '0', '0');
commit;

insert into tp_pim_restyp (ID, CODE, NAM, NAM_EG, FLAG, SYSROLE_ASSIGN_URL, SYSUSER_ASSIGN_URL,DEFAULT_ACCESS, DIM1, DIM2, DIM3, DIM4, DIM5, DIM6, DIM7, DIM8, DIM9, DIM10)
values ('RESTYP_SYSMENU', 'RES_SYSMENU', '菜单资源', 'RES_SYSMENU', '1', 'pim_res-sys-menu!toAssign.action', 'pim_spres-sys-menu!toAssign.action', null,null, null, null, null, null, null, null, null, null, null);
insert into tp_pim_restyp (ID, CODE, NAM, NAM_EG, FLAG, SYSROLE_ASSIGN_URL, SYSUSER_ASSIGN_URL,DEFAULT_ACCESS, DIM1, DIM2, DIM3, DIM4, DIM5, DIM6, DIM7, DIM8, DIM9, DIM10)
values ('RESTYP_ORG', 'RES_ORG', '机构资源', 'RES_ORG', '2', 'pim_res-org!toAssign.action', 'pim_spres-org!toAssign.action',
'SELECT ORGIDT  FROM v_pim_org CONNECT BY PRIOR ORGIDT = up_org_cde START WITH ORGIDT = (SELECT usr.orgidt FROM tp_pim_user usr WHERE id = '||''''||'@USER_ID@'||''''||')',
null, null, null, null, null, null, null, null, null, null);
insert into tp_pim_restyp (ID, CODE, NAM, NAM_EG, FLAG, SYSROLE_ASSIGN_URL, SYSUSER_ASSIGN_URL,DEFAULT_ACCESS, DIM1, DIM2, DIM3, DIM4, DIM5, DIM6, DIM7, DIM8, DIM9, DIM10)
values ('RESTYP_DEMO_CRUD', 'RES_CRUD', 'CRUD资源', 'RES_CRUD', '3', 'demo_res-crud!toAssign.action', 'demo_spres-crud!toAssign.action', null,null, null, null, null, null, null, null, null, null, null);

commit;

insert into tp_pim_role (ID, NAM, ORGIDT, MODUID, MODATE, REMARK)
values ('0', '超级管理员', 'A0013', '0', null, null);
commit;

insert into tp_pim_user (ID, LOGID, PASSWD, NAM, ORGIDT, DEPNAM, STAT, PHONENUM, EMAIL, PWD_ERR_TIMES, PWD_UPT_DAT, SKIN, IP_BIND, MODUID, MODATE, REMARK)
values ('1', 'admin', '202CB962AC59075B964B07152D234B70', '超级管理员用户', 'A0013', null, '1', null, null, 1, to_date('31-12-9999', 'dd-mm-yyyy'), null, null, null, null, null);
commit;

insert into tp_pim_user_role (USER_ID, ROLE_ID)
values ('1', '0');
commit;

insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('ip_bind', 'ipBind', '绑定IP', 'Bind IP', 20, 1, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property1', 'property1', '扩展属性1', 'Extend prop1', 1000, 2, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property2', 'property2', '扩展属性2', 'Extend prop2', 1000, 3, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property3', 'property3', '扩展属性3', 'Extend prop3', 1000, 4, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property4', 'property4', '扩展属性4', 'Extend prop4', 1000, 5, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property5', 'property5', '扩展属性5', 'Extend prop5', 1000, 6, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property6', 'property6', '扩展属性6', 'Extend prop6', 1000, 7, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property7', 'property7', '扩展属性7', 'Extend prop7', 1000, 8, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property8', 'property8', '扩展属性8', 'Extend prop8', 1000, 9, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property9', 'property9', '扩展属性9', 'Extend prop9', 1000, 10, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property10', 'property10', '扩展属性10', 'Extend prop10', 1000, 11, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property11', 'property11', '扩展属性11', 'Extend prop11', 1000, 12, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property12', 'property12', '扩展属性12', 'Extend prop12', 1000, 13, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property13', 'property13', '扩展属性13', 'Extend prop13', 1000, 14, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property14', 'property14', '扩展属性14', 'Extend prop14', 1000, 15, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property15', 'property15', '扩展属性15', 'Extend prop15', 1000, 16, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property16', 'property16', '扩展属性16', 'Extend prop16', 1000, 17, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property17', 'property17', '扩展属性17', 'Extend prop17', 1000, 18, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property18', 'property18', '扩展属性18', 'Extend prop18', 1000, 19, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property19', 'property19', '扩展属性19', 'Extend prop19', 1000, 20, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property20', 'property20', '扩展属性20', 'Extend prop20', 1000, 21, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property21', 'property21', '扩展属性21', 'Extend prop21', 1000, 22, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property22', 'property22', '扩展属性22', 'Extend prop22', 1000, 23, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property23', 'property23', '扩展属性23', 'Extend prop23', 1000, 24, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property24', 'property24', '扩展属性24', 'Extend prop24', 1000, 25, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property25', 'property25', '扩展属性25', 'Extend prop25', 1000, 26, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property26', 'property26', '扩展属性26', 'Extend prop26', 1000, 27, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property27', 'property27', '扩展属性27', 'Extend prop27', 1000, 28, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property28', 'property28', '扩展属性28', 'Extend prop28', 1000, 29, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property29', 'property29', '扩展属性29', 'Extend prop29', 1000, 30, '0');
insert into TP_PIM_USER_COL_CONFIG (COL, PROP, COLNAM_CH, COLNAM_EN, MAXLEN, ORD, IS_EXTEND)
values ('property30', 'property30', '扩展属性30', 'Extend prop30', 1000, 31, '0');
commit;

insert into tp_pim_initcall (ID, CLASSNAM, METHODNAM, SCOPE, KEY, REMARK)
values ('INITCALL_BASIC1', 'pim_sysMenuServiceImpl', 'findSysMenuList', 'application', 'sysMenuList', '系统启动时加载所有的菜单');
insert into tp_pim_initcall (ID, CLASSNAM, METHODNAM, SCOPE, KEY, REMARK)
values ('INITCALL_BASIC2', 'pim_sysMenuServiceImpl', 'findSysActionList', 'application', 'sysActionList', '系统启动时加载所有的动作');
insert into tp_pim_initcall (ID, CLASSNAM, METHODNAM, SCOPE, KEY, REMARK)
values ('INITCALL_BASIC3', 'pim_sysRoleServiceImpl', 'updateSysRoleForSysInitCall', null, null, '系统启动时更新角色信息');
insert into tp_pim_initcall (ID, CLASSNAM, METHODNAM, SCOPE, KEY, REMARK)
values ('INITCALL_BASIC4', 'pim_sysUserServiceImpl', 'updateSysUserForSysInitCall', null, null, '系统启动时更新用户信息');
commit;

insert into TP_PIM_ORG_CHGTYP_DICT (id, nam)
values (1, '新增机构');
insert into TP_PIM_ORG_CHGTYP_DICT (id, nam)
values (2, '修改机构相关信息');
insert into TP_PIM_ORG_CHGTYP_DICT (id, nam)
values (3, '修改机构映射关系');
insert into TP_PIM_ORG_CHGTYP_DICT (id, nam)
values (4, '删除机构');
commit;

insert into TP_PIM_ORG_EXT_CONF (tabnam, colnam, colcode, ord)
values ('TP_PIM_ORG', '县支行', 'ISCONTRY', 3);
insert into TP_PIM_ORG_EXT_CONF (tabnam, colnam, colcode, ord)
values ('TP_PIM_ORG', '重点支行', 'ISIMPORT', 2);
insert into TP_PIM_ORG_EXT_CONF (tabnam, colnam, colcode, ord)
values ('TP_PIM_ORG', '网点', 'ISBRH', 1);
commit;

insert into TP_PIM_ORG_SRCSYS (srcsys, sysdes, tabname, rootnode)
values ('SRCSYS_01', '当前系统', 'TP_PIM_ORG', 'A0013');

insert into tp_pim_param (PARAMTYP_ID, ID, PKEY, PVAL, PDESC, ISDEVUSE)
values ('PARAMTYP_SYS', 'PIM107', 'BIGQUERY_ADDTIME_CACHE', '15', '大数据查询超过多少秒加入缓存 单位：描述', '1');

commit;

