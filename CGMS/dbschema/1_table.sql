//���ݿ��
SET client_encoding TO 'GBK';

DROP TABLE IF EXISTS course_grade;

DROP TABLE IF EXISTS student;
CREATE TABLE IF NOT EXISTS student  (
    sn       INTEGER,     --���
    no       VARCHAR(10), --ѧ��
    name     TEXT,        --����
    gender   CHAR(1),     --�Ա�(F/M/O)
    enrolled DATE,        --��ѧʱ��
    PRIMARY KEY(sn)
);

-- ��sn����һ���������
CREATE SEQUENCE seq_student_sn 
    START 10000 INCREMENT 1 OWNED BY student.sn;
ALTER TABLE student ALTER sn 
    SET DEFAULT nextval('seq_student_sn');
-- ѧ��Ψһ
CREATE UNIQUE INDEX idx_student_no ON student(no);

-- === �γ̱�
DROP TABLE IF EXISTS course;
CREATE TABLE IF NOT EXISTS course  (
    sn       INTEGER,     --���
    no       VARCHAR(10), --�γ̺�
    name     TEXT,        --�γ�����
    credit   NUMERIC(5,2), --�γ�ѧ��
    credit_hour NUMERIC(5,2),--�γ�ѧʱ
    PRIMARY KEY(sn)
);
CREATE SEQUENCE seq_course_sn 
    START 10000 INCREMENT 1 OWNED BY course.sn;
ALTER TABLE course ALTER sn 
    SET DEFAULT nextval('seq_course_sn');
CREATE UNIQUE INDEX idx_course_no ON course(no);



DROP TABLE IF EXISTS course_grade;
CREATE TABLE IF NOT EXISTS course_grade  (
    stu_sn INTEGER,     -- ѧ�����
    cou_sn INTEGER,     -- �γ����
    grade  NUMERIC(5,2), -- ���ճɼ�
    PRIMARY KEY(stu_sn, cou_sn)
);

DROP TABLE IF EXISTS classes;
CREATE TABLE IF NOT EXISTS classes  (
    sn       INTEGER,     --���
    no       VARCHAR(10), --��κ�
    name     TEXT,        --�����
    term     TEXT,        --ѧ��
    place    TEXT,        --�ص�
    course   TEXT,        --�γ�����
    PRIMARY KEY(sn)
);
CREATE SEQUENCE seq_classes_sn 
    START 10000 INCREMENT 1 OWNED BY classes.sn;
ALTER TABLE classes ALTER sn 
    SET DEFAULT nextval('seq_classes_sn');
CREATE UNIQUE INDEX idx_classes_no ON classes(no);


DROP TABLE IF EXISTS classes_grade;
CREATE TABLE IF NOT EXISTS classes_grade  (
    stu_sn INTEGER,     -- ѧ�����
    cla_sn INTEGER,     -- �γ����
    grade  NUMERIC(5,2), -- ���ճɼ�
    PRIMARY KEY(stu_sn, cla_sn)
);




ALTER TABLE course_grade 
   ADD CONSTRAINT stu_sn_fk FOREIGN KEY (stu_sn) REFERENCES student(sn);
ALTER TABLE course_grade 
   ADD CONSTRAINT cou_sn_fk FOREIGN KEY (cou_sn) REFERENCES course(sn);
ALTER TABLE classes_grade 
   ADD CONSTRAINT stu_sn_fk FOREIGN KEY (stu_sn) REFERENCES student(sn);
ALTER TABLE classes_grade 
   ADD CONSTRAINT cla_sn_fk FOREIGN KEY (cla_sn) REFERENCES classes(sn);

