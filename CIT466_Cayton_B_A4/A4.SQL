--Q.1: Return the first and last name of all the customer that have performed at least one rental using an EXISTS subquery. —


SELECT first_name, last_name
FROM customer t1
WHERE
EXISTS(SELECT rental.customer_id FROM rental WHERE rental.customer_id = t1.customer_id )
ORDER BY last_name, first_name;

-- Q.2 Using Union, Except, or Intersect provide the name of the customers that never performed a rental.--

SELECT first_name ||', '|| last_name AS "FullName"
FROM customer t1
LEFT JOIN rental t2 ON t1.customer_id = t2.customer_id
WHERE t1.customer_id != t2.customer_id
EXCEPT
SELECT first_name ||', '|| last_name AS "FullName"
FROM customer t1
LEFT JOIN rental t2 ON t1.customer_id = t2.customer_id
WHERE t2.customer_id = t1.customer_id;

--Everyone has made a rental —

--Q.3 	Provide a summary table using GROUPING SETS where the different movies are counted by rental_rate, and by category (the first part must count how many movies exist with rental rate e.g 4.99 and then how many movies exist for a category e.g. Horror)


SELECT 
	t1.rental_rate,
	t3.name,
	COUNT(t3.name)

FROM film t1
LEFT JOIN film_category t2 ON t1.film_id = t2.film_id
LEFT JOIN category t3 ON t2.category_id = t3.category_id
GROUP BY GROUPING SETS(
				(t1.rental_rate,
				t3.name),(t3.name))
HAVING GROUPING(t1.rental_rate) = 0
ORDER BY
	t1.rental_rate,
	t3.name


--Q.4 Return the title of the movies that have a rental rate equal to the maximum rental rate for THEIR film category.

SELECT title, name, rental_rate
FROM film
LEFT JOIN film_category USING (film_id)
LEFT JOIN category USING (category_id)
WHERE rental_rate = (SELECT MAX(rental_rate)
FROM film)
ORDER BY name;


--Q.5 Using a CTE (WITH) expression that retrieves for each category of movie their average length provide the title of movies that have a length exactly equal to the average length of their category.

-- Not gonna lie, this one was pretty difficult for me to figure out

WITH cte_lengths AS
(SELECT name, ROUND(avg(length)) avglength
FROM film
LEFT JOIN film_category USING (film_id)
LEFT JOIN category USING (category_id)
GROUP BY name)

SELECT title, cte_lengths.name, cte_lengths.avglength 
FROM film

LEFT JOIN film_category USING (film_id)
LEFT JOIN category USING (category_id)
LEFT JOIN cte_lengths USING (name)
WHERE film.length = cte_lengths.avglength
ORDER BY name, title;


-- Q. 6 Create a View that lists all the movies (title and length) along with the name of the language. Name the view view_movie_language.

CREATE VIEW view_movie_language(
	
SELECT title "FilmTitle", length "RunTime", name "Language"
FROM film
INNER JOIN language USING (language_id)
ORDER BY title, length, language;
);


-- Q.7 Create a Materialized View that list the last rental for each customer. List customer name and last_name, and rental date. Name the view view_last_rental. Populate the materialized view.

CREATE MATERIALIZED VIEW view_last_rental
AS

SELECT "Full Name", rental.rental_date "Last Rental" 
FROM (SELECT DISTINCT customer_id, first_name || ' ' || last_name "Full Name",
	 MAX(rental_id) AS latest_id
	 FROM customer
	 INNER JOIN rental USING (customer_id)
	 GROUP BY customer_id
	 ORDER BY "Full Name") AS last_rental

INNER JOIN rental USING (customer_id)
WHERE last_rental.latest_id = rental.rental_id
GROUP BY "Full Name", rental.rental_date
ORDER BY "Full Name";

