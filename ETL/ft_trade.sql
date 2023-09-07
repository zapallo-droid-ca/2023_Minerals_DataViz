SELECT
	ft.country_code , dc.country_desc, dc.region_desc , ft.mineral_code , dm.mineral_desc , ft.unit_code , du.unit_desc,  ft."year" , 
	ft.quantity_import , ft.quantity_export , ft.value_import , ft.value_export,
	IFNULL((ft.quantity_import / SUM(ft.quantity_import) OVER (PARTITION BY ft."year", dm.mineral_desc)) * 100,0) AS imports_percentage_of_global,
	IFNULL((ft.quantity_import / SUM(ft.quantity_import) OVER (PARTITION BY ft."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS imports_percentage_of_region,
	IFNULL((ft.quantity_export / SUM(ft.quantity_export) OVER (PARTITION BY ft."year", dm.mineral_desc)) * 100,0) AS exports_percentage_of_global,
	IFNULL((ft.quantity_export / SUM(ft.quantity_export) OVER (PARTITION BY ft."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS exports_percentage_of_region,
	IFNULL((ft.value_import / SUM(ft.value_import) OVER (PARTITION BY ft."year", dm.mineral_desc)) * 100,0) AS imports_USD_percentage_of_global,
	IFNULL((ft.value_import / SUM(ft.value_import) OVER (PARTITION BY ft."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS imports_USD_percentage_of_region,
	IFNULL((ft.value_export / SUM(ft.value_export) OVER (PARTITION BY ft."year", dm.mineral_desc)) * 100,0) AS exports_USD_percentage_of_global,
	IFNULL((ft.value_export / SUM(ft.value_export) OVER (PARTITION BY ft."year", dm.mineral_desc, dc.region_desc)) * 100,0) AS exports_USD_percentage_of_region
	
FROM
	(SELECT
		dcm.country_code, dcm.mineral_code, dcm.unit_code, dcm."year", IFNULL(fm.quantity_import,0) quantity_import , 
		IFNULL(fm.quantity_export,0) quantity_export , IFNULL(fm.value_import,0)  value_import, IFNULL(fm.value_export,0) value_export , IFNULL(fm.trade_isna,0) trade_isna
	 FROM
	
		(SELECT 
			DISTINCT dc."year" || "-" || unit_code || "-" || country_code || "-" || mineral_code AS key, country_code, mineral_code, unit_code, dc."year"
		FROM ft_trade 
		
		CROSS JOIN (SELECT * FROM dim_calendar WHERE "year" >= 1986) dc) dcm
		
		LEFT JOIN
		
		(SELECT key, quantity_import , quantity_export , value_import ,value_export , trade_isna 
		 FROM ft_minerals) fm 
		
		ON dcm.key = fm.key) ft

	LEFT JOIN
	
	(SELECT country_code , country_desc , region_desc 
	FROM dim_country) dc 
	
	ON ft.country_code = dc.country_code
	
	LEFT JOIN
	
	(SELECT mineral_code , mineral_desc
	FROM dim_mineral) dm 
	
	ON ft.mineral_code = dm.mineral_code
	
	LEFT JOIN
	
	(SELECT unit_code  , unit_desc 
	FROM dim_unit) du 
	
	ON ft.unit_code = du.unit_code
	
ORDER BY ft.country_code, dm.mineral_desc, ft."year" DESC