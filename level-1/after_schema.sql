-- Create a rule to prevent duplicate records from being created
CREATE OR REPLACE RULE db_table_ignore_duplicate_customers AS
	ON INSERT TO customers
	WHERE (EXISTS (SELECT 1
				  FROM customers
				  WHERE customers.customer_id = NEW.customer_id))
	DO INSTEAD NOTHING;

-- Recreate table products to include product_category - no way to separate the 2 datasets
DROP TABLE PRODUCTS;

-- This table will contain only unique values
CREATE TABLE products (
  product_id TEXT PRIMARY KEY NOT NULL UNIQUE,
  product_title TEXT,
  product_category TEXT
);

-- Create view for easy access to all data used in Query 1
DROP VIEW IF EXISTS amazon_reviews_all_v CASCADE;
CREATE VIEW amazon_reviews_all_v AS (
	SELECT r.review_id, r.review_date, r.product_parent, c.customer_id,  c.customer_count,  p.product_id, p.product_title, p.product_category, v.star_rating, v.helpful_votes, v.total_votes, vine  
	FROM review_id_table r 
	JOIN vine_table v on r.review_id = v.review_id
	JOIN products p on r.product_id = p.product_id
	JOIN customers c on r.customer_id = c.customer_id
);

-- Create view to summarize data at product category and vine (Y/N) level used in Query 2
DROP VIEW IF EXISTS star_rating_V;
CREATE VIEW star_rating_V AS (
SELECT product_category, vine,
	CASE WHEN star_rating = 1 THEN count(review_id) ELSE 0 END as star_1,
	CASE WHEN star_rating = 2 THEN count(review_id) ELSE 0 END as star_2,
	CASE WHEN star_rating = 3 THEN count(review_id) ELSE 0 END as star_3,
	CASE WHEN star_rating = 4 THEN count(review_id) ELSE 0 END as star_4,
	CASE WHEN star_rating = 5 THEN count(review_id) ELSE 0 END as star_5,
	count(review_id) as total
FROM amazon_reviews_all_v
GROUP BY product_category, star_rating, vine

-- Create view to summarize total and helpful votes and total reviews per vine (Y/N) level used in Query 3	
CREATE VIEW helpfull_votes_v AS
SELECT product_category, vine, 
	sum(helpful_votes) as helpful_votes, 
	sum(total_votes) as total_votes,
	count(review_id) as total_reviews
FROM amazon_reviews_all_v
GROUP BY product_category, vine
);