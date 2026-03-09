<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\LeaveController;
use App\Http\Controllers\DepartmentController;

Route::get('/test', function() {
    return response()->json([
        'message' => 'API is working',
        'time' => now()->toDateTimeString()
    ]);
});

// Public routes
Route::post('/login', [AuthController::class, 'login']);

// Protected routes (memerlukan token)
Route::middleware('auth:sanctum')->group(function () {
    // Auth
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);
    
    // Employees
    Route::apiResource('employees', EmployeeController::class);
    
    // Departments
    Route::apiResource('departments', DepartmentController::class);
    
    // Attendance
    Route::prefix('attendance')->group(function () {
        Route::post('/check-in', [AttendanceController::class, 'checkIn']);
        Route::post('/check-out', [AttendanceController::class, 'checkOut']);
        Route::get('/', [AttendanceController::class, 'index']);
        Route::get('/summary/{user}', [AttendanceController::class, 'summary']);
    });
    
    // Leave
    Route::prefix('leaves')->group(function () {
        Route::get('/', [LeaveController::class, 'index']);
        Route::post('/', [LeaveController::class, 'store']);
        Route::post('/{leave}/approve', [LeaveController::class, 'approve']);
        Route::post('/{leave}/reject', [LeaveController::class, 'reject']);
        Route::get('/balance/{user}', [LeaveController::class, 'balance']);
    });
});