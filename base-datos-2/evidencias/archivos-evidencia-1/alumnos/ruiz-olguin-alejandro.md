# Ejercicio de Evidencia 1: `ufn_totalRecetasPorEstatus`

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)
**Objeto a crear:** Función escalar `ufn_totalRecetasPorEstatus`

## Contexto

Para saber, por ejemplo, "¿cuántas recetas siguen sin surtirse?" o "¿cuántas se cancelaron?", hoy hay que contar manualmente las filas de `Receta` filtrando por estatus. Tu función responde eso con una sola llamada, dado el id de cualquier estatus del catálogo `EstatusReceta`.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalRecetasPorEstatus` que reciba el id de un estatus y regrese cuántas recetas están actualmente en ese estatus.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idEstatusReceta` | `int` | Id del estatus a contar (`EstatusReceta.idEstatusReceta`) |

**Regresa:** `int` — el número de recetas cuyo `idEstatusReceta` actual coincide con el parámetro.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalRecetasPorEstatus` y recibe `@p_idEstatusReceta int`.
- [ ] Cuenta las filas de `Receta` donde `idEstatusReceta = @p_idEstatusReceta` (el estatus **actual**, no el historial de `BitacoraEstatusReceta`).
- [ ] Si ninguna receta está en ese estatus, regresa `0`, nunca `NULL`.
- [ ] Si el `idEstatusReceta` no existe en el catálogo, también regresa `0`.

## Ejemplo de salida esperada

Recordando el catálogo (`1 Creada`, `2 En atención`, `3 Surtida`, `4 Surtida parcialmente`, `5 Cancelada`):

| Llamada | Resultado esperado | Por qué |
|---|---|---|
| `SELECT dbo.ufn_totalRecetasPorEstatus(3)` | `4` | Las recetas 8, 9, 10 y 11 están en "Surtida" |
| `SELECT dbo.ufn_totalRecetasPorEstatus(1)` | `2` | Las recetas 1 y 2 están en "Creada" |
| `SELECT dbo.ufn_totalRecetasPorEstatus(5)` | `2` | Las recetas 3 y 15 están "Cancelada" |

## Casos de prueba sugeridos

```sql
SELECT dbo.ufn_totalRecetasPorEstatus(3) AS Total  -- esperado: 4
SELECT dbo.ufn_totalRecetasPorEstatus(2) AS Total  -- esperado: 5
SELECT dbo.ufn_totalRecetasPorEstatus(99) AS Total -- esperado: 0
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_RuizOlguinAlejandro_2253555.txt
```
