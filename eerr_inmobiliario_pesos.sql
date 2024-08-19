-- CONSULTA DATOS PPTOS, DP - VT - MACRO
(select 
	item.nombre_proyecto,
	item.item,
	item.ppto,
	item.gasto,
	case when item.item != 'Monto Menor Beneficio IVA Const' and item.por_gastar < 0 then 0
	else item.por_gastar end as por_gastar,
	item.number_row,
	case when iu.orden is null then 0
	when iu.orden = 'MANUAL' then 0
	else iu.orden
	end as orden
from 
(
	(
	select 
		cc.nombre_proyecto,
		proyectos.item,
		proyectos.ppto,
		proyectos.gasto,
		proyectos.por_gastar,
		proyectos.number_row
	from
		(
			select 
				apgi.obra,
				apgi.Partida as item,
				sum(apgi.Monto_Trabajo) as ppto,
				sum(apgi.Monto_Gastado) as gasto,
				sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
				1 as number_row
			from
			(select 
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
			(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
			from avance_por_gastar_inmobiliaria apgi
			group by apgi.obra) as actualizacion
			where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra 
			and apgi.Nombre_Area is NOT NULL
			and apgi.obra like ('%DP%')
			group by apgi.obra, apgi.Partida
		) as proyectos inner join (select nombre_proyecto, auranet_inmobiliaria from homologacion_proyectos hp where auranet_inmobiliaria is not null) as cc
		on cc.auranet_inmobiliaria = proyectos.obra
	)
	union
	(
		select 
			cc.nombre_proyecto,
			ventas.item,
			ventas.ppto,
			ventas.gasto,
			ventas.por_gastar,
			ventas.number_row
		from
			(
			select 
				apgi.obra,
				apgi.Nombre_Area as item,
				sum(apgi.Monto_Trabajo) as ppto,
				sum(apgi.Monto_Gastado) as gasto,
				sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
				1 as number_row
			from
			(select 
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
			(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
			from avance_por_gastar_inmobiliaria apgi
			group by apgi.obra) as actualizacion
			where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra 
			and apgi.Nombre_Area is NOT NULL
			and apgi.obra like ('%VT%')
			group by apgi.obra, apgi.Nombre_Area
			) as ventas inner join (select nombre_proyecto, auranet_ventas from homologacion_proyectos hp where auranet_ventas is not null) as cc 
			on ventas.obra = cc.auranet_ventas
	)
	UNION 
	(
	select 
		mp.nombre_proyecto,
		macro.item,
		macro.ppto,
		macro.gasto, 
		macro.por_gastar,
		macro.number_row
	from 
		(select 
			apgi.obra,
			apgi.Nombre_Area as item,
			sum(apgi.Monto_Trabajo) as ppto,
			sum(apgi.Monto_Gastado) as gasto,
			sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
			1 as number_row
		from
		(select 
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
		(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
		from avance_por_gastar_inmobiliaria apgi
		group by apgi.obra) as actualizacion
		where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra 
		and apgi.Nombre_Area is NOT NULL
		and apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%'
		group by apgi.obra, apgi.Nombre_Area
		) as macro inner join macro_proyectos mp on mp.macro = macro.obra
	)
	-- macro
	union
	(
		(
			select 
				hp.nombre_proyecto,
				apgi.Partida as item,
				sum(apgi.Monto_Trabajo) as ppto,
				sum(apgi.Monto_Gastado) as gasto,
				sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
				2 as numer_row
			from
			(select 
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
			(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
			from avance_por_gastar_inmobiliaria apgi
			group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii ,
			homologacion_proyectos hp
			where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra
			and apgi.Nombre_Area is NOT NULL
			and apgi.obra like ('%DP%')
			and bii.CC = apgi.obra and bii.item = apgi.Partida
			and hp.auranet_inmobiliaria = apgi.obra
			group by hp.nombre_proyecto, apgi.Partida
		)
		UNION 
		((
		select 
			mp.nombre_proyecto,
			apgi.Nombre_Area as item,
			sum(apgi.Monto_Trabajo) as ppto,
			sum(apgi.Monto_Gastado) as gasto,
			sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
			2 as numer_row
		from
		(select 
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
		(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
		from avance_por_gastar_inmobiliaria apgi
		group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, macro_proyectos mp
		where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra 
		and apgi.Nombre_Area is NOT NULL
		and apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%'
		and bii.CC = apgi.obra and bii.item = apgi.Partida
		and mp.macro = apgi.obra
		group by mp.nombre_proyecto, apgi.Nombre_Area))
	) 
	union
	
	(
		(
		select 
			hp.nombre_proyecto,
			apgi.Partida as item,
			sum(apgi.Monto_Trabajo)*0.19*bii.ceec as ppto,
			sum(apgi.Monto_Gastado)*0.19*bii.ceec as gasto,
			(sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado))*0.19*bii.ceec as por_gastar,
			3 as numer_row
		from
		(select 
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
		(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
		from avance_por_gastar_inmobiliaria apgi
		group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, homologacion_proyectos hp
		where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra
		and apgi.Nombre_Area is NOT NULL
		and apgi.obra like ('%DP%')
		and bii.CC = apgi.obra and bii.item = apgi.Partida
		and hp.auranet_inmobiliaria = apgi.obra
		group by hp.nombre_proyecto, apgi.Partida, bii.ceec
		)
		UNION 
		((
		select 
			mp.nombre_proyecto,
			apgi.Nombre_Area as item,
			sum(apgi.Monto_Trabajo)*0.19*bii.ceec as ppto,
			sum(apgi.Monto_Gastado)*0.19*bii.ceec as gasto,
			(sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado))*0.19*bii.ceec as por_gastar,
			3 as numer_row
		from
		(select 
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
		(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
		from avance_por_gastar_inmobiliaria apgi
		group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, macro_proyectos mp
		where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra 
		and apgi.Nombre_Area is NOT NULL
		and apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%'
		and bii.CC = apgi.obra and bii.item = apgi.Partida
		and mp.macro = apgi.obra
		group by mp.nombre_proyecto, apgi.Nombre_Area, bii.ceec)) 
	)
	union
	(
	select 
		apgi.nombre_proyecto,
		'IVA 19%' as item,
		round(sum(ppto)*0.19,0) as ppto,
		round(sum(gasto)*0.19,0) as gasto,
		round(sum(por_gastar)*0.19,0)  as por_gastar,
		4 as numer_row
	from
	(
	(
		(
		select 
			hp.nombre_proyecto,
			apgi.Partida as item,
			sum(apgi.Monto_Trabajo) as ppto,
			sum(apgi.Monto_Gastado) as gasto,
			sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
			2 as numer_row
		from
		(select 
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
		(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
		from avance_por_gastar_inmobiliaria apgi
		group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, homologacion_proyectos hp
		where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra
		and apgi.Nombre_Area is NOT NULL
		and apgi.obra like ('%DP%')
		and bii.CC = apgi.obra and bii.item = apgi.Partida
		and hp.auranet_inmobiliaria = apgi.obra
		group by hp.nombre_proyecto, apgi.Partida
		)
		UNION 
		((
		select 
			mp.nombre_proyecto,
			apgi.Nombre_Area as item,
			sum(apgi.Monto_Trabajo) as ppto,
			sum(apgi.Monto_Gastado) as gasto,
			sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
			1 as numer_row
		from
		(select 
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
		(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
		from avance_por_gastar_inmobiliaria apgi
		group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, macro_proyectos mp
		where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra 
		and apgi.Nombre_Area is NOT NULL
		and apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%'
		and bii.CC = apgi.obra and bii.item = apgi.Partida
		and mp.macro = apgi.obra
		group by mp.nombre_proyecto, apgi.Nombre_Area)) 
	)) as apgi
	group by apgi.nombre_proyecto
	)
	union
	(
	select 
		apgi.nombre_proyecto,
		'Monto Menor Beneficio IVA Const' as item,
		round((apgi.ppto)*0.19*apgi.ceec,0)*-1 as ppto,
		round((apgi.gasto)*0.19*apgi.ceec,0)*-1 as gasto,
		round((apgi.por_gastar)*0.19*apgi.ceec,0)*-1  as por_gastar,
		5 as numer_row
	from
	(
		(
			select 
				hp.nombre_proyecto,
				apgi.Partida as item,
				sum(apgi.Monto_Trabajo) as ppto,
				sum(apgi.Monto_Gastado) as gasto,
				sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
				2 as numer_row, bii.ceec
			from
			(select 
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
			(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
			from avance_por_gastar_inmobiliaria apgi
			group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, homologacion_proyectos hp
			where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra
			and apgi.Nombre_Area is NOT NULL
			and apgi.obra like ('%DP%')
			and bii.CC = apgi.obra and bii.item = apgi.Partida
			and hp.auranet_inmobiliaria = apgi.obra
			group by hp.nombre_proyecto, apgi.Partida,bii.ceec
			)
			UNION 
			((
			select 
				mp.nombre_proyecto,
				apgi.Nombre_Area as item,
				sum(apgi.Monto_Trabajo) as ppto,
				sum(apgi.Monto_Gastado) as gasto,
				sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
				1 as numer_row
				, bii.ceec
			from
			(select 
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
			(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
			from avance_por_gastar_inmobiliaria apgi
			group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, macro_proyectos mp
			where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra 
			and apgi.Nombre_Area is NOT NULL
			and apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%'
			and bii.CC = apgi.obra and bii.item = apgi.Partida
			and mp.macro = apgi.obra
			group by mp.nombre_proyecto, apgi.Nombre_Area, bii.ceec)) 
	) as apgi
	)
	union
	(
	select 
		apgi.nombre_proyecto,
		'Monto Menor Beneficio IVA Const' as item,
		round((apgi.ppto)*0.19*apgi.ceec,0)*-1 as ppto,
		round((apgi.gasto)*0.19*apgi.ceec,0)*-1 as gasto,
		round((apgi.por_gastar)*0.19*apgi.ceec,0)*-1  as por_gastar,
		1 as numer_row
	from
	(
		(
			select 
				hp.nombre_proyecto,
				apgi.Partida as item,
				sum(apgi.Monto_Trabajo) as ppto,
				sum(apgi.Monto_Gastado) as gasto,
				sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
				2 as numer_row, bii.ceec
			from
			(select 
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
			(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
			from avance_por_gastar_inmobiliaria apgi
			group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, homologacion_proyectos hp
			where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra
			and apgi.Nombre_Area is NOT NULL
			and apgi.obra like ('%DP%')
			and bii.CC = apgi.obra and bii.item = apgi.Partida
			and hp.auranet_inmobiliaria = apgi.obra
			group by hp.nombre_proyecto, apgi.Partida,bii.ceec
			)
			UNION 
			((
			select 
				mp.nombre_proyecto,
				apgi.Nombre_Area as item,
				sum(apgi.Monto_Trabajo) as ppto,
				sum(apgi.Monto_Gastado) as gasto,
				sum(apgi.Monto_Trabajo)-sum(apgi.Monto_Gastado) as por_gastar,
				1 as numer_row
				, bii.ceec
			from
			(select 
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
			(select apgi.obra, max(apgi.fecha_actualizacion) as fecha_actualizacion 
			from avance_por_gastar_inmobiliaria apgi
			group by apgi.obra) as actualizacion, beneficio_iva_inmobiliaria bii, macro_proyectos mp
			where apgi.fecha_actualizacion = actualizacion.fecha_actualizacion and apgi.obra = actualizacion.obra 
			and apgi.Nombre_Area is NOT NULL
			and apgi.obra not LIKE '%DP%' and apgi.obra not like '%VT%'
			and bii.CC = apgi.obra and bii.item = apgi.Partida
			and mp.macro = apgi.obra
			group by mp.nombre_proyecto, apgi.Nombre_Area, bii.ceec)) 
	) as apgi
	)
) as item inner join item_uf iu on iu.proyecto = item.nombre_proyecto
and item.item = iu.item
)
union 
(
	select 
		distinct
		fct.proyecto as nombre_proyecto,
		'COSTO TERRENO' as item,
		fct.ctoterreno*fct.valor_uf as ppto,
		fct.gasto*fct.valor_uf as gasto,
		(fct.ctoterreno-fct.gasto)*fct.valor_uf as por_gastar,
		1 as number_row,
		case when iu.orden is null then 0
		when iu.orden = 'MANUAL' then 0
		else iu.orden
		end as orden
	from finanzas_costos_terrenos fct inner join item_uf iu
	on iu.proyecto = fct.proyecto and iu.item = 'COSTO TERRENO'
);


