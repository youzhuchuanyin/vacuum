-----------------------------------------
-- Export file for user CJRS10         --
-- Created by 111 on 2018/6/7, 8:16:09 --
-----------------------------------------

set define off
spool EQU_ACTIVITY.log

prompt
prompt Creating table EQU_ACTIVITY
prompt ===========================
prompt
create table CJRS10.EQU_ACTIVITY
(
  uuid           VARCHAR2(40) not null,
  company_code   VARCHAR2(2) not null,
  equipment_code VARCHAR2(25) not null,
  box_code       VARCHAR2(25) not null,
  work_procedure VARCHAR2(6) not null,
  start_time     VARCHAR2(20) not null,
  end_time       VARCHAR2(20),
  status         VARCHAR2(10) not null,
  operator_code  VARCHAR2(15) not null,
  operator_name  VARCHAR2(20) not null
)
tablespace RSDB
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
comment on column CJRS10.EQU_ACTIVITY.company_code
  is '��˾��';
comment on column CJRS10.EQU_ACTIVITY.equipment_code
  is '�豸���';
comment on column CJRS10.EQU_ACTIVITY.box_code
  is '������';
comment on column CJRS10.EQU_ACTIVITY.work_procedure
  is '����';
comment on column CJRS10.EQU_ACTIVITY.start_time
  is '��ʼʱ��';
comment on column CJRS10.EQU_ACTIVITY.end_time
  is '����ʱ��';
comment on column CJRS10.EQU_ACTIVITY.status
  is '״̬';
comment on column CJRS10.EQU_ACTIVITY.operator_code
  is '������Ա����';
comment on column CJRS10.EQU_ACTIVITY.operator_name
  is '������Ա����';


spool off
