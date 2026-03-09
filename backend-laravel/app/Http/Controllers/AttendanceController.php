<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use App\Models\User;
use App\Services\AttendanceService;
use App\Http\Requests\AttendanceRequest;
use App\Traits\ApiResponse;
use Illuminate\Http\Request;

class AttendanceController extends Controller
{
    use ApiResponse;

    protected $attendanceService;

    public function __construct(AttendanceService $attendanceService)
    {
        $this->attendanceService = $attendanceService;
    }

    public function checkIn(AttendanceRequest $request)
    {
        $attendance = $this->attendanceService->checkIn(
            $request->user()->id,
            $request->latitude,
            $request->longitude
        );

        return $this->successResponse($attendance, 'Check-in successful');
    }

    public function checkOut(Request $request)
    {
        $attendance = $this->attendanceService->checkOut(
            $request->user()->id,
            $request->latitude,
            $request->longitude
        );

        return $this->successResponse($attendance, 'Check-out successful');
    }

    public function index(Request $request)
    {
        $query = Attendance::with('user');

        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->has('date')) {
            $query->whereDate('date', $request->date);
        }

        if ($request->has('month') && $request->has('year')) {
            $query->whereMonth('date', $request->month)
                  ->whereYear('date', $request->year);
        }

        $attendances = $query->latest()->paginate(20);
        return $this->successResponse($attendances, 'Attendance records retrieved');
    }

    public function show(Attendance $attendance)
    {
        return $this->successResponse($attendance->load('user'), 'Attendance record retrieved');
    }

    public function summary(Request $request, User $user)
    {
        $summary = $this->attendanceService->getMonthlySummary(
            $user->id,
            $request->get('month', now()->month),
            $request->get('year', now()->year)
        );

        return $this->successResponse($summary, 'Attendance summary retrieved');
    }
}