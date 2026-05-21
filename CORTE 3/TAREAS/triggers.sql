DROP DATABASE IF EXISTS tienda_onlineT;
CREATE DATABASE IF NOT EXISTS tienda_onlineT;
USE tienda_onlineT;
 
 CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    correo VARCHAR(150) UNIQUE NOT NULL
);
 
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
    on delete cascade
);
 
CREATE TABLE clientes (
    id_cliente    INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    email         VARCHAR(150) UNIQUE NOT NULL,
    ciudad        VARCHAR(80),
    fecha_registro DATE DEFAULT (CURRENT_DATE)
);
 
CREATE TABLE pedidos (
    id_pedido     INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente    INT NOT NULL,
    fecha_pedido  DATETIME DEFAULT NOW(),
    estado        ENUM('pendiente','enviado','entregado','cancelado') DEFAULT 'pendiente',
    total         DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) on delete cascade
);
 
CREATE TABLE detalle_pedido (
    id_detalle    INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido     INT NOT NULL,
    id_producto   INT NOT NULL,
    cantidad      INT NOT NULL,
    precio_unit   DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido)   REFERENCES pedidos(id_pedido) on delete cascade,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) on delete cascade
);
 
-- Datos de prueba

INSERT INTO usuarios (nombre_usuario, correo)
VALUES
('Carlos Admin', 'carlos@empresa.com'),
('Ana Supervisor', 'ana@empresa.com');

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
    
/*Trigger que guarda el producto actualizado y quien lo actualizo*/
create table auditoriaProductos (
	idAuditoria int auto_increment primary key,
    idProducto int,
    idUsuario int,
    nombreProducto varchar(120),
    precioAnterior decimal(10,2),
    precioNuevo decimal(10,2),
    stockAnterior int,
    stockNuevo int,
    usuarioActualizacion varchar(100),
    fechaActualizacion datetime default now(),
    FOREIGN KEY (idProducto) REFERENCES productos(id_producto),
    FOREIGN KEY (idUsuario) REFERENCES usuarios(id_usuario)
);

delimiter $$
create trigger trg_actualizar_producto
after update on productos
for each row
begin
	insert into auditoriaProductos (
		idProducto,
        idUsuario,
        nombreProducto,
        precioAnterior,
        precioNuevo,
        stockAnterior,
        stockNuevo,
        usuarioActualizacion,
        fechaActualizacion
        )
        values (
			OLD.id_producto,
            @usuarioActual,
            old.nombre,
			OLD.precio,
			NEW.precio,
			OLD.stock,
			NEW.stock,
            current_user(),
			NOW()
		);
end$$
delimiter ;

SET @usuarioActual = 1;

UPDATE productos
SET precio = 19000,
    stock = 10
WHERE id_producto = 1;

SELECT * FROM auditoriaProductos;
SELECT * FROM productos;

/*trigger que cuando elimine un cliente cree una tabla cliente eliminado y guarde ese cliente*/
CREATE TABLE clientes_eliminados (
    id_eliminado INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    nombre VARCHAR(100),
    email VARCHAR(150),
    ciudad VARCHAR(80),
    fecha_registro DATE,
    fecha_eliminacion DATETIME DEFAULT NOW()
);

DELIMITER $$
CREATE TRIGGER trg_eliminar_cliente
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO clientes_eliminados (
        id_cliente,
        nombre,
        email,
        ciudad,
        fecha_registro,
        fecha_eliminacion
    )
    VALUES (
        OLD.id_cliente,
        OLD.nombre,
        OLD.email,
        OLD.ciudad,
        OLD.fecha_registro,
        NOW()
    );
END$$
DELIMITER ;

DELETE FROM clientes
WHERE id_cliente = 1;

SELECT * FROM clientes_eliminados;