<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class EmployeeController extends Controller
{
    use ApiResponse;

    public function index()
    {
        $employees = User::with('department')->get();
        return $this->successResponse($employees, 'Employees retrieved successfully');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8',
            'employee_id' => 'required|string|unique:users',
            'department_id' => 'required|exists:departments,id',
            'position' => 'required|string',
            'join_date' => 'required|date',
            'phone' => 'nullable|string',
            'address' => 'nullable|string'
        ]);

        $validated['password'] = Hash::make($validated['password']);
        $employee = User::create($validated);

        return $this->successResponse($employee->load('department'), 'Employee created successfully', 201);
    }

    public function show(User $employee)
    {
        return $this->successResponse($employee->load('department'), 'Employee retrieved successfully');
    }

    public function update(Request $request, User $employee)
    {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|string|email|max:255|unique:users,email,' . $employee->id,
            'employee_id' => 'sometimes|string|unique:users,employee_id,' . $employee->id,
            'department_id' => 'sometimes|exists:departments,id',
            'position' => 'sometimes|string',
            'join_date' => 'sometimes|date',
            'phone' => 'nullable|string',
            'address' => 'nullable|string',
            'status' => 'sometimes|in:active,inactive'
        ]);

        if (isset($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        $employee->update($validated);
        return $this->successResponse($employee->load('department'), 'Employee updated successfully');
    }

    public function destroy(User $employee)
    {
        $employee->delete();
        return $this->successResponse(null, 'Employee deleted successfully');
    }
}