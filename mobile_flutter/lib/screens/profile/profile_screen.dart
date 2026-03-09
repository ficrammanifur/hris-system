import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_flutter/providers/auth_provider.dart';
import 'package:mobile_flutter/providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(theme.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: theme.toggleTheme,
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue.withAlpha(25),
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.position,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user.employeeId,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Info Cards
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            Icons.email,
                            'Email',
                            user.email,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            Icons.phone,
                            'Phone',
                            user.phone ?? '-',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Join Date',
                            '${user.joinDate.day}/${user.joinDate.month}/${user.joinDate.year}',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            Icons.business,
                            'Department',
                            user.department?.name ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Logout Button
                  ElevatedButton(
                    onPressed: () async {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}