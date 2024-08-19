
(select 
	nombre_proyecto as Proyecto,
	obra,
	item,
	COALESCE(gasto, 0) as gasto,
	COALESCE(por_gastar,0) as por_gastar, 
	COALESCE(total, 0) as total,
	COALESCE(total_anterior,0) as total_anterior,
	COALESCE(diferencia_mes_anterior,0) as diferencia_mes_anterior,
	number_row,
	tipo,
	orden AS row_position
from 
	(
		select 
			item.nombre_proyecto,
			item.obra,
			item.item,
			item.gasto,
			item.por_gastar,
			item.total,
			item.total_anterior,
			item.diferencia_mes_anterior,
			item.number_row,
			item.tipo,
			case when iu.orden is null then 0
				when iu.orden = 'MANUAL' then 0
				else iu.orden
				end as orden
		from
		(select 
			actual.nombre_proyecto,
			actual.obra,
			actual.item,
			actual.gasto,
			actual.por_gastar,
			actual.total,
			COALESCE(anterior.total,0) as total_anterior, 
			actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
			actual.number_row,
			actual.tipo
		from ds_eerr_inmobiliario_uf_anterior as anterior
		right join ds_eerr_inmobiliario_uf_actual as actual on
		actual.nombre_proyecto = anterior.nombre_proyecto and 
		actual.obra = anterior.obra and actual.item = anterior.item and 
		actual.number_row = anterior.number_row) as item inner join item_uf iu on iu.proyecto = item.nombre_proyecto and item.item = iu.item
	) as eerr)
union
(select 
	ingresos.nombre_proyecto as Proyecto,
	ingresos.nombre_proyecto as obra,
	'UTILIDAD A. DE IMPUESTOS' as item,
	ingresos.total-egresos.total as Actual,
	ingresos.total-egresos.total as Pendiente,
	ingresos.total-egresos.total as total,
	ingresos.total_anterior-egresos.total_anterior as total_anterior,
	(ingresos.total-egresos.total)-(ingresos.total_anterior-egresos.total_anterior) as diferencia_mes_anterior,
	6 as number_row,
	'PR' as tipo,
	100 as row_position
from
-- -------------------------------------------------- EGRESOS  -------------------------------------------------
(select nombre_proyecto, 'egresos' as item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 1
group by nombre_proyecto) as egresos,
-- -------------------------------------------------- INGRESOS -------------------------------------------------
(select nombre_proyecto, item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Neto'
group by nombre_proyecto, item) as ingresos,
(select nombre_proyecto, item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Bruto'
group by nombre_proyecto, item) as ingreso_bruto
where ingresos.nombre_proyecto = egresos.nombre_proyecto
and ingreso_bruto.nombre_proyecto = egresos.nombre_proyecto)
UNION 


(select 
	ingresos.nombre_proyecto as Proyecto,
	ingresos.nombre_proyecto as obra,
	'IMPTO 27%' as item,
	((ingresos.total-egresos.total)*0.27) as Actual,
	((ingresos.total-egresos.total)*0.27) as Pendiente,
	((ingresos.total-egresos.total)*0.27) as total,
	((ingresos.total_anterior-egresos.total_anterior)*0.27) as total_anterior,
	((ingresos.total-egresos.total)*0.27)-((ingresos.total_anterior-egresos.total_anterior)*0.27) as diferencia_mes_anterior,
	6 as number_row,
	'PR' as tipo,
	101 as row_position
from
-- -------------------------------------------------- EGRESOS  -------------------------------------------------
(select nombre_proyecto, 'egresos' as item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 1
group by nombre_proyecto) as egresos,
-- -------------------------------------------------- INGRESOS -------------------------------------------------
(select nombre_proyecto, item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Neto'
group by nombre_proyecto, item) as ingresos,
(select nombre_proyecto, item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Bruto'
group by nombre_proyecto, item) as ingreso_bruto
where ingresos.nombre_proyecto = egresos.nombre_proyecto
and ingreso_bruto.nombre_proyecto = egresos.nombre_proyecto)

union

(select 
	ingresos.nombre_proyecto as Proyecto,
	ingresos.nombre_proyecto as obra,
	'UTILIDAD D. DE IMPUESTOS' as item,
	(ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27) as Actual,
	(ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27) as Pendiente,
	(ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27) as total,
	(ingresos.total_anterior-egresos.total_anterior)-((ingresos.total_anterior-egresos.total_anterior)*0.27) as total_anterior,
	((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))-
	((ingresos.total_anterior-egresos.total_anterior)-((ingresos.total_anterior-egresos.total_anterior)*0.27)) as diferencia_mes_anterior,
	7 as number_row,
	'PR' as tipo,
	102 as row_position
from
-- -------------------------------------------------- EGRESOS  -------------------------------------------------
(select nombre_proyecto, 'egresos' as item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 1
group by nombre_proyecto) as egresos,
-- -------------------------------------------------- INGRESOS -------------------------------------------------
(select nombre_proyecto, item,  sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Neto'
group by nombre_proyecto, item) as ingresos,
(select nombre_proyecto, item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Bruto'
group by nombre_proyecto, item) as ingreso_bruto
where ingresos.nombre_proyecto = egresos.nombre_proyecto
and ingreso_bruto.nombre_proyecto = egresos.nombre_proyecto)
UNION 
(select 
	ingresos.nombre_proyecto as Proyecto,
	ingresos.nombre_proyecto as obra,
	'MARGEN NETO' as item,
	((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))/ ingresos.total as Actual,
	((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))/ ingresos.total as Pendiente,
	((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))/ ingresos.total as total,
	(((ingresos.total_anterior-egresos.total_anterior)-((ingresos.total_anterior-egresos.total_anterior)*0.27))/ ingresos.total_anterior) as total_anterior,
	(((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))/ ingresos.total)-
	((((ingresos.total_anterior-egresos.total_anterior)-((ingresos.total_anterior-egresos.total_anterior)*0.27))/ ingresos.total_anterior)) as diferencia_mes_anterior,
	8 as number_row,
	'PR' as tipo,
	103 as row_position
from
-- -------------------------------------------------- EGRESOS  -------------------------------------------------
(select nombre_proyecto, 'egresos' as item, sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 1
group by nombre_proyecto) as egresos,
-- -------------------------------------------------- INGRESOS -------------------------------------------------
(select nombre_proyecto, item,sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from 
	(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Neto'
group by nombre_proyecto, item) as ingresos,
(select nombre_proyecto, item, sum(gasto) as gasto, sum(por_gastar) as por_gastar, sum(gasto)+sum(por_gastar) as total
from eerr_inmobiliario
where number_row = 0 and item = 'Ingresos Bruto'
group by nombre_proyecto, item) as ingreso_bruto
where ingresos.nombre_proyecto = egresos.nombre_proyecto
and ingreso_bruto.nombre_proyecto = egresos.nombre_proyecto)
union 
(select 
	ingresos.nombre_proyecto as Proyecto,
	ingresos.nombre_proyecto as obra,
	'MARGEN BRUTO' as item,
	((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))/ ingreso_bruto.total as Actual,
	((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))/ ingreso_bruto.total as Pendiente,
	((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))/ ingreso_bruto.total as total,
	((ingresos.total_anterior-egresos.total_anterior)-((ingresos.total_anterior-egresos.total_anterior)*0.27))/ ingreso_bruto.total_anterior as total_anterior,
	(((ingresos.total-egresos.total)-((ingresos.total-egresos.total)*0.27))/ ingreso_bruto.total)-
	(((ingresos.total_anterior-egresos.total_anterior)-((ingresos.total_anterior-egresos.total_anterior)*0.27))/ ingreso_bruto.total_anterior) as diferencia_mes_anterior,
	8 as number_row,
	'PR' as tipo,
	104 as row_position
from
-- -------------------------------------------------- EGRESOS  -------------------------------------------------
(select nombre_proyecto, 'egresos' as item,
	sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from
(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 1
group by nombre_proyecto) as egresos,
-- -------------------------------------------------- INGRESOS -------------------------------------------------
(select nombre_proyecto, item, 
	sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from
(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Neto'
group by nombre_proyecto, item) as ingresos,
(
select 
	nombre_proyecto, 
	item, 
	sum(gasto) as gasto, 
	sum(por_gastar) as por_gastar, 
	sum(total) as total,
	sum(total_anterior) as total_anterior,
	sum(diferencia_mes_anterior) as diferencia_mes_anterior
from
(select 
	actual.nombre_proyecto,
	actual.obra,
	actual.item,
	actual.gasto,
	actual.por_gastar,
	actual.total,
	COALESCE(anterior.total,0) as total_anterior, 
	actual.total-COALESCE(anterior.total,0) as diferencia_mes_anterior,
	actual.number_row,
	actual.tipo
from ds_eerr_inmobiliario_uf_anterior as anterior
right join ds_eerr_inmobiliario_uf_actual as actual on
actual.nombre_proyecto = anterior.nombre_proyecto and 
actual.obra = anterior.obra and actual.item = anterior.item and 
actual.number_row = anterior.number_row) as eerr
where number_row = 0 and item = 'Ingresos Bruto'
group by nombre_proyecto, item
) as ingreso_bruto
where ingresos.nombre_proyecto = egresos.nombre_proyecto
and ingreso_bruto.nombre_proyecto = egresos.nombre_proyecto)
;





;
