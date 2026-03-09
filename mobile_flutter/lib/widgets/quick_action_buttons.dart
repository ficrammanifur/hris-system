import 'package:flutter/material.dart';

class QuickActionButtons extends StatelessWidget {
  final bool canCheckIn;
  final bool canCheckOut;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final VoidCallback onLeaveRequest;

  const QuickActionButtons({
    super.key,
    required this.canCheckIn,
    required this.canCheckOut,
    required this.onCheckIn,
    required this.onCheckOut,
    required this.onLeaveRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.login,
            label: 'Check In',
            onTap: onCheckIn,
            enabled: canCheckIn,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.logout,
            label: 'Check Out',
            onTap: onCheckOut,
            enabled: canCheckOut,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.beach_access,
            label: 'Leave',
            onTap: onLeaveRequest,
            enabled: true,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool enabled,
    required Color color,
  }) {
    return Material(
      color: enabled ? color : Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(
                icon,
                color: enabled ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: enabled ? Colors.white : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}