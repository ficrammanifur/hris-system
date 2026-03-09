import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:hris_mobile/providers/attendance_provider.dart';
import 'package:hris_mobile/core/utils/location_helper.dart';
import 'package:hris_mobile/core/utils/image_helper.dart';
import 'package:hris_mobile/widgets/attendance/camera_preview.dart';
import 'package:hris_mobile/widgets/attendance/location_badge.dart';
import 'package:hris_mobile/widgets/common/custom_button.dart';
import 'package:hris_mobile/core/constants/app_colors.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});
  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  File? _photo;
  Position? _position;
  bool _fetchingLocation = false;
  String? _locationError;

  @override
  void initState() { super.initState(); _fetchLocation(); }

  Future<void> _fetchLocation() async {
    setState(() { _fetchingLocation = true; _locationError = null; });
    try { _position = await LocationHelper.getCurrentPosition(); }
    catch (e) { _locationError = e.toString(); }
    setState(() { _fetchingLocation = false; });
  }

  Future<void> _handleCheckOut() async {
    if (_position == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location required.')));
      return;
    }
    final vm = context.read<AttendanceProvider>();
    final ok = await vm.checkOut(lat: _position!.latitude, lng: _position!.longitude, photo: _photo);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.message ?? ''), backgroundColor: ok ? Colors.green : Colors.red));
      if (ok) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AttendanceProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Check Out')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          CameraPreview(photo: _photo, onTap: () async { final p = await ImageHelper.takeSelfie(); if (p != null) setState(() => _photo = p); }),
          const SizedBox(height: 8),
          Text('Photo is optional for check-out', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          LocationBadge(position: _position, isFetching: _fetchingLocation, error: _locationError, onRefresh: _fetchLocation),
          const SizedBox(height: 24),
          CustomButton(text: 'Check Out', icon: Icons.logout_rounded, isLoading: vm.isLoading, backgroundColor: AppColors.warning, onPressed: _handleCheckOut),
        ]),
      ),
    );
  }
}