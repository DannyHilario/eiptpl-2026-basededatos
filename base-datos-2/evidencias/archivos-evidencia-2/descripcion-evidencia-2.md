# Evidencia 2: Procedimientos Almacenados sobre HospitalDB

De manera **individual**, resolverás **dos** ejercicios de creación de un procedimiento almacenado (`CREATE PROCEDURE`) sobre la base de datos `HospitalDB`. Cada alumno tiene asignados dos ejercicios distintos — busca tu nombre en la lista de abajo para encontrar los tuyos.

---

## Base de datos de práctica

Instala `HospitalDB` siguiendo el plan de instalación completo en [`sesiones/sesion-7/HospitalDB/instalar-completo.sql`](../../sesiones/sesion-7/HospitalDB/instalar-completo.sql) (o script por script desde [`instalacion/`](../../sesiones/sesion-7/HospitalDB/instalacion), en el orden de la tabla del [README de la sesión](../../sesiones/sesion-7/README.md)). Ahí también puedes consultar el diccionario de datos de cada tabla en [`docs/tablas`](../../sesiones/sesion-7/HospitalDB/docs/tablas) y, para los 5 procedimientos que ya vienen instalados de referencia (`usp_insertarConsulta`, `usp_efectuarConsulta`, `usp_generarReceta`, `usp_cambiarEstatusReceta`, `usp_insertarBitacoraEstatusReceta`), su documentación en [`docs/procedimientos`](../../sesiones/sesion-7/HospitalDB/docs/procedimientos).

> Algunos de tus ejercicios pueden pedirte invocar (`EXEC`) uno de esos 5 procedimientos ya instalados — nunca tienes que crearlos tú, ya existen en la base de datos desde la instalación.

---

## Tus ejercicios

Abre tu ficha — ahí está la descripción completa de tus dos procedimientos, con contexto de negocio, criterios de aceptación y un ejemplo del resultado esperado:

| Alumno | Ficha |
|--------|-------|
| Aguilar Hernandez Marcos Fernando | [`Ejercicios`](alumnos/aguilar-hernandez-marcos-fernando.md) |
| Espinoza Juarez Angel De Jesus | [`Ejercicios`](alumnos/espinoza-juarez-angel-de-jesus.md) |
| Garcia Martinez Marisol | [`Ejercicios`](alumnos/garcia-martinez-marisol.md) |
| Gomez Ordaz Bryan Omar | [`Ejercicios`](alumnos/gomez-ordaz-bryan-omar.md) |
| Hernandez Juarez Brenda Ivonne | [`Ejercicios`](alumnos/hernandez-juarez-brenda-ivonne.md) |
| Hernandez Martínez Alexander Kalet | [`Ejercicios`](alumnos/hernandez-martinez-alexander-kalet.md) |
| Hernandez Perez Jose Ivan | [`Ejercicios`](alumnos/hernandez-perez-jose-ivan.md) |
| Mejia Garcia Ricardo Azael | [`Ejercicios`](alumnos/mejia-garcia-ricardo-azael.md) |
| Mendez Cantu Raúl Ángel | [`Ejercicios`](alumnos/mendez-cantu-raul-angel.md) |
| Montoya Moreno Ana Valeria | [`Ejercicios`](alumnos/montoya-moreno-ana-valeria.md) |
| Morales Azuara Eduardo Gabriel | [`Ejercicios`](alumnos/morales-azuara-eduardo-gabriel.md) |
| Perez Morales Johan Valente | [`Ejercicios`](alumnos/perez-morales-johan-valente.md) |
| Rodriguez Moreno Ricardo | [`Ejercicios`](alumnos/rodriguez-moreno-ricardo.md) |
| Ruiz Olguin Alejandro | [`Ejercicios`](alumnos/ruiz-olguin-alejandro.md) |
| Sifuentes Emiliano Mucio Rafael | [`Ejercicios`](alumnos/sifuentes-emiliano-mucio-rafael.md) |
| Vazquez Anaya Johann Adad | [`Ejercicios`](alumnos/vazquez-anaya-johann-adad.md) |
| Villanueva Mata Brandon Gabriel | [`Ejercicios`](alumnos/villanueva-mata-brandon-gabriel.md) |

---

## Convenciones de código

Tu script debe seguir las convenciones SQL del curso (`CLAUDE.md` del repositorio):

- Palabras reservadas en **MAYÚSCULAS** (`SELECT`, `CREATE PROCEDURE`, `WHERE`, `IF`, etc.).
- Nombre de tu procedimiento exactamente como se indica en tu ficha (respeta mayúsculas/minúsculas).
- `SELECT` y `FROM` en líneas separadas; los campos comienzan en la misma línea del `SELECT`, máximo 5 campos por renglón.
- Comentario de cabecera al inicio del script: tema, descripción y tu nombre como autor.
- Incluye `USE HospitalDB;` seguido de `GO` antes de tu `CREATE PROCEDURE` — debe ser la única sentencia de su batch.
- Sigue el patrón de validaciones visto en clase: variables `@ErrCodigo varchar(10)` y `@ErrMensaje varchar(200)`, un `SELECT` de esas dos columnas después de cada validación fallida (con `RETURN`), y `000000` como código de éxito.

---

## Entregables

**Dos** archivos de texto plano (`.txt`), uno por cada ejercicio, con el código SQL completo de tu procedimiento (`CREATE PROCEDURE`), listo para copiar, pegar y ejecutar tal cual en SQL Server Management Studio contra `HospitalDB`.

> Son `.txt` y no `.sql` porque NEXUS no acepta esa extensión — el contenido es igual de código SQL.

Nombra tus archivos de la siguiente forma:

```
EV2_ApellidoNombre_Matricula_Ejercicio1.txt
EV2_ApellidoNombre_Matricula_Ejercicio2.txt
```

*Ejemplo: `EV2_AguilarHernandezMarcosFernando_2254024_Ejercicio1.txt` y `EV2_AguilarHernandezMarcosFernando_2254024_Ejercicio2.txt`*

---

## Forma de Entrega

- **Modalidad:** Individual. Cada alumno debe cargar sus propios dos archivos.
- **Plataforma:** NEXUS, en el apartado *"2.2 - Evidencia de aprendizaje: Script"*.
- **Fecha de entrega:** Viernes 2 de octubre de 2026.
- **Hora límite:** 10:00 p.m.

---

## Rúbrica de Evaluación

| CRITERIO / NIVEL DE DOMINIO | Evidencia completa | Evidencia suficiente | Evidencia débil | Sin evidencia |
|-----------------------------|--------------------|-----------------------|-------------------|-----------------|
| **Conocimientos** — Identifica los comandos y estructuras necesarias para crear un procedimiento almacenado. | **3** — Identifica y distingue el uso de `CREATE`/`ALTER`/`EXEC`/`DROP PROCEDURE`, la declaración y asignación de variables, las estructuras de control (`IF`) y el manejo de validaciones dentro de un procedimiento almacenado. | **2** — Identifica la mayoría de esos comandos y estructuras, pero comete errores menores de sintaxis o de uso. | **1** — Identifica escasamente esos comandos y estructuras, y no distingue correctamente su uso dentro de un procedimiento almacenado. | **0** — No presenta evidencia de la actividad. |
| **Habilidades** — Presenta los ejercicios a resolver con una estructura y sintaxis correcta. | **5** — Presenta la totalidad de los ejercicios cumpliendo el 100% de los criterios de aceptación de su ficha, con estructura y sintaxis correcta, y comprueba que los resultados generados son correctos. | **4** — Presenta la totalidad de los ejercicios, cumpliendo al menos el 50% de los criterios de aceptación de cada uno, con estructura y sintaxis correcta. | **3** — Presenta solo uno de los dos ejercicios, o ambos cumplen menos del 50% de sus criterios de aceptación, o presentan errores de sintaxis que impiden comprobar el resultado. | **0** — No presenta evidencia de la actividad. |
| **Actitudes / Valores** — Entrega en tiempo y forma. | **2** — Presenta en tiempo y forma, cuidando la calidad de la actividad. | **1** — Presenta fuera de tiempo y forma, cuidando la calidad de la actividad. | **0** — Presenta fuera de tiempo y forma, la calidad de la actividad no es la esperada. | **0** — No presenta evidencia de la actividad. |
