# Ejercicios de Evidencia 2

**Alumno:** Perez Morales Johan Valente (matrícula 2254047)

---

## Ejercicio 1: `usp_insertarConsultorio`

### Contexto

Antes de poder agendar una consulta en un consultorio, ese consultorio tiene que existir en el catálogo. Tu procedimiento da de alta uno nuevo.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre/identificador del consultorio |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarConsultorio` y recibe `@p_Nombre varchar(50)`.
- [ ] Valida que no exista ya un consultorio con ese mismo `Nombre`; si ya existe, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El consultorio ya está registrado'`, y termina con `RETURN`.
- [ ] Si no existe, inserta el nuevo renglón en `Consultorio` (`Activo` toma su valor por default, `1`).
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Inserción correcta'`.

### Ejemplo de salida esperada

`EXEC usp_insertarConsultorio @p_Nombre = 'Consultorio 11'`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Inserción correcta |

`EXEC usp_insertarConsultorio @p_Nombre = 'Consultorio 1'` (ya existe) debe regresar el error `000001`.

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_insertarConsultorio @p_Nombre = 'Consultorio 11'
SELECT * FROM Consultorio WHERE Nombre = 'Consultorio 11'

-- Ya está registrado
EXEC usp_insertarConsultorio @p_Nombre = 'Consultorio 1'
```

---

## Ejercicio 2: `usp_eliminarConsultorio`

### Contexto

Cuando un consultorio deja de usarse (remodelación, reasignación de espacio), no se borra (las consultas históricas deben seguir intactas) — se da de baja lógica.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idConsultorio` | `int` | Id del consultorio a dar de baja |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarConsultorio` y recibe `@p_idConsultorio int`.
- [ ] Valida que el consultorio exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El consultorio no existe'`, y termina con `RETURN`.
- [ ] Si existe, actualiza `Activo = 0` y `FechaUltimaModificacion = GETDATE()`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Eliminación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_eliminarConsultorio @p_idConsultorio = 10`:

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Eliminación correcta |

### Casos de prueba sugeridos

```sql
-- Éxito
EXEC usp_eliminarConsultorio @p_idConsultorio = 10
SELECT Activo FROM Consultorio WHERE idConsultorio = 10  -- esperado: 0

-- No existe
EXEC usp_eliminarConsultorio @p_idConsultorio = 9999
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_PerezMoralesJohanValente_2254047_Ejercicio1.txt
EV2_PerezMoralesJohanValente_2254047_Ejercicio2.txt
```
