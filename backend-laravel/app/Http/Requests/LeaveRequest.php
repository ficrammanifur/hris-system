<?php

namespace App\Http\Requests;  // Perbaiki namespace

use Illuminate\Foundation\Http\FormRequest;

class LeaveRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'start_date' => 'required|date|after_or_equal:today',
            'end_date' => 'required|date|after_or_equal:start_date',
            'type' => 'required|in:sick,annual,unpaid,other',
            'reason' => 'required|string|max:500',
            'notes' => 'nullable|string|max:500'
        ];
    }
}