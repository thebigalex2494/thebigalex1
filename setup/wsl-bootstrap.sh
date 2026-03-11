#!/bin/bash

set -e

echo "🚀 WSL AI Development Environment Bootstrap"
echo "=============================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if running in WSL
if ! grep -qi microsoft /proc/version; then
    log_warn "This script is designed for WSL2. Some features may not work on native Linux."
fi

log_info "Step 1: Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y
log_success "System packages updated"

log_info "Step 2: Installing base dependencies..."
sudo apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    vim \
    htop \
    net-tools \
    jq \
    unzip \
    zip
log_success "Base dependencies installed"

log_info "Step 3: Installing CLI tools..."
bash "$(dirname "$0")/install-cli-tools.sh"
log_success "CLI tools installed"

log_info "Step 4: Installing Ollama..."
bash "$(dirname "$0")/install-ollama.sh"
log_success "Ollama installed"

log_info "Step 5: Installing MCP..."
bash "$(dirname "$0")/install-mcp.sh"
log_success "MCP configured"

log_info "Step 6: Running health check..."
bash "$(dirname "$0")/../checks/health-check.sh"

echo ""
log_success "Bootstrap complete! Your WSL environment is ready."
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Run: source ~/.bashrc"
echo "  3. Verify: bash checks/health-check.sh"
