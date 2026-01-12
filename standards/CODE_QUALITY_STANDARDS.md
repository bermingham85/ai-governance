# CODE QUALITY STANDARDS
**Defining Acceptable Code Quality Metrics**

**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Review Schedule:** Quarterly

---

## 🎯 PURPOSE

Define clear, measurable standards for code quality that all projects must meet before merging to main.

---

## 📏 QUALITY METRICS

### Minimum Requirements

| Metric | Target | Tool | Enforcement |
|--------|--------|------|-------------|
| **Linting** | 0 errors, <5 warnings | ESLint/Ruff/etc. | Pre-commit hook |
| **Type Safety** | 100% (strict mode) | TypeScript/mypy | CI pipeline |
| **Test Coverage** | ≥80% | Jest/pytest-cov | CI pipeline |
| **Code Complexity** | ≤10 cyclomatic | ESLint/radon | CI warning |
| **Duplicated Code** | <3% | jscpd/pylint | CI warning |
| **Security Vulns** | 0 critical/high | Snyk/Bandit | CI blocker |
| **Doc Coverage** | ≥90% public APIs | JSDoc/Sphinx | CI warning |

---

## 🔧 LINTING RULES

### JavaScript/TypeScript (ESLint)

```json
{
  "extends": ["airbnb-base", "plugin:@typescript-eslint/recommended"],
  "rules": {
    "no-console": "error",
    "no-debugger": "error",
    "no-unused-vars": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-explicit-any": "error",
    "max-lines-per-function": ["warn", 50],
    "complexity": ["warn", 10]
  }
}
```

### Python (Ruff)

```toml
[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "W", "C90", "I", "N", "D", "UP", "S", "B", "A"]
ignore = ["D203", "D213"]

[tool.ruff.lint.per-file-ignores]
"tests/**/*.py" = ["S101"]  # Allow assert in tests
```

---

## 🔒 TYPE SAFETY

### TypeScript (tsconfig.json)

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

### Python (mypy)

```ini
[mypy]
python_version = 3.11
strict = True
warn_return_any = True
warn_unused_configs = True
disallow_untyped_defs = True
```

---

## 📝 DOCUMENTATION REQUIREMENTS

### Code Comments

**DO:**
- Document WHY, not WHAT
- Explain complex algorithms
- Note non-obvious decisions
- Reference tickets/ADRs

**DON'T:**
- State the obvious
- Leave TODO without ticket
- Comment out code (delete it)

### Function Documentation

**Required for all public functions:**

```typescript
/**
 * Calculates user credit score based on payment history
 * 
 * @param userId - Unique user identifier
 * @param lookbackMonths - Number of months to analyze (default: 12)
 * @returns Credit score 300-850, or null if insufficient data
 * @throws {ValidationError} If userId is invalid
 * 
 * @example
 * ```typescript
 * const score = await calculateCreditScore("user123", 24);
 * console.log(score); // 720
 * ```
 */
async function calculateCreditScore(
  userId: string, 
  lookbackMonths: number = 12
): Promise<number | null> {
  // Implementation
}
```

---

## 🧪 TEST REQUIREMENTS

See TESTING_PROTOCOLS.md for details. Summary:

- **Unit tests:** ≥80% coverage
- **Integration tests:** Critical paths
- **E2E tests:** User journeys
- **All tests pass:** Before merge

---

## 🔐 SECURITY SCANNING

### Required Scans

1. **Dependency vulnerabilities:** `npm audit` / `safety check`
2. **Static analysis:** Snyk / Bandit
3. **Secret scanning:** git-secrets / TruffleHog
4. **SAST:** SonarQube

### Severity Handling

| Severity | Action |
|----------|--------|
| **Critical** | Block merge, fix immediately |
| **High** | Block merge, fix before deploy |
| **Medium** | Create ticket, fix in sprint |
| **Low** | Create ticket, backlog |

---

## ⚡ PERFORMANCE BENCHMARKS

### Response Times

| Endpoint Type | Target | Max |
|---------------|--------|-----|
| GET (read) | <100ms | <200ms |
| POST (write) | <200ms | <500ms |
| Complex query | <500ms | <2s |

### Resource Usage

- **Memory:** <512MB per service
- **CPU:** <50% average
- **Database queries:** <10 per request

---

## 📊 CODE METRICS

### Cyclomatic Complexity

- **Target:** ≤10 per function
- **Max:** ≤20 (warn at 15)

### Function Length

- **Target:** ≤30 lines
- **Max:** ≤50 lines (warn at 40)

### File Length

- **Target:** ≤300 lines
- **Max:** ≤500 lines (warn at 400)

---

## 🚨 AUTO-REJECT CRITERIA

Code automatically rejected if:

- ❌ Linting errors present
- ❌ Type errors exist
- ❌ Tests failing
- ❌ Coverage drops below 80%
- ❌ Critical security vulnerabilities
- ❌ Secrets in code
- ❌ console.log / print() in prod code

---

## ✅ QUALITY CHECKLIST

Before submitting PR:

- [ ] Linter passes (0 errors)
- [ ] Type checker passes (strict mode)
- [ ] All tests pass
- [ ] Coverage ≥80%
- [ ] Security scan clean
- [ ] No console.log/debugger
- [ ] Functions documented
- [ ] Complex logic commented
- [ ] No secrets in code
- [ ] Performance acceptable

---

## 🔗 RELATED DOCUMENTS

- DEFINITION_OF_DONE.md
- TESTING_PROTOCOLS.md
- PEER_REVIEW_CHECKLIST.md
- QUALITY_GATES.md

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-12

**Co-Authored-By: Warp <agent@warp.dev>**
