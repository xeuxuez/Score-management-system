//dbschema_v0_1下是数据库脚本，写入了数据库设计方案

//创建库
SET client_encoding TO 'GBK';


DROP DATABASE IF EXISTS examdb;

DROP ROLE IF EXISTS examdb; 

-- 创建一个登陆角色（用户），用户名examdb, 缺省密码pass
CREATE ROLE examdb LOGIN
  ENCRYPTED PASSWORD 'md568cefad35fed037c318b1e44cc3480cf' -- password: pass
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;

CREATE DATABASE examdb WITH OWNER = examdb ENCODING = 'UTF8';
   

