import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ConfirmPhoneScreen extends StatefulWidget {
  const ConfirmPhoneScreen({super.key});

  @override
  State<ConfirmPhoneScreen> createState() => _ConfirmPhoneScreenState();
}

class _ConfirmPhoneScreenState extends State<ConfirmPhoneScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String countryCode = 'TR';
  String fullPhoneNumber = '';
  bool isPhoneValid = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? _verificationId;
  bool codeSent = false;
  bool isLoading = false;

  static const Color purpleButtonColor = Color(0xFF8E6FB4);
  static const Color lightPurpleButtonColor = Color(0xFFD4C7E6);

  Future<void> _sendOtp() async {
    if (!isPhoneValid || fullPhoneNumber.isEmpty) {
      _showError("Lütfen geçerli bir telefon numarası girin.");
      return;
    }

    setState(() => isLoading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _showSuccess();
        setState(() => isLoading = false);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => isLoading = false);
        String errorMessage = "Doğrulama başarısız! Hata Kodu: ${e.code}";
        if (e.code == 'invalid-phone-number') {
          errorMessage = "Geçersiz telefon numarası. Lütfen kontrol edin.";
        } else if (e.code == 'quota-exceeded') {
          errorMessage = "SMS kotası aşıldı. Lütfen daha sonra tekrar deneyin.";
        } else if (e.code == 'app-not-authorized') {
          errorMessage =
              "Giriş sağlayıcısı etkin değil. Lütfen Firebase konsolunu kontrol edin.";
        } else if (e.message != null &&
            e.message!.contains('disabled for this Firebase project')) {
          errorMessage =
              "Telefon giriş yöntemi Firebase projenizde etkinleştirilmemiş.";
        }
        _showError(errorMessage);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          codeSent = true;
          isLoading = false;
        });
        _showInfo("Doğrulama kodu telefonunuza gönderildi.");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> _verifyOtp() async {
    if (otpController.text.trim().length != 6) {
      _showError("Lütfen 6 haneli doğrulama kodunu girin.");
      return;
    }
    if (_verificationId == null) {
      _showError("SMS kodu gönderilmedi. Lütfen tekrar deneyin.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpController.text.trim(),
      );

      await _auth.signInWithCredential(credential);
      setState(() => isLoading = false);
      _showSuccess();
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      String errorMessage = "Kod doğrulanamadı. Hata: ${e.code}";
      if (e.code == 'invalid-verification-code') {
        errorMessage = "Yanlış kod. Lütfen kodu kontrol edip tekrar deneyin.";
      }
      _showError(errorMessage);
    } catch (e) {
      setState(() => isLoading = false);
      _showError("Bir hata oluştu: ${e.toString()}");
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Başarılı!"),
        content: const Text("Telefon numaranız doğrulandı."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  void _showInfo(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bilgi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hata"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Telefon Doğrulama',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxContentWidth = math.min(
                        constraints.maxWidth * 0.9,
                        600,
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Anlık Bildirimleri Telefonunuzda Alın',
                                style: TextStyle(
                                  fontSize: fontSize + 4,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Numaranız gizli tutulur ve sadece doğrulama için kullanılır.',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              const SizedBox(height: 32),
                              if (!codeSent)
                                IntlPhoneField(
                                  controller: phoneController,
                                  initialCountryCode: countryCode,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Telefon',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (phone) {
                                    fullPhoneNumber = phone.completeNumber;
                                    setState(() {
                                      isPhoneValid =
                                          phone.number.length >=
                                          10; // Basit kontrol
                                    });
                                  },
                                  onCountryChanged: (country) {
                                    countryCode = country.code;
                                  },
                                )
                              else
                                TextFormField(
                                  controller: otpController,
                                  decoration: const InputDecoration(
                                    hintText: 'Doğrulama Kodunu Girin (6 Hane)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(fontSize: fontSize),
                                ),
                              const SizedBox(height: 32),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      isLoading || (!codeSent && !isPhoneValid)
                                      ? null
                                      : () {
                                          if (!codeSent) {
                                            _sendOtp();
                                          } else {
                                            _verifyOtp();
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: codeSent || isPhoneValid
                                        ? purpleButtonColor
                                        : lightPurpleButtonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          codeSent
                                              ? 'KODU DOĞRULA'
                                              : 'BANA SMS GÖNDER',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
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
}
