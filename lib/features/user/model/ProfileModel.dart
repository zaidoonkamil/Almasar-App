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
  List<String> images;

  ProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.location,
    required this.createdAt,
    required this.images,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    isActive: json["isActive"],
    images: List<String>.from(json["images"].map((x) => x)),
    location: json["location"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "isActive": isActive,
    "images": List<dynamic>.from(images.map((x) => x)),
    "location": location,
    "createdAt": createdAt.toIso8601String(),
  };

  ProfileModel copyWith({
    int? id,
    String? name,
    String? phone,
    bool? isActive,
    List<String>? images,
    String? location,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      images: images ?? this.images,
      isActive: isActive ?? this.isActive,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
    );
  }

}
