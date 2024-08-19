select 	
	promesa.nombre_proyecto,
	promesa.PROMESA,
	escriturado.ESCRITURADO,
	reservado.RESERVADO,
	cancelado.CANCELADO,
	ip.numero_viviendas-escriturado.ESCRITURADO-promesa.PROMESA as NO_VENDIDAS
from
(


	select 
		promesa.nombre_proyecto, 
		sum(promesa.PROMESA) as PROMESA
	FROM 
	(
	(SELECT 
		promesa.nombre_proyecto,
		SUM(promesa.cantidad) as PROMESA
	FROM 
		(
			(select 
				ps.nombre_proyecto, 
				COUNT(*) AS cantidad
			from reporte_comercial_ventas rcv
			inner join proyecto_subagrupacion ps on ps.proyecto = rcv.proyecto and ps.etapa = rcv.etapa and ps.subagrupacion = rcv.subagrupacion
			where estado_actual = 'PROMESA'
			group by ps.nombre_proyecto, rcv.estado_actual, rcv.fecha_actualizacion, year(fecha), month(fecha))
		) AS promesa
	GROUP BY promesa.nombre_proyecto
	)
	UNION 
	(
	SELECT 
		promesa.nombre_proyecto,
		0 as PROMESA
	FROM 
		(
			(select 
				ps.nombre_proyecto, 
				0 AS cantidad
			from reporte_comercial_ventas rcv
			inner join proyecto_subagrupacion ps on ps.proyecto = rcv.proyecto and ps.etapa = rcv.etapa and ps.subagrupacion = rcv.subagrupacion
			where estado_actual != 'PROMESA'
			group by ps.nombre_proyecto, rcv.estado_actual, rcv.fecha_actualizacion, year(fecha), month(fecha))
		) AS promesa
	GROUP BY promesa.nombre_proyecto
	)
	) as promesa
	group by promesa.nombre_proyecto

) as promesa inner join 
(

SELECT escritura.nombre_proyecto, sum(escritura.ESCRITURADO) as ESCRITURADO
FROM
(	
	select escriturado.nombre_proyecto,
		SUM(escriturado.cantidad) as ESCRITURADO
	FROM 
	(
			(select 
				ps.nombre_proyecto, 
				COUNT(*) AS cantidad
			from reporte_comercial_ventas rcv
			inner join proyecto_subagrupacion ps on ps.proyecto = rcv.proyecto and ps.etapa = rcv.etapa and ps.subagrupacion = rcv.subagrupacion
			where estado_actual = 'ESCRITURADO'
			group by ps.nombre_proyecto, rcv.estado_actual, rcv.fecha_actualizacion, year(fecha), month(fecha))
		) AS escriturado
	group by escriturado.nombre_proyecto
	UNION 
	(select 
			ps.nombre_proyecto, 
			0 AS ESCRITURADO
		from reporte_comercial_ventas rcv
		inner join proyecto_subagrupacion ps on ps.proyecto = rcv.proyecto and ps.etapa = rcv.etapa and ps.subagrupacion = rcv.subagrupacion
		where estado_actual != 'ESCRITURADO'
	group by ps.nombre_proyecto, rcv.estado_actual, rcv.fecha_actualizacion, year(fecha), month(fecha))
) AS escritura
group by escritura.nombre_proyecto
) as escriturado on promesa.nombre_proyecto = escriturado.nombre_proyecto

inner join
(


select reserva.nombre_proyecto, sum(reserva.RESERVADO) as RESERVADO
from
(
(
select 
	reservado.nombre_proyecto,
	SUM(reservado.cantidad) as RESERVADO
FROM 
	(
		(
		select 
			ps.nombre_proyecto, 
			COUNT(*) AS cantidad
		from reporte_comercial_ventas rcv
		inner join proyecto_subagrupacion ps on ps.proyecto = rcv.proyecto and ps.etapa = rcv.etapa and ps.subagrupacion = rcv.subagrupacion
		where estado_actual = 'RESERVADO'
		group by ps.nombre_proyecto, rcv.estado_actual, rcv.fecha_actualizacion, year(fecha), month(fecha), rcv.estado_actual)
	) AS reservado
group by reservado.nombre_proyecto
)
union
(
select 
	ps.nombre_proyecto, 
	0  as RESERVADO
from reporte_comercial_ventas rcv
inner join proyecto_subagrupacion ps on ps.proyecto = rcv.proyecto and ps.etapa = rcv.etapa and ps.subagrupacion = rcv.subagrupacion
where estado_actual != 'RESERVADO'
group by ps.nombre_proyecto, rcv.estado_actual, rcv.fecha_actualizacion, year(fecha), month(fecha), rcv.estado_actual)
) as reserva
group by reserva.nombre_proyecto
) as reservado on promesa.nombre_proyecto = reservado.nombre_proyecto
inner JOIN 
(

select cancelado.nombre_proyecto, SUM(cancelado.CANCELADO) AS CANCELADO
from 
(

(
select 
	cancelado.nombre_proyecto,
	SUM(cancelado.cantidad) as CANCELADO
FROM 
	(
		(select 
			ps.nombre_proyecto, 
			COUNT(*) AS cantidad
		from reporte_comercial_ventas rcv
		inner join proyecto_subagrupacion ps on ps.proyecto = rcv.proyecto and ps.etapa = rcv.etapa and ps.subagrupacion = rcv.subagrupacion
		where estado_actual = 'CANCELADO'
		group by ps.nombre_proyecto, rcv.estado_actual, rcv.fecha_actualizacion, year(fecha), month(fecha), rcv.estado_actual)
	) AS cancelado
group by cancelado.nombre_proyecto
)
UNION 
((select 
	ps.nombre_proyecto, 
	0 as CANCELADO
from reporte_comercial_ventas rcv
inner join proyecto_subagrupacion ps on ps.proyecto = rcv.proyecto and ps.etapa = rcv.etapa and ps.subagrupacion = rcv.subagrupacion
where estado_actual != 'CANCELADO'
group by ps.nombre_proyecto, rcv.estado_actual, rcv.fecha_actualizacion, year(fecha), month(fecha), rcv.estado_actual))
) AS cancelado
GROUP BY cancelado.nombre_proyecto
) as cancelado on promesa.nombre_proyecto = cancelado.nombre_proyecto
inner join informacion_proyectos ip on ip.nombre_proyecto = promesa.nombre_proyecto;


