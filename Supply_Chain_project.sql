-- Adding foreign key constraints in MySQL is crucial for maintaining data 
-- integrity and enforcing relationships between tables. Foreign keys 
-- ensure that a column value in one table matches a primary key value in another table. 
-- This is essential for performing joins and maintaining referential integrity across related tables.

-- So let's first change the format of our columns, then We implant others.

ALTER TABLE customers
    MODIFY COLUMN `Customer Id` INT AUTO_INCREMENT PRIMARY KEY,
    MODIFY COLUMN `Customer Fname` VARCHAR(50),
    MODIFY COLUMN `Customer Lname` VARCHAR(50),
    MODIFY COLUMN `Customer Email` VARCHAR(100),
    MODIFY COLUMN `Customer Segment` VARCHAR(50),
    MODIFY COLUMN `Customer City` VARCHAR(50),
    MODIFY COLUMN `Customer State` VARCHAR(50),
    MODIFY COLUMN `Customer Country` VARCHAR(50),
    MODIFY COLUMN `Customer Street` VARCHAR(100),
    MODIFY COLUMN `Customer Zipcode` VARCHAR(20),
    MODIFY COLUMN `Latitude` DECIMAL(10, 8),
    MODIFY COLUMN `Longitude` DECIMAL(11, 8);



ALTER TABLE orders
    MODIFY COLUMN `Order Id` INT AUTO_INCREMENT PRIMARY KEY,
    MODIFY COLUMN `Order Customer Id` INT,
    MODIFY COLUMN `order date (DateOrders)` DATETIME,
    MODIFY COLUMN `Order Region` VARCHAR(50),
    MODIFY COLUMN `Order City` VARCHAR(50),
    MODIFY COLUMN `Order State` VARCHAR(50),
    MODIFY COLUMN `Order Country` VARCHAR(50),
    MODIFY COLUMN `Order Zipcode` VARCHAR(20),
    MODIFY COLUMN `Order Status` VARCHAR(50),
    MODIFY COLUMN `Shipping Mode` VARCHAR(50),
    MODIFY COLUMN `Days for shipping (real)` INT,
    MODIFY COLUMN `Days for shipment (scheduled)` INT,
    MODIFY COLUMN `Late_delivery_risk` INT,
    MODIFY COLUMN `shipping date (DateOrders)` DATETIME;
    

ALTER TABLE sales -- here I add another column, which can be unique ID for sale
	ADD COLUMN `Sales Id` INT AUTO_INCREMENT PRIMARY KEY FIRST;
ALTER TABLE sales
    MODIFY COLUMN `Order Id` INT,
    MODIFY COLUMN `Order Item Id` INT,
    MODIFY COLUMN `Order Item Cardprod Id` INT,
    MODIFY COLUMN `Product Card Id` INT,
    MODIFY COLUMN `Product Category Id` INT,
    MODIFY COLUMN `Product Name` VARCHAR(100),
    MODIFY COLUMN `Product Price` DECIMAL(10, 2),
    MODIFY COLUMN `Order Item Quantity` INT,
    MODIFY COLUMN `Sales per customer` DECIMAL(10, 2),
    MODIFY COLUMN `Order Item Product Price` DECIMAL(10, 2),
    MODIFY COLUMN `Order Item Total` DECIMAL(10, 2),
    MODIFY COLUMN `Order Item Discount` DECIMAL(5, 2),
    MODIFY COLUMN `Order Item Discount Rate` DECIMAL(5, 2),
    MODIFY COLUMN `Order Item Profit Ratio` DECIMAL(5, 2),
    MODIFY COLUMN `Order Profit Per Order` DECIMAL(10, 2);
    
    
ALTER TABLE products
    MODIFY COLUMN `Product Card Id` INT PRIMARY KEY,
    MODIFY COLUMN `Category Id` INT,
    MODIFY COLUMN `Category Name` VARCHAR(50),
    MODIFY COLUMN `Product Image` VARCHAR(100);
    


-- Add foreign key constraint in Orders table referencing Customers table
ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customers
    FOREIGN KEY (`Order Customer Id`) 
    REFERENCES customers(`Customer Id`)
    ON DELETE CASCADE;  


-- Add foreign key constraint in Sales table referencing Products table
ALTER TABLE sales
    ADD CONSTRAINT fk_sales_products
    FOREIGN KEY (`Product Card Id`) 
    REFERENCES products(`Product Card Id`)
    ON DELETE CASCADE;
    
--
ALTER TABLE sales
    ADD CONSTRAINT fk_sales_orders
    FOREIGN KEY (`Order Id`) 
    REFERENCES orders(`Order Id`)
    ON DELETE CASCADE;
    
select * from sales
-- I just want to be sure there is no null order id.

SELECT *
FROM sales
WHERE `Order Id` IS NULL;

select * from products
select * from orders
select * from customers

/*
Question:
List the top 3 customers who have ordered products with 'Premium' in the product name the most number of times. Include their full name, total number of orders, and the total amount spent on these products. Assume the category name may have variations like 'Men', 'men', 'MEN', etc., and should be matched using regex.
*/
WITH PremiumOrders AS (
    SELECT
        c.`Customer Id`,
        CONCAT(c.`Customer Fname`, ' ', c.`Customer Lname`) AS Full_Name,
        COUNT(o.`Order Id`) AS Total_Orders,
        SUM(s.`Order Item Total`) AS Total_Spent
    FROM sales s
    JOIN orders o ON s.`Order Id` = o.`Order Id`
    JOIN customers c ON o.`Order Customer Id` = c.`Customer Id`
    JOIN products p ON s.`Product Card Id` = p.`Product Card Id`
    WHERE UPPER(p.`Category Name`) REGEXP 'Men' 
    GROUP BY c.`Customer Id`, Full_Name
),
RankedCustomers AS (
    SELECT
        Full_Name,
        Total_Orders,
        Total_Spent,
        RANK() OVER (ORDER BY Total_Orders DESC) AS Orders_Rank
    FROM PremiumOrders
)
SELECT
    Full_Name,
    Total_Orders,
    Total_Spent
FROM RankedCustomers
WHERE Orders_Rank <= 3;

/*
List the top 5 products that have been ordered the most number of times by customers whose email addresses end with '.com'. Include the product name, total quantity ordered, and the total revenue generated from these orders. Consider variations in the email domain (e.g., '.COM', '.CoM') and use regex to match.
*/
WITH EmailsWithDotCom AS (
    SELECT DISTINCT
        c.`Customer Id`
    FROM customers c
    WHERE UPPER(c.`Customer Fname`) REGEXP 'ma$'  -- Regex to match first names ending with 'ma'
),
OrdersByProduct AS (
    SELECT
        p.`Product Card Id`,
        SUM(s.`Order Item Quantity`) AS Total_Quantity,
        SUM(s.`Order Item Total`) AS Total_Revenue,
        o.`Order Customer Id`
    FROM sales s
    JOIN orders o ON s.`Order Id` = o.`Order Id`
    JOIN products p ON s.`Product Card Id` = p.`Product Card Id`
    JOIN EmailsWithDotCom e ON o.`Order Customer Id` = e.`Customer Id`
    GROUP BY p.`Product Card Id`, o.`Order Customer Id`  -- Group by both Product Card Id and Order Customer Id
),
RankedProducts AS (
    SELECT
        p.`Product Card Id`,
        Total_Quantity,
        Total_Revenue,
        o.`Order Customer Id`,
        RANK() OVER (PARTITION BY o.`Order Customer Id` ORDER BY Total_Quantity DESC) AS Quantity_Rank
    FROM OrdersByProduct op
    JOIN orders o ON op.`Order Customer Id` = o.`Order Customer Id`
    JOIN products p ON op.`Product Card Id` = p.`Product Card Id`
)
SELECT
    r.`Product Card Id`,
    c.`Customer Fname`,
    Total_Quantity,
    Total_Revenue
FROM RankedProducts r
JOIN customers c ON r.`Order Customer Id` = c.`Customer Id`
WHERE Quantity_Rank <= 5;

-- List the top 10 products by total sales quantity across all orders. Include product details
SELECT
    p.`Category Id`,
    p.`Product Price`,
    SUM(s.`Order Item Quantity`) AS Total_Quantity_Sold
FROM sales s
JOIN products p ON s.`Product Card Id` = p.`Product Card Id`
GROUP BY p.`Category Id`, p.`Product Price`
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

-- Write a query to find the top 5 customers who have made the highest total sales amount. Include their full name (Customer Fname, Customer Lname), total sales amount, and rank them based on sales amount.
WITH RankedCustomers AS (
    SELECT 
        `Customer Id`,
        CONCAT(`Customer Fname`, ' ', `Customer Lname`) AS Full_Name,
        SUM(`Order Item Total`) AS Total_Sales,
        ROW_NUMBER() OVER (ORDER BY SUM(`Order Item Total`) DESC) AS Sales_Rank
    FROM sales s
    JOIN orders o ON s.`Order Id` = o.`Order Id`
    JOIN customers c ON o.`Order Customer Id` = c.`Customer Id`
    GROUP BY `Customer Id`, Full_Name
)
SELECT
    Full_Name,
    Total_Sales,
    Sales_Rank
FROM RankedCustomers
WHERE Sales_Rank <= 5;

-- Rank customers based on their average sales per order (Order Item Total). Display customer details (Customer Id, Customer Fname, Customer Lname) and rank them separately within each customer segment (Customer Segment).
WITH RankedCustomers AS (
    SELECT
        `Order Customer Id`,
        CONCAT(`Customer Fname`, ' ', `Customer Lname`) AS Full_Name,
        round(AVG(`Order Item Total`),2) AS Avg_Sales_Per_Order,
        RANK() OVER (PARTITION BY `Customer Segment` ORDER BY AVG(`Order Item Total`) DESC) AS Segment_Rank
    FROM sales s
    JOIN orders o ON s.`Order Id` = o.`Order Id`
    JOIN customers c ON o.`Order Customer Id` = c.`Customer Id`
    GROUP BY `Order Customer Id`, Full_Name
)
SELECT * FROM RankedCustomers;

-- list the top 10 products by total sales quantity across all orders and include product details.
WITH ProductSales AS (
    SELECT
        p.`Product Card Id`,
        p.`Category Id`,
        p.`Category Name`,
        p.`Product Image`,
        SUM(s.`Order Item Quantity`) AS Total_Quantity_Sold
    FROM sales s
    JOIN products p ON s.`Product Card Id` = p.`Product Card Id`
    GROUP BY p.`Product Card Id`, p.`Category Id`, p.`Category Name`, p.`Product Image`
)
SELECT
    `Product Card Id`,
    `Category Id`,
    `Category Name`,
    `Product Image`,
    Total_Quantity_Sold
FROM ProductSales
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;