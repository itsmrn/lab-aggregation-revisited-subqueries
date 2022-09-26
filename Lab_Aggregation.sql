-- DONE: LAB Aggreagation revisited subqueries


-- Select the first name, last name, and email address of all the customers who have rented a movie.

select * from customer;
select * from rental;

select distinct(c.first_name), c.last_name, c.email from customer c
join rental r using(customer_id);

-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

select * from payment;
select * from customer;

select concat(c.first_name, " ", c.last_name) customer_name, round(avg(p.amount),2) average_payment, p.customer_id from payment p
left join customer c using(customer_id)
group by customer_id;


-- Select the name and email address of all the customers who have rented the "Action" movies.
-- a) Write the query using multiple join statements

create or replace view customers_action_a as
	select concat(c.first_name, " ", c.last_name) customer_name, email from customer c
	join rental r using (customer_id)
    join inventory i using (inventory_id)
	join film_category fc using (film_id)
    join category ca using (category_id)
    where name = "Action";
    
select * from customers_action_a;

-- b) Write the query using sub queries with multiple WHERE clause and IN condition

create or replace view customers_action_b as
select (concat(first_name, " ", last_name)) customer_name, email from customer c
where customer_id in (
	select customer_id
    from rental
    where inventory_id in (
		select inventory_id
        from inventory
        where film_id in (
			select film_id
            from film_category
            where category_id in (
				select category_id
                from category ca
                where name = "Action"))));

select * from customers_action_b;

-- c) Verify if the above two queries produce the same results or not

select * from customers_action_a ca
join customers_action_b cb
using (email)
where cb.email != ca.email;

-- Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, 
-- and if it is more than 4, then it should be high.

select *,
(case
when amount > 4 then "High"
when amount between 2 and 4 then "Medium"
else "Low"
end) as "payment_classifer"
from payment;