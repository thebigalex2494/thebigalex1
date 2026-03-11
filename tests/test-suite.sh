#!/bin/bash

# Test Suite for WSL AI Environment Scripts

echo "🧪 Running Test Suite"
echo "===================="
echo ""

PASS=0
FAIL=0
SKIP=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

test_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

test_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

test_skip() {
    echo -e "${YELLOW}⊘${NC} $1 (skipped)"
    ((SKIP++))
}

# Test 1: Scripts exist
echo -e "${BLUE}Test Suite 1: File Existence${NC}"
[ -f setup/wsl-bootstrap.sh ] && test_pass "wsl-bootstrap.sh exists" || test_fail "wsl-bootstrap.sh missing"
[ -f setup/install-cli-tools.sh ] && test_pass "install-cli-tools.sh exists" || test_fail "install-cli-tools.sh missing"
[ -f setup/install-ollama.sh ] && test_pass "install-ollama.sh exists" || test_fail "install-ollama.sh missing"
[ -f setup/install-mcp.sh ] && test_pass "install-mcp.sh exists" || test_fail "install-mcp.sh missing"
[ -f setup/install-no-sudo.sh ] && test_pass "install-no-sudo.sh exists" || test_fail "install-no-sudo.sh missing"
[ -f checks/health-check.sh ] && test_pass "health-check.sh exists" || test_fail "health-check.sh missing"
[ -f checks/verify-tools.sh ] && test_pass "verify-tools.sh exists" || test_fail "verify-tools.sh missing"
echo ""

# Test 2: Scripts are executable
echo -e "${BLUE}Test Suite 2: File Permissions${NC}"
[ -x setup/wsl-bootstrap.sh ] && test_pass "wsl-bootstrap.sh is executable" || test_fail "wsl-bootstrap.sh not executable"
[ -x setup/install-no-sudo.sh ] && test_pass "install-no-sudo.sh is executable" || test_fail "install-no-sudo.sh not executable"
[ -x checks/health-check.sh ] && test_pass "health-check.sh is executable" || test_fail "health-check.sh not executable"
echo ""

# Test 3: Bash syntax validation
echo -e "${BLUE}Test Suite 3: Bash Syntax${NC}"
bash -n setup/wsl-bootstrap.sh 2>/dev/null && test_pass "wsl-bootstrap.sh syntax OK" || test_fail "wsl-bootstrap.sh has syntax errors"
bash -n setup/install-no-sudo.sh 2>/dev/null && test_pass "install-no-sudo.sh syntax OK" || test_fail "install-no-sudo.sh has syntax errors"
bash -n checks/health-check.sh 2>/dev/null && test_pass "health-check.sh syntax OK" || test_fail "health-check.sh has syntax errors"
bash -n checks/verify-tools.sh 2>/dev/null && test_pass "verify-tools.sh syntax OK" || test_fail "verify-tools.sh has syntax errors"
echo ""

# Test 4: Documentation exists
echo -e "${BLUE}Test Suite 4: Documentation${NC}"
[ -f README.md ] && test_pass "README.md exists" || test_fail "README.md missing"
[ -f docs/SETUP.md ] && test_pass "docs/SETUP.md exists" || test_fail "docs/SETUP.md missing"
[ -f docs/ARCHITECTURE.md ] && test_pass "docs/ARCHITECTURE.md exists" || test_fail "docs/ARCHITECTURE.md missing"
[ -f docs/TROUBLESHOOTING.md ] && test_pass "docs/TROUBLESHOOTING.md exists" || test_fail "docs/TROUBLESHOOTING.md missing"
echo ""

# Test 5: .gitignore exists and has content
echo -e "${BLUE}Test Suite 5: Git Configuration${NC}"
[ -f .gitignore ] && test_pass ".gitignore exists" || test_fail ".gitignore missing"
[ -s .gitignore ] && test_pass ".gitignore has content" || test_fail ".gitignore is empty"
echo ""

# Test 6: Directory structure
echo -e "${BLUE}Test Suite 6: Directory Structure${NC}"
[ -d setup ] && test_pass "setup/ directory exists" || test_fail "setup/ directory missing"
[ -d checks ] && test_pass "checks/ directory exists" || test_fail "checks/ directory missing"
[ -d docs ] && test_pass "docs/ directory exists" || test_fail "docs/ directory missing"
[ -d config ] && test_pass "config/ directory exists" || test_fail "config/ directory missing"
echo ""

# Summary
echo -e "${BLUE}Test Summary${NC}"
echo "============"
echo -e "${GREEN}Passed: $PASS${NC}"
[ $SKIP -gt 0 ] && echo -e "${YELLOW}Skipped: $SKIP${NC}"
[ $FAIL -gt 0 ] && echo -e "${RED}Failed: $FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Fix and re-run.${NC}"
    exit 1
fi
