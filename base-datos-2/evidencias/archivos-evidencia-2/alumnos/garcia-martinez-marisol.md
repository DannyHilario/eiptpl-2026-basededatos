# Ejercicios de Evidencia 2

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)

---

## Ejercicio 1: `usp_insertarDetalleReceta`

### Contexto

Cuando un médico prescribe un medicamento, esa línea se guarda en `DetalleReceta`. Pero no cualquier receta puede seguir ganando líneas: una vez que ya se surtió (total o parcialmente) o se canceló, ya no tiene sentido seguir agregando medicamentos. Además, la primera vez que una receta recién creada (`1 Creada`) recibe una línea, eso significa que ya se le está empezando a atender, así que su estatus debe pasar automáticamente a `2 En atención`.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idReceta` | `int` | Id de la receta |
| `@p_idMedicamento` | `int` | Id del medicamento a prescribir |
| `@p_Cantidad` | `int` | Cantidad prescrita |
| `@p_Indicaciones` | `varchar(200)` | Dosis/frecuencia |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarDetalleReceta` y recibe los 4 parámetros de arriba (todos obligatorios).
- [ ] Valida que la receta exista (captura también su `idEstatusReceta` actual); si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La receta no existe'`, y termina con `RETURN`.
- [ ] Valida que el medicamento exista; si no, regresa `ErrCodigo = '000002'`, `ErrMensaje = 'El medicamento no existe'`, y termina con `RETURN`.
- [ ] Valida que `@p_Cantidad` sea mayor a cero; si no, regresa `ErrCodigo = '000003'`, `ErrMensaje = 'La cantidad debe ser mayor a cero'`, y termina con `RETURN`.
- [ ] Valida que el estatus actual de la receta sea `1` (Creada) o `2` (En atención); si está en `3`, `4` o `5`, regresa `ErrCodigo = '000004'`, `ErrMensaje = 'No se pueden agregar medicamentos a una receta en este estatus'`, y termina con `RETURN`.
- [ ] Si todas las validaciones pasan, inserta la línea en `DetalleReceta`.
- [ ] **Side effect:** si el estatus de la receta **antes de esta operación** era `1` (Creada), invoca `EXEC usp_cambiarEstatusReceta @p_idReceta = @p_idReceta, @p_idEstatusNuevo = 2` para pasarla a `2 En atención`. Si ya estaba en `2`, **no** invoques nada — se queda en `2`.
- [ ] `usp_cambiarEstatusReceta` ya existe en la base instalada — no lo crees tú, solo invócalo.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Inserción correcta'`.

### Ejemplo de salida esperada

`EXEC usp_insertarDetalleReceta @p_idReceta = 1, @p_idMedicamento = 1, @p_Cantidad = 10, @p_Indicaciones = 'Tomar 1 tableta cada 8 horas'` — la receta 1 está en estatus `1 Creada`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Inserción correcta |

Después de esto, `SELECT idEstatusReceta FROM Receta WHERE idReceta = 1` debe regresar `2` (pasó de Creada a En atención automáticamente), y `SELECT * FROM BitacoraEstatusReceta WHERE idReceta = 1` debe mostrar la transición registrada.

### Casos de prueba sugeridos

```sql
-- Éxito con side effect: receta 1 está en estatus 1, debe pasar a 2
EXEC usp_insertarDetalleReceta @p_idReceta = 1, @p_idMedicamento = 1, @p_Cantidad = 10, @p_Indicaciones = 'Tomar 1 tableta cada 8 horas'
SELECT idEstatusReceta FROM Receta WHERE idReceta = 1  -- esperado: 2

-- Éxito sin side effect: receta 4 ya está en estatus 2, debe quedarse en 2
EXEC usp_insertarDetalleReceta @p_idReceta = 4, @p_idMedicamento = 3, @p_Cantidad = 5, @p_Indicaciones = 'Tomar 1 cápsula al día'
SELECT idEstatusReceta FROM Receta WHERE idReceta = 4  -- esperado: 2 (sin cambio)

-- Receta ya surtida, no debe dejar agregar
EXEC usp_insertarDetalleReceta @p_idReceta = 8, @p_idMedicamento = 1, @p_Cantidad = 5, @p_Indicaciones = 'Prueba'
```

---

## Ejercicio 2: `usp_obtenerDetalleReceta`

### Contexto

Cuando alguien necesita ver una receta completa (el médico, farmacia, o el propio paciente), necesita el encabezado (a quién pertenece, en qué estatus está) junto con todas sus líneas de medicamento en una sola consulta.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idReceta` | `int` | Id de la receta a consultar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerDetalleReceta` y recibe `@p_idReceta int`.
- [ ] Valida que la receta exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La receta no existe'`, y termina con `RETURN`.
- [ ] Si la receta existe, regresa (vía `SELECT`) una fila por cada línea de `DetalleReceta` de esa receta, con las columnas: `idReceta`, `NombreEstatus` (de `EstatusReceta.Nombre`), `idDetalleReceta`, `NombreMedicamento` (de `Medicamento.Nombre`), `Cantidad`.
- [ ] Si la receta existe pero todavía no tiene ninguna línea, el `SELECT` regresa 0 filas (no es un error).
- [ ] No imprime ningún mensaje de éxito `000000` — el resultado del `SELECT` es la respuesta.

### Ejemplo de salida esperada

`EXEC usp_obtenerDetalleReceta @p_idReceta = 8` (en estatus "Surtida", con 2 líneas):

| idReceta | NombreEstatus | idDetalleReceta | NombreMedicamento | Cantidad |
|---|---|---|---|---|
| 8 | Surtida | 6 | Metformina 850mg | 60 |
| 8 | Surtida | 7 | Losartán 50mg | 30 |

### Casos de prueba sugeridos

```sql
EXEC usp_obtenerDetalleReceta @p_idReceta = 8     -- 2 filas
EXEC usp_obtenerDetalleReceta @p_idReceta = 1     -- 0 filas (todavía sin líneas)
EXEC usp_obtenerDetalleReceta @p_idReceta = 9999  -- error 000001
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_GarciaMartinezMarisol_2253587_Ejercicio1.txt
EV2_GarciaMartinezMarisol_2253587_Ejercicio2.txt
```
