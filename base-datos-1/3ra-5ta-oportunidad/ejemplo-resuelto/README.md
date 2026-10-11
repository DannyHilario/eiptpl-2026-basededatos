# Ejemplo resuelto — LavaExpress

Solución completa del [caso LavaExpress](caso.md), un negocio que **no está asignado a ningún alumno**. Muestra lo que se espera en los cuatro entregables de la Evidencia Integral:

| Entregable | En este ejemplo |
|------------|-----------------|
| PDF | El contenido está abajo, con la misma estructura que debe tener tu PDF |
| `Instalacion.ZIP` | Los scripts de [`LavaExpressDB/instalacion/`](LavaExpressDB/instalacion) |
| `Reversa.ZIP` | Los scripts de [`LavaExpressDB/reversa/`](LavaExpressDB/reversa) |
| `Consultas.ZIP` | Los 10 archivos de [`LavaExpressDB/consultas/`](LavaExpressDB/consultas) |

← [Regresar a la descripción de la evidencia](../descripcion-evidencia-integral.md)

---

# Contenido del PDF

## Portada

- **Nombre:** (nombre completo del alumno)
- **Matrícula:** (matrícula)
- **Alumno:** (número de alumno)
- **Caso:** LavaExpress — lavandería

## 1. Modelo relacional

![Modelo relacional de LavaExpressDB](assets/diagrama-er.png)

> **En tu PDF, el diagrama se hace en [dbdiagram.io](https://dbdiagram.io).** Este ejemplo usa la herramienta de diagramas del curso, pero el contenido es el mismo: tablas, columnas, tipos, llaves y relaciones.

## 2. Descripción del negocio y de la base de datos

LavaExpress es una lavandería con tres sucursales. Ofrece servicios que se cobran por kilo (Lavado, Planchado, Tintorería, etc.), cada uno con su precio. Los clientes se registran una sola vez, en la sucursal a la que llegan primero, y cada vez que dejan ropa se registra un pedido con el servicio, la fecha, los kilos y el precio por kilo con el que se cobró.

La base de datos **LavaExpressDB** tiene 4 tablas: `Sucursal`, `Cliente`, `TipoServicio` y `Pedido`. `Pedido` une a clientes y servicios, y registra cada vez que alguien deja ropa.

## 3. Plan de instalación

| Orden | Script | Descripción |
|---|---|---|
| 1 | `01-create-database.sql` | Crea la base de datos `LavaExpressDB` |
| 2 | `02-create-table-sucursal.sql` | Crea la tabla `Sucursal` |
| 3 | `03-create-table-cliente.sql` | Crea la tabla `Cliente`, con llave foránea a `Sucursal` |
| 4 | `04-create-table-tipo-servicio.sql` | Crea la tabla `TipoServicio` |
| 5 | `05-create-table-pedido.sql` | Crea la tabla `Pedido`, con llaves foráneas a `Cliente` y a `TipoServicio` |
| 6 | `06-insert-sucursal.sql` | Inserta las 3 sucursales que define el caso |
| 7 | `07-insert-cliente.sql` | Inserta 12 clientes (los clientes 11 y 12 no tienen pedidos) |
| 8 | `08-insert-tipo-servicio.sql` | Inserta los 5 servicios que define el caso, con su precio por kilo (Edredones no tiene pedidos) |
| 9 | `09-insert-pedido.sql` | Inserta 24 pedidos, de noviembre de 2025 a junio de 2026, cada uno con el precio por kilo con el que se cobró |

> Cada script, excepto el 1, empieza con `USE LavaExpressDB;`, así que puede ejecutarse sin importar qué base de datos esté seleccionada en SSMS.

## 4. Plan de reversa

| Orden | Script | Descripción |
|---|---|---|
| 1 | `01-drop-tables.sql` | Elimina las tablas en orden inverso a las llaves foráneas: `Pedido`, `TipoServicio`, `Cliente` y `Sucursal` |
| 2 | `02-drop-database.sql` | Elimina la base de datos `LavaExpressDB` |

> Antes de ejecutar el script 2, selecciona **otra** base de datos en el dropdown de SSMS (por ejemplo, `master`): no se puede eliminar la base de datos a la que estás conectado.

## 5. Decisiones de diseño

### `Sucursal`

Es un catálogo. Las sucursales tienen su propia tabla para no repetir el nombre y la dirección en cada cliente: si una sucursal cambia de dirección, se actualiza en un solo renglón. `Nombre` es `UNIQUE` porque no puede haber dos sucursales "LavaExpress Centro".

### `Cliente`

Tiene la llave foránea `idSucursal` porque cada cliente se registra en **una** sucursal y una sucursal tiene **muchos** clientes (relación 1:N): la llave foránea va del lado de "muchos". `Telefono` es `UNIQUE` porque es como se identifica al cliente en el mostrador. `Activo` tiene `DEFAULT 1` porque todo cliente nuevo empieza activo; si pide la baja se marca en `0` en lugar de borrarlo, para no perder sus pedidos.

### `TipoServicio`

No tiene llave foránea porque no depende de otra tabla. `Nombre` es `UNIQUE` para no tener dos servicios "Planchado". `PrecioPorKilo` tiene un `CHECK (PrecioPorKilo > 0)` porque un servicio gratis o con precio negativo no tiene sentido para el negocio.

### `Pedido`

Resuelve la relación **N:M** entre clientes y servicios: un cliente pide muchos servicios a lo largo del tiempo y un servicio lo piden muchos clientes. Por eso tiene dos llaves foráneas (`idCliente` e `idTipoServicio`), más la fecha y los kilos de ese pedido. `Kilos` tiene un `CHECK (Kilos > 0)`.

**`Pedido` guarda su propio `PrecioPorKilo`, aunque `TipoServicio` ya tiene uno.** No es un dato repetido: son dos datos distintos. `TipoServicio.PrecioPorKilo` es el precio **actual** y cambia cuando la lavandería sube sus precios. `Pedido.PrecioPorKilo` es el precio **con el que se cobró ese pedido** y nunca debe cambiar. Si el pedido no lo guardara, al subir el precio del Lavado todos los pedidos anteriores "costarían" más de lo que realmente se cobró, y ya no se podría saber cuánto pagó cada cliente. Por eso, al registrar un pedido se **copia** el precio vigente del servicio. El importe se calcula con los datos del propio pedido: `Kilos × Pedido.PrecioPorKilo`.

> **Las consultas no van en el PDF.** Van en `Consultas.ZIP`.

---

# Contenido de `Consultas.ZIP`

Diez archivos, uno por consulta, con **solo el código** y un comentario con la pregunta. Se ejecutan después de la instalación, con `LavaExpressDB` seleccionada.

| Archivo | Pregunta |
|---------|----------|
| [`01-consulta.sql`](LavaExpressDB/consultas/01-consulta.sql) | Pedidos de más de 5 kilos, del más pesado al más ligero |
| [`02-consulta.sql`](LavaExpressDB/consultas/02-consulta.sql) | Clientes activos, del más antiguo al más reciente |
| [`03-consulta.sql`](LavaExpressDB/consultas/03-consulta.sql) | Clientes cuyo nombre comienza con M |
| [`04-consulta.sql`](LavaExpressDB/consultas/04-consulta.sql) | Pedidos de marzo de 2026 |
| [`05-consulta.sql`](LavaExpressDB/consultas/05-consulta.sql) | Los 5 pedidos con más kilos |
| [`06-consulta.sql`](LavaExpressDB/consultas/06-consulta.sql) | Cada cliente con su sucursal |
| [`07-consulta.sql`](LavaExpressDB/consultas/07-consulta.sql) | Cada pedido con su servicio, el precio cobrado y el precio actual |
| [`08-consulta.sql`](LavaExpressDB/consultas/08-consulta.sql) | Cada pedido con cliente, servicio, kilos y precio cobrado |
| [`09-consulta.sql`](LavaExpressDB/consultas/09-consulta.sql) | Clientes que nunca han hecho un pedido |
| [`10-consulta.sql`](LavaExpressDB/consultas/10-consulta.sql) | Tipos de servicio que nunca se han solicitado |

Por ejemplo, `09-consulta.sql`:

```sql
-- Consulta 9: Lista los clientes que nunca han hecho un pedido.
SELECT C.idCliente, C.Nombre, C.Telefono
FROM Cliente C
LEFT JOIN Pedido P ON P.idCliente = C.idCliente
WHERE P.idPedido IS NULL
```

Con los datos iniciales regresa 2 clientes: Natalia Vega Saldaña y Gerardo Elizondo Mata.
