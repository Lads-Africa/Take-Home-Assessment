# QA Assessment Submission Template

**Candidate Name**: Maxine R. Mutasa

**Email**: maxinemutasa00@gmail.com

**Phone**: +263783062941

**Submission Date**: 25/11.2025

**GitHub/GitLab Repository URL**: https://github.com/maxxine29/Take-Home-Assessment.git



---

## Submission Checklist

Check off each item as you complete it:

### Required Deliverables

- [ ✓] Test Strategy Document (`test-strategy.md` or `.pdf`)
- [✓ ] Test Plan with 50+ test cases (`test-plan.xlsx` or `.md`)
- [ ✓] Bug Reports - 30+ bugs (`bug-reports.xlsx` or bug tracking export)
- [ ✓] Laravel Automated Tests (80%+ coverage)
- [ ✓] Flutter Automated Tests (80%+ coverage)
- [ ✓] Postman Collection (`api-tests.postman_collection.json`)
- [✓ ] Postman Environment (`api-tests.postman_environment.json`)
- [✓ ] Automated API Tests
- [ ✓] Performance Test Report (`performance-test-report.md`)
- [ ✓] Test Execution Report (`test-execution-report.md`)
- [ ✓] Bug Tracking Dashboard (`bug-dashboard.xlsx`)
- [ ✓] Test Metrics Report (`test-metrics-report.md`)
- [ ✓] Test Summary Report (`test-summary-report.md`)
- [ ✓] CI/CD Configuration (`.github/workflows/tests.yml` or `.gitlab-ci.yml`)

### Bonus Deliverables (Optional)

- [ ✓] Security Test Report (`security-test-report.md`)
- [ ] Accessibility Test Report (`accessibility-test-report.md`)
- [ ] Cross-Platform Test Report (`cross-platform-test-report.md`)
- [ ✓] Test Data Management Strategy (`test-data-strategy.md`)

---

## Deliverables Summary

### Documentation Files

| Document | File Path | Status |
|----------|-----------|--------|
| Test Strategy | `docs/test-strategy.md` | [✓ ] Complete |
| Test Plan | `docs/test-plan.xlsx` | [ ✓] Complete |
| Bug Reports | `docs/bug-reports.xlsx` | [ ✓] Complete |
| Performance Report | `docs/performance-test-report.md` | [ ✓] Complete |
| Test Execution Report | `docs/test-execution-report.md` | [ ✓] Complete |
| Bug Dashboard | `docs/bug-dashboard.xlsx` | [ ✓] Complete |
| Test Metrics | `docs/test-metrics-report.md` | [ ✓] Complete |
| Test Summary | `docs/test-summary-report.md` | [✓ ] Complete |

### Test Code

| Component | Location | Coverage | Status |
|-----------|----------|----------|--------|
| Laravel Unit Tests | `laravel-project/tests/Unit/` | __80_% | [ ✓] Complete |
| Laravel Integration Tests | `laravel-project/tests/Integration/` | 80___% | [✓ ] Complete |
| Laravel Feature Tests | `laravel-project/tests/Feature/` | __80_% | [✓ ] Complete |
| Laravel API Tests | `laravel-project/tests/Feature/Api/` | _90__% | [ ✓] Complete |
| Flutter Widget Tests | `flutter-project/test/widget/` | __80_% | [ ✓] Complete |
| Flutter Integration Tests | `flutter-project/test/integration/` | _80__% | [ ✓] Complete |
| Flutter Unit Tests | `flutter-project/test/unit/` | __80_% | [ ✓] Complete |

### API Testing

| Component | File Path | Status |
|-----------|-----------|--------|
| Postman Collection | `api-tests.postman_collection.json` | [ ✓] Complete |
| Postman Environment | `api-tests.postman_environment.json` | [ ✓] Complete |

### CI/CD

| Component | File Path | Status |
|-----------|-----------|--------|
| GitHub Actions | `.github/workflows/tests.yml` | [ ✓] Complete |
| OR GitLab CI | `.gitlab-ci.yml` | [ ] Complete |

---

## Statistics

### Test Coverage

- **Laravel Backend Coverage**: _80__%
- **Flutter App Coverage**: __80_%
- **Overall Coverage**: _75+__%

### Bug Statistics

- **Total Bugs Found**: _33__
- **Critical Bugs**: __9_
- **High Severity**: __17_
- **Medium Severity**: __4_
- **Low Severity**: _1__
- **Bugs Fixed**: ___ (if applicable)

### Test Execution

- **Total Test Cases**: _75_+_
- **Test Cases Executed**: __75+_
- **Passed**: __92_
- **Failed**: _28__
- **Blocked**: ___
- **Skipped**: ___

---

## Time Spent

Provide an estimate of time spent on each major activity:

| Activity                     | Hours |
|-----------------------------|-------|
| Test Strategy & Planning    | 4     |
| Manual Testing              | 6     |
| Bug Reporting               | 3     |
| Laravel Automation          | 4     |
| Flutter Automation          | 4     |
| Performance Testing         | 1     |
| Documentation               | 5     |
| CI/CD Setup                 | 1     |
| Bonus Tasks                 | 2     |
| **Total Time Spent**        | **30 hrs** |

---

## Challenges Faced

Describe any challenges you encountered during the assessment:

### Challenge: API inconsistencies causing Flutter failures  
**Solution:** Implemented strict API integration tests to stabilize API–client contract.

### Challenge: Order endpoint lacked validation causing 500 errors  
**Solution:** Added payload validation and full test coverage.

### Challenge: CI pipeline errors  
**Solution:** Simplified workflow and separated Laravel + Flutter jobs.

---

## ASSUMPTIONS

- Token-based authentication is sufficient for assessment scope.  
- Only Android Flutter testing required.  
- No production load expected for performance tests.  

---
---

## Key Findings

### Most Critical Bugs Found

1. Bug ID: API-ORD-CRIT-001

Title: Order creation fails with 500 error due to missing validation

Severity: Critical

Impact: Invalid payloads could break the entire checkout flow, causing app crashes and allowing malformed data into the system; severely disrupts transaction flows.

2. Bug ID: API-PROD-HIGH-004

Title: Normal user can create and update products (authorization bypass)

Severity: High

Impact: Major security vulnerability—non-admin users can modify global catalogue data, potentially corrupting product listings and enabling unauthorized system changes.

3. Bug ID: FLUTTER-AUTH-CRIT-003

Title: Flutter client fails to parse API responses due to inconsistent JSON structure

Severity: Critical

Impact: Mobile app becomes unusable—product pages fail to render and order screens crash; blocks end-to-end user flow entirely.

### Testing Highlights

- [Key highlight 1]
- [Key highlight 2]
- [Key highlight 3]

---

## Recommendations

### Immediate Actions


- Strengthen validation using Laravel **FormRequest**.  
- Add **OpenAPI/Swagger** specs to reduce contract drift.  
- Expand Flutter widget and integration tests.  
- Improve global exception mapping and error handling consistency.  

---

### Long-term Improvements

1. Establish a fully automated contract-testing layer (e.g., OpenAPI-driven schema validation) to prevent future API–Flutter integration failures and ensure long-term interface stability.

2. Expand automated test coverage to include broader negative-path scenarios, offline behaviors, network timeouts, role-based restrictions, and more complex user journeys.

3. Introduce observability tooling (API monitoring dashboards, error-rate tracking, automated performance baselines) to maintain quality as the system grows and traffic increases.

---

## Additional Notes

[Any additional information you'd like to share]

---

## How to Run the Tests

### Laravel Tests

```bash
cd laravel-project
composer install
cp .env.example .env
php artisan key:generate
# Configure database in .env
php artisan migrate --seed
php artisan test --coverage
```

### Flutter Tests

```bash
cd flutter-project
flutter pub get
flutter test --coverage
```

### API Tests (Postman)

1. Import `api-tests.postman_collection.json` into Postman
2. Import `api-tests.postman_environment.json` into Postman
3. Select the environment
4. Run the collection

### CI/CD

The tests will run automatically on push to the repository. Check the Actions/CI tab for results.

---

## Contact Information

If you have any questions about this submission, please contact:

**Email**: [cto@ladsafrica.co.zw]
**Phone**: [0774866456]
**Preferred Contact Time**: [08:00 -  17:00]

---

**Thank you for your time and effort!**

