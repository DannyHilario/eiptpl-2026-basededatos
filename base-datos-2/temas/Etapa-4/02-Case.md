# CASE

`CASE` elige un **valor** según una condición, **dentro de una consulta**. Es el "si… entonces…" de SQL: mientras `IF` decide qué instrucciones se ejecutan, `CASE` decide qué valor aparece en una columna, en un orden o en un grupo.

Los ejemplos usan **TiendaDB** con los [datos de ejemplo](README.md#base-de-datos-de-los-ejemplos) de la Etapa 4.

---

## Las dos formas

**CASE buscado:** cada `WHEN` lleva su propia condición. Es la forma más usada.

```sql
CASE
    WHEN condición1 THEN valor1
    WHEN condición2 THEN valor2
    ELSE valorPorOmisión
END
```

**CASE simple:** compara **una** expresión contra una lista de valores. Sirve cuando todas las condiciones son "es igual a".

```sql
CASE expresión
    WHEN valor1 THEN resultado1
    WHEN valor2 THEN resultado2
    ELSE resultadoPorOmisión
END
```

Reglas:

- Las condiciones se revisan **en orden** y gana la **primera** que se cumple.
- Sin `ELSE`, si ninguna se cumple, el resultado es `NULL`.
- Siempre termina con `END`.

---

## CASE en SELECT

Clasificar los artículos de Abarrotes por rango de precio:

```sql
SELECT idArticulo, Nombre, PrecioUnitario,
       CASE
           WHEN PrecioUnitario < 20 THEN 'Económico'
           WHEN PrecioUnitario < 40 THEN 'Medio'
           ELSE 'Alto'
       END AS RangoPrecio
FROM Articulo
WHERE idClasificacion = 6
```

| idArticulo | Nombre | PrecioUnitario | RangoPrecio |
|------------|--------|----------------|-------------|
| 26 | Sopa instantánea en vaso 64 g | 27.00 | Medio |
| 27 | Atún en agua 130 g | 13.00 | Económico |
| 28 | Arroz 900 g | 15.00 | Económico |
| 29 | Frijoles refritos 430 g | 12.50 | Económico |
| 30 | Café capuchino en sobre 20 g | 12.00 | Económico |

La sopa ($27.00) no cumple `< 20`, pero sí `< 40`: queda en Medio. No hace falta escribir `PrecioUnitario >= 20 AND PrecioUnitario < 40`, porque si llegó al segundo `WHEN`, el primero ya no se cumplió.

### Sin ELSE

```sql
SELECT idArticulo,
       CASE WHEN PrecioUnitario < 20 THEN 'Económico' END AS SinElse
FROM Articulo
WHERE idArticulo IN (1, 29)
```

| idArticulo | SinElse |
|------------|---------|
| 1 | NULL |
| 29 | Económico |

El refresco (artículo 1, $23.00) no cumple ninguna condición y no hay `ELSE`: queda en `NULL`.

---

## CASE con ORDER BY

`ORDER BY idEstatusPedido` ordena por número: Creado (1), Enviado (2), Cancelado (3) y Entregado (4). Pero en el negocio el orden natural es el del flujo: Creado, Enviado, Entregado y, al final, Cancelado. `CASE` le asigna a cada estatus su posición:

```sql
SELECT idPedido, idEstatusPedido,
       CASE idEstatusPedido
           WHEN 1 THEN 'Creado'
           WHEN 2 THEN 'Enviado'
           WHEN 3 THEN 'Cancelado'
           WHEN 4 THEN 'Entregado'
       END AS Estatus,
       Total
FROM Pedido
ORDER BY CASE idEstatusPedido
             WHEN 1 THEN 1
             WHEN 2 THEN 2
             WHEN 4 THEN 3
             WHEN 3 THEN 4
         END,
         idPedido
```

| idPedido | idEstatusPedido | Estatus | Total |
|----------|-----------------|---------|-------|
| 5 | 1 | Creado | 320.00 |
| 6 | 1 | Creado | 126.50 |
| 8 | 1 | Creado | 0.00 |
| 3 | 2 | Enviado | 98.50 |
| 1 | 4 | Entregado | 246.00 |
| 2 | 4 | Entregado | 199.00 |
| 7 | 4 | Entregado | 244.50 |
| 4 | 3 | Cancelado | 300.00 |

El `CASE` de la columna `Estatus` es la forma simple: traduce el número a su nombre. En una consulta real se haría con un `JOIN` a `EstatusPedido`; aquí sirve para ver las dos formas de `CASE` juntas.

---

## CASE con GROUP BY

¿Cuántos artículos hay en cada rango de precio? Se agrupa **por el `CASE`**:

```sql
SELECT CASE
           WHEN PrecioUnitario < 20 THEN 'Económico'
           WHEN PrecioUnitario < 40 THEN 'Medio'
           ELSE 'Alto'
       END AS RangoPrecio,
       COUNT(idArticulo) AS Articulos
FROM Articulo
GROUP BY CASE
             WHEN PrecioUnitario < 20 THEN 'Económico'
             WHEN PrecioUnitario < 40 THEN 'Medio'
             ELSE 'Alto'
         END
```

| RangoPrecio | Articulos |
|-------------|-----------|
| Alto | 9 |
| Económico | 10 |
| Medio | 21 |

El `CASE` se repite **completo** en el `GROUP BY`. No se puede escribir `GROUP BY RangoPrecio`: como se explica en [Cláusulas SQL](../Etapa-1/01-Clausulas.md#el-orden-en-que-sql-server-las-procesa), `GROUP BY` se procesa antes que `SELECT` y todavía no conoce el alias.

---

## UPDATE con CASE

Regla de la tienda: **los pedidos de $300 o más tienen envío gratis**, los demás pagan $35. Un solo `UPDATE` pone el costo correcto a cada pedido abierto:

```sql
UPDATE Pedido
SET CostoEnvio = CASE
                     WHEN Total >= 300 THEN 0
                     ELSE 35
                 END
WHERE idEstatusPedido = 1
```

| idPedido | Total | CostoEnvio |
|----------|-------|------------|
| 5 | 320.00 | 0.00 |
| 6 | 126.50 | 35.00 |
| 8 | 0.00 | 35.00 |

Sin `CASE` harían falta dos `UPDATE`, uno por cada caso, con el riesgo de que se ejecute uno y el otro no.

---

## INSERT con CASE

El pedido 8 está vacío. Se le agregan tres artículos en un solo `INSERT … SELECT`: de las bebidas se piden 6 piezas, y de lo demás, una.

```sql
INSERT INTO DetallePedido (idPedido, idArticulo, Cantidad, PrecioUnitario)
SELECT 8, idArticulo,
       CASE
           WHEN idClasificacion = 1 THEN 6
           ELSE 1
       END,
       PrecioUnitario
FROM Articulo
WHERE idArticulo IN (3, 13, 27)
```

| idArticulo | Cantidad | PrecioUnitario |
|------------|----------|----------------|
| 3 | 6 | 22.00 |
| 13 | 1 | 27.00 |
| 27 | 1 | 13.00 |

El agua mineral (artículo 3) es una bebida: lleva 6. Los triggers de `DetallePedido` recalculan la cabecera: el pedido 8 queda con 3 líneas y $172.00.

---

## Resumen

- `CASE` elige un **valor** dentro de una consulta; `IF` decide qué **instrucciones** se ejecutan.
- **Buscado:** `CASE WHEN condición THEN valor … END`. **Simple:** `CASE expresión WHEN valor THEN resultado … END`.
- Gana el primer `WHEN` que se cumple; sin `ELSE`, el resultado es `NULL`.
- Se usa en `SELECT`, en `ORDER BY` (para un orden propio), en `GROUP BY` (repitiendo el `CASE` completo), en `UPDATE` y en `INSERT … SELECT`.
