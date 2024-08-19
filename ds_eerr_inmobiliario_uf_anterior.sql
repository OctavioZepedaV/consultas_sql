/*create table ds_eerr_inmobiliario_uf_anterior(
	nombre_proyecto varchar(500),
	obra varchar(500),
	item varchar(600),
	gasto int,
	por_gastar int,
	total int,
	number_row int,
	tipo varchar(10)
);*/

delete from ds_eerr_inmobiliario_uf_anterior;

insert into ds_eerr_inmobiliario_uf_anterior (nombre_proyecto, obra, item, gasto, por_gastar, total, number_row, tipo) 
(select 
	eerr_actual.nombre_proyecto,
	eerr_actual.obra, 
	eerr_actual.item,
	eerr_actual.gasto,
	eerr_actual.por_gastar,
	eerr_actual.gasto+eerr_actual.por_gastar as total,
	eerr_actual.number_row,
	eerr_actual.tipo
from
(
	(
		select 
			hp.nombre_proyecto,
			item.obra, 
			item.item,
			item.gasto,
			item.por_gastar,
			item.number_row,
			'DP' as tipo
		from
			(
				-- Primera subconsulta
				(
				    SELECT 
				        apgi.obra,
				        apgi.Partida AS item,
				        ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
				        ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
				        1 AS number_row
				    FROM
				        (SELECT DISTINCT 
				            apgi.obra, 
				            api.area_propuesta AS Nombre_Area, 
				            api.partida_propuesta AS Partida,
				            apgi.Recurso, 
				            apgi.Monto_Trabajo,
				            apgi.Monto_Gastado,
				            apgi.fecha_actualizacion
				        FROM avance_por_gastar_inmobiliaria apgi
				        INNER JOIN area_partida_inmobiliaria api 
				        ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
				        WHERE apgi.obra LIKE '%DP%') AS apgi
				    INNER JOIN 
				        (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
				    ON apgi.obra = actualizacion.obra
				    AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
				    AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
				    INNER JOIN item_uf AS iu
				    ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
				    WHERE apgi.Nombre_Area IS NOT NULL
				    GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf, iu.orden
				)
		) as item inner join homologacion_proyectos hp on
			item.obra = hp.auranet_inmobiliaria
	)
	UNION 
	-- ############################# macro
	(
	select 
			proyecto.nombre_proyecto,
			proyecto.obra,
			proyecto.item,
			round(proyecto.gasto*viviendas.cantidad_viviendas,2) as gasto,
			round(proyecto.por_gastar*viviendas.cantidad_viviendas,2) as por_gastar,
			proyecto.number_row,
			proyecto.tipo
		from 
		(
			select 
				mp.nombre_proyecto,
				item.obra, 
				item.item,
				item.gasto/mp.viviendas as gasto,
				item.por_gastar/mp.viviendas as por_gastar,
				item.number_row,
				'DP' as tipo
			from
				(
			
			-- Primera subconsulta
			(
			    SELECT 
			        apgi.obra,
			        apgi.Partida AS item,
			        ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
			        ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
			        1 AS number_row
			    FROM
			        (SELECT DISTINCT 
			            apgi.obra, 
			            api.area_propuesta AS Nombre_Area, 
			            api.partida_propuesta AS Partida,
			            apgi.Recurso, 
			            apgi.Monto_Trabajo,
			            apgi.Monto_Gastado,
			            apgi.fecha_actualizacion
			        FROM avance_por_gastar_inmobiliaria apgi
			        INNER JOIN area_partida_inmobiliaria api 
			        ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
			        WHERE apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%') AS apgi
			    INNER JOIN 
			        (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
			    ON apgi.obra = actualizacion.obra
			    AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
			    AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
			    INNER JOIN item_uf AS iu
			    ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
			    WHERE apgi.Nombre_Area IS NOT NULL
			    GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
			)
			) as item inner join macro_proyectos mp  on
				item.obra = mp.macro
		) as proyecto inner join
		(select distinct hp.nombre_proyecto, hp.cantidad_viviendas
		from homologacion_proyectos hp, macro_proyectos mp
		where hp.nombre_proyecto = mp.nombre_proyecto) as viviendas
		on proyecto.nombre_proyecto = viviendas.nombre_proyecto
	)
	-- ------------------------------------------- VENTAS ------------------------------------------------------------------------
	union
	(
		select 
			hp.nombre_proyecto,
			item.obra, 
			item.item,
			item.gasto,
			item.por_gastar,
			item.number_row,
			'VT' as tipo
		from
		(
			(
			select 
				apgi.obra,
				apgi.Nombre_Area as item,
				round(sum(apgi.Monto_Gastado)/iu.valor_actual_uf,2) as gasto,
				round((sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado))/iu.valor_pendiente_uf,2) as por_gastar,
				1 as number_row
			from
			(select distinct 
				apgi.obra, 
				api.area_propuesta as Nombre_Area, 
				api.partida_propuesta as Partida,
				apgi.Recurso, 
				apgi.Monto_Trabajo,
				apgi.Monto_Gastado,
				apgi.fecha_actualizacion
			from avance_por_gastar_inmobiliaria apgi
			inner join area_partida_inmobiliaria api 
			on api.obra = apgi.obra and apgi.Recurso = api.Nombre_Recurso) as apgi,
			(select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) as actualizacion, item_uf as iu
			where  year(apgi.fecha_actualizacion) = year(actualizacion.fecha_actualizacion)
			and month(apgi.fecha_actualizacion) = month(actualizacion.fecha_actualizacion) and apgi.obra = actualizacion.obra 
			and apgi.Nombre_Area is NOT NULL
			and apgi.obra like '%VT%'
			and apgi.obra = iu.CC and iu.ITEM = apgi.Nombre_Area
			group by apgi.obra, apgi.Nombre_Area, iu.valor_actual_uf, iu.valor_pendiente_uf
			)
		) as item
			inner join homologacion_proyectos hp on
			item.obra = hp.auranet_ventas
	)
	union
	-- ------------------------------------------- Beneficio IVA ------------------------------------------------------------------------
	-- Subconsulta principal
	(
	    SELECT 
	        hp.nombre_proyecto,
	        item.obra, 
	        item.item,
	        item.gasto,
	        item.por_gastar,
	        item.number_row,
	        'DP' AS tipo
	    FROM
	    (
	        SELECT 
	            item_total.obra,
	            'Monto Menor Beneficio IVA Const' AS item,
	            ROUND((SUM(item_total.gasto) * 0.19) * item_total.ceec, 2) * -1 AS gasto,
	            ROUND((SUM(item_total.por_gastar) * 0.19) * item_total.ceec, 2) * -1 AS por_gastar,
	            1 AS number_row
	        FROM
	        (
	        
	        
	        SELECT 
				    total.obra, 
				    total.item, 
				    SUM(total.gasto) AS gasto, 
				    SUM(por_gastar) AS por_gastar, 
				    total.number_row, bii.ceec
				FROM 
				(
				    -- Primera subconsulta
				    (
				    	(
					        SELECT 
					            apgi.obra,
					            apgi.Partida AS item,
					            ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
					            ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
					            2 AS number_row
					        FROM
					            (SELECT DISTINCT
					                apgi.obra, 
					                api.area_propuesta AS Nombre_Area, 
					                api.partida_propuesta AS Partida,
					                apgi.Recurso, 
					                apgi.Monto_Trabajo,
					                apgi.Monto_Gastado,
					                apgi.fecha_actualizacion
					            FROM avance_por_gastar_inmobiliaria apgi
					            INNER JOIN area_partida_inmobiliaria api 
					            ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
					            ) AS apgi
					        INNER JOIN 
					            (select 
									 apgi.obra,
									 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
									from(
									select apgi.obra, 
										MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
									from avance_por_gastar_inmobiliaria apgi
									group by apgi.obra
									) as apgi) AS actualizacion
					        ON apgi.obra = actualizacion.obra
					        AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
					        AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
					        INNER JOIN item_uf AS iu
					        ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
					        WHERE apgi.Nombre_Area IS NOT NULL
					        AND apgi.obra LIKE '%DP%'
					        GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
				        )
				        UNION 
				        ( 
					        select 
								        	macro.obra,
								        	macro.item,
								        	macro.gasto*viviendas.cantidad_viviendas as gasto,
								        	macro.por_gastar*viviendas.cantidad_viviendas as por_gastar,
								        	macro.number_row
								        FROM 
								        (
									        select 
									        	macro.obra,
									        	macro.item,
									        	macro.gasto/mp.viviendas as gasto,
									        	macro.por_gastar/mp.viviendas as por_gastar, 
									        	macro.number_row,
									        	mp.nombre_proyecto
									        from (
										        SELECT 
											        apgi.obra,
											        apgi.Partida AS item,
											        ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
											        ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
											        1 AS number_row
											    FROM
											        (SELECT DISTINCT 
											            apgi.obra, 
											            api.area_propuesta AS Nombre_Area, 
											            api.partida_propuesta AS Partida,
											            apgi.Recurso, 
											            apgi.Monto_Trabajo,
											            apgi.Monto_Gastado,
											            apgi.fecha_actualizacion
											        FROM avance_por_gastar_inmobiliaria apgi
											        INNER JOIN area_partida_inmobiliaria api 
											        ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
											        WHERE apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%') AS apgi
											    INNER JOIN 
											        (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
											    ON apgi.obra = actualizacion.obra
											    AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
											    AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
											    INNER JOIN item_uf AS iu
											    ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
											    WHERE apgi.Nombre_Area IS NOT NULL
											    GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
											    ) as macro inner join macro_proyectos mp 
											    on macro.obra = mp.macro
										   ) as macro inner join (select distinct hp.nombre_proyecto, hp.cantidad_viviendas
											from homologacion_proyectos hp, macro_proyectos mp
											where hp.nombre_proyecto = mp.nombre_proyecto) as viviendas
											on viviendas.nombre_proyecto = macro.nombre_proyecto
				        )
				    )
				) AS total
				INNER JOIN beneficio_iva_inmobiliaria bii
				ON total.obra = bii.cc AND total.item = bii.ITEM
				GROUP BY total.obra, total.item, total.number_row, bii.ceec
	        ) AS item_total
	        GROUP BY item_total.obra, item_total.CEEC
	    ) AS item
	    INNER JOIN homologacion_proyectos hp
	    ON item.obra = hp.auranet_inmobiliaria
	)
	
	union
	-- ------------------------------------------- Calculo Beneficio IVA ------------------------------------------------------------------------
	(
	
	
		SELECT 
		    hp.nombre_proyecto,
		    item.obra, 
		    item.item,
		    item.gasto,
		    item.por_gastar,
		    item.number_row,
		    'DP' AS tipo
		FROM
		(
		SELECT 
				    total.obra, 
				    total.item, 
				    SUM(total.gasto) AS gasto, 
				    SUM(por_gastar) AS por_gastar, 
				    total.number_row
				FROM 
				(
				    -- Primera subconsulta
				    (
				    	(
					        SELECT 
					            apgi.obra,
					            apgi.Partida AS item,
					            ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
					            ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
					            2 AS number_row
					        FROM
					            (SELECT DISTINCT
					                apgi.obra, 
					                api.area_propuesta AS Nombre_Area, 
					                api.partida_propuesta AS Partida,
					                apgi.Recurso, 
					                apgi.Monto_Trabajo,
					                apgi.Monto_Gastado,
					                apgi.fecha_actualizacion
					            FROM avance_por_gastar_inmobiliaria apgi
					            INNER JOIN area_partida_inmobiliaria api 
					            ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
					            ) AS apgi
					        INNER JOIN 
					            (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
					        ON apgi.obra = actualizacion.obra
					        AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
					        AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
					        INNER JOIN item_uf AS iu
					        ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
					        WHERE apgi.Nombre_Area IS NOT NULL
					        AND apgi.obra LIKE '%DP%'
					        GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
				        )
				        UNION 
				        ( 
					        select 
								        	macro.obra,
								        	macro.item,
								        	macro.gasto*viviendas.cantidad_viviendas as gasto,
								        	macro.por_gastar*viviendas.cantidad_viviendas as por_gastar,
								        	macro.number_row
								        FROM 
								        (
									        select 
									        	macro.obra,
									        	macro.item,
									        	macro.gasto/mp.viviendas as gasto,
									        	macro.por_gastar/mp.viviendas as por_gastar, 
									        	macro.number_row,
									        	mp.nombre_proyecto
									        from (
										        SELECT 
											        apgi.obra,
											        apgi.Partida AS item,
											        ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
											        ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
											        1 AS number_row
											    FROM
											        (SELECT DISTINCT 
											            apgi.obra, 
											            api.area_propuesta AS Nombre_Area, 
											            api.partida_propuesta AS Partida,
											            apgi.Recurso, 
											            apgi.Monto_Trabajo,
											            apgi.Monto_Gastado,
											            apgi.fecha_actualizacion
											        FROM avance_por_gastar_inmobiliaria apgi
											        INNER JOIN area_partida_inmobiliaria api 
											        ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
											        WHERE apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%') AS apgi
											    INNER JOIN 
											        (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
											    ON apgi.obra = actualizacion.obra
											    AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
											    AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
											    INNER JOIN item_uf AS iu
											    ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
											    WHERE apgi.Nombre_Area IS NOT NULL
											    GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
											    ) as macro inner join macro_proyectos mp 
											    on macro.obra = mp.macro
										   ) as macro inner join (select distinct hp.nombre_proyecto, hp.cantidad_viviendas
											from homologacion_proyectos hp, macro_proyectos mp
											where hp.nombre_proyecto = mp.nombre_proyecto) as viviendas
											on viviendas.nombre_proyecto = macro.nombre_proyecto
				        )
				    )
				) AS total
	
		        INNER JOIN beneficio_iva_inmobiliaria bii
		        ON total.obra = bii.cc AND total.item = bii.ITEM
		        GROUP BY total.obra, total.item, total.number_row
		) AS item
		INNER JOIN homologacion_proyectos hp
		ON item.obra = hp.auranet_inmobiliaria
	)
	union
	-- ------------------------------------------- Calculo Beneficio IVA ------------------------------------------------------------------------
	(
		SELECT 
		    hp.nombre_proyecto,
		    item.obra, 
		    item.item,
		    item.gasto,
		    item.por_gastar,
		    item.number_row,
		    'DP' AS tipo
		FROM
		(
		    SELECT 
		        item_total.obra,
		        'TOTAL' AS item,
		        ROUND(SUM(item_total.gasto), 2) AS gasto,
		        ROUND(SUM(item_total.por_gastar), 2) AS por_gastar,
		        3 AS number_row
		    FROM
		    (
		    SELECT 
				    total.obra, 
				    total.item, 
				    SUM(total.gasto) AS gasto, 
				    SUM(por_gastar) AS por_gastar, 
				    total.number_row, bii.ceec
				FROM 
				(
				    -- Primera subconsulta
				    (
				    	(
					        SELECT 
					            apgi.obra,
					            apgi.Partida AS item,
					            ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
					            ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
					            2 AS number_row
					        FROM
					            (SELECT DISTINCT
					                apgi.obra, 
					                api.area_propuesta AS Nombre_Area, 
					                api.partida_propuesta AS Partida,
					                apgi.Recurso, 
					                apgi.Monto_Trabajo,
					                apgi.Monto_Gastado,
					                apgi.fecha_actualizacion
					            FROM avance_por_gastar_inmobiliaria apgi
					            INNER JOIN area_partida_inmobiliaria api 
					            ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
					            ) AS apgi
					        INNER JOIN 
					            (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
					        ON apgi.obra = actualizacion.obra
					        AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
					        AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
					        INNER JOIN item_uf AS iu
					        ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
					        WHERE apgi.Nombre_Area IS NOT NULL
					        AND apgi.obra LIKE '%DP%'
					        GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
				        )
				        UNION 
				        ( 
					        select 
								        	macro.obra,
								        	macro.item,
								        	macro.gasto*viviendas.cantidad_viviendas as gasto,
								        	macro.por_gastar*viviendas.cantidad_viviendas as por_gastar,
								        	macro.number_row
								        FROM 
								        (
									        select 
									        	macro.obra,
									        	macro.item,
									        	macro.gasto/mp.viviendas as gasto,
									        	macro.por_gastar/mp.viviendas as por_gastar, 
									        	macro.number_row,
									        	mp.nombre_proyecto
									        from (
										        SELECT 
											        apgi.obra,
											        apgi.Partida AS item,
											        ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
											        ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
											        1 AS number_row
											    FROM
											        (SELECT DISTINCT 
											            apgi.obra, 
											            api.area_propuesta AS Nombre_Area, 
											            api.partida_propuesta AS Partida,
											            apgi.Recurso, 
											            apgi.Monto_Trabajo,
											            apgi.Monto_Gastado,
											            apgi.fecha_actualizacion
											        FROM avance_por_gastar_inmobiliaria apgi
											        INNER JOIN area_partida_inmobiliaria api 
											        ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
											        WHERE apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%') AS apgi
											    INNER JOIN 
											        (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
											    ON apgi.obra = actualizacion.obra
											    AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
											    AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
											    INNER JOIN item_uf AS iu
											    ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
											    WHERE apgi.Nombre_Area IS NOT NULL
											    GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
											    ) as macro inner join macro_proyectos mp 
											    on macro.obra = mp.macro
										   ) as macro inner join (select distinct hp.nombre_proyecto, hp.cantidad_viviendas
											from homologacion_proyectos hp, macro_proyectos mp
											where hp.nombre_proyecto = mp.nombre_proyecto) as viviendas
											on viviendas.nombre_proyecto = macro.nombre_proyecto
				        )
				    )
				) AS total
				INNER JOIN beneficio_iva_inmobiliaria bii
				ON total.obra = bii.cc AND total.item = bii.ITEM
				GROUP BY total.obra, total.item, total.number_row, bii.ceec    
		    ) AS item_total
		    GROUP BY item_total.obra
		) AS item
		INNER JOIN homologacion_proyectos hp
		ON item.obra = hp.auranet_inmobiliaria

	) union
	-- ------------------------------------------- Calculo  IVA ------------------------------------------------------------------------
	(
		SELECT 
		    hp.nombre_proyecto,
		    item.obra, 
		    item.item,
		    item.gasto,
		    item.por_gastar,
		    item.number_row,
		    'DP' AS tipo
		FROM
		(
		    SELECT 
		        item_total.obra,
		        'IVA 19%' AS item,
		        ROUND(SUM(item_total.gasto) * 0.19, 2) AS gasto,
		        ROUND(SUM(item_total.por_gastar) * 0.19, 2) AS por_gastar,
		        4 AS number_row
		    FROM
		    (
		    SELECT 
				    total.obra, 
				    total.item, 
				    SUM(total.gasto) AS gasto, 
				    SUM(por_gastar) AS por_gastar, 
				    total.number_row
				FROM 
				(
				    -- Primera subconsulta
				    (
				    	(
					        SELECT 
					            apgi.obra,
					            apgi.Partida AS item,
					            ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
					            ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
					            2 AS number_row
					        FROM
					            (SELECT DISTINCT
					                apgi.obra, 
					                api.area_propuesta AS Nombre_Area, 
					                api.partida_propuesta AS Partida,
					                apgi.Recurso, 
					                apgi.Monto_Trabajo,
					                apgi.Monto_Gastado,
					                apgi.fecha_actualizacion
					            FROM avance_por_gastar_inmobiliaria apgi
					            INNER JOIN area_partida_inmobiliaria api 
					            ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
					            ) AS apgi
					        INNER JOIN 
					            (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
					        ON apgi.obra = actualizacion.obra
					        AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
					        AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
					        INNER JOIN item_uf AS iu
					        ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
					        WHERE apgi.Nombre_Area IS NOT NULL
					        AND apgi.obra LIKE '%DP%'
					        GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
				        )
				        UNION 
				        ( 
					        select 
								        	macro.obra,
								        	macro.item,
								        	macro.gasto*viviendas.cantidad_viviendas as gasto,
								        	macro.por_gastar*viviendas.cantidad_viviendas as por_gastar,
								        	macro.number_row
								        FROM 
								        (
									        select 
									        	macro.obra,
									        	macro.item,
									        	macro.gasto/mp.viviendas as gasto,
									        	macro.por_gastar/mp.viviendas as por_gastar, 
									        	macro.number_row,
									        	mp.nombre_proyecto
									        from (
										        SELECT 
											        apgi.obra,
											        apgi.Partida AS item,
											        ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
											        ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
											        1 AS number_row
											    FROM
											        (SELECT DISTINCT 
											            apgi.obra, 
											            api.area_propuesta AS Nombre_Area, 
											            api.partida_propuesta AS Partida,
											            apgi.Recurso, 
											            apgi.Monto_Trabajo,
											            apgi.Monto_Gastado,
											            apgi.fecha_actualizacion
											        FROM avance_por_gastar_inmobiliaria apgi
											        INNER JOIN area_partida_inmobiliaria api 
											        ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
											        WHERE apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%') AS apgi
											    INNER JOIN 
											        (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
											    ON apgi.obra = actualizacion.obra
											    AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
											    AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
											    INNER JOIN item_uf AS iu
											    ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
											    WHERE apgi.Nombre_Area IS NOT NULL
											    GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
											    ) as macro inner join macro_proyectos mp 
											    on macro.obra = mp.macro
										   ) as macro inner join (select distinct hp.nombre_proyecto, hp.cantidad_viviendas
											from homologacion_proyectos hp, macro_proyectos mp
											where hp.nombre_proyecto = mp.nombre_proyecto) as viviendas
											on viviendas.nombre_proyecto = macro.nombre_proyecto
				        )
				    )
				) AS total
				INNER JOIN beneficio_iva_inmobiliaria bii
				ON total.obra = bii.cc AND total.item = bii.ITEM
				GROUP BY total.obra, total.item, total.number_row
		        
		    ) AS item_total
		    GROUP BY item_total.obra
		) AS item
		INNER JOIN homologacion_proyectos hp
		ON item.obra = hp.auranet_inmobiliaria
	)
	union
	-- ------------------------------------------- Calculo Beneficio IVA ------------------------------------------------------------------------
	(
		select 
			hp.nombre_proyecto,
			item.obra, 
			item.item,
			item.gasto,
			item.por_gastar,
			item.number_row,
			'DP' as tipo
		from
		(
			select 
				item_total.obra,
				'Monto Menor Beneficio IVA Const' as item,
				round((sum(item_total.gasto)*0.19)*item_total.ceec,2) as gasto,
				round((sum(item_total.por_gastar)*0.19)*item_total.ceec,2) as por_gastar,
				5 as number_row
			from
			(
			SELECT 
				    total.obra, 
				    total.item, 
				    SUM(total.gasto) AS gasto, 
				    SUM(por_gastar) AS por_gastar, 
				    total.number_row, bii.ceec
				FROM 
				(
				    -- Primera subconsulta
				    (
				    	(
					        SELECT 
					            apgi.obra,
					            apgi.Partida AS item,
					            ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
					            ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
					            2 AS number_row
					        FROM
					            (SELECT DISTINCT
					                apgi.obra, 
					                api.area_propuesta AS Nombre_Area, 
					                api.partida_propuesta AS Partida,
					                apgi.Recurso, 
					                apgi.Monto_Trabajo,
					                apgi.Monto_Gastado,
					                apgi.fecha_actualizacion
					            FROM avance_por_gastar_inmobiliaria apgi
					            INNER JOIN area_partida_inmobiliaria api 
					            ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
					            ) AS apgi
					        INNER JOIN 
					            (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
					        ON apgi.obra = actualizacion.obra
					        AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
					        AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
					        INNER JOIN item_uf AS iu
					        ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
					        WHERE apgi.Nombre_Area IS NOT NULL
					        AND apgi.obra LIKE '%DP%'
					        GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
				        )
				        UNION 
				        ( 
					        select 
								        	macro.obra,
								        	macro.item,
								        	macro.gasto*viviendas.cantidad_viviendas as gasto,
								        	macro.por_gastar*viviendas.cantidad_viviendas as por_gastar,
								        	macro.number_row
								        FROM 
								        (
									        select 
									        	macro.obra,
									        	macro.item,
									        	macro.gasto/mp.viviendas as gasto,
									        	macro.por_gastar/mp.viviendas as por_gastar, 
									        	macro.number_row,
									        	mp.nombre_proyecto
									        from (
										        SELECT 
											        apgi.obra,
											        apgi.Partida AS item,
											        ROUND(SUM(apgi.Monto_Gastado) / NULLIF(iu.valor_actual_uf, 0), 2) AS gasto,
											        ROUND((SUM(apgi.Monto_Trabajo) - SUM(apgi.Monto_Gastado)) / NULLIF(iu.valor_pendiente_uf, 0), 2) AS por_gastar,
											        1 AS number_row
											    FROM
											        (SELECT DISTINCT 
											            apgi.obra, 
											            api.area_propuesta AS Nombre_Area, 
											            api.partida_propuesta AS Partida,
											            apgi.Recurso, 
											            apgi.Monto_Trabajo,
											            apgi.Monto_Gastado,
											            apgi.fecha_actualizacion
											        FROM avance_por_gastar_inmobiliaria apgi
											        INNER JOIN area_partida_inmobiliaria api 
											        ON api.obra = apgi.obra AND apgi.Recurso = api.Nombre_Recurso
											        WHERE apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%') AS apgi
											    INNER JOIN 
											        (select 
					 apgi.obra,
					 FORMAT(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), MONTH(DATEADD(MONTH, -1, apgi.fecha_actualizacion)), 1), 'yyyy-MM-dd') as fecha_actualizacion
					from(
					select apgi.obra, 
						MAX(CONVERT(date, apgi.fecha_actualizacion)) as fecha_actualizacion 
					from avance_por_gastar_inmobiliaria apgi
					group by apgi.obra
					) as apgi) AS actualizacion
											    ON apgi.obra = actualizacion.obra
											    AND YEAR(apgi.fecha_actualizacion) = YEAR(actualizacion.fecha_actualizacion)
											    AND MONTH(apgi.fecha_actualizacion) = MONTH(actualizacion.fecha_actualizacion)
											    INNER JOIN item_uf AS iu
											    ON apgi.obra = iu.CC AND iu.ITEM = apgi.Partida
											    WHERE apgi.Nombre_Area IS NOT NULL
											    GROUP BY apgi.obra, apgi.Partida, iu.valor_actual_uf, iu.valor_pendiente_uf
											    ) as macro inner join macro_proyectos mp 
											    on macro.obra = mp.macro
										   ) as macro inner join (select distinct hp.nombre_proyecto, hp.cantidad_viviendas
											from homologacion_proyectos hp, macro_proyectos mp
											where hp.nombre_proyecto = mp.nombre_proyecto) as viviendas
											on viviendas.nombre_proyecto = macro.nombre_proyecto
				        )
				    )
				) AS total
				INNER JOIN beneficio_iva_inmobiliaria bii
				ON total.obra = bii.cc AND total.item = bii.ITEM
				GROUP BY total.obra, total.item, total.number_row, bii.ceec
			) as item_total
			group by item_total.obra, item_total.CEEC
		)   as item
		inner join homologacion_proyectos hp on
		item.obra = hp.auranet_inmobiliaria
	) 
	union
	-- ------------------------------------------- INGRESOS ------------------------------------------------------------------------
	(
		select 
			escrituras.nombre_proyecto,
			escrituras.nombre_proyecto as obra,
			'Ingresos Neto' as item,
			round(((((ingreso_esperado.ingreso_bruto-ingreso_esperado.costo_total)/1.19)+
			ingreso_esperado.costo_total)/escrituras.numero_viviendas)*escrituras.escrituradas,0) as gasto,
			round(((((ingreso_esperado.ingreso_bruto-ingreso_esperado.costo_total)/1.19)+
			ingreso_esperado.costo_total)/escrituras.numero_viviendas)*escrituras.por_escriturar,0) as por_gastar,
			ingreso_esperado.number_row,
			'PR' as tipo
		from
		(select 
			fie.etapa as obra,
			fie.ingreso_bruto,
			fie.avance,
			fie.costo_total,
			0 as number_row
		FROM 
		(select etapa, CONVERT(VARCHAR, MAX(fecha), 23) as fecha 
		from finanzas_ingresos_esperados fie group by etapa) as fecha_max,
		finanzas_ingresos_esperados as fie 
		where fie.etapa = fecha_max.etapa and CONVERT(VARCHAR,fie.fecha,23) = fecha_max.fecha
		) as ingreso_esperado,
			(select 
				ip.nombre_proyecto,
				ps.etapa,
				ip.numero_viviendas,
				case when ip.numero_viviendas-sum(escrituracion.cantidad) < 0 then ip.numero_viviendas
				else sum(escrituracion.cantidad)
				end as escrituradas,
				case when ip.numero_viviendas-sum(escrituracion.cantidad) < 0 then ip.numero_viviendas
				else ip.numero_viviendas-sum(escrituracion.cantidad)
				end as por_escriturar
			from
			(
				(
				select 
					proyecto, 
					etapa, 
					subagrupacion,
					estado_actual, 
					convert(varchar, concat(year(fecha),'-', month(fecha),'-01'),23) as fecha,
					count(*) as cantidad
				from reporte_comercial_ventas rcv
				where rcv.estado_actual like 'ESCRITURADO'
				group by proyecto, etapa, subagrupacion, estado_actual, year(fecha), month(fecha)
				)
				union 
				(
				SELECT 
				    rcv.proyecto,
				    rcv.etapa,
				    rcv.subagrupacion,
				    'ESCRITURADO' AS estado_actual,
				    CONVERT(VARCHAR, CONCAT(YEAR(GETDATE()), '-', MONTH(GETDATE()), '-01'), 23) AS fecha,
				    0 AS cantidad
				FROM 
				    reporte_comercial_ventas rcv
				LEFT JOIN 
				    (
				        SELECT 
				            DISTINCT
				            proyecto, 
				            etapa, 
				            subagrupacion
				        FROM 
				            reporte_comercial_ventas
				        WHERE 
				            estado_actual LIKE 'ESCRITURADO'
				    ) AS escriturado
				ON 
				    escriturado.proyecto = rcv.proyecto AND
				    escriturado.etapa = rcv.etapa AND 
				    escriturado.subagrupacion = rcv.subagrupacion
				WHERE 
				    escriturado.proyecto IS NULL AND 
				    escriturado.etapa IS NULL AND 
				    escriturado.subagrupacion IS NULL
				GROUP BY 
				    rcv.proyecto, 
				    rcv.etapa, 
				    rcv.subagrupacion
				)
			) as escrituracion
			inner join proyecto_subagrupacion ps 
			on ps.proyecto = escrituracion.proyecto and ps.etapa = escrituracion.etapa 
			and ps.subagrupacion = escrituracion.subagrupacion
			inner join informacion_proyectos ip on ps.nombre_proyecto = ip.nombre_proyecto
			group by ip.nombre_proyecto,
				ps.etapa,
				ip.numero_viviendas
		) as escrituras
		where escrituras.nombre_proyecto = ingreso_esperado.obra
	) 
	union
	(
		select 
			escrituras.nombre_proyecto,
			escrituras.nombre_proyecto as obra,
			'Ingresos Bruto' as item,
			round(((((ingreso_esperado.ingreso_bruto-ingreso_esperado.costo_total))+
			ingreso_esperado.costo_total)/escrituras.numero_viviendas)*escrituras.escrituradas,0) as gasto,
			round(((((ingreso_esperado.ingreso_bruto-ingreso_esperado.costo_total))+
			ingreso_esperado.costo_total)/escrituras.numero_viviendas)*escrituras.por_escriturar,0) as por_gastar,
			ingreso_esperado.number_row,
			'PR' as tipo
		from
		(select 
			fie.etapa as obra,
			fie.ingreso_bruto,
			fie.avance,
			fie.costo_total,
			0 as number_row
		FROM 
		(select etapa, CONVERT(VARCHAR, MAX(fecha), 23) as fecha 
		from finanzas_ingresos_esperados fie group by etapa) as fecha_max,
		finanzas_ingresos_esperados as fie 
		where fie.etapa = fecha_max.etapa and CONVERT(VARCHAR,fie.fecha,23) = fecha_max.fecha
		) as ingreso_esperado,
			(select 
				ip.nombre_proyecto,
				ps.etapa,
				ip.numero_viviendas,
				case when ip.numero_viviendas-sum(escrituracion.cantidad) < 0 then ip.numero_viviendas
				else sum(escrituracion.cantidad)
				end as escrituradas,
				case when ip.numero_viviendas-sum(escrituracion.cantidad) < 0 then ip.numero_viviendas
				else ip.numero_viviendas-sum(escrituracion.cantidad)
				end as por_escriturar
			from
			(
				(
				select 
					proyecto, 
					etapa, 
					subagrupacion,
					estado_actual, 
					convert(varchar, concat(year(fecha),'-', month(fecha),'-01'),23) as fecha,
					count(*) as cantidad
				from reporte_comercial_ventas rcv
				where rcv.estado_actual like 'ESCRITURADO'
				group by proyecto, etapa, subagrupacion, estado_actual, year(fecha), month(fecha)
				)
				union 
				(
				SELECT 
				    rcv.proyecto,
				    rcv.etapa,
				    rcv.subagrupacion,
				    'ESCRITURADO' AS estado_actual,
				    CONVERT(VARCHAR, CONCAT(YEAR(GETDATE()), '-', MONTH(GETDATE()), '-01'), 23) AS fecha,
				    0 AS cantidad
				FROM 
				    reporte_comercial_ventas rcv
				LEFT JOIN 
				    (
				        SELECT 
				            DISTINCT
				            proyecto, 
				            etapa, 
				            subagrupacion
				        FROM 
				            reporte_comercial_ventas
				        WHERE 
				            estado_actual LIKE 'ESCRITURADO'
				    ) AS escriturado
				ON 
				    escriturado.proyecto = rcv.proyecto AND
				    escriturado.etapa = rcv.etapa AND 
				    escriturado.subagrupacion = rcv.subagrupacion
				WHERE 
				    escriturado.proyecto IS NULL AND 
				    escriturado.etapa IS NULL AND 
				    escriturado.subagrupacion IS NULL
				GROUP BY 
				    rcv.proyecto, 
				    rcv.etapa, 
				    rcv.subagrupacion
				)
			) as escrituracion
			inner join proyecto_subagrupacion ps 
			on ps.proyecto = escrituracion.proyecto and ps.etapa = escrituracion.etapa 
			and ps.subagrupacion = escrituracion.subagrupacion
			inner join informacion_proyectos ip on ps.nombre_proyecto = ip.nombre_proyecto
			group by ip.nombre_proyecto,
				ps.etapa,
				ip.numero_viviendas
		) as escrituras
		where escrituras.nombre_proyecto = ingreso_esperado.obra
	) 
 ) as eerr_actual
 )
 union
 (select 
	proyecto as Proyecto,
	proyecto as obra,
	'COSTO TERRENO' as item,
	gasto,
	ctoterreno-gasto as por_gastar,
	gasto+(ctoterreno-gasto) as total,
	1 as number_row,
	'DP' as tipo
from finanzas_costos_terrenos)
;