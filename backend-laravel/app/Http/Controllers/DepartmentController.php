<?php

namespace App\Http\Controllers;

use App\Models\Department;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class DepartmentController extends Controller
{
    use ApiResponse;

    public function index()
    {
        $departments = Department::withCount('users')->get();
        return $this->successResponse($departments, 'Departments retrieved successfully');
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:departments',
            'description' => 'nullable|string',
            'code' => 'required|string|unique:departments'
        ]);

        $department = Department::create($validated);
        return $this->successResponse($department, 'Department created successfully', 201);
    }

    public function show(Department $department)
    {
        return $this->successResponse($department->load('users'), 'Department retrieved successfully');
    }

    public function update(Request $request, Department $department)
    {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255|unique:departments,name,' . $department->id,
            'description' => 'nullable|string',
            'code' => 'sometimes|string|unique:departments,code,' . $department->id
        ]);

        $department->update($validated);
        return $this->successResponse($department, 'Department updated successfully');
    }

    public function destroy(Department $department)
    {
        if ($department->users()->exists()) {
            return $this->errorResponse('Cannot delete department with existing employees', 422);
        }

        $department->delete();
        return $this->successResponse(null, 'Department deleted successfully');
    }
}