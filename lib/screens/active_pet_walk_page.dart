import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'completed_pet_walk_page.dart';

class ActivePetWalkPage extends StatefulWidget {
  const ActivePetWalkPage({
    super.key,
    required this.selectedPets,
  });

  final List<Map<String, dynamic>> selectedPets;

  @override
  State<ActivePetWalkPage> createState() => _ActivePetWalkPageState();
}

class _ActivePetWalkPageState extends State<ActivePetWalkPage> {
  GoogleMapController? _mapController;
  final List<LatLng> _path = [];
  StreamSubscription<Position>? _positionSub;
  Timer? _timer;

  Duration _elapsed = Duration.zero;
  double _distance = 0;
  LatLng? _currentLatLng;
  bool _isPaused = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeTracking() async {
    final permissionGranted = await _ensurePermission();
    if (!permissionGranted || !mounted) return;

    final current = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    final startPoint = LatLng(current.latitude, current.longitude);

    setState(() {
      _isLoading = false;
      _currentLatLng = startPoint;
      _path.add(startPoint);
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _elapsed += const Duration(seconds: 1);
        });
      }
    });

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((position) {
      if (_isPaused) return;
      final nextPoint = LatLng(position.latitude, position.longitude);

      setState(() {
        if (_path.isNotEmpty) {
          _distance += Geolocator.distanceBetween(
            _path.last.latitude,
            _path.last.longitude,
            nextPoint.latitude,
            nextPoint.longitude,
          );
        }
        _path.add(nextPoint);
        _currentLatLng = nextPoint;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(nextPoint),
      );
    });
  }

  Future<bool> _ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen konum servislerini açın.')),
        );
      }
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Konum izni gerekli.')),
          );
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Konum izni kalıcı olarak reddedildi. Ayarlar > Konumdan izin veriniz.'),
          ),
        );
      }
      return false;
    }
    return true;
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _endWalk() {
    _timer?.cancel();
    _positionSub?.cancel();

    final summaryDistanceKm = _distance / 1000;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CompletedPetWalkPage(
          duration: _elapsed,
          distanceInKm: summaryDistanceKm,
          selectedPets: widget.selectedPets,
          path: _path,
        ),
      ),
    );
  }

  String _formatDuration() {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = _elapsed.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final distanceText = '${(_distance / 1000).toStringAsFixed(2)} km';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLatLng ?? const LatLng(41.0082, 28.9784),
                zoom: 17,
              ),
              onMapCreated: (controller) => _mapController = controller,
              polylines: {
                if (_path.length > 1)
                  Polyline(
                    polylineId: const PolylineId('walk_path'),
                    color: Colors.deepPurple,
                    width: 6,
                    points: _path,
                  ),
              },
              myLocationEnabled: _currentLatLng != null,
              myLocationButtonEnabled: false,
              markers: {
                if (_path.isNotEmpty)
                  Marker(
                    markerId: const MarkerId('current'),
                    position: _path.last,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet,
                    ),
                  ),
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Yürüyüş',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _InfoChip(
                  icon: Icons.timer,
                  label: _isLoading ? '00:00' : _formatDuration(),
                ),
                const SizedBox(height: 8),
                _InfoChip(
                  icon: Icons.pets,
                  label: _isLoading ? '0.00 km' : distanceText,
                ),
                const SizedBox(height: 16),
                _EndWalkButton(
                  onPressed: _isLoading ? null : _endWalk,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF8E7CC3),
                onPressed: _isLoading ? null : _togglePause,
                child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8E7CC3)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EndWalkButton extends StatelessWidget {
  const _EndWalkButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8E7CC3),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: const Text(
        'Yürüyüşü Bitir',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
