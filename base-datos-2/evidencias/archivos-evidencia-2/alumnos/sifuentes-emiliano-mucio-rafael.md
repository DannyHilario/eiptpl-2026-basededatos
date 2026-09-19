# Ejercicios de Evidencia 2

**Alumno:** Sifuentes Emiliano Mucio Rafael (matrícula 2212513)

---

## Ejercicio 1: `usp_actualizarDetalleReceta`

### Contexto

Si un médico se equivocó al capturar la cantidad o las indicaciones de una línea de receta, necesita poder corregirla. Igual que al agregar o quitar líneas, esto solo debe permitirse mientras la receta siga en un estatus editable (`1 Creada` o `2 En atención`).

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idDetalleReceta` | `int` | Id de la línea a actualizar |
| `@p_Cantidad` | `int` | Nueva cantidad |
| `@p_Indicaciones` | `varchar(200)` | Nuevas indicaciones |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_actualizarDetalleReceta` y recibe los 3 parámetros de arriba (todos obligatorios; nota: **no** recibe `idReceta` ni `idMedicamento` — esos no cambian aquí, solo cantidad e indicaciones).
- [ ] Valida que la línea exista (captura también su `idReceta`); si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La línea de receta no existe'`, y termina con `RETURN`.
- [ ] Valida que `@p_Cantidad` sea mayor a cero; si no, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'La cantidad debe ser mayor a cero'`, y termina con `RETURN`.
- [ ] A partir del `idReceta` de esa línea, obtén el `idEstatusReceta` actual de la receta, y valida que sea `1` (Creada) o `2` (En atención); si está en `3`, `4` o `5`, regresa `ErrCodigo = '000003'`, `ErrMensaje = 'No se pueden modificar medicamentos de una receta en este estatus'`, y termina con `RETURN`.
- [ ] Si todas las validaciones pasan, actualiza `Cantidad`, `Indicaciones` y `FechaUltimaModificacion = GETDATE()` en `DetalleReceta`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Actualización correcta'`.

### Ejemplo de salida esperada

`EXEC usp_actualizarDetalleReceta @p_idDetalleReceta = 3, @p_Cantidad = 25, @p_Indicaciones = 'Tomar 1 cápsula cada 12 horas por 10 días'` (línea de la receta 5, en estatus `2 En atención`):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Actualización correcta |

### Casos de prueba sugeridos

```sql
-- Éxito: la línea 3 pertenece a la receta 5, en estatus 2 (En atención)
EXEC usp_actualizarDetalleReceta @p_idDetalleReceta = 3, @p_Cantidad = 25, @p_Indicaciones = 'Tomar 1 cápsula cada 12 horas por 10 días'

-- Cantidad inválida
EXEC usp_actualizarDetalleReceta @p_idDetalleReceta = 3, @p_Cantidad = 0, @p_Indicaciones = 'Prueba'

-- La receta ya está surtida (línea 6 pertenece a la receta 8, estatus 3)
EXEC usp_actualizarDetalleReceta @p_idDetalleReceta = 6, @p_Cantidad = 10, @p_Indicaciones = 'Prueba'
```

---

## Ejercicio 2: `usp_obtenerEspecialidadesPorMedico`

### Contexto

Cuando alguien busca "¿qué médicos son cardiólogos?" o revisa el perfil de un médico, necesita ver todas sus especialidades juntas. Tu procedimiento arma esa lista para un médico específico.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerEspecialidadesPorMedico` y recibe `@p_idMedico int`.
- [ ] Valida que el médico exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El médico no existe'`, y termina con `RETURN`.
- [ ] Si el médico existe, regresa (vía `SELECT`) una fila por cada especialidad que tiene asignada, con las columnas `idEspecialidad` y `NombreEspecialidad` (de `Especialidad.Nombre`).
- [ ] Si el médico existe pero no tiene ninguna especialidad asignada, el `SELECT` regresa 0 filas (no es un error).
- [ ] No imprime ningún mensaje de éxito `000000` — el resultado del `SELECT` es la respuesta.

### Ejemplo de salida esperada

`EXEC usp_obtenerEspecialidadesPorMedico @p_idMedico = 1` (Carlos García López):

| idEspecialidad | NombreEspecialidad |
|---|---|
| 1 | Medicina General |
| 3 | Cardiología |

### Casos de prueba sugeridos

```sql
EXEC usp_obtenerEspecialidadesPorMedico @p_idMedico = 1     -- 2 filas
EXEC usp_obtenerEspecialidadesPorMedico @p_idMedico = 2     -- 1 fila
EXEC usp_obtenerEspecialidadesPorMedico @p_idMedico = 9999  -- error 000001
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_SifuentesEmilianoMucioRafael_2212513_Ejercicio1.txt
EV2_SifuentesEmilianoMucioRafael_2212513_Ejercicio2.txt
```
