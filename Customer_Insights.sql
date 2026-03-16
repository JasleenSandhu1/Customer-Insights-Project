create database Customer;
select * from shopping_behavior_updated limit 10;

/*1.	Revenue and Profitability Questions
-	Average purchase value across different demographic groups?
-	Which product categories generate the highest revenue?
-	Which customer segments contribute the highest total revenue?
-	How does revenue vary by season?*/

select age_group, 
		gender, 
        avg(purchase_amount) as average_spending
from shopping_behavior_updated
group by age_group, gender
order by average_spending desc;

select category, 
		sum(purchase_amount) as total_revenue
from shopping_behavior_updated
group by category
order by total_revenue desc;

select	age_group, 
		gender,
		subscription_status, 
        sum(purchase_amount) as total_rev
from shopping_behavior_updated
group by age_group, gender, subscription_status
order by total_rev desc;

select season, 
		sum(purchase_amount) as total_rev, 
        avg(purchase_amount) as avg_amt
from shopping_behavior_updated
group by season
order by total_rev desc;

/*This helps businesses plan inventory and seasonal promotions.*/
SELECT season,
		category,
		SUM(purchase_amount) AS total_revenue
FROM shopping_behavior_updated
GROUP BY season, category
ORDER BY season, total_revenue DESC;



/*2.	Customer Value
-	Are high frequency customers also high-spend customers? (cannot be performed)
-	Can customers be segmented on spending levels?
-	Is there a relationship between review ratings and spending? */

select 
	case 
		when purchase_amount < 40 then 'Low Value'
        when purchase_amount between 40 and 80 then 'Mid Value'
        else 'High Value'
	END AS customer_segment,
    count(*) as total_customers,
    avg(purchase_amount) as avg_spending,
    sum(purchase_amount) as total_spending
from shopping_behavior_updated
group by customer_segment
order by total_spending desc;

select 
	review_rating,
    count(*) as total_customers,
    avg(purchase_amount) as avg_spending
from shopping_behavior_updated
group by review_rating
order by avg_spending;
    
/*3.	Subscription effectiveness
-	Do subscribers spend more than non-subscribers?
-	What percentage of high-value customers are subscribed?*/

select subscription_status,
		count(*) as total_customers,
        avg(purchase_amount) as avg_spending,
        sum(purchase_amount) as total_spending
from shopping_behavior_updated
group by subscription_status
order by total_spending desc;

WITH high_value_customers AS (
    SELECT subscription_status
    FROM shopping_behavior_updated
    WHERE purchase_amount > 80
)
SELECT 
    ROUND(
        SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
        2
    ) AS subscribed_high_value_customers
FROM high_value_customers;

/*4.	Discount & Promotion Strategy Questions
-	Do discounts increase transaction value?
-	Is the company over-reliant on discounts to drive sales?
- Do discounts impact spending behavior across age groups?*/

select discount_applied,
		count(*) as total_orders,
        avg(purchase_amount) as avg_transaction_amt,
        sum(purchase_amount) as total_transaction_amt
from shopping_behavior_updated
group by discount_applied
order by total_transaction_amt desc;

SELECT 
    discount_applied,
    SUM(purchase_amount) AS total_revenue,
    ROUND(
        SUM(purchase_amount) * 100 /
        (SELECT SUM(purchase_amount) FROM shopping_behavior_updated),
        2
    ) AS revenue_percentage
FROM shopping_behavior_updated
GROUP BY discount_applied;

SELECT 
    age_group,
    discount_applied,
    COUNT(*) AS total_orders,
    AVG(purchase_amount) AS avg_purchase_value,
    sum(purchase_amount) as total_purchase_value
FROM shopping_behavior_updated
GROUP BY age_group, discount_applied
ORDER BY age_group, total_purchase_value desc;

SELECT 
    category,
    discount_applied,
    COUNT(*) AS total_transactions,
    SUM(purchase_amount) AS total_revenue,
    AVG(purchase_amount) AS avg_transaction_value
FROM shopping_behavior_updated
GROUP BY category, discount_applied
ORDER BY category, discount_applied;

/*5.	Operational and Behavioral Questions
-	Which shipping methods are most commonly used?
-	Does shipping type affect review ratings?
-	What payment methods are most preferred by high-value customers?
- Most used payment methods*/

select shipping_type,
count(shipping_type) as shipping_times_used,
avg(purchase_amount) as avg_spending
from shopping_behavior_updated
group by shipping_type
order by shipping_times_used desc;

select shipping_type,
		round(avg(review_rating),2) as avg_review_rating
from shopping_behavior_updated
group by shipping_type
order by avg_review_rating desc;

select payment_method,
		count(*) as usage_count
from shopping_behavior_updated
where purchase_amount > 80
group by payment_method
order by usage_count desc;

select payment_method,
		count(*) as usage_count
from shopping_behavior_updated
group by payment_method
order by usage_count desc;

select * from shopping_behavior_updated
where subscription_status = 'Yes' and gender = 'Female';


SELECT
    category,
    SUM(purchase_amount) AS category_revenue,
    SUM(purchase_amount) * 100.0 / (SELECT SUM(purchase_amount) FROM shopping_behavior_updated) AS revenue_percentage
FROM shopping_behavior_updated
GROUP BY category
ORDER BY revenue_percentage DESC;

