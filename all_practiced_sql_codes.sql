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

use SalesDB;

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

-- SELECT orderId, productId, Sales,
--     FIRST_VALUE(Sales) over(PARTITION BY productId ORDER BY Sales ) as lowest_sales,
--     LAST_VALUE(Sales) over(PARTITION BY productId ORDER BY Sales ROWS BETWEEN current row AND UNBOUNDED FOLLOWING) as highest_sales
-- from Sales.Orders

-- SELECT customerID, total_sales,
--     RANK() over(ORDER by total_sales )
-- FROM
--     (
-- SELECT customerID,
--         SUM(Sales) as total_sales
--     FROM Sales.Orders
--     GROUP BY CustomerID) t

-- SELECT productId, Product, Price,
--     (select COUNT(*) from Sales.Orders ) as total_orders
-- FROM Sales.Products

-- SELECT *
-- FROM Sales.Customers as c
--     LEFT JOIN (
--     select customerId, COUNT(orderId)  as total_orders
--     from Sales.Orders
--     GROUP BY customerId
-- ) as o
--     ON c.CustomerID = o.CustomerID

-- WITH
--     CTE_total_sales
--     as
--     (
--         SELECT CustomerId, SUM(Sales) as total_sales
--         FROM Sales.Orders
--         GROUP BY CustomerId
--     )
--     ,
--     CTE_last_order_date
--     as
--     (
--         SELECT CustomerId, MAX(OrderDate) as last_order_date
--         FROM Sales.Orders
--         GROUP BY CustomerId
--     ),
--     CTE_ranked_customers
--     AS
--     (
--         SELECT CustomerId, total_sales,
--             rank() over(order by total_sales desc) as customer_rank
--         from CTE_total_sales
--     )
--     ,
--     CTE_customer_segments
--     AS
--     (
--         SELECT CustomerId, total_sales,
--             NTILE(3) OVER(order by total_sales desc) as bucket
--         FROM CTE_total_sales
--     )

-- -- SELECT *
-- -- from CTE_total_sales
-- -- ORDER BY total_sales DESC

-- SELECT c.CustomerID, c.FirstName, c.LastName, ts.total_sales, ld.last_order_date, rn.customer_rank,
--     case when cs.bucket =1 then 'high sales'
--      when cs.bucket =2 then 'medium sales'
--      else 'low sales' 
-- end as sales_category
-- FROM Sales.Customers as c
-- LEFT JOIN CTE_total_sales as ts
-- ON c.CustomerID = ts.CustomerId
-- LEFT JOIN CTE_last_order_date as ld
-- ON c.CustomerID = ld.CustomerId
-- LEFT JOIN CTE_ranked_customers as rn
-- on c.CustomerID = rn.CustomerID
-- LEFT JOIN CTE_customer_segments as cs
-- on c.CustomerID = cs.CustomerID

-- WITH
--     series
--     AS
--     (
--                     SELECT 1 as mynumber
--         UNION ALL
--             SELECT
--                 mynumber + 1
--             from series
--             WHERE mynumber < 20
--     )

-- SELECT *
-- from series

-- with
--     CTE_emp_hierarchy
--     AS
--     (
--                     SELECT
--                 EmployeeID,
--                 FirstName,
--                 ManagerID,
--                 1 as level
--             From Sales.Employees
--             WHERE ManagerID is null
--         UNION ALL
--             SELECT
--                 e.EmployeeID,
--                 e.FirstName,
--                 e.ManagerID,
--                 level+1
--             FROM Sales.Employees as e
--                 INNER join CTE_emp_hierarchy as ceh
--                 on e.ManagerID = ceh.EmployeeID
--     )

-- SELECT *
-- FROM CTE_emp_hierarchy

-- CREATE VIEW Sales.v_monthly_summary AS
-- (
--     SELECT 
--     MONTH(orderDate) ordermonth,
--     SUM(Sales) as total_sales,
--     COUNT(orderID) as total_orders,
--     SUM(quantity) as total_quantities
--     FROM Sales.Orders
--     GROUP BY MONTH(OrderDate)
-- )

-- SELECT ordermonth,
--     total_sales,
--     SUM(total_sales) OVER(ORDER BY ordermonth) as running_total_sales
-- from v_monthly_summary

-- drop view v_monthly_summary

-- SELECT *
-- INTO #temp_sales
-- from Sales.Orders

-- SELECT *
-- from #temp_sales

-- SELECT *
-- FROM tempdb.sys.tables
-- WHERE name LIKE '#temp_sales%';

-- DELETE from #temp_sales
-- WHERE OrderStatus = 'Delivered'

-- SELECT *
-- into Sales.ordersTest
-- from #temp_sales

-- SELECT *
-- from Sales.ordersTest

-- GO

-- ALTER PROCEDURE customerSummary
--     @country NVARCHAR(50)
-- AS
-- BEGIN
--     SELECT *
--     from Sales.Customers
--     WHERE Country = @country
-- END

-- EXEC customerSummary @country = 'Germany'

-- EXEC customerSummary @country = 'USA'

-- Drop PROCEDURE customerSummary


-- CREATE TABLE Sales.EmployeeLogs
-- (
--     LogID INT IDENTITY(1,1) PRIMARY KEY,
--     EmployeeID INT,
--     LogMessage VARCHAR(200),
--     LogDate DATE
-- )

-- GO

-- CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
-- After INSERT
-- AS
-- BEGIN
--     INSERT into Sales.EmployeeLogs
--         (EmployeeID, LogMessage, LogDate)
--     SELECT EmployeeID,
--         'New employee added = ' + CAST(EmployeeID as varchar),
--         GETDATE()
--     FROM inserted
-- END

-- SELECT *
-- from Sales.EmployeeLogs

-- INSERT into Sales.Employees
-- VALUES
--     (7, 'venkat', 'do', 'ceo', '2002-01-12', 'M', 500000000, 1)

-- SELECT *
-- from Sales.Employees

-- SELECT *
-- into Sales.DBcustomers
-- FROM Sales.Customers

-- CREATE CLUSTERED INDEX idx_DBcustomers_CustomerID
-- on Sales.DBcustomers(CustomerID)

-- CREATE NONCLUSTERED INDEX idx_DBcustomers_LastName
-- ON Sales.DBcustomers(LastName)

-- CREATE INDEX idx_DBcustomers_CountryScore
-- on Sales.DBcustomers(Country, Score)

-- CREATE NONCLUSTERED INDEX idx_DBcustomers_Country
-- on Sales.Customers(Country)
-- WHERE Country = 'USA'

-- --  Monitoring Index usage in below code

-- SELECT *
-- FROM sys.dm_db_index_usage_stats

-- EXEC sp_helpindex 'Sales.DBcustomers';

-- SELECT tbl.name as TableName,
--     i.object_id,
--     i.name AS INDEXName,
--     i.type_desc as IndexType,
--     i.is_primary_key as ISPrimaryKey,
--     i.is_unique as ISUnique,
--     s.user_seeks as UserSeeks,
--     s.user_scans as UserScans,
--     s.user_lookups as userLookups,
--     s.user_updates as UserUpdates,
--     COALESCE(s.last_user_seek, s.last_user_scan) LastUpdate
-- FROM sys.indexes AS i
--     JOIN sys.tables AS tbl
--     ON i.object_id = tbl.object_id
--     LEFT JOIN sys.dm_db_index_usage_stats AS s
--     ON i.object_id = s.object_id AND i.index_id = s.index_id
-- ORDER BY tbl.name, i.name

-- --  To see missing indexes recommendations
-- select *
-- from sys.dm_db_missing_index_details

-- -- To identify duplicate indexes in a table
-- SELECT tbl.name as TableName,
--     col.name as IndexColumn,
--     idx.name as IndexName,
--     idx.type_desc as IndexType,
--     COUNT(*) OVER(PARTITION BY tbl.name, col.name) as ColumnCount
-- FROM sys.tables AS tbl
--     JOIN sys.indexes AS idx
--     ON tbl.object_id = idx.object_id
--     JOIN sys.index_columns AS ic
--     ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
--     JOIN sys.columns AS col
--     ON ic.object_id = col.object_id AND ic.column_id = col.column_id
-- ORDER BY ColumnCount DESC

-- -- update statistics to make better execution plan
-- SELECT SCHEMA_NAME(t.schema_id) as SchemaName,
--     t.name as TableName,
--     s.name as StatisticsName,
--     sp.last_updated as LastUpdate,
--     DATEDIFF(day, sp.last_updated, GETDATE()) as LastUpdateDay,
--     sp.rows as 'Rows',
--     sp.modification_counter as ModificationsSinceLastUpdate
-- FROM sys.tables t
--     JOIN sys.stats s
--     ON t.object_id = s.object_id
-- CROSS APPLY sys.dm_db_stats_properties(t.object_id, s.stats_id) AS sp
-- ORDER BY sp.modification_counter DESC

-- UPDATE statistics Sales.Customers _WA_Sys_00000004_35BCFE0A

-- UPDATE statistics Sales.Customers

-- EXEC sp_updatestats

-- -- Monitor Fragmentation
-- Select tbl.name as TableName,
--     idx.name as IndexName,
--     s.avg_fragmentation_in_percent,
--     s.page_count
-- from sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') as s
--     JOIN sys.indexes AS idx
--     ON s.object_id = idx.object_id AND s.index_id = idx.index_id
--     JOIN sys.tables AS tbl
--     ON s.object_id = tbl.object_id
-- ORDER BY s.avg_fragmentation_in_percent DESC

-- ALTER INDEX idx_DBcustomers_Country on Sales.Customers REORGANIZE

-- ALTER INDEX idx_DBcustomers_Country on Sales.Customers REBUILD

-- -- step 1 : create partition function
-- CREATE PARTITION FUNCTION PartitionByyear(DATE)
-- AS RANGE LEFT FOR VALUES('2023-12-31', '2024-12-31', '2025-12-31')

-- -- Query lists all existing partition function
-- SELECT name, function_id, type, type_desc,
--     boundary_value_on_right
-- FROM sys.partition_functions

-- -- step 2 :create Filegroups
-- ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
-- ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
-- ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
-- ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- -- query that lists all filegroups
-- SELECT *
-- from sys.filegroups
-- WHERE [type] = 'FG'

-- -- step 3 : Add .ndf Files to each filegroup
-- ALTER DATABASE SalesDB ADD FILE 
-- (
--     NAME = P_2023, -- logical name
--     FILENAME = '/Users/venkatasai/Documents/SQL/P_2023.ndf'
-- ) To FILEGROUP FG_2023;

-- ALTER DATABASE SalesDB ADD FILE 
-- (
--     NAME = P_2024, -- logical name
--     FILENAME = '/Users/venkatasai/Documents/SQL/P_2024.ndf'
-- ) To FILEGROUP FG_2024;

-- ALTER DATABASE SalesDB ADD FILE 
-- (
--     NAME = P_2025, -- logical name
--     FILENAME = '/Users/venkatasai/Documents/SQL/P_2025.ndf'
-- ) To FILEGROUP FG_2025;

-- ALTER DATABASE SalesDB ADD FILE 
-- (
--     NAME = P_2026, -- logical name
--     FILENAME = '/Users/venkatasai/Documents/SQL/P_2026.ndf'
-- ) To FILEGROUP FG_2026;

-- -- query to see all files
-- SELECT fg.name as FilegroupName,
--     mf.name as LogicalFileName,
--     mf.physical_name as PhysicalFilePath,
--     mf.size / 128 as SizeinMB
-- FROM sys.filegroups AS fg
--     JOIN sys.master_files AS mf
--     ON fg.data_space_id = mf.data_space_id
-- WHERE mf.database_id =DB_ID('SalesDB');

-- -- step 4 : Create Partiotion scheme
-- CREATE PARTITION SCHEME schemePartitionByYear
-- as PARTITION PartitionByyear
-- To (FG_2023, FG_2024, FG_2025, FG_2026)

-- -- Query to check partition scheme
-- SELECT ps.name as PartitionSchemeName,
--     pf.name as PartitionFunctionName,
--     ds.destination_id as partitionNumber,
--     fg.name as FilegroupName
-- FROM sys.partition_schemes AS ps
--     JOIN sys.partition_functions AS pf
--     ON ps.function_id = pf.function_id
--     JOIN sys.destination_data_spaces AS ds
--     ON ps.data_space_id = ds.partition_scheme_id
--     JOIN sys.filegroups AS fg
--     ON ds.data_space_id = fg.data_space_id;

-- -- step 5 : create the partiotioned table
-- CREATE TABLE Sales.Orders_Partitioned
-- (
--     OrderID INT,
--     OrderDate DATE,
--     Sales INT
-- ) ON schemePartitionByYear (OrderDate)

-- INSERT INTO Sales.Orders_Partitioned
-- VALUES
--     (1, '2023-05-15', 100);
-- INSERT INTO Sales.Orders_Partitioned
-- VALUES
--     (2, '2024-07-20', 50);
-- INSERT INTO Sales.Orders_Partitioned
-- VALUES
--     (3, '2025-12-31', 50);

-- SELECT *
-- FROM Sales.Orders_Partitioned

-- -- query to check all partitions mapped
-- SELECT p.partition_number PartitionNumber,
--     f.name PartitionFilegroup,
--     p.rows as NumberOfRows
-- FROM sys.partitions p
--     join sys.destination_data_spaces dds on p.partition_number = dds.destination_id
--     JOIN sys.filegroups f on dds.data_space_id = f.data_space_id
-- WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned'

