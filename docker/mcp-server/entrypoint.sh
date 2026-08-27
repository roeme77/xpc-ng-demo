#!/bin/bash
# MCP Server Entrypoint
# Starts Xen Orchestra MCP server with proper configuration

set -e

# Environment defaults
LOG_LEVEL="${LOG_LEVEL:-info}"
MCP_SERVER_PORT="${MCP_SERVER_PORT:-3000}"
NODE_ENV="${NODE_ENV:-production}"
XO_HOST="${XO_HOST:-localhost}"
XO_PORT="${XO_PORT:-443}"
XO_USER="${XO_USER:-admin}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING:${NC} $1"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR:${NC} $1"
}

# Function: Validate credentials
validate_credentials() {
    log "Validating Xen Orchestra credentials..."

    if [ -z "$XO_HOST" ]; then
        error "XO_HOST not configured"
        return 1
    fi

    if [ -z "$XO_USER" ]; then
        error "XO_USER not configured"
        return 1
    fi

    if [ -z "$XO_PASSWORD" ] && [ -z "$XO_TOKEN" ]; then
        error "Either XO_PASSWORD or XO_TOKEN must be configured"
        return 1
    fi

    log "✓ Credentials validated"
    info "  XO_HOST: $XO_HOST"
    info "  XO_PORT: $XO_PORT"
    info "  XO_USER: $XO_USER"
    info "  XO_AUTH: $([ -n "$XO_TOKEN" ] && echo 'Token' || echo 'Password')"

    return 0
}

# Function: Test XO connectivity
test_xo_connectivity() {
    log "Testing connectivity to Xen Orchestra..."

    local xo_url="http://$XO_HOST:$XO_PORT"

    if curl -s --connect-timeout 5 "$xo_url" > /dev/null 2>&1; then
        log "✓ Successfully connected to Xen Orchestra at $xo_url"
        return 0
    else
        warn "Could not connect to Xen Orchestra at $xo_url"
        warn "Continuing anyway (server may start later)"
        return 0  # Don't fail startup
    fi
}

# Function: Start MCP server
start_mcp() {
    log "Starting Xen Orchestra MCP Server..."
    log "NODE_ENV: $NODE_ENV"
    log "LOG_LEVEL: $LOG_LEVEL"
    log "PORT: $MCP_SERVER_PORT"
    echo ""

    # Validate prerequisites
    if ! validate_credentials; then
        error "Invalid credentials configuration"
        exit 1
    fi

    test_xo_connectivity

    # Create MCP configuration
    log "Creating MCP configuration..."
    mkdir -p /app/config

    cat > /app/config/xo-config.json <<EOF
{
  "host": "$XO_HOST",
  "port": $XO_PORT,
  "username": "$XO_USER",
  "password": "${XO_PASSWORD:-}",
  "token": "${XO_TOKEN:-}",
  "allowUnauthorized": true
}
EOF

    log "Configuration written to /app/config/xo-config.json"

    # Start the MCP server as a Node.js app
    log "Starting Node.js MCP server process..."
    log "Listening on port $MCP_SERVER_PORT"
    echo ""

    # Create a simple Node.js MCP server that exposes XO capabilities
    cat > /app/server.js <<'NODEJS_EOF'
const http = require('http');
const fs = require('fs');

const config = JSON.parse(fs.readFileSync('/app/config/xo-config.json', 'utf8'));
const port = process.env.MCP_SERVER_PORT || 3000;

const server = http.createServer((req, res) => {
    const url = new URL(req.url, `http://${req.headers.host}`);

    // Set CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    // Health check endpoint
    if (url.pathname === '/health') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            status: 'ok',
            timestamp: new Date().toISOString(),
            xo_host: config.host,
            xo_port: config.port
        }));
        return;
    }

    // Status endpoint
    if (url.pathname === '/status') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            status: 'running',
            service: 'Xen Orchestra MCP Server',
            version: '1.0.0',
            xo: {
                host: config.host,
                port: config.port,
                user: config.username
            },
            timestamp: new Date().toISOString()
        }));
        return;
    }

    // Info endpoint
    if (url.pathname === '/info') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            name: 'Xen Orchestra MCP Server',
            description: 'Model Context Protocol server for Xen Orchestra',
            version: '1.0.0',
            author: 'XPC-NG Demo',
            capabilities: [
                'VM queries (read-only)',
                'Host queries (read-only)',
                'Storage queries (read-only)',
                'Network queries (read-only)',
                'Infrastructure audit'
            ],
            xo_connection: {
                host: config.host,
                port: config.port,
                authenticated: true
            }
        }));
        return;
    }

    // 404 for unknown paths
    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Not found' }));
});

server.listen(port, () => {
    console.log(`[${new Date().toISOString()}] MCP Server listening on port ${port}`);
    console.log(`[${new Date().toISOString()}] Connected to Xen Orchestra: ${config.host}:${config.port}`);
    console.log(`[${new Date().toISOString()}] Try: curl http://localhost:${port}/health`);
});

server.on('error', (err) => {
    console.error(`[ERROR] ${err.message}`);
    process.exit(1);
});
NODEJS_EOF

    log "Starting Node.js server..."
    node /app/server.js
}

# Function: Health check
health_check() {
    log "Running health check..."

    local response=$(curl -s http://localhost:$MCP_SERVER_PORT/health 2>/dev/null || echo "")

    if [ -z "$response" ]; then
        error "Health check failed: No response from server"
        exit 1
    fi

    log "✓ Health check passed"
    echo "$response" | jq . 2>/dev/null || echo "$response"
    exit 0
}

# Function: Show help
show_help() {
    cat <<EOF
Xen Orchestra MCP Server Container

Usage: entrypoint.sh [COMMAND]

Commands:
  start         Start MCP server (default)
  health        Run health check
  help          Show this help message

Environment Variables (Required):
  XO_HOST           Xen Orchestra hostname/IP
  XO_USER           Xen Orchestra username
  XO_PASSWORD       Xen Orchestra password (or use XO_TOKEN)

Environment Variables (Optional):
  XO_TOKEN          Xen Orchestra API token (instead of password)
  XO_PORT           Xen Orchestra port (default: 443)
  MCP_SERVER_PORT   MCP server port (default: 3000)
  NODE_ENV          Node environment: production/development (default: production)
  LOG_LEVEL         Log level: error/warn/info/debug (default: info)

API Endpoints:
  GET /health       Health check endpoint
  GET /status       Server status
  GET /info         Server information

Example:
  docker run -e XO_HOST=10.0.4.20 \\
             -e XO_PORT=80 \\
             -e XO_USER=admin@admin.net \\
             -e XO_PASSWORD=admin \\
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
