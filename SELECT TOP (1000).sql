-- USE MyDatabase
-- SELECT TOP 2
--     *
-- -- AVG(score) AS average_score
-- FROM orders
-- ORDER BY order_date DESC;
-- -- WHERE country = 'Germany'
-- -- WHERE score != 0
-- -- GROUP BY country
-- -- HAVING AVG(score) > 430

-- SELECT *
-- FROM customers

-- CREATE TABLE persons
-- (
--     id INT NOT NULL,
--     person_name VARCHAR(50) NOT NULL,
--     birth_date DATE ,
--     phone VARCHAR(20) NOT NULL,
--     CONSTRAINT pK_persons PRIMARY KEY (id) 
-- )

-- ALTER TABLE persons
-- ADD email VARCHAR(50)
-- NOT

-- DROP TABLE persons

-- SELECT *
-- FROM persons

-- SELECT *
-- FROM customers
--     CROSS join orders
-- on customers.id = orders.customer_id
-- WHERE orders.customer_id IS NULL OR customers.id IS NULL

use SalesDB

-- SELECT *
-- FROM Sales.Employees

-- SELECT
--     o.OrderID AS order_id,
--     c.FirstName AS customer_name,
--     p.Product AS product_name,
--     o.Sales AS sales_amount,
--     p.Price AS product_price,
--     e.FirstName AS salesperson_name
-- FROM Sales.Orders AS o
--     LEFT JOIN Sales.Customers AS c
--     ON o.customerid = c.CustomerID
--     LEFT JOIN Sales.Products AS p
--     ON o.productid = p.ProductID
--     LEFT JOIN Sales.Employees AS e
--     ON o.salespersonid = e.EmployeeID

-- SELECT
--     LEN(firstname) - LEN(TRIM(firstname))  flag
-- FROM Sales.Customers
-- WHERE LEN(firstname) - LEN(TRIM(firstname)) > 0


-- SELECT DATEPART(WEEKDAY, OrderDate)
-- FROM Sales.Orders
-- where MONTH(OrderDate) = 2

-- SELECT OrderId, CreationTime,
--     'Day' + FORMAT(CreationTime, ' ddd MMM ') + ' Q ' + DATENAME(QUARTER, CreationTime) + ' ' + FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS formatted_date
-- FROM Sales.Orders

-- SELECT category, sum(Sales) AS total_sales
-- FROM (
--     SELECT orderID, Sales,
--         CASE WHEN Sales > 50 THEN 'High'
--              WHEN Sales > 20 THEN 'Medium'
--              ELSE 'Low'
--         END AS Category
--     FROM Sales.Orders
-- ) t
-- GROUP BY category
-- ORDER BY total_sales DESC

-- SELECT orderID, Sales,
-- case when Sales > 30 then 1
--      else 0
-- end as is_high_sales
-- FROM Sales.Orders

-- SELECT CustomerID, COUNT(sales_category) AS total_orders
-- FROM(
-- SELECT C.CustomerID, C.FirstName, o.OrderID, o.Sales,
--         case when o.Sales > 30 then 1
--      else 0
--      end as sales_category
--     from Sales.Customers as C
--         LEFT JOIN Sales.Orders as o
--         ON C.CustomerID = o.CustomerID ) t
-- WHERE sales_category = 1
-- GROUP BY  CustomerID

-- SELECT MAX(Score) max_score, Country
-- FROM Sales.Customers
-- GROUP BY Country
-- ORDER BY max_score DESC

-- SELECT orderId, orderDate, productId, Sales, orderstatus,
--     SUM(Sales) over() total_sales,
--     SUM(Sales) over (PARTITION BY productId) AS total_sales_over_product,
--     SUM(Sales) over (PARTITION BY productId, orderstatus) AS total_sales_over_product_status
-- FROM Sales.Orders

-- SELECT orderId, orderDate, OrderStatus, Sales, MONTH(orderDate) AS order_month,
--     SUM(Sales) over(PARTITION BY OrderStatus ORDER BY MONTH(orderDate) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_sales
-- FROM Sales.Orders

-- SELECT c.customerID,
--     Rank() over(ORDER BY o.Sales DESC) as sales_rank
-- From Sales.Customers as C
--     LEFT JOIN Sales.Orders as o
--     ON C.CustomerID = o.CustomerID

-- SELECT orderId, productId, (CAST(Sales as FLOAT) / total_sales_over_product) *100 AS sales_percentage
-- From(
-- SELECT orderId, productId, Sales,
--         SUM(Sales) over(PARTITION BY productId ) AS total_sales_over_product
--     FROM Sales.Orders ) t 

-- SELECT orderId, Sales
-- from(
-- SELECT orderId, Sales,
--         AVG(Sales) over() AS average_sales
--     from Sales.Orders ) t
-- WHERE Sales > average_sales

-- SELECT orderId, Sales, productId
-- FROM
--     (SELECT orderId, Sales, productId,
--         ROW_NUMBER() OVER(partition by productId order by sales DESC) AS sales_rank
--     FROM sales.Orders ) t
-- WHERE sales_rank = 1

-- SELECT *
-- from
--     (SELECT customerID,
--         SUM(Sales) as total_sales_per_customer,
--         ROW_NUMBER() OVER(ORDER by SUM(Sales)) as sales_rank
--     from sales.Orders
--     GROUP BY customerID)t
-- WHERE sales_rank <= 2

-- SELECT *, CONCAT(price_cume_dist * 100, '%') AS price_percentile
-- from(
-- SELECT PRODUCT, price ,
--         PERCENT_RANK() OVER (ORDER by price desc) AS price_cume_dist
--     FROM Sales.Products)T
-- where price_cume_dist <= 0.4

-- SELECT CustomerID,
--     AVG(daysuntilnextorder) ,
--     RANK() OVER(ORDER BY AVG(daysuntilnextorder) ) AS avg_rnk
-- from(
-- SELECT orderId, customerId, orderdate currentorder,
--         LEAD(OrderDate) over(partition by customerId ORDER by orderdate) as nextorder,
--         DATEDIFF(day, orderdate, LEAD(OrderDate) over(partition by customerId ORDER by orderdate)) AS daysuntilnextorder
--     from Sales.Orders
-- ) t
-- GROUP BY CustomerID

SELECT orderId, productId, Sales,
    FIRST_VALUE(Sales) over(PARTITION BY productId ORDER BY Sales ) as lowest_sales,
    LAST_VALUE(Sales) over(PARTITION BY productId ORDER BY Sales ROWS BETWEEN current row AND UNBOUNDED FOLLOWING) as highest_sales
from Sales.Orders
