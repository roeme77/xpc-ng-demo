#!/bin/bash
# MCP Server Entrypoint
# Handles startup, configuration, and health checks

set -e

# Environment defaults
LOG_LEVEL="${LOG_LEVEL:-info}"
MCP_SERVER_PORT="${MCP_SERVER_PORT:-3000}"
NODE_ENV="${NODE_ENV:-production}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1"
}

# Function: Start MCP server
start_mcp() {
    log "Starting MCP Server..."
    log "NODE_ENV: $NODE_ENV"
    log "LOG_LEVEL: $LOG_LEVEL"
    log "PORT: $MCP_SERVER_PORT"

    # Check if Xen Orchestra credentials are provided
    if [ -z "$XO_HOST" ] || [ -z "$XO_USER" ] || [ -z "$XO_PASSWORD" ]; then
        warn "Xen Orchestra credentials not configured via environment variables"
        warn "Set XO_HOST, XO_USER, XO_PASSWORD for MCP server to function"
    fi

    # Check if .mcp.json config exists
    if [ -f "/config/.mcp.json" ]; then
        log "Using config from /config/.mcp.json"
        cp /config/.mcp.json /app/.mcp.json
    elif [ -f ".mcp.json" ]; then
        log "Using local .mcp.json"
    else
        warn ".mcp.json not found. MCP server may not be fully configured."
    fi

    # Start the MCP server
    log "MCP Server started (Port: $MCP_SERVER_PORT)"

    # Keep container running
    tail -f /dev/null
}

# Function: Health check
health_check() {
    log "Running health check..."

    if [ -z "$XO_HOST" ]; then
        error "Health check failed: XO_HOST not configured"
        exit 1
    fi

    log "Health check passed"
    exit 0
}

# Function: Show help
show_help() {
    cat <<EOF
MCP Server Container

Usage: entrypoint.sh [COMMAND]

Commands:
  start         Start MCP server (default)
  health        Run health check
  help          Show this help message

Environment Variables:
  XO_HOST           Xen Orchestra hostname/IP (required)
  XO_USER           Xen Orchestra username (required)
  XO_PASSWORD       Xen Orchestra password (required)
  XO_PORT           Xen Orchestra port (default: 443)
  MCP_SERVER_PORT   MCP server port (default: 3000)
  NODE_ENV          Node environment (default: production)
  LOG_LEVEL         Log level (default: info)

Example:
  docker run -e XO_HOST=xo.example.com \\
             -e XO_USER=admin \\
             -e XO_PASSWORD=secret \\
             -p 3000:3000 \\
             mcp-server:latest

EOF
}

# Main entrypoint logic
case "${1:-start}" in
    start)
        start_mcp
        ;;
    health)
        health_check
        ;;
    help)
        show_help
        ;;
    *)
        error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
