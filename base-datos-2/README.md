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
└── sesiones/
    ├── sesion-1/          # RestauranteDB (Comanda) — funciones de agregado
    ├── sesion-2/          # CineDB — funciones escalares y vistas
    ├── sesion-3/          # CineDB — variables y procedimientos almacenados
    ├── sesion-4/          # CineDB — validaciones y manejo de errores en SPs
    ├── sesion-5-6/        # CompuStoreDB — modelado, N:N, auditoría y constraints (dos sábados de trabajo)
    └── sesion-7/          # HospitalDB — modelo base para Evidencias 1 y 2
```

Se irá ampliando conforme avancen las sesiones del semestre.

## Sesiones

| Sesión | Base de datos | Descripción |
|--------|---------------|-------------|
| [Sesión 1](sesiones/sesion-1) | RestauranteDB | Funciones de agregado, `GROUP BY`, `HAVING` — tabla `Comanda` (reutilizada de Base de Datos I) |
| [Sesión 2](sesiones/sesion-2) | CineDB | Funciones escalares (`UPPER`, `LOWER`, `ROUND`, `CAST`, `SUBSTRING`, `LEN`, concatenación) y vistas (`CREATE VIEW`) — CineDB reutilizada de Base de Datos I |
| [Sesión 3](sesiones/sesion-3) | CineDB | Variables T-SQL, `IF`/`ELSE`, y procedimientos almacenados (`CREATE`/`ALTER PROCEDURE`) |
| [Sesión 4](sesiones/sesion-4) | CineDB | Validaciones en procedimientos almacenados y patrón de manejo de errores con códigos de salida |
| [Sesión 5-6](sesiones/sesion-5-6) | CompuStoreDB | Modelado desde cero (relación N:N con tabla puente, historial de precios), campos de auditoría, baja lógica, constraints (`PK`, `FK`, `UNIQUE`, `CHECK`, `DEFAULT`), CRUD completo con SPs, funciones, vistas y datos demo |
| [Sesión 7](sesiones/sesion-7) | HospitalDB | Modelo base para Evidencias 1 y 2 (vistas/funciones y procedimientos almacenados, uno distinto por alumno) — tablas, constraints y datos iniciales instalados |

---

## Cómo usar los scripts

1. Abre **SSMS** y conéctate a tu servidor local.
2. Crea o selecciona la base de datos desde el menú desplegable.
3. Abre el archivo `.sql` correspondiente.
4. Ejecuta con **F5** o el botón **Execute**.

> Cada carpeta de sesión incluye un `README.md` con el contexto y el detalle de lo trabajado.
