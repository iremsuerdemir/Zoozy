import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestAccessService {
  static const String _guestKey = 'is_guest_user';

  static Future<void> enableGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, true);
  }

  static Future<void> disableGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestKey, false);
  }

  static Future<bool> isGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guestKey) ?? false;
  }

  static Future<bool> ensureLoggedIn(BuildContext context) async {
    if (!await isGuest()) {
      return true;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lütfen giriş yapınız.'),
        duration: Duration(seconds: 2),
      ),
    );
    return false;
  }
}

