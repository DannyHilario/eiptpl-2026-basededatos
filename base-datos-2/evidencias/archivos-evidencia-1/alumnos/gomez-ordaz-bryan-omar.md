# Ejercicio de Evidencia 1: `vw_MedicoEspecialidadCompleta`

**Alumno:** Gomez Ordaz Bryan Omar (matrícula 2254247)
**Objeto a crear:** Vista `vw_MedicoEspecialidadCompleta`

## Contexto

Un médico puede tener más de una especialidad (por eso existe la tabla puente `MedicoEspecialidad`, relación N:M). Para saber "¿qué especialidades tiene el Dr. García?" hoy hay que cruzar tres tablas a mano. Tu vista deja ese cruce ya resuelto.

## Tu tarea

Crea una vista llamada exactamente `vw_MedicoEspecialidadCompleta` que una `Medico`, `MedicoEspecialidad` y `Especialidad`, mostrando el nombre del médico junto con el nombre de cada especialidad que tiene.

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_MedicoEspecialidadCompleta`.
- [ ] Muestra `idMedico` (de `Medico`).
- [ ] Muestra `NombreMedico`: nombre completo del médico (`Nombre + ' ' + PrimerApellido + ' ' + SegundoApellido`).
- [ ] Muestra `NombreEspecialidad`: el valor de `Especialidad.Nombre`.
- [ ] Une las tres tablas a través de `MedicoEspecialidad` (que conecta `idMedico` con `idEspecialidad`).
- [ ] Si un médico tiene 2 especialidades, aparece en **2 filas** (una por cada especialidad) — no se deduplica ni se concatena en una sola fila.

## Ejemplo de salida esperada

| idMedico | NombreMedico | NombreEspecialidad |
|---|---|---|
| 1 | Carlos García López | Medicina General |
| 1 | Carlos García López | Cardiología |
| 5 | Luis Pérez Morales | Ginecología |
| 5 | Luis Pérez Morales | Endocrinología |
| 2 | Ana Hernández Ramírez | Pediatría |

## Casos de prueba sugeridos

```sql
-- Ver todas las relaciones médico-especialidad
SELECT * FROM vw_MedicoEspecialidadCompleta

-- Ver solo las especialidades de un médico con más de una
SELECT *
FROM vw_MedicoEspecialidadCompleta
WHERE idMedico = 1
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_GomezOrdazBryanOmar_2254247.txt
```
