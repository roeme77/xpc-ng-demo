# MCP Server - Multi-runtime compatible (Docker & Podman)
# Base: Official Node.js image (slim variant for smaller footprint)
# Compatible with: Docker, Podman, docker-compose, podman-compose

FROM node:24-slim

LABEL maintainer="XPC-NG Demo"
LABEL description="Xen Orchestra MCP Server for infrastructure automation"

# Install required system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy entrypoint script
COPY mcp-server/entrypoint.sh /app/
RUN chmod +x /app/entrypoint.sh

# Note: Running as root for now; production should use non-root user
# To enable non-root: create user before container runs if needed

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Default environment variables
ENV NODE_ENV=production
ENV LOG_LEVEL=info
ENV MCP_SERVER_PORT=3000

# Expose port for MCP server
EXPOSE 3000

# Run entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["start"]
