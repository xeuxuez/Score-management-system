//dbschema_v0_1�������ݿ�ű���д�������ݿ���Ʒ���

//������
SET client_encoding TO 'GBK';


DROP DATABASE IF EXISTS examdb;

DROP ROLE IF EXISTS examdb; 

-- ����һ����½��ɫ���û������û���examdb, ȱʡ����pass
CREATE ROLE examdb LOGIN
  ENCRYPTED PASSWORD 'md568cefad35fed037c318b1e44cc3480cf' -- password: pass
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;

CREATE DATABASE examdb WITH OWNER = examdb ENCODING = 'UTF8';
   

