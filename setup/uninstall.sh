#!/bin/bash

echo "🗑️  WSL AI Environment - Uninstaller"
echo "===================================="
echo ""

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_removed() {
    echo -e "${GREEN}✓${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Ask for confirmation
echo -e "${RED}This will remove AI environment tools and configurations.${NC}"
echo ""
read -p "Are you sure? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo -e "${YELLOW}Uninstalling...${NC}"
echo ""

# Counter
removed=0

# 1. Remove CLI tools from ~/bin
log_info "Removing CLI tools from ~/bin..."
if [ -f ~/bin/claude ]; then
    rm ~/bin/claude
    log_removed "Claude CLI removed"
    ((removed++))
fi

if [ -f ~/bin/copilot ]; then
    rm ~/bin/copilot
    log_removed "Copilot CLI removed"
    ((removed++))
fi

# Clean up ~/bin if empty
if [ -d ~/bin ] && [ -z "$(ls -A ~/bin 2>/dev/null)" ]; then
    rmdir ~/bin 2>/dev/null && log_removed "Empty ~/bin directory removed"
    ((removed++))
fi

# 2. Remove MCP configuration
log_info "Removing MCP configuration..."
if [ -f ~/.config/claude/mcp.json ]; then
    rm ~/.config/claude/mcp.json
    log_removed "MCP config removed"
    ((removed++))
fi

if [ -d ~/.mcp ]; then
    rm -rf ~/.mcp
    log_removed "MCP skills directory removed"
    ((removed++))
fi

# 3. Remove environment template
log_info "Removing environment variables..."
if [ -f ~/.env.ai ]; then
    rm ~/.env.ai
    log_removed ".env.ai template removed"
    ((removed++))
fi

# 4. Remove PATH from bashrc
log_info "Cleaning up ~/.bashrc..."
if grep -q "export PATH=\$HOME/bin:\$PATH" ~/.bashrc; then
    # Create backup
    cp ~/.bashrc ~/.bashrc.backup
    # Remove the line
    sed -i '/export PATH=\$HOME\/bin:\$PATH/d' ~/.bashrc
    log_removed "PATH cleaned from ~/.bashrc (backup saved as ~/.bashrc.backup)"
    ((removed++))
fi

# 5. Summary
echo ""
echo -e "${BLUE}Uninstall Summary${NC}"
echo "=================="
echo -e "${GREEN}Removed: $removed items${NC}"
echo ""

if [ $removed -gt 0 ]; then
    echo -e "${YELLOW}Note: Some tools may still be installed system-wide:${NC}"
    echo "  - Claude CLI (from system)"
    echo "  - Ollama (run: sudo apt-remove ollama)"
    echo "  - Python/Node.js (system packages)"
    echo ""
    echo "To completely remove, run:"
    echo "  sudo apt-get remove --purge ollama python3-pip nodejs npm"
else
    log_warn "Nothing to remove"
fi

echo ""
echo -e "${GREEN}✓ Uninstall complete${NC}"
