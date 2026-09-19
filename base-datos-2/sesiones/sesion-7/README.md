# Sesión 7 — HospitalDB: modelo base para Evidencias 1 y 2

Base de datos nueva para que cada alumno construya sobre el mismo esquema una función + vista (Evidencia 1) y un procedimiento almacenado (Evidencia 2) distintos, de forma que entre los 17 alumnos del grupo se cubra en conjunto una buena parte del CRUD y la lógica de negocio de las tablas.

> **Estado:** tablas, constraints y datos iniciales instalados. `usp_efectuarConsulta`, `usp_generarReceta`, `usp_cambiarEstatusReceta` y `usp_insertarBitacoraEstatusReceta` (flujo completo de consulta → receta → farmacia) ya están escritos como referencia. Las instrucciones del resto de cada evidencia (qué función/vista/SP le toca a cada alumno) se definen más adelante.

---

## Flujo de negocio

Para entender por qué el modelo está diseñado así, es más fácil seguir la historia de una consulta médica de principio a fin que leer las tablas por separado. Aquí está el mapa completo: arriba los pasos del negocio (lo que pasa en la vida real), abajo el SP que implementa cada paso.

```
┌──────────────────────────┐   ┌──────────────────────────┐   ┌──────────────────────────┐   ┌──────────────────────────┐
│        Agendar la        │   │       El paciente        │   │        Se genera         │   │      Farmacia surte      │
│         consulta         │ ▶ │       se presenta        │ ▶ │        la receta         │ ▶ │        o cancela         │
└──────────────────────────┘   └──────────────────────────┘   └──────────────────────────┘   └──────────────────────────┘
              │                              │                              │                              │
              ▼                              ▼                              ▼                              ▼
┌──────────────────────────┐   ┌──────────────────────────┐   ┌──────────────────────────┐   ┌──────────────────────────┐
│   usp_insertarConsulta   │   │   usp_efectuarConsulta   │   │    usp_generarReceta     │   │ usp_cambiarEstatusReceta │
└──────────────────────────┘   └──────────────────────────┘   └──────────────────────────┘   └──────────────────────────┘
                                                                                                           │
                                                                                                           ▼
                                                                                         ┌───────────────────────────────────┐
                                                                                         │ usp_insertarBitacoraEstatusReceta │
                                                                                         │    (interno — deja constancia)    │
                                                                                         └───────────────────────────────────┘
```

Ahora sí, con detalle, un paciente imaginario (Ana) recorriendo los 4 pasos:

1. **Ana agenda una cita** con el Dr. García en el Consultorio 3, para el lunes a las 9:00 am. Esto es [`usp_insertarConsulta`](HospitalDB/docs/procedimientos/usp_insertarConsulta.md): crea el renglón en `Consulta` (paciente, médico, consultorio, fecha), pero antes revisa que el Dr. García y el Consultorio 3 estén libres en ese horario — nadie puede estar en dos citas de 30 minutos que se encimen. Al nacer, la consulta queda marcada `Efectuada = 0`: agendar **no** es lo mismo que "ya pasó".
2. **Llega el lunes y Ana sí se presenta.** La recepción o el propio médico corre [`usp_efectuarConsulta`](HospitalDB/docs/procedimientos/usp_efectuarConsulta.md), que pone `Efectuada = 1`. Si Ana **no** se hubiera presentado, nadie ejecuta este SP y la consulta se queda para siempre con `Efectuada = 0` — así es como el sistema distingue "cita agendada que sí ocurrió" de "cita agendada al aire". No se guarda el motivo de la inasistencia a propósito, para no complicar el modelo.
3. **Con la consulta ya efectuada, el médico genera la receta.** Este es un paso aparte y consciente — [`usp_generarReceta`](HospitalDB/docs/procedimientos/usp_generarReceta.md) — porque no toda consulta termina en receta automáticamente; alguien tiene que decidir generarla, y el SP se asegura de que la consulta sí haya ocurrido antes de crearla. La receta nace en estatus `1 Creada`.
4. **Ana va a farmacia con su receta.** Ahí es donde la receta cambia de estatus: se surte completa (`3 Surtida`), se surte solo una parte (`4 Surtida parcialmente`), o se cancela (`5 Cancelada`) si ya no aplica. Cada uno de estos cambios pasa por [`usp_cambiarEstatusReceta`](HospitalDB/docs/procedimientos/usp_cambiarEstatusReceta.md), que además dispara [`usp_insertarBitacoraEstatusReceta`](HospitalDB/docs/procedimientos/usp_insertarBitacoraEstatusReceta.md) para dejar registrado, con fecha y hora, cada movimiento — es el historial completo de la receta, útil por ejemplo si alguien pregunta "¿cuándo se surtió esto?". Tampoco se guarda el motivo de una cancelación, por la misma razón que en el paso 2.

Con esto, las 11 tablas del modelo quedan cubiertas por al menos un paso del flujo, salvo `DetalleReceta` (línea de medicamentos de la receta — agregarlas es la Evidencia 2 que queda pendiente para los alumnos, ver "Reglas de negocio" abajo).

### Los estatus de una receta, visto como mapa

Una receta no puede saltar a cualquier estatus desde cualquier otro — solo se puede mover por los caminos marcados aquí abajo. Esto es justo lo que valida `usp_cambiarEstatusReceta` (ver la explicación paso a paso en la ficha de [`usp_insertarBitacoraEstatusReceta`](HospitalDB/docs/procedimientos/usp_insertarBitacoraEstatusReceta.md#cómo-funciona-la-validación-de-la-transición-explicado-sin-jerga)):

```
                    ┌──────────────────┐
                    │   1 Creada       │
                    └──────────────────┘
                       │             │
          (se atiende) │             │ (se cancela antes de surtir)
                       ▼             ▼
                    ┌──────────────────┐      ┌──────────────────┐
                    │ 2 En atención    │─────▶│  5 Cancelada     │  ← estado final
                    └──────────────────┘      └──────────────────┘
                       │             │
             (se surte)│             │ (se surte solo en parte)
                       ▼             ▼
                    ┌──────────────────┐      ┌──────────────────────────┐
                    │  3 Surtida       │◀─────│ 4 Surtida parcialmente   │
                    └──────────────────┘      └──────────────────────────┘
                    (estado final)              (se completa después)
```

Fíjate que `3 Surtida` y `5 Cancelada` son "callejones sin salida": una vez que una receta llegó ahí, ya no se mueve más. Eso es justo la regla de "una vez surtida (parcial o completa) ya no se cancela".

---

## Modelo

![Modelo Relacional de HospitalDB](assets/diagrama-er.png)

11 tablas — cada una con su ficha de diccionario de datos en [`HospitalDB/docs/tablas`](HospitalDB/docs/tablas):

| Tabla | Descripción |
|-------|-------------|
| [`Especialidad`](HospitalDB/docs/tablas/Especialidad.md) | Catálogo de especialidades médicas |
| [`Medico`](HospitalDB/docs/tablas/Medico.md) | Catálogo de médicos |
| [`MedicoEspecialidad`](HospitalDB/docs/tablas/MedicoEspecialidad.md) | Tabla puente — relación **N:M** entre `Medico` y `Especialidad` |
| [`Paciente`](HospitalDB/docs/tablas/Paciente.md) | Catálogo de pacientes |
| [`Consultorio`](HospitalDB/docs/tablas/Consultorio.md) | Catálogo de consultorios (ubicación física) |
| [`EstatusReceta`](HospitalDB/docs/tablas/EstatusReceta.md) | Catálogo de estatus de una receta (Creada, En atención, Surtida, Surtida parcialmente, Cancelada) |
| [`Consulta`](HospitalDB/docs/tablas/Consulta.md) | Hecho — une `Paciente`, `Medico` y `Consultorio`; `Efectuada` distingue agendada de realizada |
| [`Receta`](HospitalDB/docs/tablas/Receta.md) | Hecho — **1:1** con `Consulta`, referencia su estatus actual |
| [`Medicamento`](HospitalDB/docs/tablas/Medicamento.md) | Catálogo de medicamentos |
| [`DetalleReceta`](HospitalDB/docs/tablas/DetalleReceta.md) | Líneas de una receta (medicamento, cantidad, indicaciones) |
| [`BitacoraEstatusReceta`](HospitalDB/docs/tablas/BitacoraEstatusReceta.md) | Historial de transiciones de estatus de una receta |

Todas las tablas llevan `FechaCreacion`/`FechaUltimaModificacion` (auditoría); los catálogos además llevan `Activo BIT` para baja lógica, siguiendo la misma convención que `CompuStoreDB` (sesión 5-6).

### `Receta.idEstatusReceta` vs. `BitacoraEstatusReceta`

No es una relación circular: `EstatusReceta` no referencia de vuelta a `Receta` ni a `BitacoraEstatusReceta`. Es dato redundante intencional — `Receta.idEstatusReceta` guarda el estatus **actual** (lectura rápida, sin `JOIN`+`MAX(Fecha)`), y `BitacoraEstatusReceta` guarda el historial completo. Mismo patrón que `Articulo.PrecioUnitario` + `HistoricoPrecioArticulo` en `CompuStoreDB`. Ver el detalle en [`docs/tablas/Receta.md`](HospitalDB/docs/tablas/Receta.md).

### Reglas de negocio

- Una `Consulta` solo genera `Receta` si `Efectuada = 1` — implementado en [`usp_generarReceta`](HospitalDB/docs/procedimientos/usp_generarReceta.md), y siempre como **una sola** `Receta` por consulta (1:1).
- No se puede efectuar una consulta ni generar su receta antes de la fecha programada de la consulta — implementado en [`usp_efectuarConsulta`](HospitalDB/docs/procedimientos/usp_efectuarConsulta.md) y [`usp_generarReceta`](HospitalDB/docs/procedimientos/usp_generarReceta.md).
- Una `Receta` puede ganar líneas en `DetalleReceta` mientras su estatus es `1 Creada` o `2 En atención`; en `3`, `4` o `5` debe ser un error. No es obligatorio que una receta en estatus `2` ya tenga líneas (puede estar "en atención" y aún no haberse cargado ningún medicamento). Al agregar la primera línea, si estaba en `1` pasa a `2` (si ya estaba en `2`, se queda en `2`). **Pendiente de escribir** (Evidencia 2, distinta a la de la bitácora).
- Transiciones de estatus válidas: `1 → 2`, `2 → 3`, `2 → 4`, `4 → 3`, `1 → 5`, `2 → 5`. **No** válidas: `3 → 4` ni cancelar (`→ 5`) desde `3` o `4` — una vez surtida (parcial o completa) ya no se cancela.
- Cada cambio de estatus de una receta queda registrado en `BitacoraEstatusReceta` — implementado en [`usp_cambiarEstatusReceta`](HospitalDB/docs/procedimientos/usp_cambiarEstatusReceta.md).

---

## Paquete de instalación

Igual que en `CompuStoreDB` (sesión 5-6), hay dos formas de instalar `HospitalDB`:

1. **Instalación completa en un solo script**: [`HospitalDB/instalar-completo.sql`](HospitalDB/instalar-completo.sql). Ábrelo en SSMS y ejecútalo completo (F5) — crea la base, las 11 tablas y los datos iniciales en un solo paso.
2. **Instalación manual, script por script**: ejecutar cada archivo de [`HospitalDB/instalacion`](HospitalDB/instalacion) en el orden de la tabla de abajo.

`instalar-completo.sql` se genera concatenando los archivos de `instalacion/` en orden alfabético de carpeta y nombre (`find instalacion -name "*.sql" | sort`) — el prefijo numérico de cada carpeta ya respeta las llaves foráneas. Si se modifica algún script de `instalacion/`, hay que regenerar `instalar-completo.sql` (pedir que se regenere).

| Carpeta/Archivo | Contenido |
|-----------------|-----------|
| `00-create-database.sql` | `CREATE DATABASE HospitalDB` |
| `01-Especialidad/01-create-table.sql` | Tabla `Especialidad` |
| `01-Especialidad/02-insert.sql` | 10 especialidades |
| `02-Medico/01-create-table.sql` | Tabla `Medico` |
| `02-Medico/02-insert.sql` | 10 médicos |
| `03-MedicoEspecialidad/01-create-table.sql` | Tabla puente `MedicoEspecialidad` |
| `03-MedicoEspecialidad/02-insert.sql` | 13 relaciones Medico-Especialidad (3 médicos con 2 especialidades, para ilustrar la N:M) |
| `04-Paciente/01-create-table.sql` | Tabla `Paciente` |
| `04-Paciente/02-insert.sql` | 15 pacientes |
| `05-Consultorio/01-create-table.sql` | Tabla `Consultorio` |
| `05-Consultorio/02-insert.sql` | 10 consultorios ("Consultorio 1".."Consultorio 10") |
| `06-EstatusReceta/01-create-table.sql` | Tabla `EstatusReceta` |
| `06-EstatusReceta/02-insert.sql` | 5 estatus (Creada, En atención, Surtida, Surtida parcialmente, Cancelada) |
| `07-Consulta/01-create-table.sql` | Tabla `Consulta` |
| `07-Consulta/02-insert.sql` | 17 consultas: 15 efectuadas (una por paciente) + 2 sin efectuar (una ya pasó su fecha sin presentarse el paciente, otra aún no llega a su fecha) |
| `07-Consulta/03-usp-insertar.sql` | SP `usp_insertarConsulta` — agenda una consulta, valida que no se traslape con otra del mismo médico o consultorio |
| `07-Consulta/04-usp-efectuar.sql` | SP `usp_efectuarConsulta` — marca una consulta como efectuada |
| `08-Receta/01-create-table.sql` | Tabla `Receta` |
| `08-Receta/02-insert.sql` | 15 recetas (una por cada consulta ya efectuada), repartidas entre los 5 estatus |
| `08-Receta/03-usp-generar.sql` | SP `usp_generarReceta` — genera la receta de una consulta ya efectuada |
| `08-Receta/04-usp-cambiar-estatus.sql` | SP `usp_cambiarEstatusReceta` — cambia el estatus de una receta, valida la transición y registra la bitácora |
| `09-Medicamento/01-create-table.sql` | Tabla `Medicamento` |
| `09-Medicamento/02-insert.sql` | 15 medicamentos |
| `10-DetalleReceta/01-create-table.sql` | Tabla `DetalleReceta` |
| `10-DetalleReceta/02-insert.sql` | 16 líneas de detalle (solo en recetas que ya tienen medicamentos asignados) |
| `11-BitacoraEstatusReceta/01-create-table.sql` | Tabla `BitacoraEstatusReceta` |
| `11-BitacoraEstatusReceta/02-usp-insertar.sql` | SP `usp_insertarBitacoraEstatusReceta` — inserta el renglón de bitácora (llamado internamente por `usp_cambiarEstatusReceta`) |

`BitacoraEstatusReceta` se crea **vacía** en la instalación inicial — la va llenando [`usp_cambiarEstatusReceta`](HospitalDB/docs/procedimientos/usp_cambiarEstatusReceta.md), un renglón por cada transición.

Reversa en [`HospitalDB/reversa`](HospitalDB/reversa): elimina las tablas en orden inverso a las llaves foráneas y luego la base de datos.

### Documentación de los procedimientos

- [`usp_insertarConsulta`](HospitalDB/docs/procedimientos/usp_insertarConsulta.md) — agenda una consulta, valida traslapes de horario, primer paso del flujo
- [`usp_efectuarConsulta`](HospitalDB/docs/procedimientos/usp_efectuarConsulta.md) — marca una consulta como efectuada
- [`usp_generarReceta`](HospitalDB/docs/procedimientos/usp_generarReceta.md) — genera la receta de una consulta ya efectuada (paso separado, no automático)
- [`usp_cambiarEstatusReceta`](HospitalDB/docs/procedimientos/usp_cambiarEstatusReceta.md) — cambia el estatus de una receta, valida la transición e invoca el SP siguiente
- [`usp_insertarBitacoraEstatusReceta`](HospitalDB/docs/procedimientos/usp_insertarBitacoraEstatusReceta.md) — registra la transición en `BitacoraEstatusReceta` (pieza interna, no usar directo)

---

## Origen de los datos

- **`Medico`/`Paciente`**: los 25 clientes de `CompuStoreDB` (sesión 5-6) se partieron sin traslape — los primeros 10 se adaptaron a `Medico` (agregando `Cedula`, cambiando el dominio de correo a `@hospitaldb.com`), y los 15 restantes a `Paciente` (agregando `Sexo` y `FechaNacimiento`, que ya traían de origen o se sintetizaron) — para que no exista la misma persona en ambas tablas.
- **`Especialidad`, `Consultorio`, `EstatusReceta`, `Medicamento`, `Consulta`, `Receta`, `DetalleReceta`**: no existía ninguna base de datos previa del curso con este dominio; se crearon desde cero para esta sesión.
- **Las 2 consultas 16 y 17** (`Efectuada = 0`, sin receta) se agregaron para ilustrar el flujo de "agendada pero no efectuada": la 16 ya pasó su fecha sin que nadie la marcara como efectuada, la 17 todavía no llega a su fecha.

## Constraints agregados

- `PRIMARY KEY` con `IDENTITY(1,1)` en todas las tablas.
- `FOREIGN KEY` nombradas (`fk_<Tabla>_<TablaReferenciada>`) en todas las relaciones.
- `UNIQUE` en `Especialidad.Nombre`, `Consultorio.Nombre`, `EstatusReceta.Nombre`; `Medico` (`Cedula`, `Telefono`, `Correo`); `Paciente` (`Telefono`, `Correo`); `Medicamento` (`Nombre`, `Marca`); en el par (`idMedico`, `idEspecialidad`) de `MedicoEspecialidad`, para no duplicar la misma relación; y en `Receta.idConsulta`, para garantizar la relación 1:1 con `Consulta`.
- `CHECK` en `Paciente.Sexo` (`IN ('M', 'F')`) y en `DetalleReceta.Cantidad` (`> 0`).
- `DEFAULT 1` en todos los `Activo`, y `DEFAULT GETDATE()` en los campos de auditoría (y en `BitacoraEstatusReceta.Fecha`).

Todo probado manualmente en la instancia de AWS antes de quedar documentado.
