# PIA FitZone — Objeto 07 de 11: `ufn_totalCobradoClase`

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)
**Objeto a crear:** Función escalar `ufn_totalCobradoClase`

← [Regresar al caso FitZone](README.md)

---

## Historia de usuario

**Como** dueño de FitZone, **quiero** saber cuánto se ha cobrado en total por cada clase, **para** saber qué tanto deja cada una.

## Contexto

Lo cobrado con una clase es la **suma del precio cobrado** de todas sus asistencias, **no** el precio actual.

| Situación | Regresa |
|---|---|
| La clase tiene asistencias | La suma de lo cobrado |
| La clase existe pero no tiene asistencias | `0.00` |
| La clase no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/04-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoClase` que reciba el nombre de una clase y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreClase` | `varchar(50)` | Nombre de la clase |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoClase` y recibe `@p_NombreClase varchar(50)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe una clase con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada asistencia, no el precio actual).
- [ ] Si la clase existe pero no tiene asistencias, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarSocio`](01-procedimiento-usp_insertarSocio.md), [`usp_insertarClase`](03-procedimiento-usp_insertarClase.md), [`usp_actualizarPrecioClase`](04-procedimiento-usp_actualizarPrecioClase.md), [`usp_registrarAsistencia`](05-procedimiento-usp_registrarAsistencia.md).

```sql
-- Preparación: el socio de prueba
EXEC usp_insertarSocio @p_NombreObjetivo = 'Bajar de peso', @p_Nombre = 'Socio de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaInscripcion = '2026-11-01'

-- Preparación: una clase nueva, 'Clase de Prueba' ($90.00)
EXEC usp_insertarClase @p_Nombre = 'Clase de Prueba', @p_Instructor = 'Instructor de Prueba', @p_CupoMaximo = 10, @p_PrecioPorClase = 90.00

-- Sin asistencias: 0.00
SELECT dbo.ufn_totalCobradoClase('Clase de Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoClase('NoExiste') AS TotalCobrado
EXEC usp_registrarAsistencia @p_NombreClase = 'Clase de Prueba', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-01'
EXEC usp_registrarAsistencia @p_NombreClase = 'Clase de Prueba', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-02'

-- Dos asistencias: 180.00
SELECT dbo.ufn_totalCobradoClase('Clase de Prueba') AS TotalCobrado

-- Sube el precio a $110.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioClase @p_NombreClase = 'Clase de Prueba', @p_PrecioNuevo = 110.00
EXEC usp_registrarAsistencia @p_NombreClase = 'Clase de Prueba', @p_CorreoSocio = 'prueba1@correo.com', @p_FechaAsistencia = '2026-12-03'

-- Tres asistencias: 290.00
SELECT dbo.ufn_totalCobradoClase('Clase de Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Clase de Prueba' sin asistencias | 0.00 |
| No existe | NULL |
| Con 2 asistencias | 180.00 |
| Con 3 asistencias, una con el precio nuevo | 290.00 |
