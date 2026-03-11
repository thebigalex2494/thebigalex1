#!/bin/bash

echo "🚀 WSL AI Environment - No-Sudo Installer"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Counters
installed=0
failed=0
skipped=0

# 1. Create ~/bin directory if doesn't exist
mkdir -p ~/bin

# 2. Install Claude CLI
echo -e "${BLUE}Installing CLI Tools...${NC}"
if command -v claude &> /dev/null; then
    log_success "Claude CLI already installed ($(claude --version 2>&1 | head -1))"
    ((skipped++))
else
    log_info "Downloading Claude CLI..."
    if curl -fsSL https://cdn.anthropic.com/binaries/claude-cli/latest/claude-cli-linux-amd64.zip -o /tmp/claude-cli.zip 2>/dev/null; then
        unzip -q /tmp/claude-cli.zip -d /tmp/claude-cli 2>/dev/null || true
        if [ -f /tmp/claude-cli/claude ]; then
            cp /tmp/claude-cli/claude ~/bin/claude
            chmod +x ~/bin/claude
            log_success "Claude CLI installed"
            ((installed++))
        else
            log_error "Claude CLI binary not found"
            ((failed++))
        fi
        rm -rf /tmp/claude-cli /tmp/claude-cli.zip
    else
        log_warn "Claude CLI download failed (no internet?)"
        ((failed++))
    fi
fi

# 3. Install Node.js (if not present)
echo ""
echo -e "${BLUE}Checking JavaScript Runtime...${NC}"
if command -v node &> /dev/null; then
    log_success "Node.js already installed ($(node --version))"
    ((skipped++))
else
    log_warn "Node.js not installed. Install with: sudo apt-get install -y nodejs npm"
    ((failed++))
fi

# 4. Install Python (if not present)
echo ""
echo -e "${BLUE}Checking Python Runtime...${NC}"
if command -v python3 &> /dev/null; then
    log_success "Python 3 already installed ($(python3 --version))"
    ((skipped++))
else
    log_warn "Python 3 not installed. Install with: sudo apt-get install -y python3 python3-pip"
    ((failed++))
fi

# 5. Upgrade pip if Python available
if command -v python3 &> /dev/null; then
    echo ""
    log_info "Upgrading pip..."
    python3 -m pip install --upgrade pip setuptools wheel --quiet 2>/dev/null && \
        log_success "pip upgraded" || \
        log_warn "pip upgrade failed (may need --user flag)"
fi

# 6. Install MCP Python packages
echo ""
echo -e "${BLUE}Installing MCP Packages...${NC}"
if command -v python3 &> /dev/null; then
    mcp_packages=("mcp" "anthropic")
    for pkg in "${mcp_packages[@]}"; do
        if python3 -c "import ${pkg}" 2>/dev/null; then
            log_success "$pkg already installed"
            ((skipped++))
        else
            log_info "Installing $pkg..."
            python3 -m pip install "$pkg" --quiet 2>/dev/null && \
                log_success "$pkg installed" || \
                log_warn "$pkg installation failed"
        fi
    done
fi

# 7. Create MCP directories
echo ""
echo -e "${BLUE}Setting up MCP Configuration...${NC}"
mkdir -p ~/.mcp/skills ~/.config/claude

if [ ! -f ~/.config/claude/mcp.json ]; then
    cat > ~/.config/claude/mcp.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "python",
      "args": ["-m", "mcp.server.filesystem"],
      "disabled": false
    }
  }
}
EOF
    log_success "MCP config created"
    ((installed++))
else
    log_success "MCP config already exists"
    ((skipped++))
fi

# 8. Update PATH
echo ""
echo -e "${BLUE}Updating PATH...${NC}"
if ! grep -q "export PATH=\$HOME/bin:\$PATH" ~/.bashrc; then
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
    log_success "PATH updated in ~/.bashrc"
    ((installed++))
else
    log_success "PATH already configured"
    ((skipped++))
fi

# 9. Create .env template
echo ""
echo -e "${BLUE}Creating Configuration Templates...${NC}"
if [ ! -f ~/.env.ai ]; then
    cat > ~/.env.ai << 'EOF'
# AI Environment Variables
export CLAUDE_API_KEY=""
export GEMINI_API_KEY=""
export OLLAMA_HOST="http://localhost:11434"
export OPENAI_API_KEY=""
EOF
    log_success ".env.ai template created (add your keys here)"
    ((installed++))
else
    log_success ".env.ai already exists"
    ((skipped++))
fi

# 10. Summary
echo ""
echo -e "${BLUE}Summary${NC}"
echo "======="
echo -e "${GREEN}Installed: $installed${NC}"
echo -e "${YELLOW}Skipped: $skipped${NC}"
[ $failed -gt 0 ] && echo -e "${RED}Failed/Missing: $failed${NC}"

echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "1. Source ~/.bashrc: source ~/.bashrc"
echo "2. Verify: bash checks/verify-tools.sh"
echo "3. Set API keys: nano ~/.env.ai"
echo ""

if [ $failed -gt 0 ]; then
    echo -e "${YELLOW}To install missing tools with sudo:${NC}"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install -y python3 python3-pip nodejs npm jq"
    echo "  # Then re-run this script"
fi
