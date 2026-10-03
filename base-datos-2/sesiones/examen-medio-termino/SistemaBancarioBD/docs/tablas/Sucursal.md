# Tabla `Sucursal`

Script: [`instalacion/01-Sucursal/01-create-table.sql`](../../instalacion/01-Sucursal/01-create-table.sql)

Catálogo de sucursales del banco. Cada cliente se da de alta en una sucursal.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idSucursal` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `Nombre` | `VARCHAR(50)` | No | — | Nombre de la sucursal |
| `Direccion` | `VARCHAR(200)` | No | — | Domicilio completo en un solo campo (calle, número, colonia, municipio) |
| `Telefono` | `VARCHAR(15)` | No | — | Teléfono de la sucursal a 10 dígitos |
| `Activo` | `BIT` | No | `1` | `1` = activa, `0` = cerrada (baja lógica) |
| `FechaCreacion` | `DATETIME` | No | `GETDATE()` | Cuándo se creó el renglón |
| `FechaUltimaModificacion` | `DATETIME` | No | `GETDATE()` | Cuándo se modificó por última vez |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idSucursal)` | Llave primaria | Identifica cada sucursal de forma única. |
| `UNIQUE (Nombre)` | Único | No puede haber dos sucursales con el mismo nombre. |
| `UNIQUE (Telefono)` | Único | Dos sucursales no pueden compartir teléfono. |
| `DEFAULT 1` en `Activo` | Default | Toda sucursal nueva nace activa. |
| `DEFAULT GETDATE()` en `FechaCreacion`/`FechaUltimaModificacion` | Default | Auditoría automática. |

## Datos iniciales

| idSucursal | Nombre | Direccion | Telefono | Clientes |
|---|---|---|---|---|
| 1 | Sucursal Centro | Av. Constitución 400, Col. Centro, Monterrey, N.L. | 8180000001 | 10 |
| 2 | Sucursal San Pedro | Av. Vasconcelos 1250, Col. Del Valle, San Pedro Garza García, N.L. | 8180000002 | 8 |
| 3 | Sucursal Cumbres | Av. Paseo de los Leones 3300, Col. Cumbres Elite, Monterrey, N.L. | 8180000003 | 7 |
| 4 | Sucursal Apodaca | Av. Miguel Alemán 1800, Col. Pueblo Nuevo, Apodaca, N.L. | 8180000004 | 5 |
| 5 | Sucursal Guadalupe | Av. Eloy Cavazos 2500, Col. Contry La Silla, Guadalupe, N.L. | 8180000005 | 0 |

Sucursal Guadalupe es de reciente apertura y aún no tiene clientes.

## Relacionada con

[`Cliente`](Cliente.md) — clientes dados de alta en la sucursal (1:N).
