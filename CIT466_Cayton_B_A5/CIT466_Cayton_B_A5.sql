CREATE DATABASE bigcompany;


--	Create a schema named internal, all the tables should be declared within this schema.

CREATE SCHEMA internal;

-- set search path so we don’t have to specify our schema on DDL statements

SET search_path TO internal, public;
DROP schema public;


--CREATE REGIONS TABLE
--DO NOT ALLOW NEGATIVE NUMBERS FOR EASE OF USE AND DATA ENTRY

CREATE TABLE IF NOT EXISTS regions(
	REGION_ID smallint PRIMARY KEY CHECK (REGION_ID > 0),
	REGION_NAME varchar(25)
);

--CREATE COUNTRIES TABLE

CREATE TABLE IF NOT EXISTS countries(
	country_id char(2) PRIMARY KEY,
	country_name varchar(40),
	region_id smallint,
	CONSTRAINT fk_region
		FOREIGN KEY(region_id) 
				REFERENCES regions(region_id)
				ON DELETE CASCADE
				ON UPDATE CASCADE
);

--CREATE LOCATIONS TABLE
--LOCATION ID !< 0 FOR EASE OF USE / DATA ENTRY

CREATE TABLE IF NOT EXISTS locations(
	location_id integer PRIMARY KEY CHECK(location_id > 0),
	street_address varchar(25),
	postal_code varchar(12),
	city varchar(30),
	state_province varchar(12),
	country_id char(2),
	CONSTRAINT fk_country
		FOREIGN KEY(country_id) 
				REFERENCES countries(country_id)
				ON DELETE CASCADE
				ON UPDATE CASCADE
);


--CREATE DEPARTMENTS TABLE
--DEPT ID !< 0 FOR EASE OF USE / DATA ENTRY

CREATE TABLE IF NOT EXISTS departments(
	department_id integer PRIMARY KEY CHECK(department_id > 0),
	department_name varchar(30),
	manager_id smallint CHECK(manager_id > 0),
	location_id integer,
	CONSTRAINT fk_location
		FOREIGN KEY(location_id) 
				REFERENCES locations(location_id)
				ON DELETE CASCADE
				ON UPDATE CASCADE
);


--create jobs table
CREATE TABLE IF NOT EXISTS jobs(
	JOB_ID VARCHAR(10) PRIMARY KEY,
	JOB_TITLE VARCHAR(35),
	MIN_SALARY NUMERIC(9,2) DEFAULT 0,
	MAX_SALARY NUMERIC(9,2) DEFAULT 1000000
);


--AS PER OUR EMAIL CONVO, RELATIONSHIP FROM 'job-history' to 'employees' IS INCORRECT
-- CREATE EMPLOYEES TABLE
CREATE TABLE IF NOT EXISTS employees(
	employee_id serial PRIMARY KEY,
	first_name varchar(20) NOT NULL,
	last_name varchar(25) NOT NULL,
	email varchar(25),
	phone_number varchar(20),
	hire_date date NOT NULL,
	job_id varchar(10),
	salary numeric(9,2) NOT NULL CHECK(salary >= 0 AND salary <= 1000000),
	commission_pct numeric(4,3),
	manager_id smallint CHECK(manager_id > 0),
	department_id integer CHECK(department_id > 0),
	
	CONSTRAINT fk_jobs
		FOREIGN KEY(job_id)
			REFERENCES jobs(job_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE,
	
	CONSTRAINT fk_department
		FOREIGN KEY(department_id)
			REFERENCES departments(department_id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
);

-- CREATE JOB_HISTORY TABLE
CREATE TABLE IF NOT EXISTS job_history(
	employee_id serial PRIMARY KEY,
	start_date date,
	end_date date,
	job_id varchar(10),
	department_id integer CHECK(department_id > 0),
	CONSTRAINT fk_job
		FOREIGN KEY(job_id)
			REFERENCES jobs(job_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
	
	CONSTRAINT fk_department
		FOREIGN KEY(department_id)
			REFERENCES departments(department_id)
			ON DELETE CASCADE
			ON UPDATE CASCADE
);



--ALTER job_history TABLE
--FORGOT TO ADD SECOND PK FOR COMPOSITE KEY
ALTER TABLE job_history
	DROP CONSTRAINT job_history_pkey;

--SECOND ALTER TO FIX THE COMPOSITE KEY
ALTER TABLE job_history
	ADD PRIMARY KEY(employee_id, start_date);

--HAD TO CHANGE DATA TYPE OF EMPLOYEE_ID
ALTER TABLE job_history
ALTER COLUMN employee_id TYPE smallint;




--CREATE JOB_GRADES TABLE
CREATE TABLE IF NOT EXISTS job_grades(
	grade_level varchar(2) PRIMARY KEY,
	lowest_sal numeric(9,2) DEFAULT 0,
	highest_sal numeric(9,2) DEFAULT 1000000
);




-- INSERT STATEMENTS
-- REGIONS
INSERT INTO internal.regions (region_id, region_name)
VALUES
(1, 'North America'),
(2, 'South America'),
(3, 'Europe'),
(4, 'Africa'),
(5, 'Asia'),
(6, 'Australia'),
(7, 'Antarctica');


--DELETE STATEMENT
DELETE FROM regions
WHERE region_name = 'Antarctica';


-- Countries
INSERT INTO countries (country_id, country_name, region_id)
VALUES
('US', 'United States of America', 1),
('CA', 'Canada', 1),
('MX', 'Mexico', 1),
('GL', 'Greenland', 1),
('CU', 'Cuba', 1),
('CR', 'Costa Rica', 1),
('PA', 'Panama', 1),
('BZ', 'Brazil', 2),
('CB', 'Columbia', 2),
('AG', 'Argentina', 2),
('PU', 'Peru', 2),
('VZ', 'Venezuela', 2),
('CH', 'Chile', 2),
('EC', 'Ecuador', 2),
('BV', 'Bolivia', 2),
('PG', 'Paraguay', 2),
('UG', 'Uruguay', 2),
('UK', 'United Kingdom', 3),
('IC', 'Iceland', 3),
('HG', 'Hungary', 3),
('PT', 'Portugal', 3),
('IR', 'Ireland', 3),
('CT', 'Croatia', 3),
('BN', 'Bosnia', 3),
('SV', 'Slovakia', 3),
('ES', 'Estonia', 3),
('IT', 'Italy', 3),
('TK', 'Turkey', 3),
('CY', 'Cyprus', 3),
('LX', 'Luxembourg', 3),
('DZ', 'Algeria', 4),
('AO', 'Angola', 4),
('BJ', 'Benin', 4),
('BW', 'Botswana', 4),
('BF', 'Burkina Faso', 4),
('CF', 'Central African Repubic', 4),
('TD', 'Chad', 4),
('CG', 'Congo', 4),
('ET', 'Ethiopia', 4),
('GH', 'Ghana', 4),
('AF', 'Afghanistan', 5),
('BX', 'Brunei', 5),
('HK', 'Hong Kong', 5),
('MK', 'Oman', 5),
('SY', 'Syria', 5),
('TH', 'Thailand', 5),
('QA', 'Qatar', 5),
('SI', 'Singapore', 5),
('BA', 'Bahrain', 5),
('CI', 'Cambodia', 5),
('CC', 'China', 5),
('JA', 'Japan', 5),
('AU', 'Australia', 6),
('NG', 'Papua New Guinea', 6),
('NZ', 'New Zealand', 6);

--Update data statement
UPDATE regions
SET region_name = 'Oceana'
WHERE region_id = 6;

--Alter the length of var char field for state (‘North Carolina’) didn’t fit
ALTER TABLE locations
ALTER COLUMN state_province TYPE varchar(30);

--See above
ALTER TABLE locations
ALTER COLUMN street_address TYPE varchar(50);


INSERT INTO locations(location_id, street_address, postal_code, city, state_province, country_id)
VALUES
(1, '1 John Marshall', '25701', 'Huntington', 'West Virginia', 'US'),
(2, 'McLaren Technology Center', 'GU21 4YH', 'Woking', NULL, 'UK'),
(3, 'Viao Boaria 229', '48018', 'Faenza', 'Ravenna', 'IT');


INSERT INTO departments(department_id, department_name, manager_id, location_id)
VALUES
(200, 'Data Analytics', 500, 1),
(100, 'Applications Developmen', 300, 1),
(210, 'Embedded Systems', 500, 2),
(300, 'Information Security', 300, 1);

INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
VALUES
('DB ADMIN', 'Database Administrator', 60000, 350000),
('SFTR DEV', 'Desktop Developer', 45000, 110000),
('WEB DEV', 'Web Application Developer', 40000, 95000),
('NET ENG', 'Network Engineer', 62450, 140000),
('CYB SEC', 'Information Security Eng', 70000, 160000),
('EMB SYS', 'Embedded Systems Eng', 85000, 200000);


INSERT INTO employees(first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES
('Benjamin', 'Cayton', 'cayton10@marshall.edu', '3046389603', '2017-11-12', 'DB ADMIN', 72000, 0, 1, 200),
('John', 'Doe', 'jd@marshall.edu', '5555155252', '2010-10-31', 'WEB DEV', 83000, 0, 1, 200),
('Jane', 'Doe', 'jd2@marshall.edu', '5555515252', '2011-10-31', 'SFTR DEV', 80000, 0.10, 1, 200);

UPDATE employees
SET manager_id = 300,
	department_id = 100
WHERE
	job_id ILIKE '%dev%';


INSERT INTO job_history(employee_id, start_date, job_id, department_id)
SELECT
	employee_id,
	hire_date,
	job_id,
	department_id
FROM
	employees;

UPDATE employees
SET  job_id = 'EMB SYS', salary = 135250, department_id = 210
WHERE email = 'cayton10@live.marshall.edu';


INSERT INTO job_history(employee_id, start_date, end_date, job_id, department_id)
VALUES
(1, '2018-11-13', NULL, 'EMB SYS', 210 );


INSERT INTO job_grades(grade_level, lowest_sal, highest_sal)
VALUES
('A1', 23750, 42500),
('A2', 27500, 46000),
('A3', 29000, 52000),
('B1', 32000, 57000),
('B2', 35000, 65000),
('B3', 40000, 72000),
('C1', 45000, 82000),
('C2', 55000, 95000),
('C3', 64000, 140000);