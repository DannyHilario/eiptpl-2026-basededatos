# Ejercicio de Evidencia 1: `vw_RecetaVigente`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Vista `vw_RecetaVigente`

## Contexto

`Receta` guarda el estatus actual como un id (`idEstatusReceta`), y solo referencia la consulta por su id. Cualquiera que necesite revisar rápido "¿qué recetas hay, de quién son, y en qué estatus están?" tiene que cruzar tres tablas a mano. Tu vista deja ese reporte ya armado.

## Tu tarea

Crea una vista llamada exactamente `vw_RecetaVigente` que una `Receta` con `Consulta`, `Paciente` y `EstatusReceta`, mostrando el nombre del paciente y el nombre del estatus (no sus ids).

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_RecetaVigente`.
- [ ] Muestra `idReceta` (de `Receta`).
- [ ] Muestra `NombrePaciente`: nombre completo del paciente dueño de la receta (a través de `Receta.idConsulta → Consulta.idPaciente → Paciente`), concatenando `Nombre + ' ' + PrimerApellido + ' ' + SegundoApellido`.
- [ ] Muestra `NombreEstatus`: el valor de `EstatusReceta.Nombre` (el estatus **actual** de la receta, no su historial).
- [ ] Muestra `FechaConsulta`: el valor de `Consulta.Fecha` (la fecha de la consulta que generó la receta).
- [ ] Incluye **todas** las recetas, sin importar su estatus (Creada, En atención, Surtida, Surtida parcialmente o Cancelada).

## Ejemplo de salida esperada

| idReceta | NombrePaciente | NombreEstatus | FechaConsulta |
|---|---|---|---|
| 1 | Sergio Castro Ibarra | Creada | 2026-09-01 09:00 |
| 8 | Elena Lozano Guerrero | Surtida | 2026-09-04 13:00 |
| 12 | Monserrat Cruz Navarro | Surtida parcialmente | 2026-09-08 11:00 |
| 3 | Eduardo Vargas Lozano | Cancelada | 2026-09-02 09:00 |

## Casos de prueba sugeridos

```sql
-- Ver todas las recetas con su estatus legible
SELECT * FROM vw_RecetaVigente

-- Ver solo las recetas canceladas
SELECT *
FROM vw_RecetaVigente
WHERE NombreEstatus = 'Cancelada'
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_RodriguezMorenoRicardo_2254147.txt
```
