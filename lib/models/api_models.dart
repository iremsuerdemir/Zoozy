import 'package:collection/collection.dart';

class PetProfileModel {
  const PetProfileModel({
    required this.id,
    required this.firebaseId,
    required this.name,
    required this.species,
    this.breed,
    this.age,
    this.vaccinationStatus,
    this.healthNotes,
    required this.ownerName,
    required this.ownerContact,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String firebaseId;
  final String name;
  final String species;
  final String? breed;
  final int? age;
  final String? vaccinationStatus;
  final String? healthNotes;
  final String ownerName;
  final String ownerContact;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory PetProfileModel.fromJson(Map<String, dynamic> json) =>
      PetProfileModel(
        id: json['id'] as String,
        firebaseId: json['firebaseId'] as String? ?? '',
        name: json['name'] as String? ?? '',
        species: json['species'] as String? ?? '',
        breed: json['breed'] as String?,
        age: json['age'] as int?,
        vaccinationStatus: json['vaccinationStatus'] as String?,
        healthNotes: json['healthNotes'] as String?,
        ownerName: json['ownerName'] as String? ?? '',
        ownerContact: json['ownerContact'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
      );
}

class ServiceProviderModel {
  const ServiceProviderModel({
    required this.id,
    required this.firebaseId,
    required this.name,
    required this.serviceType,
    this.description,
    required this.location,
    this.contactInfo,
    this.rating,
    required this.offersLiveTracking,
    required this.offersVideoCall,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String firebaseId;
  final String name;
  final String serviceType;
  final String? description;
  final String location;
  final String? contactInfo;
  final double? rating;
  final bool offersLiveTracking;
  final bool offersVideoCall;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) =>
      ServiceProviderModel(
        id: json['id'] as String,
        firebaseId: json['firebaseId'] as String? ?? '',
        name: json['name'] as String? ?? '',
        serviceType: json['serviceType'] as String? ?? '',
        description: json['description'] as String?,
        location: json['location'] as String? ?? '',
        contactInfo: json['contactInfo'] as String?,
        rating: (json['rating'] as num?)?.toDouble(),
        offersLiveTracking: json['offersLiveTracking'] as bool? ?? false,
        offersVideoCall: json['offersVideoCall'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
      );
}

class ServiceRequestModel {
  const ServiceRequestModel({
    required this.id,
    required this.firebaseId,
    required this.petProfileId,
    required this.serviceProviderId,
    required this.serviceType,
    required this.preferredDate,
    required this.status,
    this.notes,
    this.liveTrackingUrl,
    required this.videoCallEnabled,
    required this.createdAt,
    required this.updatedAt,
    this.petProfile,
    this.serviceProvider,
  });

  final String id;
  final String firebaseId;
  final String petProfileId;
  final String serviceProviderId;
  final String serviceType;
  final DateTime preferredDate;
  final String status;
  final String? notes;
  final String? liveTrackingUrl;
  final bool videoCallEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PetProfileModel? petProfile;
  final ServiceProviderModel? serviceProvider;

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      ServiceRequestModel(
        id: json['id'] as String,
        firebaseId: json['firebaseId'] as String? ?? '',
        petProfileId: json['petProfileId'] as String? ?? '',
        serviceProviderId: json['serviceProviderId'] as String? ?? '',
        serviceType: json['serviceType'] as String? ?? '',
        preferredDate:
            DateTime.tryParse(json['preferredDate'] as String? ?? '') ??
                DateTime.now().toUtc(),
        status: json['status'] as String? ?? '',
        notes: json['notes'] as String?,
        liveTrackingUrl: json['liveTrackingUrl'] as String?,
        videoCallEnabled: json['videoCallEnabled'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
        petProfile: json['petProfile'] is Map<String, dynamic>
            ? PetProfileModel.fromJson(
                json['petProfile'] as Map<String, dynamic>)
            : null,
        serviceProvider: json['serviceProvider'] is Map<String, dynamic>
            ? ServiceProviderModel.fromJson(
                json['serviceProvider'] as Map<String, dynamic>)
            : null,
      );
}

class FirebaseSyncResultModel {
  const FirebaseSyncResultModel({
    required this.petsCreated,
    required this.petsUpdated,
    required this.providersCreated,
    required this.providersUpdated,
    required this.requestsCreated,
    required this.requestsUpdated,
    required this.syncedAt,
  });

  final int petsCreated;
  final int petsUpdated;
  final int providersCreated;
  final int providersUpdated;
  final int requestsCreated;
  final int requestsUpdated;
  final DateTime syncedAt;

  int get totalChanges =>
      petsCreated +
      petsUpdated +
      providersCreated +
      providersUpdated +
      requestsCreated +
      requestsUpdated;

  factory FirebaseSyncResultModel.fromJson(Map<String, dynamic> json) =>
      FirebaseSyncResultModel(
        petsCreated: json['petsCreated'] as int? ?? 0,
        petsUpdated: json['petsUpdated'] as int? ?? 0,
        providersCreated: json['providersCreated'] as int? ?? 0,
        providersUpdated: json['providersUpdated'] as int? ?? 0,
        requestsCreated: json['requestsCreated'] as int? ?? 0,
        requestsUpdated: json['requestsUpdated'] as int? ?? 0,
        syncedAt: DateTime.tryParse(json['syncedAt'] as String? ?? '') ??
            DateTime.now().toUtc(),
      );
}

class ApiDashboardData {
  const ApiDashboardData({
    required this.pets,
    required this.providers,
    required this.requests,
  });

  final List<PetProfileModel> pets;
  final List<ServiceProviderModel> providers;
  final List<ServiceRequestModel> requests;

  int get activeRequestCount => requests
      .where((request) => !(request.status.toLowerCase() == 'tamamlandı' ||
          request.status.toLowerCase() == 'completed'))
      .length;

  DateTime? get latestSyncTime => requests
      .map((request) => request.updatedAt)
      .sorted((a, b) => b.compareTo(a))
      .firstOrNull;
}
