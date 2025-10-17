import 'dart:math' as math;

import 'package:flutter/material.dart';

class SupportRequestPage extends StatefulWidget {
  const SupportRequestPage({super.key});

  @override
  State<SupportRequestPage> createState() => _SupportRequestPageState();
}

class _SupportRequestPageState extends State<SupportRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  // 1️⃣ Arka plan (gradient)
  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB39DDB), // Açık mor
            Color(0xFFF48FB1), // Açık pembe
          ],
        ),
      ),
    );
  }

  // 2️⃣ Üst başlık
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Destek Talebi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // 3️⃣ Form alanı
  Widget _buildSupportForm(double fontSize) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _subjectController,
            decoration: InputDecoration(
              labelText: 'Konu',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            validator: (value) =>
                value!.isEmpty ? 'Lütfen bir konu girin' : null,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
              labelText: 'Mesajınız',
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            maxLines: 6,
            validator: (value) =>
                value!.isEmpty ? 'Lütfen mesajınızı yazın' : null,
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _isSending
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isSending = true);

                      await Future.delayed(
                        const Duration(seconds: 1),
                      ); // Sahte bekleme

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Destek talebiniz gönderildi ✅'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }

                      _subjectController.clear();
                      _messageController.clear();
                      setState(() => _isSending = false);
                    }
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isSending
                      ? [Colors.grey.shade400, Colors.grey.shade300]
                      : [Colors.purple, Colors.deepPurpleAccent],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  if (!_isSending)
                    const BoxShadow(
                      color: Colors.purpleAccent,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  _isSending ? "Gönderiliyor..." : "Gönder",
                  style: TextStyle(
                    color: _isSending ? Colors.black54 : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4️⃣ İçerik kartı (responsive tasarım)
  Widget _buildContentBody() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double maxContentWidth = math.min(
            constraints.maxWidth * 0.9,
            900,
          );
          final double fontSize = constraints.maxWidth > 1000
              ? 18
              : (constraints.maxWidth < 360 ? 14 : 16);

          return Center(
            child: Container(
              width: maxContentWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yardım mı gerekiyor?',
                      style: TextStyle(
                        fontSize: fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Aşağıdaki formu doldurarak ekibimizle iletişime geçebilirsin. '
                      'Sorununla ilgili mümkün olan en kısa sürede geri dönüş yapılacaktır.',
                      style: TextStyle(
                        fontSize: fontSize - 1,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSupportForm(fontSize),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 5️⃣ Ana yapı
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildContentBody(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
