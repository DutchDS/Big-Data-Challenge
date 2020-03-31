-- truncate table customers;
-- truncate table products;
-- truncate table review_id_table;
-- truncate table vine_table;

select count(*) from customers;
-- Output Pet Products: 103016
-- Output Musical Instruments: 151018 - 103016 
select count(*) from products;
-- Output Pet Products: 48050 
-- Output Musical Instruments: 48050 - 37234
select count(*) from review_id_table;
-- Output Pet Products: 173127
-- Output Musical Instruments: 173127 - 117813
select count(*) from vine_table;
-- Output Pet Products: 173127 - 117813
-- Output Musical Instruments: 173127 - 117813

CREATE VIEW amazon_reviews_all_v AS (
	SELECT r.review_id, r.review_date, r.product_parent, c.customer_id,  c.customer_count,  p.product_id, p.product_title, p.product_category, v.star_rating, v.helpful_votes, v.total_votes, vine  
	FROM review_id_table r 
	JOIN vine_table v on r.review_id = v.review_id
	JOIN products p on r.product_id = p.product_id
	JOIN customers c on r.customer_id = c.customer_id
)

SELECT product_category, count(*) from amazon_reviews_all_v
GROUP BY product_category;

SELECT product_category, vine, count(*) from amazon_reviews_all_v
GROUP BY product_category, vine

SELECT * FROM vine_table