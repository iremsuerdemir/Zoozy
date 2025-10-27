import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zoozy/screens/my_cities_page.dart';

class ServiceDatePage extends StatefulWidget {
  final String petName;
  const ServiceDatePage({super.key, required this.petName});

  @override
  State<ServiceDatePage> createState() => _ServiceDatePageState();
}

class _ServiceDatePageState extends State<ServiceDatePage> {
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  bool _isStartSelected = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null);
  }

  void _onNext() {
    if (_isStartSelected) {
      if (_startDate != null && _startTime != null) {
        setState(() {
          _isStartSelected = false; // Bitiş seçimine geç
        });
      }
    } else {
      if (_endDate != null && _endTime != null) {
        // Hem başlangıç hem bitiş alındı → MyCitiesPage sayfasına git
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCitiesPage(),
            settings: RouteSettings(
              arguments: {
                'petName': widget.petName,
                'serviceName': args?['serviceName'] ?? '',
                'startDate': _startDate,
                'startTime': _startTime,
                'endDate': _endDate,
                'endTime': _endTime,
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('tr', 'TR'),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9B86B3),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (_isStartSelected) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF9B86B3),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (_isStartSelected) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonActive = _isStartSelected
        ? (_startDate != null && _startTime != null)
        : (_endDate != null && _endTime != null);

    String title = _isStartSelected
        ? 'Hizmet başlangıç tarihini ve saatini seçiniz.'
        : 'Hizmet bitiş tarihini ve saatini seçiniz.';

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB39DDB), Color(0xFFF48FB1)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Üst bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Flexible(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Kart
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth =
                          math.min(constraints.maxWidth * 0.9, 800);
                      return Center(
                        child: Container(
                          width: maxWidth,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 24),
                              GestureDetector(
                                onTap: _pickDate,
                                child: _buildPickerBox(
                                  icon: Icons.calendar_today_rounded,
                                  text: _isStartSelected
                                      ? (_startDate == null
                                          ? "Tarih seçin"
                                          : DateFormat('d MMMM yyyy', 'tr_TR')
                                              .format(_startDate!))
                                      : (_endDate == null
                                          ? "Tarih seçin"
                                          : DateFormat('d MMMM yyyy', 'tr_TR')
                                              .format(_endDate!)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: _pickTime,
                                child: _buildPickerBox(
                                  icon: Icons.access_time_rounded,
                                  text: _isStartSelected
                                      ? (_startTime == null
                                          ? "Saat seçin"
                                          : _startTime!.format(context))
                                      : (_endTime == null
                                          ? "Saat seçin"
                                          : _endTime!.format(context)),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: isButtonActive ? _onNext : null,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isButtonActive
                                          ? [
                                              Colors.purple,
                                              Colors.deepPurpleAccent
                                            ]
                                          : [
                                              Colors.grey.shade400,
                                              Colors.grey.shade300
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "İleri",
                                      style: TextStyle(
                                        color: isButtonActive
                                            ? Colors.white
                                            : Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerBox({required IconData icon, required String text}) {
    const Color primaryPurple = Color(0xFF9B86B3);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: text.contains("seçin") ? Colors.grey[500] : Colors.black,
            ),
          ),
          Icon(icon, color: primaryPurple),
        ],
      ),
    );
  }
}
