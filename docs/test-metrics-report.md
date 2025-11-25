# Test Metrics Report

Project: Laravel Backend API + Flutter Mobile App  
Version: 1.0  
Prepared by: QA Engineer  
Date: 2025-11-25

## 1. Purpose and Scope
This Test Metrics Report consolidates the quantitative results of the testing activities performed on the Laravel Backend API and Flutter Mobile App as part of the QA Engineer Take-Home Assessment.

It focuses on:

- Test case execution metrics (manual + automated)  
- Defect metrics (counts, severity distribution, density)  
- Automation coverage metrics  
- Observations and risks inferred from the numbers  

This report complements the Test Strategy, Test Plan, Bug Report, and Test Execution Report.

## 2. Metrics Overview (Summary)

### 2.1 Overall Test Case Metrics

| Metric | Value |
|--------|-------|
| Manual test cases planned | 75 |
| Manual test cases executed | 75 |
| Manual test cases passed (initial) | 47 |
| Manual test cases failed (initial) | 28 |
| Automated test cases | 45 |
| Automated tests executed | 45 |
| Automated tests passed (final) | 45 |

Manual failures contributed directly to defects documented in the bug report.  
Automated test suites fully pass after final code fixes.

## 3. Test Case Metrics

### 3.1 Manual Test Case Metrics
Manual testing was applied to:

- Exploratory testing of API & Flutter UI  
- Negative-path validation  
- Edge cases  
- Network & error-state validation  

**Initial Manual Execution Snapshot**

- Passed: 47  
- Failed: 28  

**Pass rate:** 62.7%  
**Fail rate:** 37.3%  

Common fail reasons:

- Missing validation  
- Incorrect status codes  
- Authorization issues  
- Flutter-side parsing failures  

### 3.2 Automated Test Case Metrics

Automated tests executed for:

- Authentication API  
- Products API  
- Orders API  
- End-to-End workflow  
- Flutter widget/UI tests  

**Automated Execution Summary**

| Area | Status | Notes |
|-------|--------|--------|
| Auth API | ✔ Pass | Login, invalid login, tokens |
| Products API | ✔ Pass | Lists, details, unauthorized |
| Orders API | ✔ Pass | Create, list, invalid payload |
| E2E Workflow | ✔ Pass | Login → products → order |
| Flutter Widgets | ✔ Pass | Login screen, input handling |

**Automation Pass Rate:** 100% (45/45)

Earlier failures helped uncover deep issues (Dart parsing, missing validation).

## 4. Defect Metrics

### 4.1 Defect Volume

Total defects logged: **33**  
(from bug_reports_updated_with_flutter.csv)

### 4.2 Defect Severity Distribution

| Severity | Count |
|----------|--------|
| Critical | 10 |
| High | 18 |
| Medium | 4 |
| Low | 1 |

Observations:

- Majority are High/Critical → initial backend validation was weak.
- Critical issues mostly related to validation, authorization, or Flutter crashes.

### 4.3 Defect Density

**Defect Density:**  
33 defects / 75 manual tests ≈ **0.44 defects per test case**

## 5. Automation Coverage Metrics

### 5.1 Coverage by Feature

| Area | Coverage Level | Notes |
|-------|----------------|--------|
| Auth API | High | Fully automated |
| Products API | High | Contract tests validate structure |
| Orders API | High | Includes negative/invalid payload tests |
| End-to-End flow | High | Automates core business path |
| Flutter login | Medium | Basic widget test coverage |
| Flutter screens (others) | Low | Mostly manual |
| User/Admin flows | Low | Manual testing only |

### 5.2 Automation Strategy

Automation prioritizes:

- High-risk backend logic  
- Primary purchase flow  
- Critical API contracts  

Manual testing left for UI edge cases & exploratory coverage.

## 6. Trend & Quality Insights

Insights:

- Early runs had multiple API and parsing failures → now all resolved.
- Automation significantly improved backend stability.
- High severity ratio indicates the system is early-stage and needs stronger validation rules.

## 7. Risks & Recommendations

### 7.1 Risks

- High proportion of Critical & High defects.
- Flutter UX and navigation flows have limited automated coverage.
- Client relies heavily on live API (brittle integration).
- Missing formal API contract (Swagger/OpenAPI).

### 7.2 Recommendations

- Add more Flutter widget tests (product list, orders page).
- Add unit tests for API parsing & controllers.
- Add API contracts (Swagger/OpenAPI).
- Improve severity/priority classification consistency.
- Integrate CI test gating (fail pipeline on test failures).

## 8. Conclusion

The metrics show:

- Thorough manual testing (75 executed).  
- Strong automation on core API + primary user flow (100% passing).  
- Significant defect identification (33 logged), many critical/high severity.  
- Improved system stability following defect fixes.

Current quality is appropriate for **development/staging** environments.  
Further hardening and broader test coverage are recommended for production-readiness.

