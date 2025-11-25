import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CompletedPetWalkPage extends StatelessWidget {
  const CompletedPetWalkPage({
    super.key,
    required this.duration,
    required this.distanceInKm,
    required this.selectedPets,
    required this.path,
  });

  final Duration duration;
  final double distanceInKm;
  final List<Map<String, dynamic>> selectedPets;
  final List<LatLng> path;

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final finishDate = DateTime.now();
    final formattedDate =
        '${finishDate.day} ${_months[finishDate.month - 1]} ${finishDate.year}';

    return Scaffold(
      appBar: AppBar(
        title: const Text(' Evcil Hayvan Yürüyüşleri'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            color: Colors.green.shade600,
            child: const Text(
              'Yürüyüş Bilgileri Başarıyla Kaydedildi.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Tamamlanan Yürüyüşler',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(formattedDate),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: path.isNotEmpty
                              ? path.last
                              : const LatLng(41.0082, 28.9784),
                          zoom: 15,
                        ),
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId('completed_path'),
                            points: path,
                            width: 6,
                            color: Colors.deepPurple,
                          ),
                        },
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String formattedDate) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.orange.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.pets, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widgetPetNames(),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoColumn(Icons.timer, _formatDuration(duration)),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.shade300,
              ),
              _infoColumn(Icons.pets, '${distanceInKm.toStringAsFixed(2)} km'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(IconData icon, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.deepPurple),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  String widgetPetNames() {
    final names = selectedPets
        .map((pet) => pet['type'] as String? ?? '')
        .toList()
      ..removeWhere((element) => element.isEmpty);
    if (names.isEmpty) return 'Evcil Hayvanlar';
    return names.join(', ');
  }
}

const List<String> _months = [
  'Ocak',
  'Şubat',
  'Mart',
  'Nisan',
  'Mayıs',
  'Haziran',
  'Temmuz',
  'Ağustos',
  'Eylül',
  'Ekim',
  'Kasım',
  'Aralık',
];
