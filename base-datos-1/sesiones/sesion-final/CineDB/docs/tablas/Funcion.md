# Tabla `Funcion`

Script: [`instalacion/08-create-table-funcion.sql`](../../instalacion/08-create-table-funcion.sql)

Hecho — la proyección de una [`Pelicula`](Pelicula.md) en una [`Sala`](Sala.md) en una fecha y hora.

## Diccionario de datos

| Columna | Tipo | Nulo | Default | Descripción |
|---------|------|------|---------|-------------|
| `idFuncion` | `INT IDENTITY(1,1)` | No | autonumérico | Llave primaria |
| `idSala` | `INT` | No | — | FK a `Sala` |
| `idPelicula` | `INT` | No | — | FK a `Pelicula` |
| `Fecha` | `DATE` | No | — | Fecha de la función |
| `Hora` | `TIME` | No | — | Hora de inicio |
| `Precio` | `DECIMAL(10,2)` | No | — | Precio del boleto para esta función, copiado de `TipoSala.Precio` al programarla |
| `CantidadVendida` | `INT` | No | `0` | Boletos vendidos de esta función; los datos iniciales la sincronizan con `Boleto` |

## Constraints y por qué existen

| Constraint | Tipo | Para qué sirve |
|------------|------|-----------------|
| `PRIMARY KEY (idFuncion)` | Llave primaria | Identifica cada función. |
| `fk_Funcion_Sala`: `FOREIGN KEY (idSala)` → `Sala(idSala)` | Llave foránea | Solo permite referenciar registros de `Sala` que existan. |
| `fk_Funcion_Pelicula`: `FOREIGN KEY (idPelicula)` → `Pelicula(idPelicula)` | Llave foránea | Solo permite referenciar registros de `Pelicula` que existan. |
| `uq_Funcion_SalaFechaHora`: `UNIQUE (idSala, Fecha, Hora)` | Único compuesto | Una sala no puede tener dos funciones con la misma fecha y hora de inicio. No detecta traslapes (una función a las 18:01 en una sala que ya tiene otra a las 18:00); ver *Limitaciones conocidas del modelo* en el README. |
| `DEFAULT 0` en `CantidadVendida` | Default | Toda función nueva empieza sin boletos vendidos. |

No tiene `Activo`: es una tabla de hechos, no un catálogo.

## `Precio` — por qué se copia

El precio del boleto depende del **tipo de sala**, no de la película. Al programar la función se copia el `Precio` vigente de su `TipoSala` y queda fijo: si después cambia el precio del tipo de sala, las funciones ya programadas conservan el precio original. Por eso `Funcion.Precio` no se calcula con un `JOIN` a `TipoSala`.

## Relacionada con

- [`Sala`](Sala.md) — por `idSala` (N:1).
- [`Pelicula`](Pelicula.md) — por `idPelicula` (N:1).
- [`Boleto`](Boleto.md) — la referencia por `idFuncion` (1:N).
