USE restaurant_db;

#Objective 4: Revenue Analysis

#1. What is the total revenue?
SELECT SUM(price) as total_revenue
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id;

#2. What is the revenue per month?
SELECT EXTRACT(month from order_date) as month, SUM(price) as revenue_per_month 
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 1 ASC;

#3. What is the revenue per category?
SELECT category, SUM(price) AS revenue_per_category
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 2 DESC
;

#4. Which is the most revenue generating item on the menu?
SELECT item_name, COUNT(*) AS no_of_orders, SUM(price) AS revenue_per_item
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 3 DESC
;