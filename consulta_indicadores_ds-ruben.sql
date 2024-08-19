/*
CREATE TABLE consolidado_indicadores_ds (
    obra NVARCHAR(255),  -- Asumiendo un tamaño máximo de 255 caracteres para el texto
    adicionales FLOAT,
    diferencia FLOAT,
    ganancia_correccion FLOAT,
    avance_plataforma FLOAT,
    porcentaje_material FLOAT,
    porcentaje_subcontrato FLOAT,
    gasto FLOAT,
    ingresos FLOAT,
    diferencia_ingresos_gasto FLOAT,
    monto_contrato FLOAT,
    porcentaje_ingreso FLOAT,
    partidas_aprobadas FLOAT,
    partidas_cerradas FLOAT,
    valor_uf_m2_original FLOAT,
    valor_uf_m2_real FLOAT,
    variacion_uf float,  -- Computed column
    avance_informado FLOAT,
    ppto_trabajo_mo_directa FLOAT,
    monto_digitado_acum FLOAT,
    porcentaje_ppto_tratos FLOAT,
    porcentaje_gastos_generales FLOAT,
    ritmo_sem_prom float,
	p_e float,
	 cumplimineto float,
	ITE float,
	p_c float,
	p_e_4s float,
    fecha_actualizacion DATE  -- Asumiendo que es una fecha, cambiar si es necesario
);
*/
delete from consolidado_indicadores_ds;
INSERT INTO consolidado_indicadores_ds (
    obra,
    adicionales,
    diferencia,
    ganancia_correccion,
    avance_plataforma,
    porcentaje_material,
    porcentaje_subcontrato,
    gasto,
    ingresos,
    diferencia_ingresos_gasto,
    monto_contrato,
    porcentaje_ingreso,
    partidas_aprobadas,
    partidas_cerradas,
    valor_uf_m2_original,
    valor_uf_m2_real,
    variacion_uf,
    avance_informado,
    ppto_trabajo_mo_directa,
    monto_digitado_acum,
    porcentaje_ppto_tratos,
    porcentaje_gastos_generales,
    ritmo_sem_prom,
	p_e,
	 cumplimineto,
	ITE,
	p_c ,
	p_e_4s ,
    fecha_actualizacion
)
select 
	info_obra.obra,
	info_obra.adicionales,
	info_obra.diferencia,
	info_obra.ganancia_correccion,
	avance_app.avance_plataforma,
	indicadores.porcentaje_material,
	indicadores.porcentaje_subcontrato,
	contable.gasto,
	contable.Ingresos as ingresos,
	contable.diferencia_ingresos_gasto,
	contable.monto_contrato,
	contable.porcentaje_ingreso,
	estado_partidas.PorcentajeAprobadas as partidas_aprobadas,
	estado_partidas.PorcentajeCerradas as partidas_cerradas,
	m2.valor_uf_m2_original,
	m2.valor_uf_m2_real,
	(((m2.valor_uf_m2_real - m2.valor_uf_m2_original) / m2.valor_uf_m2_original) * 1.0) as variacion_uf,
	ai.avance as avance_informado,
	tratos.Ppto_Trab_MO_Directa as ppto_trabajo_mo_directa,
   	tratos.Monto_Digitado_Acum as monto_digitado_acum,
    tratos.Porcentaje_Ppto as porcentaje_ppto_tratos,
    gastos_generales.porcentaje_gastos_generales,
    indicadores_app.ritmo_sem_prom,
	indicadores_app.p_e,
	indicadores_app.cumplimineto,
	indicadores_app.ITE,
	indicadores_app.p_c ,
	indicadores_app.p_e_4s ,
    estado_partidas.fecha_actualizacion
from 
	(select 
		iod.OBRA as obra,
		iod.ADICIONALES as adicionales,
		iod.DIFERENCIA as diferencia,
		iod.GANANCIA as ganancia_correccion
	from INFORMACION_OBRA_DS iod) as info_obra
inner join 
(
-- % cierre subcontrato y compras de materiales
select 
	indicador_material.Obra,
	indicador_material.porcentaje as porcentaje_material,
	indicador_subcontrato.porcentaje as porcentaje_subcontrato
from
(select 
	indicadores.Obra, 
	indicadores.TipoCosto,
	max(indicadores.Fecha) as Fecha, 
	round(indicadores.Porcentaje,2) as porcentaje
from
(select  
	gc.Obra,	
	gc.Fecha, 
	rv.TipoCosto, 
	SUM(gc.T_comprado) as Comprado, 
	SUM(gc.T_PorComprar) as Por_Comprar, 
	SUM(gc.T_comprado)/(SUM(gc.T_comprado)+SUM(gc.T_PorComprar)) as 'Porcentaje'
from GCV1 as gc
inner join recursos_vf rv on gc.Codigo_std = rv.Codigo_rec, 
(
	select GCV1.Obra, MAX(GCV1.Fecha) as fecha
	from GCV1
	group by GCV1.Obra	
) as fecha_max
where 
fecha_max.Obra = gc.Obra and fecha_max.fecha = gc.Fecha and
rv.TipoCosto IN ('Material','Subcontrato', 'Maquinaria', 'Herramienta') 
group by gc.Obra, gc.Fecha, rv.TipoCosto
) as indicadores
where indicadores.TipoCosto in ('Material')
group by indicadores.Obra, indicadores.TipoCosto, indicadores.Porcentaje) as indicador_material
inner join
(select 
	indicadores.Obra, 
	indicadores.TipoCosto,
	max(indicadores.Fecha) as Fecha, 
	round(indicadores.Porcentaje,2) as porcentaje
from
(select  
	gc.Obra,	
	gc.Fecha, 
	rv.TipoCosto, 
	SUM(gc.T_comprado) as Comprado, 
	SUM(gc.T_PorComprar) as Por_Comprar, 
	SUM(gc.T_comprado)/(SUM(gc.T_comprado)+SUM(gc.T_PorComprar)) as 'Porcentaje'
from GCV1 as gc
inner join recursos_vf rv on gc.Codigo_std = rv.Codigo_rec, 
(
	select GCV1.Obra, MAX(GCV1.Fecha) as fecha
	from GCV1
	group by GCV1.Obra	
) as fecha_max
where 
fecha_max.Obra = gc.Obra and fecha_max.fecha = gc.Fecha and
rv.TipoCosto IN ('Material','Subcontrato', 'Maquinaria', 'Herramienta') 
group by gc.Obra, gc.Fecha, rv.TipoCosto
) as indicadores
where indicadores.TipoCosto in ('Subcontrato')
group by indicadores.Obra, indicadores.TipoCosto, indicadores.Porcentaje) as indicador_subcontrato
on indicador_material.Obra = indicador_subcontrato.Obra) as indicadores 
on indicadores.Obra = info_obra.obra
inner join 
-- GASTO CONTABLE 
(select 
	gasto.Obra as obra, 
	gasto.gasto, 
	ingresos.Ingresos, 
	ingresos.Ingresos-gasto.gasto as diferencia_ingresos_gasto,
	vco.Monto_UF as monto_contrato,
	case when ingresos.ingreso_uf/vco.Monto_UF > 1 then 1
	else ingresos.ingreso_uf/vco.Monto_UF 
	end as porcentaje_ingreso
from 
( 
	SELECT 
		CASE WHEN CUENTA.nomCResultado LIKE '2022.AJ' THEN 'AJ.I'
		WHEN CUENTA.nomCResultado LIKE '2022.EAJ' THEN 'EA.J'
		WHEN CUENTA.nomCResultado LIKE 'E.AJI' THEN 'M.EAJ'
		ELSE CUENTA.nomCResultado 
		end as Obra,
		sum(CUENTA.Monto_Gastado) as gasto
	FROM
	(
	SELECT 
		g.nomCResultado,
		YEAR(g.fechadoc) as Ano, 
		MONTH(g.fechadoc) as Mes_num, 
		sum(g.Diferencia) as Monto_Gastado,
		ROW_NUMBER() over(order by YEAR(g.fechadoc), MONTH(g.fechadoc) asc) as row_count
	FROM Gastos g 
	where g.nombre NOT LIKE 'INGRESOS POR OBRA' and g.glosa not like '%PROVISIONES%'
	GROUP BY g.nomCResultado, YEAR(g.fechadoc), MONTH(g.fechadoc)
	) AS CUENTA
	group by CUENTA.nomCResultado
) as gasto inner join 
(
select ingresos.Obra,
	sum(ingresos.Ingresos) as Ingresos,
	round(sum(ingresos.Ingresos/vu.precio_uf),2) as ingreso_uf
from
(
Select  
	CASE WHEN g.nomCResultado LIKE '2022.AJ' THEN 'AJ.I'
		WHEN g.nomCResultado LIKE '2022.EAJ' THEN 'EA.J'
		WHEN g.nomCResultado LIKE 'E.AJI' THEN 'M.EAJ'
		ELSE g.nomCResultado 
		end as Obra, 
	g.fecha,
	sum(g.diferencia)*-1 as Ingresos
from Gastos g
where g.nombre like '%INGRESOS POR OBRA%'
GROUP BY g.nomCResultado, g.fecha 
)
as ingresos inner join VALOR_UF vu on year(vu.fecha) = year(ingresos.fecha)
and month(vu.fecha) = month(ingresos.fecha)
group by ingresos.Obra
) as ingresos on ingresos.Obra = gasto.Obra
INNER JOIN (select case when vco.Obra = 'E.EAJ' 
then 'M.EAJ' ELSE vco.Obra end as Obra,vco.Monto_UF  from Valor_contrato_obras vco) vco on vco.Obra = gasto.Obra
) as contable
on contable.obra = info_obra.obra
inner join 
-- Estado de inicio de partidas
(SELECT 
    op.Obra as obra,
    op.Trabajo as trabajo,
    COUNT(*) AS TotalPartidas,
    SUM(CASE WHEN pp.EstadoAprobado = 'Aprobado' THEN 1 ELSE 0 END) AS TotalAprobadas,
    SUM(CASE WHEN pp.EstadoAprobado = 'Aprobado' THEN 1 ELSE 0 END)*1.0 / COUNT(*) AS PorcentajeAprobadas,
    SUM(CASE WHEN pp.Estado = 'Cerrada' THEN 1 ELSE 0 END) AS TotalCerradas,
    SUM(CASE WHEN pp.Estado = 'Cerrada' THEN 1 ELSE 0 END)*1.0 / COUNT(*) AS PorcentajeCerradas,
    pp.fecha_actualizacion 
FROM  partidasPpto pp inner JOIN obra_ppto op ON pp.NumPresupuesto = op.Trabajo
inner JOIN 
    (
        SELECT 
            NumPresupuesto,
            MAX(fecha_actualizacion) AS UltimaFecha
        FROM 
            partidasPpto
        GROUP BY 
            NumPresupuesto
    ) AS UltimaActualizacion ON pp.NumPresupuesto = UltimaActualizacion.NumPresupuesto 
    AND pp.fecha_actualizacion = UltimaActualizacion.UltimaFecha
GROUP BY 
    op.Obra,
    op.Trabajo,
    pp.fecha_actualizacion
) as estado_partidas
on estado_partidas.obra = info_obra.obra
inner join 
(


select 
	m2.Obra as obra,
	m2.valor_uf_m2_original,
	m2.valor_uf_m2_real
FROM 
(SELECT 
	m2.Obra, 
	m2.Fecha, 
	m2.valor_uf_m2_original, 
	m2.valor_uf_m2_real
FROM 
(
	select 
		diferencia.Obra, 
		convert(varchar(10), concat(diferencia.Ano,'-',diferencia.Mes_Num,'-01'), 121) as Fecha,
		round(vcontrato.Monto_UF/om.m2, 2) as valor_uf_m2_original,
		round((vcontrato.Monto_UF - (diferencia.dif/vcontrato.Valor_UF_Contrato))/om.m2,2) as valor_uf_m2_real
	from 
	(
		select 
			ao.Obra, 
			ao.Ano, 
			mes_num.Mes_num, 
			sum(ao.Diferencia) as dif
		from AVANCE_OBRAS ao, ( select distinct ao.Mes,
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
		from AVANCE_OBRAS ao) as mes_num
		where mes_num.Mes = ao.Mes 
		group by ao.Obra, ao.Ano, mes_num.Mes_num
	) as diferencia inner join (select vco.Obra, vco.Monto_UF, vco.Valor_UF_Contrato 
	from Valor_contrato_obras vco) as vcontrato on vcontrato.Obra = diferencia.Obra
	inner join obra_m2 om on om.Obra = vcontrato.Obra
) AS m2
) as m2, (select datos.Obra, max(Fecha) as fecha
FROM 
(SELECT 
	m2.Obra, 
	m2.Fecha, 
	m2.valor_uf_m2_original, 
	m2.valor_uf_m2_real
FROM 
(
	select 
		diferencia.Obra, 
		convert(varchar(10), concat(diferencia.Ano,'-',diferencia.Mes_Num,'-01'), 121) as Fecha,
		round(vcontrato.Monto_UF/om.m2, 2) as valor_uf_m2_original,
		round((vcontrato.Monto_UF - (diferencia.dif/vcontrato.Valor_UF_Contrato))/om.m2,2) as valor_uf_m2_real
	from 
	(
		select 
			ao.Obra, 
			ao.Ano, 
			mes_num.Mes_num, 
			sum(ao.Diferencia) as dif
		from AVANCE_OBRAS ao, ( select distinct ao.Mes,
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
		from AVANCE_OBRAS ao) as mes_num
		where mes_num.Mes = ao.Mes 
		group by ao.Obra, ao.Ano, mes_num.Mes_num
	) as diferencia inner join (select vco.Obra, vco.Monto_UF, vco.Valor_UF_Contrato 
	from Valor_contrato_obras vco) as vcontrato on vcontrato.Obra = diferencia.Obra
	inner join obra_m2 om on om.Obra = vcontrato.Obra
) AS m2
) as datos
group by datos.Obra) as fecha
where fecha.Obra = m2.Obra and fecha.fecha = m2.Fecha


) as m2 on m2.obra = info_obra.obra
inner join 
(select obra, avance from avance_informado ai) as ai
on ai.obra = info_obra.obra
inner join
(
SELECT 
    g.Fecha,
    g.obra,
    g.Ppto_Trab_MO_Directa,
    tc.Total AS Monto_Digitado_Acum ,
    CASE 
        WHEN g.Ppto_Trab_MO_Directa <> 0 THEN tc.Total / g.Ppto_Trab_MO_Directa
        ELSE 0
    END AS Porcentaje_Ppto
FROM (
    SELECT 
        g.Fecha,
        g.Obra,
        SUM(g.T_Trabajo) AS Ppto_Trab_MO_Directa
    FROM GCV1 g
    WHERE g.Clase3 = 'Mano de obra directa'
      AND g.Fecha = (
          SELECT MAX(sub.Fecha)
          FROM GCV1 sub
          WHERE sub.Obra = g.Obra
            AND sub.Clase3 = 'Mano de obra directa'
      )
    GROUP BY 
        g.Fecha,
        g.Obra
) AS g
INNER JOIN (
select tc_agrupado.obra, SUM(Total) as Total
from(
    SELECt 
	tc.Obra ,
	tc.NroTratoObra ,
	tc.FEmision ,
	tc.Recibe ,
	tc.cuadrilla ,
	tc.NombrePartida ,
	tc.semana ,
	--tc.Ubicacion ,
	tc.Nombre ,
	tc.NombreRecurso ,
	MAX(tc.Cantidad_y*tc.Precio_y) as 'Total'
from tratos_calculados tc 
group by Obra , NroTratoObra ,FEmision , Recibe , cuadrilla , NombrePartida , semana , Nombre , NombreRecurso ) as tc_agrupado
group by tc_agrupado.obra
) AS tc
ON g.Obra = tc.Obra
) as tratos
on tratos.obra = info_obra.obra
inner join 
(
select 
	datos.Obra as obra, 
	datos.porcentaje as porcentaje_gastos_generales
from
(
select fecha.obra, max(fecha.fecha) as fecha
from
(select 
	info.Obra,
	info.Ano,
	info.Mes_num,
	info.Monto_Gastado - coalesce(lag(info.Monto_Gastado) over (order by info.row_count asc), 0) as Descarga_Remuneraciones,
	info.Monto_Original,
	info.Monto_Gastado,
	info.Monto_Trabajo,
	info.Monto_Gastado/info.Monto_Trabajo as porcentaje,
	info.row_count AS N_aparicion,
	CONVERT (date, concat('01','-',info.Mes_num,'-',info.Ano), 103) as fecha
from
(
select 
	ao.Obra,
	ao.Ano,
	mes_num.Mes_num,
	ROUND(SUM(ao.Monto_Original), 2) AS Monto_Original, 
	ROUND(SUM(ao.Monto_Trabajo), 2) AS Monto_Trabajo, 
	ROUND(SUM(ao.Monto_Gastado), 2) AS Monto_Gastado,
	ROUND(SUM(ao.Total_porGastar), 2) AS Total_porGastar,
	ROUND(SUM(ao.Costo_Esperado), 2) AS Costo_Esperado,
	ROUND(SUM(ao.Diferencia), 2) AS Diferencia,
	ROW_NUMBER() over(order by ao.Ano, mes_num.Mes_num asc) as row_count
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
	where mes_num.Mes =  ao.Mes 
	AND ao.Nombre_Area = 'OTROS GASTOS' AND ao.Partida = 'GASTOS GENERALES DIRECTOS  PERSONAL'
	group by ao.Obra, ao.Ano, mes_num.Mes_num
) as info
where info.Ano > 2023
) as fecha
group by fecha.obra
) as fecha,
(select 
	info.Obra,
	info.Ano,
	info.Mes_num,
	info.Monto_Gastado - coalesce(lag(info.Monto_Gastado) over (order by info.row_count asc), 0) as Descarga_Remuneraciones,
	info.Monto_Original,
	info.Monto_Gastado,
	info.Monto_Trabajo,
	info.Monto_Gastado/info.Monto_Trabajo as porcentaje,
	info.row_count AS N_aparicion,
	CONVERT (date, concat('01','-',info.Mes_num,'-',info.Ano), 103) as fecha
from
(
select 
	ao.Obra,
	ao.Ano,
	mes_num.Mes_num,
	ROUND(SUM(ao.Monto_Original), 2) AS Monto_Original, 
	ROUND(SUM(ao.Monto_Trabajo), 2) AS Monto_Trabajo, 
	ROUND(SUM(ao.Monto_Gastado), 2) AS Monto_Gastado,
	ROUND(SUM(ao.Total_porGastar), 2) AS Total_porGastar,
	ROUND(SUM(ao.Costo_Esperado), 2) AS Costo_Esperado,
	ROUND(SUM(ao.Diferencia), 2) AS Diferencia,
	ROW_NUMBER() over(order by ao.Ano, mes_num.Mes_num asc) as row_count
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
	where mes_num.Mes =  ao.Mes 
	AND ao.Nombre_Area = 'OTROS GASTOS' AND ao.Partida = 'GASTOS GENERALES DIRECTOS  PERSONAL'
	group by ao.Obra, ao.Ano, mes_num.Mes_num
) as info
where info.Ano > 2023) as datos
where fecha.obra = datos.obra and year(fecha.fecha) = year(datos.fecha) and month(fecha.fecha) = month(datos.fecha)
) as gastos_generales 
on gastos_generales.obra = info_obra.obra
inner JOIN 
(SELECT total.obra, avg(total.avance_plataforma) as avance_plataforma
FROM 
(select 
	case when total.ID_ETAPA like 'OLI.V61.URBA' THEN 'OLI.V61'
	ELSE total.ID_ETAPA end as obra, 
	sum(total.POREJE) as avance_plataforma
FROM (
SELECT 
    CASE 
        WHEN A.FECHA = '2024-05-13' AND D.ID_ETAPA = 'OLI.V61' THEN '2024-08-13'
        WHEN A.FECHA = '2024-05-10' AND D.ID_ETAPA = 'OLI.V61' THEN '2024-08-10'
        WHEN A.FECHA = '2024-05-10' AND D.ID_ETAPA = 'OLI.V61' THEN '2024-08-09'
        WHEN A.FECHA = '2024-05-08' AND D.ID_ETAPA = 'OLI.V61' THEN '2024-07-08'
        WHEN A.FECHA = '2024-05-07' AND D.ID_ETAPA = 'OLI.V61' THEN '2024-07-07'
        WHEN A.FECHA = '2024-05-06' AND D.ID_ETAPA = 'OLI.V61' THEN '2024-06-06'
        WHEN A.FECHA = '2024-05-03' AND D.ID_ETAPA = 'OLI.V61' THEN '2024-06-03'
        WHEN D.ID_ETAPA = 'HP.VII80' AND DATEDIFF(day, A.FECHA, '2024-10-16') > 46 THEN DATEADD(month, -2, A.FECHA) 
        WHEN D.ID_ETAPA = 'HP.VII80' AND DATEDIFF(day, A.FECHA, '2024-10-16') < 46 AND DATEDIFF(day, A.FECHA, '2024-10-16') > 0 THEN DATEADD(month, -2, A.FECHA) 
        ELSE A.FECHA
    END AS FECHA, 
    A.ID_PB, 
  	D.ID_ETAPA, 
    D.ID_PROYECTO, 
    B.N AS N_PRO, 
    C.N AS N_EJE, 
    CAST(C.N AS FLOAT) / E.T AS POREJE
FROM (
    SELECT FECHA_REAL AS FECHA, ID_PB FROM [GPR-APP-PLANIFICACION].dbo.plan_semanal WHERE ESTADO = 'EJECUTADO' 
    UNION 
    SELECT FECHA_INI AS FECHA, ID_PB FROM [GPR-APP-PLANIFICACION].dbo.plan_semanal
) AS A
LEFT JOIN (
    SELECT FECHA_INI AS FECHA, ID_PB, COUNT(*) AS N FROM [GPR-APP-PLANIFICACION].dbo.plan_semanal GROUP BY ID_PB, FECHA_INI
) AS B ON A.FECHA = B.FECHA AND A.ID_PB = B.ID_PB 
LEFT JOIN (
    SELECT FECHA_REAL AS FECHA, ID_PB, COUNT(*) AS N FROM [GPR-APP-PLANIFICACION].dbo.plan_semanal WHERE ESTADO = 'EJECUTADO' AND FECHA_REAL <= GETDATE() GROUP BY ID_PB, FECHA_REAL
) AS C ON C.FECHA = A.FECHA AND A.ID_PB = C.ID_PB
LEFT JOIN [GPR-APP-PLANIFICACION].dbo.cab_plan_base AS D ON D.ID_PB = A.ID_PB
LEFT JOIN (
    SELECT ID_PB, COUNT(*) AS T FROM [GPR-APP-PLANIFICACION].dbo.plan_semanal GROUP BY ID_PB
) AS E ON E.ID_PB = A.ID_PB
WHERE NOT (B.N IS NULL AND C.N IS NULL)
) as total
group by total.ID_ETAPA) AS total 
group by total.obra) as avance_app
on avance_app.obra = info_obra.obra
inner join 
(select 
	info.obra, 
	sum(info.Total_Actividades) as total_actividades,
	avg(RITMO_SEM_PROM) as ritmo_sem_prom,
	AVG(P_E) AS p_e,
	AVG(CUMPLIMIENTO) AS cumplimineto,
	avg(ITE) as ITE,
	avg(P_C) as p_c,
	avg(P_E_4S) as p_e_4s
FROM 
(SELECT 
    -- INDICADORES FILA 1
    case when C.ID_ETAPA LIKE  'OLI.V61.URBA' THEN 'OLI.V61' 
    when C.ID_ETAPA LIKE  'LP.I125.URBA' THEN 'LP.I125' 
    ELSE C.ID_ETAPA END as obra, 
    COUNT(*) AS Total_Actividades, 
    MIN(P.FECHA_INI) AS FECHA_INICIO, --FECHA INICIO
    CASE 
        WHEN C.ID_ETAPA = 'OLI.V61' THEN '2024-08-27'
        WHEN C.ID_ETAPA = 'OLI.V61.URBA' THEN '2024-03-20'
        WHEN C.ID_ETAPA = 'HP.VII80' THEN '2024-10-16'
        ELSE MAX(P.FECHA_INI)
    END AS FECHA_TERMINO, --FECHA TERMINO
    CASE 
        WHEN C.ID_ETAPA = 'OLI.V61' THEN DATEDIFF(day, MIN(P.FECHA_INI), '2024-08-27') / 7
        WHEN C.ID_ETAPA = 'OLI.V61.URBA' THEN DATEDIFF(day, MIN(P.FECHA_INI), '2024-03-20') / 7
        WHEN C.ID_ETAPA = 'HP.VII80' THEN DATEDIFF(day, MIN(P.FECHA_INI), '2024-10-16') / 7
        ELSE DATEDIFF(day, MIN(P.FECHA_INI), MAX(P.FECHA_INI)) / 7
    END AS TOTAL_SEM, --TOTAL SEMANAS
    CASE 
        WHEN C.ID_ETAPA = 'OLI.V61' AND DATEDIFF(day, CONVERT(DATE, GETDATE()), '2024-08-27') / 7 < 0 THEN 0 
        WHEN C.ID_ETAPA = 'OLI.V61' THEN DATEDIFF(day, CONVERT(DATE, GETDATE()), '2024-08-27') / 7
        WHEN C.ID_ETAPA = 'OLI.V61.URBA' AND DATEDIFF(day, CONVERT(DATE, GETDATE()), '2024-03-20') / 7 < 0 THEN 0 
        WHEN C.ID_ETAPA = 'OLI.V61.URBA' THEN DATEDIFF(day, CONVERT(DATE, GETDATE()), '2024-03-20') / 7
        WHEN C.ID_ETAPA = 'HP.VII80' AND DATEDIFF(day, CONVERT(DATE, GETDATE()), '2024-10-16') / 7 < 0 THEN 0 
        WHEN C.ID_ETAPA = 'HP.VII80' THEN DATEDIFF(day, CONVERT(DATE, GETDATE()), '2024-10-16') / 7
        WHEN DATEDIFF(day, CONVERT(DATE, GETDATE()), MAX(P.FECHA_INI)) / 7 < 0 THEN 0 
        ELSE DATEDIFF(day, CONVERT(DATE, GETDATE()), MAX(P.FECHA_INI)) / 7 
    END AS SEM_RESTANTES, -- SEMANAS RESTANTES
    DATEDIFF(day, MIN(P.FECHA_INI), CONVERT(DATE, GETDATE())) / 7 AS SEM_PROYECTO, -- SEMANA PROYECTO
    CASE 
        WHEN C.ID_ETAPA = 'OLI.V61' THEN COUNT(*) / (DATEDIFF(day, MIN(P.FECHA_INI), '2024-08-27') / 7) 
        WHEN C.ID_ETAPA = 'OLI.V61.URBA' THEN COUNT(*) / (DATEDIFF(day, MIN(P.FECHA_INI), '2024-03-20') / 7)
        WHEN C.ID_ETAPA = 'HP.VII80' THEN COUNT(*) / (DATEDIFF(day, MIN(P.FECHA_INI), '2024-10-16') / 7)
        ELSE COUNT(*) / (DATEDIFF(day, MIN(P.FECHA_INI), MAX(P.FECHA_INI)) / 7)
    END AS ACT_SEM_PRO, -- ACTIVIVIDADES SEMANAL PROMEDIO
    CASE 
        WHEN C.ID_ETAPA = 'OLI.V61' THEN ROUND(COUNT(*) / (DATEDIFF(day, MIN(P.FECHA_INI), '2024-08-27') / 7.0) / COUNT(*), 4)
        WHEN C.ID_ETAPA = 'OLI.V61.URBA' THEN ROUND(COUNT(*) / (DATEDIFF(day, MIN(P.FECHA_INI), '2024-03-20') / 7.0) / COUNT(*), 4)
        WHEN C.ID_ETAPA = 'HP.VII80' THEN ROUND(COUNT(*) / (DATEDIFF(day, MIN(P.FECHA_INI), '2024-10-16') / 7.0) / COUNT(*), 4)
        ELSE ROUND(COUNT(*) * 1.0 / (DATEDIFF(day, MIN(P.FECHA_INI), MAX(P.FECHA_INI)) / 7.0) / COUNT(*), 4)
    END AS RITMO_SEM_PROM, -- RITMO SEMANAL PROMEDIO

    -- INDICADORES FILA 2
    COUNT(CASE WHEN P.ESTADO = 'EJECUTADO' THEN 1 ELSE NULL END) AS N_E, -- N EJECUTADO
    COUNT(CASE WHEN P.ESTADO = 'EJECUTADO' THEN 1 ELSE NULL END) * 1.0 / COUNT(*) AS P_E, -- % EJECUTADO
    COUNT(CASE WHEN P.ESTADO = 'EJECUTADO' THEN 1 ELSE NULL END) * 1.0 / COUNT(CASE WHEN P.FECHA_INI <= CONVERT(DATE, GETDATE()) THEN 1 ELSE NULL END) * 1.0 AS CUMPLIMIENTO, -- CUMPLIMIENTO
    COUNT(CASE WHEN P.FECHA_INI <= CONVERT(DATE, GETDATE()) THEN 1 ELSE NULL END) AS N_CUMPLIMIENTO, -- N_CUMPLIMIENTO
    COUNT(CASE WHEN P.FECHA_INI <= CONVERT(DATE, GETDATE()) THEN 1 ELSE NULL END) * 1.0 / COUNT(*) AS P_CUMPLIMIENTO_BASE, -- P_CUMPLIMIENTO_BASE
    ((COUNT(CASE WHEN P.ESTADO = 'liberado' THEN 1 ELSE NULL END) + COUNT(CASE WHEN P.ESTADO = 'comprometido' THEN 1 ELSE NULL END)) * 1.0 / COUNT(*)) AS ITE, -- % ITE
    COUNT(CASE WHEN P.ESTADO = 'COMPROMETIDO' THEN 1 ELSE NULL END) AS N_C, -- N COMPROMISOS
    COUNT(CASE WHEN P.ESTADO = 'COMPROMETIDO' THEN 1 ELSE NULL END) * 1.0 / COUNT(*) AS P_C, -- % TOTAL COMPROMISOS
    COUNT(CASE WHEN P.ESTADO = 'COMPROMETIDO'
        AND TRY_CONVERT(DATE, P.FECHA_COMP) >= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE()) - 1), GETDATE())
        AND TRY_CONVERT(DATE, P.FECHA_COMP) <= DATEADD(DAY, 6 - (DATEPART(WEEKDAY, GETDATE())), GETDATE())
        THEN 1 ELSE NULL END) AS N_C_SA, -- N COMPROMISOS SEMANA ACTUAL
    COUNT(CASE WHEN P.ESTADO = 'COMPROMETIDO'
        AND TRY_CONVERT(DATE, P.FECHA_COMP) >= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE()) - 1), GETDATE())
        AND TRY_CONVERT(DATE, P.FECHA_COMP) <= DATEADD(DAY, 6 - (DATEPART(WEEKDAY, GETDATE())), GETDATE())  
        THEN 1 ELSE NULL END) * 1.0 / COUNT(*) AS P_C_SA, -- % COMPROMISOS SEMANA ACTUAL
    COUNT(CASE WHEN P.ESTADO = 'EJECUTADO'
        AND P.FECHA_REAL >= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE()) + 5), GETDATE())
        AND P.FECHA_REAL <= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE())), GETDATE())
        THEN 1 ELSE NULL END) AS N_E_SP, -- N EJECUTADO SEMANA PASADA
    COUNT(CASE WHEN P.ESTADO = 'EJECUTADO'
        AND P.FECHA_REAL >= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE()) + 5), GETDATE())
        AND P.FECHA_REAL <= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE())), GETDATE())
        THEN 1 ELSE NULL END) * 1.0 / COUNT(*) AS P_E_SP, -- % EJECUTADO SEMANA PASADA
    COUNT(CASE WHEN P.ESTADO = 'EJECUTADO'
        AND TRY_CONVERT(DATE, P.FECHA_COMP) >= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE()) - 1), GETDATE())
        AND TRY_CONVERT(DATE, P.FECHA_COMP) <= DATEADD(DAY, 6 - (DATEPART(WEEKDAY, GETDATE())), GETDATE())
        THEN 1 ELSE NULL END) AS N_E_SA, -- N EJECUTADO SEMANA ACTUAL
    COUNT(CASE WHEN P.ESTADO = 'EJECUTADO'
        AND TRY_CONVERT(DATE, P.FECHA_COMP) >= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE()) - 1), GETDATE())
        AND TRY_CONVERT(DATE, P.FECHA_COMP) <= DATEADD(DAY, 6 - (DATEPART(WEEKDAY, GETDATE())), GETDATE())
        THEN 1 ELSE NULL END) * 1.0 / COUNT(*) AS P_E_SA, -- % EJECUTADO SEMANA ACTUAL
    (COUNT(CASE WHEN P.ESTADO = 'EJECUTADO'
        AND TRY_CONVERT(DATE, P.FECHA_REAL) >= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE()) - 1), GETDATE())
        AND TRY_CONVERT(DATE, P.FECHA_REAL) <= DATEADD(DAY, 6 - (DATEPART(WEEKDAY, GETDATE())), GETDATE())   
        THEN 1 ELSE NULL END) * 1.0 / COUNT(*)         
        +     
    COUNT(CASE WHEN P.ESTADO = 'COMPROMETIDO'        
        AND TRY_CONVERT(DATE, P.FECHA_COMP) >= DATEADD(DAY, -1 * (DATEPART(WEEKDAY, GETDATE()) - 1), GETDATE())
        AND TRY_CONVERT(DATE, P.FECHA_COMP) <= DATEADD(DAY, 6 - (DATEPART(WEEKDAY, GETDATE())), GETDATE())
        THEN 1 ELSE NULL END) * 1.0 / COUNT(*)) AS PROY_SA ,-- % PROYECCION SEMANA ACTUAL
    COUNT(CASE WHEN P.ESTADO='EJECUTADO' 
     	AND FECHA_REAL >= DATEADD(day,-28, GETDATE())
	    AND FECHA_REAL < DATEADD(DAY, 1, GETDATE())
	    THEN 1 ELSE NULL END)* 1.0 / COUNT(*) / 4  AS P_E_4S -- PROMEDIO EJECUTADOS 4 SEMANAS	    
FROM [GPR-APP-PLANIFICACION].dbo.plan_semanal AS P
LEFT JOIN [GPR-APP-PLANIFICACION].dbo.usuarios AS U ON U.UID = P.RESPONSABLE
LEFT JOIN [GPR-APP-PLANIFICACION].dbo.cab_plan_base AS C ON C.ID_PB = P.ID_PB
GROUP BY C.ID_ETAPA
) as info
group by obra) as indicadores_app
on indicadores_app.obra = info_obra.obra
;








(select 
	cid.obra,
	cid.adicionales, 
	cid.diferencia,
	cid.ganancia_correccion,
	cid.avance_plataforma,
	cid.porcentaje_material,
	cid.porcentaje_subcontrato,
	cid.avance_informado,
	cid.gasto, 
	cid.ingresos,
	cid.diferencia_ingresos_gasto,
	cid.monto_contrato,
	cid.porcentaje_ingreso,
	cid.partidas_aprobadas,
	cid.partidas_cerradas,
	cid.valor_uf_m2_original,
	cid.valor_uf_m2_real,
	cid.variacion_uf,
	cid.ppto_trabajo_mo_directa,
	cid.monto_digitado_acum,
	cid.porcentaje_ppto_tratos,
	cid.porcentaje_gastos_generales,
	cid.ritmo_sem_prom,
	cid.p_e,
	cid.cumplimineto,
	cid.ITE,
	cid.p_c ,
	cid.p_e_4s ,
	cid.fecha_actualizacion,
	adicionales.adicionales_uf,
	adicionales.porcentaje_adicionales
from consolidado_indicadores_ds cid inner join 
(select 
	OBRA as obra,
	ROUND((ADICIONALES/UF_CONTRATO),2) AS adicionales_uf,
	MONTO_UF_CONTRATO,
	round((ADICIONALES/UF_CONTRATO)/MONTO_UF_CONTRATO,4)*100 as porcentaje_adicionales
from INFORMACION_OBRA_DS iod) as adicionales on
adicionales.obra = cid.obra)
union
(select 
	cid.obra,
	cid.adicionales, 
	cid.diferencia,
	cid.ganancia_correccion,
	cid.avance_plataforma,
	cid.porcentaje_material,
	cid.porcentaje_subcontrato,
	cid.avance_informado,
	cid.gasto, 
	cid.ingresos,
	cid.diferencia_ingresos_gasto,
	cid.monto_contrato,
	cid.porcentaje_ingreso,
	cid.partidas_aprobadas,
	cid.partidas_cerradas,
	cid.valor_uf_m2_original,
	cid.valor_uf_m2_real,
	cid.variacion_uf,
	cid.ppto_trabajo_mo_directa,
	cid.monto_digitado_acum,
	cid.porcentaje_ppto_tratos,
	cid.porcentaje_gastos_generales,
	cid.ritmo_sem_prom,
	cid.p_e,
	cid.cumplimiento,
	cid.ITE,
	cid.p_c ,
	cid.p_e_4s ,
	cid.fecha_actualizacion,
	adicionales.adicionales_uf,
	adicionales.porcentaje_adicionales
from 
(select 
	'Resumen' as obra,
	sum(adicionales) as adicionales, 
	sum(diferencia) as diferencia,
	sum(ganancia_correccion) as ganancia_correccion,
	avg(avance_plataforma) as avance_plataforma,
	AVG(porcentaje_material) as porcentaje_material,
	avg(porcentaje_subcontrato) as porcentaje_subcontrato,
	avg(avance_informado) as avance_informado,
	sum(gasto) as gasto, 
	sum(ingresos) as ingresos,
	sum(diferencia_ingresos_gasto) as diferencia_ingresos_gasto,
	sum(monto_contrato) as monto_contrato,
	avg(porcentaje_ingreso) as porcentaje_ingreso,
	avg(partidas_aprobadas) as partidas_aprobadas,
	avg(partidas_cerradas) as partidas_cerradas,
	avg(valor_uf_m2_original) as valor_uf_m2_original,
	avg(valor_uf_m2_real) as valor_uf_m2_real,
	avg(variacion_uf) as variacion_uf,
	sum(ppto_trabajo_mo_directa) as ppto_trabajo_mo_directa,
	sum(monto_digitado_acum) as monto_digitado_acum,
	avg(porcentaje_ppto_tratos) as porcentaje_ppto_tratos,
	avg(porcentaje_gastos_generales) as porcentaje_gastos_generales ,
	avg(ritmo_sem_prom) as ritmo_sem_prom,
	avg(p_e) as p_e,
	avg(cumplimineto) as cumplimiento,
	avg(ITE) as ITE,
	avg(p_c) as p_c,
	avg(p_e_4s) as p_e_4s,
	fecha_actualizacion
from consolidado_indicadores_ds cid
group by fecha_actualizacion) as cid
inner join (select 
	'Resumen' as obra,
	sum(adicionales_uf) as adicionales_uf,
	avg(porcentaje_adicionales) as porcentaje_adicionales
from
(
select 
	OBRA as obra,
	ROUND((ADICIONALES/UF_CONTRATO),2) AS adicionales_uf,
	MONTO_UF_CONTRATO,
	round((ADICIONALES/UF_CONTRATO)/MONTO_UF_CONTRATO,4)*100 as porcentaje_adicionales,
	getdate() as fecha_actualizacion
from INFORMACION_OBRA_DS iod
) as adicionales 
group by adicionales.fecha_actualizacion) as adicionales on cid.obra = adicionales.obra);



;



select 
	sum(adicionales_uf) as adicionales,
	avg(porcentaje_adicionales) as porcentaje_adicionales
from
(
select 
	OBRA as obra,
	ROUND((ADICIONALES/UF_CONTRATO),2) AS adicionales_uf,
	MONTO_UF_CONTRATO,
	round((ADICIONALES/UF_CONTRATO)/MONTO_UF_CONTRATO,4)*100 as porcentaje_adicionales,
	getdate() as fecha_actualizacion
from INFORMACION_OBRA_DS iod
) as adicionales 
group by adicionales.fecha_actualizacion
;



select 
	cid.obra,
	cid.adicionales, 
	cid.diferencia,
	cid.ganancia_correccion,
	cid.avance_plataforma,
	cid.porcentaje_material,
	cid.porcentaje_subcontrato,
	cid.avance_informado,
	cid.gasto, 
	cid.ingresos,
	cid.diferencia_ingresos_gasto,
	cid.monto_contrato,
	cid.porcentaje_ingreso,
	cid.partidas_aprobadas,
	cid.partidas_cerradas,
	cid.valor_uf_m2_original,
	cid.valor_uf_m2_real,
	cid.variacion_uf,
	cid.ppto_trabajo_mo_directa,
	cid.monto_digitado_acum,
	cid.porcentaje_ppto_tratos,
	cid.porcentaje_gastos_generales,
	cid.ritmo_sem_prom,
	cid.p_e,
	cid.cumplimiento,
	cid.ITE,
	cid.p_c ,
	cid.p_e_4s ,
	cid.fecha_actualizacion,
	adicionales.adicionales_uf,
	adicionales.porcentaje_adicionales
from 
(select 
	'Resumen' as obra,
	sum(adicionales) as adicionales, 
	sum(diferencia) as diferencia,
	sum(ganancia_correccion) as ganancia_correccion,
	avg(avance_plataforma) as avance_plataforma,
	AVG(porcentaje_material) as porcentaje_material,
	avg(porcentaje_subcontrato) as porcentaje_subcontrato,
	avg(avance_informado) as avance_informado,
	sum(gasto) as gasto, 
	sum(ingresos) as ingresos,
	sum(diferencia_ingresos_gasto) as diferencia_ingresos_gasto,
	sum(monto_contrato) as monto_contrato,
	avg(porcentaje_ingreso) as porcentaje_ingreso,
	avg(partidas_aprobadas) as partidas_aprobadas,
	avg(partidas_cerradas) as partidas_cerradas,
	avg(valor_uf_m2_original) as valor_uf_m2_original,
	avg(valor_uf_m2_real) as valor_uf_m2_real,
	avg(variacion_uf) as variacion_uf,
	sum(ppto_trabajo_mo_directa) as ppto_trabajo_mo_directa,
	sum(monto_digitado_acum) as monto_digitado_acum,
	avg(porcentaje_ppto_tratos) as porcentaje_ppto_tratos,
	avg(porcentaje_gastos_generales) as porcentaje_gastos_generales ,
	avg(ritmo_sem_prom) as ritmo_sem_prom,
	avg(p_e) as p_e,
	avg(cumplimineto) as cumplimiento,
	avg(ITE) as ITE,
	avg(p_c) as p_c,
	avg(p_e_4s) as p_e_4s,
	fecha_actualizacion
from consolidado_indicadores_ds cid
group by fecha_actualizacion) as cid
inner join (select 
	'Resumen' as obra,
	sum(adicionales_uf) as adicionales_uf,
	avg(porcentaje_adicionales) as porcentaje_adicionales
from
(
select 
	OBRA as obra,
	ROUND((ADICIONALES/UF_CONTRATO),2) AS adicionales_uf,
	MONTO_UF_CONTRATO,
	round((ADICIONALES/UF_CONTRATO)/MONTO_UF_CONTRATO,4)*100 as porcentaje_adicionales,
	getdate() as fecha_actualizacion
from INFORMACION_OBRA_DS iod
) as adicionales 
group by adicionales.fecha_actualizacion) as adicionales on cid.obra = adicionales.obra

;



select g.cresultado, year(fechadoc) as ano, month(fechadoc) as mes, sum(g.Diferencia) from Gastos g group by g.cresultado,  year(fechadoc), month(fechadoc);



select 
	OBRA, 
	((MARGEN_ACTUAL-MARGEN_INICIAL)/MARGEN_INICIAL)*100 as porcentaje_margen
from INFORMACION_OBRA_DS iod;