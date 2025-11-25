# Test Plan Document
Project: Laravel REST API + Flutter Mobile App
Version: 1.0
Prepared by: QA Engineer
Date: 2025-11-25

## 1. Purpose
This Test Plan defines the complete framework for testing the Laravel REST API and Flutter Mobile Application.  
It outlines:
- Test case design approach
- Execution processes
- Test environment
- Test data
- Pass/fail criteria
- Traceability to requirements
- Reporting and documentation

The plan follows IEEE 829 and ISO 29119 standards to ensure structured and repeatable QA processes.

## 2. Test Items
### 2.1 Laravel Backend API
- Authentication (Login, Register, Logout)
- User Management (CRUD, validation, permissions)
- Product Management (CRUD, admin restrictions)
- Order Management (creation, totals, history, admin updates)

### 2.2 Flutter Mobile App
- UI Components
- Navigation flows
- Network/API service integration
- Error handling
- Session management

## 3. Features to Be Tested
| Module | Features |
|-------|----------|
| Authentication | Login, register, logout, token validation |
| Users | CRUD, validation, RBAC restrictions |
| Products | CRUD, price validation, category validation, admin-only actions |
| Orders | Create order, invalid orders, order history, totals, admin status changes |
| Flutter | Login flow, product list, product details, place order, session expiry, offline behavior |

## 4. Features Not to Be Tested
- UI theming or design review  
- Localization & multilingual support  
- Performance at production scale  
- Payment gateways  
- Cross-browser testing

## 5. Test Approach
### 5.1 Manual Testing
- Functional CRUD validation  
- Boundary testing  
- Negative testing  
- Error handling verification  
- UI tests on emulator/device  

### 5.2 Automated Testing
**Laravel:**  
- PHPUnit Unit tests  
- Integration tests  
- Feature/API workflow tests  
- Goal: ≥80% code coverage  

**Flutter:**  
- Unit tests  
- Widget tests  
- Integration tests  
- Goal: ≥80% code coverage  

### 5.3 ISTQB Test Design Techniques
- Boundary Value Analysis  
- Equivalence Partitioning  
- State Transition Testing  
- Decision Table Testing  
- Error Guessing  

## 6. Test Environment
### Backend
- PHP 8.x  
- Laravel  
- MySQL  
- Sanctum  

### Mobile
- Flutter SDK  
- Android Emulator  

### Tools
- Postman  
- PHPUnit  
- Flutter Test Framework  
- GitHub Actions  
- MySQL Workbench  

## 7. Test Schedule
| Activity | Timeline |
|----------|----------|
| API Manual Testing | Done |
| Flutter Manual Testing | 1–2 days |
| Laravel Automation | 2–3 days |
| Flutter Automation | 1–2 days |
| Performance Testing | 0.5–1 day |
| Documentation | 1 day |

## 8. Test Cases (Summary — 70+ total)
### 8.1 Authentication (AT1–AT10)
### 8.2 Users (U1–U15)
### 8.3 Products (P1–P15)
### 8.4 Orders (O1–O15)
### 8.5 Flutter App (F1–F20)

## 9. Test Data
### Authentication
- admin@test.com / password  
- user@test.com / password  

### Products
- Valid and invalid price sets  

### Orders
- Valid and invalid items arrays  

## 10. Pass/Fail Criteria
### Pass
- Expected output matches actual  
- Correct HTTP codes  
- Correct database updates  
- UI loads without crashes  

### Fail
- Incorrect output  
- 500 errors  
- Broken validation  
- Unauthorized access allowed  

## 11. Traceability Matrix
| Requirement | Test Case IDs |
|------------|----------------|
| Login | AT1–AT5, F1–F5 |
| Logout | AT6, F14 |
| User CRUD | U1–U15 |
| Product CRUD | P1–P15 |
| Order Creation | O1–O10, F9 |
| Order Update | O11–O15 |
| Flutter UI Flows | F1–F20 |

## 12. Reporting
Generated Reports:
- Test Execution Report  
- Test Summary Report  
- Bug Report (30+ bugs)  
- Bug Dashboard  
- Metrics Report  
- CI Pipeline Logs  

## 13. Risks & Contingencies
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| API bugs block Flutter testing | High | High | Test API first + automation |
| Permission logic errors | Medium | High | Decision table testing |
| Tight deadline | High | High | Risk-based execution |
| DB issues | Medium | Medium | Reset scripts |

# END OF TEST PLAN DOCUMENT
