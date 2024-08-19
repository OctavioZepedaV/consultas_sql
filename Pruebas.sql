select estado.proyecto,
	estado.etapa,
	estado.subagrupacion, 
	estado.meses,
	promesa.cantidad as promesa,
	escritura.cantidad as escrituracion,
	reserva.cantidad as reserva,
	desistido.cantidad as desistido,
	(promesa.cantidad+escritura.cantidad) as ventas
from 
(select proyecto, etapa, subagrupacion, min(fecha) as fecha_min, max(fecha) as fecha_max, DATEDIFF(MONTH, min(fecha), max(fecha)) as meses
from 
(
(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
from reserva r where r.proyecto like 'CONDOMINIO ALTOS DEL MIRADOR'
group by proyecto, etapa, subagrupacion, fecha, estado_actual)
union
(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
from promesa p where p.proyecto like 'CONDOMINIO ALTOS DEL MIRADOR'
group by proyecto, etapa, subagrupacion, fecha, estado_actual)
union
(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
from escritura e where e.proyecto like 'CONDOMINIO ALTOS DEL MIRADOR'
group by proyecto, etapa, subagrupacion, fecha, estado_actual)
union
(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
from desistido d  where d.proyecto like 'CONDOMINIO ALTOS DEL MIRADOR'
group by proyecto, etapa, subagrupacion, fecha, estado_actual)
) as estado
group by proyecto, etapa, subagrupacion
) as estado,
(select proyecto, etapa, subagrupacion, count(*) as cantidad
from reserva r where r.proyecto like 'CONDOMINIO ALTOS DEL MIRADOR'
group by proyecto, etapa, subagrupacion) as reserva,
(select proyecto, etapa, subagrupacion, count(*) as cantidad
from promesa p where p.proyecto like 'CONDOMINIO ALTOS DEL MIRADOR'
group by proyecto, etapa, subagrupacion) as promesa,
(select proyecto, etapa, subagrupacion,  count(*) as cantidad
from escritura e where e.proyecto like 'CONDOMINIO ALTOS DEL MIRADOR'
group by proyecto, etapa, subagrupacion) as escritura,
(select proyecto, etapa, subagrupacion, count(*) as cantidad
from desistido d  where d.proyecto like 'CONDOMINIO ALTOS DEL MIRADOR'
group by proyecto, etapa, subagrupacion) as desistido
where reserva.proyecto = estado.proyecto and promesa.proyecto = estado.proyecto and escritura.proyecto = estado.proyecto
and reserva.proyecto = estado.proyecto;




select 
	resumen_global.proyecto,
	resumen_global.etapa,
	resumen_global.subagrupacion,
	resumen_global.cotizaciones, 
	resumen_global.reservas,
	resumen_global.promesas_brutas,
	resumen_global.desistidas,
	resumen_global.promesas_netas,
	resumen_global.uf_vendidas,
	resumen_global.fecha,
	estado_proyecto.estado_actual, 
	estado_proyecto.cantidad,
	estado_proyecto.meses,
	estado_proyecto.velocidad
from
(select 
	rcv.proyecto, 
	rcv.etapa, 
	rcv.subagrupacion, 
	estado_actual, 
	count(*) as cantidad,
	meses.meses,
	(count(*)*1.0)/meses as velocidad
from reporte_comercial_ventas rcv,
(
select 
	proyecto, 
	etapa, 
	subagrupacion, 
	min(fecha) as fecha_min, 
	max(fecha) as fecha_max, 
	DATEDIFF(MONTH, min(fecha), max(fecha)) as meses
from 
	(
		(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
		from reserva r
		group by proyecto, etapa, subagrupacion, fecha, estado_actual)
	union
		(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
		from promesa p
		group by proyecto, etapa, subagrupacion, fecha, estado_actual)
	union
		(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
		from escritura e
		group by proyecto, etapa, subagrupacion, fecha, estado_actual)
	union
		(select proyecto, etapa, subagrupacion, convert(varchar, fecha, 23) as fecha, estado_actual, count(*) as cantidad
		from desistido d 
		group by proyecto, etapa, subagrupacion, fecha, estado_actual)
	) as estado
group by proyecto, etapa, subagrupacion
) as meses
where meses.proyecto = rcv.proyecto and meses.etapa = rcv.etapa and meses.subagrupacion = rcv.subagrupacion
group by rcv.proyecto, rcv.etapa, rcv.subagrupacion, rcv.estado_actual, meses.meses
) as estado_proyecto,
(select 
	proyecto,
	etapa,
	subagrupacion,
	cotizaciones, 
	reservas,
	promesas_brutas,
	desistidas,
	promesas_netas,
	uf_vendidas,
	convert(varchar, fecha, 23) as fecha
from resumen_global) as resumen_global
where resumen_global.proyecto = estado_proyecto.proyecto and 
resumen_global.etapa = estado_proyecto.etapa and resumen_global.subagrupacion = estado_proyecto.subagrupacion;



select 
	estado_proyecto.proyecto,
	estado_proyecto.etapa,
	estado_proyecto.subagrupacion,
	estado_proyecto.estado_actual, 
	estado_proyecto.cantidad,
	fecha.fecha_min,
	fecha.fecha_max,
	fecha.meses,
	(estado_proyecto.cantidad*1.0)/meses as velocidad_venta
from
(
select 
	estado.proyecto, estado.etapa, estado.subagrupacion,
	min(fecha) as fecha_min, 
	max(fecha) as fecha_max, 
	DATEDIFF(MONTH, min(fecha), max(fecha)) as meses
from
(
(select 
	n.proyecto, 
	n.etapa, 
	n.subagrupacion, 
	n.estado_actual,
	convert(varchar, fecha_firma_cliente, 23) as fecha,
	count(*) as cantidad
from negocio n 
where n.estado_actual = 'ESCRITURADO'
group by n.proyecto, n.etapa, n.subagrupacion, n.estado_actual, fecha_firma_cliente)
union
(
select 
	n.proyecto, 
	n.etapa, 
	n.subagrupacion, 
	n.estado_actual,
	convert(varchar, fecha_reserva, 23) as fecha,
	count(*) as cantidad
from negocio n 
where n.estado_actual = 'RESERVADO'
group by n.proyecto, n.etapa, n.subagrupacion, n.estado_actual, fecha_reserva
)
union
(
select 
	n.proyecto, 
	n.etapa, 
	n.subagrupacion, 
	n.estado_actual,
	convert(varchar, fecha_promesa, 23) as fecha,
	count(*) as cantidad
from negocio n 
where n.estado_actual = 'PROMESA'
group by n.proyecto, n.etapa, n.subagrupacion, n.estado_actual, fecha_promesa 
)
UNION
(
select 
	n.proyecto, 
	n.etapa, 
	n.subagrupacion, 
	n.estado_actual,
	convert(varchar, fecha_reserva , 23) as fecha,
	count(*) as cantidad
from negocio n 
where n.estado_actual = 'CANCELADO'
group by n.proyecto, n.etapa, n.subagrupacion, n.estado_actual, fecha_reserva
)
) as estado
group by estado.proyecto, estado.etapa, estado.subagrupacion
) as fecha,
((select 
	n.proyecto, 
	n.etapa, 
	n.subagrupacion, 
	n.estado_actual,
	convert(varchar, fecha_firma_cliente, 23) as fecha,
	count(*) as cantidad
from negocio n 
where n.estado_actual = 'ESCRITURADO'
group by n.proyecto, n.etapa, n.subagrupacion, n.estado_actual, fecha_firma_cliente)
union
(
select 
	n.proyecto, 
	n.etapa, 
	n.subagrupacion, 
	n.estado_actual,
	convert(varchar, fecha_reserva, 23) as fecha,
	count(*) as cantidad
from negocio n 
where n.estado_actual = 'RESERVADO'
group by n.proyecto, n.etapa, n.subagrupacion, n.estado_actual, fecha_reserva
)
union
(
select 
	n.proyecto, 
	n.etapa, 
	n.subagrupacion, 
	n.estado_actual,
	convert(varchar, fecha_promesa, 23) as fecha,
	count(*) as cantidad
from negocio n 
where n.estado_actual = 'PROMESA'
group by n.proyecto, n.etapa, n.subagrupacion, n.estado_actual, fecha_promesa 
)
UNION
(
select 
	n.proyecto, 
	n.etapa, 
	n.subagrupacion, 
	n.estado_actual,
	convert(varchar, fecha_reserva , 23) as fecha,
	count(*) as cantidad
from negocio n 
where n.estado_actual = 'CANCELADO'
group by n.proyecto, n.etapa, n.subagrupacion, n.estado_actual, fecha_reserva
)) as estado_proyecto
where fecha.proyecto = estado_proyecto.proyecto and 
fecha.etapa = estado_proyecto.etapa and fecha.subagrupacion = estado_proyecto.subagrupacion
;



select * from promesa p;


