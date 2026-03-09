import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_flutter/providers/auth_provider.dart';
import 'package:mobile_flutter/providers/attendance_provider.dart';
import 'package:mobile_flutter/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  bool _locationEnabled = false;
  Position? _currentPosition;
  String? _address;
  String? _notes;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      _showLocationDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog();
      return;
    }

    _getCurrentLocation();
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Location Disabled'),
        content: const Text('Please enable location services to check in.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Geolocator.openLocationSettings();
              Navigator.pop(ctx);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('Location permission is required to check in.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _locationEnabled = true;
      });
    } catch (e) {
      setState(() {
        _locationEnabled = false;
      });
    }
  }

  Future<void> _handleCheckIn() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to get location. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);

    final success = await attendanceProvider.checkIn(
      authProvider.user!.id,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      notes: _notes,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _locationEnabled ? Icons.location_on : Icons.location_off,
                      size: 48,
                      color: _locationEnabled ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _locationEnabled ? 'Location Ready' : 'Location Unavailable',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _locationEnabled ? Colors.green : Colors.red,
                      ),
                    ),
                    if (_currentPosition != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes Field
            TextField(
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Add any notes about your check-in',
              ),
              maxLines: 3,
              onChanged: (value) => _notes = value,
            ),

            const Spacer(),

            // Check-in Button
            CustomButton(
              text: 'Check In Now',
              onPressed: _locationEnabled ? _handleCheckIn : null,
              loading: attendanceProvider.isCheckingIn,
            ),
          ],
        ),
      ),
    );
  }
}