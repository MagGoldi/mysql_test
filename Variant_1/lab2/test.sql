SELECT actor_count AS actors, 
		COUNT(*) AS films 	
FROM (
	SELECT film_id,
	COUNT(actor_id) AS actor_count 
    FROM film_actor GROUP BY film_id) AS film_actor_counts 
WHERE actor_count = (SELECT COUNT(actor_id) AS actor_count
					FROM film_actor
					GROUP BY film_id
					ORDER BY actor_count
					LIMIT 1)
GROUP BY actor_count

select false and true and null or true or null