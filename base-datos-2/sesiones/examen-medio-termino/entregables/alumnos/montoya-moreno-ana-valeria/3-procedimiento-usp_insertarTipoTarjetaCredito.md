# Examen de Medio Término — Ejercicio 3 de 3: `usp_insertarTipoTarjetaCredito`

**Alumno:** Montoya Moreno Ana Valeria (matrícula 2254069)
**Objeto a crear:** Procedimiento almacenado `usp_insertarTipoTarjetaCredito`
**Valor:** 50 puntos

← [Regresar a la descripción del examen](../../descripcion-examen.md)

---

## Historia de usuario

**Como** gerente de producto, **quiero** dar de alta un producto nuevo de tarjeta de crédito, **para** empezar a ofrecerlo a los clientes.

## Contexto

Cada producto de tarjeta (`TipoTarjetaCredito`) define sus parámetros: el rango de límite de crédito que se puede otorgar (`LimiteCreditoMinimo` a `LimiteCreditoMaximo`), la anualidad y la tasa de interés.

El nombre del producto no se puede repetir, y el rango debe tener sentido: el límite máximo tiene que ser **mayor** que el mínimo.

## Tu tarea

Crea un procedimiento almacenado llamado exactamente `usp_insertarTipoTarjetaCredito` que valide las reglas de arriba y, si todo es correcto, inserte el producto.

## Firma del procedimiento

**Parámetros:**

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_Nombre` | `varchar(50)` | Nombre del producto |
| `@p_LimiteCreditoMinimo` | `decimal(12,2)` | Límite mínimo que se puede otorgar |
| `@p_LimiteCreditoMaximo` | `decimal(12,2)` | Límite máximo que se puede otorgar |
| `@p_Anualidad` | `decimal(10,2)` | Cuota anual |
| `@p_TasaInteresAnual` | `decimal(5,2)` | Tasa de interés anual (%) |

**Validaciones y códigos de salida:**

| Orden | Validación | ErrCodigo | ErrMensaje |
|---|---|---|---|
| 1 | No existe otro producto con ese nombre | `000001` | Ya existe un producto con ese nombre |
| 2 | El límite máximo es mayor que el mínimo | `000002` | El límite máximo debe ser mayor que el límite mínimo |
| 3 | Todo correcto | `000000` | Producto registrado |

## Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_insertarTipoTarjetaCredito` y recibe los parámetros de la tabla, con esos nombres y tipos.
- [ ] Antes de cada validación, guarda el dato que necesitas en una variable con `SELECT ... FROM ... WHERE` y luego revísala con `IF @variable IS NULL` / `IF @variable IS NOT NULL` (no uses `IF EXISTS (SELECT ...)`).
- [ ] Evalúa las validaciones **en el orden de la tabla**. Si una falla, regresa su `ErrCodigo` y `ErrMensaje` con un `SELECT` y termina con `RETURN`, sin modificar nada.
- [ ] Valida: no existe otro producto con ese nombre → `000001` *Ya existe un producto con ese nombre*.
- [ ] Valida: el límite máximo es mayor que el mínimo → `000002` *El límite máximo debe ser mayor que el límite mínimo*.
- [ ] Si todo es correcto, inserta el producto en `TipoTarjetaCredito` con los 5 datos recibidos. `Activo`, `FechaCreacion` y `FechaUltimaModificacion` toman su valor por defecto.
- [ ] Al terminar con éxito regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Producto registrado'`.

## Ejemplo de salida esperada

`EXEC usp_insertarTipoTarjetaCredito @p_Nombre = 'Banquito Joven', @p_LimiteCreditoMinimo = 2000.00, @p_LimiteCreditoMaximo = 10000.00, @p_Anualidad = 0.00, @p_TasaInteresAnual = 60.00`

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Producto registrado |

Después, `SELECT * FROM TipoTarjetaCredito WHERE idTipoTarjetaCredito = 4` muestra el producto Banquito Joven.

## Casos de prueba sugeridos

Ejecútalos después de crear tu objeto. Los resultados esperados corresponden a los **datos iniciales** de `SistemaBancarioBD`.

```sql
-- Éxito
EXEC usp_insertarTipoTarjetaCredito @p_Nombre = 'Banquito Joven', @p_LimiteCreditoMinimo = 2000.00, @p_LimiteCreditoMaximo = 10000.00, @p_Anualidad = 0.00, @p_TasaInteresAnual = 60.00
SELECT idTipoTarjetaCredito, Nombre, LimiteCreditoMinimo, LimiteCreditoMaximo, Anualidad,
    TasaInteresAnual
FROM TipoTarjetaCredito
WHERE idTipoTarjetaCredito = 4

-- 000001: ya existe Banquito Gold
EXEC usp_insertarTipoTarjetaCredito @p_Nombre = 'Banquito Gold', @p_LimiteCreditoMinimo = 2000.00, @p_LimiteCreditoMaximo = 10000.00, @p_Anualidad = 0.00, @p_TasaInteresAnual = 60.00

-- 000002: el máximo (100,000) es menor que el mínimo (500,000)
EXEC usp_insertarTipoTarjetaCredito @p_Nombre = 'Banquito Black', @p_LimiteCreditoMinimo = 500000.00, @p_LimiteCreditoMaximo = 100000.00, @p_Anualidad = 8000.00, @p_TasaInteresAnual = 30.00
```

> Estos casos **modifican los datos** de tu base. Si quieres repetirlos desde el principio, regresa a los datos iniciales como se indica en la [descripción del examen](../../descripcion-examen.md#si-necesitas-regresar-a-los-datos-iniciales).

## Entrega

Este ejercicio va dentro de tu archivo único de examen, como **ejercicio 3**. Ver [Entregable](../../descripcion-examen.md#entregable) en la descripción del examen.
