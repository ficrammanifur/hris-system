import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_flutter/providers/auth_provider.dart';
import 'package:mobile_flutter/providers/attendance_provider.dart';
import 'package:mobile_flutter/providers/leave_provider.dart';
import 'package:mobile_flutter/routes/app_routes.dart';
import 'package:mobile_flutter/widgets/bottom_nav_bar.dart';
import 'package:mobile_flutter/widgets/greeting_card.dart';
import 'package:mobile_flutter/widgets/stats_card.dart';
import 'package:mobile_flutter/widgets/quick_action_buttons.dart';
import 'package:mobile_flutter/widgets/recent_activity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Gunakan WidgetsBinding.instance.addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

    if (authProvider.user != null) {
      final userId = authProvider.user!.id;
      
      // Panggil tanpa await agar tidak blocking
      attendanceProvider.getAttendances(userId: userId);
      attendanceProvider.getSummary(
        userId: userId,
        month: DateTime.now().month,
        year: DateTime.now().year,
      );
      leaveProvider.getLeaves(userId: userId);
      leaveProvider.getLeaveBalance(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final leaveProvider = Provider.of<LeaveProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Card
              if (authProvider.user != null)
                GreetingCard(user: authProvider.user!),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              QuickActionButtons(
                canCheckIn: attendanceProvider.canCheckIn,
                canCheckOut: attendanceProvider.canCheckOut,
                onCheckIn: () {
                  Navigator.pushNamed(context, AppRoutes.checkIn);
                },
                onCheckOut: () async {
                  final success = await attendanceProvider.checkOut(
                    authProvider.user!.id,
                  );
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Check-out successful'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                onLeaveRequest: () {
                Navigator.pushNamed(context, AppRoutes.leaveRequest);
                },
              ),
              
              const SizedBox(height: 24),
              
              // Stats Cards
              if (attendanceProvider.summary != null || leaveProvider.balance != null)
                StatsCard(
                  attendanceSummary: attendanceProvider.summary,
                  leaveBalance: leaveProvider.balance,
                ),
              
              const SizedBox(height: 24),
              
              // Recent Activity
              RecentActivity(
                attendances: attendanceProvider.attendances.take(3).toList(),
                leaves: leaveProvider.leaves.take(3).toList(),
                onViewAllAttendance: () {
                  // Navigator.pushNamed(context, AppRoutes.attendanceHistory);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Attendance History - Coming Soon'),
                    ),
                  );
                },
                onViewAllLeaves: () {
                  // Navigator.pushNamed(context, AppRoutes.leaveHistory);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Leave History - Coming Soon'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Handle navigation
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              // Navigator.pushNamed(context, AppRoutes.attendanceHistory);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attendance - Coming Soon'),
                ),
              );
              break;
            case 2:
              // Navigator.pushNamed(context, AppRoutes.leaveHistory);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Leave - Coming Soon'),
                ),
              );
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}