import 'dart:convert';

List<GetActiveDeliveryModel> getActiveDeliveryModelFromJson(String str) => List<GetActiveDeliveryModel>.from(json.decode(str).map((x) => GetActiveDeliveryModel.fromJson(x)));

String getActiveDeliveryModelToJson(List<GetActiveDeliveryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetActiveDeliveryModel {
  int id;
  String name;
  String phone;
  String location;
  bool isActive;
  String role;
  DateTime updatedAt;

  GetActiveDeliveryModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.isActive,
    required this.role,
    required this.updatedAt,
  });

  factory GetActiveDeliveryModel.fromJson(Map<String, dynamic> json) => GetActiveDeliveryModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    location: json["location"],
    isActive: json["isActive"],
    role: json["role"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "location": location,
    "isActive": isActive,
    "role": role,
    "updatedAt": updatedAt.toIso8601String(),
  };
}
