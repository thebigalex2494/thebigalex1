# Multi-stage Dockerfile for thebigalex1 project
# Optimized for WSL-first development

# Build stage
FROM ubuntu:22.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    nodejs \
    npm \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy repository files
COPY . .

# Make scripts executable
RUN chmod +x tests/test-suite.sh \
    && chmod +x checks/verify-tools.sh \
    && chmod +x checks/health-check.sh

# Runtime stage
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    nodejs \
    npm \
    curl \
    git \
    shellcheck \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy from builder
COPY --from=builder /workspace /workspace

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD bash checks/health-check.sh || exit 1

# Default command runs verification and tests
CMD ["bash", "-c", "checks/verify-tools.sh && tests/test-suite.sh"]
