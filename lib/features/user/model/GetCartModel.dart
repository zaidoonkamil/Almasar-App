import 'dart:convert';

List<GetCartModel> getCartModelFromJson(String str) => List<GetCartModel>.from(json.decode(str).map((x) => GetCartModel.fromJson(x)));

String getCartModelToJson(List<GetCartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCartModel {
  int id;
  int userId;
  int productId;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;
  Productt productt;

  GetCartModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.productt,
  });

  factory GetCartModel.fromJson(Map<String, dynamic> json) => GetCartModel(
    id: json["id"],
    userId: json["userId"],
    productId: json["productId"],
    quantity: json["quantity"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    productt: Productt.fromJson(json["Product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "productId": productId,
    "quantity": quantity,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "Product": productt.toJson(),
  };
}

class Productt {
  int id;
  String title;
  String description;
  int price;
  List<String> images;
  int vendorId;
  DateTime createdAt;
  DateTime updatedAt;

  Productt({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Productt.fromJson(Map<String, dynamic> json) => Productt(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    price: json["price"],
    images: List<String>.from(json["images"].map((x) => x)),
    vendorId: json["vendorId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "images": List<dynamic>.from(images.map((x) => x)),
    "vendorId": vendorId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
