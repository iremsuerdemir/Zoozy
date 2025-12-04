import 'package:flutter/material.dart';

class ServiceProvider extends ChangeNotifier {
  /// Yeni sistem – tüm servis kartları burada tutulur
  List<Map<String, dynamic>> services = [];

  /// Geçici servis bilgileri (AddService → Describe → Rate → Location)
  Map<String, dynamic> tempServiceDetails = {};

  /// Eski sistemden gelen alanlar (HATA almaman için geri eklendi)
  String selectedServiceName = "";
  String fullAddress = "";

  /// -----------------------------
  ///  GEÇİCİ SERVİS BİLGİLERİ
  /// -----------------------------
  void setTempServiceDetails(Map<String, dynamic> details) {
    tempServiceDetails.addAll(details);
    notifyListeners();
  }

  /// AddLocation’dan gelen final adım
  void finalizeService(String address) {
    fullAddress = address;
    tempServiceDetails["address"] = address;

    services.add({
      "serviceName": tempServiceDetails["serviceName"] ?? selectedServiceName,
      "serviceIcon": tempServiceDetails["serviceIcon"],
      "price": tempServiceDetails["price"],
      "description": tempServiceDetails["description"],
      "address": address,
    });

    tempServiceDetails = {};
    notifyListeners();
  }

  /// -----------------------------
  ///   ESKİ METOTLAR – KULLANDIĞIN EKRANLAR İÇİN EKLENDİ
  /// -----------------------------

  void setService(String name) {
    selectedServiceName = name;

    /// Yeni sisteme de otomatik ekleyelim
    tempServiceDetails["serviceName"] = name;

    notifyListeners();
  }

  void setAddress(String address) {
    fullAddress = address;

    /// Yeni sisteme de ekleyelim
    tempServiceDetails["address"] = address;

    notifyListeners();
  }

  /// Eski addService çağrıları bozulmasın diye bıraktım
  void addService(String name, String address) {
    services.add({
      "serviceName": name,
      "address": address,
    });
    notifyListeners();
  }

  /// Servis sil
  void removeService(int index) {
    if (index >= 0 && index < services.length) {
      services.removeAt(index);
      notifyListeners();
    }
  }

  /// Hepsini temizle
  void clearAll() {
    services.clear();
    selectedServiceName = "";
    fullAddress = "";
    tempServiceDetails = {};
    notifyListeners();
  }
}
