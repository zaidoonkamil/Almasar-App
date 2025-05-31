import 'dart:convert';

GetProductsModel getProductsModelFromJson(String str) => GetProductsModel.fromJson(json.decode(str));

String getProductsModelToJson(GetProductsModel data) => json.encode(data.toJson());

class GetProductsModel {
  Paginations pagination;
  List<Products> products;

  GetProductsModel({
    required this.pagination,
    required this.products,
  });

  factory GetProductsModel.fromJson(Map<String, dynamic> json) => GetProductsModel(
    pagination: Paginations.fromJson({
      "totalProducts": json["totalProducts"],
      "totalPages": json["totalPages"],
      "currentPage": json["currentPage"],
    }),
    products: List<Products>.from(json["products"].map((x) => Products.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalProducts": pagination.totalProducts,
    "totalPages": pagination.totalPages,
    "currentPage": pagination.currentPage,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class Paginations {
  int totalProducts;
  int totalPages;
  int currentPage;

  Paginations({
    required this.totalProducts,
    required this.totalPages,
    required this.currentPage,
  });

  factory Paginations.fromJson(Map<String, dynamic> json) => Paginations(
    totalProducts: json["totalProducts"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalOrders": totalProducts,
    "totalPages": totalPages,
    "currentPage": currentPage,
  };
}

class Products {
  int id;
  String title;
  String description;
  int price;
  List<String> images;
  int vendorId;
  DateTime createdAt;
  DateTime updatedAt;

  Products({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
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
