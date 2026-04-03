use SalesDB
SELECT o.Sales,
    c.Country
From Sales.Orders as o
    LEFT JOIN Sales.Customers as c WITH (FORCESEEK)
    ON o.CustomerID = c.CustomerID
--OPTION(HASHJOIN)