# Ejercicios de Evidencia 2

**Alumno:** Villanueva Mata Brandon Gabriel (matrícula 2253572)

---

## Ejercicio 1: `usp_habilitarMedicamento`

### Contexto

Un medicamento dado de baja puede volver a estar disponible (vuelve a fabricarse, por ejemplo). Tu procedimiento lo reactiva.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedicamento` | `int` | Id del medicamento a reactivar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_habilitarMedicamento` y recibe `@p_idMedicamento int`.
- [ ] Valida que el medicamento exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El medicamento no existe'`, y termina con `RETURN`.
- [ ] Valida que el medicamento **no** esté ya activo; si `Activo = 1`, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El medicamento ya está activo'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, actualiza `Activo = 1` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Habilitación correcta'`.

### Ejemplo de salida esperada

Suponiendo que antes diste de baja el medicamento 15: `EXEC usp_habilitarMedicamento @p_idMedicamento = 15`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Habilitación correcta |

### Casos de prueba sugeridos

```sql
-- Prepara el caso
UPDATE Medicamento SET Activo = 0 WHERE idMedicamento = 15

-- Éxito
EXEC usp_habilitarMedicamento @p_idMedicamento = 15
SELECT Activo FROM Medicamento WHERE idMedicamento = 15  -- esperado: 1

-- Ya está activo
EXEC usp_habilitarMedicamento @p_idMedicamento = 15

-- No existe
EXEC usp_habilitarMedicamento @p_idMedicamento = 9999
```

---

## Ejercicio 2: `usp_actualizarMedicamento`

### Contexto

Si un medicamento se capturó con el nombre o la marca mal escritos, alguien necesita poder corregirlo sin que choque con otro medicamento ya registrado con esa misma combinación.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedicamento` | `int` | Id del medicamento a actualizar |
| `@p_Nombre` | `varchar(100)` | Nuevo nombre |
| `@p_Marca` | `varchar(50)` | Nueva marca |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarMedicamento` y recibe `@p_idMedicamento int`, `@p_Nombre varchar(100)`, `@p_Marca varchar(50)`.
- [ ] Valida que el medicamento exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El medicamento no existe'`, y termina con `RETURN`.
- [ ] Valida que la combinación `@p_Nombre` + `@p_Marca` no esté ya registrada por **otro** medicamento (`idMedicamento <> @p_idMedicamento`); si ya está usada, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'Ya existe un medicamento registrado con ese nombre y marca'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, actualiza `Nombre`, `Marca` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Actualización correcta'`.

### Ejemplo de salida esperada

`EXEC usp_actualizarMedicamento @p_idMedicamento = 15, @p_Nombre = 'Clotrimazol Crema 1%', @p_Marca = 'Canesten'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Actualización correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_actualizarMedicamento @p_idMedicamento = 15, @p_Nombre = 'Clotrimazol Crema 1%', @p_Marca = 'Canesten'

-- Esa combinación Nombre+Marca ya la tiene otro medicamento
EXEC usp_actualizarMedicamento @p_idMedicamento = 15, @p_Nombre = 'Paracetamol 500mg', @p_Marca = 'Tempra'

-- No existe
EXEC usp_actualizarMedicamento @p_idMedicamento = 9999, @p_Nombre = 'Lo que sea', @p_Marca = 'Lo que sea'
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_VillanuevaMataBrandonGabriel_2253572_Ejercicio1.txt
EV2_VillanuevaMataBrandonGabriel_2253572_Ejercicio2.txt
```
