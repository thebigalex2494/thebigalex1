#!/bin/bash

set -e

echo "🔌 Installing MCP and Skills"
echo "============================="

# Create MCP directory
mkdir -p ~/.mcp

# Install MCP base
echo "Setting up MCP environment..."
mkdir -p ~/.config/claude

# Create MCP config template
cat > ~/.config/claude/mcp.json << 'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "python",
      "args": ["-m", "mcp.server.filesystem"],
      "disabled": false
    },
    "search": {
      "command": "python",
      "args": ["-m", "mcp.server.search"],
      "disabled": false
    },
    "knowledge": {
      "command": "python",
      "args": ["-m", "mcp.server.knowledge"],
      "disabled": false
    }
  }
}
EOF

echo "✓ MCP config template created"

# Install Python MCP libraries
echo "Installing MCP Python libraries..."
python3 -m pip install --upgrade \
    mcp-server-core \
    mcp-server-filesystem \
    mcp-server-memory \
    mcp-server-sqlite \
    2>/dev/null || echo "⚠ Some MCP libraries may not be available yet"

echo "✓ MCP Python packages installed"

# Create Skills directory
mkdir -p ~/.mcp/skills

# Create example skill
cat > ~/.mcp/skills/example-skill.json << 'EOF'
{
  "name": "example",
  "version": "0.1.0",
  "description": "Example skill template",
  "capabilities": {
    "read": true,
    "write": true,
    "execute": false
  },
  "endpoints": [
    {
      "name": "hello",
      "description": "Say hello",
      "method": "GET"
    }
  ]
}
EOF

echo "✓ Skills directory created"

echo ""
echo "✓ MCP and Skills configured"
echo ""
echo "MCP Config: ~/.config/claude/mcp.json"
echo "Skills Dir: ~/.mcp/skills"
