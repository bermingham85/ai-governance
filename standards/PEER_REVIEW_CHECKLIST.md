# PEER REVIEW CHECKLIST

**Version:** 1.0  
**Last Updated:** 2026-01-12  
**Owner:** Engineering Team  
**Related:** CODE_QUALITY_STANDARDS.md, TESTING_PROTOCOLS.md, DEFINITION_OF_DONE.md

---

## PURPOSE

Standardize code review process to ensure quality, knowledge sharing, and risk mitigation before merging changes.

---

## REVIEW REQUIREMENTS

### When Review is Required
- **ALWAYS:** All production code changes
- **ALWAYS:** Infrastructure/config changes
- **ALWAYS:** Database migrations
- **ALWAYS:** Security-related changes
- **ALWAYS:** API contract changes

### Who Can Review
- **Standard PRs:** Any team member with domain knowledge
- **Security Changes:** Security-cleared reviewer required
- **Architecture Changes:** Tech lead or architect approval
- **Database Changes:** DBA review for migrations >100 rows

### Review Timing
- **Target Response:** Within 4 business hours
- **Target Completion:** Within 24 hours
- **Urgent/Hotfix:** Within 1 hour (requires explicit flag)

---

## PRE-REVIEW CHECKLIST (Author)

Before requesting review, author must verify:

```markdown
## Pre-Review Verification
- [ ] All tests pass locally
- [ ] Linter shows 0 errors/warnings
- [ ] Type checker passes (if applicable)
- [ ] Self-reviewed code and removed debug statements
- [ ] Added/updated tests for new functionality
- [ ] Updated documentation (README, API docs, etc.)
- [ ] No merge conflicts with target branch
- [ ] PR description explains WHAT and WHY
- [ ] Linked related issues/tickets
- [ ] Added screenshots/videos for UI changes
```

**Auto-Reject Criteria:**
- CI/CD pipeline failures
- Merge conflicts present
- Missing PR description
- >500 lines changed without justification

---

## CORE REVIEW CHECKLIST

### 1️⃣ CODE FUNCTIONALITY
```markdown
- [ ] Code does what the PR description says
- [ ] Edge cases are handled
- [ ] Error conditions are properly managed
- [ ] No obvious bugs or logic errors
- [ ] Code handles null/undefined values safely
```

### 2️⃣ CODE QUALITY
```markdown
- [ ] Follows project coding standards
- [ ] Functions are single-purpose and focused
- [ ] Variable/function names are clear and descriptive
- [ ] No unnecessary complexity
- [ ] No commented-out code (unless explained)
- [ ] No TODO comments without tickets
- [ ] Consistent with existing codebase patterns
```

### 3️⃣ TESTING
```markdown
- [ ] Tests cover new functionality
- [ ] Tests cover edge cases and error paths
- [ ] Tests are clear and maintainable
- [ ] Test coverage meets project threshold (≥80%)
- [ ] No tests are disabled/skipped without explanation
- [ ] Integration tests added if needed
```

### 4️⃣ SECURITY
```markdown
- [ ] No hardcoded secrets/credentials
- [ ] Input validation is present
- [ ] SQL injection risks mitigated (parameterized queries)
- [ ] XSS risks mitigated (output encoding)
- [ ] Authentication/authorization checked
- [ ] Sensitive data is encrypted/protected
- [ ] No new dependencies without security scan
```

### 5️⃣ PERFORMANCE
```markdown
- [ ] No obvious performance bottlenecks
- [ ] Database queries are optimized (indexes used)
- [ ] No N+1 query problems
- [ ] Large datasets are paginated
- [ ] Resource cleanup (connections, files, etc.)
- [ ] Caching used appropriately
```

### 6️⃣ DOCUMENTATION
```markdown
- [ ] Complex logic has explanatory comments
- [ ] API changes are documented
- [ ] README updated if needed
- [ ] Breaking changes are clearly marked
- [ ] Migration guide provided for breaking changes
```

### 7️⃣ MAINTAINABILITY
```markdown
- [ ] Code is easy to understand
- [ ] Dependencies are justified and necessary
- [ ] Configuration is externalized (not hardcoded)
- [ ] Logging is appropriate (level and content)
- [ ] Error messages are helpful for debugging
```

---

## SPECIALIZED REVIEWS

### Database Changes
```markdown
- [ ] Migration is reversible (has down migration)
- [ ] Indexes are added for foreign keys
- [ ] No breaking schema changes without migration plan
- [ ] Data migration tested on staging
- [ ] Estimated migration time documented
- [ ] Backup plan exists for large migrations
```

### API Changes
```markdown
- [ ] Backwards compatible OR version bump justified
- [ ] API documentation updated
- [ ] Request/response examples provided
- [ ] Error codes documented
- [ ] Rate limiting considered
- [ ] Deprecation warnings added for old endpoints
```

### Infrastructure/Config
```markdown
- [ ] Changes tested in staging environment
- [ ] Rollback plan documented
- [ ] Environment variables documented
- [ ] Secrets stored securely (not in code)
- [ ] Resource limits appropriate
- [ ] Monitoring/alerting configured
```

### UI/UX Changes
```markdown
- [ ] Screenshots/videos provided
- [ ] Responsive design tested (mobile/tablet/desktop)
- [ ] Accessibility standards met (WCAG 2.1 AA)
- [ ] Browser compatibility verified
- [ ] Loading states handled
- [ ] Error states handled gracefully
```

---

## REVIEW OUTCOMES

### ✅ APPROVE
Use when:
- All checklist items pass
- Minor issues noted but don't block merge
- Author can address comments in follow-up

**Required:** Leave comment summarizing approval

### 💬 COMMENT (No Approval)
Use when:
- You have questions or suggestions
- Not blocking merge, but want discussion
- FYI information for author

### ❌ REQUEST CHANGES
Use when:
- Critical issues found (bugs, security, performance)
- Code doesn't meet quality standards
- Tests are insufficient
- Changes required before merge

**Required:** Clearly explain what must change and why

---

## REVIEW RESPONSE EXPECTATIONS

### For Reviewers
- Assume positive intent - be constructive, not critical
- Explain the "why" behind requests
- Distinguish between "must fix" and "nice to have"
- Use code suggestions feature for specific fixes
- Approve promptly when issues are resolved
- Don't nitpick style if linter doesn't complain

### For Authors
- Respond to all comments (even if just "done" or "will do in follow-up")
- Don't take feedback personally - it improves the code
- Ask questions if feedback is unclear
- Re-request review after addressing changes
- Thank reviewers for their time

---

## BLOCKING vs NON-BLOCKING ISSUES

### 🚫 BLOCKING (Must Fix Before Merge)
- Security vulnerabilities
- Data loss risks
- Breaking changes without migration
- Crashes/critical bugs
- Test failures
- Missing tests for new code
- Hardcoded secrets
- Performance regressions >20%

### 💡 NON-BLOCKING (Can Address Later)
- Code style improvements (if linter passes)
- Refactoring suggestions
- Documentation improvements
- Additional test cases
- Performance optimizations <20%
- UI polish

**Rule:** Create follow-up ticket for non-blocking items, link in PR comments

---

## LARGE PR GUIDELINES

### When PR Exceeds 500 Lines
- **Preferred:** Break into smaller PRs
- **If Unavoidable:** Provide architectural overview
- **Required:** Add detailed commit-by-commit review guide
- **Required:** Tech lead review
- **Recommended:** Pair programming session

### Review Strategy for Large PRs
1. Review architecture/design first
2. Review tests next (ensure coverage)
3. Review implementation last
4. Take breaks between review sessions
5. Request clarification frequently

---

## AUTOMATED CHECKS (Pre-Review)

These must pass before human review:
```yaml
✓ CI/CD pipeline (build + tests)
✓ Linting (0 errors)
✓ Type checking (if applicable)
✓ Security scanning (SAST)
✓ Test coverage threshold (≥80%)
✓ Dependency vulnerability scan
✓ Code complexity analysis
```

**If automated checks fail:** Fix before requesting review

---

## REVIEW TEMPLATES

### Standard Review Comment
```markdown
## Review Summary
**Overall:** [Approve/Request Changes/Comment]

**Strengths:**
- [What was done well]

**Issues Found:**
- 🚫 BLOCKING: [Critical issue with explanation]
- 💡 NON-BLOCKING: [Suggestion with reasoning]

**Questions:**
- [Clarifying questions]

**Estimated Re-Review Time:** [X hours/minutes]
```

### Approval Comment Template
```markdown
## ✅ APPROVED

**Reviewed Areas:**
- [ ] Functionality
- [ ] Tests
- [ ] Security
- [ ] Performance

**Notes:**
- [Any minor issues to address in follow-up]

Nice work! 🎉
```

---

## METRICS & ACCOUNTABILITY

### Track These Metrics
- Average time to first review
- Average time to approval
- Number of review cycles per PR
- Approval rate by reviewer
- Most common rejection reasons

### Review Quality Indicators
- **Good:** <2 review cycles average
- **Warning:** >3 review cycles common (unclear requirements?)
- **Good:** <10% of PRs need post-merge fixes
- **Warning:** >20% need post-merge fixes (review quality issue?)

---

## ESCALATION

### When to Escalate
- Review stalled >48 hours
- Disagreement on technical approach
- Security concern dispute
- Unclear requirements

### Who to Escalate To
- **Technical disputes:** Tech Lead
- **Security concerns:** Security Team
- **Timeline pressure:** Engineering Manager
- **Cross-team coordination:** Product Manager

---

## ENFORCEMENT

### For Authors
- PRs without passing CI/CD are auto-closed after 48h
- PRs without description are auto-rejected
- PRs addressing review comments must re-request review

### For Reviewers
- Reviews not started within 8h are auto-assigned to backup reviewer
- Approvals without comments flagged for quality review
- Rubber-stamping patterns trigger reviewer training

---

## QUICK REFERENCE

```
┌─────────────────────────────────────────────────┐
│ REVIEW DECISION TREE                            │
├─────────────────────────────────────────────────┤
│ Security issue? ──────────────→ REQUEST CHANGES │
│ Tests missing? ───────────────→ REQUEST CHANGES │
│ Breaking change undocumented? → REQUEST CHANGES │
│ Logic bug? ───────────────────→ REQUEST CHANGES │
│                                                 │
│ Minor style issue? ───────────→ COMMENT         │
│ Refactoring suggestion? ──────→ COMMENT         │
│                                                 │
│ Everything good? ─────────────→ APPROVE         │
└─────────────────────────────────────────────────┘
```

---

**Related Documents:**
- CODE_QUALITY_STANDARDS.md - Coding standards
- TESTING_PROTOCOLS.md - Testing requirements
- DEFINITION_OF_DONE.md - Completion criteria
- ERROR_LOGGING_STANDARD.md - Logging standards
- INCIDENT_RESPONSE_PLAYBOOK.md - Production issues

**Co-Authored-By: Warp <agent@warp.dev>**
