-- ===================================================
-- SISTEMA DE GESTIÓN DE INVENTARIO
-- Base de Datos: PostgreSQL
-- Modelo Mejorado: Separación de Compras y Ventas
-- ===================================================

-- Eliminar TABLAs si existen (para poder ejecutar el script múltiples veces)
DROP TABLE IF EXISTS detalle_ventas CASCADE;
DROP TABLE IF EXISTS detalle_compras CASCADE;
DROP TABLE IF EXISTS ventas CASCADE;
DROP TABLE IF EXISTS compras CASCADE;
DROP TABLE IF EXISTS metodos_pago CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS locales CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS proveedores CASCADE;

-- ===================================================
-- 1. CREACIÓN DE TABLAS
-- ===================================================

-- TABLA: proveedores
CREATE TABLE proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    CONSTRAINT email_valido CHECK (email LIKE '%@%')
);

-- TABLA: productos
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    cantidad_inventario INT NOT NULL DEFAULT 0,
    id_proveedor INT NOT NULL,
    CONSTRAINT precio_positivo CHECK (precio > 0),
    CONSTRAINT cantidad_no_negativa CHECK (cantidad_inventario >= 0),
    CONSTRAINT fk_proveedor_producto FOREIGN KEY (id_proveedor) 
        REFERENCES proveedores(id_proveedor) ON DELETE RESTRICT
);

-- TABLA: clientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(20),
    CONSTRAINT email_cliente_valido CHECK (email IS NULL OR email LIKE '%@%')
);

-- TABLA: locales
CREATE TABLE locales (
    id_local SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    direccion VARCHAR(200)
);

-- TABLA: metodos_pago
CREATE TABLE metodos_pago (
    id_metodo SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- TABLA: compras
CREATE TABLE compras (
    id_compra SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    total DECIMAL(10, 2) NOT NULL DEFAULT 0,
    id_proveedor INT NOT NULL,
    id_local INT NOT NULL,
    CONSTRAINT total_compra_no_negativo CHECK (total >= 0),
    CONSTRAINT fk_proveedor_compra FOREIGN KEY (id_proveedor) 
        REFERENCES proveedores(id_proveedor) ON DELETE RESTRICT,
    CONSTRAINT fk_local_compra FOREIGN KEY (id_local) 
        REFERENCES locales(id_local) ON DELETE RESTRICT
);

-- TABLA: detalle_compras
CREATE TABLE detalle_compras (
    id_detalle_compra SERIAL PRIMARY KEY,
    id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT cantidad_compra_positiva CHECK (cantidad > 0),
    CONSTRAINT precio_unitario_compra_positivo CHECK (precio_unitario > 0),
    CONSTRAINT subtotal_compra_positivo CHECK (subtotal > 0),
    CONSTRAINT fk_compra FOREIGN KEY (id_compra) 
        REFERENCES compras(id_compra) ON DELETE CASCADE,
    CONSTRAINT fk_producto_compra FOREIGN KEY (id_producto) 
        REFERENCES productos(id_producto) ON DELETE RESTRICT
);

-- TABLA: ventas
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    total DECIMAL(10, 2) NOT NULL DEFAULT 0,
    id_cliente INT NOT NULL,
    id_local INT NOT NULL,
    id_metodo INT NOT NULL,
    CONSTRAINT total_venta_no_negativo CHECK (total >= 0),
    CONSTRAINT fk_cliente_venta FOREIGN KEY (id_cliente) 
        REFERENCES clientes(id_cliente) ON DELETE RESTRICT,
    CONSTRAINT fk_local_venta FOREIGN KEY (id_local) 
        REFERENCES locales(id_local) ON DELETE RESTRICT,
    CONSTRAINT fk_metodo_venta FOREIGN KEY (id_metodo) 
        REFERENCES metodos_pago(id_metodo) ON DELETE RESTRICT
);

-- TABLA: detalle_ventas
CREATE TABLE detalle_ventas (
    id_detalle_venta SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    CONSTRAINT cantidad_venta_positiva CHECK (cantidad > 0),
    CONSTRAINT precio_unitario_venta_positivo CHECK (precio_unitario > 0),
    CONSTRAINT subtotal_venta_positivo CHECK (subtotal > 0),
    CONSTRAINT fk_venta FOREIGN KEY (id_venta) 
        REFERENCES ventas(id_venta) ON DELETE CASCADE,
    CONSTRAINT fk_producto_venta FOREIGN KEY (id_producto) 
        REFERENCES productos(id_producto) ON DELETE RESTRICT
);

-- ===================================================
-- 2. INSERCIÓN DE DATOS DE PRUEBA
-- ===================================================

-- Agregar proveedores
INSERT INTO proveedores (nombre, direccion, telefono, email) VALUES
('TechSupply SA', 'Av. Principal 123, Santiago', '+56912345678', 'contacto@techsupply.cl'),
('Distribuidora Global', 'Calle Comercio 456, Valparaíso', '+56987654321', 'ventas@distglobal.cl'),
('Proveeduría Central', 'Paseo Industrial 789, Concepción', '+56911223344', 'info@provcentral.cl');

-- Agregar productos
INSERT INTO productos (nombre, descripcion, precio, cantidad_inventario, id_proveedor) VALUES
('Laptop HP', 'Laptop HP 15 pulgadas, 8GB RAM', 450000.00, 25, 1),
('Mouse Logitech', 'Mouse inalámbrico Logitech M185', 15000.00, 100, 2),
('Teclado Mecánico', 'Teclado mecánico RGB retroiluminado', 65000.00, 45, 1),
('Monitor Samsung', 'Monitor Samsung 24 pulgadas Full HD', 180000.00, 15, 3),
('Disco Duro Externo', 'Disco duro externo 1TB USB 3.0', 55000.00, 60, 2);

-- Agregar clientes
INSERT INTO clientes (nombre, email, telefono) VALUES
('Empresa TechCorp', 'compras@techcorp.cl', '+56922334455'),
('Comercial Los Andes', 'ventas@losandes.cl', '+56933445566'),
('Oficina Central SpA', 'contacto@oficentral.cl', '+56944556677'),
('Instituto Tecnológico', 'adquisiciones@insti.cl', '+56955667788');

-- Agregar locales
INSERT INTO locales (nombre, ciudad, direccion) VALUES
('Sucursal Centro', 'Santiago', 'Av. Libertador Bernardo O''Higgins 1234'),
('Sucursal Norte', 'Antofagasta', 'Calle Prat 567'),
('Sucursal Sur', 'Concepción', 'Av. Colón 890');

-- Agregar métodos de pago
INSERT INTO metodos_pago (nombre) VALUES
('Efectivo'),
('Tarjeta de Crédito'),
('Tarjeta de Débito'),
('Transferencia Bancaria'),
('Cheque');

-- Agregar compras (encabezados)
INSERT INTO compras (fecha, total, id_proveedor, id_local) VALUES
('2025-10-15', 13500000.00, 1, 1),  -- Compra 1: Laptops
('2025-10-18', 2250000.00, 2, 1),   -- Compra 2: Mouses
('2025-10-20', 3250000.00, 1, 2),   -- Compra 3: Teclados
('2025-11-01', 3600000.00, 3, 3),   -- Compra 4: Monitores
('2025-11-05', 4400000.00, 2, 1);   -- Compra 5: Discos Duros

-- Agregar detalle de compras
INSERT INTO detalle_compras (id_compra, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 30, 450000.00, 13500000.00),  -- 30 Laptops
(2, 2, 150, 15000.00, 2250000.00),   -- 150 Mouses
(3, 3, 50, 65000.00, 3250000.00),    -- 50 Teclados
(4, 4, 20, 180000.00, 3600000.00),   -- 20 Monitores
(5, 5, 80, 55000.00, 4400000.00);    -- 80 Discos Duros

-- Agregar ventas (encabezados)
INSERT INTO ventas (fecha, total, id_cliente, id_local, id_metodo) VALUES
('2025-10-22', 2250000.00, 1, 1, 4),   -- Venta 1: Laptops
('2025-10-25', 750000.00, 2, 1, 2),    -- Venta 2: Mouses
('2025-11-03', 325000.00, 3, 2, 1),    -- Venta 3: Teclados
('2025-11-10', 900000.00, 4, 3, 3),    -- Venta 4: Monitores
('2025-11-12', 1100000.00, 1, 1, 4);   -- Venta 5: Discos Duros

-- Agregar detalle de ventas
INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 5, 450000.00, 2250000.00),    -- 5 Laptops
(2, 2, 50, 15000.00, 750000.00),     -- 50 Mouses
(3, 3, 5, 65000.00, 325000.00),      -- 5 Teclados
(4, 4, 5, 180000.00, 900000.00),     -- 5 Monitores
(5, 5, 20, 55000.00, 1100000.00);    -- 20 Discos Duros

-- ===================================================
-- 3. CONSULTAS DE PRUEBA
-- ===================================================

-- Ver todos los productos disponibles
SELECT * FROM productos ORDER BY nombre;

-- Ver todos los proveedores
SELECT * FROM proveedores ORDER BY nombre;

-- Ver todos los clientes
SELECT * FROM clientes ORDER BY nombre;

-- Ver todas las compras con detalle
SELECT 
    c.id_compra,
    c.fecha,
    prov.nombre AS proveedor,
    loc.nombre AS local,
    prod.nombre AS producto,
    dc.cantidad,
    dc.precio_unitario,
    dc.subtotal,
    c.total AS total_compra
FROM compras c
INNER JOIN proveedores prov ON c.id_proveedor = prov.id_proveedor
INNER JOIN locales loc ON c.id_local = loc.id_local
INNER JOIN detalle_compras dc ON c.id_compra = dc.id_compra
INNER JOIN productos prod ON dc.id_producto = prod.id_producto
ORDER BY c.fecha DESC, c.id_compra, prod.nombre;

-- Ver todas las ventas con detalle
SELECT 
    v.id_venta,
    v.fecha,
    cli.nombre AS cliente,
    loc.nombre AS local,
    mp.nombre AS metodo_pago,
    prod.nombre AS producto,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal,
    v.total AS total_venta
FROM ventas v
INNER JOIN clientes cli ON v.id_cliente = cli.id_cliente
INNER JOIN locales loc ON v.id_local = loc.id_local
INNER JOIN metodos_pago mp ON v.id_metodo = mp.id_metodo
INNER JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
INNER JOIN productos prod ON dv.id_producto = prod.id_producto
ORDER BY v.fecha DESC, v.id_venta, prod.nombre;

-- Ver productos por proveedor
SELECT 
    prov.nombre AS proveedor,
    prod.nombre AS producto,
    prod.precio,
    prod.cantidad_inventario
FROM productos prod
INNER JOIN proveedores prov ON prod.id_proveedor = prov.id_proveedor
ORDER BY prov.nombre, prod.nombre;

-- Total de ventas por producto
SELECT 
    prod.nombre AS producto,
    SUM(dv.cantidad) AS total_vendido,
    SUM(dv.subtotal) AS ingresos_generados
FROM detalle_ventas dv
INNER JOIN productos prod ON dv.id_producto = prod.id_producto
GROUP BY prod.nombre
ORDER BY total_vendido DESC;

-- Total de compras por producto
SELECT 
    prod.nombre AS producto,
    SUM(dc.cantidad) AS total_comprado,
    SUM(dc.subtotal) AS costo_total
FROM detalle_compras dc
INNER JOIN productos prod ON dc.id_producto = prod.id_producto
GROUP BY prod.nombre
ORDER BY total_comprado DESC;

-- Resumen de ingresos por cliente
SELECT 
    cli.nombre AS cliente,
    COUNT(v.id_venta) AS numero_ventas,
    SUM(v.total) AS total_comprado
FROM ventas v
INNER JOIN clientes cli ON v.id_cliente = cli.id_cliente
GROUP BY cli.nombre
ORDER BY total_comprado DESC;

-- Resumen de compras por proveedor
SELECT 
    prov.nombre AS proveedor,
    COUNT(c.id_compra) AS numero_compras,
    SUM(c.total) AS total_comprado
FROM compras c
INNER JOIN proveedores prov ON c.id_proveedor = prov.id_proveedor
GROUP BY prov.nombre
ORDER BY total_comprado DESC;

-- Ventas por local
SELECT 
    loc.nombre AS local,
    loc.ciudad,
    COUNT(v.id_venta) AS numero_ventas,
    SUM(v.total) AS total_vendido
FROM ventas v
INNER JOIN locales loc ON v.id_local = loc.id_local
GROUP BY loc.nombre, loc.ciudad
ORDER BY total_vendido DESC;

-- Métodos de pago más utilizados
SELECT 
    mp.nombre AS metodo_pago,
    COUNT(v.id_venta) AS veces_usado,
    SUM(v.total) AS monto_total
FROM ventas v
INNER JOIN metodos_pago mp ON v.id_metodo = mp.id_metodo
GROUP BY mp.nombre
ORDER BY veces_usado DESC;

-- ===================================================
-- BOOTCAMP FULL STACK JAVASCRIPT
-- M05 - EVALUACIÓN DE PORTAFOLIO
-- ALUMNA: MACARENA ESPINOZA GATICA
-- ===================================================
