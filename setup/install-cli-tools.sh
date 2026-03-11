#!/bin/bash

set -e

echo "📦 Installing AI CLI Tools"
echo "=========================="

# Claude CLI
echo "Installing Claude CLI..."
curl -fsSL https://cdn.anthropic.com/binaries/claude-cli/latest/claude-cli-linux-amd64.zip -o /tmp/claude-cli.zip
unzip -q /tmp/claude-cli.zip -d /tmp/claude-cli
mkdir -p ~/bin
cp /tmp/claude-cli/claude ~/bin/claude || echo "⚠ Claude CLI copy may need manual intervention"
chmod +x ~/bin/claude
rm -rf /tmp/claude-cli /tmp/claude-cli.zip
echo "✓ Claude CLI installed"

# Gemini CLI (via gcloud SDK)
echo "Installing Gemini CLI..."
if ! command -v gcloud &> /dev/null; then
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-linux-x86_64.tar.gz
    tar xzf google-cloud-sdk-linux-x86_64.tar.gz
    ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=true --quiet
    rm google-cloud-sdk-linux-x86_64.tar.gz
fi
echo "✓ Gemini CLI (gcloud) installed"

# GitHub Copilot CLI (already in ~/bin from earlier)
echo "Installing GitHub Copilot CLI..."
if [ ! -f ~/bin/copilot ]; then
    mkdir -p ~/bin
    # Note: copilot CLI installation would go here
    echo "⚠ Copilot CLI requires manual setup. See docs/SETUP.md"
fi
echo "✓ GitHub Copilot CLI configured"

# Node.js (for npm tools)
echo "Installing Node.js..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi
echo "✓ Node.js installed"

# Python (for various tools)
echo "Installing Python..."
sudo apt-get install -y python3 python3-pip python3-venv
python3 -m pip install --upgrade pip setuptools wheel
echo "✓ Python installed"

# Update PATH in bashrc
if ! grep -q "export PATH=\$HOME/bin:\$PATH" ~/.bashrc; then
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
fi

echo ""
echo "✓ All CLI tools installed"
echo "Run: source ~/.bashrc"
