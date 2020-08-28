-- CS4400: Introduction to Database Systems
-- Company Database Simple (v6 - Clean WITHOUT Primary and Foreign Keys)

-- This version of the database is intended to work with legacy versions of MySQL
-- It does include the tables and data, which are needed to practice the queries
-- It does not include the views, stored procedures and functions from other versions

-- This version also does NOT include primary and foreign keys by design
-- Primary Keys and Foreign Keys will be introduced at a later stage in the course

DROP DATABASE IF EXISTS company;
CREATE DATABASE IF NOT EXISTS company;
USE company;

-- Table structure for table employee

DROP TABLE IF EXISTS employee;
CREATE TABLE employee (
  fname char(10) NOT NULL,
  lname char(20) NOT NULL,
  ssn decimal(9,0) NOT NULL,
  bdate date NOT NULL,
  address char(30) NOT NULL,
  sex char(1) NOT NULL,
  salary decimal(5,0) NOT NULL,
  superssn decimal(9,0) DEFAULT NULL,
  dno decimal(1,0) NOT NULL
);

-- Dumping data for table employee

INSERT INTO employee VALUES ('John','Smith',123456789,'1965-01-09','731 Fondren, Houston TX','M',30000,333445555,5),('Franklin','Wong',333445555,'1955-12-08','638 Voss, Houston TX','M',40000,888665555,5),('Joyce','English',453453453,'1972-07-31','5631 Rice, Houston TX','F',25000,333445555,5),('Ramesh','Narayan',666884444,'1962-09-15','975 Fire Oak, Humble TX','M',38000,333445555,5),('James','Borg',888665555,'1937-11-10','450 Stone, Houston TX','M',55000,NULL,1),('Jennifer','Wallace',987654321,'1941-06-20','291 Berry, Bellaire TX','F',43000,888665555,4),('Ahmad','Jabbar',987987987,'1969-03-29','980 Dallas, Houston TX','M',25000,987654321,4),('Alicia','Zelaya',999887777,'1968-01-19','3321 Castle, Spring TX','F',25000,987654321,4);

-- Table structure for table dependent

DROP TABLE IF EXISTS dependent;
CREATE TABLE dependent (
  essn decimal(9,0) NOT NULL,
  dependent_name char(10) NOT NULL,
  sex char(1) NOT NULL,
  bdate date NOT NULL,
  relationship char(30) NOT NULL
);

-- Dumping data for table dependent

INSERT INTO dependent VALUES (123456789,'Alice','F','1988-12-30','Daughter'),(123456789,'Elizabeth','F','1967-05-05','Spouse'),(123456789,'Michael','M','1988-01-04','Son'),(333445555,'Alice','F','1986-04-04','Daughter'),(333445555,'Joy','F','1958-05-03','Spouse'),(333445555,'Theodore','M','1983-10-25','Son'),(987654321,'Abner','M','1942-02-28','Spouse');

-- Table structure for table department

DROP TABLE IF EXISTS department;
CREATE TABLE department (
  dname char(20) NOT NULL,
  dnumber decimal(1,0) NOT NULL,
  mgrssn decimal(9,0) NOT NULL,
  mgrstartdate date NOT NULL
);

-- Dumping data for table department

INSERT INTO department VALUES ('Headquarters',1,888665555,'1981-06-19'),('Administration',4,987654321,'1995-01-01'),('Research',5,333445555,'1988-05-22');

-- Table structure for table dept_locations

DROP TABLE IF EXISTS dept_locations;
CREATE TABLE dept_locations (
  dnumber decimal(1,0) NOT NULL,
  dlocation char(15) NOT NULL
);

-- Dumping data for table dept_locations

INSERT INTO dept_locations VALUES (1,'Houston'),(4,'Stafford'),(5,'Bellaire'),(5,'Houston'),(5,'Sugarland');

-- Table structure for table project

DROP TABLE IF EXISTS project;
CREATE TABLE project (
  pname char(20) NOT NULL,
  pnumber decimal(2,0) NOT NULL,
  plocation char(20) NOT NULL,
  dnum decimal(1,0) NOT NULL
);

-- Dumping data for table project

INSERT INTO project VALUES ('ProductX',1,'Bellaire',5),('ProductY',2,'Sugarland',5),('ProductZ',3,'Houston',5),('Computerization',10,'Stafford',4),('Reorganization',20,'Houston',1),('Newbenefits',30,'Stafford',4);

-- Table structure for table works_on

DROP TABLE IF EXISTS works_on;
CREATE TABLE works_on (
  essn decimal(9,0) NOT NULL,
  pno decimal(2,0) NOT NULL,
  hours decimal(5,1) DEFAULT NULL
);

-- Dumping data for table works_on

INSERT INTO works_on VALUES (123456789,1,32.5),(123456789,2,7.5),(333445555,2,10.0),(333445555,3,10.0),(333445555,10,10.0),(333445555,20,10.0),(453453453,1,20.0),(453453453,2,20.0),(666884444,3,40.0),(888665555,20,NULL),(987654321,20,15.0),(987654321,30,20.0),(987987987,10,35.0),(987987987,30,5.0),(999887777,10,10.0),(999887777,30,30.0);
