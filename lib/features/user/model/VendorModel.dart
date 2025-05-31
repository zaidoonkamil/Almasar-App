import 'dart:convert';

VendorModel vendorModelFromJson(String str) => VendorModel.fromJson(json.decode(str));

String vendorModelToJson(VendorModel data) => json.encode(data.toJson());

class VendorModel {
  List<Datum> data;
  PaginationVendor paginationVendor;

  VendorModel({
    required this.data,
    required this.paginationVendor,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    paginationVendor: PaginationVendor.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pagination": paginationVendor.toJson(),
  };
}

class Datum {
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

  Datum({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.isActive,
    required this.images,
    required this.sponsorshipAmount,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    location: json["location"],
    isActive: json["isActive"],
    images: List<String>.from(json["images"].map((x) => x)),
    sponsorshipAmount: json["sponsorshipAmount"],
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

class PaginationVendor {
  int totalItems;
  int totalPages;
  int currentPage;

  PaginationVendor({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });

  factory PaginationVendor.fromJson(Map<String, dynamic> json) => PaginationVendor(
    totalItems: json["totalItems"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalItems": totalItems,
    "totalPages": totalPages,
    "currentPage": currentPage,
  };
}
