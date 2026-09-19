# Ejercicio de Evidencia 1: `vw_PacienteActivo`

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)
**Objeto a crear:** Vista `vw_PacienteActivo`

## Contexto

`Paciente` usa baja lógica (`Activo BIT`): un paciente dado de baja no se borra, solo se marca `Activo = 0`. Recepción necesita una lista rápida de los pacientes que siguen activos en el sistema, sin tener que acordarse de agregar el filtro cada vez. Tu vista deja ese filtro ya resuelto.

## Tu tarea

Crea una vista llamada exactamente `vw_PacienteActivo` que muestre únicamente los pacientes con `Activo = 1`.

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_PacienteActivo`.
- [ ] Muestra las columnas `idPaciente`, `Nombre`, `PrimerApellido`, `SegundoApellido`, `Sexo`, `Telefono`, `Correo` y `FechaNacimiento` (tal cual están en `Paciente`, sin concatenar).
- [ ] Filtra únicamente los pacientes donde `Activo = 1`.
- [ ] No incluye la columna `Activo` en el resultado (ya está implícita en el nombre de la vista).

## Ejemplo de salida esperada

Con los datos ya instalados (los 15 pacientes nacen `Activo = 1`), la vista debe mostrar los 15 — aquí un ejemplo parcial:

| idPaciente | Nombre | PrimerApellido | SegundoApellido | Sexo | Telefono | Correo | FechaNacimiento |
|---|---|---|---|---|---|---|---|
| 1 | Sergio | Castro | Ibarra | M | 8100000011 | sergio.castro@outlook.com | 1978-04-12 |
| 5 | Daniel | Aguilar | Mendoza | M | 8100000015 | daniel.aguilar@outlook.com | 2001-09-30 |

Si das de baja a un paciente de prueba (`UPDATE Paciente SET Activo = 0 WHERE idPaciente = 1`) y vuelves a consultar la vista, ese paciente ya no debe aparecer.

## Casos de prueba sugeridos

```sql
-- Ver todos los pacientes activos
SELECT * FROM vw_PacienteActivo

-- Probar que la baja lógica sí lo saca de la vista (no lo dejes así, solo es para probar)
UPDATE Paciente SET Activo = 0 WHERE idPaciente = 1
SELECT * FROM vw_PacienteActivo WHERE idPaciente = 1  -- no debe regresar filas
UPDATE Paciente SET Activo = 1 WHERE idPaciente = 1   -- revierte el cambio de prueba
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_PerezMoralesJohanValente_2254047.txt
```
