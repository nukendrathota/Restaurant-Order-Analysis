# Restaurant-Order-Analysis
## Introduction
Welcome to an analysis of a fictional restaurant order data analysis.

Curious about the SQL queries used? Check them [here](sql-queries).

## Background
### Dataset
The dataset used for this analysis comes from Maven Analytics. You can access the restaurant dataset [here](dataset).
The dataset contains two tables: The menu_items table, containing the list of menu items. It has 4 columns - menu_item_id, item_name, category and price and 32 rows. The second table, the order_details table, contains 5 columns - order_details_id, order_id, order_date, order_time and item_id and 12234 rows.

Additionally, CSV files generated from SQL queries can be found [here](sql-query-results).

### Project Overview
This project is a simple, basic SQL analysis of two tables on restaurant orders. It aims to uncover insights on the performance of the restaurant, and decide which menu items to include going forward. This project provided me with the opportunity to showcase my SQL skills and also learn MySQL and GitHub.

### Objectives
Through SQL queries, I pursued four objectives and key questions under each objective:

Objective 1: Exploratory Analysis of the Menu Items Table
Key Questions:
1. Number of items on the menu.
2. What are the least and most expensive items on the menu?
3. How many Italian dishes are on the menu?
4. What are the least and most expensive Italian dishes on the menu?
5. How many dishes are in each category?
6. What is the average dish price within each category?

Objective 2: Exploratory Analysis of the Order Details Table
Key Questions:
1. What is the date range of the table?
2. How many orders were made within this date range? What is the average number of orders made per day within this date range?
3. How many items were ordered within this date range?
4. Which orders had the most number of items?
5. How many orders had more than 12 items?

Objective 3: Analysis of Customer Behavior
Key Questions:
1. What were the least and most ordered items? What categories were they in?
2. What were the top 5 orders that spent the most money?
3. View the details of the highest spent order. Which specific items were purchased?
4. View the details of the top 5 highest spent orders.

Objective 4: Revenue Analysis
Key Questions:
1. What is the total revenue?
2. What is the revenue per month?
3. What is the revenue per category?
4. Which is the most revenue generating item on the menu?

#### SQL Queries in Objective 1
#### 1. Number of items on the menu.
To count the number of items on the menu, I used the COUNT function and counted the number of rows in the menu_items table.

```sql

SELECT
      COUNT(*) as No_of_items
FROM
      menu_items
;
```

#### 2. Least and Most Expensive items on the menu.
To identify the least and most expensive items on the menu, I ranked the items on the menu according to their price in descending order using the ROW_NUMBER window function and then filtering for row numbers 1 and 32. 
```sql
SELECT
      item_name,
      price
FROM
      (
        SELECT
              item_name,
              price,
              row_number() OVER (ORDER BY price DESC) AS rnk
        FROM
            menu_items
      )sub
WHERE
      rnk IN (1, 32)
;
```

#### 3. Number of Italian dishes on the menu.
To count the number of Italian dishes on the menu, I filtered the menu_items table for the Italian category, and then counted the number of rows.
```sql
SELECT
      COUNT(*) AS no_of_italian_dishes
FROM
      menu_items
WHERE
      category = 'Italian'
;
```

#### 4. Least and Most Expensive Italian dishes on the menu.
To retrieve the least and most expensive Italian dishes on the menu, I used a subquery to assign a rank to each Italian dish based on its price in descending order. I then filtered the table for ranks 1 and 9 as there are 9 Italian items on the menu.
```sql
SELECT
      item_name,
      price
FROM
    (
      SELECT
            item_name,
            price,
            row_number() OVER (ORDER BY price DESC) AS rnk
      FROM
            menu_items
      WHERE
            category = 'Italian'
    )sub
WHERE
    rnk IN (1, 9)
;
```

#### 5. No of dishes in each category.
To count the number of dishes in each category, I grouped the menu_items table by the category column and then counted the number of items in each group. 
```sql
SELECT
      category,
      COUNT(*) as no_of_dishes
FROM
      menu_items
GROUP BY 1
;
```

#### 6. Average dish price within each category.
To calculate the average price of dishes in each category, rounded to two decimal places, I grouped the menu_items table by the category column and then calculated the average price for each group.
```sql
SELECT
      category,
      ROUND(AVG(price),2) AS avg_price
FROM
      menu_items
GROUP BY 1
ORDER BY 2 DESC
;
```
#### SQL Queries in Objective 2
#### 1. Date Range of the order_details table.
To find the date range of the order_details table, I selected the minimum and maximum values of the order_date column.
```sql
SELECT
      MIN(order_date) as min_date,
      MAX(order_date) as max_date
FROM
      order_details
;
```
#### 2. Total Number of orders and Average Number of orders per day made within this date range.
To count the number of unique orders in the order_details table, I selected the distinct count of the order_id column.
```sql
SELECT
      COUNT(distinct order_id) as no_of_orders,
      ROUND(COUNT(distinct order_id)/90) as avg_no_of_orders
FROM
      order_details
;
```
#### 3. Number of items ordered within this date range.
To count the total number of items ordered, I selected the count of the item_id column.
```sql
SELECT
      COUNT(item_id)
FROM
      order_details
;
```

#### 4. Orders with the most number of items.
To identify orders with the most number of items, I grouped the order_details table by the order_id column, counted the number of items in each group, and then ordered the results by the item count in descending order.
```sql
SELECT
      order_id,
      COUNT(item_id)
FROM
      order_details
GROUP BY 1
ORDER BY 2 DESC
;
```

#### 5. Number of orders with more than 12 items.
```sql
SELECT COUNT(order_id) as num_orders
FROM
    (
      SELECT
            order_id
      FROM
            order_details
      GROUP BY 1
      HAVING
            count(item_id) > 12
    )sub
;
```

#### SQL Queries in Objective 3
#### 1. Least and most ordered items and their categories.
To identify the least and most ordered items and their categories, I joined the order_details table with the menu_items table on the item IDs, grouped the results by item name and category, and then ordered the results by the number of orders in descending order.
```sql
SELECT
      category,
      item_name,
      COUNT(*) AS no_of_orders
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
GROUP BY 2, 1
ORDER BY 3 DESC
;
```
#### 2. Top 5 orders that spent the most money.
To find the top 5 orders that spent the most money, I joined the order_details table with the menu_items table on the item IDs, calculated the sum of the prices for each order, grouped the results by order ID, and then ordered the results by the total order amount in descending order, limiting the output to the top 5 orders.
```sql
SELECT
      order_id,
      SUM(price) AS order_total
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
;
```

#### 3. Details of the highest spent order and the specific items purchased in that order.
Using the output of the previous query, we know that order #440 is the highest spent order. The query joins order_details table with the menu_items table on the item IDs, it then counts the numbers of items in the order per each category, and also calculates the amount spent on each category. The results are sorted in descending order of the amount spent per category.
```sql
SELECT
      category,
      item_name, 
      COUNT(item_id) OVER (partition by category) as num_items_per_category, 
      SUM(price) OVER (partition by category) AS total_spent_per_category
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
WHERE
      order_id = 440
ORDER BY 4 DESC
;
```

#### 4. Details of the top 5 highest spent orders. 
We know from the previous query, the order numbers of the top 5 highest spent orders. Filtering for these 5 orders, the query joins order_details table with the menu_items table on the item IDs, it then counts the numbers of items in the order per each category, and also calculates the amount spent on each category. The results are sorted in descending order of the amount spent per category.
```sql
SELECT category,
       COUNT(item_id) OVER (partition by category) as num_items_per_category, 
       SUM(price) OVER (partition by category) AS total_spent_per_category
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
WHERE
      order_id IN (440, 2075, 1957, 330, 2675)
ORDER BY 3 DESC
;
```
#### SQL Queries in Objective 4
#### 1. Total Revenue earned by the restaurant.
To calculate the total revenue earned by the restaurant, I first joined the order_details and menu_items tables on the item IDs and then I summed up the prices of all the items ordered.
```sql
SELECT
      SUM(price) as total_revenue
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
;
```

#### 2. Revenue earned per month.
To find the revenue earned per month, I first extracted the month of each order from the order_date column using the EXTRACT() function and then summing the price of all items ordered and grouped and ordered the results by the month.
```sql
SELECT
      EXTRACT(month from order_date) as month,
      SUM(price) as revenue_per_month 
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 1 ASC
;
```

#### 3. Revenue earned per category.
To calculate the revenue earned per category, I joined the order_details and menu_items tables on item IDs, and then I summed the prices of all the items ordered, and grouped them by the categories. 
```sql
SELECT
      category,
      SUM(price) AS revenue_per_category
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 2 DESC
;
```

#### 4. Revenue earned per menu item.
To calculate the revenue earned per menu item, I joined the order_details and menu_items tables on item IDs, and then I summed the prices of all the items ordered, and grouped them by the menu items. 

```sql
SELECT
      item_name,
      COUNT(*) AS no_of_orders,
      SUM(price) AS revenue_per_item
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 3 DESC
;
```

#### Insights
1. The restaurant has 32 items in 4 categories, with Italian and Mexican categories having 9 items each, Asian 8 items and American 6 items.
2. Over a period of 3 months, Jan-Mar 2023, the restaurant had 5370 orders or about 60 orders per day. This is a good number of orders per day.
3. While the Hamburger is the single most ordered item, it is not the most revenue generating item. That honour goes to the Korean Beef Bowl, which generated over $10000 in revenue.
4. Although Italian is the most expensive category, with an average dish price of about $16.75, it is still the most ordered category in orders that spent the most money. This indicates that the restaurant is gaining recognition for its Italian dishes in the dine-in segment, while its hamburgers are becoming increasingly popular for takeout orders.

## Closing Thoughts
This project advanced my knowledge of how MySQL works. It also showed me how results from multiple SQL queries can be clubbed together to derive unique insights. Also, this project is my first SQL project on GitHub. I've learnt how to upload project onto GitHub, and hopefully I will be able to put more SQL projects here and build a SQL portfolio. 
