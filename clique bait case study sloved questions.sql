Create database clique_bait;
use clique_bait; 



CREATE TABLE event_identifier (
   event_id INT PRIMARY KEY
AUTO_INCREMENT,
   event_type VARCHAR(255) NOT NULL,
   event_name VARCHAR(255) NOT NULL
);

CREATE TABLE users (
  user_id INT PRIMARY KEY
AUTO_INCREMENT,
  cookie_id VARCHAR(255) NOT NULL
UNIQUE,
   start_data DATE NOT NULL
);

CREATE TABLE page_hierarchy (
   page_id INT PRIMARY KEY
AUTO_INCREMENT,
   page_name VARCHAR(255) NOT NULL,
   product_category VARCHAR(255) NOT
NULL,
   Product_id INT NOT NULL
);

CREATE TABLE campaign_identifier (
   campaign_id INT PRIMARY KEY
AUTO_INCREMENT,
   products VARCHAR(225) NOT NULL,
   campaign_name VARCHAR(255) NOT NULL,
   start_date DATE NOT NULL,
   end_data DATE NOT NULL
);

CREATE TABLE events (
   visit_id INT PRIMARY KEY
AUTO_INCREMENT,
 cookie_id VARCHAR(255) NOT NULL,
 page_id INT NOT NULL,
 event_type VARCHAR(255) NOT NULL,
 sequence_number INT NOT NULL,
 event_time DATETIME NOT NULL,
 FOREIGN KEY (cookie_id) REFERENCES
users(cookies_id),
  FOREIGN KEY (page_id) REFERENCES
page_hierarchy(page_id)
);



#4. What is the number of events for each event type?  
SELECT event_type, COUNT(*) AS
event_count
FROM events
GROUP BY event_type;

#5.What is the percentage of visits which have a purchase event?
SELECT
  (COUNT(DISTINCT CASE WHEN
e.event_type = 'purchase' THEN
e.visit_id END)* 100.0) /
COUNT(DISTINCT e.visit_id) AS
purchase_percentage
FROM events e;

#6 What is the percentage of visits which view the checkout page but do not have a purchase event?  
SELECT
    (COUNT(DISTINCT CASE
      WHEN p.page-name = 'checkout'
AND
       e.event_type != 'purchase'
 THEN e.visit_id
    END)* 100.0) / COUNT(DISTINCT CASE WHEN p.page_name = 'checkout'
THEN e.visit_id
    END) AS
checkout_no_purchase_PERCENTAGE
  FROM events e   
  JOIN page_hierarchy p ON e.page_id +
p.page_id; 
#7.What are the top 3 pages by number of views?
SELECT 
    ph.page_name, 
    COUNT(e.visit_id) AS page_views
FROM 
    events e
JOIN 
    page_hierarchy ph ON e.page_id = ph.page_id
WHERE 
    e.event_type = 1 -- "Page View"
GROUP BY 
    ph.page_name
ORDER BY 
    page_views DESC
LIMIT 3;
#8.What is the number of views and cart adds for each product category?
SELECT 
    ph.product_category, 
    SUM(CASE WHEN e.event_type = 1 THEN 1 ELSE 0 END) AS page_views,
    SUM(CASE WHEN e.event_type = 2 THEN 1 ELSE 0 END) AS cart_adds
FROM 
    events e
JOIN 
    page_hierarchy ph ON e.page_id = ph.page_id
WHERE 
    ph.product_category IS NOT NULL
GROUP BY 
    ph.product_category
ORDER BY 
    page_views DESC; 
  
   
   
   
  #9.What are the top 3 products by purchases?
  
  SELECT 
    ph.page_name AS product_name,
    COUNT(e.visit_id) AS purchase_count
FROM 
    events e
JOIN 
    page_hierarchy ph ON e.page_id = ph.page_id
WHERE 
    e.event_type = 3 -- "Purchase"
GROUP BY 
    ph.page_name
ORDER BY 
    purchase_count DESC
LIMIT 3;
 #1.How many users are there? 
SELECT COUNT(DISTINCT user_id) AS user_count
FROM users;

#2.How many cookies does each user have on average?

WITH cookie_count AS (
    SELECT 
        user_id,
        COUNT(cookie_id) AS cookie_count
    FROM 
        users
    GROUP BY 
        user_id
)
SELECT 
    ROUND(AVG(cookie_count), 2) AS avg_cookie_count
FROM 
    cookie_count;
    
    # 10.What is the unique number of visits by all users per month?
    
    SELECT 
    EXTRACT(MONTH FROM event_time) AS month,
    COUNT(DISTINCT visit_id) AS unique_visits
FROM 
    events
GROUP BY 
    EXTRACT(MONTH FROM event_time)
ORDER BY 
    month;
    
    
 
 


