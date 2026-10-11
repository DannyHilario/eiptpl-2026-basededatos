# Evidencia Integral — Base de Datos I (3ra y 5ta oportunidad)

De manera **individual**, diseñarás e implementarás en Microsoft SQL Server la base de datos de un negocio pequeño. Cada alumno tiene **su propio caso de negocio**, distinto al de los demás; busca tu número en la tabla de abajo.

| Evaluación | Valor |
|------------|-------|
| **Evidencia Integral** (este documento) | **30%** |
| **Examen presencial escrito** | **70%** |

> **El examen presencial es sobre el contenido de tu Evidencia Integral.**

---

## Tu caso

Cada caso describe un negocio: qué hace, cómo funciona una operación de principio a fin (flujo de negocio), sus reglas y las 10 preguntas que el dueño quiere responder con la base de datos. **El caso no te dice qué tablas crear:** deducir el modelo a partir del negocio es parte de la evidencia.

| Alumno | Caso |
|--------|------|
| Alumno 1 | [BiciRuta — renta de bicicletas](alumnos/alumno-01.md) |

---

## Lo que debes construir

1. **El modelo relacional** del negocio, con al menos **4 tablas**, que guarde toda la información del caso y respete sus reglas de negocio mediante restricciones: `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK` y `DEFAULT`.
   > **Datos que cambian con el tiempo.** Cuando un dato puede cambiar (un precio, una tarifa, un costo) y una operación del negocio depende del valor que tenía **en el momento en que ocurrió**, ese valor se **copia** en la tabla de la operación. Por ejemplo, si una venta guardara solo la referencia al producto, al subir el precio del producto todas las ventas anteriores "costarían" más de lo que se cobró. Tu caso tiene al menos un dato así. **Este principio se revisa en la evidencia.**

2. **El paquete de instalación**: los scripts que crean la base de datos, sus tablas y sus datos iniciales.
3. **El paquete de reversa**: los scripts que eliminan por completo lo instalado.
4. **Los datos iniciales**, de dos tipos:
   - **Lo que el negocio ya tiene definido** (por ejemplo, sus sucursales o sus servicios y precios): viene en tu caso y se inserta **exactamente como viene**, sin cambiar nombres ni valores.
   - **Lo que tú inventas** (por ejemplo, clientes y operaciones): datos ficticios con las cantidades mínimas que pide tu caso.

   En conjunto, deben permitir que **cada una de las 10 consultas regrese al menos una fila**.
5. **Las 10 consultas** de tu caso.

Revisa el **ejemplo resuelto** de LavaExpress, un caso que no está asignado a ningún alumno: su [enunciado](ejemplo-resuelto/caso.md) tiene el mismo formato que el tuyo, y su [solución](ejemplo-resuelto/README.md) muestra el nivel de detalle que se espera en el PDF y en los tres ZIP.

---

## Material de consulta

Todo lo que necesitas está en los [temas del curso](../README.md#temas-del-curso). Los más útiles para esta evidencia:

| Para… | Tema |
|-------|------|
| Pasar de tu caso a las tablas | [Del negocio al modelo](../temas/Etapa-1/07-DelNegocioAlModelo.md), [Normalización](../temas/Etapa-1/04-Normalizacion.md) y [Modelo Entidad-Relación](../temas/Etapa-1/05-ModeloEntidadRelacion.md) |
| Dibujar el modelo relacional | [Guía rápida de dbdiagram.io](../temas/Etapa-1/08-dbdiagram.md) |
| Elegir los tipos de datos | [Tipos de datos en SQL Server](../temas/Etapa-2/04-TiposDeDatos.md) |
| Escribir las restricciones | [Constraints](../temas/Etapa-3/04-Constraints.md) |
| Armar la instalación y la reversa | [Paquete de instalación y reversa](../temas/Etapa-3/07-InstalacionReversa.md) |
| Escribir las consultas | [Consultas simples](../temas/Etapa-3/06-ConsultasSimples.md) y los temas de la [Etapa 4](../README.md#etapa-4--consultas-multitabla) |

---

## Entregables

Cuatro archivos:

| Archivo | Contenido |
|---------|-----------|
| `Instalacion.ZIP` | Los scripts de instalación (`.sql`), numerados en el orden en que se ejecutan: `01-create-database.sql`, `02-create-table-...sql`, ..., `NN-insert-...sql` |
| `Reversa.ZIP` | Los scripts de reversa (`.sql`), numerados en el orden en que se ejecutan: primero se eliminan las tablas en orden inverso a las llaves foráneas y al final la base de datos |
| `Consultas.ZIP` | **Diez** archivos, uno por consulta: `01-consulta.sql` a `10-consulta.sql` |
| `EvidenciaIntegral_ApellidoNombre_Matricula.pdf` | El documento con la estructura de abajo |

### Las consultas van en `Consultas.ZIP`, no en el PDF

Cada archivo de `Consultas.ZIP` contiene **solo el código SQL** de una consulta, listo para ejecutarse en SSMS **después de la instalación**, con la base de datos de tu caso seleccionada. No incluyas resultados, capturas de pantalla ni explicaciones. Al inicio de cada archivo va un comentario con el número y la pregunta:

```sql
-- Consulta N: (aquí va la pregunta de la consulta, tal como viene en tu caso)
SELECT ...
FROM ...
```

> Las consultas **no** se escriben en el PDF. El profesor instala tu base de datos con tu paquete de instalación y ejecuta cada archivo de `Consultas.ZIP` sobre ella.

### Estructura del PDF

Todos los documentos deben tener exactamente esta estructura, con estos títulos y en este orden:

```
Portada
    Nombre completo, matrícula, número de alumno y nombre del caso

1. Modelo relacional
    Imagen del diagrama generado en dbdiagram.io (https://dbdiagram.io)

2. Descripción del negocio y de la base de datos
    El negocio con tus palabras y qué guarda la base de datos

3. Plan de instalación
    Tabla: orden, nombre del script y qué hace

4. Plan de reversa
    Tabla: orden, nombre del script y qué hace, incluida la nota de seleccionar
    otra base de datos en SSMS antes de eliminar la base de datos

5. Decisiones de diseño
    Un apartado por tabla: por qué existe, de qué tabla depende y por qué
    (dónde va cada llave foránea), para qué sirve cada restricción y, si la
    tabla copia un dato que puede cambiar (precio, tarifa), por qué lo copia
```

---

## Convenciones de código

- Palabras reservadas SQL en **MAYÚSCULAS** (`SELECT`, `FROM`, `WHERE`, `CREATE TABLE`, etc.).
- Nombres de tablas y columnas en **PascalCase** y en **singular** (`Cliente`, `FechaRenta`).
- Columnas ID con prefijo `id` + nombre de la tabla (`idCliente`, `idBicicleta`).
- Cada script inicia con un comentario de cabecera con tema, descripción y autor.
- `SELECT` y `FROM` en líneas separadas; máximo 5 campos por renglón.
- Los `INSERT` siempre mencionan las columnas.
- Sin `GO`. Cada script, excepto el que crea la base de datos y el que la elimina, empieza con `USE <TuBase>;` (por ejemplo, `USE LavaExpressDB;`), para que se ejecute sobre la base correcta sin depender del dropdown de SSMS.

### SQL permitido en las consultas

Solo lo visto en el curso: `SELECT`, alias con `AS`, `WHERE` (`=`, `<>`, `>`, `<`, `>=`, `<=`, `AND`, `OR`, `NOT`, `BETWEEN`, `LIKE`, `IN`, `IS NULL`), `ORDER BY`, `TOP`, `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN`, `MONTH()`, `YEAR()`, `DAY()` y concatenación con `+`. No uses `GROUP BY`, `HAVING`, funciones de agregado, subconsultas ni `CASE`: son temas de Base de Datos II.

---

## Forma de entrega

- **Modalidad:** individual.
- **Plataforma:** Microsoft Teams, equipo *760 A2026 Base de Datos I REGULARIZACION 1*, tarea **Evidencia Integral Base de Datos I**. Sube los cuatro archivos en la misma tarea.
- **Fecha y hora límite:** viernes 20 de noviembre de 2026, 10:00 p.m.
