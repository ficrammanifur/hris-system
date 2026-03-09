import 'package:flutter/material.dart';
import 'package:mobile_flutter/data/models/attendance_model.dart';
import 'package:mobile_flutter/data/models/leave_model.dart';
import 'package:intl/intl.dart';

class RecentActivity extends StatelessWidget {
  final List<Attendance> attendances;
  final List<Leave> leaves;
  final VoidCallback onViewAllAttendance;
  final VoidCallback onViewAllLeaves;

  const RecentActivity({
    super.key,
    required this.attendances,
    required this.leaves,
    required this.onViewAllAttendance,
    required this.onViewAllLeaves,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: onViewAllAttendance,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...attendances.map((a) => _buildAttendanceItem(a)),
            if (leaves.isNotEmpty) ...[
              const Divider(height: 24),
              ...leaves.map((l) => _buildLeaveItem(l)),
            ],
            if (attendances.isEmpty && leaves.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No recent activity'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(Attendance attendance) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: attendance.isLate ? Colors.orange.shade100 : Colors.green.shade100,
        child: Icon(
          attendance.isLate ? Icons.warning : Icons.check,
          color: attendance.isLate ? Colors.orange : Colors.green,
          size: 20,
        ),
      ),
      title: Text(
        DateFormat('dd MMM yyyy').format(attendance.date),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Check-in: ${DateFormat('HH:mm').format(attendance.checkInTime)}'
        '${attendance.checkOutTime != null ? ' • Check-out: ${DateFormat('HH:mm').format(attendance.checkOutTime!)}' : ''}',
      ),
      trailing: Text(
        attendance.status.toUpperCase(),
        style: TextStyle(
          color: attendance.isLate ? Colors.orange : Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLeaveItem(Leave leave) {
    Color color;
    if (leave.isApproved) {
      color = Colors.green;
    } else if (leave.isRejected) {
      color = Colors.red;
    } else {
      color = Colors.orange;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withAlpha(26),
        child: Icon(
          leave.isApproved ? Icons.check_circle :
          leave.isRejected ? Icons.cancel : Icons.access_time,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        'Leave Request (${leave.type})',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${DateFormat('dd MMM').format(leave.startDate)} - ${DateFormat('dd MMM').format(leave.endDate)}',
      ),
      trailing: Text(
        leave.statusDisplay,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}