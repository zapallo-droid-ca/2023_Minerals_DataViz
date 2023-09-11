--YEARS
SELECT mineral_desc, MIN("year") AS 'from' , MAX("year") AS 'to' 
FROM v_minerals
WHERE quantity_produced > 0
GROUP BY mineral_desc

--NUMBER OF MINERALS
SELECT COUNT(DISTINCT  mineral_code) AS number_of_minerals
FROM v_minerals;

--LAST 5 YEARS OF PRODUCTION
WITH years AS (SELECT MAX("year") - 5 AS "min_year" FROM v_minerals)
SELECT 
	mineral_desc, unit_desc,
	SUM(CASE WHEN "year" = 2015 THEN CEIL(quantity_produced) ELSE 0 END) AS "2015",
	SUM(CASE WHEN "year" = 2016 THEN CEIL(quantity_produced) ELSE 0 END) AS "2016",
	SUM(CASE WHEN "year" = 2017 THEN CEIL(quantity_produced) ELSE 0 END) AS "2017",
	SUM(CASE WHEN "year" = 2018 THEN CEIL(quantity_produced) ELSE 0 END) AS "2018",
	SUM(CASE WHEN "year" = 2019 THEN CEIL(quantity_produced) ELSE 0 END) AS "2019",
	SUM(CASE WHEN "year" = 2020 THEN CEIL(quantity_produced) ELSE 0 END) AS "2020",
	SUM(CASE WHEN "year" >= (SELECT "min_year" FROM years) THEN CEIL(quantity_produced) ELSE 0 END) AS total
FROM v_minerals
WHERE "year" >= (SELECT "min_year" FROM years)
GROUP BY mineral_desc, unit_desc
ORDER BY unit_desc ASC, total DESC

--LAST 5 YEARS OF PRODUCTION CHANGE RATE BY YEAR
WITH years AS (SELECT MAX("year") - 6 AS "min_year" FROM v_minerals)
SELECT 
	mineral_desc, unit_desc,
	SUM(CASE WHEN "year" = 2015 THEN quantity_produced ELSE 0 END) AS "2015",
	SUM(CASE WHEN "year" = 2016 THEN quantity_produced ELSE 0 END) AS "2016",
	SUM(CASE WHEN "year" = 2017 THEN quantity_produced ELSE 0 END) AS "2017",
	SUM(CASE WHEN "year" = 2018 THEN quantity_produced ELSE 0 END) AS "2018",
	SUM(CASE WHEN "year" = 2019 THEN quantity_produced ELSE 0 END) AS "2019",
	SUM(CASE WHEN "year" = 2020 THEN quantity_produced ELSE 0 END) AS "2020",
	ROUND(AVG(CASE WHEN "year" >= (SELECT "min_year" FROM years) THEN quantity_produced ELSE 0 END),1) AS average
FROM(
	SELECT
		mineral_desc, unit_desc, "year", ROUND(((CAST(quantity_produced AS FLOAT) - CAST(quantity_produced_lag AS FLOAT) ) / CAST(quantity_produced_lag AS FLOAT) ) * 100,1) AS quantity_produced	
	FROM(
		SELECT
			mineral_desc, unit_desc, "year", quantity_produced,
			LAG(CAST(quantity_produced AS FLOAT), 1) OVER (PARTITION BY mineral_desc ORDER BY "year" ASC) AS quantity_produced_lag
		FROM(
			SELECT 
				mineral_desc, unit_desc, "year", CEIL(SUM(quantity_produced)) AS quantity_produced	
			FROM v_minerals
			WHERE "year" >= (SELECT "min_year" FROM years)
			GROUP BY mineral_desc, unit_desc, "year"
			)
		)
	WHERE "year" > (SELECT "min_year" FROM years)
	)
GROUP BY mineral_desc, unit_desc
ORDER BY unit_desc ASC, average DESC


--GLOBAL SUMMARY
SELECT 
	base.mineral_desc, base.unit_desc, base.mineral_mean, base.mineral_min, base.mineral_max, base.avg_producers, base.avg_active_producers, pareto."countries_80%",
	ROUND((pareto."countries_80%" / base.avg_active_producers) * 100,1) AS "%_countries_pareto"
FROM
	(SELECT 
		 mineral_desc, mineral_code,  unit_desc,
		 ROUND(AVG(quantity_produced),2) AS mineral_mean,
		 MIN(CASE WHEN quantity_produced >0 THEN quantity_produced ELSE NULL END) AS "mineral_min",
		 MAX(quantity_produced) AS "mineral_max",
		 AVG(producers) AS avg_producers,
		 CEIL(AVG(active_producers)) AS avg_active_producers
	FROM(
		SELECT 
			mineral_desc, mineral_code, unit_desc, "year", CEIL(SUM(quantity_produced)) AS quantity_produced,
			COUNT(DISTINCT country_code) AS producers,
			COUNT(DISTINCT CASE WHEN quantity_produced > 0 THEN country_code ELSE NULL END) AS active_producers		
		FROM v_minerals
		GROUP BY mineral_desc, unit_desc, mineral_code, "year"
		)
	GROUP BY mineral_desc, mineral_code, unit_desc
	ORDER BY mineral_mean DESC) base

LEFT JOIN

	(SELECT mineral_code,
			COUNT(DISTINCT CASE WHEN cummulated <= 0.8 THEN country_code ELSE NULL END) AS "countries_80%"
	FROM(
		SELECT 
			mineral_code, country_code, "year", quantity_produced, 
			ROUND(
				CAST(SUM(quantity_produced) OVER (PARTITION BY mineral_code, "year" ORDER BY quantity_produced DESC) AS FLOAT) / 
				SUM(quantity_produced) OVER (PARTITION BY mineral_code, "year")
				, 2) AS cummulated
		FROM v_minerals
		)
	GROUP BY mineral_code) pareto
	
	ON base.mineral_code = pareto.mineral_code

--NUMBER OF COUNTRIES
SELECT COUNT(DISTINCT CASE WHEN quantity_produced > 0 THEN country_code ELSE NULL END) AS number_of_countries
FROM v_minerals


