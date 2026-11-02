# PIA SalaRock — Objeto 06 de 11: `usp_obtenerEnsayosPorFecha`

**Alumno:** Garcia Martinez Marisol (matrícula 2253587)
**Objeto a crear:** Procedimiento almacenado `usp_obtenerEnsayosPorFecha`

← [Regresar al caso SalaRock](README.md)

---

## Historia de usuario

**Como** dueño de SalaRock, **quiero** ver los ensayos de un rango de fechas, **para** revisar la operación de un día, una semana o un mes.

## Contexto

Es una consulta de **solo lectura**: no modifica nada. Recibe una fecha inicial y una final, y regresa los ensayos de ese rango, **incluidos los dos extremos**. Lo único que puede estar mal es el rango: que la fecha inicial sea posterior a la final.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_obtenerEnsayosPorFecha` que valide el rango y regrese los ensayos.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_FechaInicio` | `date` | Primer día del rango |
| `@p_FechaFin` | `date` | Último día del rango |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | La fecha inicial no es posterior a la final | `000001` | La fecha inicial es posterior a la fecha final |

**Columnas del resultado**, en este orden y con estos nombres:

| Columna | Qué es |
|---|---|
| `FechaEnsayo` | Fecha del ensayo |
| `Sala` | Sala |
| `Banda` | Nombre de la banda |
| `Horas` | Horas |
| `PrecioCobrado` | Precio con el que se cobró el ensayo |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerEnsayosPorFecha` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Valida: la fecha inicial no es posterior a la final → `000001` *La fecha inicial es posterior a la fecha final*, con un `SELECT` de `ErrCodigo` y `ErrMensaje` y `RETURN`.
- [ ] Si el rango es válido, regresa con un `SELECT` (no con las variables de error) las 5 columnas de la tabla de arriba, con esos nombres y en ese orden.
- [ ] Incluye los registros del primer y del último día del rango.
- [ ] Ordena por `FechaEnsayo` y, en un mismo día, por `Sala`.
- [ ] Si no hay registros en el rango, el `SELECT` regresa 0 filas: **no** es un error.
- [ ] **No** regresa un `000000`: al ser una consulta de solo lectura, el resultado del `SELECT` es la respuesta.

## Ejemplo de salida esperada

`EXEC usp_obtenerEnsayosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'` (después de la preparación de los casos de prueba)

| FechaEnsayo | Sala | Banda | Horas | PrecioCobrado |
|---|---|---|---|---|
| 2026-12-01 | Sala Cobain | Banda de Prueba | 3 | 220.00 |
| 2026-12-02 | Sala Hendrix | Banda de Prueba | 1 | 150.00 |
| 2026-12-02 | Sala Lennon | Banda de Prueba | 2 | 300.00 |

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarBanda`](01-procedimiento-usp_insertarBanda.md), [`usp_registrarEnsayo`](05-procedimiento-usp_registrarEnsayo.md).

```sql
-- Preparación: la banda de prueba y tres ensayos de diciembre, registrados en desorden
EXEC usp_insertarBanda @p_Nombre = 'Banda de Prueba', @p_Integrantes = 4, @p_TelefonoContacto = '8199990001'
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Lennon', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-02', @p_Horas = 2
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Cobain', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-01', @p_Horas = 3
EXEC usp_registrarEnsayo @p_NombreSala = 'Sala Hendrix', @p_NombreBanda = 'Banda de Prueba', @p_FechaEnsayo = '2026-12-02', @p_Horas = 1

-- Todo diciembre: 3 filas
EXEC usp_obtenerEnsayosPorFecha @p_FechaInicio = '2026-12-01', @p_FechaFin = '2026-12-31'

-- Un solo día: 2 filas
EXEC usp_obtenerEnsayosPorFecha @p_FechaInicio = '2026-12-02', @p_FechaFin = '2026-12-02'

-- Enero de 2027: 0 filas, no es error
EXEC usp_obtenerEnsayosPorFecha @p_FechaInicio = '2027-01-01', @p_FechaFin = '2027-01-31'

-- 000001: rango al revés
EXEC usp_obtenerEnsayosPorFecha @p_FechaInicio = '2026-12-31', @p_FechaFin = '2026-12-01'
```

| Caso | Resultado esperado |
|---|---|
| Todo diciembre | Las 3 filas del ejemplo de arriba |
| Un solo día (inicio = fin) | 2 filas |
| Enero de 2027 | 0 filas, sin error |
| Rango al revés | `000001` *La fecha inicial es posterior a la fecha final* |
