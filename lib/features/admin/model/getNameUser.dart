import 'dart:convert';

List<GetNameUser> getNameUserFromJson(String str) =>
    List<GetNameUser>.from(json.decode(str).map((x) => GetNameUser.fromJson(x)));

String getNameUserToJson(List<GetNameUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetNameUser {
  int id;
  String name;
  String phone;
  String location;
  bool isActive;
  List<String> images;
  int sponsorshipAmount;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  GetNameUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.isActive,
    this.images = const [],
    this.sponsorshipAmount = 0,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetNameUser.fromJson(Map<String, dynamic> json) => GetNameUser(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    location: json["location"],
    isActive: json["isActive"],
    images: json["images"] != null
        ? List<String>.from(json["images"].map((x) => x))
        : [],
    sponsorshipAmount: json["sponsorshipAmount"] ?? 0,
    role: json["role"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "location": location,
    "isActive": isActive,
    "images": List<dynamic>.from(images.map((x) => x)),
    "sponsorshipAmount": sponsorshipAmount,
    "role": role,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
