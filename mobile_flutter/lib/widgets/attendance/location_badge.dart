import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationBadge extends StatelessWidget {
  final Position? position;
  final bool isFetching;
  final String? error;
  final VoidCallback onRefresh;

  const LocationBadge({
    super.key,
    this.position,
    this.isFetching = false,
    this.error,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              position != null ? Icons.location_on : Icons.location_off,
              color: position != null ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFetching ? 'Getting location...'
                      : error ?? (position != null
                        ? 'Lat: ${position!.latitude.toStringAsFixed(6)}, '
                          'Lng: ${position!.longitude.toStringAsFixed(6)}'
                        : 'Location unavailable'),
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (position?.isMocked == true)
                    const Text('WARNING: Mock location!',
                      style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            if (!isFetching)
              IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh, size: 20)),
          ],
        ),
      ),
    );
  }
}