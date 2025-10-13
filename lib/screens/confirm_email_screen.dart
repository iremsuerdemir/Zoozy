import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:zoozy/screens/my_badgets_screen.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String email;
  const ConfirmEmailScreen({super.key, required this.email});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _message = 'E-posta adresinizi doğrulamanız gereklidir.';

  Timer? _countdownTimer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _setupDynamicLinks();

    final user = _auth.currentUser;
    if (user == null) {
      _message = 'Kullanıcı oturumu alınamadı. Lütfen tekrar giriş yapın.';
    } else {
      _message =
          'E-posta adresinizi doğrulamak için doğrulama mailini kontrol edin.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _navigateToBadgetsScreen() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyBadgetsScreen()),
      );
    });
  }

  void _setupDynamicLinks() async {
    // Uygulama açıkken
    FirebaseDynamicLinks.instance.onLink
        .listen((linkData) async {
          final Uri deepLink = linkData.link;
          if (deepLink.queryParameters['mode'] == 'verifyEmail') {
            final user = _auth.currentUser;
            if (user != null) {
              await user.reload();
              final updatedUser = _auth.currentUser;
              if (updatedUser != null && updatedUser.emailVerified) {
                if (!mounted) return;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Doğrulama başarılı! Yönlendiriliyorsunuz...',
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  _navigateToBadgetsScreen();
                });
              }
            }
          }
        })
        .onError((error) {
          print('Dynamic link error: $error');
        });

    // Uygulama kapalı veya arka planda iken
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks
        .instance
        .getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      if (deepLink.queryParameters['mode'] == 'verifyEmail') {
        final user = _auth.currentUser;
        if (user != null) {
          await user.reload();
          final updatedUser = _auth.currentUser;
          if (updatedUser != null && updatedUser.emailVerified) {
            if (!mounted) return;
            _navigateToBadgetsScreen();
          }
        }
      }
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _remainingSeconds = 150;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  Future<void> _sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() {
        _message = 'Kullanıcı oturumu alınamadı.';
      });
      return;
    }

    if (_emailController.text.trim() != user.email) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen giriş yaptığınız mail adresini girin.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      });
      return;
    }

    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
        _message = 'Doğrulama e-postası gönderiliyor...';
      });

      await user.sendEmailVerification();
      await user.reload();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _message =
            'Doğrulama e-postası **${_emailController.text}** adresine gönderildi. Mail kutunuzu kontrol edin ve linke tıklayın.';
      });

      _startCountdown();
      _showSpamCheckSnackbar();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _message = 'E-posta gönderilemedi. Lütfen tekrar deneyin.';
      });
    }
  }

  void _showSpamCheckSnackbar() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unutmayın: Lütfen gereksiz/spam klasörünüzü de kontrol edin!',
          ),
          duration: Duration(seconds: 4),
          backgroundColor: Color.fromARGB(255, 11, 146, 17),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color purpleStart = Color(0xFFB39DDB);
    const Color pinkEnd = Color(0xFFF48FB1);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxContentWidth = math.min(screenWidth * 0.9, 400);

    String formatTime(int seconds) {
      final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
      final secs = (seconds % 60).toString().padLeft(2, '0');
      return '$minutes:$secs';
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [purpleStart, pinkEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
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
                    const Spacer(),
                    const Text(
                      'E-postanı Doğrula',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: maxContentWidth,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            spreadRadius: 3,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Center(
                            child: Icon(
                              Icons.mail_outline,
                              size: 80,
                              color: Color(0xFFB39DDB),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            _message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.6,
                            ),
                          ),
                          if (_remainingSeconds > 0) ...[
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                'Tekrar göndermek için kalan süre: ${formatTime(_remainingSeconds)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          const Text(
                            'Lütfen doğrulama e-postası için gereksiz/spam klasörünü de kontrol edin.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'example@mail.com',
                              labelText: 'E-posta Adresi',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFB39DDB),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 15,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFB39DDB),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: _sendVerificationEmail,
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.purple,
                                          Colors.deepPurpleAccent,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.purpleAccent
                                              .withOpacity(0.5),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "DOĞRULAMA MAILİ GÖNDER",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
