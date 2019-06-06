-- Selecting Database and showing Actor Table
USE sakila;
SELECT * FROM actor;

-- Showing specific columns
SELECT first_name, last_name
FROM actor;

-- Concattenating previous columns into one
SELECT concat(first_name, " ", last_name) AS Actor_Name
from actor;

--  Query for finding specific values
SELECT * FROM actor WHERE first_name = 'Joe';

--  Finding all actors whose last name contain the letters 'GEN'
SELECT * FROM actor
WHERE last_name like '%GEN%';

-- Finding all actors whose last name contain the letters 'LI'
-- and ordering the rows by last name and first name
SELECT actor_id, last_name, first_name FROM actor
WHERE last_name like '%LI%';

-- Using IN, display the country_id and country columns 
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

--  Create a column in the table actor named description and use the data type BLOB
ALTER TABLE actor
ADD description BLOB(50);

-- Delete the description column
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS '	Number of Actors'
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS 'Number of Repeated Last Names'
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    first_name = 'harpo' and last_name = 'williams';
    
UPDATE actor
SET 
    first_name = 'HARPO'
WHERE
    actor_id = 172;

-- 4d. In a single query, if the first name of the actor is currently HARPO, 
-- change it to GROUCHO.
ROLLBACK;

-- 5a. You cannot locate the schema of the address table.
-- Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, 
-- as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff
INNER JOIN address ON 
address.address_id = staff.address_id;

-- 6b. Display the total amount rung up by each staff member
--     in August of 2005. Use tables staff and payment.
SELECT staff_id, SUM(amount) AS 'Income on Ago-05'
FROM payment
WHERE payment_date LIKE '%2005-08%'
GROUP BY staff_id;

-- 6c. List each film and the number of actors who are listed for that film. 
--     Use tables film_actor and film.
SELECT title, COUNT(actor_id) AS 'Actors per Film'
FROM film_actor
INNER JOIN film ON
film.film_id = film_actor.film_id
GROUP BY title
ORDER BY COUNT(actor_id) DESC;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
    -- Finding the film_id value for that specific film.
    SELECT film_id
    FROM film
    WHERE title IN ('hunchback impossible'); -- film_id = 439
        -- Counting how many copies do exist for the 'film_id=439' value
        SELECT COUNT(store_id)
        FROM inventory
        WHERE film_id = 439
        GROUP BY film_id;
        -- Answer: There exist 6 copies.

-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name
SELECT first_name, last_name, SUM(amount) AS 'Total Paid'
FROM payment
INNER JOIN customer ON 
	payment.customer_id = customer.customer_id
GROUP BY first_name, last_name
ORDER BY last_name ASC;

-- 7a. Use subqueries to display the titles of movies starting with the letters 
--     K and Q whose language is English.
    -- Finding if there exist several films with different language than English wich
    -- has de 'language_id = 1' value
    SELECT * FROM film
    WHERE language_id NOT LIKE ('%1%'); -- All values are NULL, so every film is in English
        SELECT title, name
        FROM film
        INNER JOIN language ON
	    film.language_id = language.language_id
	    WHERE title like 'q%' or 'k%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name, film_id
FROM actor
INNER JOIN film_Actor ON
	actor.actor_id = film_actor.actor_id 
WHERE film_id IN (
	SELECT film_id FROM film
    WHERE title IN ('alone trip')
);

-- 7c. You will need the names and email addresses of all Canadian customers. 
--     Use joins to retrieve this information.
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
	SELECT address_id
    FROM address
    WHERE city_id IN (
		SELECT city_id
        FROM city
        INNER JOIN country ON
		city.country_id = country.country_id
		WHERE country IN ('canada')
        )
    )
;

-- 7d. Identify all movies categorized as family films.
SELECT film_id, title, rating
FROM film
WHERE rating IN ('g','pg','pg-13');

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(*) AS 'Times rented'
FROM film
INNER JOIN inventory ON
inventory.film_id = film.film_id
WHERE inventory_id IN (
	SELECT inventory_id 
    FROM rental)
GROUP BY title
HAVING COUNT(*) > 0
ORDER BY COUNT(*) DESC;

-- 8. Create view.
CREATE VIEW Canadian AS 
    SELECT customer_id, first_name, last_name, email
    FROM customer
    WHERE address_id IN (
	SELECT address_id
        FROM address
        WHERE city_id IN (
	    SELECT city_id
            FROM city
            INNER JOIN country ON
	    city.country_id = country.country_id
	    WHERE country IN ('canada')));
			      
			      
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM canadian
ORDER BY customer_id ASC;

-- 8c. Write a query to delete it.
DROP VIEW canadian;
