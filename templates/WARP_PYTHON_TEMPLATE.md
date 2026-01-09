# WARP.md - [Project Name]

**Project Type:** Python  
**Status:** [Active / Development / Maintenance]  
**Governance Version:** 1.0.0  
**Last Updated:** [YYYY-MM-DD]

---

## ⚠️ MANDATORY GOVERNANCE COMPLIANCE

This project operates under the governance framework:

**Required Reading:**
1. `C:\Users\bermi\Projects\ai-governance\GLOBAL_AI_RULES.md` (RULE 12-16)
2. `C:\Users\bermi\Projects\ai-governance\HANDOVER_PROTOCOL.md`

**Key Principles:**
- Claude designs, Warp executes, GitHub is source of truth
- All handovers follow HANDOVER_PROTOCOL.md format
- Errors follow RULE 16 (classify, route, max 2 attempts)
- Protected zones are off-limits

**Governance Override:**
User must explicitly state: "Skip governance for [reason] because [benefit]"

---

## Project Overview

**Description:**  
[Brief 1-2 sentence description of what this project does]

**Primary Purpose:**  
[What problem does this solve?]

**Key Technologies:**  
- Python [version]
- uv (package management)
- [Framework: FastAPI / Django / Flask / etc.]
- [Database if applicable]

---

## Python-Specific Rules

### Package Management (MANDATORY)

**Use `uv` exclusively** - Do NOT use pip or @latest syntax

**Installation:**
```bash
uv add package-name
```

**Development dependencies:**
```bash
uv add --dev package-name
```

**Upgrade packages:**
```bash
uv add --dev package-name --upgrade-package package-name
```

**Run tools:**
```bash
uv run tool-name
```

**Run with frozen lockfile:**
```bash
uv run --frozen command
```

### Development Environment

**Python Version:** [3.10 / 3.11 / 3.12]  
**Virtual Environment:** Managed by uv

**Setup:**
```bash
cd C:\Users\bermi\Projects\[project-name]
uv add -r requirements.txt
```

**Testing:**
```bash
uv run --frozen pytest
```

**Linting & Formatting:**
```bash
# Format code
uv run --frozen ruff format .

# Check linting
uv run --frozen ruff check .

# Auto-fix linting issues
uv run --frozen ruff check . --fix

# Type checking
uv run --frozen pyright
```

**Pre-commit Hooks:**
```bash
# Install hooks
uv run pre-commit install

# Run manually
uv run pre-commit run --all-files
```

---

### Code Standards

**Type Hints:**
- **MANDATORY** on all functions and methods
- Use `typing` module for complex types
- Public APIs must have complete type hints
- Return types are required

**Example:**
```python
from typing import Optional, List, Dict

def process_data(
    items: List[str],
    config: Optional[Dict[str, str]] = None
) -> Dict[str, int]:
    ...
```

**Docstrings:**
- **MANDATORY** for all public APIs
- Use Google or NumPy style
- Include parameters, return types, and examples

**Example:**
```python
def calculate_total(prices: List[float], tax_rate: float = 0.1) -> float:
    """Calculate total price including tax.
    
    Args:
        prices: List of individual prices
        tax_rate: Tax rate as decimal (default: 0.1 for 10%)
        
    Returns:
        Total price including tax
        
    Example:
        >>> calculate_total([10.0, 20.0], 0.15)
        34.5
    """
    ...
```

**Function Design:**
- Keep functions small and focused (one responsibility)
- Max ~20-30 lines per function
- Extract complex logic into helper functions

**Code Organization:**
- Follow existing patterns in the codebase exactly
- Group related functions into modules
- Use descriptive names (avoid abbreviations)

**Line Length:**
- Maximum 120 characters
- Break long lines sensibly
- Use parentheses for natural line breaks

---

### Testing Requirements

**Test Framework:** pytest with anyio for async

**Coverage Requirements:**
- All new features must have tests
- All bug fixes must have tests
- Public APIs must have comprehensive tests
- Cover edge cases and error conditions

**Test Structure:**
```python
import pytest
from anyio import run  # For async tests, NOT asyncio


def test_feature_name():
    """Test description."""
    # Arrange
    input_data = ...
    
    # Act
    result = function_under_test(input_data)
    
    # Assert
    assert result == expected_value


@pytest.mark.asyncio
async def test_async_feature():
    """Test async functionality."""
    result = await async_function()
    assert result is not None
```

**Run Tests:**
```bash
# All tests
uv run --frozen pytest

# Specific test file
uv run --frozen pytest tests/test_module.py

# With coverage
uv run --frozen pytest --cov=src --cov-report=html

# Verbose output
uv run --frozen pytest -v
```

**Disable Plugin Autoload (if needed):**
```bash
PYTEST_DISABLE_PLUGIN_AUTOLOAD="" uv run --frozen pytest
```

---

### Exception Handling

**Logging Exceptions:**
```python
import logging

logger = logging.getLogger(__name__)

try:
    risky_operation()
except SpecificException:
    logger.exception("Operation failed")  # Includes traceback automatically
```

**Exception Specificity:**
- Catch specific exceptions where possible: `OSError`, `json.JSONDecodeError`, `ValueError`
- Catch generic `Exception` only in:
  - Top-level handlers
  - Cleanup/finally blocks
  - Plugin/extension systems

**Bad:**
```python
try:
    something()
except Exception as e:
    logger.exception(f"Error: {e}")  # Don't include exception in message
```

**Good:**
```python
try:
    with open(file_path) as f:
        data = json.load(f)
except FileNotFoundError:
    logger.exception("Config file not found")
except json.JSONDecodeError:
    logger.exception("Invalid JSON in config")
```

---

### Git Workflow

**Commit Message Format:**
```
[type]: [subject in present tense]

[optional body explaining WHY, not WHAT]

[trailers]
Co-Authored-By: Warp <agent@warp.dev>
```

**Commit Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation only
- `refactor:` - Code restructuring
- `test:` - Test additions/changes
- `chore:` - Maintenance (deps, configs)
- `perf:` - Performance improvement

**Trailers (when applicable):**
```bash
# For bug fixes
git commit --trailer "Reported-by: John Doe"

# For GitHub issues
git commit --trailer "Github-Issue: #123"
```

**NEVER mention:**
- Co-authored-by in commit message body (use trailer only)
- Commit message tools or formatters

---

## Docker Support (Optional)

**Dockerfile Example:**
```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY . /app

# Install uv and dependencies
RUN pip install uv && \
    uv add -r requirements.txt

# Run application
CMD ["uv", "run", "main.py"]
```

**Build & Run:**
```bash
# Build image
docker build -t [project-name] .

# Run container
docker run --rm [project-name]

# With environment variables
docker run --rm --env-file .env [project-name]
```

---

## Setup Script

**setup.sh / setup.ps1:**
```bash
#!/bin/bash
set -e

echo "Installing dependencies..."
uv add -r requirements.txt

echo "Running tests..."
PYTEST_DISABLE_PLUGIN_AUTOLOAD="" uv run --frozen pytest

echo "Running linting..."
uv run --frozen ruff check .

echo "Running type checking..."
uv run --frozen pyright

echo "✅ Setup complete."
```

**Make executable:**
```bash
chmod +x setup.sh
```

---

## Protected Zones

### Project-Specific Protections
**Do NOT modify without explicit approval:**
- `requirements.txt` / `pyproject.toml` (dependency versions)
- Database migration files
- Production configuration files
- API schemas / contracts

**Require user review before:**
- Breaking API changes
- Database schema changes
- Major dependency upgrades
- Changes to authentication/authorization

---

## Dependencies & External Services

### Required Services
| Service | Purpose | Endpoint |
|---------|---------|----------|
| [Database] | [Purpose] | [Connection string location] |
| n8n | [If used] | http://192.168.50.246:5678 |
| [API] | [Purpose] | [Base URL] |

### API Keys / Secrets
**Location:** `.env` file (never committed)  
**Documentation:** See `C:\Users\bermi\Projects\ai-governance\SECRETS_REGISTRY.md`

**Environment Variables:**
```bash
# .env.example
DATABASE_URL=postgresql://localhost/dbname
API_KEY=your_api_key_here
SECRET_KEY=your_secret_key_here
```

---

## Error Handling (RULE 16 Compliance)

### When Warp Encounters Error

**Type A - Build/Runtime Errors:**
```bash
# Example: ImportError, ModuleNotFoundError
1. Check dependencies are installed: uv add --dev --upgrade-package [package]
2. Verify Python version compatibility
3. Max 2 attempts → Escalate to Claude with full error output
```

**Type B - Logic/Architecture Errors:**
```bash
# Example: Incorrect data flow, broken assumptions
1. STOP immediately
2. Hand to Claude with context
3. Do not attempt to redesign
```

**Type D - Integration Errors:**
```bash
# Example: API failures, database connection issues
1. Check service is running
2. Verify credentials/config
3. Check network connectivity
4. Review API documentation
5. Max 2 attempts → Research or escalate
```

### Error Log
**Location:** `./ERROR_LOG.md`  
**Template:** `C:\Users\bermi\Projects\ai-governance\templates\ERROR_LOG.md`

---

## Pull Requests

**PR Description Template:**
```markdown
## Summary
[High-level description of changes]

## Changes
- [Change 1]
- [Change 2]

## Testing
[What tests were added/updated]

## Breaking Changes
[If any, describe migration path]

## Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Linting passes
- [ ] Type checking passes
```

**PR Guidelines:**
- Write detailed, high-level descriptions
- Avoid low-level code specifics unless clarifying
- Explain WHY, not just WHAT
- Link related issues

---

## Common Tasks

### Adding a New Feature
```bash
# 1. Create branch
git checkout -b feature/description

# 2. Implement feature with tests
# [code changes]

# 3. Format and lint
uv run --frozen ruff format .
uv run --frozen ruff check . --fix

# 4. Type check
uv run --frozen pyright

# 5. Run tests
uv run --frozen pytest

# 6. Commit
git add .
git commit -m "feat: add [feature description]

Co-Authored-By: Warp <agent@warp.dev>"

# 7. Push and create PR
git push origin feature/description
```

### Fixing a Bug
```bash
# 1. Create branch
git checkout -b fix/bug-description

# 2. Write failing test (if possible)
# [test code]

# 3. Implement fix
# [fix code]

# 4. Verify test passes
uv run --frozen pytest tests/test_module.py

# 5. Commit with trailer
git add .
git commit --trailer "Reported-by: [Name]" -m "fix: resolve [bug description]

Co-Authored-By: Warp <agent@warp.dev>"
```

### Updating Dependencies
```bash
# Update specific package
uv add --dev package-name --upgrade-package package-name

# Test thoroughly
uv run --frozen pytest

# Check for breaking changes in changelog

# Commit
git commit -m "chore: upgrade [package] to [version]

Co-Authored-By: Warp <agent@warp.dev>"
```

---

## Project Contacts

**Owner:** [Name/Role]  
**Repository:** [GitHub URL]  
**Documentation:** [Wiki/Docs location]  
**Issues:** [Issue tracker URL]

---

## Inheritance & References

**Inherits From:**
- Global Rules: `ai-governance\GLOBAL_AI_RULES.md`
- Handover Protocol: `ai-governance\HANDOVER_PROTOCOL.md`
- Platform Rules: `orchestrator\platforms\warp.md`
- Base Template: `ai-governance\templates\WARP_BASE_TEMPLATE.md`

**Python-Specific Extensions:**
- uv package management (mandatory)
- Type hints (mandatory)
- pytest + anyio for testing
- ruff for linting/formatting
- pyright for type checking

---

## Version History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0.0 | [YYYY-MM-DD] | Initial Python project setup | [Name] |

---

**Next Review Date:** [YYYY-MM-DD]  
**Template Version:** 1.0.0  
**Governance Compliant:** ✅

---

**Co-Authored-By: Warp <agent@warp.dev>**
