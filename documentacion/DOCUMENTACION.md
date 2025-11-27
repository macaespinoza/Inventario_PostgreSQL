# BOOTCAMP FULL STACK JAVASCRIPT
# M05 - EVALUACIÓN DE PORTAFOLIO
# ALUMNA: MACARENA ESPINOZA GATICA
--------------------------------------------------------------------------------

# DOCUMENTACIÓN - SISTEMA DE GESTIÓN DE INVENTARIO

## 1. MODELO DE DATOS

### Entidades Principales

**PROVEEDORES**
- Atributos: id_proveedor (PK), nombre, dirección, teléfono, email (UK)
- Suministran productos y participan en compras

**PRODUCTOS**
- Atributos: id_producto (PK), nombre, descripción, precio, cantidad_inventario, id_proveedor (FK)
- Productos en el catálogo del inventario

**CLIENTES**
- Atributos: id_cliente (PK), nombre, email, teléfono
- Realizan compras en el comercio

**LOCALES**
- Atributos: id_local (PK), nombre, ciudad, dirección
- Sucursales donde se registran operaciones

**METODOS_PAGO**
- Atributos: id_metodo (PK), nombre
- Formas de pago disponibles para ventas

### Módulo de Compras (Entrada de Inventario)

**COMPRAS**
- Atributos: id_compra (PK), fecha, total, id_proveedor (FK), id_local (FK)
- Registro de compras a proveedores

**DETALLE_COMPRAS**
- Atributos: id_detalle_compra (PK), id_compra (FK), id_producto (FK), cantidad, precio_unitario, subtotal
- Productos incluidos en cada compra

### Módulo de Ventas (Salida de Inventario)

**VENTAS**
- Atributos: id_venta (PK), fecha, total, id_cliente (FK), id_local (FK), id_metodo (FK)
- Registro de ventas a clientes

**DETALLE_VENTAS**
- Atributos: id_detalle_venta (PK), id_venta (FK), id_producto (FK), cantidad, precio_unitario, subtotal
- Productos incluidos en cada venta

### Relaciones

**Productos y Proveedores:**
- Un PROVEEDOR suministra muchos PRODUCTOS (1:N)

**Compras:**
- Un PROVEEDOR participa en muchas COMPRAS (1:N)
- Un LOCAL registra muchas COMPRAS (1:N)
- Una COMPRA contiene muchos DETALLE_COMPRAS (1:N)
- Un PRODUCTO se incluye en muchos DETALLE_COMPRAS (1:N)

**Ventas:**
- Un CLIENTE realiza muchas VENTAS (1:N)
- Un LOCAL registra muchas VENTAS (1:N)
- Un METODO_PAGO se usa en muchas VENTAS (1:N)
- Una VENTA contiene muchos DETALLE_VENTAS (1:N)
- Un PRODUCTO se incluye en muchos DETALLE_VENTAS (1:N)

## 2. NORMALIZACIÓN

Modelo normalizado hasta 3FN:
- Valores atómicos en todos los atributos
- Sin dependencias parciales
- Sin dependencias transitivas
- Separación clara entre compras y ventas

**Mejoras del modelo:**
- Separa operaciones de entrada (compras) y salida (ventas)
- Permite múltiples productos por operación
- Facilita auditoría y análisis de negocio

## 3. RESTRICCIONES DE INTEGRIDAD

**Claves primarias:** Todas las tablas tienen PK

**Claves foráneas:** 
- ON DELETE RESTRICT para datos maestros
- ON DELETE CASCADE para detalles de compras/ventas

**Constraints de dominio:**
- Precios y totales > 0
- Cantidades > 0 en detalles, >= 0 en inventario
- Emails con formato válido (@)

## 4. DIAGRAMAS

Los modelos visuales están en la carpeta `modelos/`:
- `modelo_conceptual.mermaid` - Diagrama conceptual con flujos de negocio
- `modelo_logico.mermaid` - Diagrama ER completo
- `modelo_fisico.sql` - Script de creación de base de datos

## 5. CONSULTAS IMPLEMENTADAS

El archivo `gestion_inventario.sql` incluye:

**Consultas básicas:**
- Listado de productos, proveedores, clientes
- Vista completa de compras con detalles
- Vista completa de ventas con detalles
- Productos por proveedor

**Análisis de negocio:**
- Total de ventas por producto
- Total de compras por producto
- Resumen de ingresos por cliente
- Resumen de compras por proveedor
- Ventas por local
- Métodos de pago más utilizados

## 6. DATOS DE PRUEBA

El sistema incluye:
- 3 proveedores
- 5 productos
- 4 clientes
- 3 locales
- 5 métodos de pago
- 5 compras con detalles
- 5 ventas con detalles
