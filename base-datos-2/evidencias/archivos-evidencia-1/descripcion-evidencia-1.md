# Evidencia 1: Vistas y Funciones sobre HospitalDB

De manera **individual**, resolverás un ejercicio de creación de una vista (`CREATE VIEW`) o una función escalar definida por el usuario (`CREATE FUNCTION`) sobre la base de datos `HospitalDB`. Cada alumno tiene asignado un ejercicio distinto — busca tu nombre en la lista de abajo para encontrar el tuyo.

---

## Base de datos de práctica

Instala `HospitalDB` siguiendo el plan de instalación completo en [`sesiones/sesion-7/HospitalDB/instalar-completo.sql`](../../sesiones/sesion-7/HospitalDB/instalar-completo.sql) (o script por script desde [`instalacion/`](../../sesiones/sesion-7/HospitalDB/instalacion), en el orden de la tabla del [README de la sesión](../../sesiones/sesion-7/README.md)). Ahí también puedes consultar el diccionario de datos de cada tabla en [`docs/tablas`](../../sesiones/sesion-7/HospitalDB/docs/tablas).

---

## Tu ejercicio

Abre tu ficha — ahí está la descripción completa del objeto que debes crear, con contexto de negocio, criterios de aceptación y un ejemplo del resultado esperado:

| Alumno | Ejercicio |
|--------|-----------|
| Aguilar Hernandez Marcos Fernando | [`vw_DetalleRecetaCompleta`](alumnos/aguilar-hernandez-marcos-fernando.md) |
| Espinoza Juarez Angel De Jesus | [`vw_ConsultaCompleta`](alumnos/espinoza-juarez-angel-de-jesus.md) |
| Garcia Martinez Marisol | [`ufn_totalLineasReceta`](alumnos/garcia-martinez-marisol.md) |
| Gomez Ordaz Bryan Omar | [`vw_MedicoEspecialidadCompleta`](alumnos/gomez-ordaz-bryan-omar.md) |
| Hernandez Juarez Brenda Ivonne | [`ufn_totalConsultasPorMedico`](alumnos/hernandez-juarez-brenda-ivonne.md) |
| Hernandez Martínez Alexander Kalet | [`vw_MedicoActivo`](alumnos/hernandez-martinez-alexander-kalet.md) |
| Hernandez Perez Jose Ivan | [`ufn_totalPacientesPorMedico`](alumnos/hernandez-perez-jose-ivan.md) |
| Mejia Garcia Ricardo Azael | [`vw_ConsultaPendiente`](alumnos/mejia-garcia-ricardo-azael.md) |
| Mendez Cantu Raúl Ángel | [`ufn_nombreCompletoPaciente`](alumnos/mendez-cantu-raul-angel.md) |
| Montoya Moreno Ana Valeria | [`ufn_totalEspecialidadesPorMedico`](alumnos/montoya-moreno-ana-valeria.md) |
| Morales Azuara Eduardo Gabriel | [`ufn_nombreCompletoMedico`](alumnos/morales-azuara-eduardo-gabriel.md) |
| Perez Morales Johan Valente | [`vw_PacienteActivo`](alumnos/perez-morales-johan-valente.md) |
| Rodriguez Moreno Ricardo | [`vw_RecetaVigente`](alumnos/rodriguez-moreno-ricardo.md) |
| Ruiz Olguin Alejandro | [`ufn_totalRecetasPorEstatus`](alumnos/ruiz-olguin-alejandro.md) |
| Sifuentes Emiliano Mucio Rafael | [`vw_BitacoraRecetaDetalle`](alumnos/sifuentes-emiliano-mucio-rafael.md) |
| Vazquez Anaya Johann Adad | [`ufn_estatusVigenteReceta`](alumnos/vazquez-anaya-johann-adad.md) |
| Villanueva Mata Brandon Gabriel | [`ufn_edadPaciente`](alumnos/villanueva-mata-brandon-gabriel.md) |

---

## Convenciones de código

Tu script debe seguir las convenciones SQL del curso (`CLAUDE.md` del repositorio):

- Palabras reservadas en **MAYÚSCULAS** (`SELECT`, `CREATE VIEW`, `WHERE`, etc.).
- Nombre de tu objeto exactamente como se indica en tu ficha (respeta mayúsculas/minúsculas).
- `SELECT` y `FROM` en líneas separadas; los campos comienzan en la misma línea del `SELECT`, máximo 5 campos por renglón.
- Comentario de cabecera al inicio del script: tema, descripción y tu nombre como autor.
- Incluye `USE HospitalDB;` seguido de `GO` antes de tu `CREATE VIEW`/`CREATE FUNCTION` — en SQL Server, `CREATE VIEW` y `CREATE FUNCTION` deben ser la única sentencia de su batch, y el `GO` es lo que separa ese batch del resto del script.

---

## Entregables

Un solo archivo de **texto plano (`.txt`)** que contenga el código SQL de tu objeto (`CREATE VIEW` o `CREATE FUNCTION`), listo para copiar, pegar y ejecutar tal cual en SQL Server Management Studio contra `HospitalDB`.

> Es `.txt` y no `.sql` porque NEXUS no acepta esa extensión — el contenido es igual de código SQL.

Nombra tu archivo de la siguiente forma:

```
EV1_ApellidoNombre_Matricula.txt
```

*Ejemplo: `EV1_AguilarHernandezMarcosFernando_2254024.txt`*

---

## Forma de Entrega

- **Modalidad:** Individual. Cada alumno debe cargar su propio archivo.
- **Plataforma:** NEXUS, en el apartado *"1.2 - Evidencia de aprendizaje: Laboratorio"*.
- **Fecha de entrega:** Viernes 25 de septiembre de 2026.
- **Hora límite:** 10:00 p.m.

---

## Rúbrica de Evaluación

| CRITERIO / NIVEL DE DOMINIO | Evidencia completa | Evidencia suficiente | Evidencia débil | Sin evidencia |
|-----------------------------|--------------------|-----------------------|-------------------|-----------------|
| **Conocimientos** — Identifica los comandos y funciones necesarias para crear vistas o funciones definidas por el usuario. | **3** — Identifica y aplica correctamente los comandos para crear vistas o funciones (`CREATE VIEW` / `CREATE FUNCTION`), así como el uso de `JOIN`, funciones de agregado y escalares, y los operadores de filtro necesarios para el objeto que le tocó resolver. | **2** — Identifica la mayoría de esos comandos y funciones, pero comete errores menores de sintaxis o de uso. | **1** — Identifica escasamente los comandos y funciones señaladas, y no distingue correctamente su uso dentro de una sentencia `SELECT`. | **0** — No presenta evidencia de la actividad. |
| **Habilidades** — Resuelve el ejercicio propuesto con una estructura y sintaxis correcta. | **5** — Resuelve el ejercicio cumpliendo el 100% de los criterios de aceptación de su ficha, con estructura y sintaxis correcta, y comprueba que el resultado generado es correcto contra los datos de `HospitalDB`. | **4** — Cumple al menos el 50% de los criterios de aceptación de su ficha, con estructura y sintaxis correcta, y comprueba que el resultado de lo resuelto es correcto. | **3** — Cumple menos del 50% de los criterios de aceptación de su ficha, o el objeto presenta errores de sintaxis que impiden comprobar el resultado. | **0** — No presenta evidencia de la actividad. |
| **Actitudes / Valores** — Entrega en tiempo y forma. | **2** — Presenta en tiempo y forma, cuidando la calidad de la actividad. | **1** — Presenta fuera de tiempo y forma, cuidando la calidad de la actividad. | **0** — Presenta fuera de tiempo y forma, la calidad de la actividad no es la esperada. | **0** — No presenta evidencia de la actividad. |
