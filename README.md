# WSL AI Development Environment Setup

Una herramienta completa para configurar WSL2 con **Claude CLI**, **Gemini CLI**, **Copilot CLI**, **Ollama**, **MCP**, y **Skills** con integración a Windows nativo.

## Quick Start

```bash
# 1. Clonar repo
cd ~/Projects && git clone https://github.com/thebigalex2494/thebigalex1.git
cd thebigalex1

# 2. Ejecutar setup
bash setup/wsl-bootstrap.sh

# 3. Verificar instalación
bash checks/health-check.sh
```

## Características

✅ **Instalación automática** de CLI tools  
✅ **Verificación de entorno** completa  
✅ **Integración WSL ↔ Windows**  
✅ **Ollama + Modelos locales**  
✅ **MCP y Skills configurados**  
✅ **Documentación completa**

## Contenido

- `setup/` — Scripts de instalación
- `checks/` — Scripts de verificación
- `config/` — Templates de configuración
- `docs/` — Documentación detallada

## Requisitos

- WSL2 (Ubuntu 20.04+)
- 8GB RAM mínimo
- 20GB espacio libre

## Estructura

Ver [ARCHITECTURE.md](docs/ARCHITECTURE.md) para diagrama completo.

## Documentación

- [Setup Guide](docs/SETUP.md) — Paso a paso
- [Architecture](docs/ARCHITECTURE.md) — Componentes
- [Troubleshooting](docs/TROUBLESHOOTING.md) — Solución de problemas

## Contribuciones

Fork → Branch → Commit → Push → PR
