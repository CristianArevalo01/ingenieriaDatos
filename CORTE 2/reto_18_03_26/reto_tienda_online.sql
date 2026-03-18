##Reto 1: 
create database tienda_online;
use tienda_online;

##Reto 2:
create table producto (
idProducto int primary key auto_increment,
nombreProducto varchar(20) not null,
precioProducto decimal not null,
stockProducto int not null, 
fechaCreacionProducto datetime default current_timestamp
);

##Reto 3:
create table cliente (
idCliente int primary key auto_increment,
nombreCliente varchar(20) not null,
emailCliente varchar (50) not null,
telefonoCliente varchar (50) null 
);

create table pedido(
idPedido int primary key auto_increment,
fechaPedido date not null,
totalPedido int not null,
idClienteFK int not null,
constraint idClienteFK
foreign key (idClienteFK)
references cliente (idCliente)
);

##Reto 4:
alter table producto add categoria varchar (50) not null;
alter table cliente modify telefonoCliente varchar (15);
alter table pedido change totalPedido montoTotal varchar (20);
alter table producto drop column fechaCreacionProducto;
