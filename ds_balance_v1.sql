
DELETE FROM DS_balance_inmobiliario;

INSERT INTO DS_balance_inmobiliario (
    empresa,
    nombre_proyecto,
    ubicacion,
    monto_inferior_uf,
    monto_superior_uf,
    fecha_inicio,
    fecha_termino_presentada,
    Porcentaje_ejecucion,
    numero_viviendas,
    costo_directo_construccion_inicial_bruto_uf,
    linea_finan_original_uf,
    linea_finan_original_BG_uf,
    diferencia_uf,
    factura_por_cobrar,
    banco,
    Total_Venta_Pto_UF,
    Total_Saldos_por_recibir_UF,
    Saldos_recibir_Pdtes_por_Vender,
    Saldos_recibir_Vendidos,
    Ingresos_recuperados,
    Nro_Viviendas_Vendidas_Netas,
    monto_boletas_garantia,
    fecha_actualizacion 
)


(select 
	ip.empresa,
	ip.nombre_proyecto,
	ip.ubicacion,
	ip.monto_inferior_uf,
	ip.monto_superior_uf,
	ip.fecha_inicio,
	ip.fecha_termino_presentada,
	case when ip.fecha_termino_presentada < '2023-01-01' then 1
	else avance_obra.Porcentaje_ejecucion end as Porcentaje_ejecucion,
	ip.numero_viviendas,
	ifp.costo_directo_construccion_inicial_bruto_uf,
	ifp.linea_finan_original_uf,
	ifp.linea_finan_original_BG_uf,
	deuda.diferencia_uf as diferencia_uf,
	0 as factura_por_cobrar,
	ifp.banco,
	reporte_comercial.Total_Venta_Pto_UF,
	reporte_comercial.Total_Saldos_por_recibir_UF,
	reporte_comercial.Saldos_recibir_Pdtes_por_Vender, 
	reporte_comercial.Saldos_recibir_Vendidos,
	reporte_comercial.Ingresos_recuperados,
	reporte_comercial.Nro_Viviendas_Vendidas_Netas,
	null as monto_uf,
	CONVERT(varchar, GETDATE(), 23) as fecha_actualizacion 
from informacion_proyectos ip left join 
(
	SELECT 
		case when C.ID_ETAPA like 'PUC.III80' THEN 'COR.III80'
		ELSE C.ID_ETAPA END 
	    AS ID_ETAPA,
	    SUM(CASE WHEN P.ESTADO ='EJECUTADO' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS Porcentaje_ejecucion
	FROM [GPR-APP-PLANIFICACION].dbo.plan_semanal AS P
	LEFT JOIN [GPR-APP-PLANIFICACION].dbo.usuarios AS U ON U.UID = P.RESPONSABLE
	LEFT JOIN [GPR-APP-PLANIFICACION].dbo.cab_plan_base AS C ON C.ID_PB = P.ID_PB
	GROUP BY C.ID_ETAPA
) as avance_obra on ip.id_proyecto = avance_obra.ID_ETAPA
inner join informacion_financiera_proyectos ifp on ifp.nombre_proyecto = ip.nombre_proyecto
left join (
	(
		select 
			rcf.Total_Venta_Pto_UF,
			rcf.Total_Saldos_por_recibir_UF,
			rcf.Saldos_recibir_Pdtes_por_Vender, 
			rcf.Saldos_recibir_Vendidos,
			rcf.Ingresos_recuperados,
			rcf.Nro_Viviendas_Vendidas_Netas, 
			ps.nombre_proyecto
		from reporte_comercial_finanzas rcf left join proyecto_subagrupacion ps on 
		rcf.proyecto = ps.proyecto and ps.etapa = rcf.etapa and
		ps.subagrupacion = rcf.subagrupacion
)
union
(


	select 
		monto_contrato.monto_contrato as Total_Venta_Pto_UF,
		(monto_contrato.monto_contrato-facturas_por_cobrar.ingreso_recuperado)
		  as Total_Saldos_por_recibir_UF, --ok
		case when monto_contrato.nombre_proyecto ='Condominio Los Peumos' OR monto_contrato.nombre_proyecto = '53 Viv. Condominio Raimann (1ra parte)' then
		(monto_contrato.monto_contrato-facturas_por_cobrar.ingreso_recuperado)-((facturas_por_cobrar.total_ingresos_por_recibir-facturas_por_cobrar.ingreso_recuperado)+facturas_por_cobrar.diferencia_uf) 
		else -1*((monto_contrato.monto_contrato-facturas_por_cobrar.ingreso_recuperado)-((facturas_por_cobrar.total_ingresos_por_recibir-facturas_por_cobrar.ingreso_recuperado)+facturas_por_cobrar.diferencia_uf))
		end as  Saldos_recibir_Pdtes_por_Vender,
		case when monto_contrato.nombre_proyecto ='Condominio Los Peumos' OR monto_contrato.nombre_proyecto = '53 Viv. Condominio Raimann (1ra parte)' then
		(facturas_por_cobrar.total_ingresos_por_recibir-facturas_por_cobrar.ingreso_recuperado)+facturas_por_cobrar.diferencia_uf 
		else (monto_contrato.monto_contrato-facturas_por_cobrar.ingreso_recuperado)-(-1*((monto_contrato.monto_contrato-facturas_por_cobrar.ingreso_recuperado)-((facturas_por_cobrar.total_ingresos_por_recibir-facturas_por_cobrar.ingreso_recuperado)+facturas_por_cobrar.diferencia_uf)))
		end
		as Saldos_recibir_Vendidos,
		facturas_por_cobrar.ingreso_recuperado as Ingresos_recuperados,
		0 as Nro_Viviendas_Vendidas_Netas, 
		monto_contrato.nombre_proyecto
	from
	(
		SELECT 
			dcf.cresultado, 
			paf.nombre_proyecto, 
			dcf.ingreso_recuperado,
			dcf.total_ingresos_por_recibir as total_ingresos_por_recibir,
			dcf.diferencia_uf
		from deuda_creditos_finanzas dcf 
		left join proyecto_auranet_finanzas paf on dcf.cresultado = paf.nombre_auranet_constructora
	) as facturas_por_cobrar inner join (
		(select 'Condominio Los Peumos' as nombre_proyecto, 299604.3 as monto_contrato)
		union
		(select 'Obras Urbanización Alto Jahuel' as nombre_proyecto, 23943.67 as monto_contrato)
		union
		(select '53 Viv. Condominio Raimann (1ra parte)' as nombre_proyecto, 241900.28 as monto_contrato)
		) as monto_contrato 
		on monto_contrato.nombre_proyecto = facturas_por_cobrar.nombre_proyecto
		
		
)
) as reporte_comercial
on reporte_comercial.nombre_proyecto = ip.nombre_proyecto 
left join (
	SELECT 
		dcf.cresultado, 
		paf.nombre_proyecto, 
		dcf.diferencia_uf 
	from deuda_creditos_finanzas_propios dcf 
	left join proyecto_auranet_finanzas paf on dcf.cresultado = paf.nombre_auranet
) as deuda on deuda.nombre_proyecto = ip.nombre_proyecto 
where ip.nombre_proyecto not in ('Linea Boletas Generales')
)
union (
select mbg.empresa,
	mbg.nombre_proyecto,
	null as ubicacion,
	null as monto_inferior_uf,
	null as monto_superior_uf,
	null as fecha_inicio,
	null as fecha_termino_presentada,
	null as Porcentaje_ejecucion,
	null as numero_viviendas,
	null as costo_directo_construccion_inicial_bruto_uf,
	null as linea_finan_original_uf,
	null as linea_finan_original_BG_uf,
	null as diferencia_uf,
	null as factura_por_cobrar,
	mbg.banco,
	null as Total_Venta_Pto_UF,
	null as Total_Saldos_por_recibir_UF,
	null as Saldos_recibir_Pdtes_por_Vender, 
	null as Saldos_recibir_Vendidos,
	null as Ingresos_recuperados,
	null as Nro_Viviendas_Vendidas_Netas,
	mbg.monto_uf,
	CONVERT(varchar, GETDATE(), 23) as fecha_actualizacion 
FROM monto_boletas_garantia mbg
)
