USE sakila;

-- List all customers along with the films they have rented.
SELECT * FROM customer;
SELECT * FROM inventory;
SELECT * from rental;
SELECT * from film;

SELECT c.customer_id, c.first_name, c.last_name, f.title, r.rental_date
FROM customer c
JOIN rental r    ON c.customer_id  = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f      ON i.film_id = f.film_id
ORDER BY c.customer_id, r.rental_date;

-- List all customers and show their rental count, including those who haven't rented any films.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Show all films along with their category. Include films that don't have a category assigned.

SELECT f.film_id, f.title, c.name AS category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
ORDER BY f.film_id;

--  Show all customers and staff emails from both customer and staff tables using a full outer join (simulate using LEFT + RIGHT + UNION).

SELECT c.email AS customer_email, s.email AS staff_email
FROM customer c
LEFT JOIN staff s ON c.email = s.email
UNION
SELECT c.email AS customer_email, s.email AS staff_email
FROM customer c
RIGHT JOIN staff s ON c.email = s.email;

-- Find all actors who acted in the film "ACADEMY DINOSAUR".
SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f        ON fa.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR';

-- List all stores and the total number of staff members working in each store, even if a store has no staff.
SELECT * from store;
SELECT * from staff;

SELECT st.store_id, COUNT(sf.staff_id) AS staff_count
FROM store st
LEFT JOIN staff sf ON st.store_id = sf.store_id
GROUP BY st.store_id;

-- List the customers who have rented films more than 5 times. Include their name and total rental count.


SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(r.rental_id) > 5
ORDER BY rental_count DESC;
