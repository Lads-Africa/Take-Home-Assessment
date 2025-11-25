# Test Data Management Strategy

**Project:** Laravel Backend API + Flutter Mobile App  
**Prepared by:** QA Engineer  
**Date:** 2025-11-25

---

## 1. Introduction

This Test Data Management Strategy defines how test data is **created, stored, refreshed, secured, and used** across all testing activities for this assessment.

The goal is to ensure **consistent, reliable, secure, and repeatable** test execution for both the **Laravel API** and **Flutter application**.

This strategy covers:

- Test data design  
- Test data sources  
- Test data lifecycle  
- Data refresh and reset mechanisms  
- Sensitive data considerations  
- Automation compatibility  

---

## 2. Test Data Principles

All test data follows these core principles:

- **Deterministic** — each test must produce the same result on every run.  
- **Isolated** — test data does not interfere across tests.  
- **Resettable** — database resets guarantee a clean testing slate.  
- **Secure** — no real customer data is ever used.  
- **Traceable** — every test case maps to specific test data sets.  
- **Minimal** — use the smallest required dataset for clarity.  

---

## 3. Test Data Categories

### A. Authentication Data

| Role  | Email            | Password |
|-------|------------------|----------|
| Admin | admin@test.com   | password |
| User  | user@test.com    | password |

Used for:

- Authorization testing  
- Permission checks  
- Token lifecycle testing  

---

### B. Products Data

Generated using **Laravel factories**.

Includes valid and invalid combinations:

- Price ranges (valid + negative + non-numeric)  
- Stock values  
- Categories  

Used for:

- Product listing  
- Product creation  
- Validation testing  

---

### C. Orders Data

Orders are created linking:

- Seeded users  
- Seeded products  

Used for:

- Order creation  
- Data integrity validation  
- Negative payload testing  

---

### D. Negative Test Data

Includes intentionally invalid or malformed values:

- Malformed JSON  
- Missing required fields  
- Invalid emails  
- Negative numbers  
- Unauthorized role attempts  

Used for negative and abuse-case testing.

---

## 4. Test Data Creation Methods

### A. Laravel Factories & Seeders

Factories generate reliable entities for:

- Users  
- Products  
- Orders  

Seeders create base accounts needed for running the entire test suite.

---

### B. Inline Test Data (API Tests)

Feature tests use inline arrays for:

- Payloads  
- Invalid combinations  
- Authorization checks  

This guarantees deterministic behavior in CI/CD.

---

### C. Postman Test Data

Postman Environment Variables store:

- `token`  
- `base_url`  
- `test_user_id`  

Used for automated API collection runs.

---

### D. Flutter Test Data

Flutter tests use:

- `MockClient` responses  
- Hard‑coded credentials  
- Stubbed product and order lists  

Ensures controlled output in widget & integration tests.

---

## 5. Test Data Reset / Refresh Mechanisms

### A. Laravel

Each test run triggers:

- `RefreshDatabase`  
- Full migration reset  
- Reseeding of base user data  

Guarantees a clean state and removes cross-test contamination.

---

### B. Flutter

Each test run uses:

- A fresh app instance  
- Mocked HTTP client  
- No shared persistent storage  

Ensures every test is isolated.

---

### C. Postman

Each collection run:

- Fetches a fresh token  
- Resets environment variables  
- Ensures stateless execution  

---

## 6. Sensitive Test Data Handling

- No production or real customer data is ever used.  
- All emails, IDs, and names are **dummy values only**.  
- Test credentials cannot authenticate on any real environment.  
- Tokens used in tests are valid only for the temporary test environment.  

---

## 7. Risks and Mitigation

### **Risk 1: Tests Depend Too Much on Seed Data**  
**Mitigation:** Use factories inside each test where possible instead of relying only on seeders.

### **Risk 2: Flutter App Stores Token Insecurely in Real Usage**  
**Mitigation:** In tests, use `MockClient`; no tokens are stored persistently.

### **Risk 3: Data Conflicts Between Tests**  
**Mitigation:** Enforce `RefreshDatabase` on all test classes to reset state.  

---

## 8. Conclusion

The Test Data Management Strategy ensures:

- Predictable and repeatable test results  
- Clean database resets  
- Isolated test environments  
- Secure handling of all test credentials and payloads  

This approach fully supports **manual**, **automated**, **API**, **performance**, and **end‑to‑end** testing for the assessment.

