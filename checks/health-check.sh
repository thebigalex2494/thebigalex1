#!/bin/bash

set -e

echo "🏥 WSL Environment Health Check"
echo "================================"
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

passed=0
failed=0
warnings=0

check() {
    local name=$1
    local cmd=$2
    
    if eval "$cmd" &>/dev/null; then
        echo -e "${GREEN}✓${NC} $name"
        ((passed++))
    else
        echo -e "${RED}✗${NC} $name"
        ((failed++))
    fi
}

warn() {
    local name=$1
    local msg=$2
    echo -e "${YELLOW}⚠${NC} $name - $msg"
    ((warnings++))
}

echo -e "${BLUE}System Information${NC}"
echo "==================="
check "WSL2 Environment" "grep -qi microsoft /proc/version"
check "Git installed" "command -v git"
check "Bash installed" "command -v bash"
echo ""

echo -e "${BLUE}AI CLI Tools${NC}"
echo "============"
check "Claude CLI" "command -v claude"
check "Gemini CLI (gcloud)" "command -v gcloud"
check "GitHub Copilot CLI" "command -v copilot"
echo ""

echo -e "${BLUE}Programming Languages${NC}"
echo "====================="
check "Python 3" "command -v python3"
check "Node.js" "command -v node"
check "npm" "command -v npm"
echo ""

echo -e "${BLUE}AI Runtimes${NC}"
echo "==========="
check "Ollama" "command -v ollama"
echo ""

echo -e "${BLUE}Development Tools${NC}"
echo "=================="
check "Docker" "command -v docker" || warn "Docker" "Optional for containerization"
check "curl" "command -v curl"
check "wget" "command -v wget"
check "jq" "command -v jq"
echo ""

echo -e "${BLUE}MCP & Skills${NC}"
echo "============"
if [ -f ~/.config/claude/mcp.json ]; then
    echo -e "${GREEN}✓${NC} MCP config exists"
    ((passed++))
else
    echo -e "${RED}✗${NC} MCP config missing"
    ((failed++))
fi

if [ -d ~/.mcp/skills ]; then
    echo -e "${GREEN}✓${NC} Skills directory exists"
    ((passed++))
else
    echo -e "${RED}✗${NC} Skills directory missing"
    ((failed++))
fi
echo ""

echo -e "${BLUE}Summary${NC}"
echo "======="
echo -e "${GREEN}Passed: $passed${NC}"
[ $warnings -gt 0 ] && echo -e "${YELLOW}Warnings: $warnings${NC}"
[ $failed -gt 0 ] && echo -e "${RED}Failed: $failed${NC}"
echo ""

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✓ Health check passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some checks failed. See details above.${NC}"
    exit 1
fi
