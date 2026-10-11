# Base de Datos I

Materiales, scripts y ejercicios del curso de **Base de Datos I** (BD-434), semestre **Enero-Junio '26**, impartido con Microsoft SQL Server. El curso continúa en [Base de Datos II](../base-datos-2), semestre **Agosto-Diciembre '26**.

---

## Requisitos

- [SQL Server 2019 o superior](https://www.microsoft.com/es-mx/sql-server/sql-server-downloads) (Express es suficiente)
- [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/es-es/sql/ssms/download-sql-server-management-studio-ssms)

---

## Estructura del repositorio

```
base-datos-1/
├── temas/                        # Material de estudio, por etapa del manual del curso
│   ├── Etapa-1/                  # Diseño: conceptos, llaves, normalización, E-R, modelo relacional
│   ├── Etapa-2/                  # Entorno: SQL Server, lenguaje SQL, tipos de datos
│   ├── Etapa-3/                  # Transact-SQL: DDL, DML, constraints, consultas simples
│   └── Etapa-4/                  # Consultas multitabla (JOINs)
├── sesiones/                     # Scripts SQL organizados por sesión
│   ├── sesion-7/                 # CursoDB — ejercicios de DDL y DML
│   ├── sesion-8/                 # ViajeYA — solución Evidencia 2, Ejercicio 3
│   ├── sesion-9/                 # EscuelaDB — catálogo de técnicas y alumnos
│   ├── sesion-10/                # AutoFixDB — taller mecánico con 4 tablas
│   ├── sesion-final/             # CineDB — repaso integral con 8 tablas
│   ├── examen-final/             # BancoDB — examen final
│   └── examen-extraordinario/    # ComedorDB — 2da oportunidad
├── evidencias/                   # Material de evaluación del semestre
│   ├── archivos-evidencia-1/     # Conjuntos de datos y ejemplo resuelto
│   ├── archivos-evidencia-2/     # Descripción y ejercicios por equipo
│   ├── archivos-evidencia-3/     # Base de datos RestauranteDB
│   └── archivos-pia/             # Descripción y ejercicios del PIA por equipo
└── 3ra-5ta-oportunidad/          # Evidencia Integral: un caso de negocio por alumno
```

---

## Temas del curso

Los temas siguen las cuatro etapas del manual de Base de Datos I (PEMA 2022). Access se usa solo al inicio, como herramienta visual para entender la normalización; todo el trabajo práctico es en SQL Server.

### Etapa 1 — Diseño de una base de datos relacional

| # | Tema |
|---|------|
| 01 | [Conceptos básicos](temas/Etapa-1/01-ConceptosBasicos.md) |
| 02 | [Pasos para diseñar una base de datos](temas/Etapa-1/02-PasosDiseno.md) |
| 03 | [Los tres tipos de llaves](temas/Etapa-1/03-TiposDeClaves.md) |
| 04 | [Normalización](temas/Etapa-1/04-Normalizacion.md) |
| 05 | [Modelo Entidad-Relación y cardinalidad](temas/Etapa-1/05-ModeloEntidadRelacion.md) |
| 06 | [El modelo relacional](temas/Etapa-1/06-ModeloRelacional.md) |
| 07 | [Del negocio al modelo](temas/Etapa-1/07-DelNegocioAlModelo.md) |
| 08 | [Guía rápida de dbdiagram.io](temas/Etapa-1/08-dbdiagram.md) |
| 09 | [Ejercicio de modelado (HotelVista)](temas/Etapa-1/09-Ejercicio-Modelado.md) |

### Etapa 2 — Entorno de SQL Server

| # | Tema |
|---|------|
| 01 | [Introducción a Microsoft SQL Server](temas/Etapa-2/01-IntroduccionMSSQL.md) |
| 02 | [¿Qué es un servidor de base de datos?](temas/Etapa-2/02-IntroduccionServidores.md) |
| 03 | [El lenguaje SQL (DDL, DML y DCL)](temas/Etapa-2/03-LenguajeSQL.md) |
| 04 | [Tipos de datos en SQL Server](temas/Etapa-2/04-TiposDeDatos.md) |

### Etapa 3 — Sentencias Transact-SQL

| # | Tema |
|---|------|
| 01 | [DDL — Definición de datos](temas/Etapa-3/01-DDL.md) |
| 02 | [DML — Manipulación de datos](temas/Etapa-3/02-DML.md) |
| 03 | [Ejercicio 1 (tabla Alumno)](temas/Etapa-3/03-Ejercicio-1.md) |
| 04 | [Constraints e integridad referencial](temas/Etapa-3/04-Constraints.md) |
| 05 | [Modificar y eliminar estructuras: ALTER, TRUNCATE y DROP](temas/Etapa-3/05-ModificarEstructura.md) |
| 06 | [Consultas simples](temas/Etapa-3/06-ConsultasSimples.md) |
| 07 | [Paquete de instalación y paquete de reversa](temas/Etapa-3/07-InstalacionReversa.md) |

### Etapa 4 — Consultas multitabla

| # | Tema |
|---|------|
| 01 | [Consultas simples y combinadas](temas/Etapa-4/01-DiferenciaConsultas.md) |
| 02 | [INNER JOIN](temas/Etapa-4/02-INNER-JOIN.md) |
| 03 | [LEFT JOIN y RIGHT JOIN](temas/Etapa-4/03-LEFT-RIGHT-JOIN.md) |
| 04 | [FULL JOIN](temas/Etapa-4/04-FULL-JOIN.md) |
| 05 | [Ejercicio (EscuelaDB)](temas/Etapa-4/05-Ejercicio-1.md) |

### Sesión Final — Repaso Integral

| Base de datos | Descripción |
|---------------|-------------|
| CineDB | 8 tablas, 90 funciones, 100 boletos — 20 consultas que cubren todos los temas del curso |

---

## Cómo usar los scripts

1. Abre **SSMS** y conéctate a tu servidor local.
2. Crea o selecciona la base de datos desde el menú desplegable.
3. Abre el archivo `.sql` correspondiente.
4. Ejecuta con **F5** o el botón **Execute**.

> Cada carpeta de sesión incluye un `README.md` con el orden de ejecución de los scripts.

---

## Convenciones del código SQL

- Palabras reservadas en `MAYÚSCULAS` (`SELECT`, `FROM`, `WHERE`)
- Nombres de tablas y columnas en `PascalCase`
- Columnas de llave primaria con prefijo `id` (`idCliente`, `idServicio`)
- Cada script incluye un encabezado con tema, descripción y autor
