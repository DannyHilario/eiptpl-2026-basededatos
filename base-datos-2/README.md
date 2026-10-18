# Base de Datos II

Continuación del curso de **Base de Datos** con el mismo grupo, usando Microsoft SQL Server. Corresponde al semestre **Agosto-Diciembre '26**.

Las convenciones de código SQL, el motor objetivo y el alcance temático son los mismos que en [Base de Datos I](../base-datos-1) (semestre **Enero-Junio '26**) — ver [CLAUDE.md](../CLAUDE.md) en la raíz del repositorio.

---

## Requisitos

- [SQL Server 2019 o superior](https://www.microsoft.com/es-mx/sql-server/sql-server-downloads) (Express es suficiente)
- [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/es-es/sql/ssms/download-sql-server-management-studio-ssms)

---

## Estructura del repositorio

```
base-datos-2/
├── temas/                 # Material de estudio, por etapa del manual del curso
│   ├── Etapa-1/           # Vistas: cláusulas, funciones, operadores y vistas
│   ├── Etapa-2/           # Procedimientos almacenados: variables, IF/ELSE y validaciones
│   └── Etapa-3/           # Funciones definidas por el usuario y triggers
└── sesiones/
    ├── sesion-1/          # RestauranteDB (Comanda) — funciones de agregado
    ├── sesion-2/          # CineDB — funciones escalares y vistas
    ├── sesion-3/          # CineDB — variables y procedimientos almacenados
    ├── sesion-4/          # CineDB — validaciones y manejo de errores en SPs
    ├── sesion-5-6/        # CompuStoreDB — modelado, N:N, auditoría y constraints (dos sábados de trabajo)
    ├── sesion-7/          # HospitalDB — modelo base para Evidencias 1 y 2
    ├── examen-medio-termino/  # SistemaBancarioBD — examen práctico (función, vista y SP por alumno)
    └── sesion-11/         # AutoFixDB (versión BD2) — triggers
```

Se irá ampliando conforme avancen las sesiones del semestre.

---

## Temas del curso

Los temas siguen las etapas del manual de Base de Datos II (PEMA 2022) — ver [ContenidoTematico.md](ContenidoTematico.md). Todos los ejemplos usan **AutoFixDB**, que se instala desde la [sesión 11](sesiones/sesion-11/AutoFixDB), y se ejecutaron en SQL Server con sus datos.

### Etapa 1 — Vistas

| # | Tema |
|---|------|
| 01 | [Cláusulas SQL: DISTINCT, GROUP BY y HAVING](temas/Etapa-1/01-Clausulas.md) |
| 02 | [Funciones de agregado](temas/Etapa-1/02-FuncionesAgregado.md) |
| 03 | [Funciones escalares](temas/Etapa-1/03-FuncionesEscalares.md) |
| 04 | [Operadores para definir los criterios de consulta](temas/Etapa-1/04-Operadores.md) |
| 05 | [Vistas y manipulación de una vista](temas/Etapa-1/05-Vistas.md) |

### Etapa 2 — Procedimientos almacenados

| # | Tema |
|---|------|
| 01 | [Procedimientos almacenados y sus tipos](temas/Etapa-2/01-ProcedimientosAlmacenados.md) |
| 02 | [Crear y ejecutar un procedimiento almacenado](temas/Etapa-2/02-CrearEjecutar.md) |
| 03 | [Variables e IF / ELSE](temas/Etapa-2/03-VariablesIfElse.md) |
| 04 | [Validaciones y códigos de salida](temas/Etapa-2/04-Validaciones.md) |
| 05 | [Modificar y eliminar un procedimiento almacenado](temas/Etapa-2/05-ModificarEliminar.md) |

### Etapa 3 — Funciones y triggers

| # | Tema |
|---|------|
| 01 | [Funciones definidas por el usuario](temas/Etapa-3/01-FuncionesDefinidasUsuario.md) |
| 02 | [Triggers: qué son, para qué sirven y cómo se crean](temas/Etapa-3/02-Triggers.md) |
| 03 | [Las tablas inserted y deleted](temas/Etapa-3/03-InsertedDeleted.md) |
| 04 | [Activación y desactivación de triggers](temas/Etapa-3/04-ActivarDesactivar.md) |

## Sesiones

| Sesión | Base de datos | Descripción |
|--------|---------------|-------------|
| [Sesión 1](sesiones/sesion-1) | RestauranteDB | Funciones de agregado, `GROUP BY`, `HAVING` — tabla `Comanda` (reutilizada de Base de Datos I) |
| [Sesión 2](sesiones/sesion-2) | CineDB | Funciones escalares (`UPPER`, `LOWER`, `ROUND`, `CAST`, `SUBSTRING`, `LEN`, concatenación) y vistas (`CREATE VIEW`) — CineDB reutilizada de Base de Datos I |
| [Sesión 3](sesiones/sesion-3) | CineDB | Variables T-SQL, `IF`/`ELSE`, y procedimientos almacenados (`CREATE`/`ALTER PROCEDURE`) |
| [Sesión 4](sesiones/sesion-4) | CineDB | Validaciones en procedimientos almacenados y patrón de manejo de errores con códigos de salida |
| [Sesión 5-6](sesiones/sesion-5-6) | CompuStoreDB | Modelado desde cero (relación N:N con tabla puente, historial de precios), campos de auditoría, baja lógica, constraints (`PK`, `FK`, `UNIQUE`, `CHECK`, `DEFAULT`), CRUD completo con SPs, funciones, vistas y datos demo |
| [Sesión 7](sesiones/sesion-7) | HospitalDB | Modelo base para Evidencias 1 y 2 (vistas/funciones y procedimientos almacenados, uno distinto por alumno) — tablas, constraints y datos iniciales instalados |
| [Examen de Medio Término](sesiones/examen-medio-termino) | SistemaBancarioBD | Examen práctico en línea: cada alumno crea una función, una vista y un procedimiento almacenado sobre un modelo bancario (sucursales, clientes, tarjetas de crédito y movimientos) — [instrucciones y ejercicios](sesiones/examen-medio-termino/entregables/descripcion-examen.md) |
| [Sesión 11](sesiones/sesion-11) | AutoFixDB | Triggers (`AFTER`, `INSTEAD OF`, tablas `inserted` y `deleted`, activación y desactivación) — AutoFixDB de Base de Datos I ampliada con un procedimiento almacenado, una tabla de auditoría y dos triggers |

---

## Cómo usar los scripts

1. Abre **SSMS** y conéctate a tu servidor local.
2. Crea o selecciona la base de datos desde el menú desplegable.
3. Abre el archivo `.sql` correspondiente.
4. Ejecuta con **F5** o el botón **Execute**.

> Cada carpeta de sesión incluye un `README.md` con el contexto y el detalle de lo trabajado.
