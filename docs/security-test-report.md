# Security Test Report

**Project:** Laravel Backend API + Flutter Mobile App  
**Version:** 1.0  
**Prepared by:** QA Engineer  
**Date:** 2025-11-25  

---

## 1. Introduction

This Security Test Report summarizes the results of security-focused testing performed on the **Laravel Backend API** and the **Flutter Mobile App**.  
Testing was conducted using **OWASP Top 10** guidelines, API security testing practices, and mobile application security fundamentals.

The objective of this assessment was to identify:

- Authentication and authorization weaknesses  
- Input validation issues  
- Exposure of sensitive data  
- Error-handling vulnerabilities  
- API endpoint access misconfigurations  
- Client-side weaknesses in Flutter  

Security testing focused on API behavior, session handling, data confidentiality, and misuse scenarios.

---

## 2. Security Test Scope

### 2.1 In Scope

- Laravel API endpoints  
- Authentication flow (login, token lifecycle)  
- Authorization restrictions (admin vs user)  
- Input validation and sanitization  
- Error message handling  
- Sensitive data exposure checks  
- Token storage on Flutter  
- Network-level behavior (HTTP/HTTPS assumption)  

### 2.2 Out of Scope

- Full penetration testing  
- SSL/TLS certificate validation  
- Infrastructure/Server hardening  
- Database injection fuzzing at scale  
- iOS platform-specific security testing  

---

## 3. Security Testing Approach

The following methods were used:

- Manual checks based on OWASP Top 10  
- API misuse and abuse testing  
- Authentication and authorization bypass attempts  
- Input validation attacks (SQL injection payloads, XSS-style payloads, malformed JSON)  
- Token tampering and replay attempts  
- Testing sensitive data exposure in API responses  
- Flutter local storage inspection (e.g. SharedPreferences)  
- Error message and stack trace inspection  
- Negative testing with invalid and expired tokens  

### 3.1 Tools Used

- Postman  
- Burp Suite Community Edition (manual interception)  
- cURL  
- Flutter test utilities  
- MySQL logs  

---

## 4. Security Findings Summary

### 4.1 Severity Classification

| Severity  | Count |
|----------|-------|
| Critical | 3     |
| High     | 7     |
| Medium   | 4     |
| Low      | 2     |
| **Total**| **16**|

---

## 5. Detailed Security Findings

### 5.1 Critical Issues (3)

#### 5.1.1 Missing Server-Side Validation – Leads to 500 Errors

- **Description:** APIs such as `POST /api/orders` and `POST /api/products` accept malformed payloads, leading to unhandled exceptions and HTTP 500 errors.  
- **Impact:** Attackers can crash the API, perform denial of service, or probe internal database structure based on error patterns.  
- **Recommendation:** Use Laravel **FormRequest** validation (or equivalent) for all endpoints and ensure invalid payloads return standardized 4xx responses with safe error messages.

---

#### 5.1.2 Authorization Bypass – Normal User Accessing Admin Endpoints

- **Description:** Endpoints such as `GET /api/users` may allow access to data intended only for admins, depending on route/middleware configuration.  
- **Impact:** Potential data leakage of all registered users and sensitive profile information.  
- **Recommendation:** Enforce **admin-only middleware** on all administrative routes, and add tests that verify normal users receive `403 Forbidden` or `401 Unauthorized` where appropriate.

---

#### 5.1.3 API Returning Stack Traces / Internal Errors

- **Description:** Unhandled exceptions return raw SQL or framework error traces in responses.  
- **Impact:** Exposes internal database structure, table names, and sometimes file paths—this is a major OWASP violation.  
- **Recommendation:** Implement a **global exception handler** (e.g. using Laravel’s `Handler`) to return clean, generic JSON error responses and log detailed stack traces only on the server side.

---

### 5.2 High Issues (7)

#### 5.2.1 Weak Validation on Product Price

- **Description:** Non-numeric or malformed values can bypass validation logic for the product price field.  
- **Impact:** Data integrity risk and potential for injection or unexpected behavior if values are used in calculations or queries.  
- **Recommendation:** Enforce strict numeric validation and business rules (e.g. `numeric`, `min:0`) at the API level and add tests for invalid values.

---

#### 5.2.2 Missing Authorization Checks on Product Update

- **Description:** Normal users can attempt to modify product details via `PUT`/`PATCH` endpoints.  
- **Impact:** Elevation of privilege, allowing unauthorized edits of catalog data.  
- **Recommendation:** Apply role-based authorization checks on update/delete endpoints and verify via automated tests that only admins can update products.

---

#### 5.2.3 No Rate Limiting on `/api/login`

- **Description:** The login endpoint allows an unlimited number of attempts.  
- **Impact:** High risk of **credential stuffing** and brute-force password attacks.  
- **Recommendation:** Enable Laravel **Throttle** middleware (e.g. `throttle:5,1`) on login and other sensitive endpoints, and monitor for repeated failures.

---

#### 5.2.4 Tokens Not Invalidated After Logout

- **Description:** Logout operations do not reliably invalidate existing tokens (e.g. JWT or session tokens).  
- **Impact:** A stolen token can continue to be reused even after the user logs out, leading to **session hijacking**.  
- **Recommendation:** Implement backend-side token invalidation (e.g. token blacklist/rotation) and ensure logout flows are covered by automated tests.

---

#### 5.2.5 Overly Permissive CORS Configuration

- **Description:** If CORS is configured with `*` or overly broad origins, any website can issue requests to the API.  
- **Impact:** Increases risk of cross-domain exploitation, especially if combined with weak authentication/authorization.  
- **Recommendation:** Restrict allowed origins to trusted domains and avoid wildcards for credentials-bearing requests.

---

#### 5.2.6 Flutter Stores Token in Plain Text (SharedPreferences)

- **Description:** The Flutter app stores authentication tokens in plain text (e.g. `SharedPreferences`).  
- **Impact:** If the device is rooted or compromised, tokens can be easily extracted and reused.  
- **Recommendation:** Use **encrypted storage**, such as `flutter_secure_storage` or platform-specific secure keychains/keystores.

---

#### 5.2.7 Inconsistent Error Messages

- **Description:** Error messages vary significantly across endpoints and sometimes reveal too much detail.  
- **Impact:** Attackers can fingerprint internal logic and distinguish between valid/invalid resources, usernames, or IDs.  
- **Recommendation:** Standardize error response structure and content; use generic wording for authentication and authorization failures.

---

### 5.3 Medium Issues (4)

#### 5.3.1 Missing Input Sanitization on Text Fields

- **Description:** Some free-text fields do not sanitize or normalize input.  
- **Impact:** Potential for XSS or injection issues if data is later rendered in a web context.  
- **Recommendation:** Sanitize or encode text fields and validate length and character sets.

---

#### 5.3.2 Non-standard JSON Error Format

- **Description:** Error responses are not consistently formatted (e.g. different keys, status fields).  
- **Impact:** Makes it harder to handle errors securely and may lead to inconsistent client-side logic.  
- **Recommendation:** Define and enforce a common JSON error schema (e.g. `{ "success": false, "message": "...", "code": "..." }`).

---

#### 5.3.3 No Password Strength Enforcement

- **Description:** Weak passwords may be accepted during registration.  
- **Impact:** Higher chance of account compromise via guessing or password reuse.  
- **Recommendation:** Enforce minimum length and complexity rules and document them in the API contract.

---

#### 5.3.4 Missing Audit Logs for Admin Actions

- **Description:** Sensitive admin actions (e.g. managing users or products) are not auditable.  
- **Impact:** Difficult to trace malicious or accidental misuse by privileged accounts.  
- **Recommendation:** Implement audit logging for critical operations, including who made the change and when.

---

### 5.4 Low Issues (2)

#### 5.4.1 Minor UI Feedback Inconsistencies

- **Description:** Some security-related actions do not provide consistent visual feedback.  
- **Impact:** Limited security impact but can confuse users about the success/failure of sensitive actions.  
- **Recommendation:** Standardize UI messages and states for login, logout, and error flows.

---

#### 5.4.2 Flutter Error Dialogs Reveal Too Much Detail

- **Description:** Certain dialogs expose internal messages or technical details.  
- **Impact:** May give attackers clues about backend behavior or error states.  
- **Recommendation:** Show user-friendly messages and log technical details privately.

---

## 6. Risk Analysis

### 6.1 High-Risk Areas

The following domains represent the biggest threat to data confidentiality and API integrity:

- **Authorization:** Inconsistent enforcement on admin endpoints.  
- **Validation:** Missing or weak validation leading to 500 errors and potential data integrity issues.  
- **Error Handling:** Exposure of stack traces and internal details.  
- **Token Persistence:** Tokens not properly invalidated and stored insecurely on the client.

---

## 7. Recommendations

### 7.1 Backend Recommendations

- Enforce strict **FormRequest validation** on all write endpoints.  
- Implement a global **exception handler** for uniform JSON error output.  
- Apply **role-based middleware** for all admin-only routes.  
- Add **rate limiting** to login and other sensitive endpoints.  
- Obscure error messages and remove stack traces from client responses.  
- Validate and sanitize **all** input fields consistently.

### 7.2 Flutter (Client) Recommendations

- Store tokens using secure storage (e.g. `flutter_secure_storage`).  
- Add retry/backoff logic to avoid inconsistent states on network errors.  
- Replace verbose error messages with generic, user-friendly messages.  

### 7.3 General Recommendations

- Implement **OpenAPI/Swagger** documentation to formalize the API contract.  
- Add automated **security scans** (SAST/DAST) into CI/CD.  
- Configure logging and monitoring for suspicious authentication/authorization behavior.

---

## 8. Conclusion

The system is functional but contains several **high-severity issues** related to validation, authorization, and error handling.  
These must be addressed **before any production deployment**.

With stronger validation, secure token handling, consistent CORS and middleware enforcement, and improved error handling, the overall security posture of the Laravel Backend API and Flutter Mobile App can be significantly improved.
