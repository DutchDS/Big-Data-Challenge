-- Query 1 - Total reviews by product category and vine/non-vine reviewer. Output: Q1_output.png
SELECT product_category, vine, count(*) from amazon_reviews_all_v
GROUP BY product_category, vine

-- Query 2a - Number of review by star rating and vine review (Y/N). Output: Q2a_output.png
SELECT 
product_category, vine,
SUM(star_1) as star_1, SUM(star_2) as star_2, SUM(star_3) as star_3, SUM(star_4) as star_4, SUM(star_5) as star_5, sum(total) as total
FROM star_rating_V
GROUP BY product_category, vine;

-- Query 2b - Number of review by star rating and vine review (Y/N) in percentages. Output Q2b_output.png
SELECT 
product_category, vine,
ROUND(SUM(star_1)/SUM(total)*100,2)||'%' as star_1, 
ROUND(SUM(star_2)/SUM(total)*100,2)||'%' as star_2, 
ROUND(SUM(star_3)/SUM(total)*100,2)||'%' as star_3, 
ROUND(SUM(star_4)/SUM(total)*100,2)||'%' as star_4, 
ROUND(SUM(star_5)/SUM(total)*100,2)||'%' as star_5, 
ROUND(sum(total)/SUM(total)*100,1) ||'%' as total
FROM star_rating_V
GROUP BY product_category, vine

SELECT 
vine,
ROUND(SUM(star_1)/SUM(total)*100,2) as star_1, 
ROUND(SUM(star_2)/SUM(total)*100,2) as star_2, 
ROUND(SUM(star_3)/SUM(total)*100,2) as star_3, 
ROUND(SUM(star_4)/SUM(total)*100,2) as star_4, 
ROUND(SUM(star_5)/SUM(total)*100,2) as star_5, 
ROUND(sum(total)/SUM(total)*100,1) as total
FROM star_rating_V
GROUP BY vine

-- Query 3 How do vine reviews relate to non-vine reviews when it comes to total and helpful votes. Output: Q3_output.png
SELECT
	product_category,
	vine,
	helpful_votes,
	total_votes,
	round(sum(helpful_votes)/sum(total_votes)*100,2)||'%' as pct_helpful,
	total_votes/total_reviews avg_total_per_review,
	helpful_votes/total_reviews avg_helpfull_per_review
FROM helpfull_votes_v
GROUP BY product_category,
	vine,
	helpful_votes,
	total_votes,
	total_reviews