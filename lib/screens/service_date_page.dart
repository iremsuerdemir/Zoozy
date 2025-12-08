import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zoozy/screens/grooming_service_page.dart';
import 'package:zoozy/screens/my_cities_page.dart';
import 'package:zoozy/screens/visit_type_page.dart';

class ServiceDatePage extends StatefulWidget {
  final String petName;
  final String serviceName;
  const ServiceDatePage({
    super.key,
    required this.petName,
    required this.serviceName,
  });

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
    /// -------- TAKSİ -------- ///
    if (widget.serviceName == "Taksi") {
      if (_startDate != null && _startTime != null) {
        _isStartSelected = true;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCitiesPage(),
            settings: RouteSettings(
              arguments: {
                'petName': widget.petName,
                'serviceName': widget.serviceName,
                'startDate': _startDate,
                'startTime': _startTime,
                'endDate': null,
                'endTime': null,
              },
            ),
          ),
        );
      }
      return;
    }

    /// -------- EVDE BAKIM -------- ///
    if (widget.serviceName == "Evde Bakım") {
      if (_isStartSelected) {
        if (_startDate != null && _startTime != null) {
          setState(() => _isStartSelected = false);
        }
      } else {
        if (_endDate != null && _endTime != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VisitTypePage(
                petName: widget.petName,
                serviceName: widget.serviceName,
              ),
               settings: RouteSettings(
              arguments: {
                'petName': widget.petName,
                'serviceName': widget.serviceName,
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
      return;
    }

    //---------BAKIM-------------///
    if (widget.serviceName == "Bakım") {
      if (_isStartSelected) {
        if (_startDate != null && _startTime != null) {
          setState(() => _isStartSelected = false);
        }
      } else {
        if (_endDate != null && _endTime != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroomingServicePage(
                petName: widget.petName,
                serviceName: widget.serviceName,
              )
              ,
               settings: RouteSettings(
              arguments: {
                'petName': widget.petName,
                'serviceName': widget.serviceName,
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
      return;
    }

    /// -------- DİĞER SERVİSLER -------- ///
    if (_isStartSelected) {
      if (_startDate != null && _startTime != null) {
        setState(() => _isStartSelected = false);
      }
    } else {
      if (_endDate != null && _endTime != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCitiesPage(),
            settings: RouteSettings(
              arguments: {
                'petName': widget.petName,
                'serviceName': widget.serviceName,
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
    DateTime initialDate =
        _isStartSelected || widget.serviceName == "Taksi"
            ? DateTime.now()
            : (_startDate ?? DateTime.now());

    DateTime firstDate =
        _isStartSelected || widget.serviceName == "Taksi"
            ? DateTime.now()
            : (_startDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('tr', 'TR'),
      initialDate: initialDate,
      firstDate: firstDate,
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
        if (_isStartSelected || widget.serviceName == "Taksi") {
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

    if (picked == null) return;

    /// -------- DOĞRU SAAT DOĞRULAMASI (Taksi hariç) -------- ///
    if (widget.serviceName != "Taksi" &&
        !_isStartSelected &&
        _startDate != null &&
        _endDate != null) {
      
      bool sameDay =
          _startDate!.year == _endDate!.year &&
          _startDate!.month == _endDate!.month &&
          _startDate!.day == _endDate!.day;

      if (sameDay && _startTime != null) {
        int startMin = _startTime!.hour * 60 + _startTime!.minute;
        int endMin = picked.hour * 60 + picked.minute;

        if (endMin < startMin + 60) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Aynı gün için bitiş saati, başlangıç saatinden en az 1 saat sonra olmalıdır.",
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          return; // seçimi iptal et
        }
      }
    }

    setState(() {
      if (_isStartSelected || widget.serviceName == "Taksi") {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showEndSection = widget.serviceName != "Taksi" && !_isStartSelected;

    bool isButtonActive = widget.serviceName == "Taksi"
        ? (_startDate != null && _startTime != null)
        : (_isStartSelected
            ? (_startDate != null && _startTime != null)
            : (_endDate != null && _endTime != null));

    String title = widget.serviceName == "Taksi"
        ? "Taksi hizmeti için tarih ve saat seçiniz."
        : (_isStartSelected
            ? "Hizmet başlangıç tarihini ve saatini seçiniz."
            : "Hizmet bitiş tarihini ve saatini seçiniz.");

    String buttonText = widget.serviceName == "Taksi" || !_isStartSelected
        ? "Devam Et"
        : "İleri";

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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
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

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth = math.min(
                        constraints.maxWidth * 0.9,
                        800,
                      );

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
                            children: [
                              const SizedBox(height: 24),

                              GestureDetector(
                                onTap: _pickDate,
                                child: _buildPickerBox(
                                  icon: Icons.calendar_today_rounded,
                                  text: _startDate == null
                                      ? "Tarih seçin"
                                      : DateFormat('d MMMM yyyy', 'tr_TR')
                                          .format(_startDate!),
                                ),
                              ),
                              const SizedBox(height: 16),

                              GestureDetector(
                                onTap: _pickTime,
                                child: _buildPickerBox(
                                  icon: Icons.access_time_rounded,
                                  text: _startTime == null
                                      ? "Saat seçin"
                                      : _startTime!.format(context),
                                ),
                              ),

                              if (showEndSection) ...[
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: _pickDate,
                                  child: _buildPickerBox(
                                    icon: Icons.calendar_today_rounded,
                                    text: _endDate == null
                                        ? "Bitiş tarihi seçin"
                                        : DateFormat('d MMMM yyyy', 'tr_TR')
                                            .format(_endDate!),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: _pickTime,
                                  child: _buildPickerBox(
                                    icon: Icons.access_time_rounded,
                                    text: _endTime == null
                                        ? "Bitiş saati seçin"
                                        : _endTime!.format(context),
                                  ),
                                ),
                              ],

                              const Spacer(),

                              GestureDetector(
                                onTap: isButtonActive ? _onNext : null,
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isButtonActive
                                          ? [
                                              Colors.purple,
                                              Colors.deepPurpleAccent,
                                            ]
                                          : [
                                              Colors.grey.shade400,
                                              Colors.grey.shade300,
                                            ],
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      buttonText,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerBox({
    required IconData icon,
    required String text,
  }) {
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
              color: text.contains("seçin")
                  ? Colors.grey[500]
                  : Colors.black,
            ),
          ),
          Icon(icon, color: primaryPurple),
        ],
      ),
    );
  }
}
