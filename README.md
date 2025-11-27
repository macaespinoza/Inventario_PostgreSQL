# Sistema de Gestión de Inventario - UPGRADE v2.0
# EVALUACIÓN DE PORTAFOLIO - MÓDULO 05
## ALUMNA: MACARENA ESPINOZA GATICA

> **Nota:** Esta es una versión mejorada de la Evaluación de Módulo 05. Se encuentra en un nuevo branch con una estructura completamente normalizada que se ajusta mejor a la lógica de negocio.

## Descripción

Sistema de gestión de inventario con módulos separados para **compras** (entrada) y **ventas** (salida), permitiendo gestionar productos, proveedores, clientes, locales y métodos de pago.

## Mejoras de esta Versión

- ✅ Separación de COMPRAS y VENTAS (antes tabla única TRANSACCIONES)
- ✅ Tablas de detalle para múltiples productos por operación
- ✅ Nuevas entidades: CLIENTES, LOCALES, METODOS_PAGO
- ✅ Modelo más normalizado y escalable
- ✅ Consultas de análisis de negocio incluidas

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
psql -U tu_usuario -d gestion_inventario -f gestion_inventario.sql
```

## Estructura de Tablas

**Entidades maestras:**
- `proveedores` - Proveedores de productos
- `productos` - Catálogo de productos
- `clientes` - Clientes del comercio
- `locales` - Sucursales
- `metodos_pago` - Formas de pago

**Módulo de compras:**
- `compras` - Encabezados de compras
- `detalle_compras` - Productos por compra

**Módulo de ventas:**
- `ventas` - Encabezados de ventas
- `detalle_ventas` - Productos por venta


## Documentación

Ver `DOCUMENTACION.md` para detalles completos del modelo de datos, relaciones y normalización.

## Modelos Visuales

- `modelos/modelo_conceptual.mermaid` - Diagrama de flujos de negocio
- `modelos/modelo_logico.mermaid` - Diagrama entidad-relación
- `modelos/modelo_fisico.sql` - DDL completo

## Autor

Evaluación de Portafolio - Módulo 05 - Bootcamp Full-Stack JavaScript  
Alumna: Macarena Espinoza Gatica  
2025
