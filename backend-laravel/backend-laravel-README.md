# HRIS Backend API

## API Endpoints

### Authentication
POST   /api/auth/login          # Login, returns Sanctum token
POST   /api/auth/logout         # Revoke current token
GET    /api/auth/me             # Get authenticated user

### Employees
GET    /api/employees           # List (paginated, filterable)
POST   /api/employees           # Create new employee
GET    /api/employees/{id}      # Get employee detail
PUT    /api/employees/{id}      # Update employee
DELETE /api/employees/{id}      # Soft delete employee

### Attendance
POST   /api/attendance/check-in # Check in (photo + GPS)
POST   /api/attendance/check-out # Check out (photo + GPS)
GET    /api/attendance           # List attendance records
GET    /api/attendance/today     # Today's status
GET    /api/attendance/report    # Monthly report

### Departments
GET    /api/departments          # List departments
POST   /api/departments          # Create department
PUT    /api/departments/{id}     # Update department

### Leaves
GET    /api/leaves               # List leave requests
POST   /api/leaves               # Submit leave request
PUT    /api/leaves/{id}/approve  # Approve (HR/Manager)
PUT    /api/leaves/{id}/reject   # Reject (HR/Manager)

### Dashboard
GET    /api/dashboard/stats      # Summary statistics
GET    /api/dashboard/attendance # Attendance chart data
GET    /api/dashboard/departments # Department breakdown

## Authentication Flow
1. Client sends POST /api/auth/login with email + password
2. Server validates, returns Sanctum token
3. Client stores token, sends in Authorization: Bearer {token}
4. Token expires after configurable duration (default: 24h)
5. Logout revokes token on server

## Response Format
{
    "success": true,
    "message": "Operation successful",
    "data": { ... },
    "meta": {
        "current_page": 1,
        "per_page": 15,
        "total": 100
    }
}

## Error Response Format
{
    "success": false,
    "message": "Validation failed",
    "errors": {
        "email": ["The email field is required."]
    }
}


## Public Endpoints (Tidak Perlu Token)

# Test API
curl http://127.0.0.1:8000/api/test

# Login
curl -X POST http://127.0.0.1:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password"}'

## Protected Endpoints (Perlu Token)

# Set token
export TOKEN="1|UFOTVNYNFE9KOHdX0PJq2ZJaOWQ9D55aPIHEU72H91e7ba0f"

# 1. User Profile
curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8000/api/me

# 2. Employees
curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8000/api/employees
curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8000/api/employees/1

# 3. Departments
curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8000/api/departments
curl -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8000/api/departments/1

# 4. Attendance
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"latitude":-6.2088,"longitude":106.8456}' \
  http://127.0.0.1:8000/api/attendance/check-in

# 5. Leave
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"start_date":"2026-03-10","end_date":"2026-03-12","type":"annual","reason":"Family vacation"}' \
  http://127.0.0.1:8000/api/leaves

# 6. Logout
curl -X POST -H "Authorization: Bearer $TOKEN" http://127.0.0.1:8000/api/logout
