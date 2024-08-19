
select 
	hp.nombre_proyecto,
	velventas.cantidad,
	velventas.meses,
	velventas.velocidad
from (
	select 
		rcv.proyecto, 
		rcv.etapa, 
		rcv.subagrupacion, 
		count(*) as cantidad,
		meses.meses,
		(count(*)*1.0)/meses as velocidad
	from reporte_comercial_ventas rcv,
	(select 
		proyecto, 
		etapa, 
		subagrupacion, 
		min(fecha) as fecha_min, 
		max(fecha) as fecha_max, 
		DATEDIFF(MONTH, min(fecha), max(fecha)) as meses,
		SUM(cantidad) as cantidad
	from 
		(
			(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
			from reporte_comercial_ventas rcv 
			where rcv.estado_actual like 'RESERVADO'
			group by proyecto, etapa, subagrupacion, fecha, estado_actual)
		union
			(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
			from reporte_comercial_ventas rcv 
			where rcv.estado_actual like 'PROMESA'
			group by proyecto, etapa, subagrupacion, fecha, estado_actual)
		union
			(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
			from reporte_comercial_ventas rcv 
			where rcv.estado_actual like 'ESCRITURADO'
			group by proyecto, etapa, subagrupacion, fecha, estado_actual)
		union
			(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
			from reporte_comercial_ventas rcv 
			where rcv.estado_actual like 'CANCELADO'
			group by proyecto, etapa, subagrupacion, fecha, estado_actual)
		) as estado
	group by proyecto, etapa, subagrupacion) AS meses 
	where meses.proyecto = rcv.proyecto and meses.etapa = rcv.etapa and meses.subagrupacion = rcv.subagrupacion
	and rcv.estado_actual in ('PROMESA', 'ESCRITURADO')
	group by rcv.proyecto, rcv.etapa, rcv.subagrupacion, meses.meses
) as velventas inner join homologacion_proyectos hp 
on velventas.proyecto = hp.proyecto_ventas and velventas.etapa = hp.etapa_ventas  and velventas.subagrupacion =hp.subagrupacion_ventas 
;



SELECT distinct
	--INFORMACION.*, 
	INFORMACION.Obra,
	INFORMACION.Recurso,
	INFORMACION.UM,
	round(INFORMACION.Cantidad_Original,0) as cantidad_original,
	round(INFORMACION.Precio_Original,0) as precio_original,
	round(INFORMACION.Monto_Original,0) as monto_original,
	round(INFORMACION.Cantidad_Trabajo,0) as cantidad_trabajo,
	round(INFORMACION.Precio_Trabajo,0) as precio_trabajo,
	round(INFORMACION.Monto_Trabajo,0) as monto_trabajo,
	round(INFORMACION.Cantidad_Gastada,0) as cantidad_gastada,
	round(INFORMACION.Monto_Gastado,0) as gasto
FROM
(
	(
		SELECT ao.Obra as Obra,  MAX(Ano.Ano) as Ano, MAX(mes_num.Mes_num) as mes_num, 'ultimo' as Clasificacion
		FROM AVANCE_OBRAS ao, ( select distinct ao.Mes,
			CASE 
				WHEN ao.Mes LIKE 'ENERO%' THEN 1
				WHEN ao.Mes LIKE 'FEBRERO%' THEN 2
				WHEN ao.Mes LIKE 'MARZO%' THEN 3
				WHEN ao.Mes LIKE 'ABRIL%' THEN 4
				WHEN ao.Mes LIKE 'MAYO%' THEN 5
				WHEN ao.Mes LIKE 'JUNIO%' THEN 6
				WHEN ao.Mes LIKE 'JULIO%' THEN 7
				WHEN ao.Mes LIKE 'AGOSTO%' THEN 8
				WHEN ao.Mes LIKE 'SEPTIEMBRE%' THEN 9
				WHEN ao.Mes LIKE 'OCTUBRE%' THEN 10
				WHEN ao.Mes LIKE 'NOVIEMBRE%' THEN 11
				WHEN ao.Mes LIKE 'DICIEMBRE%' THEN 12
				ELSE 0
			END as Mes_num
		from AVANCE_OBRAS ao) as mes_num, 
		(
		select distinct ao.Obra, Max(ao.Ano) as Ano
		from AVANCE_OBRAS ao
		group by ao.Obra
		) as ano
		where ao.Mes = mes_num.Mes and Ano.Ano = ao.Ano and Ano.Obra = ao.Obra
		group by ao.Obra, Ano.Ano
	)
) AS FECHA INNER JOIN 
(
select ao.*, mes_num.Mes_num 
from (
select distinct ao.Mes,
	CASE 
		WHEN ao.Mes LIKE 'ENERO%' THEN 1
		WHEN ao.Mes LIKE 'FEBRERO%' THEN 2
		WHEN ao.Mes LIKE 'MARZO%' THEN 3
		WHEN ao.Mes LIKE 'ABRIL%' THEN 4
		WHEN ao.Mes LIKE 'MAYO%' THEN 5
		WHEN ao.Mes LIKE 'JUNIO%' THEN 6
		WHEN ao.Mes LIKE 'JULIO%' THEN 7
		WHEN ao.Mes LIKE 'AGOSTO%' THEN 8
		WHEN ao.Mes LIKE 'SEPTIEMBRE%' THEN 9
		WHEN ao.Mes LIKE 'OCTUBRE%' THEN 10
		WHEN ao.Mes LIKE 'NOVIEMBRE%' THEN 11
		WHEN ao.Mes LIKE 'DICIEMBRE%' THEN 12
		ELSE 0
	END as Mes_num
from AVANCE_OBRAS ao) as mes_num, AVANCE_OBRAS as ao
where mes_num.Mes =  ao.Mes) AS INFORMACION
on INFORMACION.Obra = FECHA.Obra AND INFORMACION.Ano = FECHA.Ano AND INFORMACION.Mes_num = FECHA.mes_num
WHERE INFORMACION.Nombre_Area NOT IN ('UTILIDAD', 'IVA', 'COSTO_INDIRECTO') AND INFORMACION.Ano >= 2023
and INFORMACION.Recurso like '%ASISTENTE BODEGA%' OR INFORMACION.Recurso like '%JEFE DE BODEGA%'
OR INFORMACION.Recurso like '%PAÑOLERO%'
order by INFORMACION.Obra, INFORMACION.Recurso asc;


select valor_uf.uf, CONVERT(VARCHAR, EOMONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, -2, GETDATE())), 1)), 103) as fecha,
CONVERT(VARCHAR, EOMONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, -2, GETDATE())), MONTH(DATEADD(MONTH, -2, GETDATE())), 1)), 105) as fecha_nombre
from
(
select max(vu.precio_uf) as uf
from VALOR_UF vu 
WHERE vu.fecha < DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)
) as valor_uf



;




select 
	concat(info.mes_actual_texto,'_',ano_actual) as ultimo_avance,
	concat(info.ultimo_mes,'_',ano_anterior) as avance_previo
from
(SELECT 
	YEAR(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) AS ano_Actual,
	YEAR(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1))-1 AS ano_anterior,
	case 
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 1 then 'ene'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 2 then 'feb'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 3 then 'mar'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 4 then 'abr'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 5 then 'may'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 6 then 'jun'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 7 then 'jul'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 8 then 'ago'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 9 then 'sep'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 10 then 'oct'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 11 then 'nov'
		when MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) = 12 then 'dic'
	end as mes_actual_texto,
	MONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1)) as mes_actual,
	'dic' as ultimo_mes
) as info;


select  CONVERT(VARCHAR, EOMONTH(DATEFROMPARTS(YEAR(DATEADD(MONTH, -1, GETDATE())), MONTH(DATEADD(MONTH, -1, GETDATE())), 1)), 103);



SELECT g.cuenta, g.nombre, 
	case when g.cresultado is null then 'ADMINISTRACION'
		 when g.cresultado = 'STRIPCENTER' then 'TDM.69.DP'
	ELSE g.cresultado END as cresultado, 
  	sum(g.Diferencia)*-1 as diferencia, 
  	g.nomCResultado
    FROM gastos_finanzas g 
    where g.nomCResultado != 'CONSTRUCTORA' and  g.nomCResultado like '%LAGOS%' AND
    g.ano >=2024 AND g.fecha < DATEFROMPARTS(YEAR(DATEADD(MONTH, 0, GETDATE())), MONTH(DATEADD(MONTH, 0, GETDATE())), 1) 
GROUP BY g.cuenta, g.nombre, g.cresultado, g.nomCResultado