# Examen de Medio Término — Base de Datos II

De manera **individual**, resolverás tres ejercicios sobre la base de datos `SistemaBancarioBD`: una **función**, una **vista** y un **procedimiento almacenado**. Cada alumno tiene una combinación distinta de ejercicios; busca tu nombre en la tabla de abajo.

| Ejercicio | Objeto | Valor |
|-----------|--------|-------|
| 1 | Función escalar (`CREATE FUNCTION`) | 20 puntos |
| 2 | Vista (`CREATE VIEW`) | 30 puntos |
| 3 | Procedimiento almacenado (`CREATE PROCEDURE`) | 50 puntos |
| | **Total** | **100 puntos** |

- **Fecha:** sábado 3 de octubre de 2026.
- **Horario:** de 8:40 a.m. a 11:10 a.m.
- **Modalidad:** en línea, individual.

---

## Antes de empezar: instala la base de datos

1. Abre [`SistemaBancarioBD/instalar-completo.sql`](../SistemaBancarioBD/instalar-completo.sql) en SSMS y ejecútalo completo (F5). Crea la base de datos, las 6 tablas, los datos iniciales y el procedimiento `usp_registrarMovimiento`.
2. Selecciona `SistemaBancarioBD` en el dropdown de SSMS.
3. Comprueba que la instalación quedó bien: `SELECT COUNT(*) FROM Movimiento` debe regresar **164**.

Si ya tenías instalada `SistemaBancarioBD` de antes, ejecuta primero la reversa (ver abajo) y vuelve a instalar, para empezar con los datos iniciales.

### Material de consulta

- [README del examen](../README.md): el modelo, el diagrama ER, los **conceptos de saldo, cargo y abono**, y las **reglas de negocio** (estado de una tarjeta, tarjetas por cliente, movimientos y saldo).
- [Diccionario de datos](../SistemaBancarioBD/docs/tablas): una ficha por tabla, con sus columnas y restricciones.
- [`usp_registrarMovimiento`](../SistemaBancarioBD/docs/procedimientos/usp_registrarMovimiento.md): el procedimiento ya instalado; sirve como ejemplo del formato de validaciones y códigos de salida.

### Si necesitas regresar a los datos iniciales

Algunos casos de prueba modifican datos. Para empezar de nuevo:

1. Selecciona `SistemaBancarioBD` y ejecuta [`reversa/01-drop-tables.sql`](../SistemaBancarioBD/reversa/01-drop-tables.sql).
2. Selecciona `master` y ejecuta [`reversa/02-drop-database.sql`](../SistemaBancarioBD/reversa/02-drop-database.sql).
3. Vuelve a ejecutar `instalar-completo.sql`.

> La reversa borra también tus objetos del examen. **Guarda tu código antes** en tu archivo de entrega.

---

## Tus ejercicios

Cada liga abre una historia de usuario con el contexto de negocio, lo que tienes que construir, los criterios de aceptación, un ejemplo del resultado esperado y casos de prueba.

| Alumno | Ejercicio 1 — Función (20) | Ejercicio 2 — Vista (30) | Ejercicio 3 — Procedimiento (50) |
|--------|----------------------------|--------------------------|----------------------------------|
| Aguilar Hernandez Marcos Fernando | [`ufn_creditoDisponibleTarjeta`](alumnos/aguilar-hernandez-marcos-fernando/1-funcion-ufn_creditoDisponibleTarjeta.md) | [`vw_TarjetaVencida`](alumnos/aguilar-hernandez-marcos-fernando/2-vista-vw_TarjetaVencida.md) | [`usp_insertarCliente`](alumnos/aguilar-hernandez-marcos-fernando/3-procedimiento-usp_insertarCliente.md) |
| Espinoza Juarez Angel De Jesus | [`ufn_totalCargosTarjeta`](alumnos/espinoza-juarez-angel-de-jesus/1-funcion-ufn_totalCargosTarjeta.md) | [`vw_TarjetaCliente`](alumnos/espinoza-juarez-angel-de-jesus/2-vista-vw_TarjetaCliente.md) | [`usp_obtenerMovimientosTarjeta`](alumnos/espinoza-juarez-angel-de-jesus/3-procedimiento-usp_obtenerMovimientosTarjeta.md) |
| Garcia Martinez Marisol | [`ufn_estadoTarjeta`](alumnos/garcia-martinez-marisol/1-funcion-ufn_estadoTarjeta.md) | [`vw_ResumenSucursal`](alumnos/garcia-martinez-marisol/2-vista-vw_ResumenSucursal.md) | [`usp_eliminarCliente`](alumnos/garcia-martinez-marisol/3-procedimiento-usp_eliminarCliente.md) |
| Gomez Ordaz Bryan Omar | [`ufn_totalTarjetasActivasCliente`](alumnos/gomez-ordaz-bryan-omar/1-funcion-ufn_totalTarjetasActivasCliente.md) | [`vw_ClienteSinTarjeta`](alumnos/gomez-ordaz-bryan-omar/2-vista-vw_ClienteSinTarjeta.md) | [`usp_cancelarTarjeta`](alumnos/gomez-ordaz-bryan-omar/3-procedimiento-usp_cancelarTarjeta.md) |
| Hernandez Juarez Brenda Ivonne | [`ufn_estadoTarjeta`](alumnos/hernandez-juarez-brenda-ivonne/1-funcion-ufn_estadoTarjeta.md) | [`vw_MovimientoDetalle`](alumnos/hernandez-juarez-brenda-ivonne/2-vista-vw_MovimientoDetalle.md) | [`usp_insertarSucursal`](alumnos/hernandez-juarez-brenda-ivonne/3-procedimiento-usp_insertarSucursal.md) |
| Hernandez Martínez Alexander Kalet | [`ufn_creditoDisponibleTarjeta`](alumnos/hernandez-martinez-alexander-kalet/1-funcion-ufn_creditoDisponibleTarjeta.md) | [`vw_TarjetaCliente`](alumnos/hernandez-martinez-alexander-kalet/2-vista-vw_TarjetaCliente.md) | [`usp_reactivarTarjeta`](alumnos/hernandez-martinez-alexander-kalet/3-procedimiento-usp_reactivarTarjeta.md) |
| Hernandez Perez Jose Ivan | [`ufn_totalTarjetasActivasCliente`](alumnos/hernandez-perez-jose-ivan/1-funcion-ufn_totalTarjetasActivasCliente.md) | [`vw_ResumenSucursal`](alumnos/hernandez-perez-jose-ivan/2-vista-vw_ResumenSucursal.md) | [`usp_actualizarDireccionCliente`](alumnos/hernandez-perez-jose-ivan/3-procedimiento-usp_actualizarDireccionCliente.md) |
| Mejia Garcia Ricardo Azael | [`ufn_estadoTarjeta`](alumnos/mejia-garcia-ricardo-azael/1-funcion-ufn_estadoTarjeta.md) | [`vw_ResumenProducto`](alumnos/mejia-garcia-ricardo-azael/2-vista-vw_ResumenProducto.md) | [`usp_emitirTarjeta`](alumnos/mejia-garcia-ricardo-azael/3-procedimiento-usp_emitirTarjeta.md) |
| Mendez Cantu Raúl Ángel | [`ufn_totalTarjetasActivasCliente`](alumnos/mendez-cantu-raul-angel/1-funcion-ufn_totalTarjetasActivasCliente.md) | [`vw_TarjetaVencida`](alumnos/mendez-cantu-raul-angel/2-vista-vw_TarjetaVencida.md) | [`usp_renovarTarjeta`](alumnos/mendez-cantu-raul-angel/3-procedimiento-usp_renovarTarjeta.md) |
| Montoya Moreno Ana Valeria | [`ufn_totalCargosTarjeta`](alumnos/montoya-moreno-ana-valeria/1-funcion-ufn_totalCargosTarjeta.md) | [`vw_MovimientoDetalle`](alumnos/montoya-moreno-ana-valeria/2-vista-vw_MovimientoDetalle.md) | [`usp_insertarTipoTarjetaCredito`](alumnos/montoya-moreno-ana-valeria/3-procedimiento-usp_insertarTipoTarjetaCredito.md) |
| Morales Azuara Eduardo Gabriel | [`ufn_creditoDisponibleTarjeta`](alumnos/morales-azuara-eduardo-gabriel/1-funcion-ufn_creditoDisponibleTarjeta.md) | [`vw_MovimientoDetalle`](alumnos/morales-azuara-eduardo-gabriel/2-vista-vw_MovimientoDetalle.md) | [`usp_cambiarSucursalCliente`](alumnos/morales-azuara-eduardo-gabriel/3-procedimiento-usp_cambiarSucursalCliente.md) |
| Perez Morales Johan Valente | [`ufn_creditoDisponibleTarjeta`](alumnos/perez-morales-johan-valente/1-funcion-ufn_creditoDisponibleTarjeta.md) | [`vw_ClienteSinTarjeta`](alumnos/perez-morales-johan-valente/2-vista-vw_ClienteSinTarjeta.md) | [`usp_insertarTipoMovimiento`](alumnos/perez-morales-johan-valente/3-procedimiento-usp_insertarTipoMovimiento.md) |
| Rodriguez Moreno Ricardo | [`ufn_totalCargosTarjeta`](alumnos/rodriguez-moreno-ricardo/1-funcion-ufn_totalCargosTarjeta.md) | [`vw_ResumenSucursal`](alumnos/rodriguez-moreno-ricardo/2-vista-vw_ResumenSucursal.md) | [`usp_actualizarLimiteCredito`](alumnos/rodriguez-moreno-ricardo/3-procedimiento-usp_actualizarLimiteCredito.md) |
| Ruiz Olguin Alejandro | [`ufn_totalTarjetasActivasCliente`](alumnos/ruiz-olguin-alejandro/1-funcion-ufn_totalTarjetasActivasCliente.md) | [`vw_ResumenProducto`](alumnos/ruiz-olguin-alejandro/2-vista-vw_ResumenProducto.md) | [`usp_obtenerTarjetasCliente`](alumnos/ruiz-olguin-alejandro/3-procedimiento-usp_obtenerTarjetasCliente.md) |
| Sifuentes Emiliano Mucio Rafael | [`ufn_totalCargosTarjeta`](alumnos/sifuentes-emiliano-mucio-rafael/1-funcion-ufn_totalCargosTarjeta.md) | [`vw_ResumenProducto`](alumnos/sifuentes-emiliano-mucio-rafael/2-vista-vw_ResumenProducto.md) | [`usp_eliminarSucursal`](alumnos/sifuentes-emiliano-mucio-rafael/3-procedimiento-usp_eliminarSucursal.md) |
| Vazquez Anaya Johann Adad | [`ufn_totalTarjetasActivasCliente`](alumnos/vazquez-anaya-johann-adad/1-funcion-ufn_totalTarjetasActivasCliente.md) | [`vw_TarjetaCliente`](alumnos/vazquez-anaya-johann-adad/2-vista-vw_TarjetaCliente.md) | [`usp_obtenerMovimientosPorRango`](alumnos/vazquez-anaya-johann-adad/3-procedimiento-usp_obtenerMovimientosPorRango.md) |
| Villanueva Mata Brandon Gabriel | [`ufn_estadoTarjeta`](alumnos/villanueva-mata-brandon-gabriel/1-funcion-ufn_estadoTarjeta.md) | [`vw_TarjetaVencida`](alumnos/villanueva-mata-brandon-gabriel/2-vista-vw_TarjetaVencida.md) | [`usp_obtenerClientesSucursal`](alumnos/villanueva-mata-brandon-gabriel/3-procedimiento-usp_obtenerClientesSucursal.md) |

---

## Convenciones de código

Tu código debe seguir las convenciones SQL del curso:

- Palabras reservadas en **MAYÚSCULAS** (`SELECT`, `CREATE VIEW`, `WHERE`, etc.).
- Nombre de cada objeto **exactamente** como se indica en su historia de usuario (respeta mayúsculas y minúsculas), y parámetros con los nombres y tipos indicados.
- `SELECT` y `FROM` en líneas separadas; los campos comienzan en la misma línea del `SELECT`; máximo 5 campos por renglón.
- En los procedimientos, cada validación guarda el dato en una variable (`SELECT ... FROM ... WHERE`) y la revisa con `IF @variable IS NULL` / `IS NOT NULL`. No uses `IF EXISTS (SELECT ...)`.
- Los procedimientos regresan sus resultados con el formato `ErrCodigo` / `ErrMensaje`, como `usp_registrarMovimiento`.
- Las funciones se llaman con el prefijo `dbo.`: `SELECT dbo.ufn_nombreFuncion(1)`.
- Las vistas no llevan `ORDER BY`.

---

## Entregable

Un solo archivo de **texto plano (`.txt`)** con el código de tus **tres** objetos, listo para copiar, pegar y ejecutar tal cual en SSMS contra `SistemaBancarioBD`. Usa esta estructura:

```sql
-- Tema:        Examen de Medio Término - SistemaBancarioBD
-- Descripción: Ejercicios 1, 2 y 3
-- Autor:       Tu nombre completo (matrícula)

USE SistemaBancarioBD;
GO

-- Ejercicio 1: función
CREATE FUNCTION ...
GO

-- Ejercicio 2: vista
CREATE VIEW ...
GO

-- Ejercicio 3: procedimiento almacenado
CREATE PROCEDURE ...
GO
```

> `CREATE FUNCTION`, `CREATE VIEW` y `CREATE PROCEDURE` deben ser la única sentencia de su lote: por eso va un `GO` antes y después de cada uno. Antes de entregar, comprueba que tu archivo se ejecuta completo, sin errores, sobre una instalación limpia de `SistemaBancarioBD`.

> Es `.txt` y no `.sql` porque NEXUS no acepta esa extensión; el contenido es igual código SQL.

Nombra tu archivo de la siguiente forma:

```
EMT_ApellidoNombre_Matricula.txt
```

*Ejemplo: `EMT_AguilarHernandezMarcosFernando_2254024.txt`*

---

## Forma de entrega

- **Modalidad:** individual. Cada alumno carga su propio archivo.
- **Plataforma:** NEXUS, en el apartado *"Examen de medio término"*.
- **Fecha y hora límite:** sábado 3 de octubre de 2026, 11:10 a.m.

---

## Evaluación

Cada ejercicio se califica por separado, con su valor máximo (20, 30 y 50 puntos), según los criterios de aceptación de su historia de usuario:

| Nivel | Condición | Porcentaje del valor del ejercicio |
|-------|-----------|-----------------------------------|
| **Completo** | El objeto se crea sin errores y cumple el 100% de sus criterios de aceptación | 100% |
| **Suficiente** | El objeto se crea sin errores y cumple al menos el 50% de sus criterios | 70% |
| **Débil** | El objeto se crea sin errores pero cumple menos del 50% de sus criterios, o tiene errores de sintaxis que impiden crearlo | 40% |
| **Sin evidencia** | No se entregó el ejercicio | 0% |

**Calificación final** = puntos del ejercicio 1 + puntos del ejercicio 2 + puntos del ejercicio 3 (máximo 100).
