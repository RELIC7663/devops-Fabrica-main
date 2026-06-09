# Post-Mortem: Incidente Simulado - Error en CrashController

**Fecha:** 2026-06-04
**Duracion:** 4 minutos
**Severidad:** SEV-2
**Autores:** Equipo proyecto-devops
**Estado:** Resuelto

## Resumen ejecutivo

Se introdujo un bug deliberado en el archivo CrashController.java como parte de la simulacion de incidente requerida por la tarea. El commit "Simular Error" (e176a2d) fue pusheado a main y el pipeline CI (#7) detecto el fallo. Se ejecuto un revert (commit d8e6f28) para restaurar el servicio. El pipeline CI (#8) confirmo la correccion.

## Timeline (UTC-5)

| Hora | Evento |
|------|--------|
| 10:02 | Commit e176a2d "Simular Error" pusheado a main |
| 10:02 | Pipeline CI #7 se activa automaticamente |
| 10:04 | Pipeline CI #7 falla (rojo) - error detectado |
| 10:04 | CD Pipeline #5 se activa pero no despliega (CI fallo) |
| 10:05 | Equipo ejecuta: git revert HEAD --no-edit |
| 10:05 | Commit d8e6f28 "Revert Simular Error" pusheado a main |
| 10:06 | Pipeline CI #8 se activa con el revert |
| 10:06 | Servicio restaurado. Incidente cerrado |

## Evidencia

- CI Pipeline #7 (Simular Error): FALLO (rojo) - ver GitHub Actions
- CI Pipeline #8 (Revert): ejecutado - ver GitHub Actions
- Commits visibles en historial de GitHub

## Root Cause Analysis

### Causa raiz
Se modifico el archivo CrashController.java introduciendo un comentario que altero la estructura del codigo, causando un fallo en la compilacion/tests del pipeline CI.

### 5 Whys

1. **Por que fallo el pipeline?** Porque se introdujo un cambio que rompio el codigo en CrashController.java
2. **Por que llego el bug a main?** Porque no hay branch protection rules que requieran PR review antes de mergear a main
3. **Por que no se detecto antes del push?** Porque no se ejecutaron tests locales antes de hacer push
4. **Por que no hay pre-push hooks?** Porque no se configuro un hook de Git que ejecute mvn test antes de cada push
5. **Por que no hay politica de testing local?** Porque no existia un checklist de desarrollo que incluya testing obligatorio

## Impacto

- **Duracion del incidente:** 4 minutos (de 10:02 a 10:06)
- **Usuarios afectados:** Ninguno (el CD no desplego porque el CI fallo)
- **Deploys fallidos:** 1 de 8 totales = 12.5% Change Failure Rate
- **MTTR:** 4 minutos (nivel Elite segun DORA benchmarks)

## Action Items

| Accion | Responsable | Prioridad | Fecha limite |
|--------|------------|-----------|-------------|
| Configurar branch protection en main (requerir PR) | DevOps | Alta | 1 semana |
| Agregar pre-push hook con mvn test | Dev team | Alta | 1 semana |
| Crear checklist de code review | Tech Lead | Media | 2 semanas |
| Agregar smoke test automatico post-deploy en CD | DevOps | Media | 2 semanas |
| Implementar notificaciones Slack para pipelines fallidos | SRE | Baja | 3 semanas |

## Lecciones aprendidas

1. **El pipeline CI funciono como red de seguridad:** detecto el error y evito que llegara a produccion via CD
2. **El rollback con git revert es rapido y seguro:** restaurar el servicio tomo menos de 2 minutos
3. **La observabilidad del pipeline es clave:** GitHub Actions mostro inmediatamente cual commit causo el fallo
4. **Branch protection es esencial:** sin PR obligatorio, cualquier commit llega directo a main sin revision
5. **La cultura blameless funciona:** el foco esta en mejorar el proceso, no en culpar a quien introdujo el bug
