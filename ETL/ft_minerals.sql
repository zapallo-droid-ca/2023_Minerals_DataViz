SELECT 
	dcfm.country_code , dc.country_desc, dc.region_desc , dcfm.mineral_code , dm.mineral_desc , dcfm.unit_code , du.unit_desc,  dcfm."year" , 
	dcfm.quantity_produced , dcfm.quantity_import , dcfm.quantity_export , dcfm.value_export , dcfm.value_import , dcfm.trade_isna, 
	CASE WHEN "year" < 1986 THEN "production only" ELSE "production  and trade" END AS dimension,
	
	IFNULL((dcfm.quantity_produced / SUM(dcfm.quantity_produced) OVER (PARTITION BY dcfm."year", dm.mineral_desc)) * 100,0) AS produced_percentage_of_global,
	IFNULL((dcfm.quantity_produced / SUM(dcfm.quantity_produced) OVER (PARTITION BY dcfm."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS produced_percentage_of_region,	
	
	IFNULL((dcfm.quantity_import / SUM(dcfm.quantity_import) OVER (PARTITION BY dcfm."year", dm.mineral_desc)) * 100,0) AS imports_percentage_of_global,
	IFNULL((dcfm.quantity_import / SUM(dcfm.quantity_import) OVER (PARTITION BY dcfm."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS imports_percentage_of_region,
	IFNULL((dcfm.quantity_export / SUM(dcfm.quantity_export) OVER (PARTITION BY dcfm."year", dm.mineral_desc)) * 100,0) AS exports_percentage_of_global,
	IFNULL((dcfm.quantity_export / SUM(dcfm.quantity_export) OVER (PARTITION BY dcfm."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS exports_percentage_of_region,
	
	IFNULL((dcfm.value_import / SUM(dcfm.value_import) OVER (PARTITION BY dcfm."year", dm.mineral_desc)) * 100,0) AS imports_USD_percentage_of_global,
	IFNULL((dcfm.value_import / SUM(dcfm.value_import) OVER (PARTITION BY dcfm."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS imports_USD_percentage_of_region,
	IFNULL((dcfm.value_export / SUM(dcfm.value_export) OVER (PARTITION BY dcfm."year", dm.mineral_desc)) * 100,0) AS exports_USD_percentage_of_global,
	IFNULL((dcfm.value_export / SUM(dcfm.value_export) OVER (PARTITION BY dcfm."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS exports_USD_percentage_of_region
FROM 
	(SELECT
		dcm.country_code, dcm.mineral_code, dcm.unit_code, dcm."year", IFNULL(fm.quantity_produced,0) quantity_produced, IFNULL(fm.quantity_import,0) quantity_import , 
		IFNULL(fm.quantity_export,0) quantity_export , IFNULL(fm.value_import,0)  value_import, IFNULL(fm.value_export,0) value_export , IFNULL(fm.trade_isna,0) trade_isna
	FROM
	
		(SELECT 
			DISTINCT dc."year" || "-" || unit_code || "-" || country_code || "-" || mineral_code AS key, country_code, mineral_code, unit_code, dc."year"
		FROM ft_minerals 
		
		CROSS JOIN dim_calendar dc) dcm
		
		LEFT JOIN
		
		(SELECT key, value AS quantity_produced, quantity_import , quantity_export , value_import ,value_export , trade_isna 
		 FROM ft_minerals) fm 
		
		ON dcm.key = fm.key) dcfm
	
	LEFT JOIN
	
	(SELECT country_code , country_desc , region_desc 
	FROM dim_country) dc 
	
	ON dcfm.country_code = dc.country_code
	
	LEFT JOIN
	
	(SELECT mineral_code , mineral_desc
	FROM dim_mineral) dm 
	
	ON dcfm.mineral_code = dm.mineral_code
	
	LEFT JOIN
	
	(SELECT unit_code  , unit_desc 
	FROM dim_unit) du 
	
	ON dcfm.unit_code = du.unit_code
	
	