# Ejercicios de Evidencia 2

**Alumno:** Mejia Garcia Ricardo Azael (matrícula 2253586)

---

## Ejercicio 1: `usp_actualizarConsulta`

### Contexto

Una consulta agendada a veces necesita reprogramarse: cambiar la fecha, el médico o el consultorio antes de que ocurra. Pero una consulta que **ya se efectuó** no se debe poder tocar (sería reescribir un hecho médico real), y el nuevo horario tiene que seguir respetando la regla de que ni el médico ni el consultorio pueden tener dos consultas encimadas.

> ⚠️ Presta atención especial al último criterio de aceptación — es la parte más fácil de hacer mal.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idConsulta` | `int` | Id de la consulta a reprogramar |
| `@p_idMedico` | `int` | Nuevo médico |
| `@p_idConsultorio` | `int` | Nuevo consultorio |
| `@p_Fecha` | `datetime` | Nueva fecha y hora |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarConsulta` y recibe los 4 parámetros de arriba.
- [ ] Valida que la consulta exista (captura también su `Efectuada` actual); si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La consulta no existe'`, y termina con `RETURN`.
- [ ] Valida que la consulta **no** esté efectuada; si `Efectuada = 1`, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'No se puede reprogramar una consulta que ya fue efectuada'`, y termina con `RETURN`.
- [ ] Valida que el médico nuevo exista; si no, regresa `ErrCodigo = '000003'`, `ErrMensaje = 'El médico no existe'`, y termina con `RETURN`.
- [ ] Valida que el consultorio nuevo exista; si no, regresa `ErrCodigo = '000004'`, `ErrMensaje = 'El consultorio no existe'`, y termina con `RETURN`.
- [ ] Valida el traslape de horario igual que [`usp_insertarConsulta`](../../../sesiones/sesion-7/HospitalDB/docs/procedimientos/usp_insertarConsulta.md) (mismo médico o consultorio, ventana de 30 minutos), **pero excluyendo la propia consulta que se está actualizando** de esa comparación (agrega `AND idConsulta <> @p_idConsulta` al `WHERE` del chequeo de traslape). Si no la excluyes, la consulta siempre "chocará contra sí misma" y el `UPDATE` nunca podrá completarse, ni siquiera para un cambio menor. Si hay traslape (contra otra consulta que no sea ella misma), regresa `ErrCodigo = '000005'`, `ErrMensaje = 'El médico o el consultorio ya tienen una consulta agendada en ese horario'`, y termina con `RETURN`.
- [ ] Si todas las validaciones pasan, actualiza `idMedico`, `idConsultorio`, `Fecha` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Actualización correcta'`.

### Ejemplo de salida esperada

`EXEC usp_actualizarConsulta @p_idConsulta = 17, @p_idMedico = 7, @p_idConsultorio = 7, @p_Fecha = '2026-10-01T10:00:00'` (la consulta 17 no está efectuada; solo le cambiamos la hora, mismo médico/consultorio, sin chocar con nada más):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Actualización correcta |

### Casos de prueba sugeridos

```sql
-- Éxito: reprogramar la consulta 17 a otra hora, sin chocar con nada
EXEC usp_actualizarConsulta @p_idConsulta = 17, @p_idMedico = 7, @p_idConsultorio = 7, @p_Fecha = '2026-10-01T10:00:00'

-- Éxito: actualizar la consulta 17 dejando exactamente los mismos datos que ya tenía
-- (esto es justo la prueba que revela si excluiste bien la propia consulta del chequeo de traslape)
EXEC usp_actualizarConsulta @p_idConsulta = 17, @p_idMedico = 7, @p_idConsultorio = 7, @p_Fecha = '2026-10-01T09:00:00'

-- La consulta ya fue efectuada, no se debe poder reprogramar
EXEC usp_actualizarConsulta @p_idConsulta = 1, @p_idMedico = 2, @p_idConsultorio = 2, @p_Fecha = '2026-11-01T09:00:00'

-- Traslape real contra OTRA consulta (mueve la 17 a la misma hora exacta que la 1, con el mismo médico)
EXEC usp_actualizarConsulta @p_idConsulta = 17, @p_idMedico = 1, @p_idConsultorio = 1, @p_Fecha = '2026-09-01T09:00:00'
```

---

## Ejercicio 2: `usp_obtenerConsultasPorPaciente`

### Contexto

Cuando un paciente llega, es útil ver su historial completo de consultas: cuándo, con qué médico, en qué consultorio. Tu procedimiento arma ese historial.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPaciente` | `int` | Id del paciente |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerConsultasPorPaciente` y recibe `@p_idPaciente int`.
- [ ] Valida que el paciente exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El paciente no existe'`, y termina con `RETURN`.
- [ ] Si el paciente existe, regresa (vía `SELECT`) una fila por cada consulta de ese paciente, con las columnas: `idConsulta`, `Fecha`, `Efectuada`, `NombreMedico` (nombre completo), `NombreConsultorio`.
- [ ] Incluye **todas** las consultas del paciente, sin importar el valor de `Efectuada`.
- [ ] No imprime ningún mensaje de éxito `000000` — el resultado del `SELECT` es la respuesta.

### Ejemplo de salida esperada

`EXEC usp_obtenerConsultasPorPaciente @p_idPaciente = 1` (Sergio Castro Ibarra tuvo la consulta 1 y la 16):

| idConsulta | Fecha | Efectuada | NombreMedico | NombreConsultorio |
|---|---|---|---|---|
| 1 | 2026-09-01 09:00 | 1 | Carlos García López | Consultorio 1 |
| 16 | 2026-09-11 09:00 | 0 | Sofía Sánchez Vega | Consultorio 6 |

### Casos de prueba sugeridos

```sql
EXEC usp_obtenerConsultasPorPaciente @p_idPaciente = 1     -- 2 filas
EXEC usp_obtenerConsultasPorPaciente @p_idPaciente = 9999  -- error 000001
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_MejiaGarciaRicardoAzael_2253586_Ejercicio1.txt
EV2_MejiaGarciaRicardoAzael_2253586_Ejercicio2.txt
```
