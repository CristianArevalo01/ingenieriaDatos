-- DDL: Creación de base de datos y tablas
create database tienda_tech character set utf8mb4;
use tienda_tech;

create table clientes (
	cliente_id int primary key auto_increment,
    nombre varchar(100) not null,
    email varchar(100) unique not null,
    ciudad varchar(60),
    fecha_registro date default (current_date()));
    
create table productos (
	producto_id int auto_increment primary key,
    nombre varchar(100) not null,
    categoria varchar(60),
    precio decimal(10,2) not null check(precio>0),
    stock int default 0
);

create table pedidos (
	pedido_id int auto_increment primary key,
    cliente_id int not null,
    producto_id int not null,
    cantidad int not null check(cantidad>0),
    fecha_pedido date default (current_date()),
    estado varchar(20) default 'pendiente' check (estado in ('pendiente','entregado','cancelado')),
    foreign key (cliente_id) references clientes(cliente_id),
    foreign key (producto_id) references productos(producto_id)
);

-- DML: datos de prueba
describe clientes;
INSERT INTO clientes VALUES
 (1,"Ana Lopez","ana@mail.com","Bogota","2023-01-15"),
 (2,"Carlos Ruiz","carlos@mail.com","Medellin","2023-03-22"),
 (3,"Maria Torres","maria@mail.com","Cali","2023-05-10"),
 (4,"Pedro Gomez","pedro@mail.com","Bogota","2023-07-08"),
 (5,"Sofia Herrera","sofia@mail.com","Barranquilla","2023-09-01"),
 (6,"Luis Martinez","luis@mail.com","Bogota","2024-01-20"),
 (7,"Camila Vargas","camila@mail.com","Cali","2024-02-14"),
 (8,"Diego Morales","diego@mail.com","Medellin","2024-03-30");
 
describe productos;
INSERT INTO productos VALUES
 (1,"Laptop Pro 15","Computadores",3500000.00,12),
 (2,"Mouse Inalambrico","Perifericos",85000.00,50),
 (3,"Teclado Mecanico","Perifericos",220000.00,30),
 (4,"Monitor 27","Pantallas",1200000.00,8),
 (5,"Auriculares BT","Audio",350000.00,25),
 (6,"Webcam HD","Perifericos",180000.00,20),
 (7,"Disco SSD 1TB","Almacenamiento",420000.00,40),
 (8,"Tablet 10","Moviles",1800000.00,6);

describe pedidos;
INSERT INTO pedidos VALUES
 (1,1,1,1,"2024-01-10","entregado"),(2,1,2,2,"2024-01-15","entregado"),
 (3,2,3,1,"2024-02-05","entregado"),(4,2,5,1,"2024-02-20","cancelado"),
 (5,3,4,1,"2024-03-01","entregado"),(6,3,7,2,"2024-03-15","pendiente"),
 (7,4,2,3,"2024-04-02","entregado"),(8,4,6,1,"2024-04-10","pendiente"),
 (9,5,8,1,"2024-04-18","entregado"),(10,6,1,2,"2024-05-05","entregado"),
 (11,6,3,1,"2024-05-12","pendiente"),(12,7,5,2,"2024-05-20","entregado"),
 (13,1,7,1,"2024-06-01","entregado"),(14,8,4,1,"2024-06-10","cancelado"),
 (15,5,2,4,"2024-06-15","entregado"),(16,3,1,1,"2024-07-01","pendiente");
 
 
 /*(1) Agrega la columna total_valor (cantidad * precio) a la tabla pedidos
    Crea un índice sobre la columna estado para optimizar búsquedas*/
    
 -- agrega la columna total_valor a pedidos
 alter table pedidos add column total_valor decimal(12,2) null;
 
 -- Llena total_valor multiplicando cantidad * precio
-- JOIN une pedidos con productos para acceder al precio
 update pedidos p
 join productos pr on p.producto_id = pr.producto_id
 set p.total_valor = p.cantidad*pr.precio;
 
 -- Verifica que el cálculo quedó correcto
 select
	p.pedido_id,
    p.cantidad,
    pr.precio,
    p.total_valor
from pedidos p
join productos pr on p.producto_id=pr.producto_id order by pedido_id asc;

-- Crea índice sobre estado para acelerar búsquedas por esa columna
create index idx_pedidos_estado on pedidos(estado);

-- Confirma que total_valor e idx_pedidos_estado quedaron en la tabla
describe pedidos;
 
 
 /*(2) Crea la tabla log_cambios_estado para registrar cambios de estado en pedidos
	Crea la vista vista_log_reciente con los últimos 10 registros ordenados por fecha*/
    
-- Creacion de la tabla log_cambios_estado
create table log_cambios_estado (
	log_id	int auto_increment primary key,
    pedido_id int not null,
    estado_anterior varchar(20),
    estado_nuevo varchar(20),
    fecha_cambio datetime default now(),
    foreign key (pedido_id) references pedidos(pedido_id));
    
-- Insercion de registros de prueba para poder visualizar la vista
select * from pedidos;
 insert into log_cambios_estado (pedido_id, estado_anterior, estado_nuevo, fecha_cambio) values
	(1,  'pendiente',  'entregado',  '2024-01-10 08:00:00'),
	(2,  'pendiente',  'entregado',  '2024-01-15 09:30:00'),
	(3,  'pendiente',  'entregado',  '2024-02-05 10:00:00'),
	(4,  'pendiente',  'cancelado',  '2024-02-20 11:15:00'),
	(5,  'pendiente',  'entregado',  '2024-03-01 14:00:00'),
	(6,  'pendiente',  'entregado',  '2024-03-15 16:45:00'),
	(7,  'pendiente',  'entregado',  '2024-04-02 08:30:00'),
	(8,  'pendiente',  'pendiente',  '2024-04-10 09:00:00'),
	(9,  'pendiente',  'entregado',  '2024-04-18 13:20:00'),
	(10, 'pendiente',  'entregado',  '2024-05-05 10:10:00'),
	(11, 'pendiente',  'pendiente',  '2024-05-12 11:00:00'),
	(12, 'pendiente',  'entregado',  '2024-05-20 15:30:00');
    
-- Creación de la vista con los ultimos 10 re4gistros ordenados por fecha descendiente
create view v_log_reciente as
select
	log_id,
    pedido_id,
    estado_anterior,
    estado_nuevo,
    fecha_cambio
from log_cambios_estado
order by fecha_cambio desc
limit 10;
select * from v_log_reciente;
 
 
 /*(3) - Inserta un nuevo cliente y su pedido
    - Actualiza el stock del producto correspondiente
    - Consulta con JOIN para verificar el pedido recién creado (multitabla) */
    
 -- INSERCIÓN DEL CLIENTE
 INSERT INTO clientes (nombre, email, ciudad)
VALUES ('Laura Rios', 'laura@mail.com', 'Manizales');

-- insertar pedido
 INSERT INTO pedidos (cliente_id, producto_id, cantidad, estado)
VALUES (LAST_INSERT_ID(), 3, 2, 'pendiente');

-- Disminucion del stock
UPDATE productos
SET stock = stock - 2
WHERE producto_id = 3;

-- consulta del pedido recien creado
describe pedidos;
select
 c.nombre as cliente,
 pr.nombre as producto,
 p.estado
from pedidos p
join clientes c on p.cliente_id=c.cliente_id
join productos pr on p.producto_id=pr.producto_id
where p.pedido_id= last_insert_id();
	
 
 /*(4)- Incrementa 8% el precio de productos cuyo stock sea menor
      al promedio de stock de su misma categoría
    - Elimina pedidos cancelados cuyos clientes no tengan
      ningún pedido entregado (subconsulta)*/
 
-- Para cada producto, calcula el promedio de stock de su misma categoría
-- Si su stock es menor a ese promedio, incrementa el precio un 8%
UPDATE productos p
SET p.precio = p.precio * 1.08
WHERE p.stock < (
    -- Subconsulta correlacionada: se ejecuta una vez por cada fila de productos
    -- p2.categoria = p.categoria vincula la subconsulta con el producto actual
    SELECT AVG(p2.stock)
    FROM productos p2
    WHERE p2.categoria = p.categoria
);
 
 -- Verifica qué precios fueron actualizados
SELECT producto_id, nombre, categoria, stock, precio
FROM productos
ORDER BY categoria;
 
 -- Elimina pedidos cancelados cuyo cliente NO tenga ningún pedido entregado
DELETE FROM pedidos
WHERE estado = 'cancelado'
AND NOT EXISTS (
    -- NOT EXISTS retorna TRUE si la subconsulta no encuentra ninguna fila
    -- Busca si el mismo cliente tiene AL MENOS UN pedido entregado
    SELECT 1
    FROM pedidos p2
    WHERE p2.cliente_id = pedidos.cliente_id
    AND p2.estado = 'entregado'
);
 
-- Verifica que los pedidos cancelados correctos fueron eliminados
SELECT pedido_id, cliente_id, estado
FROM pedidos
WHERE estado = 'cancelado';
 
 
 /*(5)- Lista clientes, productos y fechas de pedidos entregados
      cuyo total (cantidad * precio) supere el promedio general
      de totales de pedidos entregados
    - Ordenado por total descendente (multi,sub)*/

-- Consulta principal con JOIN de tres tablas
SELECT
    c.nombre        AS cliente,
    c.ciudad,
    pr.nombre       AS producto,
    p.cantidad,
    p.fecha_pedido,
    p.cantidad * pr.precio AS total
FROM pedidos p
JOIN clientes  c  ON p.cliente_id  = c.cliente_id
JOIN productos pr ON p.producto_id = pr.producto_id
-- Filtra solo pedidos entregados cuyo total supere el promedio general
WHERE p.estado = 'entregado'
AND p.cantidad * pr.precio > (
    -- Subconsulta escalar: retorna un único valor (el promedio general)
    -- Solo considera pedidos entregados para el cálculo del promedio
    SELECT AVG(p2.cantidad * pr2.precio)
    FROM pedidos p2
    JOIN productos pr2 ON p2.producto_id = pr2.producto_id
    WHERE p2.estado = 'entregado'
)
ORDER BY total DESC;


/*(6) - Crea la vista vista_ventas_ciudad con estadísticas de ventas por ciudad
    - Consulta la vista filtrando ciudades con ingresos mayores a 5,000,000 (multi,vista)*/
-- Crea la vista con los totales de ventas agrupados por ciudad
CREATE VIEW vista_ventas_ciudad AS
SELECT
    c.ciudad,
    COUNT(p.pedido_id)            AS total_pedidos_entregados,
    SUM(p.cantidad * pr.precio)   AS suma_ingresos,
    AVG(p.cantidad * pr.precio)   AS promedio_ingreso_por_pedido
FROM pedidos p
JOIN clientes  c  ON p.cliente_id  = c.cliente_id
JOIN productos pr ON p.producto_id = pr.producto_id
-- Solo considera pedidos entregados
WHERE p.estado = 'entregado'
-- Agrupa los resultados por ciudad
GROUP BY c.ciudad;

-- Consulta la vista mostrando solo ciudades con suma_ingresos > 5,000,000
-- ordenadas de mayor a menor ingreso
SELECT *
FROM vista_ventas_ciudad
WHERE suma_ingresos > 5000000
ORDER BY suma_ingresos DESC;
    
/*(7) - Crea la vista vista_productos_populares con productos pedidos
      por más de un cliente distinto en pedidos entregados
    - Consulta la vista filtrando solo productos de categoría Perifericos (sub,vis)*/ 

-- Crea la vista con productos que han sido pedidos por más de un cliente distinto
CREATE VIEW vista_productos_populares AS
SELECT
    pr.producto_id,
    pr.nombre,
    pr.categoria,
    pr.precio,
    COUNT(DISTINCT p.cliente_id) AS total_clientes_distintos
FROM pedidos p
JOIN productos pr ON p.producto_id = pr.producto_id
-- Solo considera pedidos entregados
WHERE p.estado = 'entregado'
-- Agrupa por producto para contar clientes distintos por cada uno
GROUP BY pr.producto_id, pr.nombre, pr.categoria, pr.precio
-- Filtra solo productos pedidos por MÁS de un cliente distinto
HAVING COUNT(DISTINCT p.cliente_id) > 1;

-- Consulta la vista filtrando solo productos de categoría Perifericos
SELECT *
FROM vista_productos_populares
WHERE categoria = 'Perifericos';


/*(8) - Crea la función fn_ingreso_cliente que retorna el ingreso total
      acumulado de un cliente (solo pedidos entregados)
    - Usa la función en un SELECT sobre clientes ordenado por ingreso descendente (func,multi)*/

DELIMITER //
CREATE FUNCTION fn_ingreso_cliente(p_cliente_id INT)
-- RETURNS define el tipo de dato que retornará la función
RETURNS DECIMAL(12,2)
-- READS SQL DATA indica que la función solo lee datos, no los modifica
READS SQL DATA
BEGIN
    -- Variable local para almacenar el resultado
    DECLARE v_ingreso DECIMAL(12,2);

    -- Calcula la suma de cantidad * precio solo para pedidos entregados
    -- y lo almacena en v_ingreso
    SELECT SUM(p.cantidad * pr.precio)
    INTO v_ingreso
    FROM pedidos p
    JOIN productos pr ON p.producto_id = pr.producto_id
    WHERE p.cliente_id = p_cliente_id
    AND p.estado = 'entregado';

    -- Si el cliente no tiene pedidos entregados, SUM retorna NULL
    -- COALESCE reemplaza NULL por 0
    RETURN COALESCE(v_ingreso, 0);
END//
-- Restaura el delimitador original
DELIMITER ;

-- Usa la función en un SELECT para mostrar nombre, ciudad e ingreso_total
-- de todos los clientes, ordenados de mayor a menor ingreso
SELECT
    c.nombre,
    c.ciudad,
    fn_ingreso_cliente(c.cliente_id) AS ingreso_total
FROM clientes c
ORDER BY ingreso_total DESC;


/*(9) - Crea la función fn_stock_suficiente que retorna 1 si el stock
      es mayor o igual a la cantidad solicitada, 0 en caso contrario
    - Consulta productos donde la función retorne 0 (menos de 5 unidades) (func,sub)*/

DELIMITER //
CREATE FUNCTION fn_stock_suficiente(p_producto_id INT, p_cantidad_solicitada INT)
RETURNS INT
READS SQL DATA
BEGIN
    -- Variable local para almacenar el stock actual del producto
    DECLARE v_stock INT;
    -- Obtiene el stock actual del producto recibido como parámetro
    SELECT stock
    INTO v_stock
    FROM productos
    WHERE producto_id = p_producto_id;
    -- Retorna 1 si el stock es suficiente, 0 si no lo es
    IF v_stock >= p_cantidad_solicitada THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END//
DELIMITER ;

-- Consulta productos donde fn_stock_suficiente retorne 0
-- es decir, productos con menos de 5 unidades disponibles
SELECT
    nombre,
    stock
FROM productos
WHERE fn_stock_suficiente(producto_id, 5) = 0
ORDER BY stock ASC;


/*(10) - Crea el procedimiento sp_actualizar_estado_pedido que:
      (a) Verifica que el pedido exista
      (b) Registra el cambio en log_cambios_estado
      (c) Actualiza el estado del pedido
      (d) Si el nuevo estado es cancelado, restaura el stock del producto (proc)*/

DELIMITER //

CREATE PROCEDURE sp_actualizar_estado_pedido(
    p_pedido_id    INT,
    p_nuevo_estado VARCHAR(20)
)
BEGIN
    -- Variables locales para almacenar datos del pedido
    DECLARE v_estado_anterior VARCHAR(20);
    DECLARE v_producto_id     INT;
    DECLARE v_cantidad        INT;

    -- (a) Verifica si el pedido existe obteniendo su estado actual
    -- Si no existe, SELECT INTO deja v_estado_anterior en NULL
    SELECT estado, producto_id, cantidad
    INTO v_estado_anterior, v_producto_id, v_cantidad
    FROM pedidos
    WHERE pedido_id = p_pedido_id;

    -- Si v_estado_anterior es NULL el pedido no existe, retorna mensaje de error
    IF v_estado_anterior IS NULL THEN
        SELECT 'Error: el pedido no existe' AS mensaje;

    ELSE
        -- (b) Registra el cambio en log_cambios_estado
        INSERT INTO log_cambios_estado (pedido_id, estado_anterior, estado_nuevo)
        VALUES (p_pedido_id, v_estado_anterior, p_nuevo_estado);

        -- (c) Actualiza el estado del pedido
        UPDATE pedidos
        SET estado = p_nuevo_estado
        WHERE pedido_id = p_pedido_id;

        -- (d) Si el nuevo estado es cancelado, restaura el stock del producto
        IF p_nuevo_estado = 'cancelado' THEN
            UPDATE productos
            SET stock = stock + v_cantidad
            WHERE producto_id = v_producto_id;
        END IF;

        -- Confirmación de la operación realizada
        SELECT CONCAT('Pedido ', p_pedido_id, ' actualizado a: ', p_nuevo_estado) AS mensaje;

    END IF;

END//

DELIMITER ;

-- Prueba 1: actualiza un pedido existente a cancelado (debe restaurar stock)
CALL sp_actualizar_estado_pedido(6, 'cancelado');

-- Prueba 2: intenta actualizar un pedido que no existe (debe mostrar error)
CALL sp_actualizar_estado_pedido(99, 'entregado');

-- Verifica el log de cambios
SELECT * FROM log_cambios_estado;

-- Verifica que el stock del producto fue restaurado
SELECT producto_id, nombre, stock FROM productos WHERE producto_id = 7;


/*(11) - Crea el procedimiento sp_resumen_cliente que retorna en un solo SELECT:
      nombre, ciudad, total de pedidos por estado en columnas separadas
      e ingreso total de pedidos entregados (proc,multi)*/

DELIMITER //

CREATE PROCEDURE sp_resumen_cliente(p_cliente_id INT)
BEGIN
    -- Variable para verificar si el cliente existe
    DECLARE v_nombre VARCHAR(100);

    SELECT nombre
    INTO v_nombre
    FROM clientes
    WHERE cliente_id = p_cliente_id;

    -- Si el cliente no existe retorna mensaje de error
    IF v_nombre IS NULL THEN
        SELECT 'Error: el cliente no existe' AS mensaje;

    ELSE
        -- Retorna el resumen completo del cliente en un solo SELECT
        SELECT
            c.nombre,
            c.ciudad,
            -- Cuenta pedidos entregados usando CASE WHEN dentro de SUM
            -- CASE evalúa condición por fila: si es entregado suma 1, sino 0
            SUM(CASE WHEN p.estado = 'entregado' THEN 1 ELSE 0 END) AS pedidos_entregados,
            SUM(CASE WHEN p.estado = 'pendiente' THEN 1 ELSE 0 END) AS pedidos_pendientes,
            SUM(CASE WHEN p.estado = 'cancelado' THEN 1 ELSE 0 END) AS pedidos_cancelados,
            -- Suma el ingreso total solo de pedidos entregados
            SUM(CASE WHEN p.estado = 'entregado'
                THEN p.cantidad * pr.precio
                ELSE 0
            END)                                                      AS ingreso_total
        FROM clientes c
        JOIN pedidos   p  ON c.cliente_id  = p.cliente_id
        JOIN productos pr ON p.producto_id = pr.producto_id
        WHERE c.cliente_id = p_cliente_id
        GROUP BY c.nombre, c.ciudad;

    END IF;

END//

DELIMITER ;

-- Prueba 1: resumen de cliente existente
CALL sp_resumen_cliente(1);

-- Prueba 2: resumen de cliente que no existe
CALL sp_resumen_cliente(99);

/*(12) - Crea la vista vista_pedidos_pendientes con datos de pedidos pendientes
      incluyendo los días de espera desde la fecha del pedido hasta hoy
    - Crea el procedimiento sp_alertar_retrasos que retorna pedidos
      cuyo días de espera supere el límite recibido como parámetro (proc,vis)*/
-- Crea la vista con los pedidos pendientes y sus días de espera
CREATE VIEW vista_pedidos_pendientes AS
SELECT
    p.pedido_id,
    c.nombre                              AS nombre_cliente,
    pr.nombre                             AS nombre_producto,
    p.cantidad,
    pr.precio                             AS precio_unitario,
    -- DATEDIFF calcula la diferencia en días entre dos fechas
    -- CURDATE() retorna la fecha actual sin hora
    DATEDIFF(CURDATE(), p.fecha_pedido)   AS dias_espera
FROM pedidos p
JOIN clientes  c  ON p.cliente_id  = c.cliente_id
JOIN productos pr ON p.producto_id = pr.producto_id
-- Solo incluye pedidos con estado pendiente
WHERE p.estado = 'pendiente';

-- Verifica la vista
SELECT * FROM vista_pedidos_pendientes;

DELIMITER $$

CREATE PROCEDURE sp_alertar_retrasos(p_dias_limite INT)
BEGIN
    -- Consulta la vista retornando solo pedidos que superen el límite de días
    SELECT *
    FROM vista_pedidos_pendientes
    WHERE dias_espera > p_dias_limite
    ORDER BY dias_espera DESC;

END$$

DELIMITER ;

-- Prueba: retorna pedidos pendientes con más de 100 días de espera
CALL sp_alertar_retrasos(100);

-- Prueba: retorna pedidos pendientes con más de 200 días de espera
CALL sp_alertar_retrasos(200);


/*(13) - Agrega la columna descuento a productos con restricción entre 0 y 50
    - Crea la función fn_precio_final que aplica el descuento al precio
    - Consulta los 3 productos con mayor precio final usando la función (func,sub)*/
-- Agrega la columna descuento a productos
-- CHECK garantiza que el descuento solo pueda ser entre 0 y 50
ALTER TABLE productos
ADD COLUMN descuento DECIMAL(5,2) DEFAULT 0
CHECK (descuento >= 0 AND descuento <= 50);

-- Asigna descuentos de prueba a algunos productos
UPDATE productos SET descuento = 10 WHERE producto_id = 1;
UPDATE productos SET descuento = 15 WHERE producto_id = 4;
UPDATE productos SET descuento = 20 WHERE producto_id = 8;

-- Verifica que los descuentos quedaron asignados
SELECT producto_id, nombre, precio, descuento FROM productos;

DELIMITER $$

CREATE FUNCTION fn_precio_final(p_producto_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    -- Variables para almacenar precio y descuento del producto
    DECLARE v_precio    DECIMAL(10,2);
    DECLARE v_descuento DECIMAL(5,2);

    -- Obtiene precio y descuento del producto
    SELECT precio, descuento
    INTO v_precio, v_descuento
    FROM productos
    WHERE producto_id = p_producto_id;

    -- Aplica el descuento al precio y retorna el precio final
    -- precio * (1 - descuento/100) equivale a restar el porcentaje de descuento
    RETURN v_precio * (1 - v_descuento / 100);

END$$

DELIMITER ;

-- Consulta los 3 productos con mayor precio final usando la función
-- ORDER BY DESC ordena de mayor a menor precio final
-- LIMIT 3 restringe el resultado a los 3 primeros
SELECT
    nombre,
    precio,
    descuento,
    fn_precio_final(producto_id) AS precio_final
FROM productos
ORDER BY precio_final DESC
LIMIT 3;


/*(14) Crea el procedimiento sp_registrar_pedido que:
      (a) Valida que el cliente exista
      (b) Valida que el stock sea suficiente
      (c) Inserta el pedido con estado pendiente
      (d) Actualiza el stock descontando la cantidad
      (e) Retorna el pedido recién creado con nombre del cliente y producto (proc,multi)*/
DELIMITER $$

CREATE PROCEDURE sp_registrar_pedido(
    p_cliente_id  INT,
    p_producto_id INT,
    p_cantidad    INT
)
BEGIN
    -- Variables para almacenar datos de validación
    DECLARE v_nombre_cliente VARCHAR(100);
    DECLARE v_stock_actual   INT;
    DECLARE v_pedido_id      INT;

    -- (a) Valida que el cliente exista
    SELECT nombre
    INTO v_nombre_cliente
    FROM clientes
    WHERE cliente_id = p_cliente_id;

    IF v_nombre_cliente IS NULL THEN
        SELECT 'Error: el cliente no existe' AS mensaje;

    ELSE
        -- (b) Valida que el stock sea suficiente
        SELECT stock
        INTO v_stock_actual
        FROM productos
        WHERE producto_id = p_producto_id;

        IF v_stock_actual IS NULL THEN
            SELECT 'Error: el producto no existe' AS mensaje;

        ELSEIF v_stock_actual < p_cantidad THEN
            SELECT CONCAT('Error: stock insuficiente. Stock disponible: ', v_stock_actual) AS mensaje;

        ELSE
            -- (c) Inserta el pedido con estado pendiente
            INSERT INTO pedidos (cliente_id, producto_id, cantidad, estado)
            VALUES (p_cliente_id, p_producto_id, p_cantidad, 'pendiente');

            -- Guarda el id del pedido recién insertado
            SET v_pedido_id = LAST_INSERT_ID();

            -- (d) Actualiza el stock descontando la cantidad pedida
            UPDATE productos
            SET stock = stock - p_cantidad
            WHERE producto_id = p_producto_id;

            -- (e) Retorna el pedido recién creado con JOIN
            SELECT
                p.pedido_id,
                c.nombre    AS nombre_cliente,
                pr.nombre   AS nombre_producto,
                p.cantidad,
                p.estado,
                p.fecha_pedido
            FROM pedidos p
            JOIN clientes  c  ON p.cliente_id  = c.cliente_id
            JOIN productos pr ON p.producto_id = pr.producto_id
            WHERE p.pedido_id = v_pedido_id;

        END IF;
    END IF;

END$$

DELIMITER ;

-- Prueba 1: registro exitoso
CALL sp_registrar_pedido(2, 5, 3);

-- Prueba 2: cliente que no existe
CALL sp_registrar_pedido(99, 5, 3);

-- Prueba 3: stock insuficiente (Tablet 10 solo tiene 6 unidades)
CALL sp_registrar_pedido(1, 8, 10);

-- Verifica que el stock fue descontado correctamente
SELECT producto_id, nombre, stock FROM productos WHERE producto_id = 5;

 
/*(15)- Crea la función fn_clasificar_producto que clasifica productos
      en PREMIUM, ESTANDAR o BASICO según su precio
    - Crea la vista vista_catalogo_clasificado usando la función
    - Consulta la vista filtrando productos PREMIUM con stock > 5 (multi,func,vista)*/
DELIMITER $$

CREATE FUNCTION fn_clasificar_producto(p_producto_id INT)
RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
    -- Variable para almacenar el precio del producto
    DECLARE v_precio DECIMAL(10,2);

    -- Obtiene el precio del producto
    SELECT precio
    INTO v_precio
    FROM productos
    WHERE producto_id = p_producto_id;

    -- Clasifica el producto según su precio usando CASE
    RETURN CASE
        WHEN v_precio > 1000000  THEN 'PREMIUM'
        WHEN v_precio >= 200000  THEN 'ESTANDAR'
        ELSE                          'BASICO'
    END;

END$$

DELIMITER ;

-- Crea la vista usando la función para clasificar cada producto
CREATE VIEW vista_catalogo_clasificado AS
SELECT
    nombre,
    categoria,
    precio,
    fn_clasificar_producto(producto_id) AS clasificacion,
    stock
FROM productos;

-- Verifica la vista completa
SELECT * FROM vista_catalogo_clasificado;

-- Consulta solo productos PREMIUM con stock mayor a 5
SELECT *
FROM vista_catalogo_clasificado
WHERE clasificacion = 'PREMIUM'
AND stock > 5;


/*(16) - Crea la vista vista_clientes_vip con clientes que tienen más pedidos
      entregados que el promedio de pedidos entregados por cliente
    - Consulta la vista con JOIN para listar los últimos 2 pedidos
      de cada cliente VIP (sub,multi,vista)*/
-- Crea la vista con clientes VIP
CREATE VIEW vista_clientes_vip AS
SELECT
    c.cliente_id,
    c.nombre,
    c.ciudad,
    COUNT(p.pedido_id) AS total_pedidos_entregados
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.estado = 'entregado'
GROUP BY c.cliente_id, c.nombre, c.ciudad
-- HAVING filtra grupos cuyo conteo supere el promedio general
-- La subconsulta calcula el promedio de pedidos entregados por cliente
HAVING COUNT(p.pedido_id) > (
    SELECT AVG(total)
    FROM (
        -- Subconsulta anidada: primero cuenta pedidos entregados por cliente
        -- luego el AVG calcula el promedio de esos conteos
        SELECT COUNT(pedido_id) AS total
        FROM pedidos
        WHERE estado = 'entregado'
        GROUP BY cliente_id
    ) AS conteos_por_cliente
);

-- Verifica la vista
SELECT * FROM vista_clientes_vip;

-- Consulta los últimos 2 pedidos de cada cliente VIP usando ROW_NUMBER
SELECT
    vip.nombre          AS nombre_cliente,
    pr.nombre           AS nombre_producto,
    p.fecha_pedido,
    p.estado
FROM vista_clientes_vip vip
JOIN pedidos p ON vip.cliente_id = p.cliente_id
JOIN productos pr ON p.producto_id = pr.producto_id
-- Subconsulta que numera los pedidos de cada cliente de más reciente a más antiguo
WHERE p.pedido_id IN (
    SELECT pedido_id
    FROM (
        SELECT
            pedido_id,
            cliente_id,
            -- ROW_NUMBER asigna un número secuencial a cada pedido
            -- PARTITION BY reinicia el conteo por cada cliente
            -- ORDER BY fecha_pedido DESC numera desde el más reciente
            ROW_NUMBER() OVER (
                PARTITION BY cliente_id
                ORDER BY fecha_pedido DESC
            ) AS rn
        FROM pedidos
    ) AS pedidos_numerados
    -- Filtra solo los 2 primeros de cada cliente (los 2 más recientes)
    WHERE rn <= 2
)
ORDER BY vip.nombre, p.fecha_pedido DESC;