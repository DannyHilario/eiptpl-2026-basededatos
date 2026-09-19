# Ejercicios de Evidencia 2

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)

---

## Ejercicio 1: `usp_insertarMedico`

### Contexto

Antes de poder asignarle consultas o especialidades a un médico, tiene que existir en el catálogo `Medico`. Tu procedimiento da de alta uno nuevo, cuidando que no se dupliquen los datos que deben ser únicos: cédula profesional, teléfono y correo.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre(s) del médico |
| `@p_PrimerApellido` | `varchar(50)` | Primer apellido |
| `@p_SegundoApellido` | `varchar(50)` | Segundo apellido (puede ser `NULL`) |
| `@p_Cedula` | `varchar(20)` | Cédula profesional |
| `@p_Telefono` | `varchar(20)` | Teléfono (puede ser `NULL`) |
| `@p_Correo` | `varchar(100)` | Correo (puede ser `NULL`) |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarMedico` y recibe los 6 parámetros de arriba.
- [ ] Valida que `@p_Cedula` no esté ya registrada; si ya existe, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La cédula ya está registrada'`, y termina con `RETURN`.
- [ ] Si `@p_Telefono` **no es `NULL`**, valida que no esté ya registrado por otro médico; si ya existe, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El teléfono ya está registrado'`, y termina con `RETURN`. Si `@p_Telefono` es `NULL`, esta validación se omite (`UNIQUE` en SQL Server permite varios `NULL`).
- [ ] Si `@p_Correo` **no es `NULL`**, valida de la misma forma; si ya existe, regresa `ErrCodigo = '000003'`, `ErrMensaje = 'El correo ya está registrado'`, y termina con `RETURN`.
- [ ] Si todas las validaciones pasan, inserta el nuevo médico (`Activo` toma su valor por default, `1`).
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Inserción correcta'`.

### Ejemplo de salida esperada

`EXEC usp_insertarMedico @p_Nombre = 'Fernando', @p_PrimerApellido = 'Salazar', @p_SegundoApellido = 'Nava', @p_Cedula = '10234511', @p_Telefono = '8112000011', @p_Correo = 'fernando.salazar@hospitaldb.com'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Inserción correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarMedico @p_Nombre = 'Fernando', @p_PrimerApellido = 'Salazar', @p_SegundoApellido = 'Nava',
     @p_Cedula = '10234511', @p_Telefono = '8112000011', @p_Correo = 'fernando.salazar@hospitaldb.com'

-- Cédula duplicada (la del médico 1)
EXEC usp_insertarMedico @p_Nombre = 'Prueba', @p_PrimerApellido = 'Prueba', @p_SegundoApellido = NULL,
     @p_Cedula = '10234501', @p_Telefono = '8112009999', @p_Correo = 'prueba@hospitaldb.com'
```

---

## Ejercicio 2: `usp_eliminarMedico`

### Contexto

Cuando un médico deja el hospital, no se borra (sus consultas y especialidades históricas deben seguir intactas) — se da de baja lógica.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico a dar de baja |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarMedico` y recibe `@p_idMedico int`.
- [ ] Valida que el médico exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El médico no existe'`, y termina con `RETURN`.
- [ ] Si existe, actualiza `Activo = 0` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Eliminación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_eliminarMedico @p_idMedico = 10` (Mariana Delgado Ortiz):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Eliminación correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_eliminarMedico @p_idMedico = 10
SELECT Activo FROM Medico WHERE idMedico = 10  -- esperado: 0

-- No existe
EXEC usp_eliminarMedico @p_idMedico = 9999
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_HernandezPerezJoseIvan_2253557_Ejercicio1.txt
EV2_HernandezPerezJoseIvan_2253557_Ejercicio2.txt
```
