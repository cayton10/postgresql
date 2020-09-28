# Advanced SELECT Statements

## Q. 1 - 
#### Count the number of customers whose surname starts with each letter of the alphabet

Used
```SQL
LEFT(string, n)
```
function to limit results of string. Function returns the first n character in the string returned

## Q. 2 -
#### Return a count of rentals for each month of year 2005

Was overcomplicating things from our in class example using ROLLUP(). I removed rollup and set the WHERE clause to limit results to
```SQL
EXTRACT(YEAR FROM rental_date) = '2005'
```
and everything worked fine.

## Q. 3 - 10

Mostly all related to INNER JOINs. Not bad. Was really good practice for putting joins together. I'm sure if I looked further into the records returned for each table I could optimize some of the JOINs, but I think for the purposes of this exercise I satisfied the requirements.