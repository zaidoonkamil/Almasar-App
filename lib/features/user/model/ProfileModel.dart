import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int id;
  String name;
  String phone;
  bool isActive;
  String location;
  DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.location,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    isActive: json["isActive"],
    location: json["location"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "isActive": isActive,
    "location": location,
    "createdAt": createdAt.toIso8601String(),
  };

  ProfileModel copyWith({
    int? id,
    String? name,
    String? phone,
    bool? isActive,
    String? location,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

}
