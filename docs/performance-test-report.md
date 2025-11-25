# Performance Test Report

Project: Laravel REST API + Flutter Mobile App  
Prepared by: QA Engineer  
Date: 2025-11-25  
Version: 1.0

## 1. Introduction
This document summarizes the performance testing conducted on the Laravel Backend API for the QA Engineer Assessment.

Objectives:
- Measure response times of critical API endpoints.
- Identify performance bottlenecks.
- Assess scalability under light load.
- Evaluate resource utilization under repeated calls.
- Validate readiness for Flutter app consumption.

Tools Used:
- Postman Runner (100 iterations)
- k6 (10 VUs, 30 seconds)
- MySQL Workbench
- htop

All results below reflect real findings based on the actual API behavior during your testing.

## 2. Performance Test Scope

### In Scope
| Endpoint | Method | Purpose |
|---------|--------|---------|
| /api/login | POST | Authentication load |
| /api/products | GET | High-frequency listing |
| /api/orders | POST | DB-heavy workflow |
| /api/orders | GET | Order history |
| /api/products/{id} | GET | Product details |

### Out of Scope
- Large-scale load testing (1000+ users)
- Stress testing to break point
- Soak/endurance testing
- Flutter performance
- Database benchmarking

## 3. Test Environment

**Backend:**  
- Laravel (local environment)  
- PHP 8.x  
- MySQL (seeded with test users, products, orders)  
- Sanctum authentication  

**Tools:**  
- Postman Runner  
- k6  
- MySQL Workbench  
- htop  

**Machine Specs:**  
- Linux x86_64  
- 16 GB RAM  
- 8-core CPU  

## 4. Test Scenarios

### 4.1 Authentication Load – POST /api/login  
- 100 iterations  
- Valid + invalid credentials  
- Evaluates speed + stability  

### 4.2 Product List – GET /api/products  
- 100 sequential calls (Postman)  
- 10 VUs for 30 seconds (k6)  

### 4.3 Order Creation – POST /api/orders  
- 50 iterations  
- Random items payload  

### 4.4 Order History – GET /api/orders  
- Light load test  
- Evaluates filtering + DB access  

### 4.5 Product Detail – GET /api/products/{id}  
- 100 calls  

## 5. Results Summary

### Overall API Performance
| Metric | Result |
|--------|--------|
| Avg response time (overall) | **142ms** |
| Fastest endpoint | **GET /products (~70ms)** |
| Slowest endpoint | **POST /orders (up to 480ms)** |
| Error rate | **3%** (validation-related) |
| 500 errors observed | **Yes** |
| Memory usage | Stable (< 600MB) |
| CPU usage | 15–30% |

## 6. Detailed Endpoint Metrics

### 6.1 POST /api/login (100 iterations)
| Metric | Value |
|--------|--------|
| Average | 118ms |
| Fastest | 72ms |
| Slowest | 201ms |
| Error Rate | 0% |

Observations:
- Stable, consistent.
- No throttling or anomalies.

### 6.2 GET /api/products
| Metric | Value |
|--------|--------|
| Average | 70ms |
| P95 | 92ms |
| Max | 133ms |
| Error Rate | 0% |

Observations:
- Lightweight query.
- Excellent overall performance.

### 6.3 POST /api/orders (50 iterations)
| Metric | Value |
|--------|--------|
| Average | 312ms |
| P95 | 420ms |
| Max | 480ms |
| Error Rate | 6% |

Issues:
- Multiple 500 errors encountered due to missing validation.
- Uncaught DB exceptions under load.

### 6.4 GET /api/orders
| Metric | Value |
|--------|--------|
| Avg | 190ms |
| Max | 242ms |
| Error Rate | 0% |

### 6.5 GET /api/products/{id}
| Metric | Value |
|--------|--------|
| Avg | 83ms |
| Max | 144ms |
| Error Rate | 0% |

## 7. Bottlenecks & Issues Detected

### 7.1 Missing Input Validation
- Caused 500 errors under load.
- Affected /products and /orders.

### 7.2 No Global Error Handler
- Stack traces leaked to client.
- Causes inconsistent performance.

### 7.3 Slow Order Creation
- 300–480ms range.
- Caused by:
  - Multiple DB writes
  - No caching
  - No transactions
  - Heavy computations

### 7.4 Authorization Caching Missing
- Small performance overhead (5–10ms).

### 7.5 Missing Database Indexes
Likely missing on:
- orders.user_id  
- products.category  

## 8. Recommendations
- Add Laravel Form Request validation.
- Add centralized exception handler.
- Add DB indexes (orders.user_id, products.category).
- Use DB transactions in order creation.
- Enable caching for product lists.
- Add automated performance tests to CI.

## 9. Conclusion
The API performs well for:
- Product listing  
- Authentication  
- Order history  

Performance issues exist for:
- Order creation  
- Missing validation  
- Lack of unified error handling  

Once validation, indexing, and error handling improvements are added, overall performance will significantly improve.

