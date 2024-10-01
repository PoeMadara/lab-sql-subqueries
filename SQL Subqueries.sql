-- Exercise 1: Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system
SELECT 
    COUNT(*) AS num_copies  -- Number of copies of "Hunchback Impossible"
FROM 
    inventory
WHERE 
    film_id = (SELECT film_id FROM film WHERE title = 'Hunchback Impossible');  -- Subquery to get film_id for "Hunchback Impossible"

-- Exercise 2: List all films whose length is longer than the average length of all films in the Sakila database
SELECT 
    title, 
    length  -- Film title and length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);  -- Subquery to calculate the average length of all films

-- Exercise 3: Use a subquery to display all actors who appear in the film "Alone Trip"
SELECT 
    a.first_name, 
    a.last_name  -- Actor's first and last name
FROM 
    actor AS a
WHERE 
    a.actor_id IN (
        SELECT fa.actor_id 
        FROM film_actor AS fa 
        JOIN film AS f ON fa.film_id = f.film_id
        WHERE f.title = 'Alone Trip'  -- Subquery to find all actors in "Alone Trip"
    );

-- Bonus 1: Identify all movies categorized as family films
SELECT 
    f.title  -- Film title
FROM 
    film AS f
JOIN 
    film_category AS fc ON f.film_id = fc.film_id
JOIN 
    category AS c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';  -- Movies categorized as 'Family'

-- Bonus 2: Retrieve the name and email of customers from Canada using both subqueries and joins
SELECT 
    c.first_name, 
    c.last_name, 
    c.email  -- Customer name and email
FROM 
    customer AS c
WHERE 
    c.address_id IN (
        SELECT a.address_id 
        FROM address AS a
        WHERE a.city_id IN (
            SELECT ci.city_id 
            FROM city AS ci
            WHERE ci.country_id = (SELECT country_id FROM country WHERE country = 'Canada')  -- Subquery to find Canadian customers
        )
    );

-- Bonus 3: Determine which films were starred by the most prolific actor
SELECT 
    f.title  -- Film titles starred by the most prolific actor
FROM 
    film AS f
JOIN 
    film_actor AS fa ON f.film_id = fa.film_id
WHERE 
    fa.actor_id = (
        SELECT fa.actor_id
        FROM film_actor AS fa
        GROUP BY fa.actor_id
        ORDER BY COUNT(fa.film_id) DESC  -- Find the most prolific actor based on number of films
        LIMIT 1
    );

-- Bonus 4: Find the films rented by the most profitable customer
SELECT 
    f.title  -- Film titles rented by the most profitable customer
FROM 
    film AS f
JOIN 
    inventory AS i ON f.film_id = i.film_id
JOIN 
    rental AS r ON i.inventory_id = r.inventory_id
WHERE 
    r.customer_id = (
        SELECT p.customer_id 
        FROM payment AS p
        GROUP BY p.customer_id
        ORDER BY SUM(p.amount) DESC  -- Most profitable customer based on total payments
        LIMIT 1
    );

-- Bonus 5: Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client
SELECT 
    customer_id, 
    SUM(amount) AS total_amount_spent  -- Total amount spent by each client
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    total_amount_spent > (
        SELECT AVG(total_amount) 
        FROM (
            SELECT 
                customer_id, 
                SUM(amount) AS total_amount  -- Subquery to calculate average total amount spent per client
            FROM 
                payment
            GROUP BY 
                customer_id
        ) AS subquery
    );
