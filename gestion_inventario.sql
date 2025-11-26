-- ===================================================
-- SISTEMA DE GESTIÓN DE INVENTARIO
-- Base de Datos: PostgreSQL
-- ===================================================

-- Eliminar TABLAs si existen (para poder ejecutar el script múltiples veces)
DROP TABLE IF EXISTS transacciones CASCADE;
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

-- TABLA: transacciones
CREATE TABLE transacciones (
    id_transaccion SERIAL PRIMARY KEY,
    tipo VARCHAR(10) NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    cantidad INT NOT NULL,
    id_producto INT NOT NULL,
    id_proveedor INT NOT NULL,
    CONSTRAINT tipo_valido CHECK (tipo IN ('compra', 'venta')),
    CONSTRAINT cantidad_positiva CHECK (cantidad > 0),
    CONSTRAINT fk_producto FOREIGN KEY (id_producto) 
        REFERENCES productos(id_producto) ON DELETE RESTRICT,
    CONSTRAINT fk_proveedor FOREIGN KEY (id_proveedor) 
        REFERENCES proveedores(id_proveedor) ON DELETE RESTRICT
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

-- Agregar transacciones de compra
INSERT INTO transacciones (tipo, fecha, cantidad, id_producto, id_proveedor) VALUES
('compra', '2025-10-15', 30, 1, 1),
('compra', '2025-10-18', 150, 2, 2),
('compra', '2025-10-20', 50, 3, 1),
('compra', '2025-11-01', 20, 4, 3),
('compra', '2025-11-05', 80, 5, 2);

-- Agregar transacciones de venta
INSERT INTO transacciones (tipo, fecha, cantidad, id_producto, id_proveedor) VALUES
('venta', '2025-10-22', 5, 1, 1),
('venta', '2025-10-25', 50, 2, 2),
('venta', '2025-11-03', 5, 3, 1),
('venta', '2025-11-10', 5, 4, 3),
('venta', '2025-11-12', 20, 5, 2);

-- ===================================================
-- 3. CONSULTAS DE PRUEBA
-- ===================================================

-- Ver todos los productos disponibles
SELECT * FROM productos ORDER BY nombre;

-- Ver todos los proveedores
SELECT * FROM proveedores ORDER BY nombre;

-- Ver todas las transacciones
SELECT 
    t.id_transaccion,
    t.tipo,
    t.fecha,
    t.cantidad,
    prod.nombre AS producto,
    prov.nombre AS proveedor
FROM transacciones t
INNER JOIN productos prod ON t.id_producto = prod.id_producto
INNER JOIN proveedores prov ON t.id_proveedor = prov.id_proveedor
ORDER BY t.fecha DESC;

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
    prod.nombre,
    SUM(t.cantidad) AS total_vendido
FROM transacciones t
INNER JOIN productos prod ON t.id_producto = prod.id_producto
WHERE t.tipo = 'venta'
GROUP BY prod.nombre
ORDER BY total_vendido DESC;

-- Total de compras por producto
SELECT 
    prod.nombre,
    SUM(t.cantidad) AS total_comprado
FROM transacciones t
INNER JOIN productos prod ON t.id_producto = prod.id_producto
WHERE t.tipo = 'compra'
GROUP BY prod.nombre
ORDER BY total_comprado DESC;

-- ===================================================
-- BOOTCAMP FULL STACK JAVASCRIPT
-- M05 - EVALUACIÓN DE MÓDULO
-- ALUMNA: MACARENA ESPINOZA GATICA
-- ===================================================
