import 'dart:convert';

class RequestItem {
  final String petName;
  final String serviceName;
  final String userPhoto;
  final DateTime startDate;
  final DateTime endDate;
  final int dayDiff;
  final String note;
  final String location;

  RequestItem({
    required this.petName,
    required this.serviceName,
    required this.userPhoto,
    required this.startDate,
    required this.endDate,
    required this.dayDiff,
    required this.note,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'petName': petName,
        'serviceName': serviceName,
        'userPhoto': userPhoto,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'dayDiff': dayDiff,
        'note': note,
        'location': location,
      };

  factory RequestItem.fromJson(Map<String, dynamic> json) => RequestItem(
        petName: json['petName'],
        serviceName: json['serviceName'],
        userPhoto: json['userPhoto'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        dayDiff: json['dayDiff'],
        note: json['note'] ?? '',
        location: json['location'] ?? '',
      );

  static String encode(List<RequestItem> items) =>
      json.encode(items.map((e) => e.toJson()).toList());

  static List<RequestItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<RequestItem>((e) => RequestItem.fromJson(e))
          .toList();
}
