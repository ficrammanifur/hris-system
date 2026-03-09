<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('attendances', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->date('date');
            $table->datetime('check_in_time');
            $table->datetime('check_out_time')->nullable();
            $table->decimal('check_in_latitude', 10, 8)->nullable();
            $table->decimal('check_in_longitude', 11, 8)->nullable();
            $table->decimal('check_out_latitude', 10, 8)->nullable();
            $table->decimal('check_out_longitude', 11, 8)->nullable();
            $table->enum('status', ['present', 'late', 'absent', 'half_day'])->default('present');
            $table->text('notes')->nullable();
            $table->timestamps();
            
            $table->unique(['user_id', 'date']);
        });
    }

    public function down()
    {
        Schema::dropIfExists('attendances');
    }
};