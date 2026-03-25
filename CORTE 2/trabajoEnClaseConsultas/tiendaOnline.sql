/*
Autor: Cristian Daniel Arevalo Esguerra
*/
create database if not exists tiendaOnline;
use tiendaOnline;

create table clientes(
idCliente int primary key auto_increment,
nombreCliente varchar(100) not null,
emailCliente varchar(150) unique,
ciudad varchar(80) null,
creado_en datetime default now()
);

create table productos(
idProducto int primary key auto_increment,
nombreProducto varchar(120) not null,
precioProducto decimal(10,2),
stockProducto int default 0,
categoriaProducto varchar(60)
);

create table pedido(
idPedido int primary key auto_increment,
cantidadProducto int not null,
fechaPedido date,
idClienteFK int,
idProductoFK int,
foreign key (idClienteFK) references clientes(idCliente),
foreign key (idProductoFK) references productos(idProducto)
);

create table cliente_backup (
idClienBack int primary key auto_increment,
nombreCliente varchar(100) ,
emailCliente varchar(150),
copiado_en datetime default now()
);

insert into clientes(idCliente,nombreCliente,emailCliente,ciudad) values ('','Ana Garcia','ana@mail.com','Madrid');
insert into clientes(nombreCliente,emailCliente,ciudad) values ('Pedro Perez','pedro@mail.com','Barcelona');

insert into productos (nombreProducto,precioProducto,stockProducto,categoriaProducto)
values ('Laptop Pro',1200000,15,'Electrónica'), 
('Mouse USB',50000,80,'Accesorios'),
('Monitor 32"',500000,20,'Electrónica'),
('Teclados',100000,35,'Accesorios');

insert into cliente_backup (nombreCliente,emailCliente)
select nombreCliente,emailCliente
from clientes
where creado_en<'2026-03-20';

/* INSERT
1. Inserta 3 clientes nuevos con nombre, email y ciudad
2. Inserta 2 productos con nombre, precio, stock y categoría
3. Inserta 1 pedido vinculando un cliente y un producto recién creados
UPDATE
4. Cambia la ciudad de uno de tus clientes insertados
5. Aumenta en 5 unidades el stock de uno de tus productos
6. Modifica el precio del segundo producto aplicando un descuento del 10%
DELETE
7. Elimina el pedido que creaste en el punto 3
8. Elimina el cliente cuya ciudad cambiaste en el punto 4
9. Elimina todos los productos con stock menor a 3
*/
insert into clientes(nombreCliente,emailCliente,ciudad) 
values ('Cristian Arevalo','cristian@mail.com','Bogota'),
('Sara Ferro','sara@mail.com','cali'),
('Alisson Nawal','alisson@mail.com','Medellin');

insert into productos (nombreProducto,precioProducto,stockProducto,categoriaProducto)
values ('Camara',120000,3,'Accesorios'), 
('Audifonos',80000,15,'Accesorios');

describe productos;
select * from clientes;
select * from productos;
select * from pedido;
insert into pedido(cantidadProducto,fechaPedido,idClienteFK,idProductoFK) values (3,'2026-03-19',3,5);

update clientes set ciudad='Bucaramanga' where idCliente=4;

update productos set stockProducto=stockProducto + 5 where idProducto=2;

update productos set precioProducto=precioProducto - (precioProducto * 0.1) where idProducto=2;

delete from pedido where idPedido = 1;

delete from clientes where idCliente = 4;

delete from productos where stockProducto < 3;

### Sentencia para consultas 25/03/26
describe productos;

alter table productos change stockProducto stoProdT int(11);

### consulta general con dos campos en especifico
select nombreProducto, stoProdT from productos;

### Alias: Cambia unicamente la forma en como se ve al momento de ejecutar la consulta
select nombreProducto as Nombre_Producto, stoProdT as stock from productos;

### consulta con condicion
select nombreProducto, stoProdT from productos where idProducto = 1;
select nombreProducto as Nombre_Producto, stoProdT as stock from productos where stoProdT >= 15 and idProducto = 1;
select nombreProducto as Nombre_Producto, stoProdT as stock from productos where stoProdT >= 15 and nombreProducto = 'Laptop Pro';
select nombreProducto as Nombre_Producto, stoProdT as stock from productos where stoProdT >= 25 or idProducto = 1;
###ordenar select campos from nomTabla order by campo_a_ordenar formaOrden(ASC/DESC) ASC: ascendente, DESC: descendente
select nombreProducto as Nombre_Producto, stoProdT as stock from productos order by stoProdT ASC;
select nombreProducto as Nombre_Producto, stoProdT as stock from productos order by idProducto ASC;
select nombreProducto as Nombre_Producto, stoProdT as stock from productos order by nombreProducto DESC;

## consulta por rangos(between) 
select * from productos;
## select campos from nomTabla between valor1 and valor2
select nombreProducto as Nombre_Producto, precioProducto as Precio from productos where precioProducto between 500 and 10000 and stoProdT>3 order by precioProducto ASC;
select nombreProducto as Nombre_Producto, precioProducto as Precio from productos where precioProducto between 50000 and 100000 and stoProdT>3 order by precioProducto ASC;

##consultas like caracteres que inicien, terminen o contengan
##Inicia
select * from productos where nombreProducto like 'a%';
select * from productos where nombreProducto like 'm%';
select * from productos where nombreProducto like 'mon%';
select * from productos where nombreProducto not like 'mon%';
##Contenga
select * from productos where nombreProducto like '%o%';
select * from productos where nombreProducto not like '%o%';
##Termine / limit #de datos que va a mostrar ej; limit 10
select * from productos where nombreProducto like '%os';
select * from productos where nombreProducto like '%os' order by precioProducto ASC limit 10;

##Consultas especificas con funciones varchar y enteros (2 y 2)
select categoriaProducto as Categoria_Producto from productos where upper(categoriaProducto)='accesorios';
