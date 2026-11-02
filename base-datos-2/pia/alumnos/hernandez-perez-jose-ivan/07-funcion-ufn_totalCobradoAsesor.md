# PIA AsesorPro — Objeto 07 de 11: `ufn_totalCobradoAsesor`

**Alumno:** Hernandez Perez Jose Ivan (matrícula 2253557)
**Objeto a crear:** Función escalar `ufn_totalCobradoAsesor`

← [Regresar al caso AsesorPro](README.md)

---

## Historia de usuario

**Como** directora de AsesorPro, **quiero** saber cuánto se ha cobrado en total por cada asesor, **para** saber qué tanto deja cada uno.

## Contexto

Lo cobrado con un asesor es la **suma de lo cobrado** en todas sus asesorías: en cada una, el precio cobrado × horas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| El asesor tiene asesorías | La suma de lo cobrado |
| El asesor existe pero no tiene asesorías | `0.00` |
| El asesor no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoAsesor` que reciba el correo electrónico de un asesor y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_CorreoAsesor` | `varchar(100)` | Correo electrónico del asesor |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoAsesor` y recibe `@p_CorreoAsesor varchar(100)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe un asesor con ese correo electrónico, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada asesoría, no el precio actual), multiplicado por horas.
- [ ] Si el asesor existe pero no tiene asesorías, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarAlumno`](01-procedimiento-usp_insertarAlumno.md), [`usp_insertarAsesor`](03-procedimiento-usp_insertarAsesor.md), [`usp_actualizarTarifaAsesor`](04-procedimiento-usp_actualizarTarifaAsesor.md), [`usp_registrarAsesoria`](05-procedimiento-usp_registrarAsesoria.md).

```sql
-- Preparación: el alumno de prueba
EXEC usp_insertarAlumno @p_NombreNivelEscolar = 'Secundaria', @p_Nombre = 'Alumno de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- Preparación: un asesor nuevo, 'asesor.prueba@asesorpro.mx' ($250.00)
EXEC usp_insertarAsesor @p_Nombre = 'Asesor de Prueba', @p_CorreoElectronico = 'asesor.prueba@asesorpro.mx', @p_Materia = 'Historia', @p_AniosExperiencia = 2, @p_TarifaPorHora = 250.00

-- Sin asesorías: 0.00
SELECT dbo.ufn_totalCobradoAsesor('asesor.prueba@asesorpro.mx') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoAsesor('NoExiste') AS TotalCobrado
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'asesor.prueba@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-01', @p_Horas = 2
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'asesor.prueba@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-02', @p_Horas = 3

-- Dos asesorías: 1250.00
SELECT dbo.ufn_totalCobradoAsesor('asesor.prueba@asesorpro.mx') AS TotalCobrado

-- Sube el precio a $300.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarTarifaAsesor @p_CorreoAsesor = 'asesor.prueba@asesorpro.mx', @p_PrecioNuevo = 300.00
EXEC usp_registrarAsesoria @p_CorreoAsesor = 'asesor.prueba@asesorpro.mx', @p_CorreoAlumno = 'prueba1@correo.com', @p_FechaAsesoria = '2026-12-03', @p_Horas = 1

-- Tres asesorías: 1550.00
SELECT dbo.ufn_totalCobradoAsesor('asesor.prueba@asesorpro.mx') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'asesor.prueba@asesorpro.mx' sin asesorías | 0.00 |
| No existe | NULL |
| Con 2 asesorías | 1250.00 |
| Con 3 asesorías, una con el precio nuevo | 1550.00 |
