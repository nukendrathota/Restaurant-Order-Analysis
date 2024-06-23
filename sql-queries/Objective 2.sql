USE restaurant_db;
# Objective 2: Explore the order_details table
#1. View the order_details table.
SELECT *
FROM order_details
;

#2. What is the date range of the table?
SELECT MIN(order_date) as min_date, MAX(order_date) as max_date
FROM order_details
;

#3. How many orders were made within this date range?
SELECT COUNT(distinct order_id) as no_of_orders, ROUND(COUNT(distinct order_id)/90) as avg_no_of_orders
FROM order_details
;

#4. How many items were ordered within this date range?
SELECT COUNT(item_id)
FROM order_details
;

#5. Which orders had the most number of items?
SELECT order_id, COUNT(item_id)
FROM order_details
GROUP BY 1
ORDER BY 2 DESC
;

#6. How many orders had more than 12 items?
SELECT COUNT(order_id) as num_orders
FROM
(
SELECT order_id
FROM order_details
GROUP BY 1
HAVING count(item_id) > 12
)sub
;