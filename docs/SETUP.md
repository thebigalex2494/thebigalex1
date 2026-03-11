# WSL AI Development Environment - Setup Guide

Guía paso a paso para configurar un entorno completo de desarrollo en WSL2 con Claude CLI, Gemini CLI, Copilot CLI, Ollama, MCP y Skills.

## Prerequisitos

- **WSL2** instalado en Windows (Windows 10 21H1+ o Windows 11)
- **Ubuntu 20.04 LTS o superior** como distribución WSL
- **8GB RAM mínimo** (16GB recomendado para Ollama)
- **20GB espacio libre en disco**

## Instalación Rápida (Recomendado)

### Opción 1: Usar Interactive Menu (Recomendado - Sprint 3)

```bash
# 1. Clonar el repositorio
git clone https://github.com/thebigalex2494/thebigalex1.git
cd thebigalex1

# 2. Ejecutar el menu interactivo
bash setup/menu-installer.sh

# 3. Seleccionar opción:
#    1 = Full Installation (todos los componentes)
#    2 = Minimal Installation (solo dependencias del sistema)
#    3 = Verify Installation (verificar instalación existente)
#    4 = Uninstall (remover todo)
```

### Opción 2: Instalación por Línea de Comandos

```bash
# Full installation (no-interactiva)
bash setup/menu-installer.sh --full

# Minimal installation
bash setup/menu-installer.sh --minimal

# Verify existing installation
bash setup/menu-installer.sh --verify

# Dry-run (preview sin hacer cambios)
bash setup/menu-installer.sh --full --dry-run

# Con logging
bash setup/menu-installer.sh --full --dry-run
# Logs saved to: ./logs/setup-*.log
```

### Opción 3: Bootstrap Original

```bash
# 1. Ejecutar bootstrap
bash setup/wsl-bootstrap.sh

# 2. Recargar shell
source ~/.bashrc

# 3. Verificar
bash checks/health-check.sh
```

## Instalación Manual (Paso a Paso)

### Paso 1: Actualizar Sistema

```bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y build-essential curl wget git vim
```

### Paso 2: Instalar Claude CLI

```bash
curl -fsSL https://cdn.anthropic.com/binaries/claude-cli/latest/claude-cli-linux-amd64.zip -o /tmp/claude-cli.zip
unzip /tmp/claude-cli.zip -d ~/bin/
chmod +x ~/bin/claude
```

### Paso 3: Instalar Gemini CLI (gcloud)

```bash
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-linux-x86_64.tar.gz
tar xzf google-cloud-sdk-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
```

### Paso 4: Instalar Ollama

```bash
curl -fsSL https://ollama.ai/install.sh | sh
ollama pull mistral
ollama pull neural-chat
```

### Paso 5: Instalar MCP

```bash
python3 -m pip install mcp-server-core
mkdir -p ~/.mcp/skills
```

### Paso 6: Configurar PATH

```bash
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## Desinstalación

### Opción 1: Menu Interactivo (Recomendado)

```bash
bash setup/menu-installer.sh
# Seleccionar opción 4: Uninstall
```

### Opción 2: Script Directo con Opciones

```bash
# Desinstalar con preview (dry-run)
bash setup/uninstall.sh --dry-run

# Desinstalar con logging
bash setup/uninstall.sh --log

# Desinstalar para real
bash setup/uninstall.sh
```

## Configuración WSL2 Avanzada

### Plantilla .wslconfig

Crear o editar `%USERPROFILE%\.wslconfig` en Windows:

```ini
[wsl2]
# Máxima memoria a usar (ajusta según tu RAM disponible)
memory=8GB
swap=2GB
processors=4
localhostForwarding=true

# Kernel mejorado
kernel=\\\\wsl.localhost\\Ubuntu\\boot\\vmlinuz

[interop]
enabled=true
appendWindowsPath=true

[boot]
systemd=true
```

### Plantilla para Desarrollo WSL (Linux)

En `~/.wslconfig` (dentro de WSL):

```bash
# ~/.wslconfig.local
export WSL_MEMORY=8GB
export WSL_SWAP=2GB
export WSL_PROCESSORS=4
export DEV_MODE=true
```

### Aplicar Cambios

```bash
# En Windows PowerShell (como Admin):
wsl --shutdown

# Luego reinicia WSL
wsl
```

## Verificación

```bash
# Health check completo
bash checks/health-check.sh

# Verificar herramientas específicas
bash checks/verify-tools.sh

# Ejecutar suite de tests
bash tests/test-suite.sh
```

## CI/CD - Docker Support

El proyecto incluye soporte para CI/CD con GitHub Actions y Docker:

```bash
# Construir imagen Docker
docker build -t thebigalex1 .

# Ejecutar tests dentro del contenedor
docker run --rm thebigalex1

# Ejecutar con volúmenes para desarrollo
docker run -it -v $(pwd):/workspace thebigalex1 /bin/bash
```

Ver `.github/workflows/ci.yml` para configuración de CI automática.

## Próximos Pasos

1. **Configurar Claude CLI**: `claude auth login`
2. **Configurar Gemini CLI**: `gcloud auth login`
3. **Configurar Copilot CLI**: Ver [Copilot Setup](https://github.com/github/copilot-cli)
4. **Crear Skills**: Documentación en `docs/SKILLS.md`
5. **Configurar Ollama**: `ollama run mistral`

## Troubleshooting

Ver [TROUBLESHOOTING.md](TROUBLESHOOTING.md) para problemas comunes.
