# Ejercicio de Evidencia 1: `ufn_estatusVigenteReceta`

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)
**Objeto a crear:** Función escalar `ufn_estatusVigenteReceta`

## Contexto

`Receta.idEstatusReceta` guarda el estatus actual, pero como un id — no es útil para mostrarlo directo en un reporte o mensaje. Tu función traduce ese id al nombre legible del estatus (`EstatusReceta.Nombre`) con una sola llamada.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_estatusVigenteReceta` que reciba el id de una receta y regrese el nombre de su estatus actual.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idReceta` | `int` | Id de la receta |

**Regresa:** `varchar(30)` — el nombre del estatus actual de esa receta.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_estatusVigenteReceta` y recibe `@p_idReceta int`.
- [ ] Busca el `idEstatusReceta` **actual** de la receta (en `Receta`, no en `BitacoraEstatusReceta`) y regresa el `Nombre` correspondiente de `EstatusReceta`.
- [ ] Si la receta no existe, regresa `NULL` (no genera error).

## Ejemplo de salida esperada

| Llamada | Resultado esperado |
|---|---|
| `SELECT dbo.ufn_estatusVigenteReceta(8)` | `'Surtida'` |
| `SELECT dbo.ufn_estatusVigenteReceta(12)` | `'Surtida parcialmente'` |
| `SELECT dbo.ufn_estatusVigenteReceta(3)` | `'Cancelada'` |
| `SELECT dbo.ufn_estatusVigenteReceta(9999)` | `NULL` |

## Casos de prueba sugeridos

```sql
SELECT dbo.ufn_estatusVigenteReceta(1)  AS Estatus  -- esperado: 'Creada'
SELECT dbo.ufn_estatusVigenteReceta(8)  AS Estatus  -- esperado: 'Surtida'
SELECT dbo.ufn_estatusVigenteReceta(12) AS Estatus  -- esperado: 'Surtida parcialmente'
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_VazquezAnayaJohannAdad_2253497.txt
```
