# PIA EspacioUno — Objeto 07 de 11: `ufn_totalCobradoEspacio`

**Alumno:** Rodriguez Moreno Ricardo (matrícula 2254147)
**Objeto a crear:** Función escalar `ufn_totalCobradoEspacio`

← [Regresar al caso EspacioUno](README.md)

---

## Historia de usuario

**Como** dueña de EspacioUno, **quiero** saber cuánto se ha cobrado en total por cada espacio, **para** saber qué tanto deja cada uno.

## Contexto

Lo cobrado con un espacio es la **suma de lo cobrado** en todas sus reservas: en cada una, el precio cobrado × horas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| El espacio tiene reservas | La suma de lo cobrado |
| El espacio existe pero no tiene reservas | `0.00` |
| El espacio no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoEspacio` que reciba el nombre de un espacio y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreEspacio` | `varchar(50)` | Nombre del espacio |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoEspacio` y recibe `@p_NombreEspacio varchar(50)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe un espacio con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada reserva, no el precio actual), multiplicado por horas.
- [ ] Si el espacio existe pero no tiene reservas, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarMiembro`](01-procedimiento-usp_insertarMiembro.md), [`usp_insertarEspacio`](03-procedimiento-usp_insertarEspacio.md), [`usp_actualizarTarifaTipoEspacio`](04-procedimiento-usp_actualizarTarifaTipoEspacio.md), [`usp_registrarReserva`](05-procedimiento-usp_registrarReserva.md).

```sql
-- Preparación: el miembro de prueba
EXEC usp_insertarMiembro @p_Nombre = 'Miembro de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_Empresa = 'Empresa de Prueba'

-- Preparación: un espacio nuevo, 'Escritorio Prueba' (Oficina privada, $200.00)
EXEC usp_insertarEspacio @p_NombreTipoEspacio = 'Oficina privada', @p_NombreEspacio = 'Escritorio Prueba', @p_FechaApertura = '2026-11-01'

-- Sin reservas: 0.00
SELECT dbo.ufn_totalCobradoEspacio('Escritorio Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoEspacio('NoExiste') AS TotalCobrado
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Prueba', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-01', @p_Horas = 2
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Prueba', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-02', @p_Horas = 3

-- Dos reservas: 1000.00
SELECT dbo.ufn_totalCobradoEspacio('Escritorio Prueba') AS TotalCobrado

-- Sube el precio a $240.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarTarifaTipoEspacio @p_NombreTipoEspacio = 'Oficina privada', @p_PrecioNuevo = 240.00
EXEC usp_registrarReserva @p_NombreEspacio = 'Escritorio Prueba', @p_CorreoMiembro = 'prueba1@correo.com', @p_FechaReserva = '2026-12-03', @p_Horas = 1

-- Tres reservas: 1240.00
SELECT dbo.ufn_totalCobradoEspacio('Escritorio Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Escritorio Prueba' sin reservas | 0.00 |
| No existe | NULL |
| Con 2 reservas | 1000.00 |
| Con 3 reservas, una con el precio nuevo | 1240.00 |
