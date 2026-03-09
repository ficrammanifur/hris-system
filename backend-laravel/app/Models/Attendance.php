<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Attendance extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'date',
        'check_in_time',
        'check_out_time',
        'check_in_latitude',
        'check_in_longitude',
        'check_out_latitude',
        'check_out_longitude',
        'status',
        'notes'
    ];

    protected $casts = [
        'date' => 'date',
        'check_in_time' => 'datetime',
        'check_out_time' => 'datetime'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function getDurationAttribute()
    {
        if ($this->check_in_time && $this->check_out_time) {
            return $this->check_in_time->diffInHours($this->check_out_time);
        }
        return null;
    }

    public function getIsLateAttribute()
    {
        if ($this->check_in_time) {
            $lateThreshold = now()->setTime(9, 0, 0); // 9 AM
            return $this->check_in_time->gt($lateThreshold);
        }
        return false;
    }
}