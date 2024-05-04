
-- Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output.
select title, length,
rank () over (order by length asc) as ranking
from sakila.film
where length is not null and length > 0;


-- Rank films by length within the rating category (filter out the rows with nulls or zeros in length column). 
	-- In your output, only select the columns title, length, rating and rank.
select title, length, rating,
rank () over (partition by rating order by length asc) as ranking
from sakila.film
where length is not null and length > 0;  
 
    
-- How many films are there for each of the categories in the category table? 
	-- Hint: Use appropriate join between the tables "category" and "film_category".
select *
from sakila.category;
select *
from sakila.film_category;

CREATE TEMPORARY TABLE sakila.join_film_per_category as
SELECT film_category.film_id, category.name
FROM sakila.film_category
LEFT JOIN sakila.category
  ON film_category.category_id = category.category_id;
  
select name, count(film_id) as 'number of films'
from sakila.join_film_per_category
group by name
order by count(film_id);
    
 
-- Which actor has appeared in the most films? 
	-- Hint: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
select *
from sakila.actor;
select *
from sakila.film_actor;

CREATE TEMPORARY TABLE sakila.join_films_per_actor as
SELECT a.first_name, a.last_name, fa.film_id
FROM sakila.actor a
LEFT JOIN sakila.film_actor fa
  ON a.actor_id = fa.actor_id;
  
select first_name, last_name, count(film_id) as 'number of films'
from sakila.join_films_per_actor
group by 1,2
order by 3 desc;   
 

-- Which is the most active customer (the customer that has rented the most number of films)? 
	-- Hint: Use appropriate join between the tables "customer" and "rental" and count the rental_id for each customer.
select * 
from sakila.customer;
select * 
from sakila.rental;

CREATE TEMPORARY TABLE sakila.join_rentals_per_customer as
SELECT c.first_name, c.last_name, r.rental_id
FROM sakila.customer c
LEFT JOIN sakila.rental r
  ON c.customer_id = r.customer_id;

select first_name, last_name, count(rental_id) as 'number of rentals'
from sakila.join_rentals_per_customer
group by 1,2
order by 3 desc;   

-- Bonus: Which is the most rented film? (The answer is Bucket Brotherhood).
	-- This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.
	-- Hint: You can use join between three tables - "Film", "Inventory", and "Rental" and count the rental ids for each film.
select * 
from sakila.film;
select * 
from sakila.inventory;
select * 
from sakila.rental;

CREATE TEMPORARY TABLE sakila.join_film_inventory as
SELECT f.title, f.film_id, i.inventory_id
FROM sakila.film f
LEFT JOIN sakila.inventory i
  ON f.film_id = i.film_id;

select * from sakila.join_film_inventory;

CREATE TEMPORARY TABLE sakila.film_inventory_rental as
SELECT fi.title, fi.film_id, fi.inventory_id, r.rental_id
FROM sakila.rental r
LEFT JOIN sakila.join_film_inventory fi
  ON r.inventory_id= fi.inventory_id;
  
select * from sakila.film_inventory_rental;

select title, film_id, count(rental_id) as 'number of rentals'
from sakila.film_inventory_rental
group by 1,2
order by 3 desc;

