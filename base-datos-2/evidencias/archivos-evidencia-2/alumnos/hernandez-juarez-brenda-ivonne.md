# Ejercicios de Evidencia 2

**Alumno:** Hernandez Juarez Brenda Ivonne (matrícula 2253945)

---

## Ejercicio 1: `usp_insertarEspecialidad`

### Contexto

`Especialidad` es un catálogo simple (Medicina General, Pediatría, etc.). Antes de poder asignarle una especialidad a un médico, esa especialidad tiene que existir en el catálogo. Tu procedimiento da de alta una especialidad nueva.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre de la especialidad |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarEspecialidad` y recibe `@p_Nombre varchar(50)`.
- [ ] Valida que no exista ya una especialidad con ese mismo `Nombre`; si ya existe, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La especialidad ya está registrada'`, y termina con `RETURN`.
- [ ] Si no existe, inserta el nuevo renglón en `Especialidad` (`Activo` toma su valor por default, `1`).
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Inserción correcta'`.

### Ejemplo de salida esperada

`EXEC usp_insertarEspecialidad @p_Nombre = 'Neurología'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Inserción correcta |

`EXEC usp_insertarEspecialidad @p_Nombre = 'Pediatría'` (ya existe en el catálogo semilla) debe regresar el error `000001`.

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarEspecialidad @p_Nombre = 'Neurología'
SELECT * FROM Especialidad WHERE Nombre = 'Neurología'

-- Ya está registrada
EXEC usp_insertarEspecialidad @p_Nombre = 'Pediatría'
```

---

## Ejercicio 2: `usp_eliminarEspecialidad`

### Contexto

Cuando una especialidad deja de ofrecerse, no se borra físicamente (otros médicos podrían seguir referenciándola en `MedicoEspecialidad`) — se da de baja lógica, como el resto de los catálogos del curso.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idEspecialidad` | `int` | Id de la especialidad a dar de baja |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarEspecialidad` y recibe `@p_idEspecialidad int`.
- [ ] Valida que la especialidad exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La especialidad no existe'`, y termina con `RETURN`.
- [ ] Si existe, actualiza `Activo = 0` y `FechaUltimaModificacion = GETDATE()` (no hace un `DELETE` físico).
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Eliminación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_eliminarEspecialidad @p_idEspecialidad = 9` (Psiquiatría):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Eliminación correcta |

Después de esto, `SELECT Activo FROM Especialidad WHERE idEspecialidad = 9` debe regresar `0`.

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_eliminarEspecialidad @p_idEspecialidad = 9
SELECT Activo FROM Especialidad WHERE idEspecialidad = 9  -- esperado: 0

-- No existe
EXEC usp_eliminarEspecialidad @p_idEspecialidad = 9999
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_HernandezJuarezBrendaIvonne_2253945_Ejercicio1.txt
EV2_HernandezJuarezBrendaIvonne_2253945_Ejercicio2.txt
```
