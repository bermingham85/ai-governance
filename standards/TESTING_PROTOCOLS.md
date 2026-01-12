# TESTING PROTOCOLS
**Comprehensive Testing Requirements**

**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Review Schedule:** Quarterly

---

## 🎯 PURPOSE

Ensure all code is properly tested before production deployment through comprehensive testing strategy.

---

## 📊 TEST COVERAGE REQUIREMENTS

| Test Type | Coverage Target | When to Run | Blocker |
|-----------|----------------|-------------|---------|
| **Unit Tests** | ≥80% | Every commit | Yes |
| **Integration Tests** | Critical paths | Pre-merge | Yes |
| **E2E Tests** | User journeys | Pre-deploy | Yes |
| **Performance Tests** | Key endpoints | Weekly | No |
| **Security Tests** | OWASP Top 10 | Pre-deploy | Yes |

---

## 🧪 UNIT TESTS

### Requirements

- **Coverage:** Minimum 80% line coverage
- **Speed:** All tests complete in <30 seconds
- **Isolation:** No external dependencies (mock/stub)
- **Assertions:** Clear, specific assertions
- **Documentation:** Each test describes what it tests

### Structure (Jest/TypeScript)

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', async () => {
      const userData = { email: 'test@example.com', name: 'Test' };
      const user = await userService.createUser(userData);
      
      expect(user.id).toBeDefined();
      expect(user.email).toBe('test@example.com');
      expect(user.createdAt).toBeInstanceOf(Date);
    });

    it('should throw ValidationError for invalid email', async () => {
      const userData = { email: 'invalid', name: 'Test' };
      
      await expect(userService.createUser(userData))
        .rejects
        .toThrow(ValidationError);
    });

    it('should throw ConflictError for duplicate email', async () => {
      const userData = { email: 'existing@example.com', name: 'Test' };
      
      await expect(userService.createUser(userData))
        .rejects
        .toThrow(ConflictError);
    });
  });
});
```

### Python (pytest)

```python
class TestUserService:
    def test_create_user_with_valid_data(self, user_service):
        """Should create user with valid data"""
        user_data = {"email": "test@example.com", "name": "Test"}
        user = user_service.create_user(user_data)
        
        assert user.id is not None
        assert user.email == "test@example.com"
        assert isinstance(user.created_at, datetime)

    def test_create_user_invalid_email_raises_error(self, user_service):
        """Should raise ValidationError for invalid email"""
        user_data = {"email": "invalid", "name": "Test"}
        
        with pytest.raises(ValidationError):
            user_service.create_user(user_data)
```

---

## 🔗 INTEGRATION TESTS

### Requirements

- **Coverage:** All critical API endpoints
- **Database:** Use test database or containers
- **Speed:** Complete in <2 minutes
- **Cleanup:** Reset state after each test
- **Real dependencies:** Database, external services (mocked)

### Example (API Integration)

```typescript
describe('POST /api/users', () => {
  beforeEach(async () => {
    await db.clear('users');
  });

  it('should create user and return 201', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ email: 'new@example.com', name: 'New User' })
      .expect(201);
    
    expect(response.body.user.id).toBeDefined();
    expect(response.body.user.email).toBe('new@example.com');
    
    // Verify database
    const userInDb = await db.users.findOne({ email: 'new@example.com' });
    expect(userInDb).toBeDefined();
  });

  it('should return 400 for invalid email', async () => {
    await request(app)
      .post('/api/users')
      .send({ email: 'invalid', name: 'Test' })
      .expect(400);
  });
});
```

---

## 🌐 E2E TESTS

### Requirements

- **Coverage:** Complete user journeys
- **Tools:** Playwright / Cypress
- **Environment:** Staging or dedicated E2E environment
- **Speed:** Complete in <5 minutes
- **Data:** Seed with realistic test data

### Example (Playwright)

```typescript
test('user registration flow', async ({ page }) => {
  // Navigate to registration
  await page.goto('/register');
  
  // Fill form
  await page.fill('[data-testid="email-input"]', 'test@example.com');
  await page.fill('[data-testid="password-input"]', 'SecurePass123!');
  await page.fill('[data-testid="name-input"]', 'Test User');
  
  // Submit
  await page.click('[data-testid="submit-button"]');
  
  // Verify success
  await expect(page.locator('[data-testid="success-message"]'))
    .toContainText('Registration successful');
  
  // Verify redirect to dashboard
  await expect(page).toHaveURL('/dashboard');
  
  // Verify user profile visible
  await expect(page.locator('[data-testid="user-name"]'))
    .toContainText('Test User');
});
```

---

## ⚡ PERFORMANCE TESTS

### Requirements

- **Load Testing:** Simulate realistic traffic
- **Stress Testing:** Find breaking points
- **Endurance:** Run for extended periods
- **Tools:** k6 / Artillery / JMeter

### Example (k6)

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 0 },   // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<200'], // 95% under 200ms
    http_req_failed: ['rate<0.01'],   // Less than 1% failures
  },
};

export default function () {
  const res = http.get('https://api.example.com/users');
  
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
  });
  
  sleep(1);
}
```

---

## 🔐 SECURITY TESTS

### Requirements

- **SAST:** Static analysis (SonarQube, Snyk)
- **DAST:** Dynamic testing (OWASP ZAP)
- **Dependency Scan:** Check vulnerabilities
- **Penetration Testing:** Quarterly professional audit

### Automated Security Tests

```typescript
describe('Security Tests', () => {
  it('should sanitize SQL injection attempts', async () => {
    const maliciousInput = "'; DROP TABLE users; --";
    
    const response = await request(app)
      .get(`/api/users/search?query=${maliciousInput}`)
      .expect(200);
    
    // Should not execute SQL, should treat as literal string
    expect(response.body.results).toHaveLength(0);
  });

  it('should prevent XSS attacks', async () => {
    const xssPayload = '<script>alert("XSS")</script>';
    
    const response = await request(app)
      .post('/api/comments')
      .send({ text: xssPayload })
      .expect(201);
    
    // Should be escaped
    expect(response.body.comment.text).not.toContain('<script>');
    expect(response.body.comment.text).toContain('&lt;script&gt;');
  });

  it('should require authentication for protected routes', async () => {
    await request(app)
      .get('/api/users/me')
      .expect(401);
  });
});
```

---

## 🔄 REGRESSION TESTS

### Requirements

- **Purpose:** Ensure old bugs don't return
- **Creation:** Add test for every bug fixed
- **Maintenance:** Run with every build
- **Coverage:** All previously fixed critical bugs

### Example

```typescript
describe('Regression Tests', () => {
  // Bug #1234: User profile not updating
  it('should update user profile (Bug #1234)', async () => {
    const user = await createTestUser();
    
    await request(app)
      .patch(`/api/users/${user.id}`)
      .send({ name: 'Updated Name' })
      .expect(200);
    
    const updated = await db.users.findById(user.id);
    expect(updated.name).toBe('Updated Name');
  });
});
```

---

## 🤖 TEST AUTOMATION

### CI/CD Pipeline

```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run unit tests
        run: npm run test:unit -- --coverage
      
      - name: Run integration tests
        run: npm run test:integration
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
      
      - name: Check coverage threshold
        run: |
          coverage=$(jq '.total.lines.pct' coverage/coverage-summary.json)
          if (( $(echo "$coverage < 80" | bc -l) )); then
            echo "Coverage $coverage% is below 80%"
            exit 1
          fi
```

---

## 📋 TEST CHECKLIST

Before merging PR:

- [ ] All unit tests pass
- [ ] Coverage ≥80%
- [ ] Integration tests pass
- [ ] No flaky tests
- [ ] Test names are descriptive
- [ ] Assertions are specific
- [ ] Edge cases tested
- [ ] Error cases tested
- [ ] Mocks/stubs properly used
- [ ] Test data cleaned up

---

## 🚫 TESTING ANTI-PATTERNS

### ❌ Testing Implementation Details
```typescript
// BAD: Tests internal implementation
it('should call getUserById method', () => {
  spyOn(userService, 'getUserById');
  // ...
});

// GOOD: Tests behavior/outcome
it('should return user data for valid ID', () => {
  const user = await userService.getUser('123');
  expect(user.id).toBe('123');
});
```

### ❌ Brittle Tests
```typescript
// BAD: Breaks if order changes
expect(users).toEqual([user1, user2, user3]);

// GOOD: Tests what matters
expect(users).toHaveLength(3);
expect(users).toContainEqual(expect.objectContaining({ id: 'user1' }));
```

### ❌ Slow Tests
```typescript
// BAD: Unnecessary delays
it('should save user', async () => {
  await sleep(5000); // Why?!
  // ...
});

// GOOD: Fast, focused test
it('should save user', async () => {
  const user = await userService.save(userData);
  expect(user.id).toBeDefined();
});
```

---

## 📈 TEST METRICS

Track these metrics:

| Metric | Target | How to Measure |
|--------|--------|----------------|
| **Coverage** | ≥80% | Coverage reports |
| **Pass Rate** | 100% | CI pipeline |
| **Execution Time** | <2 min total | CI logs |
| **Flaky Tests** | 0 | Test retry tracking |
| **New Tests per PR** | ≥1 per feature | PR review |

---

## 🔗 RELATED DOCUMENTS

- CODE_QUALITY_STANDARDS.md
- DEFINITION_OF_DONE.md
- PEER_REVIEW_CHECKLIST.md
- QUALITY_GATES.md

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-12

**Co-Authored-By: Warp <agent@warp.dev>**
