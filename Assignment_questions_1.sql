use sakila;

-- Get all customers whose first name starts with 'J' and who are active.-----

SELECT * from customer;
SELECT * from customer where first_name like 'j%' and active = TRUE;

-- Find all films where the title contains the word 'ACTION' or the description contains 'WAR'.

select * from film;
SELECT * from film WHERE title LIKE '%action%' or description like '%war%';


-- List all customers whose last name is not 'SMITH' and whose first name ends with 'a'. ---
SELECT * from customer WHERE first_name like '%a' AND last_name != 'SMITH';


-- Get all films where the rental rate is greater than 3.0 and the replacement cost is not null.----

SELECT * FROM film WHERE rental_rate >3.0 AND replacement_cost IS NOT NULL;

-- Count how many customers exist in each store who have active status = 1. ---

SELECT store_id, COUNT(*) AS active_customers FROM customer WHERE active = TRUE GROUP BY store_id;

-- Show distinct film ratings available in the film table. --

SELECT DISTINCT (rating) from film;
-- Find the number of films for each rental duration where the average length is more than 100 minutes.

SELECT rental_duration, COUNT(*) AS numbr_of_films FROM film GROUP BY rental_duration HAVING AVG(length) > 100;

-- List payment dates and total amount paid per date, but only include days where more than 100 payments were made.


SELECT * FROM payment;

SELECT DATE(payment_date) AS pay_date,
       COUNT(*)           AS num_payments,
       SUM(amount)        AS total_amount
FROM payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100
ORDER BY pay_date;

-- Find customers whose email address is null or ends with '.org'.

SELECT * FROM customer WHERE email IS NULL OR email LIKE '%.org';

-- List all films with rating 'PG' or 'G', and order them by rental rate in descending order.

SELECT * FROM film WHERE rating IN ('PG', 'G') ORDER BY rental_rate DESC;

-- Count how many films exist for each length where the film title starts with 'T' and the count is more than 5.

SELECT length, COUNT(*) AS film_count
FROM film
WHERE title LIKE 'T%'
GROUP BY length
HAVING COUNT(*) >5;

-- List all actors who have appeared in more than 10 films.

SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;

-- Find the top 5 films with the highest rental rates and longest lengths combined, ordering by rental rate first and length second.

SELECT *, length FROM film ORDER BY rental_rate DESC, length DESC LIMIT 5;

-- Show all customers along with the total number of rentals they have made, ordered from most to least rentals.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_rentals DESC;

-- List the film titles that have never been rented.

SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r    ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) = 0;
