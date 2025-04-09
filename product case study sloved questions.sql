CREATE DATABASE Products;
use products;
CREATE TABLE Products (
     product_id INT PRIMARY KEY,
     Price DECIMAL(10, 2),
     Product_name VARCHAR(255),
     Category_id INT,
     Segment_id int );
CREATE TABLE Product_Sales (
   prod_id INT,
   qty INT,
   price DECIMAL(10, 2),
   Discount DECIMAL(5, 2),
   member BOOLEAN,
   txn_id INT PRIMARY KEY,
   Start_txn_time TIMESTAMP,
   FOREIGN KEY (prod_id) REFERENCES
   Products(product_id)
   );
  CREATE TABLE Product_Hierarchy (
    price_id INT PRIMARY KEY,
    Parent_id INT,
    level_text VARCHAR(255),
    level_name VARCHAR(255),
    FOREIGN KEY (parent_id) REFERENCES
Product_Hierarchy(price_id)
);
CREATE TABLE Categories (
   category_id INT PRIMARY KEY,
   category_name VARCHAR(255)
);
CREATE TABLE Segments (
    segment_id INT PRIMARY KEY,
    segment_name VARCHAR(255)
);
    
    
#1.What was the total quantity sold for all products?
SELECT SUM(qty) AS total_quantity_sold
FROM Product_Sales;

#2.What is the total generated revenue for all products before discounts?
SELECT SUM(price * qty) AS
total_revenue_before_discount
FROM Product_sales;

#3.What was the total discount amount for all products?
SELECT SUM(discount * qty) AS
total_discount_amount
FROM Product_sales;

#4.How many unique transactions were there?
SELECT COUNT(DISTINCT txn_id) AS
unique_transactions
FROM Product_sales;

#5.What is the average unique products purchased in each transaction?
SELECT AVG(unique_products) AS
avg_uniaue_products_per_transaction
FROM (
    SELECT txn_id, COUNT(DISTINCT 
Prod_id) AS unique_products
   FROM Product_Sales
   GROUP BY txn_id
) AS transaction_summary; 

# 6.What are the 25th, 50th and 75th percentile values for the revenue per transaction? 
SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP     
(ORDER BY price * qty) AS percentile_25,
    PERCENTILE_CONT(0.50) WITHIN GROUP
(ORDER BY price * qty) AS percentile_50,
    PERCENTILE_CONT(0.75) WITHIN GROUP
(ORDER BY price * qty) AS percentile_75
FROM Product_Sales;

#7.What is the average discount value per transaction?
SELECT AVG(discount *  qty) AS
avg_discount_per_transaction
FROM Product_Sales;

#8.What is the percentage split of all transactions for members vs non-members?
SELECT
   SUM(CASE WHEN member = TRUE THEN 1
ELSE 0 END)* 100.0 / COUNT(*) AS
member_percentage,
 SUM(CASE WHEN member = FALSE THEN 1
ELSE 0 END)* 100.0 / COUNT(*) AS
non_member_percentage
FROM Product_Sales;
#9.What is the average revenue for member transactions and non-member transactions?
SELECT
  AVG(CASE WHEN member = True THEN 
Price * qty ELSE NULL END) AS
avg_revenue_member_transaction,
   AVG(CASE WHEN member = FALSE THEN
price * qty ELSE NULL END) AS
avg_revenue_non_member_transactions
FROM Product_Sales;

#10.What are the top 3 products by total revenue before discount?   
    SELECT prod_id,
       SUM(price * qty) AS
total_revenue_before_discount
FROM Product_sales
GROUP BY prod_id
ORDER BY total_revenue_before_discount
DESC
LIMIT 3;
#11.What is the total quantity, revenue and discount for each segment?
SELECT s.segment_id,
       s.segment_name,
       SUM(ps.qty) AS total_quantity,
       SUM(ps.price * ps.qty) AS
total_revenue,
     SUM(ps.discount * ps.qty) AS
total_discount
FROM Product_Sales ps
JOIN Segments s ON ps.prod_id =
s.segment_id
GROUP BY s.segment_id, s.segment_name;
#12.What is the top selling product for each segment?     
WITH Segment_Product_Sales As (
    SELECT
       s.segment_id,
       p.product_id,
       p.product_name,
       SUM(ps.qty) AS
total_quantity_sold
     FROM Product_Sales ps
     JOIN products P ON ps.prod_id =
p.product_id
     JOIN Segments s ON p.segment_id =
s.segment_id
     GROUP BY s.segment_id, p.product_id,
p.product_name
)
SELECT segment_id,
Product_id,
product_name,
total_quantity_sold
FROM Segment_Product_Sales
WHERE (segment_id, total_quantity_sold)
IN (
    SELECT segment_id,
MAX(total_quantity_sold)
    FROM Segment_Product_Sales
    Group BY segment_id
);


    
     



  

