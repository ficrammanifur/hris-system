import 'package:flutter/material.dart';
import 'package:mobile_flutter/data/models/attendance_model.dart';
import 'package:mobile_flutter/data/models/leave_model.dart';

class StatsCard extends StatelessWidget {
  final AttendanceSummary? attendanceSummary;
  final LeaveBalance? leaveBalance;

  const StatsCard({
    super.key,
    this.attendanceSummary,
    this.leaveBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.calendar_today,
                    value: attendanceSummary?.totalDays.toString() ?? '0',
                    label: 'Days',
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.access_time,
                    value: attendanceSummary?.totalHours.toStringAsFixed(1) ?? '0',
                    label: 'Hours',
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.beach_access,
                    value: leaveBalance?.remaining.toString() ?? '0',
                    label: 'Leave Left',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}