# Tabla `Comanda`

Script: [`instalacion/02-create-table-comanda.sql`](../../instalacion/02-create-table-comanda.sql)

Comandas (tickets) del restaurante durante 2025. Es una tabla **desnormalizada a propósito**: viene de una hoja de cálculo plana, y `Cliente`, `Mesero` y `MedioPago` son texto libre en lugar de llaves foráneas a sus catálogos.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idComanda` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `FechaComanda` | `DATE` | No | — | Fecha en que se registró la comanda |
| `Cliente` | `VARCHAR(100)` | No | — | Nombre completo del cliente (texto libre; 30 clientes distintos) |
| `Mesero` | `VARCHAR(100)` | No | — | Nombre completo del mesero que atendió (texto libre; 8 meseros distintos) |
| `Mesa` | `INT` | No | — | Número de mesa (1–15) |
| `MedioPago` | `VARCHAR(30)` | No | — | Forma de pago: `'Efectivo'`, `'Tarjeta de Credito'` (así, sin acento), `'Tarjeta de Débito'` o `'Transferencia'` |
| `TotalPagado` | `DECIMAL(10,2)` | No | — | Monto total de la comanda |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idComanda)` | Llave primaria | Identifica cada comanda. |

Solo tiene llave primaria: no hay catálogos ni `CHECK`. La normalización de esta tabla (catálogos de clientes, meseros y medios de pago) es justo lo que el modelo no hace.
