USE restaurant_db;

#Objective 3: Analyze customer behavior

#1. Combine the menu_items and the order_details tables into a single table.
SELECT order_details_id, order_id, order_date, order_time, O.item_id, item_name, category, price
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
;

#2. What were the number of orders for each category?
SELECT category, COUNT(*) AS no_of_orders
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 2 DESC
;

#3. What were the least and most ordered items? What categories were they in?
SELECT category, item_name, COUNT(*) AS no_of_orders
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
GROUP BY 2, 1
ORDER BY 3 DESC
;  

#4. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) AS order_total
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

#5. View the details of the highest spend order. Which specific items were purchased?
SELECT category, 
	   item_name, 
       COUNT(item_id) OVER (partition by category) as num_items_per_category, 
       SUM(price) OVER (partition by category) AS total_spent_per_category
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
WHERE order_id = 440
ORDER BY 4 DESC
;

#6. View the details of the top 5 highest spend orders.
SELECT distinct category,   
       COUNT(item_id) OVER (partition by category) as num_items_per_category, 
       SUM(price) OVER (partition by category) AS total_spent_per_category
FROM order_details O
LEFT JOIN menu_items M ON O.item_id = M.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
ORDER BY 3 DESC
;