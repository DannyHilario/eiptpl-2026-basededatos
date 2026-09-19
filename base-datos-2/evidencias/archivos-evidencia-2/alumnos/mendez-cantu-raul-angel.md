# Ejercicios de Evidencia 2

**Alumno:** Mendez Cantu Raúl Ángel (matrícula 2212484)

---

## Ejercicio 1: `usp_habilitarMedico`

### Contexto

Un médico dado de baja puede volver a estar disponible (regresa de una licencia, por ejemplo). Tu procedimiento lo reactiva.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico a reactivar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_habilitarMedico` y recibe `@p_idMedico int`.
- [ ] Valida que el médico exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El médico no existe'`, y termina con `RETURN`.
- [ ] Valida que el médico **no** esté ya activo; si `Activo = 1`, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El médico ya está activo'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, actualiza `Activo = 1` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Habilitación correcta'`.

### Ejemplo de salida esperada

Suponiendo que antes diste de baja al médico 10: `EXEC usp_habilitarMedico @p_idMedico = 10`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Habilitación correcta |

### Casos de prueba sugeridos

```sql
-- Prepara el caso
UPDATE Medico SET Activo = 0 WHERE idMedico = 10

-- Éxito
EXEC usp_habilitarMedico @p_idMedico = 10
SELECT Activo FROM Medico WHERE idMedico = 10  -- esperado: 1

-- Ya está activo
EXEC usp_habilitarMedico @p_idMedico = 10

-- No existe
EXEC usp_habilitarMedico @p_idMedico = 9999
```

---

## Ejercicio 2: `usp_actualizarMedico`

### Contexto

Los datos de contacto de un médico (nombre, apellidos, teléfono, correo) pueden cambiar. Su cédula profesional, no — esa se mantiene fija como identificador permanente y no se actualiza aquí.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico a actualizar |
| `@p_Nombre` | `varchar(50)` | Nombre(s) |
| `@p_PrimerApellido` | `varchar(50)` | Primer apellido |
| `@p_SegundoApellido` | `varchar(50)` | Segundo apellido (puede ser `NULL`) |
| `@p_Telefono` | `varchar(20)` | Teléfono (puede ser `NULL`) |
| `@p_Correo` | `varchar(100)` | Correo (puede ser `NULL`) |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarMedico` y recibe los 6 parámetros de arriba (nota: **no** recibe `Cedula` — esa no se actualiza).
- [ ] Valida que el médico exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El médico no existe'`, y termina con `RETURN`.
- [ ] Si `@p_Telefono` **no es `NULL`**, valida que no esté registrado por **otro** médico (`idMedico <> @p_idMedico`); si ya existe, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El teléfono ya está registrado'`, y termina con `RETURN`.
- [ ] Si `@p_Correo` **no es `NULL`**, valida de la misma forma; si ya existe, regresa `ErrCodigo = '000003'`, `ErrMensaje = 'El correo ya está registrado'`, y termina con `RETURN`.
- [ ] Si todas las validaciones pasan, actualiza `Nombre`, `PrimerApellido`, `SegundoApellido`, `Telefono`, `Correo` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Actualización correcta'`.

### Ejemplo de salida esperada

`EXEC usp_actualizarMedico @p_idMedico = 10, @p_Nombre = 'Mariana', @p_PrimerApellido = 'Delgado', @p_SegundoApellido = 'Ortiz', @p_Telefono = '8112000099', @p_Correo = 'mariana.delgado2@hospitaldb.com'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Actualización correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_actualizarMedico @p_idMedico = 10, @p_Nombre = 'Mariana', @p_PrimerApellido = 'Delgado',
     @p_SegundoApellido = 'Ortiz', @p_Telefono = '8112000099', @p_Correo = 'mariana.delgado2@hospitaldb.com'

-- El teléfono ya lo tiene otro médico (el 1)
EXEC usp_actualizarMedico @p_idMedico = 10, @p_Nombre = 'Mariana', @p_PrimerApellido = 'Delgado',
     @p_SegundoApellido = 'Ortiz', @p_Telefono = '8112000001', @p_Correo = NULL
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_MendezCantuRaulAngel_2212484_Ejercicio1.txt
EV2_MendezCantuRaulAngel_2212484_Ejercicio2.txt
```
