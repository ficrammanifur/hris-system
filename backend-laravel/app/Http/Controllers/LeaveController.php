<?php

namespace App\Http\Controllers;

use App\Models\Leave;
use App\Models\User;
use App\Services\LeaveService;
use App\Http\Requests\LeaveRequest;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class LeaveController extends Controller
{
    use ApiResponse;

    protected $leaveService;

    public function __construct(LeaveService $leaveService)
    {
        $this->leaveService = $leaveService;
    }

    public function index(Request $request)
    {
        $query = Leave::with('user');

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        $leaves = $query->latest()->paginate(20);
        return $this->successResponse($leaves, 'Leave requests retrieved');
    }

    public function store(LeaveRequest $request)
    {
        $leave = $this->leaveService->createLeaveRequest(
            $request->user()->id,
            $request->validated()
        );

        return $this->successResponse($leave->load('user'), 'Leave request submitted', 201);
    }

    public function show(Leave $leave)
    {
        return $this->successResponse($leave->load('user'), 'Leave request retrieved');
    }

    public function update(LeaveRequest $request, Leave $leave)
    {
        $leave->update($request->validated());
        return $this->successResponse($leave->load('user'), 'Leave request updated');
    }

    public function approve(Leave $leave)
    {
        $leave = $this->leaveService->approveLeave($leave->id);
        return $this->successResponse($leave, 'Leave request approved');
    }

    public function reject(Leave $leave, Request $request)
    {
        $request->validate(['rejection_reason' => 'required|string']);
        
        $leave = $this->leaveService->rejectLeave(
            $leave->id, 
            $request->rejection_reason
        );
        
        return $this->successResponse($leave, 'Leave request rejected');
    }

    public function balance(Request $request, User $user)
    {
        $balance = $this->leaveService->getLeaveBalance($user->id);
        return $this->successResponse($balance, 'Leave balance retrieved');
    }
}