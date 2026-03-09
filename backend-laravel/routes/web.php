<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'message' => 'Welcome to HRIS API',
        'documentation' => 'Please use /api endpoints',
        'endpoints' => [
            'GET /api/test' => 'Test API',
            'POST /api/login' => 'Login',
            'GET /api/user' => 'Get user (auth required)'
        ]
    ]);
});