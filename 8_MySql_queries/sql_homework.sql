use sakila;
#1a - get first name and last name from actor
	select first_name , last_name from actor;
    
#1b - get first name and last name in 
	select upper(concat(first_name,' ' ,last_name)) as 'Actor Name'from actor;

#2a You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
	select actor_id , first_name, last_name from actor
	where upper(first_name) = 'JOE';
    
#2b - Find all actors whose last name contain the letters `GEN`
	select actor_id , first_name, last_name from actor
	where upper(last_name) like '%GEN%';
    
#2C Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
	select actor_id , first_name, last_name from actor
	where upper(last_name) like '%LI%'
	ORDER BY last_name ,first_name;
    
#2d Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
	select country_id , country from country where country in ('China' ,'Bangladesh' ,'Afghanistan');

#3a  create a column in the table `actor` named `description` and use the data type `BLOB` 
	ALTER TABLE  actor
	ADD COLUMN description BLOB NULL AFTER last_update;
    
#3b Delete the `description` column.
	ALTER TABLE actor 
	drop column description;
    
#4a List the last names of actors, as well as how many actors have that last name.
	select last_name, count(last_name) as 'count' from actor group by last_name;
    
#4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
	select last_name , count(last_name) as 'count'  from actor group by last_name having count >=2;
    
#4c The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
	update actor set first_name = 'HARPO' 
    where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
    
#4D if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
	update actor set first_name = 'GROUCHO' where first_name = 'HARPO' and last_name = 'WILLIAMS';
    
#5a You cannot locate the schema of the `address` table. Which query would you use to re-create it?
	show create table address;

#6a Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
	select s.first_name , s.last_name, ad.address , ad.city_id , ad.postal_code, ad.district
    from staff s join address ad on s.address_id =  ad.address_id;
    
#6b Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
	select sum(p.amount) as amount , first_name , last_name  from staff s ,payment p 
    where s.staff_id = p.staff_id  and payment_date  BETWEEN "2005-08-01" AND "2005-08-31"
    group by last_name , first_name;
    
#6c List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join
	select f.title, count(fa.actor_id) as 'actors count'  from film f , film_actor fa where f.film_id = fa.film_id 
    group by f.title;
     
#6d How many copies of the film `Hunchback Impossible` exist in the inventory system?
	select count( i.inventory_id) as 'copies', f.title from film f, inventory i  
	where f.film_id = i.film_id  and f.title = upper('Hunchback Impossible');

#6e Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name
	select  c.first_name, c.last_name, sum(p.amount) as 'Total Amount Paid' from customer c , payment p where c.customer_id = p.customer_id group by c.customer_id 
	order by c.last_name ;

#7a Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
	select f.title ,f.language_id  
	from film f
	where (f.title like  'K%' or    f.title like 'Q%' ) and language_id = (select language_id from language where name = 'English');

#7b Use subqueries to display all actors who appear in the film `Alone Trip`.
	select first_name , last_name from actor where actor_id in ( select actor_id from film_actor fa , film f 
    where fa.film_id = f.film_id and f.title = upper('Alone Trip'));

#7c You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
	use sakila;
	select cu.first_name , cu.last_name , ce.email from customer cu, customer_email ce , address ad , city ci, country co
    where cu.customer_id = ce.customer_id  and cu.address_id  = ad.address_id 
    and ad.city_id = ci.city_id and ci.country_id = co.country_id and co.country = 'Canada' ;
    
#7d Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
	select f.title from film f, film_category fc , category ca where f.film_id = fc.film_id and fc.category_id = ca.category_id and ca.name = 'Family';
    
#7e Display the most frequently rented movies in descending order.
	select count(r.inventory_id) as count, f.title from rental r , inventory i , film f 
    where r.inventory_id = i.inventory_id  and i.film_id = f.film_id 
    group by r.inventory_id order by count desc ;
    
#7f Write a query to display how much business, in dollars, each store brought in.
	SELECT concat( "$" ,format(sum(p.amount),2)) as sales, ci.city as city FROM sakila.rental r , sakila.payment p , sakila.address a , sakila.store s , sakila.inventory i , sakila.city ci
	where  p.rental_id = r.rental_id   and  r.inventory_id = i.inventory_id and i.store_id = s.store_id 
	and s.address_id = a.address_id and a.city_id = ci.city_id 
	group by s.store_id;

#7g  Write a query to display for each store its store ID, city, and country.
	select s.store_id , c.city, co.country from store s , address a , city c , country co 
    where s.address_id = a.address_id and a.city_id = c.city_id and  c.country_id = co.country_id;

#7h  List the top five genres in gross revenue in descending order
	SELECT sum(p.amount) as sales, c.name
	FROM sakila.rental r , sakila.payment p ,sakila.category c, sakila.inventory i , film_category fc ,film f
	where  p.rental_id = r.rental_id   
	and  r.inventory_id = i.inventory_id 
	and i.film_id = f.film_id 
	and f.film_id = fc.film_id 
	and fc.category_id = c.category_id 
	group by c.name
	order by sales desc 
	LIMIT 5;

#8a  create a view.
	CREATE VIEW Top_five_film_genre  AS
	SELECT sum(p.amount) as sales, c.name
	FROM sakila.rental r , sakila.payment p ,sakila.category c, sakila.inventory i , film_category fc ,film f
	where  p.rental_id = r.rental_id   
	and  r.inventory_id = i.inventory_id 
	and i.film_id = f.film_id 
	and f.film_id = fc.film_id 
	and fc.category_id = c.category_id 
	group by c.name
	order by sales desc 
	LIMIT 5;

#8b  How would you display the view that you created in 8a?
	select * from Top_five_film_genre ;
    
#8c Write a query to delete it.
	DROP VIEW Top_five_film_genre;
 
 