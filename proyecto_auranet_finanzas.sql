-- al estar en el haber se toma la fecha doc
-- al estar al debe se toma la fecha 
-- en base al mes se debe tomar el valor uf del mes
/*
create table proyecto_auranet_finanzas (
	nombre_proyecto varchar(500),
	nombre_auranet varchar(500),
	nombre_auranet_constructora varchar(500),
	vigencia varchar(50)
);
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('Linea Boletas Generales','S/I','S/I','S/I');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('Linea Boletas Generales','S/I','S/I','S/I');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('Condominio Los Peumos','2022.LP.125','2022.LP.I.125','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('Obras Urbanización Alto Jahuel','2023.E.AJ.I','2023.E.AJ.I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('53 Viv. Condominio Raimann (1ra parte)','2024.CRAIM.I.53','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('53 Viv. Condominio Raimann (2da parte)','NO CREADO','S/I','');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('Administración','S/I','ADMINISTACION','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('79 Viviendas Puerto Montt','S/I','S/I','S/I');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('76 Viviendas Puente Alto','PUENTE ALTO 76 DP','S/I','NO VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('64 Departamentos Puente Alto','PALTO64.DP','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('88 Viviendas Puente Alto','PAII88.DP','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('96 Departamentos Puente Alto','PAII96.DP','2023.PA.VI.96','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('64 Departamentos Altos de Mirador','ADM64DP.D1','2022.CADM.I.64','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('67 Viviendas Sendero Santa Clara Etapa 1','SSC.65.DP','S/I','NO VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('60 Viviendas Sendero Santa Clara Etapa 2','SSC.60.DP','S/I','NO VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('60 Viviendas Sendero Santa Clara Etapa 3','SSC60.E3DP','2021.SSC.III.60','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('64 Departamentos Sendero Santa Clara','SSC64DP.D1','2022.SSC.IV.64','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('58 Townhouses Sendero Santa Clara','SSC.58.TWH.DP','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('135 Buin','BUIN135.DP','2021.BN.V.135','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('80 Deptos. Parque Pucalán','CORV.1.DP','S/I','NO VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('80 Deptos. Parque Pucalán Etapa 2','CORV.2.DP','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('80 Deptos. Parque Pucalán Etapa 3','CORV.3.DP','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('63 Viviendas Altos de Mirador','ADM63.DP','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('62 Viviendas Altos de Mirador','ADM62.DP','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('61 Viviendas Altos de Mirador','ADM.61.DP','2023.OLI.V.61','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('69 TWH Terrazas de Mirador','TDM.69.DP','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('69 Viviendas Hualpén','HP.69.DP','HP.69.VI','NO VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('80 Departamentos Hualpen III, Etapa I','HP80DP.7A2','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('80 Departamentos Hualpen III, Etapa II','2022.HP80II.DP7A2','S/I','VIGENTE');
insert into proyecto_auranet_finanzas(nombre_proyecto, nombre_auranet, nombre_auranet_constructora,vigencia) values ('80 Departamentos Hualpen III, Etapa III','2023.HP80III.DP7A2','2023.HP.VII.80','VIGENTE');


*/

SELECT 
		dcf.cresultado, 
		paf.nombre_proyecto, 
		dcf.diferencia_uf as factura_por_cobrar 
	from deuda_creditos_finanzas dcf 
	left join proyecto_auranet_finanzas paf on dcf.cresultado = paf.nombre_auranet_constructora
	where dcf.diferencia_uf >0

SELECT dcf.cresultado, paf.nombre_proyecto, round(dcf.diferencia_uf*-1, 2) as diferencia_uf
from deuda_creditos_finanzas dcf left join proyecto_auranet_finanzas paf on dcf.cresultado like CONCAT('%',paf.nombre_auranet,'%');

select * from proyecto_auranet_finanzas paf;
select sum(dcf.diferencia_uf)
from deuda_creditos_finanzas dcf
group by dcf.cresultado;

select *
from reporte_comercial_finanzas rcf inner join proyecto_subagrupacion ps on ps.subagrupacion = rcf.subagrupacion;

select * from deuda_creditos_finanzas dcf;


select top 1 fecha, precio_uf  from VALOR_UF vu order by fecha desc;

SELECT empresa,
    nombre_proyecto,
    diferencia_uf,
    factura_por_cobrar as facturas_por_cobrar,
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
    banco,
    Total_Venta_Pto_UF,
    Total_Saldos_por_recibir_UF,
    Saldos_recibir_Pdtes_por_Vender,
    Saldos_recibir_Vendidos,
    Ingresos_recuperados,
    Nro_Viviendas_Vendidas_Netas
  FROM DS_balance_inmobiliario;