# Restaurant Order SQL Analysis
## Introduction
The Taste of the World Cafe is a fictional restaurant that has diverse menu offerings and serves generous portions. It debuted a new menu at the start of 2023. As their data analyst, I have been asked to dig into the customer data to see which menu items are doing well/not well and what the top customers seem to like best.

Curious about the SQL queries used? Check them [here](sql-queries).

## Background
### Dataset
The dataset used for this analysis comes from Maven Analytics. You can access the restaurant dataset [here](dataset).
The dataset contains two tables: The menu_items table, containing the list of menu items. It has 4 columns - menu_item_id, item_name, category and price and 32 rows. The second table, the order_details table, contains 5 columns - order_details_id, order_id, order_date, order_time and item_id and 12234 rows.

Additionally, CSV files generated from SQL queries can be found [here](sql-query-results).

### Table Preview
Here's a preview of the menu_items and order_details tables limited to their first 5 rows.

#### Menu Items Table
| menu_item_id | item_name      | category | price |
|--------------|----------------|----------|-------|
| 101          | Hamburger      | American | 12.95 |
| 102          | Cheeseburger   | American | 13.95 |
| 103          | Hot Dog        | American | 9.00  |
| 104          | Veggie Burger  | American | 10.50 |
| 105          | Mac & Cheese   | American | 7.00  |

#### Order Details Table
| order_details_id | order_id | order_date | order_time | item_id |
|------------------|----------|------------|------------|---------|
| 1                | 1        | 2023-01-01 | 11:38:36   | 109     |
| 2                | 2        | 2023-01-01 | 11:57:40   | 108     |
| 3                | 2        | 2023-01-01 | 11:57:40   | 124     |
| 4                | 2        | 2023-01-01 | 11:57:40   | 117     |
| 5                | 2        | 2023-01-01 | 11:57:40   | 129     |

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
2. What were the total number of orders for each category?
3. What were the top 5 orders that spent the most money?
4. View the details of the highest spent order. Which specific items were purchased?
5. View the details of the top 5 highest spent orders.

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
Here's the output:
| No_of_items |
|-------------|
| 32          |
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
| item_name    | price |
|--------------|-------|
| Shrimp Scampi| 19.95 |
| Edamame      | 5.00  |
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
| no_of_italian_dishes |
|----------------------|
| 9                    |
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
| item_name           | price |
|---------------------|-------|
| Shrimp Scampi       | 19.95 |
| Fettuccine Alfredo  | 14.50 |
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
| category | no_of_dishes |
|----------|--------------|
| American | 6            |
| Asian    | 8            |
| Mexican  | 9            |
| Italian  | 9            |
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
| category | avg_price |
|----------|-----------|
| Italian  | 16.75     |
| Asian    | 13.48     |
| Mexican  | 11.80     |
| American | 10.07     |

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
| min_date   | max_date   |
|------------|------------|
| 2023-01-01 | 2023-03-31 |
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
| no_of_orders | avg_no_of_orders |
|--------------|------------------|
| 5370         | 60               |
#### 3. Number of items ordered within this date range.
To count the total number of items ordered, I selected the count of the item_id column.
```sql
SELECT
      COUNT(item_id)
FROM
      order_details
;
```
| COUNT(item_id) |
|----------------|
| 12097          |
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
LIMIT 10
;
```
| order_id | COUNT(item_id) |
|----------|----------------|
| 2675     | 14             |
| 443      | 14             |
| 1957     | 14             |
| 3473     | 14             |
| 330      | 14             |
| 440      | 14             |
| 4305     | 14             |
| 1274     | 13             |
| 2126     | 13             |
| 1734     | 13             |

#### 5. Number of orders with more than 12 items.
To count the number of orders where more than 12 items were ordered, I first grouped the order_details table by order_id and filtered out groups with a count of item_id greater than 12. I then counted the remaining orders.
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
| num_orders |
|------------|
| 20         |
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
| category  | item_name             | no_of_orders |
|-----------|-----------------------|--------------|
| American  | Hamburger             | 622          |
| Asian     | Edamame               | 620          |
| Asian     | Korean Beef Bowl      | 588          |
| American  | Cheeseburger          | 583          |
| American  | French Fries          | 571          |
| Asian     | Tofu Pad Thai         | 562          |
| Mexican   | Steak Torta           | 489          |
| Italian   | Spaghetti & Meatballs | 470          |
| American  | Mac & Cheese          | 463          |
| Mexican   | Chips & Salsa         | 461          |
| Asian     | Orange Chicken        | 456          |
| Mexican   | Chicken Burrito       | 455          |
| Italian   | Eggplant Parmesan     | 420          |
| Mexican   | Chicken Torta         | 379          |
| Italian   | Spaghetti             | 367          |
| Italian   | Chicken Parmesan      | 364          |
| Asian     | Pork Ramen            | 360          |
| Italian   | Mushroom Ravioli      | 359          |
| Asian     | California Roll       | 355          |
| Mexican   | Steak Burrito         | 354          |
| Asian     | Salmon Roll           | 324          |
| Italian   | Meat Lasagna          | 273          |
| American  | Hot Dog               | 257          |
| Italian   | Fettuccine Alfredo    | 249          |
| Italian   | Shrimp Scampi         | 239          |
| American  | Veggie Burger         | 238          |
| Mexican   | Chips & Guacamole     | 237          |
| Mexican   | Cheese Quesadillas    | 233          |
| Mexican   | Steak Tacos           | 214          |
| Italian   | Cheese Lasagna        | 207          |
| Asian     | Potstickers           | 205          |
| NULL      | NULL                  | 137          |
| Mexican   | Chicken Tacos         | 123          |

#### 2. Total orders for each category.
To determine the number of orders for each menu item category, I performed a join between the order_details and menu_items tables using item IDs. Using the COUNT(*) function, I aggregated the orders for each category and sorted the results in descending order based on the order count.
```sql
SELECT
      category,
      COUNT(*) AS no_of_orders
FROM
      order_details O
LEFT JOIN
      menu_items M ON O.item_id = M.menu_item_id
GROUP BY 1
ORDER BY 2 DESC
;
```
| category  | no_of_orders |
|-----------|--------------|
| Asian     | 3470         |
| Italian   | 2948         |
| Mexican   | 2945         |
| American  | 2734         |
| NULL      | 137          |

#### 3. Top 5 orders that spent the most money.
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
| order_id | order_total |
|----------|-------------|
| 440      | 192.15      |
| 2075     | 191.05      |
| 1957     | 190.10      |
| 330      | 189.70      |
| 2675     | 185.10      |

#### 4. Details of the highest spent order and the specific items purchased in that order.
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
| category | item_name             | num_items_per_category | total_spent_per_category |
|----------|-----------------------|------------------------|--------------------------|
| Italian  | Spaghetti             | 8                      | 132.25                   |
| Italian  | Spaghetti & Meatballs | 8                      | 132.25                   |
| Italian  | Spaghetti & Meatballs | 8                      | 132.25                   |
| Italian  | Fettuccine Alfredo    | 8                      | 132.25                   |
| Italian  | Fettuccine Alfredo    | 8                      | 132.25                   |
| Italian  | Meat Lasagna          | 8                      | 132.25                   |
| Italian  | Chicken Parmesan      | 8                      | 132.25                   |
| Italian  | Eggplant Parmesan     | 8                      | 132.25                   |
| Asian    | Korean Beef Bowl      | 2                      | 22.95                    |
| Asian    | Edamame               | 2                      | 22.95                    |
| Mexican  | Steak Tacos           | 2                      | 20.95                    |
| Mexican  | Chips & Salsa         | 2                      | 20.95                    |
| American | Hot Dog               | 2                      | 16.00                    |
| American | French Fries          | 2                      | 16.00                    |

#### 5. Details of the top 5 highest spent orders. 
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
| category  | num_items_per_category | total_spent_per_category |
|-----------|------------------------|--------------------------|
| Italian   | 26                     | 430.65                   |
| Asian     | 17                     | 228.65                   |
| Mexican   | 16                     | 189.45                   |
| American  | 10                     | 99.35                    |

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
| total_revenue |
|---------------|
| 159217.90     |

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
| month | revenue_per_month |
|-------|-------------------|
| 1     | 53816.95          |
| 2     | 50790.35          |
| 3     | 54610.60          |
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
| category  | revenue_per_category |
|-----------|----------------------|
| Italian   | 49462.70             |
| Asian     | 46720.65             |
| Mexican   | 34796.80             |
| American  | 28237.75             |
| NULL      | NULL                 |
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
| item_name             | no_of_orders | revenue_per_item |
|-----------------------|--------------|------------------|
| Korean Beef Bowl      | 588          | 10554.60         |
| Spaghetti & Meatballs | 470          | 8436.50          |
| Tofu Pad Thai         | 562          | 8149.00          |
| Cheeseburger          | 583          | 8132.85          |
| Hamburger             | 622          | 8054.90          |
| Orange Chicken        | 456          | 7524.00          |
| Eggplant Parmesan     | 420          | 7119.00          |
| Steak Torta           | 489          | 6821.55          |
| Chicken Parmesan      | 364          | 6533.80          |
| Pork Ramen            | 360          | 6462.00          |
| Chicken Burrito       | 455          | 5892.25          |
| Mushroom Ravioli      | 359          | 5564.50          |
| Spaghetti             | 367          | 5321.50          |
| Steak Burrito         | 354          | 5292.30          |
| Meat Lasagna          | 273          | 4900.35          |
| Salmon Roll           | 324          | 4843.80          |
| Shrimp Scampi         | 239          | 4768.05          |
| Chicken Torta         | 379          | 4529.05          |
| California Roll       | 355          | 4242.25          |
| French Fries          | 571          | 3997.00          |
| Fettuccine Alfredo    | 249          | 3610.50          |
| Mac & Cheese          | 463          | 3241.00          |
| Chips & Salsa         | 461          | 3227.00          |
| Cheese Lasagna        | 207          | 3208.50          |
| Edamame               | 620          | 3100.00          |
| Steak Tacos           | 214          | 2985.30          |
| Veggie Burger         | 238          | 2499.00          |
| Cheese Quesadillas    | 233          | 2446.50          |
| Hot Dog               | 257          | 2313.00          |
| Chips & Guacamole     | 237          | 2133.00          |
| Potstickers           | 205          | 1845.00          |
| Chicken Tacos         | 123          | 1469.85          |
| NULL                  | 137          | NULL             |

#### Insights
1. The restaurant has 32 items in 4 categories, with Italian and Mexican categories having 9 items each, Asian 8 items and American 6 items.
2. Over a period of 3 months, Jan-Mar 2023, the restaurant had 5370 orders or about 60 orders per day and earned a revenue of over $150,000.
3. While the Hamburger is the single most ordered item, it is not the most revenue generating item. That honour goes to the Korean Beef Bowl, which generated over $10000 in revenue.
4. Although Italian is the most expensive category, with an average dish price of about $16.75, it is still the most ordered category in orders that spent the most money. This indicates that the restaurant is gaining recognition for its Italian dishes in the dine-in segment, while its hamburgers are becoming increasingly popular for takeout orders.

## Closing Thoughts
This project advanced my knowledge of how MySQL works. It also showed me how results from multiple SQL queries can be clubbed together to derive unique insights. Also, this project is my first SQL project on GitHub. I've learnt how to upload project onto GitHub, and hopefully I will be able to put more SQL projects here and build a SQL portfolio. 
