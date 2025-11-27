-- ===================================================
-- SISTEMA DE GESTIÓN DE INVENTARIO
-- Base de Datos: PostgreSQL
-- Modelo Mejorado: Separación de Compras y Ventas
-- ===================================================

-- ===================================================
-- TABLAS MAESTRAS
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

-- ===================================================
-- MÓDULO DE COMPRAS (Entrada de Inventario)
-- ===================================================

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

-- ===================================================
-- MÓDULO DE VENTAS (Salida de Inventario)
-- ===================================================

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
-- ÍNDICES PARA OPTIMIZACIÓN
-- ===================================================

-- Índices para búsquedas frecuentes
CREATE INDEX idx_productos_proveedor ON productos(id_proveedor);
CREATE INDEX idx_compras_fecha ON compras(fecha);
CREATE INDEX idx_compras_proveedor ON compras(id_proveedor);
CREATE INDEX idx_detalle_compras_compra ON detalle_compras(id_compra);
CREATE INDEX idx_detalle_compras_producto ON detalle_compras(id_producto);
CREATE INDEX idx_ventas_fecha ON ventas(fecha);
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX idx_detalle_ventas_venta ON detalle_ventas(id_venta);
CREATE INDEX idx_detalle_ventas_producto ON detalle_ventas(id_producto);

-- ===================================================
-- COMENTARIOS EN TABLAS
-- ===================================================

COMMENT ON TABLE proveedores IS 'Almacena información de los proveedores que suministran productos';
COMMENT ON TABLE productos IS 'Catálogo de productos disponibles con su inventario actual';
COMMENT ON TABLE clientes IS 'Registro de clientes que realizan compras';
COMMENT ON TABLE locales IS 'Ubicaciones físicas donde se realizan operaciones';
COMMENT ON TABLE metodos_pago IS 'Métodos de pago disponibles para ventas';
COMMENT ON TABLE compras IS 'Registro de compras realizadas a proveedores';
COMMENT ON TABLE detalle_compras IS 'Detalle de productos incluidos en cada compra';
COMMENT ON TABLE ventas IS 'Registro de ventas realizadas a clientes';
COMMENT ON TABLE detalle_ventas IS 'Detalle de productos incluidos en cada venta';
