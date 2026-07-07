CREATE DATABASE zomato_analysis;
USE zomato_analysis;

USE zomato_analysis;

DROP TABLE IF EXISTS zomato;
CREATE TABLE zomato (
    name VARCHAR(255),
    online_order VARCHAR(10),
    book_table VARCHAR(10),
    ratings DECIMAL(3,1),
    votes INT,
    location VARCHAR(100),
    rest_type VARCHAR(255),
    dish_liked TEXT,
    cuisines TEXT,
    approx_cost_for_two DECIMAL(10,2),
    reviews_list LONGTEXT,
    menu_item LONGTEXT,
    listed_in_type VARCHAR(100),
    listed_in_city VARCHAR(100)
);
SHOW TABLES;

--- 1. Total number of Restaurants available in the dataset

SELECT COUNT(*) AS total_restaurants
FROM zomato;

--- 2. Total number of unique restaurant chains.

SELECT COUNT(DISTINCT(name)) AS unique_rest_chains
FROM zomato;

--- 3. No. of different locations which are covered.

SELECT COUNT(DISTINCT(location)) AS diff_locations
FROM zomato;

--- 4. Top 10 restaurant chains with the highest number of outlets.

SELECT name, COUNT(name) AS no_of_outlets
FROM zomato
GROUP BY name
ORDER BY COUNT(name) DESC
LIMIT 10;

--- 5. Top 10 locations having the highest number of restaurants.

SELECT location, COUNT(name) AS no_of_restaurants
FROM zomato
GROUP BY location
ORDER BY COUNT(name) DESC
LIMIT 10;

--- 6. Locations with highest average restaurant ratings.

SELECT location, ROUND(AVG(ratings),1) AS avg_rest_rating
FROM zomato
GROUP BY location
ORDER BY AVG(ratings) DESC
LIMIT 10;

--- 7. Restaurant types having the highest average ratings.

SELECT rest_type AS Restaurant_Type,
ROUND(AVG(ratings),1) AS avg_rating
FROM zomato
GROUP BY rest_type
ORDER BY ROUND(AVG(ratings),1) DESC
LIMIT 10;

--- 8. Cuisines which are the most popular.

SELECT cuisines AS name_of_cuisine,
COUNT(*) AS total_restaurants
FROM zomato
GROUP BY cuisines
ORDER BY COUNT(*) DESC
LIMIT 10;

--- 9. Do restaurants offering online ordering have better average ratings?

SELECT online_order AS online_order_status,
ROUND(AVG(ratings),2) AS avg_rating
FROM zomato
GROUP BY online_order
ORDER BY ROUND(AVG(ratings),2) DESC;

--- 10. Does table booking influence restaurant ratings?

SELECT book_table AS Booked_table,
ROUND(AVG(ratings),2) AS Restaurants_rating
FROM zomato
GROUP BY book_table;

--- 11. Restaurant chains have the highest average ratings? (Minimum 20 outlets)

SELECT name AS Rest_chain_name,
ROUND(AVG(ratings),2) AS avg_rating
FROM zomato
GROUP BY name
HAVING COUNT(name) >=20
ORDER BY ROUND(AVG(ratings),2) DESC
LIMIT 10;

--- 12. Restaurants which have ratings higher than the overall average rating

SELECT name AS Restaurant_name,
ratings as restaurant_rating
FROM zomato
WHERE ratings>( SELECT AVG(ratings) FROM zomato);

--- 13. Ranking the restaurants based on customer votes.

SELECT
    name AS restaurant_name,
    SUM(votes) AS Votes,
    DENSE_RANK() OVER (ORDER BY SUM(votes) DESC) AS restaurant_rank
FROM zomato
GROUP BY name;

--- 14. Categorising restaurants based on their ratings.

SELECT name AS Restaurant_name,
ratings AS Rating,
CASE 
	WHEN ratings>= 4.5 THEN "Excellent"
    WHEN ratings>= 4.0 THEN "Very Good"
    WHEN ratings>= 3.5 THEN "Good"
    ELSE "Average"
    END AS rating_category
    FROM zomato
    ORDER BY ratings DESC;
    
--- 15. Locations having the highest number of highly rated restaurants (ratings ≥ 4.5)

SELECT location, COUNT(*) AS num_of_restaurants
FROM zomato
WHERE ratings>= 4.5
GROUP BY location
ORDER BY COUNT(*) DESC ;    
