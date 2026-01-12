# DEFINITION OF DONE (DoD)
**Clear Criteria for Task Completion**

**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Owner:** Development Team  
**Review Schedule:** Quarterly

---

## 🎯 PURPOSE

This document defines when a task, feature, or project is considered **truly complete** and ready for production or delivery.

**Key Principle:** "Done" means production-ready, not just "code works on my machine."

---

## ✅ UNIVERSAL DEFINITION OF DONE

**ALL tasks must meet these criteria before being marked complete:**

### 1. Code Complete
- [ ] **Feature implemented** as per acceptance criteria
- [ ] **All functions work** as specified
- [ ] **Edge cases handled** (nulls, empty values, errors)
- [ ] **No commented-out code** (remove or document why kept)
- [ ] **No debug statements** (console.log, print, etc.) in production code
- [ ] **Code follows style guide** (linting passes)

### 2. Tested
- [ ] **Unit tests written** (cover core functionality)
- [ ] **Unit tests pass** (100% of new tests green)
- [ ] **Integration tests pass** (if applicable)
- [ ] **Manual testing completed** (happy path + edge cases)
- [ ] **No regressions** (existing tests still pass)
- [ ] **Test coverage maintained** (no decrease from baseline)

### 3. Reviewed
- [ ] **Code review completed** by at least 1 other developer
- [ ] **All review comments addressed** or discussed
- [ ] **Approval received** from reviewer(s)
- [ ] **Security concerns resolved** (if any raised)
- [ ] **Performance concerns resolved** (if any raised)

### 4. Documented
- [ ] **README updated** (if functionality affects usage)
- [ ] **API docs updated** (if public API changed)
- [ ] **Inline comments added** (for complex logic)
- [ ] **CHANGELOG updated** (user-facing changes)
- [ ] **ADR created** (for architectural decisions)

### 5. Quality Gates Passed
- [ ] **Linting passes** (no errors, minimal warnings)
- [ ] **Type checking passes** (TypeScript strict mode, mypy, etc.)
- [ ] **Security scan passes** (no high/critical vulnerabilities)
- [ ] **Build succeeds** (no compilation errors)
- [ ] **CI pipeline green** (all automated checks pass)

### 6. Deployed
- [ ] **Merged to main/master** branch
- [ ] **Deployed to staging** (if applicable)
- [ ] **Smoke tested in staging** (basic functionality verified)
- [ ] **Deployed to production** (or ready for deployment)
- [ ] **Deployment documented** (in deployment log/ADR)

### 7. Verified
- [ ] **Acceptance criteria met** (per original requirements)
- [ ] **Stakeholder approval** (if required)
- [ ] **No known critical bugs** (P0/P1 issues resolved)
- [ ] **Rollback plan exists** (if high-risk change)
- [ ] **Monitoring/alerts configured** (if affects production)

---

## 📋 TASK-SPECIFIC CRITERIA

### For New Features

In addition to universal DoD:

- [ ] **Feature flag implemented** (if gradual rollout needed)
- [ ] **Analytics/tracking added** (to measure usage)
- [ ] **Performance benchmarked** (meets SLA/targets)
- [ ] **Load tested** (if high-traffic feature)
- [ ] **A/B test configured** (if experimental)
- [ ] **User documentation created** (help docs, tooltips)
- [ ] **Training materials updated** (if affects users)

### For Bug Fixes

In addition to universal DoD:

- [ ] **Root cause identified** (documented in commit/ADR)
- [ ] **Regression test added** (to prevent recurrence)
- [ ] **Related bugs checked** (similar issues addressed)
- [ ] **Hotfix documented** (if production hotfix)
- [ ] **Postmortem created** (if critical bug)

### For Refactoring

In addition to universal DoD:

- [ ] **Functionality unchanged** (no behavior changes)
- [ ] **Performance measured** (before/after comparison)
- [ ] **No new bugs introduced** (regression tests pass)
- [ ] **Tech debt reduced** (measurable improvement)
- [ ] **Team informed** (if affects other developers)

### For New Repositories

In addition to universal DoD:

- [ ] **PROJECT_DECISION_MATRIX completed** (8-step process)
- [ ] **ADR created** (documenting decision)
- [ ] **PROJECT_REGISTRY updated** (added to registry)
- [ ] **README from template** (complete documentation)
- [ ] **LICENSE file** (MIT or appropriate)
- [ ] **.gitignore configured** (language-appropriate)
- [ ] **CI/CD pipeline** (GitHub Actions or equivalent)
- [ ] **Branch protection** (require PR, tests pass)
- [ ] **WARP.md created** (project-specific rules)
- [ ] **Dependencies documented** (package.json, requirements.txt)

### For Documentation

- [ ] **Technically accurate** (peer-reviewed)
- [ ] **Clear and concise** (no ambiguity)
- [ ] **Examples provided** (code samples, use cases)
- [ ] **Up-to-date** (reflects current implementation)
- [ ] **Accessible location** (in repo or wiki)
- [ ] **Linked from README** (discoverable)

### For Configuration Changes

- [ ] **Tested in non-prod** (staging/dev environment)
- [ ] **Rollback tested** (can revert safely)
- [ ] **Team notified** (if affects multiple services)
- [ ] **Monitoring confirmed** (alerts still work)
- [ ] **Documentation updated** (runbooks, config docs)

---

## 🚫 ANTI-PATTERNS (NOT DONE)

### ❌ "Works on My Machine"
**Problem:** Code runs locally but fails elsewhere  
**Solution:** Test in staging, CI must pass

### ❌ "I'll Document It Later"
**Problem:** Documentation never gets written  
**Solution:** Documentation is part of DoD, not optional

### ❌ "Just One More Quick Fix"
**Problem:** Scope creep, never truly done  
**Solution:** New fixes = new tasks with their own DoD

### ❌ "Tests Can Wait"
**Problem:** Technical debt accumulates  
**Solution:** Tests are mandatory, not optional

### ❌ "I'll Get Reviews Later"
**Problem:** Poor quality merged to main  
**Solution:** Code review is blocking, not advisory

### ❌ "It's 90% Done"
**Problem:** Last 10% takes as long as first 90%  
**Solution:** Binary state - Done or Not Done

---

## 🎭 ROLE-SPECIFIC RESPONSIBILITIES

### Developer
- Write code that meets DoD
- Write tests
- Request code review
- Address review comments
- Update documentation
- Deploy (if applicable)

### Reviewer
- Check code quality
- Verify tests exist and pass
- Ensure documentation updated
- Approve or request changes
- Unblock deployment

### Product Owner
- Define acceptance criteria
- Verify acceptance criteria met
- Approve stakeholder requirements
- Sign off on completion

### QA/Tester
- Execute test plan
- Verify edge cases
- Confirm no regressions
- Report issues found

---

## 📊 CHECKLIST BY PROJECT TYPE

### Quick Reference

**Backend API:**
```
✓ Code + tests + review
✓ API docs updated (OpenAPI/Swagger)
✓ Integration tests pass
✓ Security scan passes
✓ Deployed to staging
✓ Smoke tested
✓ Performance benchmarked
```

**Frontend Feature:**
```
✓ Code + tests + review
✓ Visual regression tests
✓ Accessibility tested (WCAG)
✓ Mobile responsive
✓ Browser compatibility
✓ Analytics tracking added
✓ Deployed to staging
```

**CLI Tool:**
```
✓ Code + tests + review
✓ Help text complete
✓ Error messages clear
✓ Edge cases handled
✓ Install instructions
✓ Published to package manager
```

**Database Migration:**
```
✓ Migration script tested
✓ Rollback script tested
✓ Data integrity verified
✓ Performance measured
✓ Backup confirmed
✓ Runbook updated
✓ Team notified
```

**Infrastructure Change:**
```
✓ Terraform/IaC applied
✓ Tested in non-prod
✓ Rollback plan documented
✓ Monitoring configured
✓ Alerts verified
✓ Runbook updated
✓ Team trained
```

---

## 🔄 CONTINUOUS IMPROVEMENT

### When to Update DoD

- **After retrospective** - Team identifies missing criteria
- **After incident** - Postmortem reveals gap
- **New technology** - Different stack requires different checks
- **Team growth** - Onboarding reveals unclear expectations
- **Regulatory changes** - Compliance requires new criteria

### Feedback Loop

Document in retrospectives:
- Which DoD items are most often forgotten?
- Which items catch the most bugs?
- Which items are redundant?
- What new items should be added?

Update this document accordingly.

---

## 📏 MEASURING COMPLIANCE

### Metrics to Track

| Metric | Target | How to Measure |
|--------|--------|----------------|
| **Tasks marked done meeting DoD** | 100% | Spot check in code reviews |
| **Tests passing on merge** | 100% | CI metrics |
| **Code review approval rate** | 100% | GitHub/GitLab insights |
| **Documentation completeness** | 95%+ | Documentation audit |
| **Production bugs from "done" tasks** | <2% | Bug tracker analysis |
| **Rollbacks due to incomplete DoD** | <1% | Deployment logs |

### Audit Process

**Weekly:** Random sample of 3 completed tasks - verify DoD met  
**Monthly:** Review metrics, identify trends  
**Quarterly:** Update DoD based on learnings

---

## 🚨 ESCALATION

### When DoD Can Be Skipped

**ONLY in these circumstances:**

1. **Critical hotfix** (P0 production outage)
   - Skip: Documentation, some tests
   - Still Required: Code review, basic testing, rollback plan
   - Follow-up: Create tech debt ticket for skipped items

2. **Prototype/POC** (explicitly marked as such)
   - Skip: Full test coverage, production deployment
   - Still Required: Code review, basic documentation
   - Follow-up: Delete or productionize within 30 days

3. **Security emergency** (active exploit)
   - Skip: Normal review timeline, some documentation
   - Still Required: Security review, deployment verification
   - Follow-up: Postmortem, full DoD completion

**Process:**
1. Document reason for DoD skip
2. Get approval from tech lead
3. Create follow-up ticket
4. Complete skipped items within 1 sprint

---

## 🎓 TRAINING

### For New Team Members

1. Read this document
2. Shadow code review (see DoD in action)
3. Submit first PR with DoD checklist
4. Receive mentorship on missing items
5. Iterate until consistent

### For Reviewers

1. Use DoD as review checklist
2. Block merge if DoD not met
3. Provide specific feedback referencing DoD
4. Escalate repeated violations

---

## 🔗 RELATED DOCUMENTS

- **CODE_QUALITY_STANDARDS.md** - What "good code" means
- **TESTING_PROTOCOLS.md** - Test requirements details
- **PEER_REVIEW_CHECKLIST.md** - Review process
- **PROJECT_DECISION_MATRIX.md** - New repo requirements
- **GLOBAL_AI_RULES.md** - AI-specific completion criteria

---

## 📝 EXAMPLES

### Example 1: Simple Bug Fix

**Task:** Fix null pointer exception in user profile endpoint

**DoD Checklist:**
- [x] Bug fixed (null check added)
- [x] Regression test added
- [x] Unit tests pass
- [x] Code reviewed by Sarah
- [x] Deployed to staging
- [x] Tested in staging (verified fix)
- [x] Deployed to production
- [x] Monitoring shows no errors
- [x] Root cause documented in commit
- [ ] ~~README update~~ (not needed)
- [ ] ~~CHANGELOG~~ (internal fix, not user-facing)

**Status:** ✅ DONE

### Example 2: New API Endpoint

**Task:** Add GET /api/v1/users/{id}/preferences endpoint

**DoD Checklist:**
- [x] Endpoint implemented
- [x] Request validation added
- [x] Response schema defined
- [x] Unit tests (80% coverage)
- [x] Integration tests
- [x] OpenAPI spec updated
- [x] Code reviewed by Tom
- [x] Security scan passes
- [x] Deployed to staging
- [x] Manual testing (Postman)
- [x] Performance tested (<100ms)
- [x] Deployed to production
- [x] Analytics tracking added
- [x] API docs updated
- [x] Example added to README

**Status:** ✅ DONE

### Example 3: New Repository

**Task:** Create new payment-processing-service repo

**DoD Checklist:**
- [x] PROJECT_DECISION_MATRIX completed (ADR-015)
- [x] Searched PROJECT_REGISTRY (no duplicate)
- [x] Repo created on GitHub
- [x] README from template
- [x] LICENSE (MIT)
- [x] .gitignore (Node.js)
- [x] package.json configured
- [x] CI/CD pipeline (GitHub Actions)
- [x] Branch protection enabled
- [x] WARP.md created
- [x] Initial commit pushed
- [x] PROJECT_REGISTRY updated
- [x] Team notified in Slack

**Status:** ✅ DONE

---

## 🎯 KEY TAKEAWAYS

1. **"Done" is binary** - Either meets DoD or it doesn't
2. **Documentation is not optional** - Part of done, not extra
3. **Tests are mandatory** - No exceptions
4. **Review is required** - No self-merge
5. **Production-ready means production-ready** - Not "almost ready"
6. **DoD applies to everyone** - No shortcuts for seniors
7. **Skip only in emergencies** - With documentation and follow-up

---

## ✅ USING THIS DOCUMENT

### Before Starting Work
1. Read acceptance criteria
2. Review DoD for task type
3. Estimate time including DoD items

### During Work
1. Check off items as completed
2. Don't mark task done until all checked
3. Ask for help if stuck on DoD item

### After Completion
1. Verify all DoD items met
2. Move task to "Done" column
3. Celebrate! 🎉

---

**Remember:** DoD protects the team from technical debt and production issues. It's not bureaucracy - it's quality assurance.

---

**Document Owner:** Development Team  
**Version:** 1.0.0  
**Last Updated:** 2026-01-12  
**Next Review:** 2026-04-12  

**Co-Authored-By: Warp <agent@warp.dev>**
