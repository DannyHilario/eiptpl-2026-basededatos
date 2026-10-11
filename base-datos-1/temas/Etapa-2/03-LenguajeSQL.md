# El Lenguaje SQL

## ¿Qué es SQL?

SQL (Structured Query Language) es el lenguaje estándar para comunicarse con bases de datos relacionales. Fue creado en los años 70 y desde entonces existe un estándar internacional (ISO/ANSI) que define un conjunto de instrucciones que cualquier motor relacional debe soportar.

Esto significa que lo fundamental que aprendas en SQL Server lo podrás aplicar en PostgreSQL, Oracle, MySQL u otro motor relacional. El núcleo del lenguaje es el mismo.

---

## SQL Estándar: el núcleo portable

El estándar SQL define las instrucciones que son comunes a todos los motores. Ejemplos:

- Crear y eliminar tablas (`CREATE TABLE`, `DROP TABLE`)
- Insertar, modificar y eliminar datos (`INSERT`, `UPDATE`, `DELETE`)
- Consultar datos (`SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`)
- Combinar tablas (`JOIN`)
- Definir restricciones (`PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`)

Un `SELECT` básico escrito hoy en SQL Server funcionará exactamente igual en PostgreSQL o en Oracle. Esa portabilidad es una de las grandes ventajas de aprender SQL.

---

## Las extensiones: cuando cada motor agrega lo suyo

Aunque el estándar es robusto, cada motor de base de datos agrega su propia capa de funcionalidades sobre ese núcleo. Estas extensiones permiten hacer cosas más avanzadas, pero **no son portables** entre motores.

| Motor | Nombre de su extensión |
|-------|------------------------|
| Microsoft SQL Server | **T-SQL** (Transact-SQL) |
| PostgreSQL | **PL/pgSQL** |
| Oracle | **PL/SQL** |
| MySQL | No tiene nombre formal |

En este curso trabajaremos con **T-SQL**, la extensión de SQL Server.

---

## Los tres grupos de sentencias SQL

Las sentencias de SQL se dividen en tres grupos, según lo que hacen:

| Grupo | Nombre | Para qué sirve | Sentencias |
|-------|--------|----------------|------------|
| **DDL** | *Data Definition Language*, lenguaje de definición de datos | Crear, modificar y eliminar la **estructura**: bases de datos, tablas | `CREATE`, `ALTER`, `DROP` |
| **DML** | *Data Manipulation Language*, lenguaje de manipulación de datos | Insertar, consultar, modificar y borrar los **datos** dentro de las tablas | `INSERT`, `SELECT`, `UPDATE`, `DELETE` |
| **DCL** | *Data Control Language*, lenguaje de control de datos | Dar o quitar **permisos** a los usuarios | `GRANT`, `REVOKE` |

Una forma sencilla de distinguirlos:

- **DDL** trabaja con el **mueble**: crea el librero, le agrega una repisa, lo tira.
- **DML** trabaja con lo que hay **dentro**: mete libros, los busca, los cambia de lugar, los saca.
- **DCL** decide **quién** puede abrir el librero.

En el curso se usan DDL (ver [DDL](../Etapa-3/01-DDL.md) y [Modificar y eliminar estructuras](../Etapa-3/05-ModificarEstructura.md)) y DML (ver [DML](../Etapa-3/02-DML.md)). DCL lo administra quien está a cargo del servidor; basta con saber qué es.

---

## T-SQL vs PL/pgSQL: una comparación

Para ilustrar cómo varían las extensiones, veamos algunas diferencias concretas entre T-SQL (SQL Server) y PL/pgSQL (PostgreSQL):

### Tipos de datos para texto

| Propósito | T-SQL (SQL Server) | PL/pgSQL (PostgreSQL) |
|-----------|--------------------|-----------------------|
| Texto de longitud fija | `CHAR(n)` | `CHAR(n)` |
| Texto de longitud variable | `VARCHAR(n)` | `VARCHAR(n)` |
| Texto largo sin límite | `VARCHAR(MAX)` | `TEXT` |

### Obtener la fecha y hora actual

| Motor | Instrucción |
|-------|-------------|
| SQL Server | `GETDATE()` |
| PostgreSQL | `NOW()` |

Ambas devuelven el mismo resultado, pero la función tiene distinto nombre.

### Limitar resultados de una consulta

| Motor | Sintaxis |
|-------|----------|
| SQL Server | `SELECT TOP 10 ...` |
| PostgreSQL | `SELECT ... LIMIT 10` |

Misma intención, sintaxis completamente diferente.

### Manejo de errores

| Motor | Mecanismo |
|-------|-----------|
| SQL Server | `BEGIN TRY ... END TRY / BEGIN CATCH ... END CATCH` |
| PostgreSQL | `BEGIN ... EXCEPTION WHEN ... END` |

---

## ¿Qué significa esto en la práctica?

Imagina que aprendes a escribir consultas en SQL Server y luego trabajas en una empresa que usa PostgreSQL. Las consultas básicas (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) funcionarán igual. Pero si escribiste lógica avanzada usando funciones o manejo de errores propios de T-SQL, tendrás que reescribir esa parte.

En resumen:

- **SQL estándar** → portable entre motores
- **T-SQL / PL/pgSQL / etc.** → específico de cada motor, no portable

Por eso es importante distinguir siempre qué estás escribiendo: ¿SQL estándar o una extensión del motor?
