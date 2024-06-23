USE restaurant_db;
# Objective 1: Explore the menu_items table

# 1. View the menu_items table
SELECT *
FROM menu_items;

#2. Find the number of items on the menu
SELECT COUNT(*) as No_of_items
FROM menu_items;

#3. What are the least and most expensive items on the menu?
SELECT item_name, price
FROM
(
SELECT item_name, price, row_number() OVER (ORDER BY price DESC) AS rnk
FROM menu_items
)sub
WHERE rnk IN (1, 32)
;

#4. How many Italian dishes are on the menu?
SELECT COUNT(*) AS no_of_italian_dishes
FROM menu_items
WHERE category = 'Italian'
;

#5. What are the least and most expensive Italian dishes on the menu?
SELECT item_name, price
FROM
(
SELECT item_name, price, row_number() OVER (ORDER BY price DESC) AS rnk
FROM menu_items
WHERE category = 'Italian'
)sub
WHERE rnk IN (1, 9)
;

#6. How many dishes are in each category?
SELECT category, COUNT(*) as no_of_dishes
FROM menu_items
GROUP BY 1
;

#7. What is the average dish price within each category?
SELECT category, ROUND(AVG(price),2) AS avg_price
FROM menu_items
GROUP BY 1
ORDER BY 2 DESC
;
