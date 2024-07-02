

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



DELETE FROM course_grade;
DELETE FROM course;
DELETE FROM student;

INSERT INTO student (sn, no, name)  VALUES
    (101, 'S001',  '����'),
    (102, 'S002',  '����'), 
    (103, 'S003',  '����'),
    (104, 'S004',  '����');

INSERT INTO course (sn, no, name, credit, credit_hour)  VALUES 
    (101, 'C01',  '����', 6, 60), 
    (102, 'C02',  '����', 2, 36),
    (103, 'C03',  '�ߴ�', 3, 40),
    (104, 'C04',  '�˳�', 4, 32),
    (105, 'C05',  '����', 3, 38);


INSERT INTO course_grade (stu_sn, cou_sn, grade)  VALUES 
    (101, 101,  91), 
    (102, 101,  89),
    (103, 101,  90),
    (101, 102,  89);


INSERT INTO classes (sn, no, name, term, place, course)  VALUES 
    (101, 'C01',  '����1��', '2024����', '��һ������ѧ¥A101', '����'), 
    (102, 'C02',  '����2��', '2024����', '��һ������ѧ¥A201', '����'),
    (103, 'C03',  '����1��', '2024����', '��һ������ѧ¥B101', '����'),
    (104, 'C04',  '����2��', '2024����', '��һ������ѧ¥B201', '����'),
    (105, 'C05',  '�ߴ�1��', '2024����', '��һ������ѧ¥A108', '�ߴ�'),
    (106, 'C06',  '�ߴ�2��', '2024����', '��һ������ѧ¥A208', '�ߴ�'),
    (107, 'C07',  '�˳�1��', '2024����', '��һ������ѧ¥C108', '�˳�'),
    (108, 'C08',  '�˳�2��', '2024����', '��һ������ѧ¥C109', '�˳�'),
    (109, 'C09',  '����1��', '2024����', '��һ������ѧ¥C208', '����'),
    (110, 'C10',  '����2��', '2024����', '��һ������ѧ¥C209', '����');
   
INSERT INTO classes_grade (stu_sn, cla_sn, grade)  VALUES 
    (104, 101,  91);
    


