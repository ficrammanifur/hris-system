import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class PermissionHandler {
  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Open app settings
      await Geolocator.openAppSettings();
      return false;
    }
    
    return true;
  }
  
  static Future<bool> requestCameraPermission() async {
    final status = await ph.Permission.camera.request();
    return status.isGranted;
  }
  
  static Future<bool> requestNotificationPermission() async {
    if (await ph.Permission.notification.isGranted) {
      return true;
    }
    
    final status = await ph.Permission.notification.request();
    return status.isGranted;
  }
  
  static Future<bool> checkLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
  
  static Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }
}