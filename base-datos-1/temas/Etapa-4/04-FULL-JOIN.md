# FULL JOIN

## ¿Qué es?

`FULL JOIN` (también se escribe `FULL OUTER JOIN`; son lo mismo) combina un `LEFT JOIN` y un `RIGHT JOIN`: devuelve **todas** las filas de **las dos** tablas.

- Si una fila tiene pareja en la otra tabla, aparecen juntas.
- Si una fila de la izquierda no tiene pareja, las columnas de la derecha salen en `NULL`.
- Si una fila de la derecha no tiene pareja, las columnas de la izquierda salen en `NULL`.

| Tipo | Devuelve |
|------|----------|
| `INNER JOIN` | Solo las filas **con** pareja en ambas tablas |
| `LEFT JOIN` | Todas las de la izquierda, con o sin pareja |
| `RIGHT JOIN` | Todas las de la derecha, con o sin pareja |
| `FULL JOIN` | **Todas** las de ambas tablas, con o sin pareja |

---

## Sintaxis

```sql
SELECT A.columna1, B.columna2
FROM TablaA AS A
FULL JOIN TablaB AS B ON A.idComun = B.idComun;
```

---

## Tablas de ejemplo

Las mismas que en el ejemplo de RIGHT JOIN (ver [LEFT JOIN y RIGHT JOIN](03-LEFT-RIGHT-JOIN.md)):

**Empleado**

| idEmpleado | NombreEmpleado | idDepartamento |
|------------|----------------|----------------|
| 1 | Ana | 1 |
| 2 | Pedro | 2 |
| 3 | Luis | NULL |

**Departamento**

| idDepartamento | Nombre |
|----------------|--------|
| 1 | Sistemas |
| 2 | Finanzas |
| 3 | Comercial |

Luis todavía no tiene departamento, y Comercial todavía no tiene empleados.

---

## Ejemplo 1 — Todos los empleados y todos los departamentos

```sql
SELECT E.NombreEmpleado, D.Nombre AS Departamento
FROM Empleado AS E
FULL JOIN Departamento AS D ON D.idDepartamento = E.idDepartamento;
```

| NombreEmpleado | Departamento |
|----------------|--------------|
| Ana | Sistemas |
| Pedro | Finanzas |
| Luis | NULL |
| NULL | Comercial |

Aparecen los cuatro casos a la vez:

- Ana y Pedro, con su departamento (lo que daría un `INNER JOIN`).
- Luis, sin departamento (lo que agrega el `LEFT JOIN`).
- Comercial, sin empleados (lo que agrega el `RIGHT JOIN`).

---

## Ejemplo 2 — Solo lo que no tiene pareja

Igual que con `LEFT JOIN`, se filtra con `IS NULL`. Aquí, en cualquiera de los dos lados:

```sql
SELECT E.NombreEmpleado, D.Nombre AS Departamento
FROM Empleado AS E
FULL JOIN Departamento AS D ON D.idDepartamento = E.idDepartamento
WHERE E.idEmpleado IS NULL OR D.idDepartamento IS NULL;
```

| NombreEmpleado | Departamento |
|----------------|--------------|
| Luis | NULL |
| NULL | Comercial |

Una sola consulta encuentra los dos problemas: empleados sin departamento y departamentos sin empleados.

---

## ¿Cuándo se usa?

Mucho menos que `INNER JOIN` y `LEFT JOIN`. Se usa cuando interesa ver **las dos listas completas** y detectar los huecos de ambos lados, por ejemplo para revisar que los datos estén completos.

> En un modelo bien diseñado, con llaves foráneas `NOT NULL`, una fila de la tabla hija **siempre** tiene pareja: no puede existir una cita sin paciente. Por eso, en esos modelos, `FULL JOIN` suele dar el mismo resultado que un `RIGHT JOIN` o un `LEFT JOIN`, según el orden de las tablas.

---

## Resumen

| Necesito… | Uso |
|-----------|-----|
| Solo lo que se relaciona | `INNER JOIN` |
| Todo lo de una tabla, con o sin relación | `LEFT JOIN` (o `RIGHT JOIN`) |
| Lo de una tabla que **no** se relaciona | `LEFT JOIN` + `WHERE … IS NULL` |
| Todo lo de las dos tablas | `FULL JOIN` |
| Lo que no se relaciona, en cualquiera de las dos | `FULL JOIN` + `WHERE … IS NULL OR … IS NULL` |
