# Ejercicio de Evidencia 1: `vw_MedicoActivo`

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)
**Objeto a crear:** Vista `vw_MedicoActivo`

## Contexto

`Medico` usa baja lógica (`Activo BIT`): un médico dado de baja no se borra, solo se marca `Activo = 0`. Recepción necesita una lista rápida de los médicos que sí están disponibles hoy, sin tener que acordarse de agregar el filtro cada vez que hacen una consulta. Tu vista deja ese filtro ya resuelto.

## Tu tarea

Crea una vista llamada exactamente `vw_MedicoActivo` que muestre únicamente los médicos con `Activo = 1`.

## Criterios de aceptación

- [ ] La vista se llama exactamente `vw_MedicoActivo`.
- [ ] Muestra las columnas `idMedico`, `Nombre`, `PrimerApellido`, `SegundoApellido`, `Cedula`, `Telefono` y `Correo` (tal cual están en `Medico`, sin concatenar).
- [ ] Filtra únicamente los médicos donde `Activo = 1`.
- [ ] No incluye la columna `Activo` en el resultado (ya está implícita en el nombre de la vista).

## Ejemplo de salida esperada

Con los datos ya instalados (los 10 médicos nacen `Activo = 1`), la vista debe mostrar los 10 — aquí un ejemplo parcial:

| idMedico | Nombre | PrimerApellido | SegundoApellido | Cedula | Telefono | Correo |
|---|---|---|---|---|---|---|
| 1 | Carlos | García | López | 10234501 | 8112000001 | carlos.garcia@hospitaldb.com |
| 5 | Luis | Pérez | Morales | 10234505 | 8112000005 | luis.perez@hospitaldb.com |

Si das de baja a un médico de prueba (`UPDATE Medico SET Activo = 0 WHERE idMedico = 1`) y vuelves a consultar la vista, ese médico ya no debe aparecer.

## Casos de prueba sugeridos

```sql
-- Ver todos los médicos activos
SELECT * FROM vw_MedicoActivo

-- Probar que la baja lógica sí lo saca de la vista (no lo dejes así, solo es para probar)
UPDATE Medico SET Activo = 0 WHERE idMedico = 1
SELECT * FROM vw_MedicoActivo WHERE idMedico = 1  -- no debe regresar filas
UPDATE Medico SET Activo = 1 WHERE idMedico = 1   -- revierte el cambio de prueba
```

## Entregable

Ver [`descripcion-evidencia-1.md`](../descripcion-evidencia-1.md) para la forma de entrega completa. Tu archivo se llama:

```
EV1_HernandezMartinezAlexanderKalet_2212470.txt
```
