# Ejercicios de Evidencia 2

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)

---

## Ejercicio 1: `usp_eliminarDetalleReceta`

### Contexto

Si un medicamento se agregó por error a una receta, alguien necesita poder quitarlo. Pero igual que al agregar líneas, esto solo debe permitirse mientras la receta siga en un estatus donde todavía "se puede seguir editando" (`1 Creada` o `2 En atención`) — quitar una línea de una receta ya surtida no tendría sentido.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idDetalleReceta` | `int` | Id de la línea a eliminar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarDetalleReceta` y recibe `@p_idDetalleReceta int`.
- [ ] Valida que la línea exista (captura también su `idReceta`); si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La línea de receta no existe'`, y termina con `RETURN`.
- [ ] A partir del `idReceta` de esa línea, obtén el `idEstatusReceta` actual de la receta.
- [ ] Valida que el estatus de la receta sea `1` (Creada) o `2` (En atención); si está en `3`, `4` o `5`, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'No se pueden quitar medicamentos de una receta en este estatus'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, elimina físicamente (`DELETE`) el renglón de `DetalleReceta` (no hay baja lógica: `DetalleReceta` no tiene columna `Activo`).
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Eliminación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_eliminarDetalleReceta @p_idDetalleReceta = 3` (línea de la receta 5, que está en estatus `2 En atención`):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Eliminación correcta |

`EXEC usp_eliminarDetalleReceta @p_idDetalleReceta = 6` (línea de la receta 8, que está "Surtida") debe regresar el error `000002`.

### Casos de prueba sugeridos

```sql
-- Éxito: la línea 3 pertenece a la receta 5, en estatus 2 (En atención)
EXEC usp_eliminarDetalleReceta @p_idDetalleReceta = 3
SELECT * FROM DetalleReceta WHERE idDetalleReceta = 3  -- no debe regresar filas

-- No existe
EXEC usp_eliminarDetalleReceta @p_idDetalleReceta = 9999

-- La receta ya está surtida (línea 6 pertenece a la receta 8, estatus 3)
EXEC usp_eliminarDetalleReceta @p_idDetalleReceta = 6
```

---

## Ejercicio 2: `usp_asignarMedicoEspecialidad`

### Contexto

Cuando un médico se certifica en una especialidad nueva, hay que registrar esa relación en `MedicoEspecialidad` — sin permitir que la misma combinación médico-especialidad quede duplicada.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico |
| `@p_idEspecialidad` | `int` | Id de la especialidad a asignar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_asignarMedicoEspecialidad` y recibe `@p_idMedico int`, `@p_idEspecialidad int`.
- [ ] Valida que el médico exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El médico no existe'`, y termina con `RETURN`.
- [ ] Valida que la especialidad exista; si no, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'La especialidad no existe'`, y termina con `RETURN`.
- [ ] Valida que esa combinación médico-especialidad no exista ya; si ya existe, regresa `ErrCodigo = '000003'`, `ErrMensaje = 'El médico ya tiene asignada esa especialidad'`, y termina con `RETURN`.
- [ ] Si todas las validaciones pasan, inserta el nuevo renglón en `MedicoEspecialidad`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Asignación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_asignarMedicoEspecialidad @p_idMedico = 2, @p_idEspecialidad = 1` (Ana Hernández Ramírez, que solo tenía Pediatría, ahora también Medicina General):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Asignación correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_asignarMedicoEspecialidad @p_idMedico = 2, @p_idEspecialidad = 1
SELECT * FROM MedicoEspecialidad WHERE idMedico = 2  -- debe mostrar 2 filas ahora

-- Ya tiene esa especialidad (el médico 1 ya tiene Cardiología, idEspecialidad 3)
EXEC usp_asignarMedicoEspecialidad @p_idMedico = 1, @p_idEspecialidad = 3
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_RodriguezMorenoRicardo_2254147_Ejercicio1.txt
EV2_RodriguezMorenoRicardo_2254147_Ejercicio2.txt
```
