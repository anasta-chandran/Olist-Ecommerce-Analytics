CREATE DATABASE ECOMMERCE_ANALYTICS_PROJECT;
USE ECOMMERCE_ANALYTICS_PROJECT;

# KPI 1
# Weekday vs Weekend Payment Statistics

SELECT
    CONCAT(ROUND(COUNT(CASE WHEN Data_type = 'Weekday' THEN 1 END) * 100 / COUNT(*), 0), '%') AS Weekday_Percent,
    CONCAT(ROUND(COUNT(CASE WHEN Data_type = 'Weekend' THEN 1 END) * 100 / COUNT(*), 0), '%') AS Weekend_Percent
FROM orders;
    
#KPI 2
# Count of Orders with Review Score 5 and Payment Type as Credit Card

SELECT p.payment_type, CONCAT(ROUND(COUNT(*)/1000,1),'K') AS no_of_orders
FROM orders_reviews r INNER JOIN orders_payments p ON p.order_id=r.order_id
WHERE r.review_score=5 
GROUP BY p.payment_type;

# KPI 3
#  Average Delivery Time for Pet Shop Products

SELECT
    ROUND(AVG(
        DATEDIFF(
            STR_TO_DATE(o.order_delivered_customer_date, '%d-%m-%Y'),
            STR_TO_DATE(o.order_purchase_timestamp, '%d-%m-%Y')
        )
    ), 2) AS Average_Delivery_Days
FROM orders o
JOIN orders_item oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_cat_clean = 'pet_shop';

# KPI 4
# Average Order Price and Payment Amount for Customers in São Paulo
SELECT
    ROUND(AVG(i.price), 2) AS Average_Order_Price,
    ROUND(AVG(p.payment_value), 2) AS Average_Payment_Amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN orders_item i
ON o.order_id = i.order_id
JOIN orders_payments p
ON o.order_id = p.order_id
WHERE c.customer_city = 'sao paulo';

# KPI 5 
# Relationship Between Shipping Days and Review Scores

SELECT
    r.review_score,
    ROUND(AVG(
        DATEDIFF(
            STR_TO_DATE(o.order_delivered_customer_date, '%d-%m-%Y'),
            STR_TO_DATE(o.order_purchase_timestamp, '%d-%m-%Y')
        )
    ), 2) AS Average_Shipping_Days
FROM orders o
JOIN orders_reviews r
ON o.order_id = r.order_id
GROUP BY r.review_score
ORDER BY r.review_score;

# KPI 6 
# Which Product Categories Generate the Highest Total Sales?

SELECT
    p.product_cat_clean AS Product_Category,
    ROUND(SUM(oi.price), 2) AS Total_Sales
FROM orders_item oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_cat_clean
ORDER BY Total_Sales DESC
LIMIT 10;

# KPI 7  
# Which Payment Type Is Used Most Frequently?

SELECT
    payment_type,
    COUNT(*) AS Total_Uses
FROM orders_payments
GROUP BY payment_type
ORDER BY Total_Uses DESC
LIMIT 1;

# KPI 8 
# What Is the Average Order Value by Customer State?

SELECT
    c.customer_state AS Customer_State,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS Average_Order_Value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN orders_payments p
ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY Average_Order_Value DESC;

# KPI 9 
# Which Seller States Have the Highest Number of Orders?

SELECT
    s.seller_state AS Seller_State,
    COUNT(DISTINCT oi.order_id) AS Total_Orders
FROM sellers s
JOIN orders_item oi
ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY Total_Orders DESC;

# KPI 10
# How Does the Number of Orders Change Month-over-Month?

SELECT
    DATE_FORMAT(
        STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y'),
        '%Y-%m'
    ) AS Order_Month,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM orders
GROUP BY
    DATE_FORMAT(
        STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y'),
        '%Y-%m'
    )
ORDER BY Order_Month;

# KPI 11
# Total Orders

SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM orders;

# kPI 12
# Total Customers

SELECT COUNT(DISTINCT customer_id) AS Total_Customers
FROM customers;

# KPI 13
# Avg Delivery Days

SELECT
    ROUND(AVG(
        DATEDIFF(
            STR_TO_DATE(order_delivered_customer_date, '%d-%m-%Y'),
            STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y')
        )
    ), 2) AS Average_Delivery_Days
FROM orders;

# kPI 14
# Total Revenue

SELECT ROUND(SUM(payment_value), 2) AS Total_Revenue
FROM orders_payments;

# KPI 15 
# Total Price

SELECT ROUND(SUM(price), 2) AS Total_Price
FROM orders_item;

