#!/bin/bash

# WSL AI Environment - Interactive Menu Installer
# Supports: full, minimal, verify, uninstall modes with dry-run and logging

set -o pipefail

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging
LOG_DIR="./logs"
LOG_FILE="${LOG_DIR}/setup-$(date +%Y%m%d_%H%M%S).log"
DRY_RUN=false

# Initialize logging
setup_logging() {
    mkdir -p "$LOG_DIR"
    {
        echo "=== WSL AI Environment Setup ==="
        echo "Started: $(date)"
        echo "User: $(whoami)"
        echo "Mode: $([ "$DRY_RUN" = true ] && echo "DRY-RUN" || echo "LIVE")"
        echo ""
    } | tee "$LOG_FILE"
}

log_info() {
    local msg="$1"
    echo -e "${BLUE}ℹ${NC} $msg" | tee -a "$LOG_FILE"
}

log_success() {
    local msg="$1"
    echo -e "${GREEN}✓${NC} $msg" | tee -a "$LOG_FILE"
}

log_warn() {
    local msg="$1"
    echo -e "${YELLOW}⚠${NC} $msg" | tee -a "$LOG_FILE"
}

log_error() {
    local msg="$1"
    echo -e "${RED}✗${NC} $msg" | tee -a "$LOG_FILE"
}

# Execute command with dry-run support
execute() {
    local cmd="$1"
    local desc="$2"
    
    log_info "Executing: $desc"
    log_info "Command: $cmd"
    
    if [ "$DRY_RUN" = true ]; then
        log_warn "[DRY-RUN] Would execute: $cmd"
        echo "# $cmd" >> "$LOG_FILE"
        return 0
    fi
    
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        log_success "$desc"
        return 0
    else
        log_error "Failed: $desc"
        return 1
    fi
}

# Installation functions
install_system_deps() {
    log_info "Installing system dependencies..."
    execute "sudo apt-get update" "Update package list"
    execute "sudo apt-get install -y python3 python3-pip nodejs npm curl git" "Install base dependencies"
}

install_minimal() {
    log_info "Starting MINIMAL installation..."
    install_system_deps
    log_success "Minimal installation complete"
}

install_full() {
    log_info "Starting FULL installation..."
    install_system_deps
    
    # Install additional tools
    execute "sudo apt-get install -y shellcheck jq" "Install development tools"
    
    # Run setup scripts if they exist
    if [ -f "./setup/install-cli-tools.sh" ]; then
        execute "bash ./setup/install-cli-tools.sh" "Install CLI tools"
    fi
    
    if [ -f "./setup/install-mcp.sh" ]; then
        execute "bash ./setup/install-mcp.sh" "Install MCP"
    fi
    
    log_success "Full installation complete"
}

verify_installation() {
    log_info "Verifying installation..."
    
    local failed=0
    
    # Check Python
    if ! command -v python3 &> /dev/null; then
        log_error "Python3 not found"
        ((failed++))
    else
        log_success "Python3: $(python3 --version)"
    fi
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        log_error "Node.js not found"
        ((failed++))
    else
        log_success "Node.js: $(node --version)"
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        log_error "npm not found"
        ((failed++))
    else
        log_success "npm: $(npm --version)"
    fi
    
    # Check curl
    if ! command -v curl &> /dev/null; then
        log_error "curl not found"
        ((failed++))
    else
        log_success "curl installed"
    fi
    
    # Check git
    if ! command -v git &> /dev/null; then
        log_error "git not found"
        ((failed++))
    else
        log_success "git: $(git --version)"
    fi
    
    # Run test suite if available
    if [ -f "./tests/test-suite.sh" ]; then
        log_info "Running test suite..."
        bash ./tests/test-suite.sh >> "$LOG_FILE" 2>&1 && \
            log_success "Test suite passed" || \
            log_warn "Test suite had warnings"
    fi
    
    # Run verify-tools if available
    if [ -f "./checks/verify-tools.sh" ]; then
        log_info "Running tool verification..."
        bash ./checks/verify-tools.sh >> "$LOG_FILE" 2>&1 && \
            log_success "Tool verification passed" || \
            log_warn "Tool verification had issues"
    fi
    
    if [ $failed -eq 0 ]; then
        log_success "All verifications passed"
        return 0
    else
        log_error "$failed verifications failed"
        return 1
    fi
}

uninstall() {
    log_info "Starting UNINSTALL..."
    
    local removed=0
    
    # Confirm
    if [ "$DRY_RUN" = false ]; then
        read -p "Are you sure you want to uninstall? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            log_warn "Uninstall cancelled"
            exit 0
        fi
    fi
    
    # Remove CLI tools
    log_info "Removing CLI tools..."
    [ -f ~/bin/claude ] && execute "rm ~/bin/claude" "Remove Claude CLI" && ((removed++))
    [ -f ~/bin/copilot ] && execute "rm ~/bin/copilot" "Remove Copilot CLI" && ((removed++))
    
    # Clean up bin if empty
    [ -d ~/bin ] && [ -z "$(ls -A ~/bin 2>/dev/null)" ] && \
        execute "rmdir ~/bin" "Remove empty ~/bin" && ((removed++))
    
    # Remove MCP config
    log_info "Removing MCP configuration..."
    [ -f ~/.config/claude/mcp.json ] && \
        execute "rm ~/.config/claude/mcp.json" "Remove MCP config" && ((removed++))
    [ -d ~/.mcp ] && \
        execute "rm -rf ~/.mcp" "Remove MCP skills" && ((removed++))
    
    # Remove environment template
    log_info "Removing environment variables..."
    [ -f ~/.env.ai ] && \
        execute "rm ~/.env.ai" "Remove .env.ai" && ((removed++))
    
    # Clean up bashrc
    log_info "Cleaning up shell configuration..."
    if grep -q "export PATH=\$HOME/bin:\$PATH" ~/.bashrc; then
        execute "cp ~/.bashrc ~/.bashrc.backup" "Backup ~/.bashrc"
        execute "sed -i '/export PATH=\$HOME\/bin:\$PATH/d' ~/.bashrc" "Clean PATH from ~/.bashrc"
        ((removed++))
    fi
    
    log_info "Uninstall Summary: $removed items removed"
    log_success "Uninstall complete"
}

show_menu() {
    clear
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  WSL AI Environment - Setup Menu       ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo "1) Full Installation    (all components)"
    echo "2) Minimal Installation (system deps only)"
    echo "3) Verify Installation (check existing setup)"
    echo "4) Uninstall           (remove all)"
    echo "5) Quit"
    echo ""
}

show_help() {
    cat << EOF
WSL AI Environment - Interactive Setup

Usage: $0 [OPTIONS]

Options:
  --full         Run full installation (non-interactive)
  --minimal      Run minimal installation (non-interactive)
  --verify       Run verification (non-interactive)
  --uninstall    Run uninstall (non-interactive)
  --dry-run      Simulate operations without making changes
  --help         Show this help message

Examples:
  $0 --full --dry-run
  $0 --verify
  $0 --uninstall

EOF
}

# Main menu loop
main_menu() {
    while true; do
        show_menu
        read -p "Select option (1-5): " choice
        
        case $choice in
            1)
                install_full
                read -p "Press Enter to continue..."
                ;;
            2)
                install_minimal
                read -p "Press Enter to continue..."
                ;;
            3)
                verify_installation
                read -p "Press Enter to continue..."
                ;;
            4)
                uninstall
                read -p "Press Enter to continue..."
                ;;
            5)
                log_info "Exiting setup menu"
                exit 0
                ;;
            *)
                log_error "Invalid option. Please try again."
                ;;
        esac
    done
}

# Parse command-line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full)
                setup_logging
                install_full
                exit $?
                ;;
            --minimal)
                setup_logging
                install_minimal
                exit $?
                ;;
            --verify)
                setup_logging
                verify_installation
                exit $?
                ;;
            --uninstall)
                setup_logging
                uninstall
                exit $?
                ;;
            --dry-run)
                DRY_RUN=true
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
}

# Main entry point
main() {
    parse_args "$@"
    setup_logging
    main_menu
}

# Run main
main "$@"
