# Modelo Entidad-Relación y cardinalidad

## ¿Qué es?

El **modelo Entidad-Relación** (E-R), creado por Peter Chen en los años setenta, es una forma de **dibujar el diseño conceptual**: qué "cosas" hay en el negocio, qué datos tienen y cómo se relacionan. Se hace **antes** de pensar en tablas y columnas.

Sus elementos son tres: **entidades**, **atributos** y **relaciones**.

---

## Entidad

Es un objeto del mundo real sobre el que se quiere guardar información: un cliente, un producto, una sucursal. Se dibuja con un **rectángulo**.

| Tipo | Qué es | Ejemplo |
|------|--------|---------|
| **Entidad fuerte** | Existe por sí misma | `Cliente`: un cliente existe aunque no haya hecho pedidos |
| **Entidad débil** | Su existencia depende de otra | `DetallePedido`: no hay renglón de pedido sin pedido |

```
┌──────────┐        ╔══════════════════╗
│ CLIENTE  │        ║┌────────────────┐║
└──────────┘        ║│ DETALLEPEDIDO  │║
                    ║└────────────────┘║
 entidad fuerte     ╚══════════════════╝
                       entidad débil
                     (rectángulo doble)
```

---

## Atributo

Es una característica de la entidad que interesa guardar: el nombre o el teléfono de un cliente. Se dibuja con un **óvalo** unido a su entidad.

```
     (Nombre)    (Teléfono)
          \         /
         ┌───────────┐
         │  CLIENTE  │
         └───────────┘
```

Los atributos se convierten después en las **columnas** de la tabla.

---

## Relación

Es la asociación entre dos entidades. Se dibuja con un **rombo** y lleva un verbo que describe qué hace una entidad con la otra.

```
┌──────────┐          ╱╲           ┌──────────┐
│ CLIENTE  │─────────╱hace╲────────│  PEDIDO  │
└──────────┘         ╲    ╱        └──────────┘
                      ╲╱
```

---

## Cardinalidad

La **cardinalidad** dice **cuántos** registros de una entidad se relacionan con cuántos de la otra. Hay tres tipos.

### Uno a uno (1:1)

Cada registro de A se relaciona con **uno solo** de B, y viceversa.

> Un empleado tiene un solo gafete, y cada gafete es de un solo empleado.

Es la menos común. Muchas veces significa que las dos entidades podrían ser una sola tabla.

### Uno a muchos (1:N)

Un registro de A se relaciona con **muchos** de B, pero cada registro de B pertenece a **uno solo** de A.

> Una sucursal tiene muchos clientes; cada cliente se registra en una sola sucursal.

Es la más común. Se resuelve con una **llave foránea en el lado "muchos"**: `Cliente` guarda `idSucursal`.

### Muchos a muchos (N:M)

Un registro de A se relaciona con **muchos** de B, y uno de B con **muchos** de A.

> Un cliente compra muchos productos; un producto lo compran muchos clientes.

No se puede resolver con una sola llave foránea. Se necesita una **tabla intermedia** con una llave foránea hacia cada lado. Muchas veces esa tabla intermedia **es la operación del negocio**: la venta, la renta, la consulta, el pedido.

```
CLIENTE ──1────N── VENTA ──N────1── PRODUCTO
                (tabla intermedia:
                 idCliente, idProducto,
                 fecha, cantidad…)
```

---

## Cómo descubrir la cardinalidad

Haz la pregunta **en los dos sentidos**:

| Pregunta | Respuesta |
|----------|-----------|
| ¿Una sucursal puede tener **varios** clientes? | Sí |
| ¿Un cliente puede estar en **varias** sucursales? | No (regla del negocio: se registra en una sola) |
| **Cardinalidad** | **1:N** → la llave foránea va en `Cliente` |

| Pregunta | Respuesta |
|----------|-----------|
| ¿Un cliente puede comprar **varios** productos? | Sí |
| ¿Un producto lo pueden comprar **varios** clientes? | Sí |
| **Cardinalidad** | **N:M** → se necesita una tabla intermedia |

> La respuesta no la decides tú: la dicen las **reglas del negocio**. Por eso hay que leerlas con cuidado.

---

## Del diagrama E-R a las tablas

| Elemento E-R | Se convierte en |
|--------------|-----------------|
| Entidad | Una tabla |
| Atributo | Una columna |
| Relación 1:N | Una llave foránea en la tabla del lado "muchos" |
| Relación N:M | Una tabla intermedia con dos llaves foráneas |
| Relación 1:1 | Una llave foránea con `UNIQUE`, o una sola tabla |

El resultado es el **modelo relacional**, que es el siguiente tema: [El modelo relacional](06-ModeloRelacional.md).
