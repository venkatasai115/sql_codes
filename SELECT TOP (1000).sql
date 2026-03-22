USE MyDatabase
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

CREATE TABLE persons
(
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE ,
    phone VARCHAR(20) NOT NULL,
    CONSTRAINT pK_persons PRIMARY KEY (id)
)

ALTER TABLE persons
ADD email VARCHAR(50)
NOT

DROP TABLE persons

SELECT *
FROM persons

SELECT *
FROM customers
    FULL join orders
    on customers.id = orders.customer_id
WHERE orders.customer_id IS NULL OR customers.id IS NULL