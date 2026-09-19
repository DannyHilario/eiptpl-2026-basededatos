# Ejercicios de Evidencia 2

**Alumno:** Aguilar Hernandez Marcos Fernando (matrícula 2254024)

---

## Ejercicio 1: `usp_obtenerRecetasPorPaciente`

### Contexto

Cuando un paciente vuelve al hospital, es útil ver de un vistazo todas las recetas que se le han generado a lo largo del tiempo y en qué estatus está cada una. Hoy eso implica cruzar `Receta`, `Consulta` y `EstatusReceta` a mano. Tu procedimiento responde esa pregunta con una sola llamada.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPaciente` | `int` | Id del paciente |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerRecetasPorPaciente` y recibe `@p_idPaciente int`.
- [ ] Valida que el paciente exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El paciente no existe'`, y termina con `RETURN`.
- [ ] Si el paciente existe, regresa (vía `SELECT`, no vía las variables de error) una fila por cada receta asociada a ese paciente (a través de sus consultas), con las columnas: `idReceta`, `NombreEstatus` (de `EstatusReceta.Nombre`), `FechaConsulta` (de `Consulta.Fecha`).
- [ ] Si el paciente existe pero no tiene ninguna receta, el `SELECT` regresa 0 filas (no es un error).
- [ ] No imprime ningún mensaje de éxito `000000` — al ser una consulta de solo lectura, el resultado del `SELECT` **es** la respuesta.

### Ejemplo de salida esperada

`EXEC usp_obtenerRecetasPorPaciente @p_idPaciente = 1` (Sergio Castro Ibarra, que tuvo las consultas 1 y 16):

| idReceta | NombreEstatus | FechaConsulta |
|---|---|---|
| 1 | Creada | 2026-09-01 09:00 |

*(la consulta 16 no aparece porque nunca se generó su receta — no fue efectuada)*

### Casos de prueba sugeridos

```sql
EXEC usp_obtenerRecetasPorPaciente @p_idPaciente = 1     -- 1 fila
EXEC usp_obtenerRecetasPorPaciente @p_idPaciente = 9999  -- error 000001
```

---

## Ejercicio 2: `usp_quitarMedicoEspecialidad`

### Contexto

Un médico puede tener asignadas varias especialidades (`MedicoEspecialidad`). Si se registró una asignación por error, o el médico deja de ejercer una especialidad, alguien necesita poder quitarla. Tu procedimiento hace exactamente eso.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico |
| `@p_idEspecialidad` | `int` | Id de la especialidad a quitar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_quitarMedicoEspecialidad` y recibe `@p_idMedico int`, `@p_idEspecialidad int`.
- [ ] Valida que exista esa relación específica en `MedicoEspecialidad` (ese `idMedico` con esa `idEspecialidad`); si no existe, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El médico no tiene asignada esa especialidad'`, y termina con `RETURN`.
- [ ] Si existe, elimina físicamente (`DELETE`) el renglón correspondiente de `MedicoEspecialidad`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Eliminación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_quitarMedicoEspecialidad @p_idMedico = 1, @p_idEspecialidad = 3` (el médico 1, Carlos García López, tiene Medicina General y Cardiología — esto le quita Cardiología):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Eliminación correcta |

Después de esto, `SELECT * FROM MedicoEspecialidad WHERE idMedico = 1` debe mostrar solo 1 fila (Medicina General).

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_quitarMedicoEspecialidad @p_idMedico = 1, @p_idEspecialidad = 3
SELECT * FROM MedicoEspecialidad WHERE idMedico = 1  -- debe quedar solo 1 fila

-- La relación no existe (el médico 2 nunca tuvo la especialidad 3)
EXEC usp_quitarMedicoEspecialidad @p_idMedico = 2, @p_idEspecialidad = 3
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_AguilarHernandezMarcosFernando_2254024_Ejercicio1.txt
EV2_AguilarHernandezMarcosFernando_2254024_Ejercicio2.txt
```
