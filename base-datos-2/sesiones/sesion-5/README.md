# Sesión 5 — CompuStoreDB: modelado, N:N y auditoría

Retoma el ejercicio del PIA de Base de Datos I ([equipo-3.md](../../../base-datos-1/evidencias/archivos-pia/ejercicios/equipo-3.md) — CompuStore, tienda de artículos de cómputo) y lo evoluciona con temas propios de Base de Datos II: campos de auditoría, catálogos con baja lógica (`Activo`), una relación N:N resuelta con tabla puente, y una tabla de historial de precios.

---

## Modelo

![Modelo Relacional de CompuStoreDB](assets/diagrama-er.png)

7 tablas:

| Tabla | Descripción |
|-------|-------------|
| `Categoria` | Catálogo de categorías de artículos (Laptops, Monitores, Teclados, etc.) |
| `Articulo` | Catálogo de artículos, con precio de lista vigente |
| `ArticuloCategoria` | Tabla puente — relación **N:N** entre `Articulo` y `Categoria` |
| `HistoricoPrecioArticulo` | Historial de cambios de precio de un artículo (`PrecioAnterior` → `PrecioNuevo`), **1:N** con `Articulo` |
| `Cliente` | Catálogo de clientes |
| `Pedido` | Encabezado de pedido — **1:N** con `Cliente` |
| `DetallePedido` | Líneas de un pedido (artículo, cantidad, precio al momento de la venta) — **1:N** con `Pedido`, N:1 con `Articulo` |

Todas las tablas tienen `FechaCreacion` y `FechaUltimaModificacion` (auditoría). Los catálogos (`Categoria`, `Articulo`, `Cliente`) además tienen `Activo BIT` para baja lógica.

`Articulo.PrecioUnitario` es el precio de lista vigente; `DetallePedido.PrecioUnitario` conserva el precio real de cada venta aunque el precio de lista cambie después. El registro en `HistoricoPrecioArticulo` es manual (no hay trigger todavía).

---

## Paquete de instalación

Hay dos formas de instalar `CompuStoreDB`, ambas válidas — usa la que prefieras:

1. **Instalación completa en un solo script**: [`CompuStoreDB/instalar-completo.sql`](CompuStoreDB/instalar-completo.sql). Ábrelo en SSMS y ejecútalo completo (F5) — crea la base, las 7 tablas, los datos y los 19 procedimientos en un solo paso. Es la concatenación, en orden, de todos los scripts de `instalacion/`; cada uno queda separado con `GO` porque un `CREATE PROCEDURE` debe ser la única instrucción de su lote.
2. **Instalación manual, script por script**: ejecutar cada archivo de [`CompuStoreDB/instalacion`](CompuStoreDB/instalacion) en el orden de la tabla de abajo. Más lento, pero deja ver qué hace cada pieza por separado — recomendado la primera vez que se estudia el modelo.

Si modificas algún script de `instalacion/`, actualiza también `instalar-completo.sql` (o pide que se regenere) para que ambas formas de instalar sigan siendo equivalentes.

La carpeta `instalacion/` está organizada en una subcarpeta por entidad (prefijo numérico = orden de instalación, respeta las llaves foráneas):

| Carpeta/Archivo | Contenido |
|-----------------|-----------|
| `00-create-database.sql` | `CREATE DATABASE CompuStoreDB` |
| `01-Categoria/01-create-table.sql` | Tabla `Categoria` |
| `01-Categoria/02-insert.sql` | 11 categorías |
| `01-Categoria/03-usp-insertar.sql` | `usp_insertarCategoria` — alta de categoría |
| `01-Categoria/04-usp-eliminar.sql` | `usp_eliminarCategoria` — baja lógica de categoría |
| `01-Categoria/05-usp-habilitar.sql` | `usp_habilitarCategoria` — reactivar una categoría dada de baja |
| `01-Categoria/06-usp-actualizar.sql` | `usp_actualizarCategoria` — actualiza el nombre de una categoría |
| `02-Articulo/01-create-table.sql` | Tabla `Articulo` |
| `02-Articulo/02-insert.sql` | 51 artículos |
| `02-Articulo/03-usp-insertar.sql` | `usp_insertarArticulo` — alta de artículo |
| `02-Articulo/04-usp-eliminar.sql` | `usp_eliminarArticulo` — baja lógica de artículo |
| `02-Articulo/05-usp-habilitar.sql` | `usp_habilitarArticulo` — reactivar un artículo dado de baja |
| `02-Articulo/06-usp-actualizar-precio.sql` | `usp_actualizarPrecioArticulo` — cambia el precio de lista, invocando el registro de histórico |
| `02-Articulo/07-usp-actualizar.sql` | `usp_actualizarArticulo` — actualiza nombre y marca de un artículo |
| `03-ArticuloCategoria/01-create-table.sql` | Tabla puente `ArticuloCategoria` |
| `03-ArticuloCategoria/02-insert.sql` | 55 relaciones Articulo-Categoria (4 artículos en 2 categorías, para ilustrar la N:N) |
| `03-ArticuloCategoria/03-usp-asignar.sql` | `usp_asignarCategoriaArticulo` — asigna una categoría a un artículo |
| `03-ArticuloCategoria/04-usp-quitar.sql` | `usp_quitarCategoriaArticulo` — quita la asignación (`DELETE` físico) |
| `04-HistoricoPrecioArticulo/01-create-table.sql` | Tabla `HistoricoPrecioArticulo` |
| `04-HistoricoPrecioArticulo/02-usp-insertar.sql` | `usp_insertarHistoricoPrecioArticulo` — registra un cambio de precio |
| `05-Cliente/01-create-table.sql` | Tabla `Cliente` |
| `05-Cliente/02-insert.sql` | 25 clientes |
| `05-Cliente/03-usp-insertar.sql` | `usp_insertarCliente` — alta de cliente |
| `05-Cliente/04-usp-eliminar.sql` | `usp_eliminarCliente` — baja lógica de cliente |
| `05-Cliente/05-usp-habilitar.sql` | `usp_habilitarCliente` — reactivar un cliente dado de baja |
| `05-Cliente/06-usp-actualizar.sql` | `usp_actualizarCliente` — sobrescribe los datos principales de un cliente |
| `06-Pedido/01-create-table.sql` | Tabla `Pedido` |
| `06-Pedido/02-usp-insertar.sql` | `usp_insertarPedido` — alta de pedido |
| `06-Pedido/03-usp-eliminar.sql` | `usp_eliminarPedido` — elimina un pedido sin líneas registradas |
| `06-Pedido/04-usp-actualizar.sql` | `usp_actualizarPedido` — actualiza la fecha de un pedido |
| `07-DetallePedido/01-create-table.sql` | Tabla `DetallePedido` |

`Pedido`, `DetallePedido` y `HistoricoPrecioArticulo` se crean vacías — son tablas de hechos/historial, no catálogos, y no había datos reales que reutilizar para ellas.

`usp_actualizarPrecioArticulo` (dentro de `02-Articulo/`) hace `EXEC usp_insertarHistoricoPrecioArticulo` (definido en `04-HistoricoPrecioArticulo/`) antes de actualizar `Articulo.PrecioUnitario`. SQL Server resuelve nombres de objetos en un procedimiento hasta que se ejecuta (no al crearlo), así que el orden de las carpetas no rompe la instalación aunque el SP de Articulo se cree antes que el de HistoricoPrecioArticulo — solo importa que ambos existan antes de invocar `usp_actualizarPrecioArticulo`.

Reversa en [`CompuStoreDB/reversa`](CompuStoreDB/reversa): elimina las tablas en orden inverso a las llaves foráneas y luego la base de datos. No hay scripts de reversa por procedimiento porque `02-drop-database.sql` elimina la base completa, incluyendo todos los `usp_`.

### Documentación de los procedimientos

Todos siguen el patrón de "guard clauses" con códigos de salida visto en las sesiones 3 y 4 (`@ErrCodigo`/`@ErrMensaje`, `'000000'` para éxito, `RETURN` en cada validación fallida) — sin `TRY CATCH` todavía. Requieren `USE CompuStoreDB; GO` antes del `CREATE PROCEDURE` porque, a diferencia de una tabla o un `INSERT`, un procedimiento debe ser la primera instrucción de su batch.

El detalle de cada uno (parámetros, validaciones, códigos de salida, ejemplo `EXEC` y casos de prueba) está en [`CompuStoreDB/docs`](CompuStoreDB/docs):

**Categoria**
- [`usp_insertarCategoria`](CompuStoreDB/docs/usp_insertarCategoria.md) — alta de categoría
- [`usp_eliminarCategoria`](CompuStoreDB/docs/usp_eliminarCategoria.md) — baja lógica de categoría
- [`usp_habilitarCategoria`](CompuStoreDB/docs/usp_habilitarCategoria.md) — reactivar una categoría dada de baja
- [`usp_actualizarCategoria`](CompuStoreDB/docs/usp_actualizarCategoria.md) — actualiza el nombre de una categoría

**ArticuloCategoria**
- [`usp_asignarCategoriaArticulo`](CompuStoreDB/docs/usp_asignarCategoriaArticulo.md) — asigna una categoría a un artículo
- [`usp_quitarCategoriaArticulo`](CompuStoreDB/docs/usp_quitarCategoriaArticulo.md) — quita la asignación (`DELETE` físico, no hay `Activo` en la tabla puente)

**Cliente**
- [`usp_insertarCliente`](CompuStoreDB/docs/usp_insertarCliente.md) — alta de cliente
- [`usp_eliminarCliente`](CompuStoreDB/docs/usp_eliminarCliente.md) — baja lógica de cliente
- [`usp_habilitarCliente`](CompuStoreDB/docs/usp_habilitarCliente.md) — reactivar un cliente dado de baja
- [`usp_actualizarCliente`](CompuStoreDB/docs/usp_actualizarCliente.md) — sobrescribe los datos principales de un cliente

**Articulo**
- [`usp_insertarArticulo`](CompuStoreDB/docs/usp_insertarArticulo.md) — alta de artículo
- [`usp_eliminarArticulo`](CompuStoreDB/docs/usp_eliminarArticulo.md) — baja lógica de artículo
- [`usp_habilitarArticulo`](CompuStoreDB/docs/usp_habilitarArticulo.md) — reactivar un artículo dado de baja
- [`usp_insertarHistoricoPrecioArticulo`](CompuStoreDB/docs/usp_insertarHistoricoPrecioArticulo.md) — registra un cambio de precio (pieza interna, no usar directo)
- [`usp_actualizarPrecioArticulo`](CompuStoreDB/docs/usp_actualizarPrecioArticulo.md) — cambia el precio de lista invocando el SP anterior
- [`usp_actualizarArticulo`](CompuStoreDB/docs/usp_actualizarArticulo.md) — actualiza nombre y marca (no toca el precio)

**Pedido**
- [`usp_insertarPedido`](CompuStoreDB/docs/usp_insertarPedido.md) — alta de pedido
- [`usp_eliminarPedido`](CompuStoreDB/docs/usp_eliminarPedido.md) — elimina un pedido sin líneas registradas (`DELETE` físico, `Pedido` no tiene `Activo`)
- [`usp_actualizarPedido`](CompuStoreDB/docs/usp_actualizarPedido.md) — actualiza la fecha de un pedido

Todos se probaron manualmente en la instancia de AWS (casos de error y de éxito) antes de quedar documentados.

---

## Origen de los datos

- **`Categoria`/`Articulo`**: no existía ninguna base de datos previa del curso con artículos de cómputo. Los 51 artículos (nombre, marca, precio) se tomaron de material de asesoría personal (`Base de Datos II 2024/Sesión 2024-11-09`) y se adaptaron al modelo de CompuStore, separando marca del nombre y clasificándolos en 11 categorías.
- **`Cliente`**: los 25 primeros clientes reales de `AutoFixDB` (Base de Datos I, [`sesion-10`](../../../base-datos-1/sesiones/sesion-10/05-Ejercicio-2/instalacion/06-insert-cliente.sql)), agregando el campo `Sexo` que no existía en el origen.

## Constraints agregados

- `PRIMARY KEY` con `IDENTITY(1,1)` en todas las tablas.
- `FOREIGN KEY` nombradas (`fk_<Tabla>_<TablaReferenciada>`) en todas las relaciones.
- `UNIQUE` en `Categoria.Nombre`; `Articulo` (`Nombre`, `Marca`); `Cliente.Correo` y `Cliente.Telefono`; y en el par (`idArticulo`, `idCategoria`) de `ArticuloCategoria`, para no duplicar la misma relación.
- `CHECK` en precios y cantidades (`> 0`), en `Cliente.Sexo` (`IN ('M', 'F')`), y en `HistoricoPrecioArticulo` para que `PrecioNuevo` sea distinto de `PrecioAnterior` (no registrar un "cambio" que no cambió nada).
- `DEFAULT 1` en todos los `Activo`, y `DEFAULT GETDATE()` en los campos de auditoría.

---

## Refactor de nomenclatura: `sp_` → `usp_` en CineDB

Aprovechando esta sesión, se renombraron los 3 procedimientos almacenados de CineDB creados en las sesiones 3 y 4 (`sp_obtenerNombreCliente`, `sp_insertarPelicula`, `sp_eliminarPelicula`) al prefijo `usp_`, tanto en la instancia de AWS como en los scripts del repo (ver notas de nomenclatura en [sesión 3](../sesion-3/README.md) y [sesión 4](../sesion-4/README.md#nota-de-nomenclatura)).

`sp_` está reservado por SQL Server para procedimientos del sistema (siempre se busca primero en `master`); `usp_` es la convención definida en el [CLAUDE.md](../../../CLAUDE.md) del repo. En la instancia, cada procedimiento se recreó (`DROP` + `CREATE`) bajo el nuevo nombre con el mismo cuerpo, y se verificó que siguieran funcionando igual (`EXECUTE` de cada uno con datos válidos e inválidos).
