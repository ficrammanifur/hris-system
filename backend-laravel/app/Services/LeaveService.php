<?php

namespace App\Services;

use App\Models\Leave;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class LeaveService
{
    const ANNUAL_LEAVE_DAYS = 12;

    public function createLeaveRequest($userId, $data)
    {
        return DB::transaction(function () use ($userId, $data) {
            // Check for overlapping leave requests
            $overlapping = Leave::where('user_id', $userId)
                ->where('status', '!=', 'rejected')
                ->where(function ($query) use ($data) {
                    $query->whereBetween('start_date', [$data['start_date'], $data['end_date']])
                        ->orWhereBetween('end_date', [$data['start_date'], $data['end_date']]);
                })
                ->exists();

            if ($overlapping) {
                throw new \Exception('You already have a leave request for this period');
            }

            // Check leave balance
            if ($data['type'] === 'annual') {
                $balance = $this->getLeaveBalance($userId);
                $daysRequested = Carbon::parse($data['start_date'])->diffInDays(Carbon::parse($data['end_date'])) + 1;
                
                if ($balance['remaining'] < $daysRequested) {
                    throw new \Exception('Insufficient leave balance');
                }
            }

            return Leave::create([
                'user_id' => $userId,
                ...$data,
                'status' => 'pending'
            ]);
        });
    }

    public function approveLeave($leaveId, $approverId = null)
    {
        return DB::transaction(function () use ($leaveId, $approverId) {
            $leave = Leave::findOrFail($leaveId);
            
            $leave->update([
                'status' => 'approved',
                'approved_by' => $approverId,
                'approved_at' => now()
            ]);

            return $leave;
        });
    }

    public function rejectLeave($leaveId, $rejectionReason)
    {
        return DB::transaction(function () use ($leaveId, $rejectionReason) {
            $leave = Leave::findOrFail($leaveId);
            
            $leave->update([
                'status' => 'rejected',
                'rejection_reason' => $rejectionReason
            ]);

            return $leave;
        });
    }

    public function getLeaveBalance($userId)
    {
        $user = User::findOrFail($userId);
        
        // Calculate total leave days taken this year
        $takenLeaves = Leave::where('user_id', $userId)
            ->where('type', 'annual')
            ->where('status', 'approved')
            ->whereYear('start_date', now()->year)
            ->get()
            ->sum(function ($leave) {
                return $leave->days;
            });

        // Calculate pending leaves
        $pendingLeaves = Leave::where('user_id', $userId)
            ->where('type', 'annual')
            ->where('status', 'pending')
            ->whereYear('start_date', now()->year)
            ->get()
            ->sum(function ($leave) {
                return $leave->days;
            });

        // Calculate remaining balance (you can customize this logic)
        $total = self::ANNUAL_LEAVE_DAYS;
        $remaining = $total - $takenLeaves;

        return [
            'total' => $total,
            'taken' => $takenLeaves,
            'pending' => $pendingLeaves,
            'remaining' => $remaining
        ];
    }
}