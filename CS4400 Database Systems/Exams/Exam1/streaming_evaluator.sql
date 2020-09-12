-- CS4400: Introduction to Database Systems
-- Automated Evaluation Script for the Streaming Database [v1 - BASIC - Initial State Only]
-- [Thu, 3 Sep 2020]: Expected results uploaded
set @thisDatabase = 'streaming';

-- This is required to support some of the arbitrary SQL commands that might be used in the testing process.
set SQL_SAFE_UPDATES = 0;

-- This SQL MODE is used to deliberately allow for queries that do not follow the "ONLY_FULL_GROUP_BY" protocol.
-- Though it does permit queries that are arguably poorly-structured, this is permitted by the most recent SQL standards.
set session SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- The magic44_data_capture table is used to store the data created by the student's queries
-- The table is populated by the magic44_evaluate_queries stored procedure
-- The data in the table is used to populate the magic44_test_results table for analysis

drop table if exists magic44_data_capture;
create table magic44_data_capture (
	stepID integer, queryID integer,
    columnDump0 varchar(1000), columnDump1 varchar(1000), columnDump2 varchar(1000), columnDump3 varchar(1000), columnDump4 varchar(1000),
    columnDump5 varchar(1000), columnDump6 varchar(1000), columnDump7 varchar(1000), columnDump8 varchar(1000), columnDump9 varchar(1000),
	columnDump10 varchar(1000), columnDump11 varchar(1000), columnDump12 varchar(1000), columnDump13 varchar(1000), columnDump14 varchar(1000)
);

-- The magic44_column_listing table is used to help prepare the insert statements for the magic44_data_capture
-- table for the student's queries which may have variable numbers of columns (the table is prepopulated)

drop table if exists magic44_column_listing;
create table magic44_column_listing (
	columnPosition integer,
    simpleColumnName varchar(50),
    nullColumnName varchar(50)
);

insert into magic44_column_listing (columnPosition, simpleColumnName) values
(0, 'columnDump0'), (1, 'columnDump1'), (2, 'columnDump2'), (3, 'columnDump3'), (4, 'columnDump4'),
(5, 'columnDump5'), (6, 'columnDump6'), (7, 'columnDump7'), (8, 'columnDump8'), (9, 'columnDump9'),
(10, 'columnDump10'), (11, 'columnDump11'), (12, 'columnDump12'), (13, 'columnDump13'), (14, 'columnDump14');

drop function if exists magic44_gen_simple_template;
delimiter //
create function magic44_gen_simple_template(numberOfColumns integer)
	returns varchar(1000) deterministic
begin
return (select group_concat(simpleColumnName separator ", ") from magic44_column_listing
	where columnPosition < numberOfColumns);
end //
delimiter ;

-- Create a variable to effectively act as a program counter for the testing process/steps
set @stepCounter = 0;

-- The magic44_magic44_query_capture function is used to construct the instruction
-- that can be used to execute and store the results of a query
drop function if exists magic44_query_capture;
delimiter //
create function magic44_query_capture(thisQuery integer)
	returns varchar(1000) deterministic
begin
	set @numberOfColumns = (select count(*) from information_schema.columns
		where table_schema = @thisDatabase
        and table_name = concat('testQuery', thisQuery));

	set @buildQuery = "insert into magic44_data_capture (stepID, queryID, ";
    set @buildQuery = concat(@buildQuery, magic44_gen_simple_template(@numberOfColumns));
    set @buildQuery = concat(@buildQuery, ") select ");
    set @buildQuery = concat(@buildQuery, @stepCounter, ", ");
    set @buildQuery = concat(@buildQuery, thisQuery, ", testQuery");
    set @buildQuery = concat(@buildQuery, thisQuery, ".* from testQuery");
    set @buildQuery = concat(@buildQuery, thisQuery, ";");
    
return @buildQuery;
end //
delimiter ;

-- The magic44_testing_steps table is used to change the state of the database to test the queries more fully
-- This table is used by the magic44_evaluate_queries stored procedure
-- The table is prepopulated and contains both SQL commands and non-SQL special commands that drive the testing process
-- The SQL commands are used to change the state of the database to facilitate more thorough testing
-- The non-SQL special commands are used to support execution of otherwise complex commands (e.g., stored procedures)

drop table if exists magic44_testing_steps;
create table magic44_testing_steps (
	stepID integer,
    changeInstruction varchar(2000),
    primary key (stepID)
);

-- In many cases, we will use a "compensating transaction" policy to change a table, and then change it's contents
-- back to the original state to minimize any effects from propagting errors
-- For more advanced testing, however, multiple sequential changes to the tables will be executed

insert into magic44_testing_steps values
(0, '&non_sql&evaluate_all_queries');

drop function if exists magic44_query_exists;
delimiter //
create function magic44_query_exists(thisQuery integer)
	returns integer deterministic
begin
	return (select exists (select * from information_schema.views
		where table_schema = @thisDatabase
        and table_name like concat('testQuery', thisQuery)));
end //
delimiter ;

drop function if exists magic44_test_step_exists;
delimiter //
create function magic44_test_step_exists()
	returns integer deterministic
begin
	return (select exists (select * from magic44_testing_steps where stepID = @stepCounter));
end //
delimiter ;

-- Exception checking has been implemented to prevent (as much as reasonably possible) errors
-- in the queries being evaluated from interrupting the testing process
-- The magic44_log_query_errors table capture these errors for later review

drop table if exists magic44_log_query_errors;
create table magic44_log_query_errors (
	step_id integer,
    query_id integer,
    error_code char(5),
    error_message text	
);

drop procedure if exists magic44_query_check_and_run;
delimiter //
create procedure magic44_query_check_and_run(in thisQuery integer)
begin
	declare err_code char(5) default '00000';
    declare err_msg text;
    
	declare continue handler for SQLEXCEPTION
    begin
		get diagnostics condition 1
			err_code = RETURNED_SQLSTATE, err_msg = MESSAGE_TEXT;
	end;

	if magic44_query_exists(thisQuery) then
		set @sql_text = magic44_query_capture(thisQuery);
		prepare statement from @sql_text;
        execute statement;
        if err_code <> '00000' then
			insert into magic44_log_query_errors values (@stepCounter, thisQuery, err_code, err_msg);
		end if;
        deallocate prepare statement;
	end if;
end //
delimiter ;

drop procedure if exists magic44_test_step_check_and_run;
delimiter //
create procedure magic44_test_step_check_and_run()
begin
	if magic44_test_step_exists() then
		set @sql_text = (select changeInstruction from magic44_testing_steps where stepID = @stepCounter);
        if @sql_text = '&non_sql&evaluate_all_queries' then
			call magic44_evaluate_queries();
        else
			prepare statement from @sql_text;
			execute statement;
			deallocate prepare statement;
		end if;
	end if;
end //
delimiter ;

drop procedure if exists magic44_evaluate_queries;
delimiter //
create procedure magic44_evaluate_queries()
sp_main: begin
	set @startingQuery = 0, @endingQuery = 50;
    set @queryCounter = @startingQuery;
    
	all_queries: while @queryCounter <= @endingQuery do
		call magic44_query_check_and_run(@queryCounter);
		set @queryCounter = @queryCounter + 1;
	end while;
end //
delimiter ;

drop procedure if exists magic44_evaluate_testing_steps;
delimiter //
create procedure magic44_evaluate_testing_steps()
sp_main: begin
	set @startingStep = 0;    
    if not exists (select max(stepID) from magic44_testing_steps) then leave sp_main; end if;
    set @endingStep = (select max(stepID) from magic44_testing_steps);
	set @stepCounter = @startingStep;

    all_steps: repeat		
        call magic44_test_step_check_and_run();
        set @stepCounter = @stepCounter + 1;
	until (@stepCounter > @endingStep)
    end repeat;
end //
delimiter ;

-- These tables are used to store the answers and test results.  The answers are generated by executing
-- the test script against our reference solution.  The test results are collected by running the test
-- script against your submission in order to compare the results.

-- the results from magic44_data_capture the are transferred into the magic44_test_results table
drop table if exists magic44_test_results;
create table magic44_test_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

call magic44_evaluate_testing_steps();
insert into magic44_test_results
select stepID, queryID, concat_ws('#', ifnull(columndump0, ''), ifnull(columndump1, ''), ifnull(columndump2, ''), ifnull(columndump3, ''),
ifnull(columndump4, ''), ifnull(columndump5, ''), ifnull(columndump6, ''), ifnull(columndump7, ''), ifnull(columndump8, ''), ifnull(columndump9, ''),
ifnull(columndump10, ''), ifnull(columndump11, ''), ifnull(columndump12, ''), ifnull(columndump13, ''), ifnull(columndump14, ''))
from magic44_data_capture;

-- the answers generated from the reference solution are loaded below
drop table if exists magic44_expected_results;
create table magic44_expected_results (
	step_id integer not null,
    query_id integer,
	row_hash varchar(2000) not null
);

insert into magic44_expected_results values
(0,1,'aquaman#2018#pg-13#143#action,adventure,fantasy#2018-12-21#dccomics########'),
(0,1,'badboys#1995#r#119#action,comedy,crime#1995-04-07#simpson/bruckheimer########'),
(0,1,'badboysforlife#2020#r#124#action,comedy,crime#2020-01-17#columbiapictures########'),
(0,1,'batmanbegins#2005#pg-13#140#action,adventure#2005-06-15#warnerbros########'),
(0,1,'batmanvsuperman#2016#pg-13#152#action,adventure,sci-fi#2016-03-25#warnerbros########'),
(0,1,'hollowman#2000#r#112#action,horror,sci-fi#2000-08-04#columbiapictures########'),
(0,1,'knivesout#2019#pg-13#130#comedy,crime,drama#2019-11-27#lionsgate########'),
(0,1,'spy#2015#r#120#action,comedy,crime#2015-06-05#20thcenturystudios########'),
(0,1,'tenet#2020#pg-13#150#action,sci-fi#2020-09-03#warnerbros########'),
(0,1,'thegentlemen#2019#r#113#action,comedy,crime#2020-01-24#miramax########'),
(0,1,'thegrudge#2004#pg-13#91#horror,mystery,thriller#2004-10-22#columbiapictures########'),
(0,1,'thegrudge#2020#r#94#horror,mystery#2020-01-03#screengems########'),
(0,1,'theinvisibleman#2020#r#124#horror,mystery,sci-fi#2020-02-28#universalpictures########'),
(0,1,'thenewmutants#2020#pg-13#94#action,horror,sci-fi#2020-08-28#20thcenturystudios########'),
(0,1,'wonderwoman#2017#pg-13#141#action,adventure,fantasy#2017-06-02#warnerbros########'),
(0,2,'badboys#1995#r#119###########'),
(0,2,'hollowman#2000#r#112###########'),
(0,2,'spy#2015#r#120###########'),
(0,2,'thegentlemen#2019#r#113###########'),
(0,2,'thegrudge#2004#pg-13#91###########'),
(0,2,'thegrudge#2020#r#94###########'),
(0,2,'thenewmutants#2020#pg-13#94###########'),
(0,3,'badboys#1995#r#119###########'),
(0,3,'hollowman#2000#r#112###########'),
(0,3,'thegentlemen#2019#r#113###########'),
(0,3,'thegrudge#2004#pg-13#91###########'),
(0,3,'thegrudge#2020#r#94###########'),
(0,3,'thenewmutants#2020#pg-13#94###########'),
(0,4,'badboys#1995#r#119###########'),
(0,5,'badboys#1995#r#119###########'),
(0,5,'hollowman#2000#r#112###########'),
(0,5,'thegrudge#2004#pg-13#91###########'),
(0,6,'aquaman#2018#pg-13#143###########'),
(0,6,'batmanbegins#2005#pg-13#140###########'),
(0,6,'batmanvsuperman#2016#pg-13#152###########'),
(0,6,'knivesout#2019#pg-13#130###########'),
(0,6,'tenet#2020#pg-13#150###########'),
(0,6,'thenewmutants#2020#pg-13#94###########'),
(0,6,'wonderwoman#2017#pg-13#141###########'),
(0,7,'hollowman#2000#r#112###########'),
(0,7,'thegentlemen#2019#r#113###########'),
(0,7,'thegrudge#2004#pg-13#91###########'),
(0,7,'thegrudge#2020#r#94###########'),
(0,7,'thenewmutants#2020#pg-13#94###########'),
(0,8,'badboys#1995#r#119###########'),
(0,8,'hollowman#2000#r#112###########'),
(0,8,'thegentlemen#2019#r#113###########'),
(0,8,'thegrudge#2004#pg-13#91###########'),
(0,8,'thegrudge#2020#r#94###########'),
(0,8,'thenewmutants#2020#pg-13#94###########'),
(0,9,'batmanbegins#2005#pg-13#140#2005-06-15##########'),
(0,9,'spy#2015#r#120#2015-06-05##########'),
(0,9,'wonderwoman#2017#pg-13#141#2017-06-02##########'),
(0,10,'aquaman#2018#pg-13#143#2018-12-21##########'),
(0,10,'badboysforlife#2020#r#124#2020-01-17##########'),
(0,10,'knivesout#2019#pg-13#130#2019-11-27##########'),
(0,10,'thegentlemen#2019#r#113#2020-01-24##########'),
(0,10,'thegrudge#2020#r#94#2020-01-03##########'),
(0,11,'badboysforlife#2020#r#124#2020-01-17##########'),
(0,11,'thegentlemen#2019#r#113#2020-01-24##########'),
(0,11,'thegrudge#2020#r#94#2020-01-03##########'),
(0,12,'spy#2015#r#120#2015-06-05##########'),
(0,13,'batmanbegins#2005#pg-13#140#2005-06-15##########'),
(0,13,'knivesout#2019#pg-13#130#2019-11-27##########'),
(0,13,'wonderwoman#2017#pg-13#141#2017-06-02##########'),
(0,14,'pg-13#2018#############'),
(0,14,'r#1995#############'),
(0,14,'r#2020#############'),
(0,14,'pg-13#2005#############'),
(0,14,'pg-13#2016#############'),
(0,14,'r#2000#############'),
(0,14,'pg-13#2019#############'),
(0,14,'r#2015#############'),
(0,14,'pg-13#2020#############'),
(0,14,'r#2019#############'),
(0,14,'pg-13#2004#############'),
(0,14,'pg-13#2017#############'),
(0,15,'badboys#1995#r#action,comedy,crime#simpson/bruckheimer##########'),
(0,15,'batmanvsuperman#2016#pg-13#action,adventure,sci-fi#warnerbros##########'),
(0,15,'hollowman#2000#r#action,horror,sci-fi#columbiapictures##########'),
(0,15,'knivesout#2019#pg-13#comedy,crime,drama#lionsgate##########'),
(0,15,'spy#2015#r#action,comedy,crime#20thcenturystudios##########'),
(0,15,'thegentlemen#2019#r#action,comedy,crime#miramax##########'),
(0,16,'knivesout#2019#pg-13#comedy,crime,drama#lionsgate##########'),
(0,17,'hollowman#2000#r#112#action,horror,sci-fi#2000-08-04#columbiapictures########'),
(0,17,'theinvisibleman#2020#r#124#horror,mystery,sci-fi#2020-02-28#universalpictures########'),
(0,18,'pg-13#8#91#152###########'),
(0,18,'r#7#94#124###########'),
(0,19,'1995#1#119############'),
(0,19,'2000#1#112############'),
(0,19,'2004#1#91############'),
(0,19,'2005#1#140############'),
(0,19,'2015#1#120############'),
(0,19,'2016#1#152############'),
(0,19,'2017#1#141############'),
(0,19,'2018#1#143############'),
(0,19,'2019#2#243############'),
(0,19,'2020#2#586############'),
(0,20,'dccomics#1#0############'),
(0,20,'simpson/bruckheimer#1#0############'),
(0,20,'columbiapictures#3#20############'),
(0,20,'warnerbros#4#15############'),
(0,20,'lionsgate#1#0############'),
(0,20,'20thcenturystudios#2#5############'),
(0,20,'miramax#1#0############'),
(0,20,'screengems#1#0############'),
(0,20,'universalpictures#1#0############'),
(0,21,'pg-13#8#91#152###########'),
(0,22,'2005#1#140############'),
(0,22,'2016#1#152############'),
(0,22,'2017#1#141############'),
(0,22,'2020#1#150############'),
(0,23,'simpson/bruckheimer#1#0############'),
(0,23,'columbiapictures#3#20############'),
(0,23,'warnerbros#4#15############'),
(0,23,'20thcenturystudios#2#5############'),
(0,24,'abigayle#velez#hulu#3#2010-10-29###no#######'),
(0,24,'abigayle#velez#netflix#1#1999-05-03#2000#2021-07-29#no#######'),
(0,24,'bryony#stark#hbo#1#2016-02-10#100##no#######'),
(0,24,'kamila#ferry#netflix#4#1999-11-01#100#2020-09-21#yes#######'),
(0,24,'portia#banks#amazon#1#2010-06-17###no#######'),
(0,24,'portia#banks#netflix#1#2004-05-02##2020-10-12#no#######'),
(0,24,'susanna#delacruz#hulu#1#2008-08-15##2020-11-28#no#######'),
(0,24,'willow#mcdonough#amazon#5#2018-03-18#300#2021-06-02#yes#######'),
(0,25,'abigayle#velez#hulu#3#no##########'),
(0,25,'kamila#ferry#netflix#4#yes##########'),
(0,26,'abigayle#velez#netflix#1#2000#no#########'),
(0,26,'kamila#ferry#netflix#4#100#yes#########'),
(0,26,'willow#mcdonough#amazon#5#300#yes#########'),
(0,27,'kamila#ferry#netflix#100#yes##########'),
(0,27,'willow#mcdonough#amazon#300#yes##########'),
(0,28,'abigayle#velez#netflix#1999-05-03#2021-07-29##########'),
(0,28,'kamila#ferry#netflix#1999-11-01#2020-09-21##########'),
(0,28,'portia#banks#netflix#2004-05-02#2020-10-12##########'),
(0,28,'susanna#delacruz#hulu#2008-08-15#2020-11-28##########'),
(0,28,'willow#mcdonough#amazon#2018-03-18#2021-06-02##########'),
(0,29,'abigayle#velez#hulu#2010-10-29###########'),
(0,29,'portia#banks#amazon#2010-06-17###########'),
(0,30,'abigayle#velez#netflix#1#2100##########'),
(0,30,'bryony#stark#hbo#1#200##########'),
(0,30,'kamila#ferry#netflix#4#500##########'),
(0,30,'willow#mcdonough#amazon#5#800##########'),
(0,31,'abigayle#velez#netflix#1#1999-05-03#2000#2021-07-29#no#######'),
(0,31,'bryony#stark#hbo#1#2016-02-10#100##no#######'),
(0,32,'hulu##############'),
(0,32,'netflix##############'),
(0,32,'amazon##############'),
(0,33,'abigayle#velez#############'),
(0,34,'hulu#2#4############'),
(0,34,'netflix#3#6############'),
(0,34,'hbo#1#1############'),
(0,34,'amazon#2#6############'),
(0,35,'hulu#1#3#4###########'),
(0,35,'netflix#1#1#2###########'),
(0,35,'amazon#1#5#6###########'),
(0,36,'abigayle#velez#1#3###########'),
(0,36,'bryony#stark#1#1###########'),
(0,36,'portia#banks#1#1###########'),
(0,36,'susanna#delacruz#1#1###########'),
(0,36,'willow#mcdonough#1#5###########'),
(0,37,'hulu#3#4############'),
(0,37,'hbo#1#1############'),
(0,38,'thegrudge#2#91#94###########'),
(0,39,'columbiapictures#r#2############'),
(0,39,'warnerbros#pg-13#4############'),
(0,40,'hbo#2014-10-15#newyork,newyork,u.s.############'),
(0,41,'9800#195#############'),
(0,42,'2#12000#890############'),
(0,43,'2#4900#761############');

-- Delete the unneeded rows from the answers table to simplify later analysis
delete from magic44_expected_results where not magic44_query_exists(query_id);

-- Modify the row hash results for the results table to eliminate spaces and convert all characters to lowercase
update magic44_test_results set row_hash = lower(replace(row_hash, ' ', ''));

-- The magic44_count_differences view displays the differences between the number of rows contained in the answers
-- and the test results.  the value null in the answer_total and result_total columns represents zero (0) rows for
-- that query result.

drop view if exists magic44_count_answers;
create view magic44_count_answers as
select step_id, query_id, count(*) as answer_total
from magic44_expected_results group by step_id, query_id;

drop view if exists magic44_count_test_results;
create view magic44_count_test_results as
select step_id, query_id, count(*) as result_total
from magic44_test_results group by step_id, query_id;

drop view if exists magic44_count_differences;
create view magic44_count_differences as
select magic44_count_answers.query_id, magic44_count_answers.step_id, answer_total, result_total
from magic44_count_answers left outer join magic44_count_test_results
	on magic44_count_answers.step_id = magic44_count_test_results.step_id
	and magic44_count_answers.query_id = magic44_count_test_results.query_id
where answer_total <> result_total or result_total is null
union
select magic44_count_test_results.query_id, magic44_count_test_results.step_id, answer_total, result_total
from magic44_count_test_results left outer join magic44_count_answers
	on magic44_count_test_results.step_id = magic44_count_answers.step_id
	and magic44_count_test_results.query_id = magic44_count_answers.query_id
where result_total <> answer_total or answer_total is null
order by query_id, step_id;

-- The magic44_content_differences view displays the differences between the answers and test results
-- in terms of the row attributes and values.  the error_category column contains missing for rows that
-- are not included in the test results but should be, while extra represents the rows that should not
-- be included in the test results.  the row_hash column contains the values of the row in a single
-- string with the attribute values separated by a selected delimeter (i.e., the pound sign/#).

drop view if exists magic44_content_differences;
create view magic44_content_differences as
select query_id, step_id, 'missing' as category, row_hash
from magic44_expected_results where concat(step_id, '@', query_id, '@',row_hash) not in
	(select concat(step_id, '@', query_id, '@', row_hash) from magic44_test_results)
union
select query_id, step_id, 'extra' as category, row_hash
from magic44_test_results where concat(step_id, '@', query_id, '@', row_hash) not in
	(select concat(step_id, '@', query_id, '@', row_hash) from magic44_expected_results)
order by query_id, step_id, row_hash;

drop view if exists magic44_result_set_size_errors;
create view magic44_result_set_size_errors as
select step_id, query_id, 'result_set_size' as err_category from magic44_count_differences
group by step_id, query_id;

drop view if exists magic44_attribute_value_errors;
create view magic44_attribute_value_errors as
select step_id, query_id, 'attribute_values' as err_category from magic44_content_differences
where concat(step_id, '@', query_id) not in (select concat(step_id, '@', query_id) from magic44_count_differences)
group by step_id, query_id;

drop view if exists magic44_errors_assembled;
create view magic44_errors_assembled as
select * from magic44_result_set_size_errors
union    
select * from magic44_attribute_value_errors;

drop table if exists magic44_row_count_errors;
create table magic44_row_count_errors (
	query_id integer,
    step_id integer,
    expected_row_count integer,
    actual_row_count integer
);

insert into magic44_row_count_errors
select * from magic44_count_differences
order by query_id, step_id;

drop table if exists magic44_column_errors;
create table magic44_column_errors (
	query_id integer,
    step_id integer,
    extra_or_missing char(20),
    condensed_row_contents varchar(15000)
);

insert into magic44_column_errors
select * from magic44_content_differences
order by query_id, step_id, row_hash;

-- Evaluate potential query errors against the original state and the modified state
drop view if exists magic44_result_errs_original;
create view magic44_result_errs_original as
select distinct 'row_count_errors_initial_state' as title, query_id
from magic44_row_count_errors where step_id = 0;

drop view if exists magic44_result_errs_modified;
create view magic44_result_errs_modified as
select distinct 'row_count_errors_modified_state' as title, query_id
from magic44_row_count_errors
where query_id not in (select query_id from magic44_result_errs_original)
union
select * from magic44_result_errs_original;

drop view if exists magic44_attribute_errs_original;
create view magic44_attribute_errs_original as
select distinct 'column_errors_initial_state' as title, query_id
from magic44_column_errors where step_id = 0
and query_id not in (select query_id from magic44_result_errs_modified)
union
select * from magic44_result_errs_modified;

drop view if exists magic44_attribute_errs_modified;
create view magic44_attribute_errs_modified as
select distinct 'column_errors_modified_state' as title, query_id
from magic44_column_errors
where query_id not in (select query_id from magic44_attribute_errs_original)
union
select * from magic44_attribute_errs_original;

drop view if exists magic44_correct_remainders;
create view magic44_correct_remainders as
select distinct 'fully_correct' as title, query_id
from magic44_test_results
where query_id not in (select query_id from magic44_attribute_errs_modified)
union
select * from magic44_attribute_errs_modified;

drop view if exists magic44_grading_rollups;
create view magic44_grading_rollups as
select title, count(*) as number_affected, group_concat(query_id order by query_id asc) as queries_affected
from magic44_correct_remainders
group by title;

drop table if exists magic44_autograding_results;
create table magic44_autograding_results (
	query_status varchar(1000),
    number_affected integer,
    queries_affected varchar(2000)
);

drop table if exists magic44_autograding_directory;
create table magic44_autograding_directory (query_status_category varchar(1000));

insert into magic44_autograding_directory values ('column_errors_initial_state'),
('fully_correct'), ('row_count_errors_initial_state');

insert into magic44_autograding_results
select query_status_category, number_affected, queries_affected
from magic44_autograding_directory left outer join magic44_grading_rollups
on query_status_category = title;

-- Remove all unneeded tables, views, stored procedures and functions
-- Keep only those structures needed to provide student feedback
drop table if exists magic44_autograding_directory;
drop view if exists magic44_grading_rollups;
drop view if exists magic44_correct_remainders;
drop view if exists magic44_attribute_errs_modified;
drop view if exists magic44_attribute_errs_original;
drop view if exists magic44_result_errs_modified;
drop view if exists magic44_result_errs_original;
drop view if exists magic44_errors_assembled;
drop view if exists magic44_attribute_value_errors;
drop view if exists magic44_result_set_size_errors;
drop view if exists magic44_content_differences;
drop view if exists magic44_count_differences;
drop view if exists magic44_count_test_results;
drop view if exists magic44_count_answers;
drop procedure if exists magic44_evaluate_testing_steps;
drop procedure if exists magic44_evaluate_queries;
drop procedure if exists magic44_test_step_check_and_run;
drop procedure if exists magic44_query_check_and_run;
drop function if exists magic44_test_step_exists;
drop function if exists magic44_query_exists;
drop function if exists magic44_query_capture;
drop function if exists magic44_gen_simple_template;
drop table if exists magic44_column_listing;
drop table if exists magic44_data_capture;
