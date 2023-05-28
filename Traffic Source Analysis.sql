-- Find the Top Traffic Sources
	-- Find where the bulk of the website sessions are coming from, through 2012-04-12
SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS num_of_sessions
FROM website_sessions w
WHERE created_at < '2012-04-12'
GROUP BY 1,2,3
ORDER BY 4 DESC

-- Conclusion:Drill deeper into gsearch nonbrand campaign traffic to explore potential optimization opportunities

-- Traffic Source Conversion Rates
	-- gsearch nonbrand
	-- Calculate the conversion rate (CVR) from session to order. Based on what we're paying for clicks, we’ll need a CVR of at least 4% to make the numbers work.
	-- If we're much lower, we’ll need to reduce bids. If we’re higher, we can increase bids to drive more volume.
 
 SELECT
    COUNT(DISTINCT w.website_session_id)AS sessions,
    COUNT(DISTINCT o.order_id)AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS s2o_conv_rt
FROM website_sessions w LEFT JOIN orders o
ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-04-14'
  AND utm_source = 'gsearch'
  AND utm_campaign = 'nonbrand';   

-- Conclusion:

	-- Conversion rate is 2%, which is lower than the 4% threshold
	-- Monitor the impact of bid reductions
	-- Analyze performance trending by device type in order to refine bidding strategy
 
 -- Traffic Source Trending
	-- gsearch nonbrand
	-- Based on your conversion rate analysis, we bid down
	-- gsearch nonbrand on 2012-04-15.
	-- Can you pull gsearch nonbrand trended session volume, by week, to see if the bid changes have caused volume to drop at all?
SELECT
    MIN(DATE(created_at))AS week_start_date,
    COUNT(DISTINCT w.website_session_id)AS sessions
FROM website_sessions w
WHERE w.created_at < '2012-05-10'
  AND w.utm_source = 'gsearch'
  AND w.utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(w.created_at)

-- Conclusion:

	-- After the bid happen at '2012-04-15', the session drop down from 621 to 399, which means the gsearch nonbrand is fairly sensitive to bid changes.
	-- Think about how we could make the campaigns more efficient so that we can increase volume again

-- Bid Optimization for Paid Traffic
	-- Could you pull conversion rates from session to order, by device type?
	-- If desktop performance is better than on mobile we may be able to bid up for desktop specifically to get more volume?

SELECT 
    w.device_type,
    COUNT(DISTINCT w.website_session_id)AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id)/COUNT(DISTINCT w.website_session_id) AS conv_rt
FROM website_sessions w LEFT JOIN orders o
ON o.website_session_id = w.website_session_id
WHERE w.created_at < '2012-05-11'
  AND w.utm_source = 'gsearch'
  AND w.utm_campaign = 'nonbrand'
GROUP BY 1;

-- Conclusion:

	-- Increase our bids on desktop.
	-- Analyze volume by device type to see if the bid changes make a material impact