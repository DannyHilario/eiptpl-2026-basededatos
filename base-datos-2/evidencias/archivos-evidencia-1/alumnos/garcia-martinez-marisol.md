# Ejercicio de Evidencia 1: `ufn_totalLineasReceta`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Función escalar `ufn_totalLineasReceta`

## Contexto

Cuando alguien en farmacia revisa una receta, una de las primeras preguntas es "¿cuántos medicamentos trae?". Hoy la única forma de saberlo es contar manualmente las filas de `DetalleReceta` para esa receta. Tu función escalar responde esa pregunta con una sola llamada.

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalLineasReceta` que reciba el id de una receta y regrese cuántas líneas tiene en `DetalleReceta`.

## Firma de la función

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idReceta` | `int` | Id de la receta a contar |

**Regresa:** `int` — el número de líneas de `DetalleReceta` de esa receta.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalLineasReceta` y recibe `@p_idReceta int`.
- [ ] Cuenta las filas de `DetalleReceta` donde `idReceta = @p_idReceta`.
- [ ] Si la receta no tiene ninguna línea, regresa **`0`**, nunca `NULL` (recuerda: `COUNT(*)` siempre regresa un número, incluso sobre cero filas — úsalo así y no tendrás este problema).
- [ ] Si el `idReceta` no existe en absoluto, también regresa `0` (no genera error).

## Ejemplo de salida esperada

Con los datos ya instalados:

| Llamada | Resultado esperado | Por qué |
|---|---|---|
| `SELECT dbo.ufn_totalLineasReceta(4)` | `2` | La receta 4 tiene 2 líneas (Paracetamol, Ibuprofeno) |
| `SELECT dbo.ufn_totalLineasReceta(1)` | `0` | La receta 1 está en estatus "Creada" y todavía no tiene ninguna línea cargada |
| `SELECT dbo.ufn_totalLineasReceta(9999)` | `0` | No existe ninguna receta con ese id |

## Casos de prueba sugeridos

```sql
SELECT dbo.ufn_totalLineasReceta(4)  AS TotalLineas  -- esperado: 2
SELECT dbo.ufn_totalLineasReceta(1)  AS TotalLineas  -- esperado: 0
SELECT dbo.ufn_totalLineasReceta(11) AS TotalLineas  -- esperado: 2
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_GarciaMartinezMarisol_2253587.txt
```
