-- Practice 0
CREATE OR REPLACE VIEW Practice0 as 
SELECT bdate, address FROM employee WHERE lname="Smith" AND fname="John";
-- Practice 1  
CREATE OR REPLACE VIEW Practice1 as 
SELECT fname, lname, address FROM employee WHERE dno = 5;
-- Practice 2 (Skip)
-- CREATE OR REPLACE VIEW Practice2 as
SELECT * FROM department;

-- Practice 3
CREATE OR REPLACE VIEW Practice3 as
SELECT pname FROM project WHERE dnum=5;

-- Practice 4
-- CREATE OR REPLACE VIEW Practice4 as
SELECT pnumber, dnum, dno, lname FROM project, employee WHERE lname = "Smith"; 

-- Practice 5
-- CREATE OR REPLACE VIEW Practice5 as
SELECT fname, lname FROM employee, dependent  ;

-- Practice 6
CREATE OR REPLACE VIEW Practice6 as
SELECT fname, lname FROM employee WHERE ssn not in (SELECT essn FROM dependent);

-- Practice 7
-- CREATE OR REPLACE VIEW Practice7 as

-- Practice 8
-- CREATE OR REPLACE VIEW Practice8 as

