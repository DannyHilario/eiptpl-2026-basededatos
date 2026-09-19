# Ejercicios de Evidencia 2

**Alumno:** Ruiz Olguin Alejandro (matrícula 2253555)

---

## Ejercicio 1: `usp_habilitarConsultorio`

### Contexto

Un consultorio dado de baja puede volver a ponerse en servicio. Tu procedimiento lo reactiva.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idConsultorio` | `int` | Id del consultorio a reactivar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_habilitarConsultorio` y recibe `@p_idConsultorio int`.
- [ ] Valida que el consultorio exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El consultorio no existe'`, y termina con `RETURN`.
- [ ] Valida que el consultorio **no** esté ya activo; si `Activo = 1`, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El consultorio ya está activo'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, actualiza `Activo = 1` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Habilitación correcta'`.

### Ejemplo de salida esperada

Suponiendo que antes diste de baja el consultorio 10: `EXEC usp_habilitarConsultorio @p_idConsultorio = 10`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Habilitación correcta |

### Casos de prueba sugeridos

```sql
-- Prepara el caso
UPDATE Consultorio SET Activo = 0 WHERE idConsultorio = 10

-- Éxito
EXEC usp_habilitarConsultorio @p_idConsultorio = 10
SELECT Activo FROM Consultorio WHERE idConsultorio = 10  -- esperado: 1

-- Ya está activo
EXEC usp_habilitarConsultorio @p_idConsultorio = 10

-- No existe
EXEC usp_habilitarConsultorio @p_idConsultorio = 9999
```

---

## Ejercicio 2: `usp_actualizarConsultorio`

### Contexto

Si un consultorio se renombra (cambia de número o de piso), alguien necesita poder corregir su nombre sin duplicar el catálogo.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idConsultorio` | `int` | Id del consultorio a actualizar |
| `@p_Nombre` | `varchar(50)` | Nuevo nombre |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarConsultorio` y recibe `@p_idConsultorio int`, `@p_Nombre varchar(50)`.
- [ ] Valida que el consultorio exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El consultorio no existe'`, y termina con `RETURN`.
- [ ] Valida que `@p_Nombre` no esté ya registrado por **otro** consultorio (`idConsultorio <> @p_idConsultorio`); si ya está usado, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El nombre ya está registrado por otro consultorio'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, actualiza `Nombre = @p_Nombre` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Actualización correcta'`.

### Ejemplo de salida esperada

`EXEC usp_actualizarConsultorio @p_idConsultorio = 10, @p_Nombre = 'Consultorio 10-A'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Actualización correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_actualizarConsultorio @p_idConsultorio = 10, @p_Nombre = 'Consultorio 10-A'

-- El nombre ya lo tiene otro consultorio
EXEC usp_actualizarConsultorio @p_idConsultorio = 10, @p_Nombre = 'Consultorio 1'

-- No existe
EXEC usp_actualizarConsultorio @p_idConsultorio = 9999, @p_Nombre = 'Lo que sea'
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_RuizOlguinAlejandro_2253555_Ejercicio1.txt
EV2_RuizOlguinAlejandro_2253555_Ejercicio2.txt
```
