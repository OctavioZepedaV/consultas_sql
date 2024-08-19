
/*
 create table informacion_proyectos (
	empresa	varchar(250),
	nombre_proyecto	varchar(250),
	ubicacion	varchar(250),
	monto_inferior_uf	float,
	monto_superior_uf	float,
	fecha_inicio date,
	fecha_termino_presentada	date,
	numero_viviendas int,
	id_proyecto varchar(50)
);

insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('CONSTRUCTORA GPR S.A.','Linea Boletas Generales','',0,0,'','',0,'');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('CONSTRUCTORA GPR S.A.','Linea Boletas Generales','',0,0,'','',0,'');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('CONSTRUCTORA GPR S.A.','Condominio Los Peumos','Quilicura',0,0,'03-10-2022','15-05-2024',125,'LP.I125');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('CONSTRUCTORA GPR S.A.','Obras Urbanización Alto Jahuel','Buin',0,0,'01-08-2023','31-05-2024',0,'M.EAJ');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('CONSTRUCTORA GPR S.A.','53 Viv. Condominio Raimann (1ra parte)','Puerto Varas',0,0,'15-01-2024','30-03-2024',53,'CRAIM.I53');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('CONSTRUCTORA GPR S.A.','53 Viv. Condominio Raimann (2da parte)','Puerto Varas',0,0,'25-03-2024','15-08-2025',53,'CRAIM.I53');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR PTO VARAS LTDA. ','79 Viviendas Puerto Montt','Puerto Montt',1460,2300,'01-09-2013','31-08-2014',79,'-');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR LAS CAÑAS LTDA.','76 Viviendas Puente Alto','Puente Alto',2090,2510,'02-10-2017','31-05-2019',76,'-');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR LAS CAÑAS LTDA.','64 Departamentos Puente Alto','Puente Alto',2700,2900,'19-07-2021','30-06-2023',64,'PA.IV64');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR LAS CAÑAS LTDA.','88 Viviendas Puente Alto','Puente Alto',3200,3600,'23-08-2022','15-01-2024',88,'PA.V88');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR LAS CAÑAS LTDA.','96 Departamentos Puente Alto','Puente Alto',2700,3500,'23-10-2023','31-12-2024',96,'PA.VI96');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA JP COQUIMBO S.A.','64 Departamentos Altos de Mirador','Coquimbo',2000,2500,'15-11-2022','31-03-2024',64,'CADM.I64');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA JP COQUIMBO S.A.','67 Viviendas Sendero Santa Clara Etapa 1','Coquimbo',2400,3300,'05-08-2019','05-08-2020',67,'SSC.I67');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA JP COQUIMBO S.A.','60 Viviendas Sendero Santa Clara Etapa 2','Coquimbo',2600,3400,'05-10-2020','05-09-2021',60,'SSC.II60');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA JP COQUIMBO S.A.','60 Viviendas Sendero Santa Clara Etapa 3','Coquimbo',3100,3500,'07-09-2021','15-12-2022',60,'SSC.III60');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA JP COQUIMBO S.A.','64 Departamentos Sendero Santa Clara','Coquimbo',2300,3000,'03-01-2023','31-03-2024',64,'SSC.IV64');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA JP COQUIMBO S.A.','58 Townhouses Sendero Santa Clara','Coquimbo',3100,3950,'18-03-2024','28-02-2024',58,'-');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA JP S.A.','','Buin',3500,4200,'01-07-2021','31-05-2023',135,'BN.V135');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR SAN RAMON LTDA.','80 Deptos. Parque Pucalán','Puerto Montt',2000,2300,'15-01-2020','01-03-2022',80,'COR.I80');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR SAN RAMON LTDA.','80 Deptos. Parque Pucalán Etapa 2','Puerto Montt',2200,2400,'01-06-2021','15-12-2022',80,'COR.II80');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR SAN RAMON LTDA.','80 Deptos. Parque Pucalán Etapa 3','Puerto Montt',2600,2800,'17-10-2022','15-11-2023',80,'COR.III80');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR SAN RAMON LTDA.','63 Viviendas Altos de Mirador','Coquimbo',2300,2700,'14-06-2021','30-10-2022',63,'-');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR SAN RAMON LTDA.','62 Viviendas Altos de Mirador','Coquimbo',2600,3000,'15-06-2022','15-07-2023',62,'OLI.IV62');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR SAN RAMON LTDA.','61 Viviendas Altos de Mirador','Coquimbo',2500,3300,'01-09-2023','30-08-2024',61,'OLI.V61');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA TERRAZAS DE MIRADOR','69 TWH Terrazas de Mirador','Puerto Varas',4200,4800,'15-12-2023','31-01-2025',69,'TM.I69');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR HUALPEN LTDA.','69 Viviendas Hualpén','Hualpén',2100,2400,'15-11-2019','15-10-2020',69,'-');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR HUALPEN LTDA.','80 Departamentos Hualpen III, Etapa I','Hualpén',2000,2300,'22-10-2021','30-10-2022',100,'HP.V80');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR HUALPEN LTDA.','80 Departamentos Hualpen III, Etapa II','Hualpén',2100,2300,'15-11-2022','30-10-2023',80,'HP.VI80');
insert into informacion_proyectos(empresa,nombre_proyecto,ubicacion,monto_inferior_uf,monto_superior_uf,fecha_inicio,fecha_termino_presentada, numero_viviendas,id_proyecto) values('INMOBILIARIA GPR HUALPEN LTDA.','80 Departamentos Hualpen III, Etapa III','Hualpén',2100,2500,'16-10-2023','16-09-2024',80,'HP.VII80');


create table informacion_financiera_proyectos (
	nombre_proyecto varchar(250),
	costo_directo_construccion_inicial_bruto_uf float, 
	linea_finan_original_uf float, 
	linea_finan_original_BG_uf float, 
	banco varchar(250)
)


insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('Linea Boletas Generales',0,0,15000,'Santander');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('Linea Boletas Generales',0,0,10000,'Banco de Chile');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('Condominio Los Peumos',210154,0,60000,'Aspor');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('Obras Urbanización Alto Jahuel',17649.7631578947,0,4788.73374,'Santander');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('53 Viv. Condominio Raimann (1ra parte)',178843,0,0,'-');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('53 Viv. Condominio Raimann (2da parte)',178843,0,35299,'En evaluación');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('79 Viviendas Puerto Montt',77667.086,85667.086,0,'Itau');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('76 Viviendas Puente Alto',113096,107314,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('64 Departamentos Puente Alto',132000,125400,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('88 Viviendas Puente Alto',144000,142000,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('96 Departamentos Puente Alto',135547,135547,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('64 Departamentos Altos de Mirador',93150,110000,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('67 Viviendas Sendero Santa Clara Etapa 1',114626,110258,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('60 Viviendas Sendero Santa Clara Etapa 2',102331.46,102331.46,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('60 Viviendas Sendero Santa Clara Etapa 3',107150,108000,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('64 Departamentos Sendero Santa Clara',109406,109406,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('58 Townhouses Sendero Santa Clara',128770,128770,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('135 Buin',277148,277148,0,'Security');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('80 Deptos. Parque Pucalán',89000,107467,0,'Santander');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('80 Deptos. Parque Pucalán Etapa 2',106266,106266,0,'Santander');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('80 Deptos. Parque Pucalán Etapa 3',122873,115442,0,'Santander');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('63 Viviendas Altos de Mirador',91753,91753,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('62 Viviendas Altos de Mirador',91368,91368,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('61 Viviendas Altos de Mirador',104706.260917547,105000,0,'Estado');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('69 TWH Terrazas de Mirador',187366,169000,0,'Chile');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('69 Viviendas Hualpén',96209,95537,0,'Chile');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('80 Departamentos Hualpen III, Etapa I',133849,101867,0,'Chile');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('80 Departamentos Hualpen III, Etapa II',100859,100859,0,'Chile');
insert into informacion_financiera_proyectos (nombre_proyecto,costo_directo_construccion_inicial_bruto_uf, linea_finan_original_uf, linea_finan_original_BG_uf, banco) values ('80 Departamentos Hualpen III, Etapa III',97467.939,97500,0,'Chile');


DROP TABLE proyecto_subagrupacion;

create table proyecto_subagrupacion (
	nombre_proyecto varchar(500),
	proyecto varchar(500),
	etapa varchar(500),
	subagrupacion varchar(500)
);

insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('64 Departamentos Puente Alto','CONDOMINIO ALTOS DEL PEÑON','CADP 64','ETAPA I - 64 ');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('88 Viviendas Puente Alto','ALTOS DEL PEÑON','ADP 88','ETAPA IV - 88 VIVIENDAS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('96 Departamentos Puente Alto','CONDOMINIO ALTOS DEL PEÑON','CADP 96','ETAPA II - 96 ');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('64 Departamentos Altos de Mirador','CONDOMINIO ALTOS DEL MIRADOR','CADM 64','ETAPA I - 64 DEPARTAMENTOS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('67 Viviendas Sendero Santa Clara Etapa 1','SENDEROS SANTA CLARA','ETAPA I - 67 VIVIENDAS','ETAPA I - 67 VIVIENDAS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('60 Viviendas Sendero Santa Clara Etapa 2','SENDEROS SANTA CLARA','ETAPA II - 60 VIVIENDAS','ETAPA II - 60 VIVIENDAS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('60 Viviendas Sendero Santa Clara Etapa 3','SENDEROS SANTA CLARA','ETAPA III - 60 VIVIENDAS','ETAPA III - 60 VIVIENDAS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('64 Departamentos Sendero Santa Clara','CONDOMINIO SENDEROS SANTA CLARA','CSSC 64','ETAPA I - 64 DEPARTAMENTOS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('58 Townhouses Sendero Santa Clara','CONDOMINIO HACIENDA SANTA CLARA','CHSC 58','ETAPA I');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('135 Buin','CONDOMINIO PRADOS DE BUIN','PDB 135','ETAPA V - 135 VIVIENDAS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('80 Deptos. Parque Pucalán','CONDOMINIO BOSQUE PUCALÁN','PUC 80-1','PUC 80-1');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('80 Deptos. Parque Pucalán Etapa 2','CONDOMINIO BOSQUE PUCALÁN','PUC 80-2','PUV 80-2');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('80 Deptos. Parque Pucalán Etapa 3','CONDOMINIO BOSQUE PUCALÁN','PUC 80-3','PUC 80-3');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('63 Viviendas Altos de Mirador','ALTOS DEL MIRADOR','ETAPA X - 63 VIVIENDAS','ETAPA X - 63 VIVIENDAS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('62 Viviendas Altos de Mirador','ALTOS DEL MIRADOR','ADM 62 ','ETAPA XI - 62 VIVIENDAS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('61 Viviendas Altos de Mirador','ALTOS DEL MIRADOR','ADM 61 ','ADM 61 VIVIENDAS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('69 TWH Terrazas de Mirador','TERRAZAS MIRADOR DE PUERTO VARAS','TDM 69','PRIMERA ETAPA');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('80 Departamentos Hualpen III, Etapa I','CONDOMINIO ALTOS DE HUALPÉN','HLP 80-1','HLP 80-1');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('80 Departamentos Hualpen III, Etapa II','CONDOMINIO ALTOS DE HUALPÉN','HLP 80-2','ETAPA IV - 80 DEPARTAMENTOS');
insert into proyecto_subagrupacion(nombre_proyecto, proyecto, etapa, subagrupacion) values ('80 Departamentos Hualpen III, Etapa III','CONDOMINIO ALTOS DE HUALPÉN','HLP 80-3','HLP 80-3');

*/
/*
SELECT 
    C.ID_ETAPA,
    SUM(CASE WHEN P.ESTADO ='EJECUTADO' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS Porcentaje_ejecución
FROM 
    [GPR-APP-PLANIFICACION].dbo.plan_semanal AS P
LEFT JOIN 
    [GPR-APP-PLANIFICACION].dbo.usuarios AS U ON U.UID = P.RESPONSABLE
LEFT JOIN 
    [GPR-APP-PLANIFICACION].dbo.cab_plan_base AS C ON C.ID_PB = P.ID_PB
GROUP BY C.ID_ETAPA;


-- drop table DS_balance_inmobiliario; 
create table DS_balance_inmobiliario (
	empresa varchar(500),
	nombre_proyecto varchar(500),
	ubicacion varchar(500),
	monto_inferior_uf float,
	monto_superior_uf float,
	fecha_inicio date,
	fecha_termino_presentada date,
	Porcentaje_ejecucion float,
	numero_viviendas int,
	costo_directo_construccion_inicial_bruto_uf float,
	linea_finan_original_uf float,
	linea_finan_original_BG_uf float,
	diferencia_uf float,
	factura_por_cobrar float,
	banco varchar(500),
	Total_Venta_Pto_UF float,
	Total_Saldos_por_recibir_UF float, 
	Saldos_recibir_Pdtes_por_Vender float,
	Saldos_recibir_Vendidos float,
	Ingresos_recuperados float,
	Nro_Viviendas_Vendidas_Netas int,
	monto_boletas_garantia float,
	fecha_actualizacion date
);

*/


/*
select 
		rcf.Total_Venta_Pto_UF,
		rcf.Total_Saldos_por_recibir_UF,
		rcf.Saldos_recibir_Pdtes_por_Vender, 
		rcf.Saldos_recibir_Vendidos,
		rcf.Ingresos_recuperados,
		rcf.Nro_Viviendas_Vendidas_Netas, ps.nombre_proyecto
from reporte_comercial_finanzas rcf left join proyecto_subagrupacion ps on ps.subagrupacion = rcf.subagrupacion
;

SELECT 
		dcf.cresultado, 
		paf.nombre_proyecto, 
		sum(dcf.diferencia_uf) as diferencia_uf
from deuda_creditos_finanzas dcf 
left join proyecto_auranet_finanzas paf on dcf.cresultado = paf.nombre_auranet
group by dcf.cresultado, 
		paf.nombre_proyecto
;

select cresultado, max(diferencia_uf) as diferencia_uf from deuda_creditos_finanzas dcf group by dcf.cresultado;




SELECT TABLE_NAME 
FROM information_schema.tables WHERE TABLE_SCHEMA = 'dbo';
*/