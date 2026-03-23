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


SELECT DATEPART(WEEKDAY, OrderDate)
FROM Sales.Orders
-- where MONTH(OrderDate) = 2