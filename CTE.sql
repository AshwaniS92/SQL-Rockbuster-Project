 WITH TopCountries AS (
    SELECT 
        D.country
    FROM 
        customer A
        INNER JOIN address B ON A.address_id = B.address_id
        INNER JOIN city C ON B.city_id = C.city_id
        INNER JOIN country D ON C.country_id = D.country_id
    GROUP BY 
        D.country
    ORDER BY 
        COUNT(A.customer_id) DESC
    LIMIT 10
),
TopCities AS (
    SELECT 
        D.country, 
        C.city
    FROM 
        customer A
        INNER JOIN address B ON A.address_id = B.address_id
        INNER JOIN city C ON B.city_id = C.city_id
        INNER JOIN country D ON C.country_id = D.country_id
    WHERE 
        D.country IN (SELECT country FROM TopCountries)
    GROUP BY 
        D.country, C.city
    ORDER BY 
        COUNT(A.customer_id) DESC
    LIMIT 10
),
CustomerPayments AS (
    SELECT  
        B.customer_id, 
        B.first_name, 
        B.last_name, 
        E.country, 
        D.city, 
        SUM(A.amount) AS total_amount_paid
    FROM 
        payment A
        INNER JOIN customer B ON A.customer_id = B.customer_id
        INNER JOIN address C ON B.address_id = C.address_id
        INNER JOIN city D ON C.city_id = D.city_id
        INNER JOIN country E ON D.country_id = E.country_id
    WHERE 
        (E.country, D.city) IN (SELECT country, city FROM TopCities)
    GROUP BY 
        B.customer_id, B.first_name, B.last_name, E.country, D.city
)
SELECT AVG(total_amount_paid) AS average_amount_paid
FROM CustomerPayments
LIMIT 5;

