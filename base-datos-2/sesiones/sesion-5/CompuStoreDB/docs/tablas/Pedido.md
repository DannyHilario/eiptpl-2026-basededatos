# Tabla `Pedido`

Script: [`instalacion/06-Pedido/01-create-table.sql`](../../instalacion/06-Pedido/01-create-table.sql)

Encabezado de pedido — **1:N** con `Cliente`. No tiene `Total` (se calcula al vuelo, ver [`ufn_calcularTotalPedido`](../funciones/ufn_calcularTotalPedido.md)) ni `Activo` (no es catálogo).

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idPedido` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idCliente` | `INT` | No | — | FK a `Cliente` |
| `Fecha` | `DATE` | No | — | Fecha del pedido |
| `Cerrado` | `BIT` | No | `0` | `1` = ya fue entregado (ver [`usp_entregarPedido`](../usp_entregarPedido.md)); congela el pedido y sus líneas contra más cambios |
| `FechaEntrega` | `DATE` | No | `'1900-01-01'` | Fecha en la que se marcó como entregado. Centinela `1900-01-01` = "todavía no entregado" — se evita `NULL` como estado, mismo criterio que `Activo` en las demás tablas |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el pedido |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idPedido)` | Llave primaria | Identifica cada pedido. |
| `FOREIGN KEY (idCliente) REFERENCES Cliente` | Llave foránea | No se puede crear un pedido de un cliente que no existe. |
| `DEFAULT 0` en `Cerrado` | Default | Todo pedido nuevo nace abierto (no entregado); nadie tiene que mandar `0` explícito al insertar. |
| `DEFAULT '1900-01-01'` en `FechaEntrega` | Default | Evita dejar la columna en `NULL` mientras el pedido no se entrega — una fecha claramente "imposible" es más fácil de filtrar (`WHERE FechaEntrega = '1900-01-01'`) que distinguir `NULL` de "sí tiene fecha pero no se cargó". |
| `DEFAULT GETDATE()` en fechas de auditoría | Default | Igual que en las demás tablas. |

No tiene `CHECK`/`UNIQUE` propios más allá de la FK: no hay ninguna combinación de columnas que deba ser única a nivel de esquema (un mismo cliente puede tener varios pedidos en la misma fecha).

## SPs, función y vista relacionados

[`usp_insertarPedido`](../usp_insertarPedido.md) · [`usp_eliminarPedido`](../usp_eliminarPedido.md) · [`usp_actualizarPedido`](../usp_actualizarPedido.md) · [`usp_entregarPedido`](../usp_entregarPedido.md) · [`ufn_calcularTotalPedido`](../funciones/ufn_calcularTotalPedido.md) · [`vw_PedidoResumen`](../vistas/vw_PedidoResumen.md)
