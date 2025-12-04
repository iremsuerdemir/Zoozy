import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoozy/screens/owner_login_page.dart';
import 'package:zoozy/screens/edit_profile.dart';
import 'package:zoozy/screens/password_forgot_screen.dart';
import 'package:zoozy/screens/terms_of_service_page.dart';
import 'package:zoozy/screens/privacy_policy_page.dart';

// Şifre değiştirme sayfası için bir geçici import ekliyorum.
// Gerçek uygulamanızda bu sayfayı oluşturmanız gerekecektir.
// import 'package:zoozy/screens/change_password_page.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const Color zoozyPurple = Color(0xFF9C27B0);
  static const Color zoozyGradientStart = Color(0xFFB39DDB);
  static const Color zoozyGradientEnd = Color(0xFFF48FB1);

  // 🔹 Oturumu kapatma
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, color: zoozyPurple, size: 50),
              SizedBox(height: 12),
              Text(
                'Oturumu kapatmak istediğine emin misin?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Giriş ekranına yönlendirileceksin.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () async {
                  // Dialog'u kapat
                  Navigator.of(dialogContext).pop();

                  print("LOGOUT: Oturum kapatma işlemi başlatılıyor...");
                  try {
                    // Firebase ve SharedPreferences temizle
                    await FirebaseAuth.instance.signOut();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    print(
                      "LOGOUT: Firebase oturumu kapatıldı ve SharedPreferences temizlendi.",
                    );

                    if (!context.mounted) return;

                    // Başarı mesajını göster
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Başarıyla çıkış yapıldı."),
                        backgroundColor: Colors.blueGrey,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(16),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    print("LOGOUT: OwnerLoginPage'e yönlendiriliyor.");
                    // Güvenilir yönlendirme
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const OwnerLoginPage()),
                      (route) => false,
                    );
                  } catch (e) {
                    print(
                      "LOGOUT ERROR: Çıkış yapılırken bir hata oluştu: ${e.toString()}",
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Çıkış hatası: ${e.toString()}"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Çıkış Yap',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Hesabı silme fonksiyonu (Güncellenmiş)
  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Hesabı Sil"),
        content: const Text(
          "Hesabınızı kalıcı olarak silmek istediğinize emin misiniz? Bu işlem geri alınamaz.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              // Önce onay diyalogunu kapat
              Navigator.pop(dialogContext);

              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                print("DELETE ERROR: Kullanıcı oturumu bulunamadı.");
                return;
              }
              print(
                "DELETE: Kullanıcı UID: ${user.uid} - Hesap silme işlemi başlatılıyor.",
              );

              try {
                // 🔸 Google hesabı, diğer sosyal medya veya anonim ise (tekrar şifre istemeye gerek yok)
                if (user.providerData.any(
                  (info) =>
                      info.providerId == 'google.com' ||
                      info.providerId == 'facebook.com' ||
                      info.providerId == 'twitter.com' ||
                      info.providerId == 'apple.com' ||
                      info.providerId == 'anonymous',
                )) {
                  print(
                    "DELETE: Google/Sosyal Medya/Anonim hesap. Direkt silme deneniyor.",
                  );
                  await user.delete();
                } else {
                  // 🔸 Email/şifre ile giriş yapan kullanıcılar için şifre doğrulama
                  print(
                    "DELETE: Email/Şifre hesabı. Şifre doğrulaması isteniyor.",
                  );
                  String? enteredPassword = await showDialog<String>(
                    context: context,
                    builder: (passwordDialogContext) {
                      final TextEditingController passwordController =
                          TextEditingController();
                      return AlertDialog(
                        title: const Text("Şifreyi Onayla"),
                        content: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Şifrenizi girin",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(passwordDialogContext, null),
                            child: const Text("İptal"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(
                              passwordDialogContext,
                              passwordController.text,
                            ),
                            child: const Text("Onayla"),
                          ),
                        ],
                      );
                    },
                  );

                  if (enteredPassword == null || enteredPassword.isEmpty) {
                    print(
                      "DELETE: Şifre doğrulama iptal edildi veya boş bırakıldı.",
                    );
                    return;
                  }

                  if (user.email == null) {
                    print(
                      "DELETE ERROR: Email/Şifre kullanıcısının e-posta adresi bulunamadı.",
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Hesap silinemedi. Lütfen tekrar giriş yapın.",
                          ),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16),
                        ),
                      );
                    }
                    return;
                  }

                  // Kimlik bilgileriyle yeniden oturum açma
                  final cred = EmailAuthProvider.credential(
                    email: user.email!,
                    password: enteredPassword,
                  );

                  print("DELETE: Kullanıcı yeniden kimliklendiriliyor...");
                  await user.reauthenticateWithCredential(cred);
                  print(
                    "DELETE: Yeniden kimliklendirme başarılı, hesap siliniyor...",
                  );
                  await user.delete();
                }

                // Hesap silme başarılı
                print("DELETE SUCCESS: Hesap başarıyla silindi.");

                // Hesap silindikten sonra SharedPreferences temizle
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                print("DELETE: SharedPreferences temizlendi.");

                if (!context.mounted) return;

                // 🔹 SnackBar'ı göster
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Hesabınız başarıyla silindi. Giriş sayfasına yönlendiriliyorsunuz.",
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(16),
                    duration: Duration(seconds: 3),
                  ),
                );

                // 🔹 Yönlendirmeyi yap
                print("DELETE: OwnerLoginPage'e yönlendiriliyor.");
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const OwnerLoginPage()),
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                String errorMessage = "";
                print(
                  "DELETE ERROR: FirebaseAuthException - Code: ${e.code}, Message: ${e.message}",
                ); // ⬅️ DEBUG LOG

                if (e.code == 'wrong-password' ||
                    e.code == 'invalid-credential') {
                  errorMessage =
                      "Girdiğiniz şifre yanlış. Lütfen tekrar deneyin.";
                } else if (e.code == 'requires-recent-login') {
                  errorMessage =
                      "Hesabınızı silebilmek için yeniden giriş yapmanız gerekiyor (Çok kısa süre önce giriş yapmalısınız).";
                } else if (e.code == 'user-not-found') {
                  errorMessage =
                      "Kullanıcı bulunamadı. Lütfen tekrar giriş yapın.";
                } else {
                  errorMessage = "Hesap silinemedi: ${e.message}";
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                }
              } catch (e) {
                print(
                  "DELETE ERROR: Beklenmedik bir hata oluştu: ${e.toString()}",
                ); // ⬅️ DEBUG LOG
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Beklenmedik bir hata oluştu: ${e.toString()}",
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 145, 34, 165),
            ),
            child: const Text("Sil", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 🔹 Ayar satırını oluşturan widget
  Widget _buildSettingRow(String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
      ],
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
                colors: [zoozyGradientStart, zoozyGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
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
                      const Text(
                        'Hesap Ayarları',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double maxWidth = math
                          .min(constraints.maxWidth * 0.9, 900)
                          .toDouble();

                      return Center(
                        child: Container(
                          width: maxWidth,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
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
                                const SizedBox(height: 6),
                                const Text(
                                  " HESAP",
                                  style: TextStyle(
                                    color: zoozyPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildSettingRow(
                                  "Profili Düzenle",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const EditProfileScreen(),
                                      ),
                                    );
                                  },
                                ),
                                // Şifreyi Değiştir için onTap eklendi
                                _buildSettingRow(
                                  "Şifreyi Değiştir",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PasswordForgotScreen(),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 20),
                                const Text(
                                  " HUKUKİ",
                                  style: TextStyle(
                                    color: zoozyPurple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildSettingRow(
                                  "Hizmet Şartları",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const TermsOfServicePage(
                                              isForApproval: false,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                                _buildSettingRow(
                                  "Gizlilik Politikası",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const PrivacyPolicyPage(
                                          isModal: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                // Oturumu Kapat butonu
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF9C27B0),
                                        Color(0xFF7B1FA2),
                                      ],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () => _showLogoutDialog(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      minimumSize: const Size.fromHeight(50),
                                      padding:
                                          EdgeInsets.zero, // Padding'i kaldırır
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Oturumu Kapat",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Hesabı Sil butonu
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(
                                          255,
                                          239,
                                          83,
                                          80,
                                        ), // Kırmızımsı başlangıç
                                        Color.fromARGB(
                                          255,
                                          211,
                                          47,
                                          47,
                                        ), // Kırmızımsı bitiş
                                      ],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _showDeleteAccountDialog(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      minimumSize: const Size.fromHeight(50),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Hesabı Sil",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
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
