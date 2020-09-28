-- 1 Count the number of customers whose surname starts with each letter of the alphabet

SELECT LEFT(last_name, 1) AS Initial,
COUNT (last_name) as NumOfNames
FROM 
	customer
GROUP BY
	Initial
ORDER BY
	Initial;
--2 Return a count of rentals for each month of year 2005

SELECT 
	EXTRACT(YEAR FROM rental_date) yyyy,
	EXTRACT(MONTH FROM rental_date) m,
	COUNT(rental_id)
	FROM rental
	WHERE 
		EXTRACT(YEAR FROM rental_date) = '2005'
	GROUP BY yyyy, m
	ORDER BY m;
--3 Provide a list of all the rentals (title of the movie, date of the rental) for the customers whose first name is John (output also the name of the customers)

SELECT 
	first_name || ' ' || last_name AS FullName,
	rental_date,
	title
	
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id

WHERE c.first_name = 'John'

ORDER BY rental_date;


--4 Calculate the maximum, minimum, and average of the rental rates for all the movies

SELECT 
	MAX(rental_rate) AS Maximum,
	MIN(rental_rate) AS Minimum,
	ROUND(AVG(rental_rate),2) AS Average
FROM
	film;


--5 Return all the addresses stored in the database completed with the name of the city and the name of the country

SELECT a.address, address2, c.city, a.district, postal_code, country.country
FROM address a
INNER JOIN city c ON c.city_id = a.city_id
INNER JOIN country ON country.country_id = c.country_id

ORDER BY country.country;


--6 Return the number of movies present in each category

SELECT c.name AS "Genre", COUNT(f.film_id) AS "Total Number"

FROM category c
INNER JOIN film_category fc ON fc.category_id = c.category_id
INNER JOIN film f ON fc.film_id = f.film_id

GROUP BY c.name
ORDER BY c.name;


--7 Return a list of all the different first 3 numbers of a zipcode (something that can be used to determine the number of different cities, do not worry about the fact that they are in different countries)

SELECT DISTINCT LEFT(postal_code, 3) AS "First 3"
FROM address
ORDER BY "First 3";


--8 Find the total revenue (the sum of all the rentals) for each store (characterized by store_id)

SELECT s.store_id, SUM(p.amount) AS "Total Revenue"
 
 FROM store s, payment p
 INNER JOIN staff st ON st.staff_id = p.staff_id
 
 WHERE s.store_id = st.store_id

GROUP BY s.store_id
ORDER BY s.store_id;


--9 Return a list of all the customers that performed more than 40 rentals

SELECT first_name || ' ' || last_name AS "FrequentCustomer", 
	COUNT(rental_id) AS "Total Rentals"
FROM customer c
	INNER JOIN rental r ON r.customer_id = c.customer_id

GROUP BY "FrequentCustomer"
HAVING COUNT(rental_id) > 40
ORDER BY "Total Rentals" DESC;

--10 Provide the titles of all the movies rented by Nicholas Barfield.

SELECT 

	title AS "Nicks Rentals"
	
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN inventory i ON i.inventory_id = r.inventory_id
INNER JOIN film f ON f.film_id = i.film_id

WHERE c.first_name = 'Nicholas'
	AND c.last_name = 'Barfield'

ORDER BY "Nicks Rentals";
