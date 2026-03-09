<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Http\Requests\LoginRequest;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    use ApiResponse;

    public function login(LoginRequest $request)
    {
        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['The provided credentials are incorrect.'],
            ]);
        }

        $token = $user->createToken('auth-token')->plainTextToken;

        return $this->successResponse([
            'user' => $user,
            'token' => $token
        ], 'Login successful');
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return $this->successResponse(null, 'Logged out successfully');
    }

    public function me(Request $request)
    {
        return $this->successResponse($request->user()->load('department'), 'User profile retrieved');
    }
}