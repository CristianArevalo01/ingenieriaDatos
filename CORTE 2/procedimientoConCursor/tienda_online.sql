CREATE DATABASE IF NOT EXISTS tienda_onlineT;
USE tienda_onlineT;
drop database tienda_onlineT;
CREATE TABLE categorias (
    id_categoria  INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(80) NOT NULL,
    descripcion   TEXT
);
 
CREATE TABLE productos (
    id_producto   INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(120) NOT NULL,
    precio        DECIMAL(10,2) NOT NULL,
    stock         INT DEFAULT 0,
    id_categoria  INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);
 
CREATE TABLE clientes (
    id_cliente    INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    ciudad        VARCHAR(80),
    fecha_registro DATE
);
 
CREATE TABLE pedidos (
    id_pedido     INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente    INT NOT NULL,
    fecha_pedido  DATETIME DEFAULT NOW(),
    estado        ENUM('pendiente','enviado','entregado','cancelado') DEFAULT 'pendiente',
    total         DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
 
CREATE TABLE detalle_pedido (
    id_detalle    INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido     INT NOT NULL,
    id_producto   INT NOT NULL,
    cantidad      INT NOT NULL,
    precio_unit   DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido)   REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
 
-- Datos de prueba
INSERT INTO categorias VALUES (1,'Electrónica','Dispositivos electrónicos'),
    (2,'Ropa','Prendas de vestir'),(3,'Libros','Libros y revistas');
 
INSERT INTO productos VALUES
    (1,'Laptop Pro',18500.00,15,1),(2,'Auriculares BT',650.00,40,1),
    (3,'Camiseta Básica',250.00,100,2),(4,'Python Crash Course',450.00,30,3);
 
INSERT INTO clientes VALUES
    (1,'Ana García','ana@email.com','CDMX','2024-01-10'),
    (2,'Luis Pérez','luis@email.com','GDL','2024-02-15'),
    (3,'María López','maria@email.com','MTY','2024-03-01');
 
INSERT INTO pedidos VALUES
    (1,1,NOW(),'entregado',19150.00),(2,2,NOW(),'enviado',650.00),
    (3,1,NOW(),'pendiente',700.00),(4,3,NOW(),'cancelado',450.00);
 
INSERT INTO detalle_pedido VALUES
    (1,1,1,1,18500.00),(2,1,2,1,650.00),
    (3,2,2,1,650.00),(4,3,3,2,250.00),(5,3,4,1,450.00),(6,4,4,1,450.00);


### Pedidos con el nombre del cliente

describe pedidos;

select p.id_pedido, 
c.nombre as cliente,
c.id_cliente,
c.ciudad,
p.fecha_pedido,
p.estado,
p. total
from pedidos p
inner join clientes c on p.id_cliente=c.id_cliente
order by p.fecha_pedido desc;

select * from pedidos;

### clientes que aun no tengan pedidos

select 
c.nombre as cliente,
c.id_cliente,
c.ciudad,
count(p.id_pedido) as totalPedido
from clientes c
left join pedidos p on c.id_cliente=p.id_cliente
order by p.fecha_pedido desc;

### Join con 3 tablas cliente pedido producto
use tienda_onlinet;

select
c.nombre as cliente,
p.id_pedido,
p.estado,
pr.nombre as producto,
dp.cantidad,
dp.precio_unit,
(dp.cantidad*dp.precio_unit) as Subtotal
from clientes c
inner join pedidos p  on c.id_cliente=p.id_cliente
inner join detalle_pedido dp on p.id_pedido=dp.id_pedido
inner join productos pr  on dp.id_producto=pr.id_producto
order by c.nombre, p.id_pedido;

##=== procedimientos almacenados - funciones - vistas

/* ====== Procedimientos almacenados Stored Procedures=======
son bloques de código de  SQL que tienen un nombre que se almacenan 
en el sevidor y se ejecutan con invocación o llamandolos CALL registro o creacion 
de consulta de modificación o actualización de eliminación

con parametros entrada in  salida out ambos (inout)

sintaxis
--Crear Procedimiento
DELIMITER//
CREATE PROCEDURE nombreProcedimiento(
	IN parametro_entrada tipo,
    OUT parametro_salida tipo,
    INOUT parametro_entradasalida tipo 
)
BEGIN 
-- Declaración de variables locales
DECLARE variable tipo DEFAULT valor;

-- cuerpo del procedimiento
-- sentencias SQL, control flujo ....

END //
    
DELIMITER;
-- Invocar Procedimiento
CALL nombreProcedimiento(valor_entrada, @variable_salida,@variable_entrada_salida);

*/
use tienda_onlinet;

describe detalle_pedido;
-- Ejemplo 1 Registro de un pedido completo
DELIMITER //
CREATE PROCEDURE sp_crear_pedido(
    IN  p_id_cliente  INT,
    IN  p_id_producto INT,
    IN  p_cantidad    INT,
    OUT p_id_pedido   INT,
    OUT p_mensaje     VARCHAR(200)
)
BEGIN
    DECLARE v_stock   INT;
    DECLARE v_precio  DECIMAL(10,2);
    DECLARE v_total   DECIMAL(12,2);
 
    -- Manejador de errores: si algo falla, hace ROLLBACK
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mensaje = 'Error: transacción revertida';
        SET p_id_pedido = -1;
    END;
 
    -- Validar stock disponible
    SELECT stock, precio INTO v_stock, v_precio
    FROM productos WHERE id_producto = p_id_producto;
 
    IF v_stock < p_cantidad THEN
        SET p_mensaje  = CONCAT('Stock insuficiente. Disponible: ', v_stock);
        SET p_id_pedido = 0;
    ELSE
        START TRANSACTION;
 
        SET v_total = v_precio * p_cantidad;
 
        -- Crear cabecera del pedido
        INSERT INTO pedidos(id_cliente, total)
        VALUES (p_id_cliente, v_total);
        SET p_id_pedido = LAST_INSERT_ID();
 
        -- Insertar detalle
        INSERT INTO detalle_pedido(id_pedido, id_producto, cantidad, precio_unit)
        VALUES (p_id_pedido, p_id_producto, p_cantidad, v_precio);
 
        -- Descontar stock
        UPDATE productos
        SET stock = stock - p_cantidad
        WHERE id_producto = p_id_producto;
 
        COMMIT;
        SET p_mensaje = CONCAT('Pedido #', p_id_pedido, ' creado correctamente');
    END IF;
END //
DELIMITER ;
 

-- INVOCAR O EJECUTAR EL PROCEDIMIENTO 
CALL sp_crear_pedido(1,3,10,@pedido_id,@msg);

select @pedido_id as id_pedido, @msg as mensaje;

select * from pedidos;
select * from detalle_pedido;
select * from productos;

##Vista procedimiento anterior para verificar disponibilidad de productos
CREATE VIEW v_disponibilidad_productos AS
SELECT
    p.id_producto,
    p.nombre,
    p.precio,
    p.stock,
    CASE
        WHEN p.stock = 0 THEN 'Sin stock'
        WHEN p.stock < 20 THEN 'Stock bajo'
        ELSE 'Disponible'
    END AS disponibilidad
FROM productos p;
SELECT * FROM v_disponibilidad_productos;

## Crear un procedimiento almacenado que permita cancelar un pedido:
## Recibir como parametro de entrada el id_pedido y el id_cliente (verificar que el pedido pertenece al cliente)
## Validar que el pedido exista y pertenezca al cliente indicado, si no debe mostrar mensaje de error
## validar que el pedido no este cancelado ni entregado. solo se va a poder cancelar pedidos que esten pendientes o enviado
## Actualizar el estado del pedido a cancelado
## Actualizar o restaurar ek stock de cada producto de ese pedido (detalle_pedido)
## retornar como parametro de salida un mensaje que Pedido#x: Cancelado Stock restauradopara n productos
## 1. exitosa Pedido#x: Cancelado Stock restauradopara n productos
## 2. No exitosa el pedido no existe o no pertenece al cliente

use tienda_onlinet;
DELIMITER //
CREATE PROCEDURE sp_cancelar_pedido(
    IN  p_id_cliente INT,
    IN  p_id_pedido INT,
    OUT p_mensaje VARCHAR(200)
)
BEGIN
    DECLARE v_estado varchar(20);
    DECLARE v_id_cliente INT;
    DECLARE v_num_productos INT;
 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_mensaje = 'Error: transacción revertida';
	END;
 
    -- Verrificar existencia de pedido y que pertenece al cliente
    SELECT estado,id_cliente INTO v_estado,v_id_cliente
    FROM pedidos WHERE id_pedido = p_id_pedido;
 
    IF v_id_cliente IS NULL THEN 
        SET p_mensaje  = 'Error: el pedido no existe.';
   ELSEIF v_id_cliente<> p_id_cliente then
		SET p_mensaje  = 'Error: el pedido no pertenece al cliente';
	ELSEIF v_estado IN ('cancelado','entregado') then
		SET p_mensaje  = concat('Error: No se puede cancelar un pedido en estado: "',v_estado,'"');
	ELSE
        START TRANSACTION;
		update productos pr
        inner join detalle_pedido dp ON pr.id_producto=dp.id_producto
        set pr.stock=pr.stock+dp.cantidad
        where dp.id_pedido=p_id_pedido;
        
        select count(*) into v_num_productos
        from detalle_pedido
        where id_pedido=p_id_pedido;
        
        update pedidos
        set estado='cancelado'
        where id_pedido=p_id_pedido;
                
        COMMIT;
        SET p_mensaje = CONCAT('Pedido #', p_id_pedido, ' cancelado. Stock restaurado para ', v_num_productos, 'producto(s).');
    END IF;
END //
DELIMITER ;

CALL sp_cancelar_pedido(3,1,@msg);
select @msg;

##Vista para verificar si un pedido es cancelable
CREATE VIEW v_estado_cancelacion AS
SELECT
    p.id_pedido,
    p.id_cliente,
    c.nombre AS nombre_cliente,
    p.estado,
    p.total,
    p.fecha_pedido,
    CASE
        WHEN p.estado = 'cancelado'  THEN 'No cancelable: ya fue cancelado'
        WHEN p.estado = 'entregado'  THEN 'No cancelable: ya fue entregado'
        ELSE 'Cancelable'
    END AS puede_cancelarse
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente;
SELECT * FROM v_estado_cancelacion;
## Tarea hacer  ejemplo de procedimiento con cursor
/*Un cursor es una estructura que permite recorrer fila por fila el resultado de una consulta dentro de ese procedimiento.
SQL trabaja de forma orientada a conjuntos (procesa todas las filas a la vez). A veces necesitas procesar cada fila individualmente — ahí es donde entra el cursor.
Estructura cursor: DECLARE → OPEN → FETCH → (lógica fila por fila) → CLOSE → DEALLOCATE*/
DELIMITER //
CREATE PROCEDURE ajustarPrecios()
BEGIN
    -- Variables que reciben cada fila del cursor
    DECLARE v_id_producto  INT;
    DECLARE v_nombre       VARCHAR(120);
    DECLARE v_precio       DECIMAL(10,2);
    DECLARE v_stock        INT;
    -- Control del loop, empieza en false y cambiara a true cuando el cursor se quede sin filas
    DECLARE fin BOOLEAN DEFAULT FALSE;
    -- Cursor: recorre todos los productos
    DECLARE cur_productos CURSOR FOR
        SELECT id_producto, nombre, precio, stock
        FROM productos;
    -- Ponerele fin cuando no haya más filas
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;
    -- Abrir cursor
    OPEN cur_productos;
    loop_productos: LOOP
        -- Traer siguiente fila
        FETCH cur_productos INTO v_id_producto, v_nombre, v_precio, v_stock;
        IF fin THEN
            LEAVE loop_productos;
        END IF;
        -- Aplicar regla según stock
        IF v_stock < 20 THEN
            UPDATE productos
            SET precio = precio * 1.15
            WHERE id_producto = v_id_producto;
            SELECT CONCAT(v_nombre, ': stock bajo → precio subió 15%') AS log;
        ELSEIF v_stock > 50 THEN
            UPDATE productos
            SET precio = precio * 0.90
            WHERE id_producto = v_id_producto;
            SELECT CONCAT(v_nombre, ': stock alto → precio bajó 10%') AS log;
        ELSE
            SELECT CONCAT(v_nombre, ': stock normal → sin cambios') AS log;
        END IF;
    END LOOP loop_productos;
    CLOSE cur_productos;
END//
DELIMITER ;

SELECT nombre, precio, stock FROM productos;
CALL ajustarPrecios();
SELECT nombre, precio, stock FROM productos;

/*Procedimiento en vista*/
CREATE VIEW v_ajustePrecios AS
SELECT
    id_producto,
    nombre,
    precio AS precio_actual,
    stock,
    CASE
        WHEN stock < 20  THEN ROUND(precio * 1.15, 2)
        WHEN stock > 50  THEN ROUND(precio * 0.90, 2)
        ELSE precio
    END AS precio_ajustado,
    CASE
        WHEN stock < 20  THEN 'Subir 15%'
        WHEN stock > 50  THEN 'Bajar 10%'
        ELSE 'Sin cambio'
    END AS accion
FROM productos;

SELECT * FROM v_ajustePrecios;
use tienda_onlineT;