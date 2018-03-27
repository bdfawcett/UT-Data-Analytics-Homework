USE sakila;

-- 1a
SELECT 
	first_name, 
    last_name 
FROM actor
;

-- 1b
SELECT 
	concat(first_name, ' ', last_name) 
AS 'Actor Name'
FROM actor
;

-- 2a
SELECT 
	actor_id,
	first_name, 
    last_name
FROM actor
WHERE first_name = 'Joe'
;

-- 2b
SELECT 
	actor_id,
	first_name, 
    last_name
FROM actor
WHERE last_name LIKE '%GEN%'
;

-- 2c
SELECT 
	actor_id,
	first_name, 
    last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name
;

-- 2d
SELECT
	country_id,
    country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
;

-- 3a
ALTER TABLE actor
	ADD COLUMN middle_name VARCHAR(45) AFTER first_name
;

-- 3b
ALTER TABLE actor 
	MODIFY middle_name BLOB
;

-- 3c
ALTER TABLE actor
  DROP COLUMN middle_name
;

-- 4a
SELECT 
    last_name,
    count(last_name)
FROM actor
GROUP BY last_name
;

-- 4b
SELECT 
    last_name,
    count(last_name) c
FROM actor
GROUP BY last_name HAVING c > 1
;

-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'
;

-- 4d
UPDATE actor
SET first_name = (CASE WHEN first_name = 'GROUCHO' THEN 'MUCHO GROUCHO'
					   WHEN first_name = 'HARPO' THEN 'GROUCHO'
				 END)
WHERE first_name IN ('GROUCHO', 'HARPO')
;

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT
	s.first_name,
    s.last_name,
    a.address
FROM staff s
JOIN address a ON
a.address_id = s.address_id
;

-- 6b
SELECT
	s.staff_id,
	s.first_name,
    s.last_name,
    p.payment_date,
    sum(p.amount)
FROM staff s
JOIN payment p ON
s.staff_id = p.staff_id
WHERE p.payment_date LIKE '2005-08-%%'
GROUP BY s.staff_id
;

-- 6c
SELECT
	f.title,
    count(a.actor_id)
FROM film f
INNER JOIN film_actor a ON
f.film_id = a.film_id
GROUP BY f.title
;

-- 6d
SELECT
	f.title,
    count(i.film_id)
FROM film f
INNER JOIN inventory i ON
f.film_id = i.film_id
GROUP BY f.title
;

-- 6e
SELECT
	c.first_name,
    c.last_name,
    sum(p.amount)
FROM payment p
INNER JOIN customer c ON
p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name
;

-- 7a
SELECT title
FROM film 
WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id IN
	(
		SELECT language_id
		FROM language l
		WHERE name = 'English'
	)
;

-- 7b
SELECT 
	actor_id,
    first_name, 
    last_name
FROM actor
WHERE actor_id IN
	(
		SELECT actor_id
        FROM film_actor
        WHERE film_id IN
        (
			SELECT film_id
			FROM film
            WHERE title = 'Alone Trip'
		)
	)
;

-- 7c
SELECT
	cust.first_name,
    cust.last_name,
    cust.email
FROM customer cust
INNER JOIN address a ON
a.address_id = cust.address_id
INNER JOIN city ci ON
a.city_id = ci.city_id
INNER JOIN country co ON
ci.country_id = co.country_id
WHERE co.country = 'Canada'
;

-- 7d
SELECT 
	title 
FROM film f
INNER JOIN film_category fc ON
f.film_id = fc.film_id
INNER JOIN category c ON
fc.category_id = c.category_id
WHERE c.name = 'Family'
;

-- 7e
SELECT 
	f.title,
    count(r.inventory_id)
FROM film f
INNER JOIN inventory i ON
f.film_id = i.film_id
INNER JOIN rental r ON
i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY count(r.inventory_id) DESC
;

-- 7f
SELECT
	s.store_id,
    sum(p.amount) AS Revenue
FROM payment p
INNER JOIN customer cust ON
p.customer_id = cust.customer_id
INNER JOIN store s ON
cust.store_id = s.store_id
GROUP BY s.store_id
;

-- 7g
SELECT
	s.store_id,
    ci.city,
    co.country
FROM store s
INNER JOIN address a ON
s.address_id = a.address_id
INNER JOIN city ci ON
a.city_id = ci.city_id
INNER JOIN country co ON
ci.country_id = co.country_id
;

-- 7h
SELECT
	c.name,
    sum(p.amount) AS Revenue
FROM payment p
INNER JOIN rental r ON
p.rental_id = r.rental_id
INNER JOIN inventory i ON
r.inventory_id = i.inventory_id
INNER JOIN film_category fc ON
i.film_id = fc.film_id
INNER JOIN category c ON
fc.category_id = c.category_id
GROUP BY c.name
ORDER BY Revenue DESC
LIMIT 5
;

-- 8a
CREATE VIEW top_five_genres AS
	SELECT
	c.name,
    sum(p.amount) AS Revenue
	FROM payment p
	INNER JOIN rental r ON
	p.rental_id = r.rental_id
	INNER JOIN inventory i ON
	r.inventory_id = i.inventory_id
	INNER JOIN film_category fc ON
	i.film_id = fc.film_id
	INNER JOIN category c ON
	fc.category_id = c.category_id
	GROUP BY c.name
	ORDER BY Revenue DESC
	LIMIT 5
;

-- 8b
SELECT * FROM sakila.top_five_genres;

-- 8c
DROP VIEW IF EXISTS sakila.top_five_genres;