-- practiceQuery0: [book 0] Retrieve the birth date and address of the employees whose name is 'John Smith'.
CREATE OR REPLACE VIEW practicequery0 as 
SELECT bdate, address FROM employee WHERE lname="Smith" AND fname="John";
-- practiceQuery1: [book 1] Retrieve the first name, last name 
-- and address of all employees who work for the 'Research' department. 
CREATE OR REPLACE VIEW practicequery1 as 
SELECT fname, lname, address FROM employee WHERE dno = 5;
-- practiceQuery2: [book 2] For every project located in 'Stafford', list the project number, the controlling department number,
--  and the department manager's last name, address, and birth date.
CREATE OR REPLACE VIEW practicequery2 as
SELECT f.pnumber, f.dnum, f.lname, f.address, f.bdate FROM (
SELECT * FROM (
SELECT * FROM (SELECT * FROM project WHERE plocation LIKE "%Stafford%") e
LEFT JOIN department d ON e.dnum=d.dnumber) c
LEFT JOIN employee e2 ON c.mgrssn=e2.ssn) f;

-- practiceQuery3: [book 3] Find the names of employees who work on all the projects controlled by department number 5.
-- CREATE OR REPLACE VIEW Practice3 as
CREATE OR REPLACE VIEW practicequery3 as
SELECT fname, lname FROM employee e
LEFT JOIN (
SELECT * FROM (
SELECT essn, COUNT(essn) AS "Num" FROM works_On WHERE pno=1 OR pno=2 OR pno=3 GROUP BY essn) a WHERE a.Num=3) b
ON e.ssn=b.essn WHERE b.Num=3;

-- practiceQuery4: [book 4] Make a list of project numbers for projects that involve an employee whose last name is 'Smith', 
-- either as a worker or as a manager of the department that controls the project.
CREATE OR REPLACE VIEW practicequery4 as
SELECT b.pno FROM (SELECT * FROM employee) a 
LEFT JOIN (
SELECT essn, pno FROM works_on) b ON b.essn=a.ssn WHERE a.lname="Smith";

-- practiceQuery5: [book 5] List the names of all employees with two or more dependents.
CREATE OR REPLACE VIEW practicequery5 as
SELECT a.fname, a.lname FROM (
SELECT * FROM employee) a 
INNER JOIN (
SELECT essn, COUNT(essn) FROM dependent GROUP BY essn HAVING COUNT(*) > 2) b ON a.ssn=b.essn ;

-- practiceQuery6: [book 6] Retrieve the names of employees who have no dependents.
CREATE OR REPLACE VIEW practicequery6 as
SELECT fname, lname FROM (
SELECT * FROM employee) a 
LEFT JOIN (
SELECT essn, COUNT(*) AS "Num" FROM dependent GROUP BY essn) b ON a.ssn=b.essn WHERE b.Num is NULL;

-- practiceQuery7: [book 7] List the names of managers who have at least one dependent.
CREATE OR REPLACE VIEW practicequery7 as
SELECT fname, lname FROM employee e
INNER JOIN (
SELECT DISTINCT(superssn) AS mgrssn FROM (
SELECT * FROM employee) a
LEFT JOIN (
SELECT essn, COUNT(*) AS "Num" FROM dependent GROUP BY essn) b ON a.superssn=b.essn WHERE b.Num>0) c 
ON c.mgrssn=e.ssn;

-- practiceQuery8: [book 8] For each employee, retrieve the employee's first
-- and last name and the first and last name of his or her immediate supervisor.
CREATE OR REPLACE VIEW practicequery8 as
SELECT e1.fname, e1.lname, e2.fname AS "e2FName", e2.lname AS "e2lNameFROM" FROM employee e1
LEFT JOIN employee e2 ON e1.superssn=e2.ssn;

-- practiceQuery9: [book 9] Select all of the employee's Social Security Numbers.
CREATE OR REPLACE VIEW practicequery9 as 
SELECT ssn FROM employee;

-- practiceQuery10: [book 10]
-- Select all possible combinations of the employee's Social Security Numbers and department names.
CREATE OR REPLACE VIEW practicequery10 as 
SELECT ssn, dname FROM employee, department;

-- practiceQuery11: [book 11] Retrieve the distinct salaries of all of the employees.
CREATE OR REPLACE VIEW practicequery11 as
SELECT distinct(salary) FROM employee;

-- practiceQuery12: [book 12] Retrieve the first and last names of all employees whose address is in Houston, Texas.
CREATE OR REPLACE VIEW practicequery12 as
SELECT fname, lname FROM employee WHERE address LIKE '%Houston%';

-- practiceQuery13: [book 13] Show the first and last names and resulting salaries 
-- if every employee working on the 'ProductX' project is given a 10% raise.
CREATE OR REPLACE VIEW practicequery13 as
SELECT fname, lname, Max(salary) FROM (
SELECT fname, lname, salary FROM employee e2
UNION
SELECT fname, lname, salary * 1.1 FROM employee e 
INNER JOIN (
SELECT essn FROM works_on w
INNER JOIN (
SELECT pnumber FROM project WHERE pname="ProductX") p ON p.pnumber=w.pno) c ON e.ssn=c.essn) f GROUP BY fname, lname;

-- practiceQuery14: [book 14] Retrieve all information for employees in department 5 
-- whose salary is between $30,000 and $40,000.
CREATE OR REPLACE VIEW practicequer14 as
SELECT * FROM employee WHERE dno=5 and salary BETWEEN 30000 AND 40000;

-- practiceQuery15: [book 15] Retrieve a list of department names, employee first and last names, 
-- and the project names they are working on, ordered by department 
-- and, within each department, ordered alphabetically by last name, then first name.
-- CREATE OR REPLACE VIEW practicequer15 as
SELECT d.dname, e.lname, e.fname FROM employee e
LEFT JOIN department d ON d.dnumber=e.dno ORDER BY d.dname, e.lname, e.fname;

-- practiceQuery16: [book 16] Retrieve the name of each employee 
-- who has a dependent with the same first name and is the same sex as the employee.
CREATE OR REPLACE VIEW practicequer16 as
SELECT fname, lname FROM employee, dependent WHERE fname=dependent_name AND employee.sex=dependent.sex;

-- practiceQuery17: [book 17] Retrieve the Social Security numbers of all employees
--  who work on project numbers 1, 2 or 3.
CREATE OR REPLACE VIEW practicequer17 as
SELECT DISTINCT(essn) FROM works_on WHERE pno = 1 OR pno=2 OR pno=3;

-- practiceQuery18: [book 18] Retrieve the names of all employees who do not have supervisors.
CREATE OR REPLACE VIEW practicequer18 as
SELECT fname, lname FROM employee WHERE superssn is NULL;

-- practiceQuery19: [book 19] Find the sum of the salaries of all employees, 
-- the maximum salary, the minimum salary, and the average salary. 
CREATE OR REPLACE VIEW practicequer19 as
SELECT SUM(salary) AS "sum(salary)", MAX(salary) AS "max(salary)", min(salary) AS "min(salary)", SUM(salary)/COUNT(salary) AS "avg(salary)" FROM employee;

-- practiceQuery20: [book 20] Find the sum of the salaries of all employees of the 'Research' department, as well as the maximum salary, the minimum salary, 
-- and the average salary in this department.
CREATE OR REPLACE VIEW practicequer20 as
SELECT SUM(salary) AS "sum(salary)", MAX(salary) AS "max(salary)", min(salary) AS "min(salary)", SUM(salary)/COUNT(salary) AS "avg(salary)" FROM employee WHERE dno=5;

-- practiceQuery21: [book 21] Retrieve the total number of employees in the company.
 CREATE OR REPLACE VIEW practicequer21 as
SELECT COUNT(fname) FROM employee;

-- practiceQuery22: [book 22] Retrieve the total number of employees in the 'Research' department.
CREATE OR REPLACE VIEW practicequer22 as
SELECT COUNT(fname) FROM employee WHERE dno=5;

-- practiceQuery23: [book 23] Count the number of distinct salary values in the database.
CREATE OR REPLACE VIEW practicequer23 as
SELECT COUNT(DISTINCT(salary)) FROM employee;

-- practiceQuery24: [book 24] For each department, retrieve the department number, 
-- the number of employees in the department, and their average salary.
CREATE OR REPLACE VIEW practicequer24 as
SELECT dno, COUNT(dno), SUM(salary)/COUNT(dno) FROM employee GROUP BY dno;

-- practiceQuery25: [book 25] For each project, retrieve the project number, the project name, 
-- and the number of employees who work on that project. 
-- (Null employees will be interpreted as zero employees).
CREATE OR REPLACE VIEW practicequer25 as
SELECT pnumber, pname, Num  FROM project p
LEFT JOIN (SELECT pno, COUNT(pno) AS Num FROM works_on GROUP BY pno) w ON w.pno = p.pnumber;

-- practiceQuery26: [book 26] For each project on which more than two employees work, 
-- retrieve the project number, the project name, 
-- and the number of employees who work on the project.
CREATE OR REPLACE VIEW practicequer26 as
SELECT pnumber, pname, Num  FROM project p
LEFT JOIN (SELECT pno, COUNT(pno) AS Num FROM works_on GROUP BY pno) w ON w.pno = p.pnumber WHERE Num>2;

-- practiceQuery27: [book 27] For each project, retrieve the project number, the project name,
-- and the number of employees from department 5 who work on the project.
CREATE OR REPLACE VIEW practicequer27 as
SELECT p2.pname, p2.pnumber, COUNT(p1.pname) FROM project p2
LEFT JOIN (
SELECT pname, pnumber, essn FROM (
SELECT pname, pnumber, essn FROM project p
LEFT JOIN works_on w ON p.pnumber=w.pno) a
LEFT JOIN employee e ON a.essn=e.ssn WHERE dno=5) p1 ON p2.pname=p1.pname GROUP BY p2.pname;


-- practiceQuery28: [book 28] For each department that has less than four employees, 
-- retrieve the department number and the number of its employees who are making more than $25,000.
CREATE OR REPLACE VIEW practicequer28 as
SELECT b.dno, COUNT(*) FROM (
SELECT dno, ssn, salary FROM employee WHERE salary > 25000) a
LEFT JOIN (
SELECT dno FROM employee GROUP BY dno HAVING COUNT(*) < 4) b ON b.dno=a.dno WHERE b.dno is NOT NULL GROUP BY b.dno; 


-- practiceQuery29: [book 1c] Retrieve all of the attribute values for any employee who works in department 5.
CREATE OR REPLACE VIEW practicequer29 as
SELECT * FROM employee WHERE dno=5;

-- practiceQuery30: [book 1d] Retrieve all of the attributes for each employee and the department for which he or she works.
CREATE OR REPLACE VIEW practicequer30 as
SELECT * FROM employee e
LEFT JOIN department d ON e.dno=d.dnumber;

-- practiceQuery31: [book 12a] Find the first name, last name and birthdate of the employees who were born during the 1950s.
CREATE OR REPLACE VIEW practicequer31 as
SELECT fname, lname, bdate FROM employee WHERE bdate LIKE "%195%";

-- PracticeQuery32: [book 6_10a] Retrieve the first and last names of all employees in department 5 
-- who work more than 10 hours per week on the ProductX project.
CREATE OR REPLACE VIEW practicequer32 as
SELECT fname, lname FROM (
SELECT * FROM (SELECT * FROM works_on WHERE hours > 10 AND pno=1) w
LEFT JOIN employee e ON e.ssn=w.essn WHERE e.dno=5) f;

-- practiceQuery33: [book 6_10b] List the first and last names of all employees 
-- who have a dependent with the same first name as themselves.
CREATE OR REPLACE VIEW practicequer33 as
SELECT fname, lname FROM employee, dependent WHERE dependent_name=fname;

-- practiceQuery34: [book 6_10c] Find the first and last names of all employees 
-- who are directly supervised by 'Franklin Wong'.
CREATE OR REPLACE VIEW practicequer34 as
SELECT fname, lname FROM employee WHERE superssn=333445555; 

-- practiceQuery35: [book 7_7a] Retrieve the first and last names of all employees 
-- who work in the department that has the employee with the highest salary among all employees.
CREATE OR REPLACE VIEW practicequer35 as
SELECT fname, lname FROM employee WHERE salary=55000;

-- practiceQuery36: [book 7_7b] Retrieve the first and last names of all employees 
-- whose supervisor's supervisor has '888665555' for their SSN.
CREATE OR REPLACE VIEW practicequer36 as
SELECT * FROM (
SELECT e1.fname, e1.lname FROM employee e1
LEFT JOIN employee e2 ON e1.superssn=e2.ssn WHERE e2.superssn="888665555") f;

-- practiceQuery37: [book 7_7c] Retrieve the first and last names of employees who make at least $10,000 
-- more than the employee who is paid the least in the company.
CREATE OR REPLACE VIEW practicequer37 as
SELECT fname, lname FROM employee WHERE salary > 35000;

-- practiceQuery40: Display the words 'Hello World!'
CREATE OR REPLACE VIEW practicequer40 AS
SELECT "Hello World!";

-- Practice 40 to 49  Introductory Level Select Only: Skipped

-- practiceQuery50: Display the first name, last name and address of all employees.
CREATE OR REPLACE VIEW practicequer50 AS
SELECT fname, lname, address FROM employee;

-- practiceQuery51: Display the last name in a column titled 'Last Name', first name in a column titled 'First Name', 
-- and address in a column titled 'Residence Location' for all employees.
CREATE OR REPLACE VIEW practiceQuery51 AS
SELECT lname AS "Last Name", fname AS "First Name", address AS "Residence Location" FROM employee;

-- practiceQuery52: Retrieve the first name, last name and address of all employees, 
-- and display the first and last name as a combined 'Whole Name'.
CREATE OR REPLACE VIEW practiceQuery52 AS
SELECT CONCAT(fname," ", lname) AS "Whole Name", address FROM employee;

-- practiceQuery53: Retrieve the department numbers for all employees.
CREATE OR REPLACE VIEW practiceQuery53 AS
SELECT dno FROM employee;

-- practiceQuery54: Retrieve the unique department numbers for all employees.
CREATE OR REPLACE VIEW practiceQuery54 AS
SELECT distinct(dno) FROM employee;

-- practiceQuery55: Retrieve the salary and department number combinations for all employees.
CREATE OR REPLACE VIEW practiceQuery55 AS
SELECT salary, dno FROM employee;

-- practiceQuery56: Retrieve the distinct salary and department number combinations for all employees.
CREATE OR REPLACE VIEW practiceQuery56 AS
SELECT DISTINCT(salary), dno FROM employee;

-- practiceQuery60: Retrieve the first name, last name and address of all employees in department 5.
CREATE OR REPLACE VIEW practiceQuery60 AS
SELECT fname, lname, address FROM employee WHERE dno=5;

-- practiceQuery61: Retrieve the first name, last name and address of all employees who are not in department 5.
CREATE OR REPLACE VIEW practiceQuery61 AS
SELECT fname, lname, address FROM employee WHERE dno != 5;

-- practiceQuery62: Retrieve the first name, last name and address of all employees who earn more than 30000 in salary.
CREATE OR REPLACE VIEW practiceQuery62 AS
SELECT fname, lname, address FROM employee WHERE salary > 30000;

-- practiceQuery63: Retrieve the first name, last name and address of all employees who are in department 5 or earn more than 30000 in salary.
CREATE OR REPLACE VIEW practiceQuery63 AS
SELECT fname, lname, address FROM employee WHERE dno=5 OR salary>30000;

-- practiceQuery64: Retrieve the first name, last name and address of all employees who are in department 5 and earn more than 30000 in salary.
CREATE OR REPLACE VIEW practiceQuery64 AS
SELECT fname, lname, address FROM employee WHERE dno=5 AND salary>30000;

-- practiceQuery65: Retrieve the first name, last name, address and birthdate of all employees born after January 1st, 1968.
CREATE OR REPLACE VIEW practiceQuery65 AS
SELECT fname, lname, address, bdate FROM employee WHERE bdate > "1968-1-1";

-- practiceQuery66: Retrieve the first name, last name, address and birthdate of all employees 
-- born after January 1st, 1964 and before August 10th, 1970.
CREATE OR REPLACE VIEW practiceQuery66 AS
SELECT fname, lname, address, bdate FROM employee WHERE bdate BETWEEN "1964-1-1" AND "1970-08-10";

-- practiceQuery67: Retrieve the first name, last name and address of all employees in first name order.
CREATE OR REPLACE VIEW practiceQuery67 AS
SELECT fname, lname, address FROM employee ORDER BY fname ASC;

-- practiceQuery68: Retrieve the first name, last name and address of all employees 
-- in descending last name order.
CREATE OR REPLACE VIEW practiceQuery68 AS
SELECT fname, lname, address FROM employee order by lname DESC;

-- practiceQuery69: Retrieve the first name and address of all employees in last name order (descending).
CREATE OR REPLACE VIEW practiceQuery69 AS
SELECT fname, address FROM employee ORDER BY lname DESC;

-- practiceQuery70: Retrieve the first name, last name and address of all employees
--  in the order of last name and then first name.
CREATE OR REPLACE VIEW practiceQuery70 AS
SELECT fname, lname, address FROM employee ORDER BY lname, fname ASC;
-- practiceQuery71: Retrieve the first name, last name and address of all employees who live in Houston
CREATE OR REPLACE VIEW practiceQuery71 AS
SELECT fname, lname, address FROM employee WHERE address LIKE "%Houston%";
-- practiceQuery72: Retrieve the first name, last name and address of all employees who live in Dallas.
CREATE OR REPLACE VIEW practiceQuery72 AS
SELECT fname, lname, address FROM employee WHERE address LIKE "%Dallas%";
-- practiceQuery73: Retrieve the first name, last name 
-- and address of all employees whose first names begin with the letter 'J'.
CREATE OR REPLACE VIEW practiceQuery73 AS
SELECT fname, lname, address FROM employee WHERE fname LIKE "J%";
-- practiceQuery74: Retrieve the first name, last name 
-- and address of all employees who's last names contain the pattern 'aya'.
CREATE OR REPLACE VIEW practiceQuery74 AS
SELECT fname, lname, address FROM employee WHERE lname LIKE "%aya%";
-- practiceQuery75: Retrieve the first name, last name and address of all employees 
-- whose last names contain the pattern 'aya' 
-- where the pattern is not at the end of the string.
CREATE OR REPLACE VIEW practiceQuery75 AS
SELECT fname, lname, address FROM employee WHERE lname LIKE "%aya%" AND lname NOT LIKE "%aya";

-- practiceQuery80: Retrieve the first name, last name and salary of the employees in department number 5 
-- if they were all given a 10% raise in salary.
CREATE OR REPLACE VIEW practiceQuery80 AS
SELECT fname, lname, salary*1.1 FROM employee WHERE dno=5;
-- practiceQuery81: Retrieve the sum of the salaries for all employees in department number 5.
CREATE OR REPLACE VIEW practiceQuery81 AS
SELECT SUM(salary) FROM employee WHERE dno=5;
-- practiceQuery82: Retrieve the smallest and largest salaries for all employees in department number 5.
CREATE OR REPLACE VIEW practiceQuery82 AS
SELECT MIN(salary), MAX(salary) FROM employee WHERE dno=5;
-- practiceQuery83: Retrieve the number of different salaries for all employees.
CREATE OR REPLACE VIEW practiceQuery83 AS
SELECT COUNT(DISTINCT(salary)) FROM employee;
-- practiceQuery84: Retrieve the number of Supervisor's Social Security Numbers (superssn) without duplicates.
CREATE OR REPLACE VIEW practiceQuery84 AS
SELECT COUNT(DISTINCT(superssn)) FROM employee;
-- practiceQuery85: Retrieve the number of employees whose superssn is equal to 333445555.
CREATE OR REPLACE VIEW practiceQuery85 AS
SELECT COUNT(*) FROM employee WHERE superssn="333445555";
-- practiceQuery86: Retrieve the number of employees whose superssn is not equal to 333445555.
CREATE OR REPLACE VIEW practiceQuery86 AS
SELECT COUNT(*) FROM employee WHERE superssn!="333445555";
-- practiceQuery87: Retrieve the total number of employees.
CREATE OR REPLACE VIEW practiceQuery87 AS
SELECT COUNT(*) FROM employee;
-- practiceQuery88: Retrieve the minimum, average and maximum salary for the employees in each department.
CREATE OR REPLACE VIEW practiceQuery88 AS
SELECT dno, min(salary), SUM(salary)/COUNT(*), max(salary) FROM employee GROUP BY dno;
-- practiceQuery89: Retrieve the minimum, average 
-- and maximum salary for the employees in each department with less than four employees.
CREATE OR REPLACE VIEW practiceQuery89 AS
SELECT DNO, min(salary), SUM(salary)/COUNT(*), max(salary) FROM employee GROUP BY dno HAVING COUNT(*) <4;

-- practiceQuery100: Retrieve the total number of employees whose salaries exceed $25,000 in each department.
CREATE OR REPLACE VIEW practiceQuery89 AS
SELECT dno, COUNT(*) FROM (
SELECT dno, salary FROM employee WHERE salary > 25000) b GROUP BY b.dno;

-- practiceQuery101: Retrieve the total number of employees whose salaries exceed $25,000 
-- in all of the departments except Headquarters.
CREATE OR REPLACE VIEW practiceQuery101 AS
SELECT dno, COUNT(*) FROM (
SELECT dno, salary FROM employee WHERE salary > 25000) b WHERE b.dno!=1 GROUP BY b.dno;

-- practiceQuery102: Retrieve the department numbers for departments where fewer than four employees work.
CREATE OR REPLACE VIEW practiceQuery102 AS
SELECT dno FROM employee GROUP BY dno HAVING COUNT(dno) < 4;

-- practiceQuery103: Retrieve the total number of employees whose salaries exceed $25,000 per department, 
-- but only for departments where fewer than four employees work.
CREATE OR REPLACE VIEW practiceQuery103 AS
SELECT a.dno, a.n FROM (
SELECT dno, COUNT(*) AS n FROM employee WHERE salary >25000 GROUP BY dno) a 
INNER JOIN (
SELECT COUNT(*), dno FROM employee GROUP BY dno HAVING COUNT(*) < 4) b ON a.dno=b.dno;
-- practiceQuery104: Retrieve the first name, last name and address for each employee that has a dependent daughter.
CREATE OR REPLACE VIEW practiceQuery104 AS
SELECT e.fname, e.lname, e.address FROM (
SELECT * FROM dependent WHERE relationship="Daughter") d 
LEFT JOIN (
SELECT fname, lname, address, ssn FROM employee) e ON d.essn=e.ssn;

-- practiceQuery105: Retrieve the first name, last name and address 
-- for each employee that is working on a project that is located in Houston.
CREATE OR REPLACE VIEW practiceQuery105 AS
SELECT DISTINCT(fname), lname, address FROM (
SELECT * FROM works_on WHERE pno=3 OR pno=2) a 
LEFT JOIN employee e ON a.essn=e.ssn; 
-- SELECT * FROM project WHERE plocation="Houston";

-- practiceQuery106: Retrieve the Social Security Number (ssn) of employees 
-- who earn more than 25000 in salary or work on project 20.
-- CREATE OR REPLACE VIEW Practice106 AS
CREATE OR REPLACE VIEW practiceQuery106 AS
SELECT ssn FROM employee WHERE salary>25000
UNION
SELECT essn FROM works_on WHERE pno=20;

-- practiceQuery107: Retrieve the Social Security Number (ssn) of each employee 
-- who earns more than 25000 in salary and also works on project 20.
CREATE OR REPLACE VIEW practiceQuery107 AS
SELECT ssn FROM (
SELECT essn FROM works_on WHERE pno=20) a
LEFT JOIN employee e ON a.essn=e.ssn WHERE e.salary>25000;

-- practiceQuery108: Retrieve the Social Security Number (ssn) of each employee 
-- who earns more than 25000 in salary but doesn't work on project 20.
CREATE OR REPLACE VIEW practiceQuery108 AS
SELECT ssn FROM (
SELECT ssn FROM employee WHERE salary>25000) a
LEFT JOIN (
SELECT essn FROM works_on WHERE pno=20) b ON a.ssn=b.essn WHERE essn IS NOT NULL;
