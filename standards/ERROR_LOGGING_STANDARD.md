# ERROR LOGGING STANDARD

**Version:** 1.0  
**Last Updated:** 2026-01-12  
**Owner:** Engineering Team  
**Related:** ERROR_HANDLING_PROTOCOL.md, INCIDENT_RESPONSE_PLAYBOOK.md

---

## PURPOSE

Establish consistent logging practices for effective debugging, monitoring, and incident response across all systems.

---

## LOG LEVELS

### Standard Levels (Severity Order)
```
TRACE → DEBUG → INFO → WARN → ERROR → FATAL
```

### Level Definitions

#### 🔍 TRACE
**When:** Detailed diagnostic information (disabled in production)
```typescript
// Example: Every function entry/exit
logger.trace('Entering calculateTotal()', { userId: 123, items: 5 });
logger.trace('Exiting calculateTotal()', { result: 59.99 });
```
**Production:** OFF  
**Development:** Optional

---

#### 🐛 DEBUG
**When:** Information useful for debugging
```typescript
// Example: Variable states, decision paths
logger.debug('Cache miss, fetching from database', { key: 'user:123' });
logger.debug('Applying discount', { original: 100, discount: 0.2, final: 80 });
```
**Production:** OFF (or rate-limited)  
**Development:** ON

---

#### ℹ️ INFO
**When:** Normal application flow, important business events
```typescript
// Example: User actions, system state changes
logger.info('User logged in', { userId: 123, method: 'oauth' });
logger.info('Payment processed', { orderId: 'ORD-456', amount: 59.99 });
logger.info('Background job started', { jobType: 'email-batch', items: 1000 });
```
**Production:** ON  
**Development:** ON

---

#### ⚠️ WARN
**When:** Recoverable issues, deprecated features, potential problems
```typescript
// Example: Degraded performance, fallback used
logger.warn('API slow response', { endpoint: '/api/users', latency: 2500 });
logger.warn('Cache unavailable, using direct database', { cache: 'redis' });
logger.warn('Deprecated API called', { endpoint: '/v1/users', caller: 'mobile-app' });
```
**Production:** ON  
**Development:** ON  
**Alert:** Threshold-based (e.g., >100 warns/minute)

---

#### ❌ ERROR
**When:** Errors that affect current operation but system continues
```typescript
// Example: Failed requests, validation errors, external service failures
logger.error('Failed to send email', { 
  userId: 123, 
  error: err.message, 
  stack: err.stack,
  emailType: 'welcome' 
});
logger.error('Database query failed', { 
  query: 'SELECT * FROM users WHERE id = ?', 
  error: err.message 
});
```
**Production:** ON  
**Development:** ON  
**Alert:** Immediate (any ERROR triggers alert)

---

#### 💀 FATAL
**When:** System is unusable, requires immediate shutdown
```typescript
// Example: Database unreachable, critical config missing
logger.fatal('Database connection pool exhausted', { 
  error: err.message,
  poolSize: 20,
  activeConnections: 20 
});
logger.fatal('Required environment variable missing', { variable: 'DATABASE_URL' });
// Process exits after FATAL
```
**Production:** ON  
**Development:** ON  
**Alert:** Immediate + Page on-call engineer

---

## STRUCTURED LOGGING FORMAT

### Required Format: JSON
```json
{
  "timestamp": "2026-01-12T19:24:02.123Z",
  "level": "ERROR",
  "message": "Failed to process payment",
  "context": {
    "userId": "usr_123",
    "orderId": "ord_456",
    "amount": 59.99,
    "currency": "USD",
    "paymentMethod": "stripe"
  },
  "error": {
    "message": "Card declined",
    "type": "StripeCardError",
    "code": "card_declined",
    "stack": "Error: Card declined\n    at ..."
  },
  "metadata": {
    "service": "payment-service",
    "version": "2.1.0",
    "environment": "production",
    "hostname": "api-server-03",
    "requestId": "req_789xyz",
    "correlationId": "trace_abc123"
  }
}
```

### Required Fields (All Logs)
```typescript
interface LogEntry {
  timestamp: string;        // ISO 8601 format
  level: LogLevel;          // TRACE|DEBUG|INFO|WARN|ERROR|FATAL
  message: string;          // Human-readable description
  service: string;          // Service/application name
  version: string;          // Application version
  environment: string;      // production|staging|development
  hostname: string;         // Server/container identifier
}
```

### Required Fields (ERROR/FATAL Only)
```typescript
interface ErrorLogEntry extends LogEntry {
  error: {
    message: string;        // Error message
    type: string;           // Error class/type
    code?: string;          // Error code (if applicable)
    stack: string;          // Full stack trace
  };
  context: object;          // Relevant business context
  requestId?: string;       // Request ID (for HTTP requests)
  userId?: string;          // User ID (if authenticated)
}
```

---

## CONTEXTUAL INFORMATION

### Always Include (When Available)
```typescript
// User Context
userId: string
userEmail?: string
userRole: string

// Request Context (HTTP)
requestId: string           // Unique per request
method: string              // GET, POST, etc.
path: string                // /api/users/123
statusCode: number          // 200, 404, 500
latency: number             // Request duration (ms)
userAgent: string

// Business Context
orderId?: string
transactionId?: string
customerId?: string
resourceId: string          // Generic resource identifier

// System Context
service: string
version: string
environment: string
hostname: string
processId: number
```

### Correlation IDs
```typescript
// Link related logs across services
correlationId: string       // Same across entire user flow
requestId: string           // Unique per HTTP request
spanId: string              // Unique per operation (distributed tracing)
parentSpanId?: string       // Parent operation (distributed tracing)
```

**Example Usage:**
```typescript
// Service A
logger.info('Initiating payment', { 
  correlationId: 'corr_abc123',
  requestId: 'req_111',
  spanId: 'span_001'
});

// Service B (called by Service A)
logger.info('Processing payment', {
  correlationId: 'corr_abc123',  // SAME as Service A
  requestId: 'req_222',           // NEW for this request
  spanId: 'span_002',             // NEW for this operation
  parentSpanId: 'span_001'        // Reference to Service A
});
```

---

## WHAT TO LOG

### ✅ DO LOG

#### Business Events
```typescript
✓ User registrations/logins
✓ Payment transactions
✓ Order creation/updates
✓ Data exports
✓ Configuration changes
✓ Permission grants/revokes
```

#### System Events
```typescript
✓ Service startup/shutdown
✓ Database migrations
✓ Cache invalidations
✓ Scheduled job executions
✓ Circuit breaker state changes
✓ Rate limit hits
```

#### Integration Events
```typescript
✓ External API calls (start/end)
✓ Queue message processing
✓ Webhook deliveries
✓ File uploads/downloads
```

#### Error Conditions
```typescript
✓ All exceptions with stack traces
✓ Validation failures
✓ Authentication/authorization failures
✓ Timeout errors
✓ Retry attempts
```

---

### ❌ DO NOT LOG

#### Sensitive Data (PCI/PII/GDPR)
```typescript
✗ Full credit card numbers (log last 4 digits only)
✗ CVV codes
✗ Passwords (plain or hashed)
✗ Social Security Numbers
✗ API keys/secrets
✗ Session tokens
✗ Personal health information
✗ Full IP addresses (log first 3 octets only)
```

#### Excessive Data
```typescript
✗ Full request/response bodies (log IDs/sizes instead)
✗ Large binary data
✗ Complete database records
✗ Entire file contents
```

**Safe Alternatives:**
```typescript
// ❌ BAD
logger.info('User data', { user: entireUserObject });

// ✅ GOOD
logger.info('User updated', { 
  userId: user.id, 
  fieldsChanged: ['email', 'phone'],
  changedBy: adminId 
});

// ❌ BAD
logger.info('API response', { body: largeResponseBody });

// ✅ GOOD
logger.info('API response', { 
  statusCode: 200, 
  bodySize: 15234,
  latency: 245 
});
```

---

## ERROR LOGGING BEST PRACTICES

### Include Complete Context
```typescript
// ❌ BAD - Not useful
logger.error('Database error', { error: err.message });

// ✅ GOOD - Actionable
logger.error('Failed to fetch user profile', {
  error: {
    message: err.message,
    type: err.constructor.name,
    code: err.code,
    stack: err.stack
  },
  context: {
    userId: 123,
    query: 'SELECT * FROM users WHERE id = ?',
    database: 'primary',
    retryAttempt: 2,
    maxRetries: 3
  },
  requestId: req.id
});
```

### Log Before Retries
```typescript
for (let attempt = 1; attempt <= maxRetries; attempt++) {
  try {
    return await apiCall();
  } catch (err) {
    logger.warn('API call failed, retrying', {
      attempt,
      maxRetries,
      error: err.message,
      endpoint: '/api/users'
    });
    
    if (attempt === maxRetries) {
      logger.error('API call failed after all retries', {
        attempts: maxRetries,
        error: err.message,
        stack: err.stack
      });
      throw err;
    }
  }
}
```

### Aggregate Similar Errors
```typescript
// ❌ BAD - Logs spam (1000 identical logs)
users.forEach(user => {
  try {
    processUser(user);
  } catch (err) {
    logger.error('Failed to process user', { userId: user.id, error: err });
  }
});

// ✅ GOOD - Aggregated logging
const failures = [];
users.forEach(user => {
  try {
    processUser(user);
  } catch (err) {
    failures.push({ userId: user.id, error: err.message });
  }
});

if (failures.length > 0) {
  logger.error('Batch user processing failed', {
    totalUsers: users.length,
    failureCount: failures.length,
    failures: failures.slice(0, 10), // Log first 10 only
    failureRate: (failures.length / users.length * 100).toFixed(2) + '%'
  });
}
```

---

## PERFORMANCE CONSIDERATIONS

### Log Sampling (High-Traffic Paths)
```typescript
// Sample 1% of INFO logs in production
if (Math.random() < 0.01 || level >= LogLevel.WARN) {
  logger.log(level, message, context);
}
```

### Async Logging
```typescript
// Non-blocking logging for performance-critical paths
logger.infoAsync('Request processed', { requestId, latency });
```

### Rate Limiting
```typescript
// Limit ERROR logs to 100/minute to prevent spam
const errorLogger = rateLimitedLogger(logger, { 
  level: 'ERROR', 
  limit: 100, 
  window: 60000 
});
```

---

## LOG RETENTION

### Retention Policy
```
TRACE/DEBUG: 1 day
INFO:        7 days
WARN:        30 days
ERROR:       90 days
FATAL:       1 year
```

### Storage Tiers
```
Hot (searchable):  Last 7 days
Warm (archived):   8-30 days
Cold (backup):     31-90 days
```

---

## MONITORING & ALERTING

### Alert Thresholds

#### ERROR Rate
```yaml
Critical: >10 errors/minute (5 min average)
Warning:  >5 errors/minute (5 min average)
```

#### FATAL Events
```yaml
Critical: ANY fatal log (immediate page)
```

#### WARN Rate
```yaml
Warning: >100 warns/minute (10 min average)
```

#### Log Volume
```yaml
Warning: >1000 logs/second (may indicate log spam)
```

---

## IMPLEMENTATION

### TypeScript/JavaScript (Winston)
```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: {
    service: 'payment-service',
    version: process.env.APP_VERSION,
    environment: process.env.NODE_ENV,
    hostname: process.env.HOSTNAME
  },
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ 
      filename: 'logs/error.log', 
      level: 'error' 
    })
  ]
});

// Usage
logger.error('Payment failed', {
  context: { orderId: 'ord_123', amount: 59.99 },
  error: {
    message: err.message,
    type: err.constructor.name,
    stack: err.stack
  },
  requestId: req.id
});
```

### Python (structlog)
```python
import structlog

logger = structlog.get_logger()
structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer()
    ]
)

# Usage
logger.error(
    "payment_failed",
    order_id="ord_123",
    amount=59.99,
    error=str(err),
    error_type=type(err).__name__,
    request_id=request.id
)
```

---

## LOGGING CHECKLIST

```markdown
- [ ] All ERROR logs include error message, type, and stack trace
- [ ] All logs include service name, version, environment
- [ ] Sensitive data (PII, credentials, tokens) is NOT logged
- [ ] Logs use structured JSON format
- [ ] Request/correlation IDs are included for traceability
- [ ] Business context is included (userId, orderId, etc.)
- [ ] Log levels are used correctly (not everything is ERROR)
- [ ] High-frequency logs are sampled or rate-limited
- [ ] Logs are aggregated when appropriate (batch operations)
- [ ] ERROR logs trigger alerts
- [ ] FATAL logs trigger pages
```

---

## ANTI-PATTERNS

### ❌ Logging Without Context
```typescript
logger.error('Failed');  // What failed? Why? How to fix?
```

### ❌ Logging Sensitive Data
```typescript
logger.info('User login', { password: user.password });
```

### ❌ Swallowing Errors
```typescript
try {
  doSomething();
} catch (err) {
  // Silent failure - no log!
}
```

### ❌ Log Spam
```typescript
// Inside a tight loop
for (let i = 0; i < 1000000; i++) {
  logger.debug('Processing item', { index: i });
}
```

### ❌ Using console.log in Production
```typescript
console.log('User data:', user);  // Use proper logger!
```

---

## COMPLIANCE

### GDPR/Privacy Requirements
- Log retention must not exceed data retention policies
- Personal data in logs must be anonymized or pseudonymized
- Users can request deletion of logs containing their data
- Access to logs must be audited

### SOC 2 Requirements
- Logs must be immutable (append-only)
- Log access must be restricted and audited
- Log integrity must be verifiable
- Logs must be retained per retention policy

---

**Related Documents:**
- ERROR_HANDLING_PROTOCOL.md - Error classification & routing
- INCIDENT_RESPONSE_PLAYBOOK.md - Production issue handling
- CODE_QUALITY_STANDARDS.md - Code quality metrics
- PEER_REVIEW_CHECKLIST.md - Code review standards

**Co-Authored-By: Warp <agent@warp.dev>**
