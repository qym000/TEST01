--Copyright (c) MINGYOUTECH Co. Ltd.--
--version 2.1.0--

drop table tp_pim_log ;
drop table tp_pim_improve;
drop table tp_pim_action ;
drop table tp_pim_menu;
drop table tp_pim_restyp;
drop table tp_pim_role_res;
drop table tp_pim_user_role;
drop table tp_pim_user_res;
drop table tp_pim_role;
drop table tp_pim_user_col_config;
drop table tp_pim_user;
drop table tp_pim_initcall;
drop table tp_pim_param;
drop table tp_pim_paramtyp;
drop view  v_pim_org;
DROP TABLE TP_PIM_ORG;
DROP TABLE TP_PIM_ORG_CHGLOG;
DROP TABLE TP_PIM_ORG_CHGTYP_DICT;
DROP TABLE TP_PIM_ORG_COL_CONFIG;
DROP TABLE TP_PIM_ORG_EXT_CONF;
DROP TABLE TP_PIM_ORG_MAP;
DROP TABLE TP_PIM_ORG_REMIND;
DROP TABLE TP_PIM_ORG_SRCSYS;
DROP TABLE TP_PIM_FTP;
DROP TABLE TP_PIM_JDBC;
DROP TABLE TP_PIM_HOST;
DROP TABLE T_DIM_CDEORG;

drop table tp_demo_crud;

drop table TP_PIM_BIGQUERY_CACHE ;
drop table TP_PIM_FAVORITE;
drop table TP_PIM_FOOTPRINT;
drop table TP_PIM_SENSITIVEINFO;

DROP package PKG_PIM;
DROP package PKG_MYBI_CORE;

DROP TYPE TYP_MYBI_OBJTAB; 
DROP TYPE TYP_MYBI_OBJID;

--系统参数类型
create table TP_PIM_PARAMTYP
(
  ID  VARCHAR2(32) not null,
  NAM VARCHAR2(80) not null
);
alter table TP_PIM_PARAMTYP
  add primary key (ID);

--系统参数
create table tp_pim_param
(
  PARAMTYP_ID VARCHAR2(32),	
  ID       VARCHAR2(32) not null,
  PKEY     VARCHAR2(100),
  PVAL     VARCHAR2(200),
  PDESC    VARCHAR2(200),
  ISDEVUSE CHAR(1) default 0
);
comment on table tp_pim_param
  is '系统参数';
comment on column tp_pim_param.PARAMTYP_ID
  is '参数类型ID';  
comment on column tp_pim_param.ID
  is 'ID';
comment on column tp_pim_param.PKEY
  is '标识';
comment on column tp_pim_param.PVAL
  is '值';
comment on column tp_pim_param.PDESC
  is '描述';
comment on column tp_pim_param.ISDEVUSE
  is '是否开发人员专用(1是0否)';
alter table tp_pim_param
  add constraint PK_tp_pim_param primary key (ID);
alter table tp_pim_param
  add constraint UK_tp_pim_param unique (PKEY);
  
--系统菜单
create table tp_pim_menu
(
  ID       VARCHAR2(32) not null,
  NAM      VARCHAR2(100),
  NAM_EG   VARCHAR2(100),
  PID      VARCHAR2(32),
  URL      VARCHAR2(300),
  ORD      NUMBER(4) default 1,
  ISDEVUSE CHAR(1) default 0,
  REMARK   VARCHAR2(200),
  ACTCLS VARCHAR2(300)
);
comment on table tp_pim_menu
  is '系统菜单';
comment on column tp_pim_menu.ID
  is 'ID';
comment on column tp_pim_menu.NAM
  is '菜单中文名称';
comment on column tp_pim_menu.NAM_EG
  is '菜单英文名称';
comment on column tp_pim_menu.PID
  is '上级菜单ID';
comment on column tp_pim_menu.URL
  is 'URL连接';
comment on column tp_pim_menu.ORD
  is '排序';
comment on column tp_pim_menu.ISDEVUSE
  is '是否开发人员专用(1是0否)';
comment on column tp_pim_menu.REMARK
  is '描述';
comment on column tp_pim_menu.ACTCLS
  is '配置跳出当前功能URL的其他URL的ACTION名称，如Pim_spresSysMenuAction';  
alter table tp_pim_menu
  add constraint PK_TP_PIM_MENU primary key (ID);

--系统动作
create table tp_pim_action
(
  ID       VARCHAR2(32) not null,
  CODE     VARCHAR2(50),
  NAM      VARCHAR2(50) not null,
  NAM_EG   VARCHAR2(50),
  MENU_ID  VARCHAR2(32),
  URL      VARCHAR2(500),
  ORD      NUMBER(3) default 1,
  ISDEVUSE CHAR(1) default 0,
  ISDEFAULT CHAR(1) default 0
);
comment on table tp_pim_action
  is '系统动作';
comment on column tp_pim_action.ID
  is 'ID';
comment on column tp_pim_action.CODE
  is '代码';
comment on column tp_pim_action.NAM
  is '动作中文名称';
comment on column tp_pim_action.NAM_EG
  is '动作英文名称';
comment on column tp_pim_action.MENU_ID
  is '菜单ID';
comment on column tp_pim_action.URL
  is 'URL连接';
comment on column tp_pim_action.ORD
  is '排序';
comment on column tp_pim_action.ISDEVUSE
  is '是否开发人员专用(1是0否)';
comment on column tp_pim_action.ISDEFAULT
  is '是否默认(1是0否)';
alter table tp_pim_action
  add constraint PK_tp_pim_action primary key (ID);
alter table tp_pim_action
  add constraint UNIQUE_TP_PIM_ACTION unique (CODE);   

--系统资源类型
create table tp_pim_restyp
(
  ID         VARCHAR2(32) not null,
  CODE       VARCHAR2(40),
  NAM        VARCHAR2(80),
  NAM_EG        VARCHAR2(80),
  FLAG       CHAR(1) default 1,
  SYSROLE_ASSIGN_URL VARCHAR2(300),
  SYSUSER_ASSIGN_URL VARCHAR2(300),
  DEFAULT_ACCESS VARCHAR2(1000),
  DIM1       VARCHAR2(40),
  DIM2       VARCHAR2(40),
  DIM3       VARCHAR2(40),
  DIM4       VARCHAR2(40),
  DIM5       VARCHAR2(40),
  DIM6       VARCHAR2(40),
  DIM7       VARCHAR2(40),
  DIM8       VARCHAR2(40),
  DIM9       VARCHAR2(40),
  DIM10      VARCHAR2(40)
);
comment on table tp_pim_restyp
  is '系统资源类型';
comment on column tp_pim_restyp.ID
  is 'ID';
comment on column tp_pim_restyp.CODE
  is '编码';
comment on column tp_pim_restyp.NAM
  is '名称';
comment on column tp_pim_restyp.NAM_EG
  is '英文名称';  
comment on column tp_pim_restyp.SYSROLE_ASSIGN_URL
  is '角色资源分配页面路径';
comment on column tp_pim_restyp.FLAG
  is '应用场景标识(0无效；1、角色资源分配；2、用户特例资源分配；3、共用)';
comment on column tp_pim_restyp.DIM1
  is '维度1：机构';
comment on column tp_pim_restyp.DIM2
  is '维度2：币种';
comment on column tp_pim_restyp.SYSUSER_ASSIGN_URL
  is '用户特例资源分配页面路径';
alter table tp_pim_restyp
  add constraint PK_TP_PIM_RESTYP primary key (ID);
alter table tp_pim_restyp
  add constraint UNIQUE_TP_PIM_RESTYP unique (CODE);

--系统角色
create table TP_PIM_ROLE
(
  id         VARCHAR2(32) not null,
  nam        VARCHAR2(100) not null,
  assignable CHAR(1) default 0 not NULL,
  orgidt     VARCHAR2(8),
  moduid     VARCHAR2(32),
  modate     DATE default sysdate,
  remark     VARCHAR2(200)
);
comment on table TP_PIM_ROLE
  is '系统角色';
comment on column TP_PIM_ROLE.id
  is 'ID';
comment on column TP_PIM_ROLE.nam
  is '名称';
comment on column TP_PIM_ROLE.assignable
  is '是否可下放';
comment on column TP_PIM_ROLE.orgidt
  is '所属机构';
comment on column TP_PIM_ROLE.moduid
  is '最后维护人ID';
comment on column TP_PIM_ROLE.modate
  is '最后维护日期';
comment on column TP_PIM_ROLE.remark
  is '备注'; 
alter table TP_PIM_ROLE
  add constraint PK_TP_PIM_ROLE primary key (ID);


--系统角色与系统资源对应关系
create table tp_pim_role_res
(
  ROLE_ID     VARCHAR2(32) not null,	
  RESTYP_CODE VARCHAR2(40) not null,
  RES_ID      VARCHAR2(32) not null
);
comment on table tp_pim_role_res
  is '系统角色与系统资源对应关系';
comment on column tp_pim_role_res.ROLE_ID
  is '角色ID';  
comment on column tp_pim_role_res.RESTYP_CODE
  is '资源类型编码';
comment on column tp_pim_role_res.RES_ID
  is '资源ID';
alter table tp_pim_role_res
  add constraint PK_TP_PIM_ROLE_RES primary key (RES_ID, ROLE_ID, RESTYP_CODE);

--系统用户
create table tp_pim_user
(
  ID            VARCHAR2(32) not null,
  LOGID         VARCHAR2(32) not null,
  PASSWD        VARCHAR2(32) not null,
  NAM           VARCHAR2(200),
  ORGIDT        VARCHAR2(8) not null,
  DEPNAM        VARCHAR2(50),
  STAT          VARCHAR2(1) default '1',
  PHONENUM      VARCHAR2(20),
  EMAIL         VARCHAR2(60),
  PWD_ERR_TIMES INTEGER default 0,
  PWD_UPT_DAT   DATE default sysdate,
  SKIN          VARCHAR2(30),
  IP_BIND       VARCHAR2(20),
  MODUID        VARCHAR2(32),
  MODATE        DATE default sysdate,
  REMARK        VARCHAR2(200),
  PROPERTY1  VARCHAR2(1000),
  PROPERTY2  VARCHAR2(1000),
  PROPERTY3  VARCHAR2(1000),
  PROPERTY4  VARCHAR2(1000),
  PROPERTY5  VARCHAR2(1000),
  PROPERTY6  VARCHAR2(1000),
  PROPERTY7  VARCHAR2(1000),
  PROPERTY8  VARCHAR2(1000),
  PROPERTY9  VARCHAR2(1000),
  PROPERTY10 VARCHAR2(1000),
  PROPERTY11 VARCHAR2(1000),
  PROPERTY12 VARCHAR2(1000),
  PROPERTY13 VARCHAR2(1000),
  PROPERTY14 VARCHAR2(1000),
  PROPERTY15 VARCHAR2(1000),
  PROPERTY16 VARCHAR2(1000),
  PROPERTY17 VARCHAR2(1000),
  PROPERTY18 VARCHAR2(1000),
  PROPERTY19 VARCHAR2(1000),
  PROPERTY20 VARCHAR2(1000),
  PROPERTY21 VARCHAR2(1000),
  PROPERTY22 VARCHAR2(1000),
  PROPERTY23 VARCHAR2(1000),
  PROPERTY24 VARCHAR2(1000),
  PROPERTY25 VARCHAR2(1000),
  PROPERTY26 VARCHAR2(1000),
  PROPERTY27 VARCHAR2(1000),
  PROPERTY28 VARCHAR2(1000),
  PROPERTY29 VARCHAR2(1000),
  PROPERTY30 VARCHAR2(1000)
);
comment on table tp_pim_user
  is '系统用户';
comment on column tp_pim_user.ID
  is 'ID';
comment on column tp_pim_user.LOGID
  is '登录编号';
comment on column tp_pim_user.PASSWD
  is '密码';
comment on column tp_pim_user.NAM
  is '姓名';
comment on column tp_pim_user.ORGIDT
  is '归属机构';
comment on column tp_pim_user.DEPNAM
  is '部门';
comment on column tp_pim_user.STAT
  is '状态';
comment on column tp_pim_user.PHONENUM
  is '联系电话';
comment on column tp_pim_user.EMAIL
  is '邮箱';
comment on column tp_pim_user.PWD_ERR_TIMES
  is '密码输错次数';
comment on column tp_pim_user.PWD_UPT_DAT
  is '密码修改日期';
comment on column tp_pim_user.SKIN
  is '主题';
comment on column tp_pim_user.IP_BIND
  is '绑定的IP地址';
comment on column tp_pim_user.MODUID
  is '最后维护人ID';
comment on column tp_pim_user.MODATE
  is '最后维护日期';
comment on column tp_pim_user.REMARK
  is '备注';
comment on column tp_pim_user.PROPERTY1
  is '扩展字段1';
comment on column tp_pim_user.PROPERTY2
  is '扩展字段2';
comment on column tp_pim_user.PROPERTY3
  is '扩展字段3';
comment on column tp_pim_user.PROPERTY4
  is '扩展字段4';
comment on column tp_pim_user.PROPERTY5
  is '扩展字段5';
comment on column tp_pim_user.PROPERTY6
  is '扩展字段6';
comment on column tp_pim_user.PROPERTY7
  is '扩展字段7';
comment on column tp_pim_user.PROPERTY8
  is '扩展字段8';
comment on column tp_pim_user.PROPERTY9
  is '扩展字段9';
comment on column tp_pim_user.PROPERTY10
  is '扩展字段10'; 
comment on column tp_pim_user.PROPERTY11
  is '扩展字段11'; 
comment on column tp_pim_user.PROPERTY12
  is '扩展字段12';
comment on column tp_pim_user.PROPERTY13
  is '扩展字段13';
comment on column tp_pim_user.PROPERTY14
  is '扩展字段14';
comment on column tp_pim_user.PROPERTY15
  is '扩展字段15';
comment on column tp_pim_user.PROPERTY16
  is '扩展字段16'; 
comment on column tp_pim_user.PROPERTY17
  is '扩展字段17';
comment on column tp_pim_user.PROPERTY18
  is '扩展字段18'; 
comment on column tp_pim_user.PROPERTY19
  is '扩展字段19'; 
comment on column tp_pim_user.PROPERTY20
  is '扩展字段20';  
comment on column tp_pim_user.PROPERTY21
  is '扩展字段21';
comment on column tp_pim_user.PROPERTY22
  is '扩展字段22';
comment on column tp_pim_user.PROPERTY23
  is '扩展字段23';
comment on column tp_pim_user.PROPERTY24
  is '扩展字段24';
comment on column tp_pim_user.PROPERTY25
  is '扩展字段25';
comment on column tp_pim_user.PROPERTY26
  is '扩展字段26';
comment on column tp_pim_user.PROPERTY27
  is '扩展字段27';
comment on column tp_pim_user.PROPERTY28
  is '扩展字段28';
comment on column tp_pim_user.PROPERTY29
  is '扩展字段29';
comment on column tp_pim_user.PROPERTY30
  is '扩展字段30';                                    
alter table tp_pim_user
  add constraint PK_TP_PIM_USER primary key (ID);

--系统用户与系统角色对应关系
create table tp_pim_user_role
(
  USER_ID VARCHAR2(32) not null,
  ROLE_ID VARCHAR2(32) not null
);
comment on table tp_pim_user_role
  is '系统用户与系统角色对应关系';
comment on column tp_pim_user_role.USER_ID
  is '用户ID';
comment on column tp_pim_user_role.ROLE_ID
  is '角色ID';
alter table tp_pim_user_role
  add constraint PK_TP_PIM_USER_ROLE primary key (USER_ID, ROLE_ID);

--系统用户特例资源
create table tp_pim_user_res
(
  USER_ID     VARCHAR2(32),
  RESTYP_CODE VARCHAR2(40),
  RES_ID      VARCHAR2(32),
  DIM1        VARCHAR2(40),
  DIM2        VARCHAR2(40),
  DIM3        VARCHAR2(40),
  DIM4        VARCHAR2(40),
  DIM5        VARCHAR2(40),
  DIM6        VARCHAR2(40),
  DIM7        VARCHAR2(40),
  DIM8        VARCHAR2(40),
  DIM9        VARCHAR2(40),
  DIM10       VARCHAR2(40)
);
comment on table tp_pim_user_res
  is '系统用户特例资源';
comment on column tp_pim_user_res.USER_ID
  is '用户ID';
comment on column tp_pim_user_res.RESTYP_CODE
  is '资源类型';
comment on column tp_pim_user_res.RES_ID
  is '资源ID';
comment on column tp_pim_user_res.DIM1
  is '维度1：机构';
comment on column tp_pim_user_res.DIM2
  is '维度2：币种';

--用户表的列配置
create table TP_PIM_USER_COL_CONFIG
(
  COL       VARCHAR2(50),
  PROP      VARCHAR2(50),
  COLNAM_CH VARCHAR2(1000),
  COLNAM_EN VARCHAR2(1000),
  MAXLEN    NUMBER(4) default 1000,
  ORD       NUMBER(3) default 9,
  IS_EXTEND CHAR(1) default '0'
);

comment on table TP_PIM_USER_COL_CONFIG
  is '用户表的列配置';
comment on column TP_PIM_USER_COL_CONFIG.COL
  is '表的列';
comment on column TP_PIM_USER_COL_CONFIG.PROP
  is '列对应的类属性';
comment on column TP_PIM_USER_COL_CONFIG.COLNAM_CH
  is '列中文';
comment on column TP_PIM_USER_COL_CONFIG.COLNAM_EN
  is '列英文';
comment on column TP_PIM_USER_COL_CONFIG.MAXLEN
  is '最大长度';
comment on column TP_PIM_USER_COL_CONFIG.ORD
  is '排序';
comment on column TP_PIM_USER_COL_CONFIG.IS_EXTEND
  is '是否扩展列';


--系统初始调用
create table tp_pim_initcall
(
  ID        VARCHAR2(32) not null,	
  CLASSNAM  VARCHAR2(200),
  METHODNAM VARCHAR2(50),
  SCOPE     VARCHAR2(20),
  KEY       VARCHAR2(50),
  REMARK    VARCHAR2(200)
);
comment on table tp_pim_initcall
  is '系统初始调用';
comment on column tp_pim_initcall.ID
  is 'ID';  
comment on column tp_pim_initcall.CLASSNAM
  is '类名';
comment on column tp_pim_initcall.METHODNAM
  is '方法名';
comment on column tp_pim_initcall.SCOPE
  is '范围application(固定值),如果为空,则一般是方法没有返回值';
comment on column tp_pim_initcall.KEY
  is '接收返回值之后，保存在scope中的key部分';
comment on column tp_pim_initcall.REMARK
  is '说明';
alter table tp_pim_initcall
  add constraint PK_TP_PIM_INITCALL primary key (ID);  
alter table tp_pim_initcall
  add constraint UNIQUE_SYSINITCALL unique (CLASSNAM, METHODNAM);

--系统建议
create table tp_pim_improve
(
  ID       VARCHAR2(32) not null,
  USER_ID  VARCHAR2(32),
  OPR_DATE DATE default sysdate,
  CONTENT  VARCHAR2(2000),
  TYP CHAR(1),
  PHONENUM      VARCHAR2(20),
  EMAIL         VARCHAR2(60)
);
comment on table tp_pim_improve
  is '系统建议';
comment on column tp_pim_improve.USER_ID
  is '用户ID';
comment on column tp_pim_improve.OPR_DATE
  is '日期';
comment on column tp_pim_improve.CONTENT
  is '内容';
comment on column tp_pim_improve.TYP
  is '类型';
comment on column tp_pim_improve.PHONENUM
  is '电话';
comment on column tp_pim_improve.EMAIL
  is '邮箱';      
alter table tp_pim_improve
  add constraint PK_TP_PIM_IMPROVE primary key (ID);
  
--系统日志
create table tp_pim_log
(
  ID        VARCHAR2(32) not null,
  USER_ID   VARCHAR2(32),
  MENU_ID   VARCHAR2(32),
  ACTION_ID VARCHAR2(32),
  OPR_DATE  DATE default SYSDATE,
  IP        VARCHAR2(20)
);
comment on table tp_pim_log
  is '系统日志';
comment on column tp_pim_log.ID
  is 'ID';
comment on column tp_pim_log.USER_ID
  is '用户ID';  
comment on column tp_pim_log.MENU_ID
  is '菜单ID';
comment on column tp_pim_log.ACTION_ID
  is '动作ID';
comment on column tp_pim_log.OPR_DATE
  is '日期';
comment on column tp_pim_log.IP
  is '客户端IP';
alter table tp_pim_log
  add constraint PK_TP_PIM_LOG primary key (ID);  

--机构相关表
SET define off
spool abc.log

prompt

prompt Creating table TP_PIM_ORG
prompt =========================
prompt

create table TP_PIM_ORG
(
  orgidt      VARCHAR2(16) not null,
  orgnam      VARCHAR2(100) not null,
  short_nam   VARCHAR2(100),
  up_orgidt   VARCHAR2(16) not null,
  orglvl      VARCHAR2(4),
  status      VARCHAR2(2),
  effdate     VARCHAR2(8),
  enddate     VARCHAR2(8),
  isstop      VARCHAR2(2),
  isbrh       VARCHAR2(1) default '0',
  brhtyp      VARCHAR2(2),
  brhlvl      VARCHAR2(2),
  isbusdept   VARCHAR2(2),
  iscontry    VARCHAR2(2),
  isimport    VARCHAR2(2),
  manauto     VARCHAR2(1) default '0',
  area        VARCHAR2(16),
  zone        VARCHAR2(16),
  eval_group  VARCHAR2(16),
  pboc_code   VARCHAR2(32),
  pboc_orgcde VARCHAR2(32),
  pboc_orgnam VARCHAR2(100),
  citcde      VARCHAR2(10),
  addr        VARCHAR2(100),
  postcode    VARCHAR2(16),
  mapx        VARCHAR2(16),
  mapy        VARCHAR2(16),
  maplabpos   VARCHAR2(16),
  mapfieno    VARCHAR2(16),
  mapinfo3    VARCHAR2(200),
  adduid      VARCHAR2(32),
  adddate     DATE,
  moduid      VARCHAR2(32),
  moddate     DATE,
  property1   VARCHAR2(100),
  property2   VARCHAR2(100),
  property3   VARCHAR2(100),
  property4   VARCHAR2(100),
  property5   VARCHAR2(100),
  property6   VARCHAR2(100),
  property7   VARCHAR2(100),
  property8   VARCHAR2(100),
  property9   VARCHAR2(100),
  property10  VARCHAR2(100),
  property11  VARCHAR2(100),
  property12  VARCHAR2(100),
  property13  VARCHAR2(100),
  property14  VARCHAR2(100),
  property15  VARCHAR2(100),
  property16  VARCHAR2(100),
  property17  VARCHAR2(100),
  property18  VARCHAR2(100),
  property19  VARCHAR2(100),
  property20  VARCHAR2(100),
  property21  VARCHAR2(500),
  property22  VARCHAR2(500),
  property23  VARCHAR2(500),
  property24  VARCHAR2(500),
  property25  VARCHAR2(500),
  property26  VARCHAR2(500),
  property27  VARCHAR2(500),
  property28  VARCHAR2(500),
  property29  VARCHAR2(500),
  property30  VARCHAR2(500)
)
;
comment on table TP_PIM_ORG
  is '机构信息表';
comment on column TP_PIM_ORG.orgidt
  is '机构号';
comment on column TP_PIM_ORG.orgnam
  is '机构名称';
comment on column TP_PIM_ORG.short_nam
  is '机构短名';
comment on column TP_PIM_ORG.up_orgidt
  is '上级机构号';
comment on column TP_PIM_ORG.orglvl
  is '机构层级(行政管理)';
comment on column TP_PIM_ORG.status
  is '机构状态(1:正常,2:已撤销)';
comment on column TP_PIM_ORG.effdate
  is '生效日期';
comment on column TP_PIM_ORG.enddate
  is '失效日期';
comment on column TP_PIM_ORG.isstop
  is '是否停业(1:是0:否)';
comment on column TP_PIM_ORG.isbrh
  is '是否网点(1:是0:否)';
comment on column TP_PIM_ORG.brhtyp
  is '网点类型';
comment on column TP_PIM_ORG.brhlvl
  is '网点等级';
comment on column TP_PIM_ORG.isbusdept
  is '是否为营业部(1:是0:否)';
comment on column TP_PIM_ORG.iscontry
  is '是否县支行(1:是0:否)';
comment on column TP_PIM_ORG.isimport
  is '是否重点支行(1:是0:否)';
comment on column TP_PIM_ORG.manauto
  is '是否手工维护机构(1是0否)';
comment on column TP_PIM_ORG.area
  is '地区';
comment on column TP_PIM_ORG.zone
  is '片区';
comment on column TP_PIM_ORG.eval_group
  is '考核分组';
comment on column TP_PIM_ORG.pboc_code
  is '人行编码';
comment on column TP_PIM_ORG.pboc_orgcde
  is '人行机构代码';
comment on column TP_PIM_ORG.pboc_orgnam
  is '人行机构名称';
comment on column TP_PIM_ORG.citcde
  is '城市代码';
comment on column TP_PIM_ORG.addr
  is '地址';
comment on column TP_PIM_ORG.postcode
  is '邮编';
comment on column TP_PIM_ORG.mapx
  is '地图坐标X';
comment on column TP_PIM_ORG.mapy
  is '地图坐标Y';
comment on column TP_PIM_ORG.maplabpos
  is '地图信息1';
comment on column TP_PIM_ORG.mapfieno
  is '地图信息2';
comment on column TP_PIM_ORG.mapinfo3
  is '地图信息3';
comment on column TP_PIM_ORG.adduid
  is '添加人';
comment on column TP_PIM_ORG.adddate
  is '添加时间';
comment on column TP_PIM_ORG.moduid
  is '最后修改人';
comment on column TP_PIM_ORG.moddate
  is '最后修改时间';
comment on column TP_PIM_ORG.property1
  is '扩展信息1';
comment on column TP_PIM_ORG.property2
  is '扩展信息2';
comment on column TP_PIM_ORG.property3
  is '扩展信息3';
comment on column TP_PIM_ORG.property4
  is '扩展信息4';
comment on column TP_PIM_ORG.property5
  is '扩展信息5';
comment on column TP_PIM_ORG.property6
  is '扩展信息6';
comment on column TP_PIM_ORG.property7
  is '扩展信息7';
comment on column TP_PIM_ORG.property8
  is '扩展信息8';
comment on column TP_PIM_ORG.property9
  is '扩展信息9';
comment on column TP_PIM_ORG.property10
  is '扩展信息10';
comment on column TP_PIM_ORG.property11
  is '扩展信息11';
comment on column TP_PIM_ORG.property12
  is '扩展信息12';
comment on column TP_PIM_ORG.property13
  is '扩展信息13';
comment on column TP_PIM_ORG.property14
  is '扩展信息14';
comment on column TP_PIM_ORG.property15
  is '扩展信息15';
comment on column TP_PIM_ORG.property16
  is '扩展信息16';
comment on column TP_PIM_ORG.property17
  is '扩展信息17';
comment on column TP_PIM_ORG.property18
  is '扩展信息18';
comment on column TP_PIM_ORG.property19
  is '扩展信息19';
comment on column TP_PIM_ORG.property20
  is '扩展信息20';
comment on column TP_PIM_ORG.property21
  is '扩展信息21';
comment on column TP_PIM_ORG.property22
  is '扩展信息22';
comment on column TP_PIM_ORG.property23
  is '扩展信息23';
comment on column TP_PIM_ORG.property24
  is '扩展信息24';
comment on column TP_PIM_ORG.property25
  is '扩展信息25';
comment on column TP_PIM_ORG.property26
  is '扩展信息26';
comment on column TP_PIM_ORG.property27
  is '扩展信息27';
comment on column TP_PIM_ORG.property28
  is '扩展信息28';
comment on column TP_PIM_ORG.property29
  is '扩展信息29';
comment on column TP_PIM_ORG.property30
  is '扩展信息30';
alter table TP_PIM_ORG
  add constraint PK_TP_PIM_ORG primary key (ORGIDT);

prompt

prompt Creating table TP_PIM_ORG_CHGLOG
prompt ================================
prompt

create table TP_PIM_ORG_CHGLOG
(
  chgtyp  VARCHAR2(10),
  chgdate DATE,
  orgidt  VARCHAR2(16) not null,
  orgnam  VARCHAR2(100),
  chgdesc clob,
  usrid   VARCHAR2(32) not null,
  usrnam  VARCHAR2(100),
  remark  VARCHAR2(2000)
)
;
comment on table TP_PIM_ORG_CHGLOG
  is '机构信息更改记录';
comment on column TP_PIM_ORG_CHGLOG.chgtyp
  is '变更类型';
comment on column TP_PIM_ORG_CHGLOG.chgdate
  is '变更日期';
comment on column TP_PIM_ORG_CHGLOG.orgidt
  is '机构代码';
comment on column TP_PIM_ORG_CHGLOG.orgnam
  is '机构名称';
comment on column TP_PIM_ORG_CHGLOG.chgdesc
  is '变更描述(自动填写)';
comment on column TP_PIM_ORG_CHGLOG.usrid
  is '变更人';
comment on column TP_PIM_ORG_CHGLOG.usrnam
  is '变更人名称';
comment on column TP_PIM_ORG_CHGLOG.remark
  is '变更备注(人工填写)';

prompt

prompt Creating table TP_PIM_ORG_CHGTYP_DICT
prompt =====================================
prompt

create table TP_PIM_ORG_CHGTYP_DICT
(
  id  NUMBER,
  nam VARCHAR2(100)
)
;
comment on table TP_PIM_ORG_CHGTYP_DICT
  is '机构变动类型字典表';
comment on column TP_PIM_ORG_CHGTYP_DICT.id
  is '类型ID';
comment on column TP_PIM_ORG_CHGTYP_DICT.nam
  is '类型名称';

prompt

prompt Creating table TP_PIM_ORG_COL_CONFIG
prompt ====================================
prompt

create table TP_PIM_ORG_COL_CONFIG
(
  col_code   VARCHAR2(50) not null,
  col_name   VARCHAR2(50),
  col_enname VARCHAR2(50),
  col_desc   VARCHAR2(1000),
  prop       VARCHAR2(50),
  maxlen     NUMBER(4),
  ord        NUMBER(3),
  is_extend  CHAR(1) default '0',
  viewsql    VARCHAR2(1000),
  comp_typ   VARCHAR2(50)
)
;
comment on table TP_PIM_ORG_COL_CONFIG
  is '机构信息配置表';
comment on column TP_PIM_ORG_COL_CONFIG.col_code
  is '字段代码';
comment on column TP_PIM_ORG_COL_CONFIG.col_name
  is '字段业务名称';
comment on column TP_PIM_ORG_COL_CONFIG.col_enname
  is '字段英文名称';
comment on column TP_PIM_ORG_COL_CONFIG.col_desc
  is '字段描述';
comment on column TP_PIM_ORG_COL_CONFIG.prop
  is '属性列代码';
comment on column TP_PIM_ORG_COL_CONFIG.maxlen
  is '最大长度';
comment on column TP_PIM_ORG_COL_CONFIG.ord
  is '显示顺序';
comment on column TP_PIM_ORG_COL_CONFIG.is_extend
  is '是否扩展字段';
comment on column TP_PIM_ORG_COL_CONFIG.viewsql
  is '控件SQL';
comment on column TP_PIM_ORG_COL_CONFIG.comp_typ
  is '控件类型';
alter table TP_PIM_ORG_COL_CONFIG
  add constraint PK_TP_PIM_ORG_COL_CONFIG primary key (COL_CODE);

prompt

prompt Creating table TP_PIM_ORG_EXT_CONF
prompt ==================================
prompt

create table TP_PIM_ORG_EXT_CONF
(
  tabnam  VARCHAR2(30),
  colnam  VARCHAR2(30),
  colcode VARCHAR2(30),
  ord     NUMBER
)
;
-- Add comments to the table 
comment on table TP_PIM_ORG_EXT_CONF
  is '机构控件更多按钮扩展表';
-- Add comments to the columns 
comment on column TP_PIM_ORG_EXT_CONF.tabnam
  is '机构映射来源表';
comment on column TP_PIM_ORG_EXT_CONF.colnam
  is '列名';
comment on column TP_PIM_ORG_EXT_CONF.colcode
  is '列字段';
comment on column TP_PIM_ORG_EXT_CONF.ord
  is '排序';

prompt

prompt Creating table TP_PIM_ORG_MAP
prompt =============================
prompt

create table TP_PIM_ORG_MAP
(
  orgidt  VARCHAR2(10) not null,
  srcorg  VARCHAR2(30) not null,
  srcsys  VARCHAR2(60) not null,
  adduid  VARCHAR2(32),
  adddate DATE,
  moduid  VARCHAR2(32),
  moddate DATE,
  manauto CHAR(1)
)
;
comment on table TP_PIM_ORG_MAP
  is '管理机构和各系统机构对应关系';
comment on column TP_PIM_ORG_MAP.orgidt
  is '机构号    ';
comment on column TP_PIM_ORG_MAP.srcorg
  is '源系统机构号';
comment on column TP_PIM_ORG_MAP.srcsys
  is '源系统';
comment on column TP_PIM_ORG_MAP.adduid
  is '添加人';
comment on column TP_PIM_ORG_MAP.adddate
  is '添加时间';
comment on column TP_PIM_ORG_MAP.moduid
  is '最后修改人';
comment on column TP_PIM_ORG_MAP.moddate
  is '最后修改时间';
comment on column TP_PIM_ORG_MAP.manauto
  is '是否手动维护';
alter table TP_PIM_ORG_MAP
  add constraint PK_TP_PIM_ORG_MAP primary key (ORGIDT, SRCORG, SRCSYS);

prompt

prompt Creating table TP_PIM_ORG_REMIND
prompt ================================
prompt

create table TP_PIM_ORG_REMIND
(
  cendat     VARCHAR2(8),
  sysid      VARCHAR2(16),
  src_orgidt VARCHAR2(100),
  src_orgnam VARCHAR2(200),
  chgtyp     VARCHAR2(2),
  chginfo    VARCHAR2(1000),
  remindflag VARCHAR2(1)
)
;
comment on table TP_PIM_ORG_REMIND
  is '机构变动记录表';
comment on column TP_PIM_ORG_REMIND.cendat
  is '日期';
comment on column TP_PIM_ORG_REMIND.sysid
  is '源系统';
comment on column TP_PIM_ORG_REMIND.src_orgidt
  is '机构号';
comment on column TP_PIM_ORG_REMIND.src_orgnam
  is '机构名称';
comment on column TP_PIM_ORG_REMIND.chgtyp
  is '变动类型';
comment on column TP_PIM_ORG_REMIND.chginfo
  is '变更信息摘要';
comment on column TP_PIM_ORG_REMIND.remindflag
  is '提醒标识';

prompt

prompt Creating table TP_PIM_ORG_SRCSYS
prompt ================================
prompt

create table TP_PIM_ORG_SRCSYS
(
  srcsys   VARCHAR2(60) not null,
  sysdes   VARCHAR2(100),
  tabname  VARCHAR2(200),
  rootnode VARCHAR2(16)
)
;
comment on table TP_PIM_ORG_SRCSYS
  is '机构抽取源系统参数表';
comment on column TP_PIM_ORG_SRCSYS.srcsys
  is '源系统';
comment on column TP_PIM_ORG_SRCSYS.sysdes
  is '源系统描述';
comment on column TP_PIM_ORG_SRCSYS.tabname
  is '物理表名';
comment on column TP_PIM_ORG_SRCSYS.rootnode
  is '根节点';
alter table TP_PIM_ORG_SRCSYS
  add constraint PK_TP_PIM_ORG_SRCSYS primary key (SRCSYS);

prompt

prompt Creating view V_PIM_ORG
prompt =======================
prompt

CREATE OR REPLACE FORCE VIEW V_PIM_ORG AS
SELECT ORGIDT ORGIDT,
       ORGNAM ORGNAM,
       SHORT_NAM SHORTNAM,
       UP_ORGIDT UP_ORG_CDE,
       ORGLVL ORGLVL
FROM TP_PIM_ORG;
spool off


-- Create table
create table T_DIM_CDEORG
(
  orgidt    VARCHAR2(8) not null,
  orgnam    NVARCHAR2(100),
  up_orgidt VARCHAR2(5),
  isresp    INTEGER,
  status    VARCHAR2(1),
  orglvl    INTEGER,
  banlvl    INTEGER,
  citcde    VARCHAR2(4),
  orgtyp    INTEGER,
  issum     INTEGER,
  orggrade  INTEGER,
  isenty    INTEGER default 1,
  statgrade INTEGER,
  misorgtyp INTEGER,
  short_nam VARCHAR2(100)
);
-- Add comments to the table 
comment on table T_DIM_CDEORG
  is '机构表';
-- Add comments to the columns 
comment on column T_DIM_CDEORG.orgidt
  is '机构号    ';
comment on column T_DIM_CDEORG.orgnam
  is '机构名称  ';
comment on column T_DIM_CDEORG.up_orgidt
  is '上级机构号';
comment on column T_DIM_CDEORG.isresp
  is '是否责任中心(0:是纯机构,1:是纯责任中心,2:既是机构又是责任中心)';
comment on column T_DIM_CDEORG.status
  is '机构状态(1：正常,2：已撤销)';
comment on column T_DIM_CDEORG.orglvl
  is 'GL机构层级';
comment on column T_DIM_CDEORG.banlvl
  is 'BANCS机构层级';
comment on column T_DIM_CDEORG.citcde
  is '城市代码';
comment on column T_DIM_CDEORG.orgtyp
  is 'BANCS机构类型(0：总行,1：一级分行,2：直属分行,3：二级分行,4：管辖分行,5：经营性机构,8：业务经营部门,9：虚拟机构)';
comment on column T_DIM_CDEORG.issum
  is '是否汇总机构';
comment on column T_DIM_CDEORG.orggrade
  is '网点等级';
comment on column T_DIM_CDEORG.isenty
  is '是否实体机构(1:实体机构,0:虚拟机构)';
comment on column T_DIM_CDEORG.statgrade
  is '统计口径网点等级';
comment on column T_DIM_CDEORG.misorgtyp
  is 'MIS机构类型(1:城区网点,2:县域网点,其他无意义)';
comment on column T_DIM_CDEORG.short_nam
  is '机构简称';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T_DIM_CDEORG
  add constraint PK_T_CDEORG primary key (ORGIDT);

--FTP服务器表
create table TP_PIM_FTP
(
  FTP_ID      VARCHAR2(50) not null,
  FTP_DESC    VARCHAR2(50),
  SERVER_IP   VARCHAR2(50) not null,
  SERVER_PORT INTEGER not null,
  USERNAME    VARCHAR2(50) not null,
  PASSWORD    VARCHAR2(100) not null,
  URL         VARCHAR2(100) not null
);
comment on table TP_PIM_FTP
  is 'FTP服务器表';
comment on column TP_PIM_FTP.FTP_ID
  is 'FTP方案ID';
comment on column TP_PIM_FTP.FTP_DESC
  is 'FTP方案名称';
comment on column TP_PIM_FTP.SERVER_IP
  is 'FTP服务器IP地址';
comment on column TP_PIM_FTP.SERVER_PORT
  is 'FTP服务器端口号';
comment on column TP_PIM_FTP.USERNAME
  is '用户名';
comment on column TP_PIM_FTP.PASSWORD
  is '用户密码';
comment on column TP_PIM_FTP.URL
  is '目标文件路径';
alter table TP_PIM_FTP
  add constraint PK_TP_PIM_FTP primary key (FTP_ID);

--JDBC连接
create table TP_PIM_JDBC
(
  CONNECT_ID   VARCHAR2(50) not null,
  CONNECT_DESC VARCHAR2(100),
  IP           VARCHAR2(50) not null,
  PORT         VARCHAR2(10) not null,
  SID          VARCHAR2(50) not null,
  USERNAME     VARCHAR2(50) not null,
  PASSWORD     VARCHAR2(100) not null,
  REMARK       VARCHAR2(100)
);
comment on table TP_PIM_JDBC
  is '数据库连接配置表';
comment on column TP_PIM_JDBC.CONNECT_ID
  is '数据库连接';
comment on column TP_PIM_JDBC.CONNECT_DESC
  is '数据库连接描述说明';
comment on column TP_PIM_JDBC.IP
  is '数据库服务器IP';
comment on column TP_PIM_JDBC.SID
  is '数据库实例名';
comment on column TP_PIM_JDBC.USERNAME
  is '数据库用户名';
comment on column TP_PIM_JDBC.PASSWORD
  is '数据库用户密码';
comment on column TP_PIM_JDBC.REMARK
  is '备注';
alter table TP_PIM_JDBC
  add constraint PK_TP_PIM_JDBC primary key (CONNECT_ID);

--主机表
create table tp_pim_host
(
  HOST_ID   VARCHAR2(50) not null,
  HOST_NAME VARCHAR2(100) not null,
  SERVER_IP VARCHAR2(50) not null,
  USERNAME  VARCHAR2(50) not null,
  PASSWORD  VARCHAR2(100) not null,
  CONN_TYPE VARCHAR2(50) not null,
  REMARK    VARCHAR2(800)
);
comment on table tp_pim_host
  is '主机配置表';
comment on column tp_pim_host.HOST_ID
  is '主机编号';
comment on column tp_pim_host.HOST_NAME
  is '主机名称';
comment on column tp_pim_host.SERVER_IP
  is '主机IP地址';
comment on column tp_pim_host.USERNAME
  is '用户名';
comment on column tp_pim_host.PASSWORD
  is '密码';
comment on column tp_pim_host.CONN_TYPE
  is '连接方式(TELNET/SSH)';
comment on column tp_pim_host.REMARK
  is '备注';

alter table tp_pim_host
  add constraint PK_tp_pim_host primary key (HOST_ID);

-- Create table
create table TP_DEMO_CRUD
(
  id        VARCHAR2(32) not null,
  nam       VARCHAR2(100) not null,
  orgidt    VARCHAR2(8),
  moduid    VARCHAR2(32),
  modate    DATE default sysdate,
  remark    VARCHAR2(200),
  phone_num VARCHAR2(11),
  position  VARCHAR2(50),
  address   VARCHAR2(50),
  birthday  NUMBER(8)
);
-- Add comments to the table 
comment on table TP_DEMO_CRUD
  is 'DEMO之CRUD';
-- Add comments to the columns 
comment on column TP_DEMO_CRUD.id
  is 'ID';
comment on column TP_DEMO_CRUD.nam
  is '名称';
comment on column TP_DEMO_CRUD.orgidt
  is '所属机构';
comment on column TP_DEMO_CRUD.moduid
  is '最后维护人ID';
comment on column TP_DEMO_CRUD.modate
  is '最后维护日期';
comment on column TP_DEMO_CRUD.remark
  is '备注';
comment on column TP_DEMO_CRUD.phone_num
  is '电话';
comment on column TP_DEMO_CRUD.position
  is '职位';
comment on column TP_DEMO_CRUD.address
  is '地址';
comment on column TP_DEMO_CRUD.birthday
  is '出生日期';
;

-- Create table
create table TP_PIM_BIGQUERY_CACHE
(
  id       VARCHAR2(32) default sys_guid() not null,
  key      VARCHAR2(1000),
  val      BLOB,
  src      VARCHAR2(300),
  savetime NUMBER,
  adddate  DATE default sysdate,
  filler1  VARCHAR2(100),
  filler2  VARCHAR2(100),
  filler3  VARCHAR2(100),
  filler4  VARCHAR2(100),
  filler5  VARCHAR2(100)
);
-- Add comments to the columns 
comment on column TP_PIM_BIGQUERY_CACHE.id
  is 'id';
comment on column TP_PIM_BIGQUERY_CACHE.key
  is '缓存key值';
comment on column TP_PIM_BIGQUERY_CACHE.val
  is '缓存数据，JAVA对象';
comment on column TP_PIM_BIGQUERY_CACHE.src
  is '原始调用对象';
comment on column TP_PIM_BIGQUERY_CACHE.savetime
  is '保存时间';
comment on column TP_PIM_BIGQUERY_CACHE.adddate
  is '添加时间';
comment on column TP_PIM_BIGQUERY_CACHE.filler1
  is '预留字段';
comment on column TP_PIM_BIGQUERY_CACHE.filler2
  is '预留字段';
comment on column TP_PIM_BIGQUERY_CACHE.filler3
  is '预留字段';
comment on column TP_PIM_BIGQUERY_CACHE.filler4
  is '预留字段';
comment on column TP_PIM_BIGQUERY_CACHE.filler5
  is '预留字段';
  

-- Create table
create table TP_PIM_FAVORITE
(
  restyp_code VARCHAR2(50),
  res_id      VARCHAR2(50),
  favuid      VARCHAR2(50),
  favdate     DATE
);
-- Add comments to the columns 
comment on column TP_PIM_FAVORITE.restyp_code
  is '资源类型代码';
comment on column TP_PIM_FAVORITE.res_id
  is '资源ID';
comment on column TP_PIM_FAVORITE.favuid
  is '收藏人用户id';
comment on column TP_PIM_FAVORITE.favdate
  is '收藏日期';


-- Create table
create table TP_PIM_FOOTPRINT
(
  restyp_code VARCHAR2(50),
  res_id      VARCHAR2(50),
  visituid    VARCHAR2(50),
  visitdate   DATE
);
-- Add comments to the columns 
comment on column TP_PIM_FOOTPRINT.restyp_code
  is '资源类型代码';
comment on column TP_PIM_FOOTPRINT.res_id
  is '资源ID';
comment on column TP_PIM_FOOTPRINT.visituid
  is '访问人ID';
comment on column TP_PIM_FOOTPRINT.visitdate
  is '访问日期';
  
-- Create table
create table TP_PIM_SENSITIVEINFO
(
  id           VARCHAR2(32) default sys_guid(),
  name         VARCHAR2(100),
  filter_type  VARCHAR2(2),
  filter_rules VARCHAR2(500),
  filter_desc  VARCHAR2(200),
  filler1      VARCHAR2(200),
  filler2      VARCHAR2(200),
  filler3      VARCHAR2(200),
  filler4      VARCHAR2(200),
  filler5      VARCHAR2(200)
);
-- Add comments to the table 
comment on table TP_PIM_SENSITIVEINFO
  is '敏感信息表';
-- Add comments to the columns 
comment on column TP_PIM_SENSITIVEINFO.name
  is '描述';
comment on column TP_PIM_SENSITIVEINFO.filter_type
  is '过滤类型， 0/显示为空，1/保留几位其他使用占位符代替，2/可以看到制定规则内的数据';
comment on column TP_PIM_SENSITIVEINFO.filter_rules
  is '过滤规则';
comment on column TP_PIM_SENSITIVEINFO.filter_desc
  is '过滤描述';
comment on column TP_PIM_SENSITIVEINFO.filler1
  is '预留字段1';
comment on column TP_PIM_SENSITIVEINFO.filler2
  is '预留字段2';
comment on column TP_PIM_SENSITIVEINFO.filler3
  is '预留字段3';
comment on column TP_PIM_SENSITIVEINFO.filler4
  is '预留字段4';
comment on column TP_PIM_SENSITIVEINFO.filler5
  is '预留字段5';





CREATE OR REPLACE TYPE TYP_MYBI_OBJID                                                                                                                                                                                                                                                                                                   as
object(obj_id varchar2(50));
/

CREATE OR REPLACE TYPE TYP_MYBI_OBJTAB                                                                                                                                                                                                                                                                                                                                                                                                                                                             as
table of TYP_MYBI_OBJID;
/

create or replace package PKG_PIM is
    procedure withdrawAccess_obj(restyp_code_in in varchar2);
    PROCEDURE REF_TP_PIM_ORG_MAP;
end PKG_PIM;
/

CREATE OR REPLACE PACKAGE BODY PKG_PIM AS

procedure withdrawAccess_obj(restyp_code_in in varchar2) as
  /*
  ******************************************************************************************
  功能名称：角色权限资源回收
  ******************************************************************************************
  参数说明：
  ******************************************************************************************
  实现思路：
  ******************************************************************************************
  修改历史：
      create  houjianzhi   2013/3/20 14:36
  ******************************************************************************************
  */
  tmp_par VARCHAR2(2000);
  cnt     integer;
begin
  loop
    delete from tp_pim_role_res
     where res_id in
           (select res_id
              from (select res.*,
                           org.orgidt,
                           org.up_org_cde,
                           (select count(*)
                              from tp_pim_role_res tmp
                             where tmp.restyp_code = 'TS_FUNCTION' --restyp_code_in
                               and tmp.res_id = res.res_id
                               and tmp.role_id in
                                   (select id
                                      from tp_pim_role r
                                     where r.orgidt = org.up_org_cde)
                               and tmp.role_id != '0') as up_org_count
                      from (select *
                              from tp_pim_role_res
                             where restyp_code = 'TS_FUNCTION' --restyp_code_in
                            ) res,
                           tp_pim_role role,
                           v_pim_org org
                     where res.role_id = role.id
                       and role.orgidt = org.orgidt
                       and org.orgidt != (select orgidt
                                            from tp_pim_user u
                                           where u.id = '1'))
             where up_org_count = 0);
    select count(1)
      into cnt
      from tp_pim_role_res
     where res_id in
           (select res_id
              from (select res.*,
                           org.orgidt,
                           org.up_org_cde,
                           (select count(*)
                              from tp_pim_role_res tmp
                             where tmp.restyp_code = restyp_code_in --'TS_FUNCTION'
                               and tmp.res_id = res.res_id
                               and tmp.role_id in
                                   (select id
                                      from tp_pim_role r
                                     where r.orgidt = org.up_org_cde)
                               and tmp.role_id != '0') as up_org_count
                      from (select *
                              from tp_pim_role_res
                             where restyp_code = restyp_code_in --'TS_FUNCTION'
                            ) res,
                           tp_pim_role role,
                           v_pim_org org
                     where res.role_id = role.id
                       and role.orgidt = org.orgidt
                       and org.orgidt != (select orgidt
                                            from tp_pim_user u
                                           where u.id = '1'))
             where up_org_count = 0);
    exit when cnt = 0;
  end loop;
end withdrawAccess_obj;

PROCEDURE REF_TP_PIM_ORG_MAP IS
    /************************************************************************
    *      文 件 名: REF_TP_PIM_ORG_MAP
    *      程 序 名: 机构映射表加工
    *      功能描述: 根据配置自动加工机构表
    *      目标表  ：TP_PIM_ORG_MAP
    *      入口参数:
    *        CENDAT   VARCHAR2(8)    期数
    *      出口参数：
    *
    *      运行脚本:
    *
    *      创建者：dongzhaowu
    *      创建日期：20150625
    *      版本号：v1.00
    *      修改历史：
    *      ===== ============= ========================================
    *      姓名                            日期                       描述
    *      ===== ============= ========================================
    **************************************************************************/
BEGIN

    --删除MAP表中自动化维护的机构映射关系历史数据
    DELETE FROM TP_PIM_ORG_MAP
    WHERE MANAUTO = '0';
    COMMIT;
    --根据自动抽取的机构插入TP_PIM_ORG_MAP
    --根据TP_PIM_ORG_SRCSYS 中查找有几套源系统机构分别进行更新处理
    FOR RSRCSYS IN (SELECT SRCSYS
                    FROM TP_PIM_ORG_SRCSYS)
    LOOP

        FOR UPORG IN (SELECT ORGIDT
                      FROM TP_PIM_ORG
                      CONNECT BY NOCYCLE PRIOR ORGIDT = UP_ORGIDT
                      START WITH ORGIDT = (SELECT PVAL FROM TP_PIM_PARAM WHERE PKEY = 'LOCAL_TOP_ORGIDT'))
        LOOP
            INSERT INTO TP_PIM_ORG_MAP
                (ORGIDT,
                 SRCORG,
                 SRCSYS,
                 MANAUTO)
                SELECT UPORG.ORGIDT,
                       ORGIDT,
                       SRCSYS,
                       MANAUTO
                FROM (SELECT ORGIDT,
                             UP_ORGIDT,
                             RSRCSYS.SRCSYS SRCSYS,
                             '0' AS MANAUTO
                      FROM TP_PIM_ORG
                      UNION ALL
                      SELECT SRCORG,
                             ORGIDT AS UP_ORGIDT,
                             RSRCSYS.SRCSYS SRCSYS,
                             MANAUTO
                      FROM TP_PIM_ORG_MAP
                      WHERE SRCSYS = RSRCSYS.SRCSYS AND
                            MANAUTO = '1' 
                      --添加手工维护的
                      )
                WHERE CONNECT_BY_ISLEAF = 1
                CONNECT BY NOCYCLE PRIOR ORGIDT = UP_ORGIDT
                START WITH ORGIDT = UPORG.ORGIDT;
            COMMIT;
        END LOOP;
    END LOOP;
END;
end PKG_PIM;
/

CREATE OR REPLACE PACKAGE PKG_MYBI_CORE AS
/************************************************************************
    *      文 件 名:PKG_MYBI_CORE.pkg
    *      程 序 名: mybi基础包
    *      功能描述: 主要处理权限等
    *
    *      创建者：ian shan
    *      创建日期：2014-11-29
    *      版本号：v1.00
    *      修改历史：
    *
**************************************************************************/


  -- Author  : ian shan
  -- Created : 2014/11/26
  -- Purpose : 获取非特例访问用户权限

  type myrctype is ref cursor;

  FUNCTION getAccess_obj(p_objtyp IN VARCHAR2, p_userid IN VARCHAR2) RETURN TYP_MYBI_OBJTAB
        PIPELINED;
END PKG_MYBI_CORE;
/

CREATE OR REPLACE PACKAGE BODY PKG_MYBI_CORE AS

  FUNCTION getAccess_obj(p_objtyp IN VARCHAR2, p_userid IN VARCHAR2)
    RETURN TYP_MYBI_OBJTAB
    PIPELINED AS
    v TYP_MYBI_OBJID;
   /************************************************************************
    *      文 件 名: getAccess_obj
    *      程 序 名: 资源访问控制
    *      功能描述: 获取用户资源访问权限
    *
    *      参数:
    *        p_objtyp   varchar2    资源类型
    *        p_userid   number      用户ID
    *      返回：
    *        PIPE  资源权限列表
    *      创建者：ian shan
    *      创建日期：20141129
    *      版本号：v1.00
    *      修改历史：
    *      ===== ============= ========================================
    *      姓名                            日期                       描述
    *      ===== ============= ========================================
  **************************************************************************/

    V_CNT         NUMBER;
    V_USERORG     VARCHAR2(50);
    V_DEFAULT_SQL VARCHAR2(1000);
    rc            myrctype; --定义ref cursor变量
    V_SPECIAL     VARCHAR2(300);
  BEGIN
    V_SPECIAL := 'select res_id from TP_PIM_USER_RES where user_id = ''' ||
                 p_userid || ''' and restyp_code = ''' || p_objtyp || '''';
    select count(*)
      into V_CNT
      from TP_PIM_USER_ROLE role, TP_PIM_ROLE_RES roleres

     where user_id = p_userid
       and role.role_id = roleres.role_id
       and restyp_code = p_objtyp;

    begin
      select default_access
        into V_DEFAULT_SQL
        from TP_PIM_RESTYP
       where code = p_objtyp;
    EXCEPTION
      WHEN OTHERS THEN
        V_DEFAULT_SQL := null;
    end;
    if v_cnt = 0 and V_DEFAULT_SQL is not null then
      open rc for replace(V_DEFAULT_SQL, '@USER_ID@', p_userid) || ' union all ' || V_SPECIAL;
    else
      open rc for
        select roleres.res_id
          from TP_PIM_USER_ROLE role, TP_PIM_ROLE_RES roleres
         where user_id = p_userid
           and role.role_id = roleres.role_id
           and restyp_code = p_objtyp
        union all
        select res_id
          from TP_PIM_USER_RES
         where user_id = p_userid
           and restyp_code = p_objtyp;
    end if;

    loop
      fetch rc
        into V_USERORG;
      exit when rc%notfound;
      v := typ_mybi_objid(V_USERORG);
      PIPE ROW(v);
    end loop;
    close rc;
    return;

  END getAccess_obj;
END PKG_MYBI_CORE;
/
