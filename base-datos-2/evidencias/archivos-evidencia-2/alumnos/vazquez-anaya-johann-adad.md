# Ejercicios de Evidencia 2

**Alumno:** Vazquez Anaya Johann Adad (matrícula 2253497)

---

## Ejercicio 1: `usp_insertarMedicamento`

### Contexto

Antes de poder prescribir un medicamento en una receta (`DetalleReceta`), ese medicamento tiene que existir en el catálogo `Medicamento`. Tu procedimiento da de alta uno nuevo, cuidando que no se repita el mismo nombre con la misma marca.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(100)` | Nombre del medicamento |
| `@p_Marca` | `varchar(50)` | Marca comercial |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarMedicamento` y recibe `@p_Nombre varchar(100)`, `@p_Marca varchar(50)`.
- [ ] Valida que no exista ya un medicamento con esa combinación exacta de `Nombre` **y** `Marca`; si ya existe, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El medicamento ya está registrado con esa marca'`, y termina con `RETURN`.
- [ ] Si no existe, inserta el nuevo renglón en `Medicamento` (`Activo` toma su valor por default, `1`).
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Inserción correcta'`.

### Ejemplo de salida esperada

`EXEC usp_insertarMedicamento @p_Nombre = 'Aspirina 100mg', @p_Marca = 'Bayer'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Inserción correcta |

`EXEC usp_insertarMedicamento @p_Nombre = 'Paracetamol 500mg', @p_Marca = 'Tempra'` (ya existe en el catálogo semilla) debe regresar el error `000001`.

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarMedicamento @p_Nombre = 'Aspirina 100mg', @p_Marca = 'Bayer'

-- Ya está registrado con esa marca
EXEC usp_insertarMedicamento @p_Nombre = 'Paracetamol 500mg', @p_Marca = 'Tempra'

-- Mismo nombre, marca distinta: SÍ debe permitirse (la UNIQUE es sobre Nombre+Marca juntos)
EXEC usp_insertarMedicamento @p_Nombre = 'Paracetamol 500mg', @p_Marca = 'GenéricoPlus'
```

---

## Ejercicio 2: `usp_eliminarMedicamento`

### Contexto

Cuando un medicamento se descontinúa, no se borra (las recetas históricas que lo prescribieron deben seguir intactas) — se da de baja lógica.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedicamento` | `int` | Id del medicamento a dar de baja |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarMedicamento` y recibe `@p_idMedicamento int`.
- [ ] Valida que el medicamento exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El medicamento no existe'`, y termina con `RETURN`.
- [ ] Si existe, actualiza `Activo = 0` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Eliminación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_eliminarMedicamento @p_idMedicamento = 15` (Clotrimazol Crema):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Eliminación correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_eliminarMedicamento @p_idMedicamento = 15
SELECT Activo FROM Medicamento WHERE idMedicamento = 15  -- esperado: 0

-- No existe
EXEC usp_eliminarMedicamento @p_idMedicamento = 9999
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_VazquezAnayaJohannAdad_2253497_Ejercicio1.txt
EV2_VazquezAnayaJohannAdad_2253497_Ejercicio2.txt
```
