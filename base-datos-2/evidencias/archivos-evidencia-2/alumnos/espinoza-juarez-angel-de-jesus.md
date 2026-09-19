# Ejercicios de Evidencia 2

**Alumno:** Espinoza Juarez Angel De Jesus (matrícula 2253562)

---

## Ejercicio 1: `usp_eliminarConsulta`

### Contexto

A veces una consulta se agenda por error (fecha equivocada, médico equivocado) y hay que cancelarla del todo antes de que ocurra. Pero una consulta que **ya se efectuó** no se puede simplemente borrar — sería perder el registro de una consulta real, y podría tener una receta generada. Tu procedimiento solo permite eliminar consultas que todavía no han pasado por `usp_efectuarConsulta`.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idConsulta` | `int` | Id de la consulta a eliminar |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_eliminarConsulta` y recibe `@p_idConsulta int`.
- [ ] Valida que la consulta exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'La consulta no existe'`, y termina con `RETURN`.
- [ ] Valida que la consulta **no** esté efectuada (`Efectuada = 0`); si ya está efectuada (`Efectuada = 1`), regresa `ErrCodigo = '000002'`, `ErrMensaje = 'No se puede eliminar una consulta que ya fue efectuada'`, y termina con `RETURN`.
- [ ] Si pasa ambas validaciones, elimina físicamente (`DELETE`) el renglón de `Consulta`.
- [ ] Al terminar exitosamente, regresa `ErrCodigo = '000000'`, `ErrMensaje = 'Eliminación correcta'`.

### Ejemplo de salida esperada

`EXEC usp_eliminarConsulta @p_idConsulta = 17` (Fernanda Morales Sandoval, agendada para el 2026-10-01, `Efectuada = 0`):

| ErrCodigo | ErrMensaje |
|---|---|
| 000000 | Eliminación correcta |

`EXEC usp_eliminarConsulta @p_idConsulta = 1` (ya efectuada) debe regresar el error `000002`, sin borrar nada.

### Casos de prueba sugeridos

```sql
-- Éxito: la consulta 17 nunca se efectuó
EXEC usp_eliminarConsulta @p_idConsulta = 17
SELECT * FROM Consulta WHERE idConsulta = 17  -- no debe regresar filas

-- La consulta no existe
EXEC usp_eliminarConsulta @p_idConsulta = 9999

-- La consulta ya fue efectuada (no se debe poder eliminar)
EXEC usp_eliminarConsulta @p_idConsulta = 1
```

---

## Ejercicio 2: `usp_obtenerConsultasPorMedico`

### Contexto

Un médico necesita ver rápido su propia agenda: todas las consultas que tiene asignadas, con el nombre del paciente y el consultorio, sin tener que leer los ids a mano. Tu procedimiento arma esa agenda.

### Firma

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `@p_idMedico` | `int` | Id del médico |

### Criterios de aceptación

- [ ] El procedimiento se llama exactamente `usp_obtenerConsultasPorMedico` y recibe `@p_idMedico int`.
- [ ] Valida que el médico exista; si no, regresa `ErrCodigo = '000001'`, `ErrMensaje = 'El médico no existe'`, y termina con `RETURN`.
- [ ] Si el médico existe, regresa (vía `SELECT`) una fila por cada consulta de ese médico, con las columnas: `idConsulta`, `Fecha`, `Efectuada`, `NombrePaciente` (nombre completo del paciente), `NombreConsultorio` (de `Consultorio.Nombre`).
- [ ] Incluye **todas** las consultas del médico, sin importar el valor de `Efectuada`.
- [ ] No imprime ningún mensaje de éxito `000000` — el resultado del `SELECT` es la respuesta.

### Ejemplo de salida esperada

`EXEC usp_obtenerConsultasPorMedico @p_idMedico = 6` (Sofía Sánchez Vega, que atiende las consultas 6 y 16):

| idConsulta | Fecha | Efectuada | NombrePaciente | NombreConsultorio |
|---|---|---|---|---|
| 6 | 2026-09-03 12:00 | 1 | Carolina Salinas Herrera | Consultorio 6 |
| 16 | 2026-09-11 09:00 | 0 | Sergio Castro Ibarra | Consultorio 6 |

### Casos de prueba sugeridos

```sql
EXEC usp_obtenerConsultasPorMedico @p_idMedico = 6     -- 2 filas
EXEC usp_obtenerConsultasPorMedico @p_idMedico = 9999  -- error 000001
```

---

## Entregable

Ver [`descripcion-evidencia-2.md`](../descripcion-evidencia-2.md) para la forma de entrega completa. Tus archivos se llaman:

```
EV2_EspinozaJuarezAngelDeJesus_2253562_Ejercicio1.txt
EV2_EspinozaJuarezAngelDeJesus_2253562_Ejercicio2.txt
```
