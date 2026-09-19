# Ejercicio de Evidencia 1: `vw_DetalleRecetaCompleta`

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)
**Objeto a crear:** Vista `vw_DetalleRecetaCompleta`

## Contexto

Cuando un médico prescribe medicamentos en una receta, cada línea queda guardada en `DetalleReceta` — pero ahí solo se guarda el `idMedicamento`, no su nombre. Cualquiera que quiera leer una receta completa (el propio médico, farmacia, o un reporte) tiene que cruzar `DetalleReceta` con `Medicamento` para saber qué se prescribió realmente. Tu vista resuelve ese cruce de una vez por todas.

## Tu tarea

Crea una vista llamada exactamente `vw_DetalleRecetaCompleta` que una `DetalleReceta` con `Medicamento`, mostrando el nombre del medicamento en lugar de su id.

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_DetalleRecetaCompleta`.
- [ ] Muestra una columna `idDetalleReceta` (de `DetalleReceta`).
- [ ] Muestra una columna `idReceta` (de `DetalleReceta`).
- [ ] Muestra una columna `NombreMedicamento` con el valor de `Medicamento.Nombre` (no el id).
- [ ] Muestra las columnas `Cantidad` e `Indicaciones` (de `DetalleReceta`, tal cual).
- [ ] Une `DetalleReceta` con `Medicamento` por `idMedicamento`.
- [ ] Muestra **una fila por cada línea** de `DetalleReceta` que exista, sin excluir ninguna receta ni ningún estatus.

## Ejemplo de salida esperada

Con los datos ya instalados, `SELECT * FROM vw_DetalleRecetaCompleta` debe incluir filas como estas (no son las únicas, son solo un ejemplo para verificar):

| idDetalleReceta | idReceta | NombreMedicamento | Cantidad | Indicaciones |
|---|---|---|---|---|
| 1 | 4 | Paracetamol 500mg | 20 | Tomar 1 tableta cada 8 horas por 5 días |
| 2 | 4 | Ibuprofeno 400mg | 10 | Tomar 1 tableta cada 12 horas por 5 días |
| 3 | 5 | Amoxicilina 500mg | 21 | Tomar 1 cápsula cada 8 horas por 7 días |

## Casos de prueba sugeridos

```sql
-- Ver todas las líneas
SELECT * FROM vw_DetalleRecetaCompleta

-- Ver solo las líneas de una receta específica
SELECT *
FROM vw_DetalleRecetaCompleta
WHERE idReceta = 8
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_AguilarHernandezMarcosFernando_2254024.txt
```
