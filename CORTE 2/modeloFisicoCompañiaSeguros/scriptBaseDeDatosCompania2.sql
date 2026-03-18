/* Autor: CRISTIAN DANIEL AREVALO ESGUERRA
Nuevo campo: Se agrego el campo nomPropietario a la tabla automovil.
Eliminación campo: Se elimino el campo nomPropietario de la tabla automovil.
Actualización nombre tabla automovil: Se cambio el nombre de la tabla automovil a vehiculo.
Eliminacion FK idCompania: Se elimino la relacion entre compania y seguros.
Creacion idCompaniaFK: Se creo nuevamente la relacion entre compania y seguros.
*/

create database companiaseguros;
use companiaseguros;

create table compania (
idCompania varchar (50) primary key,
nit varchar (20) unique not null,
nombreCompania varchar (50) not null,
fechaFundacion date null,
representantelegal varchar(50) not null
);

create table automovil (
idAutomovil varchar (50) primary key,
placa varchar (10) not null,
marca varchar (50) not null,
modelo varchar (50) not null,
tipo varchar (50) not null,
anoFabricacion date not null,
serialchasis varchar (50) not null,
cilindraje int not null,
pasajeros int not null
);

create table seguros (
idSeguro varchar (50) primary key,
fechaInicio date not null,
fechaExpiracion date not null,
estado varchar (20) not null,
costo double not null,
valorAsegurado double not null,
idCompaniaFK varchar (50) not null,
idAutomovilFK varchar (50) not null,
constraint idCompaniaFK
foreign key (idCompaniaFK)
references compania (idCompania),
constraint idAutomovilFK
foreign key (idAutomovilFK)
references automovil (idAutomovil)
);

create table accidente (
idAccidente varchar (50) primary key,
fechaAccidente date not null,
lugar varchar (50) not null,
fatalidades int null,
heridos int null
);

create table detalle_accidente (
idDetalleAccidente varchar (50) primary key,
idAutomovilFK varchar (50) not null,
idAccidenteFK varchar (50) not null,
foreign key (idAutomovilFK)
references automovil (idAutomovil),
constraint idAccidenteFK
foreign key (idAccidenteFK)
references accidente (idAccidente)
);

alter table automovil add nomPropietario varchar (50) not null;

alter table automovil drop column nomPropietario;

alter table automovil rename to vehiculo;

alter table seguros drop foreign key idCompaniaFK;

alter table seguros
add constraint idCompaniaFk
foreign key (idCompaniaFk)
references compania (idCompania);