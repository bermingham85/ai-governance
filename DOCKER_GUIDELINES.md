# Docker Guidelines

**Version:** 1.0.0  
**Purpose:** Docker standards for containerized development and deployment  
**Last Updated:** 2026-01-09

---

## Overview

All projects should use Docker for:
- **Development** - Consistent environments across machines
- **Testing** - Isolated test execution
- **Deployment** - Production-ready containers

---

## Template Usage

### Available Templates

Located in `ai-governance/templates/`:

| Template | Purpose | Use Case |
|----------|---------|----------|
| `Dockerfile.python` | Python apps with uv | API servers, scripts, services |
| `Dockerfile.node` | Node.js apps | Web servers, APIs, microservices |
| `Dockerfile.devcontainer` | Dev environments | Consistent development setup |
| `docker-compose.yml` | Multi-service apps | App + database + cache |
| `docker-compose.dev.yml` | Dev environment | Development with live reload |
| `.dockerignore` | Build context filter | Exclude unnecessary files |

### Quick Start

**For Python project:**
```bash
# Copy template
cp C:\Users\bermi\Projects\ai-governance\templates\Dockerfile.python ./Dockerfile

# Replace placeholders
# [PYTHON_VERSION] → 3.12
# [PROJECT_NAME] → your-project

# Build
docker build -t your-project .

# Run
docker run --rm -p 8000:8000 your-project
```

**For Node project:**
```bash
# Copy template
cp C:\Users\bermi\Projects\ai-governance\templates\Dockerfile.node ./Dockerfile

# Replace placeholders
# [NODE_VERSION] → 20
# [PROJECT_NAME] → your-project

# Build
docker build -t your-project .

# Run
docker run --rm -p 3000:3000 your-project
```

---

## Security Best Practices

### 1. Non-Root User (MANDATORY)
**Always run containers as non-root user**

```dockerfile
# Create user
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app
USER appuser
```

**Why:** Prevents privilege escalation if container is compromised

### 2. Minimal Base Images
**Use slim or alpine variants**

```dockerfile
# Good
FROM python:3.12-slim
FROM node:20-alpine

# Bad
FROM python:3.12  # Full image, unnecessary size
```

**Why:** Smaller attack surface, faster builds, less storage

### 3. Layer Caching
**Order commands for optimal caching**

```dockerfile
# Good - dependencies cached separately
COPY requirements.txt ./
RUN uv add -r requirements.txt
COPY . .

# Bad - cache invalidated on any code change
COPY . .
RUN uv add -r requirements.txt
```

**Why:** Faster rebuilds during development

### 4. Health Checks (MANDATORY)
**All production containers must have health checks**

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1
```

**Why:** Automatic container restart on failure

### 5. Secrets Management
**NEVER commit secrets in Dockerfiles or images**

```dockerfile
# Bad
ENV API_KEY=secret123

# Good - use env_file or secrets
# Pass at runtime
```

**How to handle secrets:**
```bash
# Option 1: Environment file
docker run --env-file .env your-image

# Option 2: Docker secrets
docker secret create api_key api_key.txt
docker service create --secret api_key your-image

# Option 3: docker-compose
services:
  app:
    env_file:
      - .env
    secrets:
      - api_key
```

### 6. Multi-Stage Builds (For Production)
**Separate build and runtime environments**

```dockerfile
# Build stage
FROM python:3.12 AS builder
WORKDIR /app
COPY requirements.txt .
RUN uv add -r requirements.txt

# Runtime stage
FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY . .
USER appuser
CMD ["uv", "run", "main.py"]
```

**Why:** Smaller final image, no build tools in production

---

## Development Workflow

### Dev Containers

**Setup:**
```bash
# Create .devcontainer directory
mkdir .devcontainer
cp C:\Users\bermi\Projects\ai-governance\templates\Dockerfile.devcontainer .devcontainer/Dockerfile

# Create devcontainer.json (VS Code)
{
  "name": "Project Dev Container",
  "dockerComposeFile": "docker-compose.dev.yml",
  "service": "dev",
  "workspaceFolder": "/workspace",
  "extensions": [
    "ms-python.python",
    "ms-python.vscode-pylance"
  ]
}
```

**Usage:**
```bash
# Start dev environment
docker-compose -f docker-compose.dev.yml up -d

# Attach to container
docker exec -it project-dev bash

# Install dependencies
uv add package-name

# Run tests
uv run --frozen pytest

# Stop environment
docker-compose -f docker-compose.dev.yml down
```

---

## Docker Compose Best Practices

### Environment Variables

**Use .env file for configuration:**
```bash
# .env (never commit)
PROJECT_NAME=my-project
APP_PORT=8000
DB_USER=postgres
DB_PASSWORD=secretpassword
DB_NAME=mydb
```

**Reference in docker-compose.yml:**
```yaml
services:
  app:
    container_name: ${PROJECT_NAME}-app
    ports:
      - "${APP_PORT}:8000"
```

### Service Dependencies

**Use depends_on with health checks:**
```yaml
services:
  app:
    depends_on:
      database:
        condition: service_healthy
    
  database:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 10s
```

### Named Volumes

**Use named volumes for persistence:**
```yaml
volumes:
  db-data:
    driver: local
  redis-data:
    driver: local
```

---

## Common Commands

### Building
```bash
# Build from Dockerfile
docker build -t project-name .

# Build with specific target (multi-stage)
docker build --target production -t project-name .

# Build with no cache
docker build --no-cache -t project-name .

# Build with build args
docker build --build-arg PYTHON_VERSION=3.12 -t project-name .
```

### Running
```bash
# Run with port mapping
docker run -p 8000:8000 project-name

# Run with env file
docker run --env-file .env project-name

# Run with volume mount
docker run -v $(pwd)/logs:/app/logs project-name

# Run in detached mode
docker run -d project-name

# Run with auto-remove
docker run --rm project-name
```

### Docker Compose
```bash
# Start services
docker-compose up

# Start in detached mode
docker-compose up -d

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# View logs
docker-compose logs -f

# Rebuild services
docker-compose up --build

# Scale service
docker-compose up --scale app=3
```

### Debugging
```bash
# View container logs
docker logs container-name
docker logs -f container-name  # Follow

# Execute command in running container
docker exec container-name ls -la

# Interactive shell
docker exec -it container-name bash

# Inspect container
docker inspect container-name

# View resource usage
docker stats

# List all containers
docker ps -a

# Remove stopped containers
docker container prune
```

### Image Management
```bash
# List images
docker images

# Remove image
docker rmi image-name

# Remove unused images
docker image prune

# Tag image
docker tag source-image:tag target-image:tag

# Save image to file
docker save -o image.tar image-name

# Load image from file
docker load -i image.tar
```

---

## Health Check Guidelines

### Application Health Endpoint

**Every application should expose `/health` endpoint:**

**Python (FastAPI):**
```python
@app.get("/health")
async def health():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}
```

**Node (Express):**
```javascript
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});
```

### Docker Health Check

**In Dockerfile:**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1
```

**In docker-compose.yml:**
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
  interval: 30s
  timeout: 3s
  retries: 3
  start_period: 5s
```

---

## Troubleshooting

### Build Failures

**Problem:** Build fails with "layer too large"
**Solution:** Use .dockerignore to exclude large files
```bash
# Add to .dockerignore
node_modules/
*.log
.git/
```

**Problem:** Package installation fails
**Solution:** Clear Docker cache
```bash
docker build --no-cache -t project-name .
```

### Runtime Issues

**Problem:** Container exits immediately
**Solution:** Check logs
```bash
docker logs container-name
```

**Problem:** Can't connect to service
**Solution:** Verify port mapping and firewall
```bash
docker ps  # Check port mappings
netstat -an | grep 8000  # Check if port is in use
```

**Problem:** Permission denied
**Solution:** Ensure correct file ownership
```dockerfile
RUN chown -R appuser:appuser /app
USER appuser
```

### Performance Issues

**Problem:** Slow builds
**Solution:** 
1. Optimize layer caching
2. Use multi-stage builds
3. Reduce image size

**Problem:** High memory usage
**Solution:** Set memory limits
```yaml
services:
  app:
    deploy:
      resources:
        limits:
          memory: 512M
```

---

## Integration with Governance

### WARP.md Docker Section

**Every project WARP.md should include:**
```markdown
## Docker Setup

**Build:**
```bash
docker build -t project-name .
```

**Run:**
```bash
docker run --env-file .env -p 8000:8000 project-name
```

**Development:**
```bash
docker-compose -f docker-compose.dev.yml up
```

**Health Check:**
http://localhost:8000/health
```

### Automated Docker Operations

**Warp can autonomously:**
- Generate Dockerfile from template
- Test Docker builds before committing
- Add health checks to containers
- Create docker-compose.yml for multi-service projects
- Update .dockerignore
- Document Docker usage in WARP.md

**n8n can trigger:**
- Scheduled Docker builds
- Health check monitoring
- Image updates
- Container restarts

---

## Windows-Specific Notes

### Docker Desktop on Windows

**Requirements:**
- Docker Desktop for Windows
- WSL 2 backend enabled
- Hyper-V enabled (for older versions)

**Path Handling:**
```bash
# Windows paths in docker-compose.yml
volumes:
  - C:\Users\bermi\Projects\project:/app

# Or use relative paths
volumes:
  - ./logs:/app/logs
```

### PowerShell Commands

**Building:**
```powershell
docker build -t project-name .
```

**Running with env file:**
```powershell
docker run --env-file .env -p 8000:8000 project-name
```

**Mounting volumes:**
```powershell
docker run -v ${PWD}/logs:/app/logs project-name
```

---

## Checklist for New Projects

When creating a new project with Docker:

- [ ] Copy appropriate Dockerfile template
- [ ] Replace placeholders ([PYTHON_VERSION], [PROJECT_NAME])
- [ ] Create .dockerignore from template
- [ ] Add health check endpoint to application
- [ ] Test Docker build locally
- [ ] Create docker-compose.yml if multi-service
- [ ] Create .env.example with required variables
- [ ] Document Docker commands in WARP.md
- [ ] Add Docker setup to project README
- [ ] Test container health checks
- [ ] Verify non-root user configuration
- [ ] Commit Dockerfile with project

---

## Next Steps

### Phase 2 Completion:
- [x] Dockerfile templates created
- [x] docker-compose templates created
- [x] Dev container configs created
- [x] .dockerignore template created
- [x] Docker guidelines documented

### Phase 3: Automation
- [ ] n8n workflow for automated Docker builds
- [ ] Health check monitoring system
- [ ] Automated image updates
- [ ] Container deployment pipeline

---

**Version:** 1.0.0  
**Next Review:** 2026-02-09  
**Governance Compliant:** ✅

---

**Co-Authored-By: Warp <agent@warp.dev>**
