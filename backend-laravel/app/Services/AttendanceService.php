<?php

namespace App\Services;

use App\Models\Attendance;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AttendanceService
{
    public function checkIn($userId, $latitude, $longitude)
    {
        return DB::transaction(function () use ($userId, $latitude, $longitude) {
            // Check if already checked in today
            $existing = Attendance::where('user_id', $userId)
                ->whereDate('date', now())
                ->first();

            if ($existing) {
                throw new \Exception('Already checked in today');
            }

            return Attendance::create([
                'user_id' => $userId,
                'date' => now(),
                'check_in_time' => now(),
                'check_in_latitude' => $latitude,
                'check_in_longitude' => $longitude,
                'status' => 'present'
            ]);
        });
    }

    public function checkOut($userId, $latitude, $longitude)
    {
        return DB::transaction(function () use ($userId, $latitude, $longitude) {
            $attendance = Attendance::where('user_id', $userId)
                ->whereDate('date', now())
                ->first();

            if (!$attendance) {
                throw new \Exception('No check-in record found for today');
            }

            if ($attendance->check_out_time) {
                throw new \Exception('Already checked out today');
            }

            $attendance->update([
                'check_out_time' => now(),
                'check_out_latitude' => $latitude,
                'check_out_longitude' => $longitude
            ]);

            return $attendance;
        });
    }

    public function getMonthlySummary($userId, $month, $year)
    {
        $attendances = Attendance::where('user_id', $userId)
            ->whereMonth('date', $month)
            ->whereYear('date', $year)
            ->get();

        $totalDays = $attendances->count();
        $lateDays = $attendances->filter(function ($attendance) {
            return $attendance->is_late;
        })->count();
        
        $totalHours = $attendances->sum(function ($attendance) {
            return $attendance->duration ?? 0;
        });

        return [
            'total_days' => $totalDays,
            'late_days' => $lateDays,
            'total_hours' => round($totalHours, 2),
            'average_hours_per_day' => $totalDays > 0 ? round($totalHours / $totalDays, 2) : 0,
            'attendances' => $attendances
        ];
    }
}