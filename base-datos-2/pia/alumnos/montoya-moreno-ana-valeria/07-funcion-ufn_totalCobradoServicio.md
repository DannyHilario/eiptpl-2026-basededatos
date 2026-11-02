# PIA SpaZen — Objeto 07 de 11: `ufn_totalCobradoServicio`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Función escalar `ufn_totalCobradoServicio`

← [Regresar al caso SpaZen](README.md)

---

## Historia de usuario

**Como** dueño de SpaZen, **quiero** saber cuánto se ha cobrado en total por cada servicio, **para** saber qué tanto deja cada uno.

## Contexto

Lo cobrado con un servicio es la **suma del precio cobrado** de todas sus citas, **no** el precio actual.

| Situación | Regresa |
|---|---|
| El servicio tiene citas | La suma de lo cobrado |
| El servicio existe pero no tiene citas | `0.00` |
| El servicio no existe | `NULL` |

Cuidado con el segundo caso: `SUM` sobre cero filas regresa `NULL`, no `0` ([Errores de valor nulo](../../../temas/Etapa-4/05-ValoresNulos.md)).

## Tu tarea

Crea una función escalar llamada exactamente `ufn_totalCobradoServicio` que reciba el nombre de un servicio y regrese el total cobrado según la tabla de arriba.

## Firma de la función

| Parámetro | Tipo | Descripción |
|---|---|---|
| `@p_NombreServicio` | `varchar(50)` | Nombre del servicio |

**Regresa:** `decimal(12,2)`.

## Criterios de aceptación

- [ ] La función se llama exactamente `ufn_totalCobradoServicio` y recibe `@p_NombreServicio varchar(50)`.
- [ ] Regresa un valor de tipo `decimal(12,2)`.
- [ ] Si no existe un servicio con ese nombre, regresa `NULL`.
- [ ] Suma lo **cobrado** (el precio que guarda cada cita, no el precio actual).
- [ ] Si el servicio existe pero no tiene citas, regresa `0.00`: usa `ISNULL`.
- [ ] No genera error en ningún caso.

## Casos de prueba

Parten de una [instalación limpia](README.md#cómo-probar-tus-objetos). Ejecútalos en orden. Usan [`usp_insertarCliente`](01-procedimiento-usp_insertarCliente.md), [`usp_insertarServicio`](03-procedimiento-usp_insertarServicio.md), [`usp_actualizarPrecioServicio`](04-procedimiento-usp_actualizarPrecioServicio.md), [`usp_registrarCita`](05-procedimiento-usp_registrarCita.md).

```sql
-- Preparación: el cliente de prueba
EXEC usp_insertarCliente @p_NombreZona = 'Norte', @p_Nombre = 'Cliente de Prueba', @p_CorreoElectronico = 'prueba1@correo.com', @p_FechaRegistro = '2026-11-01'

-- Preparación: un servicio nuevo, 'Servicio de Prueba' ($750.00)
EXEC usp_insertarServicio @p_Nombre = 'Servicio de Prueba', @p_DuracionMinutos = 30, @p_Precio = 750.00

-- Sin citas: 0.00
SELECT dbo.ufn_totalCobradoServicio('Servicio de Prueba') AS TotalCobrado

-- No existe: NULL
SELECT dbo.ufn_totalCobradoServicio('NoExiste') AS TotalCobrado
EXEC usp_registrarCita @p_NombreServicio = 'Servicio de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-01', @p_Calificacion = 5
EXEC usp_registrarCita @p_NombreServicio = 'Servicio de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-02', @p_Calificacion = 4

-- Dos citas: 1500.00
SELECT dbo.ufn_totalCobradoServicio('Servicio de Prueba') AS TotalCobrado

-- Sube el precio a $900.00 y se registra otra; las anteriores conservan lo que se cobró
EXEC usp_actualizarPrecioServicio @p_NombreServicio = 'Servicio de Prueba', @p_PrecioNuevo = 900.00
EXEC usp_registrarCita @p_NombreServicio = 'Servicio de Prueba', @p_CorreoCliente = 'prueba1@correo.com', @p_FechaCita = '2026-12-03', @p_Calificacion = 3

-- Tres citas: 2400.00
SELECT dbo.ufn_totalCobradoServicio('Servicio de Prueba') AS TotalCobrado
```

| Caso | Resultado esperado |
|---|---|
| 'Servicio de Prueba' sin citas | 0.00 |
| No existe | NULL |
| Con 2 citas | 1500.00 |
| Con 3 citas, una con el precio nuevo | 2400.00 |
