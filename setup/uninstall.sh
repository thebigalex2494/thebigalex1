#!/bin/bash

# WSL AI Environment - Uninstaller with dry-run support
# Usage: ./uninstall.sh [--dry-run] [--log]

set -o pipefail

echo "🗑️  WSL AI Environment - Uninstaller"
echo "===================================="
echo ""

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Parse arguments
DRY_RUN=false
ENABLE_LOGGING=false
LOG_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            ;;
        --log)
            ENABLE_LOGGING=true
            LOG_DIR="./logs"
            mkdir -p "$LOG_DIR"
            LOG_FILE="${LOG_DIR}/uninstall-$(date +%Y%m%d_%H%M%S).log"
            ;;
        --help)
            echo "Usage: $0 [--dry-run] [--log]"
            echo "  --dry-run   Preview what would be removed"
            echo "  --log       Save output to logs/"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

log_info() {
    local msg="$1"
    echo -e "${BLUE}ℹ${NC} $msg"
    [ -n "$LOG_FILE" ] && echo "[INFO] $msg" >> "$LOG_FILE"
}

log_warn() {
    local msg="$1"
    echo -e "${YELLOW}⚠${NC} $msg"
    [ -n "$LOG_FILE" ] && echo "[WARN] $msg" >> "$LOG_FILE"
}

log_removed() {
    local msg="$1"
    echo -e "${GREEN}✓${NC} $msg"
    [ -n "$LOG_FILE" ] && echo "[REMOVED] $msg" >> "$LOG_FILE"
}

log_error() {
    local msg="$1"
    echo -e "${RED}✗${NC} $msg"
    [ -n "$LOG_FILE" ] && echo "[ERROR] $msg" >> "$LOG_FILE"
}

# Log initialization
if [ -n "$LOG_FILE" ]; then
    {
        echo "=== Uninstall Log ==="
        echo "Started: $(date)"
        echo "Mode: $([ "$DRY_RUN" = true ] && echo "DRY-RUN" || echo "LIVE")"
        echo "User: $(whoami)"
    } > "$LOG_FILE"
fi

# Show dry-run notice
if [ "$DRY_RUN" = true ]; then
    log_warn "DRY-RUN MODE: No changes will be made"
    echo ""
fi

# Ask for confirmation
echo -e "${RED}This will remove AI environment tools and configurations.${NC}"
echo ""

if [ "$DRY_RUN" = false ]; then
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Cancelled."
        exit 0
    fi
fi

echo ""
echo -e "${YELLOW}Uninstalling...${NC}"
echo ""

# Counter
removed=0

# 1. Remove CLI tools from ~/bin
log_info "Removing CLI tools from ~/bin..."
if [ -f ~/bin/claude ]; then
    if [ "$DRY_RUN" = true ]; then
        log_warn "[DRY-RUN] Would remove: ~/bin/claude"
    else
        rm ~/bin/claude
        log_removed "Claude CLI removed"
    fi
    ((removed++))
fi

if [ -f ~/bin/copilot ]; then
    if [ "$DRY_RUN" = true ]; then
        log_warn "[DRY-RUN] Would remove: ~/bin/copilot"
    else
        rm ~/bin/copilot
        log_removed "Copilot CLI removed"
    fi
    ((removed++))
fi

# Clean up ~/bin if empty
if [ -d ~/bin ] && [ -z "$(ls -A ~/bin 2>/dev/null)" ]; then
    if [ "$DRY_RUN" = true ]; then
        log_warn "[DRY-RUN] Would remove empty: ~/bin"
    else
        rmdir ~/bin 2>/dev/null && log_removed "Empty ~/bin directory removed"
    fi
    ((removed++))
fi

# 2. Remove MCP configuration
log_info "Removing MCP configuration..."
if [ -f ~/.config/claude/mcp.json ]; then
    if [ "$DRY_RUN" = true ]; then
        log_warn "[DRY-RUN] Would remove: ~/.config/claude/mcp.json"
    else
        rm ~/.config/claude/mcp.json
        log_removed "MCP config removed"
    fi
    ((removed++))
fi

if [ -d ~/.mcp ]; then
    if [ "$DRY_RUN" = true ]; then
        log_warn "[DRY-RUN] Would remove: ~/.mcp"
    else
        rm -rf ~/.mcp
        log_removed "MCP skills directory removed"
    fi
    ((removed++))
fi

# 3. Remove environment template
log_info "Removing environment variables..."
if [ -f ~/.env.ai ]; then
    if [ "$DRY_RUN" = true ]; then
        log_warn "[DRY-RUN] Would remove: ~/.env.ai"
    else
        rm ~/.env.ai
        log_removed ".env.ai template removed"
    fi
    ((removed++))
fi

# 4. Remove PATH from bashrc
log_info "Cleaning up ~/.bashrc..."
if grep -q "export PATH=\$HOME/bin:\$PATH" ~/.bashrc; then
    if [ "$DRY_RUN" = true ]; then
        log_warn "[DRY-RUN] Would clean PATH from ~/.bashrc"
    else
        # Create backup
        cp ~/.bashrc ~/.bashrc.backup
        # Remove the line
        sed -i '/export PATH=\$HOME\/bin:\$PATH/d' ~/.bashrc
        log_removed "PATH cleaned from ~/.bashrc (backup saved as ~/.bashrc.backup)"
    fi
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
