create table PERSON (
    ssn varchar(9) not null,
    bdate date,
    sex char(2),
    fname varchar(20) not null,
    minit char(1),
    lname varchar(20) not null,
    address varchar(50),
    
    primary key(ssn)
) engine=InnoDB;

create table COURSE (
    course_num int not null,
    course_name varchar(20) not null,
    course_desc varchar(50),
    
    primary key (course_num)
) engine=InnoDB;

create table COLLEGE (
    col_name varchar(20) not null,
    col_dean varchar(15),
    col_office varchar(20),
    
    primary key (col_name)
) engine=InnoDB;

create table DEPARTMENT (
    dept_name varchar(20) not null,
    dept_phone varchar(20),
    dept_office varchar(20),
    clg_name varchar(20),
    crs_num int,
    
    primary key (dept_name),
    foreign key (clg_name) references COLLEGE(col_name),
    foreign key (crs_num) references COURSE(course_num)
) engine=InnoDB;

create table SECTION (
    section_num int not null,
    year year,
    qtr varchar(10),
    crs_num int,

    primary key (section_num),
    foreign key (crs_num) references COURSE(course_num)
) engine=InnoDB;

create table CURRENT_SECTION (
    cur_section_num int not null,

    primary key (cur_section_num),
    foreign key (cur_section_num) references SECTION(section_num)
) engine=InnoDB;

create table UNI_GRANT (
    num int not null,
    title varchar(20) not null,
    agency varchar(20),
    start_date date,
    
    primary key (num)
) engine=InnoDB;

create table INSTRUCTOR_RESEARCHER (
    inst_id varchar(10) not null,
    teach_sec int,
    
    primary key (inst_id),
    foreign key (teach_sec) references SECTION(section_num)
) engine=InnoDB;

create table FACULTY (
    pssn varchar(9) not null,
    ranking varchar(9),
    office varchar(20),
    phone varchar(20),
    salary float,
    researcher_id varchar(10),
    grant_no int,
    dept_chair varchar(20) unique,

    primary key (pssn),
    foreign key (pssn) references PERSON(ssn) on delete cascade,
    foreign key (researcher_id) references INSTRUCTOR_RESEARCHER(inst_id),
    foreign key (grant_no) references UNI_GRANT(num),
    foreign key (dept_chair) references DEPARTMENT(dept_name)
) engine=InnoDB;

create table STUDENT (
    pssn varchar(9) not null,
    class varchar(10) not null,
    researcher_id varchar(10),
    major varchar(20) not null,
    minor varchar(20),
    
    primary key (pssn),
    foreign key (pssn) references PERSON (ssn) on delete cascade,
    foreign key (researcher_id) references INSTRUCTOR_RESEARCHER(inst_id),
    foreign key (major) references DEPARTMENT(dept_name),
    foreign key (minor) references DEPARTMENT(dept_name)
) engine=InnoDB;

create table SUPPORT (
    spt_start date not null,
    spt_end date,
    spt_time time,
    
    grant_num int,
    inst_id varchar(10),
    
    primary key (grant_num, inst_id, spt_start),
    foreign key (grant_num) references UNI_GRANT(num) on delete cascade,
    foreign key (inst_id) references INSTRUCTOR_RESEARCHER(inst_id) on delete cascade
) engine=InnoDB;

create table BELONGS (
    fac_ssn varchar(9),
    dept_name varchar(20),
    
    primary key (fac_ssn, dept_name),
    foreign key (fac_ssn) references FACULTY(pssn) on delete cascade,
    foreign key (dept_name) references DEPARTMENT(dept_name) on delete cascade
) engine=InnoDB;

create table DEGREE (
    deg_num varchar(9) not null,
    college varchar(20),
    degree varchar(20),
    year date,
    
    primary key (deg_num)
) engine=InnoDB;

create table GRAD_STUDENT (
    gssn varchar(9) not null,
    degree varchar(9),
    advisor varchar(9),
    
    primary key (gssn),
    foreign key (gssn) references STUDENT(pssn) on delete cascade,
    foreign key (degree) references DEGREE(deg_num) on delete cascade,
    foreign key (advisor) references FACULTY(pssn)
) engine=InnoDB;

create table TRANSCRIPT (
    pssn varchar(9),
    sec_num int,
    grade varchar(9) not null,
    
    primary key (pssn, sec_num, grade),
    foreign key (pssn) references STUDENT(pssn) on delete cascade,
    foreign key (sec_num) references SECTION(section_num) on delete cascade
) engine=InnoDB;

create table COMMITEE (
    fac_ssn varchar(9),
    grad_ssn varchar(9),
    
    primary key (fac_ssn, grad_ssn),
    foreign key (fac_ssn) references FACULTY(pssn) on delete cascade,
    foreign key (grad_ssn) references GRAD_STUDENT(gssn) on delete cascade
) engine=InnoDB;

create table REGISTERED (
    cur_num int,
    stu_ssn varchar(9),
    
    primary key (cur_num, stu_ssn),
    foreign key (cur_num) references CURRENT_SECTION(cur_section_num) on delete cascade,
    foreign key (stu_ssn) references STUDENT(pssn) on delete cascade
) engine=InnoDB;


create view STUDENT_INFO as
select * 
from PERSON, STUDENT
where PERSON.ssn=STUDENT.pssn;

create view FACULTY_INFO as
select *
from PERSON, FACULTY
where PERSON.ssn=FACULTY.pssn;

create view CURRENT_SECTION_INFO as
select *
from SECTION, CURRENT_SECTION
where SECTION.section_num=CURRENT_SECTION.cur_section_num;

create view GRAD_STUDENT_INFO as
select *
from STUDENT, GRAD_STUDENT
where STUDENT.pssn=GRAD_STUDENT.gssn;

