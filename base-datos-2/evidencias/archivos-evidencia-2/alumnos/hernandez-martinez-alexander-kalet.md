# Ejercicios de Evidencia 2

**Alumno:** Hernandez Martínez Alexander Kalet (matrícula 2212470)

---

## Ejercicio 1: `usp_habilitarEspecialidad`

### Contexto

Una especialidad dada de baja (`Activo = 0`) puede volver a ofrecerse más adelante. Tu procedimiento la reactiva.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idEspecialidad` | `int` | Id de la especialidad a reactivar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_habilitarEspecialidad` y recibe `@p_idEspecialidad int`.
- [ ] Valida que la especialidad exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La especialidad no existe'`, y termina con `RETURN`.
- [ ] Valida que la especialidad **no** esté ya activa; si `Activo = 1`, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'La especialidad ya está activa'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, actualiza `Activo = 1` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Habilitación correcta'`.

### Ejemplo de salida esperada

Suponiendo que antes diste de baja la especialidad 9 (Psiquiatría): `EXEC usp_habilitarEspecialidad @p_idEspecialidad = 9`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Habilitación correcta |

### Casos de prueba sugeridos

```sql
-- Prepara el caso: da de baja una especialidad de prueba
UPDATE Especialidad SET Activo = 0 WHERE idEspecialidad = 9

-- Éxito
EXEC usp_habilitarEspecialidad @p_idEspecialidad = 9
SELECT Activo FROM Especialidad WHERE idEspecialidad = 9  -- esperado: 1

-- Ya está activa
EXEC usp_habilitarEspecialidad @p_idEspecialidad = 9

-- No existe
EXEC usp_habilitarEspecialidad @p_idEspecialidad = 9999
```

---

## Ejercicio 2: `usp_actualizarEspecialidad`

### Contexto

Si una especialidad se capturó con el nombre mal escrito, alguien necesita poder corregirlo sin duplicar el catálogo.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idEspecialidad` | `int` | Id de la especialidad a actualizar |
| `@p_Nombre` | `varchar(50)` | Nuevo nombre |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarEspecialidad` y recibe `@p_idEspecialidad int`, `@p_Nombre varchar(50)`.
- [ ] Valida que la especialidad exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La especialidad no existe'`, y termina con `RETURN`.
- [ ] Valida que `@p_Nombre` no esté ya registrado por **otra** especialidad (comparando `idEspecialidad <> @p_idEspecialidad`); si ya está usado, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El nombre ya está registrado por otra especialidad'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, actualiza `Nombre = @p_Nombre` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Actualización correcta'`.

### Ejemplo de salida esperada

`EXEC usp_actualizarEspecialidad @p_idEspecialidad = 9, @p_Nombre = 'Psiquiatría Infantil'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Actualización correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_actualizarEspecialidad @p_idEspecialidad = 9, @p_Nombre = 'Psiquiatría Infantil'

-- El nombre ya lo tiene otra especialidad
EXEC usp_actualizarEspecialidad @p_idEspecialidad = 9, @p_Nombre = 'Pediatría'

-- No existe
EXEC usp_actualizarEspecialidad @p_idEspecialidad = 9999, @p_Nombre = 'Lo que sea'
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_HernandezMartinezAlexanderKalet_2212470_Ejercicio1.txt
EV2_HernandezMartinezAlexanderKalet_2212470_Ejercicio2.txt
```
