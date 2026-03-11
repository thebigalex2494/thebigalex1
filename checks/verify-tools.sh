#!/bin/bash

echo "🔍 Tool Verification"
echo "===================="
echo ""

tools=("git" "python3" "node" "npm" "curl" "wget" "jq" "claude" "ollama")

for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        version=$($tool --version 2>&1 | head -1)
        echo "✓ $tool: $version"
    else
        echo "✗ $tool: NOT INSTALLED"
    fi
done

echo ""
echo "For details, run: bash checks/health-check.sh"
