<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Department;
use App\Models\Attendance;
use App\Models\Leave;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run()
    {
        // Create departments
        $departments = [
            ['name' => 'Information Technology', 'code' => 'IT', 'description' => 'IT Department'],
            ['name' => 'Human Resources', 'code' => 'HR', 'description' => 'HR Department'],
            ['name' => 'Finance', 'code' => 'FIN', 'description' => 'Finance Department'],
            ['name' => 'Marketing', 'code' => 'MKT', 'description' => 'Marketing Department'],
        ];

        foreach ($departments as $dept) {
            Department::create($dept);
        }

        // Create admin user
        User::create([
            'name' => 'Admin User',
            'email' => 'admin@example.com',
            'password' => Hash::make('password'),
            'employee_id' => 'EMP001',
            'department_id' => 1,
            'position' => 'System Administrator',
            'join_date' => now(),
            'phone' => '081234567890',
            'address' => 'Jakarta',
            'status' => 'active'
        ]);

        // Create sample employees
        $employees = [
            [
                'name' => 'John Doe',
                'email' => 'john@example.com',
                'employee_id' => 'EMP002',
                'department_id' => 1,
                'position' => 'Software Engineer',
                'join_date' => now()->subMonths(6),
                'phone' => '081234567891',
            ],
            [
                'name' => 'Jane Smith',
                'email' => 'jane@example.com',
                'employee_id' => 'EMP003',
                'department_id' => 2,
                'position' => 'HR Manager',
                'join_date' => now()->subYears(2),
                'phone' => '081234567892',
            ],
        ];

        foreach ($employees as $emp) {
            $emp['password'] = Hash::make('password');
            $emp['address'] = 'Jakarta';
            $emp['status'] = 'active';
            User::create($emp);
        }

        // Create sample attendance records for this month
        $users = User::all();
        foreach ($users as $user) {
            for ($i = 1; $i <= now()->day; $i++) {
                if ($i <= 5) { // Only create for first 5 days of month
                    Attendance::create([
                        'user_id' => $user->id,
                        'date' => now()->setDay($i),
                        'check_in_time' => now()->setDay($i)->setTime(8, 0),
                        'check_out_time' => now()->setDay($i)->setTime(17, 0),
                        'check_in_latitude' => -6.2088,
                        'check_in_longitude' => 106.8456,
                        'status' => 'present'
                    ]);
                }
            }
        }
    }
}