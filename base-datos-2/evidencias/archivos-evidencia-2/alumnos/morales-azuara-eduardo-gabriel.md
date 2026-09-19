# Ejercicios de Evidencia 2

**Alumno:** Morales Azuara Eduardo Gabriel (matrícula 2254090)

---

## Ejercicio 1: `usp_habilitarPaciente`

### Contexto

Un paciente dado de baja puede volver a activarse si regresa al hospital. Tu procedimiento lo reactiva.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPaciente` | `int` | Id del paciente a reactivar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_habilitarPaciente` y recibe `@p_idPaciente int`.
- [ ] Valida que el paciente exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El paciente no existe'`, y termina con `RETURN`.
- [ ] Valida que el paciente **no** esté ya activo; si `Activo = 1`, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El paciente ya está activo'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, actualiza `Activo = 1` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Habilitación correcta'`.

### Ejemplo de salida esperada

Suponiendo que antes diste de baja al paciente 15: `EXEC usp_habilitarPaciente @p_idPaciente = 15`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Habilitación correcta |

### Casos de prueba sugeridos

```sql
-- Prepara el caso
UPDATE Paciente SET Activo = 0 WHERE idPaciente = 15

-- Éxito
EXEC usp_habilitarPaciente @p_idPaciente = 15
SELECT Activo FROM Paciente WHERE idPaciente = 15  -- esperado: 1

-- Ya está activo
EXEC usp_habilitarPaciente @p_idPaciente = 15

-- No existe
EXEC usp_habilitarPaciente @p_idPaciente = 9999
```

---

## Ejercicio 2: `usp_actualizarPaciente`

### Contexto

Los datos de contacto de un paciente pueden cambiar con el tiempo (teléfono, correo, incluso el nombre si hubo un error de captura). Tu procedimiento actualiza esos datos.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPaciente` | `int` | Id del paciente a actualizar |
| `@p_Nombre` | `varchar(50)` | Nombre(s) |
| `@p_PrimerApellido` | `varchar(50)` | Primer apellido |
| `@p_SegundoApellido` | `varchar(50)` | Segundo apellido |
| `@p_Telefono` | `varchar(20)` | Teléfono |
| `@p_Correo` | `varchar(100)` | Correo |
| `@p_FechaNacimiento` | `date` | Fecha de nacimiento |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarPaciente` y recibe los 7 parámetros de arriba (todos obligatorios; nota: **no** recibe `Sexo` — eso no se actualiza aquí).
- [ ] Valida que el paciente exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El paciente no existe'`, y termina con `RETURN`.
- [ ] Valida que `@p_Telefono` no esté registrado por **otro** paciente (`idPaciente <> @p_idPaciente`); si ya existe, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El teléfono ya está registrado'`, y termina con `RETURN`.
- [ ] Valida que `@p_Correo` no esté registrado por **otro** paciente, de la misma forma; si ya existe, regresa `ErrCodigo = '000003'`, `ErrMensaje = 'El correo ya está registrado'`, y termina con `RETURN`.
- [ ] Si todas las validaciones pasan, actualiza `Nombre`, `PrimerApellido`, `SegundoApellido`, `Telefono`, `Correo`, `FechaNacimiento` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Actualización correcta'`.

### Ejemplo de salida esperada

`EXEC usp_actualizarPaciente @p_idPaciente = 15, @p_Nombre = 'Roberto', @p_PrimerApellido = 'Silva', @p_SegundoApellido = 'Espinoza', @p_Telefono = '8100000099', @p_Correo = 'roberto.silva2@gmail.com', @p_FechaNacimiento = '2003-02-21'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Actualización correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_actualizarPaciente @p_idPaciente = 15, @p_Nombre = 'Roberto', @p_PrimerApellido = 'Silva',
     @p_SegundoApellido = 'Espinoza', @p_Telefono = '8100000099', @p_Correo = 'roberto.silva2@gmail.com',
     @p_FechaNacimiento = '2003-02-21'

-- El correo ya lo tiene otro paciente (el del paciente 1)
EXEC usp_actualizarPaciente @p_idPaciente = 15, @p_Nombre = 'Roberto', @p_PrimerApellido = 'Silva',
     @p_SegundoApellido = 'Espinoza', @p_Telefono = '8100000099', @p_Correo = 'sergio.castro@outlook.com',
     @p_FechaNacimiento = '2003-02-21'
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_MoralesAzuaraEduardoGabriel_2254090_Ejercicio1.txt
EV2_MoralesAzuaraEduardoGabriel_2254090_Ejercicio2.txt
```
