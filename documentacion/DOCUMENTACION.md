# BOOTCAMP FULL STACK JAVASCRIPT
# M05 - EVALUACIÓN DE MÓDULO
# ALUMNA: MACARENA ESPINOZA GATICA
--------------------------------------------------------------------------------

# DOCUMENTACIÓN - SISTEMA DE GESTIÓN DE INVENTARIO

## 1. MODELO DE DATOS

**Notas:** 
- El diagrama entidad-relación completo está disponible en el archivo `diagrama_modelo_relacional.mermaid` así como su representación visual en el archivo `diagrama_modelo_relacional.png`.
- Se incluyen capturas de las consultas realizadas en el archivo `capturas_consultas_sql.pdf`

### Entidades Principales

**PROVEEDORES**
- Atributos: id_proveedor (PK), nombre, dirección, teléfono, email (UK - UNIQUE)
- Descripción: Almacena información de los proveedores que suministran productos

**PRODUCTOS**
- Atributos: id_producto (PK), nombre, descripción, precio, cantidad_inventario, id_proveedor (FK)
- Descripción: Registra los productos disponibles en el inventario

**TRANSACCIONES**
- Atributos: id_transaccion (PK), tipo, fecha, cantidad, id_producto (FK), id_proveedor (FK)
- Descripción: Registra las operaciones de compra y venta

### Relaciones
- Un PROVEEDOR suministra muchos PRODUCTOS (1:N)
- Un PROVEEDOR participa en muchas TRANSACCIONES (1:N)
- Un PRODUCTO tiene muchas TRANSACCIONES (1:N)

## 2. NORMALIZACIÓN

El modelo está normalizado hasta la Tercera Forma Normal (3FN):
- Todos los atributos contienen valores atómicos
- No hay dependencias parciales
- No hay dependencias transitivas

**Ventajas:**
- Elimina redundancia de datos
- Facilita el mantenimiento
- Asegura la integridad de los datos

## 3. RESTRICCIONES DE INTEGRIDAD

**Integridad de entidad:**
- PRIMARY KEY en todas las tablas

**Integridad referencial:**
- FOREIGN KEY en transacciones y productos
- ON DELETE RESTRICT para evitar eliminación de registros con dependencias

**Restricciones de dominio:**
- precio > 0
- cantidad_inventario >= 0
- tipo IN ('compra', 'venta')
- cantidad > 0
- email UNIQUE

## 4. FUNCIONALIDADES

### Funciones Implementadas
- **registrar_venta()**: Valida inventario antes de registrar venta
- **registrar_compra()**: Registra compra y actualiza inventario

### Vistas Creadas
- **vista_inventario**: Resume el estado del inventario
- **vista_transacciones**: Historial detallado de transacciones

### Índices para Optimización
- idx_transacciones_fecha
- idx_transacciones_tipo
- idx_transacciones_producto
- idx_productos_nombre

## 5. EJEMPLOS DE USO

**Registrar una compra:**
```sql
SELECT registrar_compra(id_producto, cantidad, id_proveedor);
```

**Registrar una venta:**
```sql
SELECT registrar_venta(id_producto, cantidad, id_proveedor);
```

**Consultar inventario:**
```sql
SELECT * FROM vista_inventario;
```

**Ver transacciones recientes:**
```sql
SELECT * FROM vista_transacciones ORDER BY fecha DESC;
```

## 6. DATOS DE PRUEBA

El sistema incluye:
- 3 proveedores
- 5 productos
- 10 transacciones (5 compras, 5 ventas)

