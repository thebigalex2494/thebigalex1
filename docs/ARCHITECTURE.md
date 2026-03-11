# Architecture - WSL AI Development Environment

## Componentes

```
┌─────────────────────────────────────────────────────────────┐
│                     Windows 10/11                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              WSL2 (Ubuntu 20.04+)                    │   │
│  │                                                      │   │
│  │  ┌────────────────────────────────────────────────┐ │   │
│  │  │         AI CLI Tools Layer                    │ │   │
│  │  │  ┌──────────────────────────────────────────┐ │ │   │
│  │  │  │  Claude CLI  │  Gemini CLI │ Copilot CLI│ │ │   │
│  │  │  └──────────────────────────────────────────┘ │ │   │
│  │  └────────────────────────────────────────────────┘ │   │
│  │                       ↓                             │   │
│  │  ┌────────────────────────────────────────────────┐ │   │
│  │  │        MCP + Skills Layer                     │ │   │
│  │  │  ┌──────────────────────────────────────────┐ │ │   │
│  │  │  │  Filesystem │ Memory │ SQLite │ Custom  │ │ │   │
│  │  │  └──────────────────────────────────────────┘ │ │   │
│  │  └────────────────────────────────────────────────┘ │   │
│  │                       ↓                             │   │
│  │  ┌────────────────────────────────────────────────┐ │   │
│  │  │    Local Model Runtime (Ollama)              │ │   │
│  │  │  ┌──────────────────────────────────────────┐ │ │   │
│  │  │  │  Mistral │ Neural-Chat │ Llama2        │ │ │   │
│  │  │  └──────────────────────────────────────────┘ │ │   │
│  │  └────────────────────────────────────────────────┘ │   │
│  │                       ↓                             │   │
│  │  ┌────────────────────────────────────────────────┐ │   │
│  │  │   Development Environment                    │ │   │
│  │  │  ┌──────────────────────────────────────────┐ │ │   │
│  │  │  │ Python 3 │ Node.js │ Git │ Docker      │ │ │   │
│  │  │  └──────────────────────────────────────────┘ │ │   │
│  │  └────────────────────────────────────────────────┘ │   │
│  │                                                      │   │
│  └──────────────────────────────────────────────────────┘   │
│  ↕ Interoperability Layer (Windows ↔ WSL)                   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │   Windows Native Tools (PowerShell, VS Code, etc)    │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Directorios

```
~
├── bin/                    # Ejecutables de CLI tools
│   ├── claude
│   ├── gcloud
│   └── copilot
├── .config/
│   └── claude/
│       └── mcp.json       # Configuración MCP
├── .mcp/
│   └── skills/            # Custom skills
├── .ollama/               # Configuración Ollama
└── .bashrc                # PATH actualizado
```

## Flujo de Interacción

```
User Input
    ↓
Claude CLI / Gemini CLI / Copilot CLI
    ↓
MCP Layer (if needed)
    ↓
Skills / External Services
    ↓
Ollama (Local Models) / External APIs
    ↓
Output
```

## Componentes Detallados

### 1. AI CLI Tools
- **Claude CLI**: Cliente de línea de comandos para Claude
- **Gemini CLI**: Google Cloud SDK con acceso a Gemini
- **Copilot CLI**: GitHub Copilot en terminal

### 2. MCP (Model Context Protocol)
Servidores que exponen capacidades:
- **Filesystem**: Lectura/escritura de archivos
- **Memory**: Almacenamiento persistente
- **SQLite**: Base de datos local
- **Custom**: Skills personalizados

### 3. Ollama
Runtime para modelos locales:
- **Mistral**: Modelo rápido y eficiente
- **Neural-Chat**: Optimizado para conversación
- **Llama2**: Modelo versátil

### 4. Windows Integration
WSL2 permite acceso bidireccional:
- Acceder a archivos Windows desde WSL
- Ejecutar herramientas Windows desde WSL
- Clipboard compartido

## Configuración de Ambiente

Variables de entorno necesarias:

```bash
# En ~/.bashrc
export PATH=$HOME/bin:$PATH
export CLAUDE_API_KEY=<your-key>
export GOOGLE_APPLICATION_CREDENTIALS=<path-to-json>
export OLLAMA_HOST=http://localhost:11434
```

## Performance

- **Ollama**: Necesita GPU (recomendado) o ~4GB RAM
- **MCP Servers**: ~100MB cada uno
- **Total mínimo**: 8GB RAM (16GB recomendado)
