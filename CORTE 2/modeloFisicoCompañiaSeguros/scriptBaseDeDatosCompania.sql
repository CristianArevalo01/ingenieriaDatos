## Query instruccion o peticion a la base de datos (comentario en linea)
/*
Comentario en bloque
Lenguaje de definicion de datos DDL
create: crear
alter: alteraciones
drop: borrar
truncate: modificar / eliminar
*/
##Creacion de base de datos create database nombre_base_datos todo minuscula
create database companiaseguros;

##Encender la base de datos use nombre_BD
use companiaseguros;

/*Crear las tablas
create table nombre_table (
campo1 tipodato tamaño restriccion,
campo2 tipodato tamaño restriccion,
campo3 tipodato tamaño restriccion
);
int auto_increment
*/
create table compania (
idCompania varchar (50) primary key,
nit varchar (20) unique not null,
nombreCompania varchar (50) not null,
fechaFundacion date null,
representantelegal varchar(50) not null
);

create table seguros (
idSeguro varchar (50) primary key,
fechaInicio date not null,
fechaExpiracion date not null,
estado varchar (20) not null,
costo double not null,
valorAsegurado double not null,
idCompaniaFK varchar (50) not null,
idAutomovilFK varchar (50) not null
);

create table automovil (
placa varchar (10) primary key,
idAutomovil varchar (50),
marca varchar (50) not null,
modelo varchar (50) not null,
tipo varchar (50) not null,
anoFabricacion date not null,
serialchasis varchar (50) not null,
cilindraje int not null,
pasajeros int not null
);

create table detalle_accidente (
idDetalleAccidente varchar (50) primary key,
placaFK varchar (10),
idAccidenteFK varchar (50)
);

create table accidente (
idAccidente varchar (50) primary key,
fechaAccidente date not null,
lugar varchar (50) not null,
fatalidades int null,
heridos int null
);