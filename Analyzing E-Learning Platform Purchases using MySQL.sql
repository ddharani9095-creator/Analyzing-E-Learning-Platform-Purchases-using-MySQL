Create DATABASE Online_platform;

use  Online_platform;

Create table learners (
learner_id int Primary key auto_increment,
Full_name varchar (50) Not null,
country varchar (100) not null
);

Create table courses (
course_id int Primary key auto_increment,
course_name varchar (100) Not null,
category  varchar (100),
unit_price decimal (10,2)
);

Create table purchases (
purchase_id int primary key auto_increment,
learner_id int,
course_id int, 
quantity int Not null DEFAULT 1,
purchase_data DATE,

Foreign key (learner_id) References  learners (learner_id),
Foreign key (course_id) References courses (course_id),

 constraint check_quantity
 check ( quantity > 0 )
 
);

ALTER TABLE purchases
RENAME COLUMN purchase_data TO purchase_date;          

Describe learners;
Describe courses;
Describe purchases;

show databases;
select database ();

Select *
From learners;

Insert into learners (learner_id, Full_name, country)
VALUES ( 001, 'Dharani', 'India'),
(002, 'Prem','India'),
(003, 'Sandeep', 'India'),
(004, 'Roshan', 'india'),
(005, 'Umarani', 'Abroad'),
(006, 'Kalai', 'Abroad'),
(007, 'Dhanapal', 'Abroad'),
(008, 'Priya', 'Dubai'),
(009, 'Lala', 'Dubai');

Select*From learners;
Select* From Purchases;
Select * From courses;

 Insert into courses (course_id, course_name, category, unit_price)
 Values ( 1001, 'Data_Anlytics', 'IT', 45000),
 (1002, 'Full_stack', 'IT', 50000),
 (1003, 'HR', 'IT', 30000),
 (1004, 'sales','Marketing', 25000),
 (1005, 'Cashier', 'Banking', 20000),
 (1006, 'Teacher', 'schooling', 10000);
 
 Update courses
 set category = 'Advanced'
 Where course_id= 1001;
 
 Update courses
 set category = 'Advanced'
 Where course_id= 1002;
 
 Update courses
 set category = 'Beginner'
 Where course_id= 1003;
 
 
 Update courses
 set category = 'Beginner'
 Where course_id= 1004;
 
 
 Update courses
 set category = 'Intermediate'
 Where course_id= 1005;
 
 
 Update courses
 set category = 'Intermediate'
 Where course_id= 1006;
 
 
Update  courses
set  unit_price = 30000
 Where course_id= 1006;
 
 INSERT INTO courses
(course_id, course_name, category, unit_price)
VALUES
(1007, 'Python', 'IT', 35000);
 
Select*
From purchases;

Insert into purchases (learner_id, course_id, quantity, purchase_date)
values ( 1, 1001, 1, '2026-03-01'),
(2,1002, 1, '2026-05-01'),
(3, 1005, 2, '2025-01-10'),
(5,1006, 1, '2023-10-09'),
(6,1003, 2,'2025-07-05') ,
(6, 1002, 2, '2025-08-14'),
(7,1004,1, '2025-09-30');

Display: Learner name, Course name, Category, Quantity, Total amount, Purchase
date

SELECT
    l.full_name AS Learner_Name,
    c.course_name AS Course_Name,
    c.category AS Category,
    p.quantity AS Quantity,
    FORMAT(p.quantity * c.unit_price, 2) AS Total_Amount,
    p.purchase_date AS Purchase_Date
FROM purchases p
LEFT JOIN learners l
    ON p.learner_id = l.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id
ORDER BY p.quantity * c.unit_price DESC;


SELECT
    l.full_name AS Learner_Name,
    l.country AS Country,
    SUM(p.quantity * c.unit_price) AS Total_Spending
FROM learners l
LEFT JOIN purchases p
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name,
    l.country
ORDER BY Total_Spending DESC;

SELECT
    c.course_name,
    SUM(p.quantity) AS Total_Quantity
FROM purchases p
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    c.course_id,
    c.course_name
ORDER BY
    Total_Quantity DESC
LIMIT 3;

Q3. Show each category’s:
● Total revenue
● Number of unique learners

SELECT
    c.category AS Category,
    SUM(p.quantity * c.unit_price) AS Total_Revenue,
    COUNT(DISTINCT p.learner_id) AS Unique_Learners
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY
    c.category
ORDER BY
    Total_Revenue DESC;
    
SELECT
    l.full_name AS Learner_Name,
    COUNT(DISTINCT c.category) AS Categories_Purchased
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name
HAVING
    COUNT(DISTINCT c.category) > 1;

SELECT
    c.course_name,
    c.category,
    c.unit_price
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
WHERE p.course_id IS NULL;

SELECT
    l.full_name,
    SUM(p.quantity * c.unit_price) AS Total_Spending
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name
HAVING
    SUM(p.quantity * c.unit_price) >
    (
        SELECT AVG(total_spending)
        FROM
        (
            SELECT
                SUM(p.quantity * c.unit_price) AS total_spending
            FROM purchases p
            JOIN courses c
                ON p.course_id = c.course_id
            GROUP BY p.learner_id
        ) AS avg_table
    );

SELECT
    course_name,
    category,
    unit_price
FROM courses
WHERE unit_price > ANY
(
    SELECT unit_price
    FROM courses
    WHERE category = 'Beginner'
);


SELECT
    course_name,
    category,
    unit_price
FROM courses
WHERE category = 'Beginner';


SELECT
    l.full_name,
    l.country,
    SUM(p.quantity * c.unit_price) AS total_spending
FROM learners l
JOIN purchases p
    ON l.learner_id = p.learner_id
JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name,
    l.country
HAVING
    SUM(p.quantity * c.unit_price) >
(
    SELECT AVG(country_spending)
    FROM
    (
        SELECT
            SUM(p2.quantity * c2.unit_price) AS country_spending
        FROM learners l2
        JOIN purchases p2
            ON l2.learner_id = p2.learner_id
        JOIN courses c2
            ON p2.course_id = c2.course_id
        WHERE l2.country = l.country
        GROUP BY l2.learner_id
    ) AS avg_country
);

WITH LearnerSpending AS
(
    SELECT
        l.learner_id,
        l.full_name,
        SUM(p.quantity * c.unit_price) AS total_spending
    FROM learners l
    JOIN purchases p
        ON l.learner_id = p.learner_id
    JOIN courses c
        ON p.course_id = c.course_id
    GROUP BY
        l.learner_id,
        l.full_name
)

SELECT *
FROM LearnerSpending
WHERE total_spending > 10000;
       

WITH LearnerSpending AS
(
    SELECT
        l.learner_id,
        l.full_name,
        SUM(p.quantity * c.unit_price) AS total_spending
    FROM learners l
    JOIN purchases p
        ON l.learner_id = p.learner_id
    JOIN courses c
        ON p.course_id = c.course_id
    GROUP BY
        l.learner_id,
        l.full_name
)

SELECT
    full_name,
    total_spending,
    CASE
        WHEN total_spending > 15000 THEN 'High Value'
        WHEN total_spending BETWEEN 8000 AND 15000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS learner_category
FROM LearnerSpending;

SELECT
    c.course_name,
    COALESCE(COUNT(p.purchase_id), 0) AS purchase_count
FROM courses c
LEFT JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY
    c.course_id,
    c.course_name;
    
    CREATE VIEW category_performance_view AS

SELECT
    c.category,
    SUM(p.quantity * c.unit_price) AS total_revenue,
    COUNT(p.purchase_id) AS number_of_purchases,
    AVG(p.quantity * c.unit_price) AS average_revenue_per_purchase
FROM courses c
JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY
    c.category;