[README.md](https://github.com/user-attachments/files/23779801/README.md)
# Sistema de Gestión de Inventario

## Descripción
Sistema de gestión de inventario que permite administrar productos, proveedores y transacciones de compra/venta.

## Requisitos
- PostgreSQL 12 o superior

## Instalación

1. Crear la base de datos:
```sql
CREATE DATABASE gestion_inventario;
\c gestion_inventario
```

2. Ejecutar el script:
```bash
psql -U tu_usuario -d gestion_inventario -f sistema_inventario.sql
```

## Estructura de Tablas

- **productos**: Información de productos e inventario
- **proveedores**: Datos de proveedores
- **transacciones**: Registro de compras y ventas

## Funcionalidades Principales

- Gestión de productos (CRUD)
- Registro de proveedores
- Transacciones de compra/venta con actualización automática de inventario
- Vistas para consultas de inventario y transacciones

## Ejemplos de Uso

**Registrar una venta:**
```sql
SELECT registrar_venta(1, 5, 1);
```

**Registrar una compra:**
```sql
SELECT registrar_compra(2, 50, 2);
```

**Ver inventario:**
```sql
SELECT * FROM vista_inventario;
```

**Ver transacciones:**
```sql
SELECT * FROM vista_transacciones ORDER BY fecha DESC;
```

## Autor
Evaluación Módulo 05 - Bootcamp Full-Stack
Alumna: Macarena Espinoza Gatica
2025
