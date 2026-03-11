# Troubleshooting

## Problemas Comunes

### Claude CLI no se encuentra

**Síntoma**: `command not found: claude`

**Solución**:
```bash
# Verificar que está en ~/bin
ls -la ~/bin/claude

# Verificar PATH
echo $PATH | grep $HOME/bin

# Si no aparece, agregar a bashrc
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### Ollama no inicia

**Síntoma**: `Cannot connect to ollama`

**Solución**:
```bash
# Iniciar Ollama en background
ollama serve &

# O en screen/tmux
screen -S ollama
ollama serve
```

### MCP config no se encuentra

**Síntoma**: `~/.config/claude/mcp.json: No such file`

**Solución**:
```bash
mkdir -p ~/.config/claude
# Re-run install-mcp.sh
bash setup/install-mcp.sh
```

### Permiso denegado en scripts

**Síntoma**: `Permission denied: ./setup/wsl-bootstrap.sh`

**Solución**:
```bash
chmod +x setup/*.sh
chmod +x checks/*.sh
bash setup/wsl-bootstrap.sh
```

### WSL2 usando demasiada RAM

**Síntoma**: Ollama consume mucha memoria

**Solución**:
```bash
# Crear ~/.wslconfig (en Windows)
[wsl2]
memory=12GB
processors=4
swap=4GB

# Reiniciar WSL
wsl --shutdown
wsl
```

### Python/Node.js no disponible

**Síntoma**: `command not found: python3`

**Solución**:
```bash
sudo apt-get install -y python3 python3-pip nodejs npm
```

### GitHub CLI autenticación

**Síntoma**: `gh auth login` falla

**Solución**:
```bash
# Opción 1: Web browser
gh auth login --web

# Opción 2: Token
gh auth login --with-token
# Pega tu personal access token (PAT)
```

## Verificación de Componentes

```bash
# Todos los componentes
bash checks/health-check.sh

# Herramientas específicas
bash checks/verify-tools.sh

# Versiones
git --version
python3 --version
node --version
npm --version
ollama --version
```

## Logs

```bash
# Logs de bootstrap (si existen)
tail -f /var/log/setup.log

# Logs de Ollama
ps aux | grep ollama

# Logs de MCP
~/.config/claude/mcp.log
```

## Contacto / Help

- Lee [SETUP.md](SETUP.md)
- Revisa [ARCHITECTURE.md](ARCHITECTURE.md)
- Abre un issue en GitHub
