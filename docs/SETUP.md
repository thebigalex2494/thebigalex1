# WSL AI Development Environment - Setup Guide

Guía paso a paso para configurar un entorno completo de desarrollo en WSL2 con Claude CLI, Gemini CLI, Copilot CLI, Ollama, MCP y Skills.

## Prerequisitos

- **WSL2** instalado en Windows (Windows 10 21H1+ o Windows 11)
- **Ubuntu 20.04 LTS o superior** como distribución WSL
- **8GB RAM mínimo** (16GB recomendado para Ollama)
- **20GB espacio libre en disco**

## Instalación Rápida (Recomendado)

```bash
# 1. Clonar el repositorio
git clone https://github.com/thebigalex2494/thebigalex1.git
cd thebigalex1

# 2. Ejecutar bootstrap
bash setup/wsl-bootstrap.sh

# 3. Recargar shell
source ~/.bashrc

# 4. Verificar
bash checks/health-check.sh
```

## Instalación Manual

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

## Verificación

```bash
# Health check completo
bash checks/health-check.sh

# Verificar herramientas específicas
bash checks/verify-tools.sh
```

## Próximos Pasos

1. **Configurar Claude CLI**: `claude auth login`
2. **Configurar Gemini CLI**: `gcloud auth login`
3. **Configurar Copilot CLI**: Ver [Copilot Setup](https://github.com/github/copilot-cli)
4. **Crear Skills**: Documentación en `docs/SKILLS.md`
5. **Configurar Ollama**: `ollama run mistral`

## Troubleshooting

Ver [TROUBLESHOOTING.md](TROUBLESHOOTING.md) para problemas comunes.
