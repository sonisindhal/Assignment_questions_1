use sakila;


-- Customers who rented in the same month (and year) as customer 5 (Subqueries)
SELECT * from customer;
select * from rental;


SELECT *
FROM customer
WHERE customer_id IN (
   SELECT customer_id
   FROM rental
   WHERE (YEAR(rental_date), MONTH(rental_date)) IN (
       SELECT DISTINCT YEAR(rental_date), MONTH(rental_date)
       FROM rental
       WHERE customer_id = 5
   )
)
AND customer_id != 5;


-- same questions using recursive CTE


WITH customer5_months AS (
   SELECT DISTINCT YEAR(rental_date) AS yr, MONTH(rental_date) AS mon
   FROM rental
   WHERE customer_id = 5
),
matching_customers AS (
   SELECT DISTINCT r.customer_id
   FROM rental r
   JOIN customer5_months cm
     ON YEAR(r.rental_date) = cm.yr
    AND MONTH(r.rental_date) = cm.mon
   WHERE r.customer_id != 5
)
SELECT c.*
FROM customer c
JOIN matching_customers mc ON c.customer_id = mc.customer_id;


-- Staff who handled a payment greater than the average payment (subqueries)


SELECT * from staff;
select * from payment;




SELECT *
FROM staff
WHERE staff_id IN (
   SELECT staff_id
   FROM payment
   WHERE amount > (
       SELECT AVG(amount)
       FROM payment
   )
);


-- Films whose rental duration is above the average (subqueries)


SELECT * from film;




SELECT title, rental_duration
FROM film
WHERE rental_duration > (
   SELECT AVG(rental_duration)
   FROM film
);


-- Customers with the same address as customer 1 (subqueries)




SELECT *
FROM customer
WHERE address_id = (
   SELECT address_id
   FROM customer
   WHERE customer_id = 1
)
AND customer_id != 1;


-- Payments greater than the average payment (subqueries)


SELECT *
FROM payment
WHERE amount > (
   SELECT AVG(amount)
   FROM payment
);




-- Customers who have made more than 5 payments (CTE)




WITH payment_counts AS (
   SELECT customer_id, COUNT(*) AS total_payments
   FROM payment
   GROUP BY customer_id
)
SELECT c.*, pc.total_payments
FROM customer c
JOIN payment_counts pc ON c.customer_id = pc.customer_id
WHERE pc.total_payments > 5;


-- 2. Actors who have acted in more than 10 films (CTE)


WITH actor_film_counts AS (
   SELECT actor_id, COUNT(film_id) AS film_count
   FROM film_actor
   GROUP BY actor_id
)
SELECT a.first_name, a.last_name, afc.film_count
FROM actor a
JOIN actor_film_counts afc ON a.actor_id = afc.actor_id
WHERE afc.film_count > 10;



-- 3. Customers who never made a payment (Temp Table)


DROP TEMPORARY TABLE IF EXISTS tmp_paying_customers;



CREATE TEMPORARY TABLE tmp_paying_customers AS
SELECT DISTINCT customer_id
FROM payment;


SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN tmp_paying_customers t ON c.customer_id = t.customer_id
WHERE t.customer_id IS NULL;



-- 4. Films whose rental rate is above the average rental rate (Views)




CREATE OR REPLACE VIEW v_avg_rate AS
SELECT AVG(rental_rate) AS avg_rental_rate
FROM film;


SELECT f.title, f.rental_rate
FROM film f
CROSS JOIN v_avg_rate v
WHERE f.rental_rate > v.avg_rental_rate;





