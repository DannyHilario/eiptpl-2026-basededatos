# Normalización

## ¿Qué es?

La **normalización** es un conjunto de reglas para organizar los datos en tablas de modo que **no se repita información** y no aparezcan datos contradictorios. Se aplica en el diseño lógico, antes de crear las tablas.

Una base de datos se normaliza para:

- Evitar la **redundancia** (datos repetidos).
- Evitar **problemas al insertar, modificar y borrar** datos.
- Proteger la **integridad** de los datos.

---

## El problema: redundancia y anomalías

Una empresa guarda a sus empleados y el departamento al que pertenecen en **una sola tabla**:

| idEmpleado | Nombre | Puesto | Departamento | TelDepto | Encargado |
|------------|--------|--------|--------------|----------|-----------|
| 1 | Claudia | Administrativo | Ingeniería | 23456789 | Catalina |
| 2 | Marco | Ingeniero | Recursos Humanos | 34789045 | Gina |
| 3 | Antonio | Administrativo | Construcción | 12568934 | César |
| 4 | Yahir | Administrativo | Construcción | 12568934 | César |

El teléfono y el encargado de **Construcción** se repiten en cada empleado de ese departamento. Esa redundancia provoca tres **anomalías**:

| Anomalía | Qué pasa en el ejemplo |
|----------|------------------------|
| **De inserción** | No se puede registrar un departamento nuevo hasta que tenga al menos un empleado. Y nada impide escribir a un nuevo empleado de Construcción con **otro** teléfono. |
| **De modificación** | Si Construcción cambia de teléfono, hay que cambiarlo en **todas** sus filas. Si se olvida una, la tabla dice dos teléfonos distintos para el mismo departamento. |
| **De eliminación** | Si Marco se va y se borra su fila, se pierde **todo** lo que se sabía de Recursos Humanos. |

La solución es separar: una tabla `Empleado` y una tabla `Departamento`, unidas por una llave foránea.

---

## Dependencia funcional

Es la idea en la que se basan las formas normales.

> Un campo **B depende funcionalmente** de un campo **A** si, conociendo A, siempre se conoce B.

- Conociendo `idEmpleado`, se conoce el `Nombre` → `Nombre` depende de `idEmpleado`.
- Conociendo `Departamento`, se conoce `TelDepto` → `TelDepto` depende de `Departamento`, **no** del empleado.

Ese segundo caso es el que delata que `TelDepto` está en la tabla equivocada.

---

## Las formas normales

Cada forma normal incluye a la anterior: una tabla en 3FN también está en 2FN y en 1FN. Edgar F. Codd definió las tres primeras, que son las del curso.

```
┌──────────────────────────────┐
│ 3FN: nada depende de un      │
│      campo que no es llave   │
│  ┌────────────────────────┐  │
│  │ 2FN: todo depende de   │  │
│  │      TODA la llave     │  │
│  │  ┌──────────────────┐  │  │
│  │  │ 1FN: sin grupos  │  │  │
│  │  │      repetidos   │  │  │
│  │  └──────────────────┘  │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

Para verlas en acción, normalicemos paso a paso los pedidos de **TecnoShop**, una tienda de artículos de cómputo.

### Forma normal cero (sin normalizar)

TecnoShop anota cada pedido en una hoja de cálculo. Un pedido puede traer varios productos:

| NumPedido | Fecha | idCliente | NombreCliente | Telefono | Productos (clave, nombre, precio, cantidad) |
|-----------|-------|-----------|---------------|----------|---------------------------------------------|
| 101 | 2026-03-02 | 7 | Rosa Leal | 8111111111 | P1 Mouse $250 ×2; P2 Teclado $480 ×1 |
| 102 | 2026-03-05 | 9 | Iván Soto | 8122222222 | P1 Mouse $250 ×1 |
| 103 | 2026-03-09 | 7 | Rosa Leal | 8111111111 | P3 Monitor $3,200 ×1 |

La celda de productos tiene **varios valores** a la vez. No se puede buscar ni filtrar bien, y no se sabe cuántas columnas reservar para productos.

### Primera Forma Normal (1FN)

> **Regla:** cada celda guarda **un solo valor**, sin grupos repetidos. Cada grupo de datos relacionados va en su propia tabla, con su llave primaria.

Los productos de cada pedido pasan a una tabla aparte, una fila por producto:

**Pedido**

| NumPedido (PK) | Fecha | idCliente | NombreCliente | Telefono |
|----------------|-------|-----------|---------------|----------|
| 101 | 2026-03-02 | 7 | Rosa Leal | 8111111111 |
| 102 | 2026-03-05 | 9 | Iván Soto | 8122222222 |
| 103 | 2026-03-09 | 7 | Rosa Leal | 8111111111 |

**DetallePedido**

| NumPedido (PK) | ClaveProducto (PK) | NombreProducto | Precio | Cantidad |
|----------------|--------------------|----------------|--------|----------|
| 101 | P1 | Mouse | 250 | 2 |
| 101 | P2 | Teclado | 480 | 1 |
| 102 | P1 | Mouse | 250 | 1 |
| 103 | P3 | Monitor | 3200 | 1 |

La llave de `DetallePedido` es **compuesta**: `(NumPedido, ClaveProducto)`.

### Segunda Forma Normal (2FN)

> **Regla:** está en 1FN y cada campo que no es llave depende de **toda** la llave primaria, no solo de una parte.

Solo puede fallar en tablas con llave compuesta. En `DetallePedido`:

- `Cantidad` depende de **toda** la llave: cuántos mouses lleva **ese** pedido. ✔
- `NombreProducto` depende **solo** de `ClaveProducto`: P1 es "Mouse" en cualquier pedido. ✘

`NombreProducto` se va a su propia tabla:

**Producto**

| ClaveProducto (PK) | NombreProducto | PrecioActual |
|--------------------|----------------|--------------|
| P1 | Mouse | 250 |
| P2 | Teclado | 480 |
| P3 | Monitor | 3200 |

**DetallePedido**

| NumPedido (PK) | ClaveProducto (PK) | PrecioUnitario | Cantidad |
|----------------|--------------------|----------------|----------|
| 101 | P1 | 250 | 2 |
| 101 | P2 | 480 | 1 |
| 102 | P1 | 250 | 1 |
| 103 | P3 | 3200 | 1 |

> **¿Y el precio?** Parecería que el precio también depende solo del producto. Pero hay **dos precios distintos**: el precio **actual** del producto (`Producto.PrecioActual`, que cambia cuando la tienda sube precios) y el precio **con el que se vendió** en ese pedido (`DetallePedido.PrecioUnitario`, que nunca debe cambiar). El segundo sí depende de toda la llave: es el precio de **ese** producto en **ese** pedido. Ver *Datos que cambian con el tiempo* en [Del negocio al modelo](07-DelNegocioAlModelo.md).

### Tercera Forma Normal (3FN)

> **Regla:** está en 2FN y ningún campo que no es llave depende de **otro campo que tampoco es llave**.

En `Pedido`:

- `Fecha` depende de `NumPedido`. ✔
- `NombreCliente` y `Telefono` dependen de `idCliente`, que **no** es la llave de `Pedido`. ✘

Por eso Rosa Leal aparece repetida. Los datos del cliente se van a su propia tabla:

**Cliente**

| idCliente (PK) | NombreCliente | Telefono |
|----------------|---------------|----------|
| 7 | Rosa Leal | 8111111111 |
| 9 | Iván Soto | 8122222222 |

**Pedido**

| NumPedido (PK) | Fecha | idCliente (FK) |
|----------------|-------|----------------|
| 101 | 2026-03-02 | 7 |
| 102 | 2026-03-05 | 9 |
| 103 | 2026-03-09 | 7 |

### Resultado

| Tabla | Llave primaria | Llaves foráneas |
|-------|----------------|-----------------|
| `Cliente` | `idCliente` | — |
| `Producto` | `ClaveProducto` | — |
| `Pedido` | `NumPedido` | `idCliente` → `Cliente` |
| `DetallePedido` | `(NumPedido, ClaveProducto)` | `NumPedido` → `Pedido`; `ClaveProducto` → `Producto` |

Cada dato vive ahora en un solo lugar: si Rosa cambia de teléfono, se corrige en **una** fila.

---

## Cómo normalizar, en tres preguntas

| Forma | Pregunta | Si la respuesta es "sí" |
|-------|----------|-------------------------|
| 1FN | ¿Hay celdas con varios valores, o columnas que se repiten (`Producto1`, `Producto2`…)? | Pasa esos datos a otra tabla, una fila por valor |
| 2FN | En una tabla con llave compuesta, ¿algún campo depende solo de **una parte** de la llave? | Pasa ese campo a la tabla de esa parte |
| 3FN | ¿Algún campo depende de otro campo que **no** es la llave? | Pasa esos campos a su propia tabla |
