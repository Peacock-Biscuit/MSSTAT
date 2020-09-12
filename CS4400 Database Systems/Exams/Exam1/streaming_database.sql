-- CS4400: Introduction to Database Systems
-- Exam #1: SQL DML Single-Table Queries / Fall 2020 Semester
-- SELECT - FROM - WHERE - GROUP BY - HAVING - ORDER BY

DROP DATABASE IF EXISTS streaming;
CREATE DATABASE IF NOT EXISTS streaming;
USE streaming;

DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
  title varchar(100) NOT NULL,
  produced integer NOT NULL,
  rating varchar(100) DEFAULT NULL,
  duration integer DEFAULT NULL,
  genres varchar(100) DEFAULT NULL,
  released date DEFAULT NULL,
  company varchar(100) DEFAULT NULL,
  PRIMARY KEY (title, produced)
) ENGINE=InnoDB;

INSERT INTO movies VALUES ('Aquaman',2018,'PG-13',143,'action, adventure, fantasy','2018-12-21','DC Comics'),
('Bad Boys',1995,'R',119,'action, comedy, crime','1995-04-07','Simpson/Bruckheimer'),
('Bad Boys for Life',2020,'R',124,'action, comedy, crime','2020-01-17','Columbia Pictures'),
('Batman Begins',2005,'PG-13',140,'action, adventure','2005-06-15','Warner Bros'),
('Batman v Superman',2016,'PG-13',152,'action, adventure, sci-fi','2016-03-25','Warner Bros'),
('Hollow Man',2000,'R',112,'action, horror, sci-fi','2000-08-04','Columbia Pictures'),
('Knives Out',2019,'PG-13',130,'comedy, crime, drama','2019-11-27','Lionsgate'),
('Spy',2015,'R',120,'action, comedy, crime','2015-06-05','20th Century Studios'),
('Tenet',2020,'PG-13',150,'action, sci-fi','2020-09-03','Warner Bros'),
('The Gentlemen',2019,'R',113,'action, comedy, crime','2020-01-24','Miramax'),
('The Grudge',2004,'PG-13',91,'horror, mystery, thriller','2004-10-22','Columbia Pictures'),
('The Grudge',2020,'R',94,'horror, mystery','2020-01-03','Screen Gems'),
('The Invisible Man',2020,'R',124,'horror, mystery, sci-fi','2020-02-28','Universal Pictures'),
('The New Mutants',2020,'PG-13',94,'action, horror, sci-fi','2020-08-28','20th Century Studios'),
('Wonder Woman',2017,'PG-13',141,'action, adventure, fantasy','2017-06-02','Warner Bros');

DROP TABLE IF EXISTS services;
CREATE TABLE services (
  sname varchar(100) NOT NULL,
  website varchar(100) DEFAULT NULL,
  founded date DEFAULT NULL,
  headquarters varchar(100) DEFAULT NULL,
  revenue integer DEFAULT NULL,
  employees integer DEFAULT NULL,
  viewers integer DEFAULT NULL,
  PRIMARY KEY (sname)
) ENGINE=InnoDB;

INSERT INTO services VALUES ('Amazon','https://www.primevideo.com','2006-09-07','Seattle, Washington, U.S.',3,10000,164),
('HBO','https://www.hbonow.com','2014-10-15','New York, New York, U.S.',6,2000,726),
('Hulu','https://www.hulu.com','2007-10-29','Santa Monica, California, U.S.',1,2900,35),
('Netflix','https://www.netflix.com','1997-08-29','Los Gatos, California, U.S.',20,8600,193),
('YouTube','https://www.youtube.com','2005-02-14','San Bruno, California, U.S.',15,1200,2);

DROP TABLE IF EXISTS viewers;
CREATE TABLE viewers (
  fname varchar(100) NOT NULL,
  lname varchar(100) NOT NULL,
  service varchar(100) NOT NULL,
  account_size integer DEFAULT NULL,
  joined date DEFAULT NULL,
  bonus_credits integer DEFAULT NULL,
  auto_renewal date DEFAULT NULL,
  parental_limit varchar(100) DEFAULT NULL,
  PRIMARY KEY (fname, service, lname)
) ENGINE=InnoDB;

INSERT INTO viewers VALUES ('Abigayle','Velez','Hulu',3,'2010-10-29',NULL,NULL,'no'),
('Abigayle','Velez','Netflix',1,'1999-05-03',2000,'2021-07-29','no'),
('Bryony','Stark','HBO',1,'2016-02-10',100,NULL,'no'),
('Kamila','Ferry','Netflix',4,'1999-11-01',100,'2020-09-21','yes'),
('Portia','Banks','Amazon',1,'2010-06-17',NULL,NULL,'no'),
('Portia','Banks','Netflix',1,'2004-05-02',NULL,'2020-10-12','no'),
('Susanna','Delacruz','Hulu',1,'2008-08-15',NULL,'2020-11-28','no'),
('Willow','McDonough','Amazon',5,'2018-03-18',300,'2021-06-02','yes');
