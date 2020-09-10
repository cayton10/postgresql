--Q. 1 - RETRIEVE ALL THE INFORMATION FROM THE FILM TABLE --
SELECT *
FROM film;

--Q. 2 - OUTPUT THE NAMES OF ALL CUSTOMERS, FORMATTED AS 'SURNAME, FIRSTNAME' ORDERED BY LAST 
--NAME, THEN FIRST NAME. THE NEW COLUMN SHOULD BE NAMED "NAME"
SELECT last_name || ', ' || first_name AS "Name"
FROM customer
ORDER BY last_name ASC, 
		 first_name ASC;

--Q. 3 - LIST THE TITLE OF ALL THE MOVIES THAT CONTAIN THE WORD 'ALIEN'
SELECT title
FROM film
--REMEMBER TO USE SINGLE (') QUOTES FOR STRINGS
WHERE title ILIKE '%alien%';

--Q. 4 - LIST THE TITLE OF ALL THE MOVIES AND CLASSIFY THEIR RENTAL PRICE AS "EXPENSIVE" 
--IF IT IS GREATER THAN $2.99 AND "CHEAP IF IT IS LESS THAN $2.99. USE THE NAME "COST" FOR
--THIS NEW COLUMN
SELECT title, rental_rate,
	CASE
		WHEN rental_rate > 2.99 THEN 'Expensive'
		WHEN rental_rate <= 2.99 THEN 'Cheap'
	END AS "Cost"
FROM film;
--THIS ONE WAS KIND OF TRICKY AS I WAS ATTEMPTING TO USE IF CONDITIONS AT FIRST. THE IN CLASS
--EXAMPLE HELPED ME COMPLETE THIS QUERY.

--Q. 5 - RETURN THE FIRST NAME AND LAST NAME OF ALL THE CUSTOMERS WHOSE FIRST NAME IS EITHER 
--JOHN OR MARY
SELECT first_name, last_name
FROM customer
WHERE first_name ILIKE 'john' OR
first_name ILIKE 'mary';

--Q. 6 - FOR EACH RENTAL RETURN THE LENGTH OF THE RENTAL(DATES) ASSOCIATED WITH THE ID.
--(BONUS: WHAT HAPPENS IF THE RENTAL IS STILL ONGOING?)

SELECT rental_id, 
	CASE
		WHEN rental_date < return_date THEN
			return_date - rental_date
	end	AS rental_length
FROM rental
ORDER BY rental_length DESC; --LISTS RENTALS STILL OUT FIRST, THEN LONGEST RENTED TITLE, ETC.

--IF RENTAL IS STILL ONGOING, THE VALUE WILL BE NULL. THIS IS BECAUSE THE RETURN DATE IS NULL. 


--Q. 7 - Return all the current rentals (think about the return date)
SELECT *
FROM rental
WHERE return_date IS NULL;

--Q. 8 - SELECT THE NAME OF THE COUNTRIES THAT CONTAIN "TA"
SELECT country
FROM COUNTRY
WHERE country ILIKE '%ta%';

--Q. 9 - SELECT ALL THE RENTALS THAT STARTED BETWEEN THE 1ST OF MAY 2005 AND THE 3RD OF AUGUST
--2005
SELECT *
FROM rental
WHERE return_date BETWEEN '05-1-2005' AND '08-3-2005'
ORDER BY return_date ASC;

--Q. 10 - SELECT THE TITLE OF THE MOVIES WHOSE DESCRIPTION CONTAIN MORE THAN 8 WORDS
SELECT *
FROM film
WHERE array_length(regexp_split_to_array(description, '\s+'), 1) > 8;
--The regexp_split_to_array function behaves the same as regexp_split_to_table, 
--except that regexp_split_to_array returns its result as an array of text. 
--It has the syntax regexp_split_to_array(string, pattern [, flags ]). 
--The parameters are the same as for regexp_split_to_table.

--Found the information from the above at: https://www.postgresql.org/docs/9.1/functions-matching.html
--The documentation is readable, and the array_length(regexp_split_to_array) function works as described
--with DESCRIPTION as the 'string' parameter, SPACE '\s+' as the pattern parameter, but I was confused
--about what the flag represented. After looking over lots of web resources I found the example below.
--I'm still not sure why '1' is the appropriate flag here. I tried multiple values and they all broke
--the query, so maybe you can shed some light on this for me.

--https://stackoverflow.com/a/27835047/12671600