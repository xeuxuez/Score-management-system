

DROP TABLE IF EXISTS course_grade;

DROP TABLE IF EXISTS student;
CREATE TABLE IF NOT EXISTS student  (
    sn       INTEGER,     --序号
    no       VARCHAR(10), --学号
    name     TEXT,        --姓名
    gender   CHAR(1),     --性别(F/M/O)
    enrolled DATE,        --入学时间
    PRIMARY KEY(sn)
);

-- 给sn创建一个自增序号
CREATE SEQUENCE seq_student_sn 
    START 10000 INCREMENT 1 OWNED BY student.sn;
ALTER TABLE student ALTER sn 
    SET DEFAULT nextval('seq_student_sn');
-- 学号唯一
CREATE UNIQUE INDEX idx_student_no ON student(no);

-- === 课程表
DROP TABLE IF EXISTS course;
CREATE TABLE IF NOT EXISTS course  (
    sn       INTEGER,     --序号
    no       VARCHAR(10), --课程号
    name     TEXT,        --课程名称
    credit   NUMERIC(5,2), --课程学分
    credit_hour NUMERIC(5,2),--课程学时
    PRIMARY KEY(sn)
);
CREATE SEQUENCE seq_course_sn 
    START 10000 INCREMENT 1 OWNED BY course.sn;
ALTER TABLE course ALTER sn 
    SET DEFAULT nextval('seq_course_sn');
CREATE UNIQUE INDEX idx_course_no ON course(no);



DROP TABLE IF EXISTS course_grade;
CREATE TABLE IF NOT EXISTS course_grade  (
    stu_sn INTEGER,     -- 学生序号
    cou_sn INTEGER,     -- 课程序号
    grade  NUMERIC(5,2), -- 最终成绩
    PRIMARY KEY(stu_sn, cou_sn)
);

DROP TABLE IF EXISTS classes;
CREATE TABLE IF NOT EXISTS classes  (
    sn       INTEGER,     --序号
    no       VARCHAR(10), --班次号
    name     TEXT,        --班次名
    term     TEXT,        --学期
    place    TEXT,        --地点
    course   TEXT,        --课程名称
    PRIMARY KEY(sn)
);
CREATE SEQUENCE seq_classes_sn 
    START 10000 INCREMENT 1 OWNED BY classes.sn;
ALTER TABLE classes ALTER sn 
    SET DEFAULT nextval('seq_classes_sn');
CREATE UNIQUE INDEX idx_classes_no ON classes(no);


DROP TABLE IF EXISTS classes_grade;
CREATE TABLE IF NOT EXISTS classes_grade  (
    stu_sn INTEGER,     -- 学生序号
    cla_sn INTEGER,     -- 课程序号
    grade  NUMERIC(5,2), -- 最终成绩
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
    (101, 'S001',  '张三'),
    (102, 'S002',  '李四'), 
    (103, 'S003',  '王五'),
    (104, 'S004',  '马六');

INSERT INTO course (sn, no, name, credit, credit_hour)  VALUES 
    (101, 'C01',  '高数', 6, 60), 
    (102, 'C02',  '外语', 2, 36),
    (103, 'C03',  '线代', 3, 40),
    (104, 'C04',  '运筹', 4, 32),
    (105, 'C05',  '马哲', 3, 38);


INSERT INTO course_grade (stu_sn, cou_sn, grade)  VALUES 
    (101, 101,  91), 
    (102, 101,  89),
    (103, 101,  90),
    (101, 102,  89);


INSERT INTO classes (sn, no, name, term, place, course)  VALUES 
    (101, 'C01',  '高数1班', '2024春季', '第一公共教学楼A101', '高数'), 
    (102, 'C02',  '高数2班', '2024春季', '第一公共教学楼A201', '高数'),
    (103, 'C03',  '外语1班', '2024春季', '第一公共教学楼B101', '外语'),
    (104, 'C04',  '外语2班', '2024春季', '第一公共教学楼B201', '外语'),
    (105, 'C05',  '线代1班', '2024春季', '第一公共教学楼A108', '线代'),
    (106, 'C06',  '线代2班', '2024春季', '第一公共教学楼A208', '线代'),
    (107, 'C07',  '运筹1班', '2024春季', '第一公共教学楼C108', '运筹'),
    (108, 'C08',  '运筹2班', '2024春季', '第一公共教学楼C109', '运筹'),
    (109, 'C09',  '马哲1班', '2024春季', '第一公共教学楼C208', '马哲'),
    (110, 'C10',  '马哲2班', '2024春季', '第一公共教学楼C209', '马哲');
   
INSERT INTO classes_grade (stu_sn, cla_sn, grade)  VALUES 
    (104, 101,  91);
    


