# Ejercicios de Evidencia 2

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)

---

## Ejercicio 1: `usp_insertarPaciente`

### Contexto

Antes de poder agendarle una consulta a alguien, esa persona tiene que existir en el catálogo `Paciente`. Tu procedimiento da de alta uno nuevo.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre(s) del paciente |
| `@p_PrimerApellido` | `varchar(50)` | Primer apellido |
| `@p_SegundoApellido` | `varchar(50)` | Segundo apellido |
| `@p_Sexo` | `char(1)` | `'M'` o `'F'` |
| `@p_Telefono` | `varchar(20)` | Teléfono |
| `@p_Correo` | `varchar(100)` | Correo |
| `@p_FechaNacimiento` | `date` | Fecha de nacimiento |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarPaciente` y recibe los 7 parámetros de arriba (todos obligatorios, ninguno acepta `NULL`).
- [ ] Valida que `@p_Sexo` sea `'M'` o `'F'`; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El sexo debe ser M o F'`, y termina con `RETURN` (esto reemplaza con un mensaje amigable lo que de otra forma sería un error crudo del `CHECK` de la tabla).
- [ ] Valida que `@p_Telefono` no esté ya registrado; si ya existe, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El teléfono ya está registrado'`, y termina con `RETURN`.
- [ ] Valida que `@p_Correo` no esté ya registrado; si ya existe, regresa `ErrCodigo = '000003'`, `ErrMensaje = 'El correo ya está registrado'`, y termina con `RETURN`.
- [ ] Si todas las validaciones pasan, inserta el nuevo paciente (`Activo` toma su valor por default, `1`).
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Inserción correcta'`.

### Ejemplo de salida esperada

`EXEC usp_insertarPaciente @p_Nombre = 'Ximena', @p_PrimerApellido = 'Torres', @p_SegundoApellido = 'Vega', @p_Sexo = 'F', @p_Telefono = '8100000099', @p_Correo = 'ximena.torres@gmail.com', @p_FechaNacimiento = '1995-05-20'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Inserción correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarPaciente @p_Nombre = 'Ximena', @p_PrimerApellido = 'Torres', @p_SegundoApellido = 'Vega',
     @p_Sexo = 'F', @p_Telefono = '8100000099', @p_Correo = 'ximena.torres@gmail.com', @p_FechaNacimiento = '1995-05-20'

-- Sexo inválido
EXEC usp_insertarPaciente @p_Nombre = 'Prueba', @p_PrimerApellido = 'Prueba', @p_SegundoApellido = 'Prueba',
     @p_Sexo = 'X', @p_Telefono = '8100000098', @p_Correo = 'prueba@gmail.com', @p_FechaNacimiento = '2000-01-01'

-- Teléfono duplicado (el del paciente 1)
EXEC usp_insertarPaciente @p_Nombre = 'Prueba', @p_PrimerApellido = 'Prueba', @p_SegundoApellido = 'Prueba',
     @p_Sexo = 'F', @p_Telefono = '8100000011', @p_Correo = 'prueba2@gmail.com', @p_FechaNacimiento = '2000-01-01'
```

---

## Ejercicio 2: `usp_eliminarPaciente`

### Contexto

Cuando un paciente deja de atenderse en el hospital, no se borra (su historial de consultas y recetas debe seguir intacto) — se da de baja lógica.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idPaciente` | `int` | Id del paciente a dar de baja |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarPaciente` y recibe `@p_idPaciente int`.
- [ ] Valida que el paciente exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El paciente no existe'`, y termina con `RETURN`.
- [ ] Si existe, actualiza `Activo = 0` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Eliminación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_eliminarPaciente @p_idPaciente = 15` (Roberto Silva Espinoza):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Eliminación correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_eliminarPaciente @p_idPaciente = 15
SELECT Activo FROM Paciente WHERE idPaciente = 15  -- esperado: 0

-- No existe
EXEC usp_eliminarPaciente @p_idPaciente = 9999
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_MontoyaMorenoAnaValeria_2254069_Ejercicio1.txt
EV2_MontoyaMorenoAnaValeria_2254069_Ejercicio2.txt
```
