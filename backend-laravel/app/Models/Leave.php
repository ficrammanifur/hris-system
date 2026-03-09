<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Leave extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'start_date',
        'end_date',
        'type',
        'reason',
        'status',
        'approved_by',
        'approved_at',
        'rejection_reason',
        'notes'
    ];

    protected $casts = [
        'start_date' => 'date',
        'end_date' => 'date',
        'approved_at' => 'datetime'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function approver()
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    public function getDaysAttribute()
    {
        return $this->start_date->diffInDays($this->end_date) + 1;
    }

    public function getStatusBadgeAttribute()
    {
        $badges = [
            'pending' => 'warning',
            'approved' => 'success',
            'rejected' => 'danger'
        ];
        
        return $badges[$this->status] ?? 'secondary';
    }
}