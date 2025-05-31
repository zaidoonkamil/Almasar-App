import 'dart:convert';

ProductsVendorModel productsVendorModelFromJson(String str) => ProductsVendorModel.fromJson(json.decode(str));

String productsVendorModelToJson(ProductsVendorModel data) => json.encode(data.toJson());

class ProductsVendorModel {
  PaginationProductsVendor paginationProductsVendor;
  List<Products> products;

  ProductsVendorModel({
    required this.paginationProductsVendor,
    required this.products,
  });

  factory ProductsVendorModel.fromJson(Map<String, dynamic> json) => ProductsVendorModel(
    paginationProductsVendor: PaginationProductsVendor.fromJson({
      "totalProducts": json["totalProducts"],
      "totalPages": json["totalPages"],
      "currentPage": json["currentPage"],
    }),
    products: List<Products>.from(json["products"].map((x) => Products.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalProducts": paginationProductsVendor.totalOrders,
    "totalPages": paginationProductsVendor.totalPages,
    "currentPage": paginationProductsVendor.currentPage,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

class PaginationProductsVendor {
  int totalOrders;
  int totalPages;
  int currentPage;

  PaginationProductsVendor({
    required this.totalOrders,
    required this.totalPages,
    required this.currentPage,
  });

  factory PaginationProductsVendor.fromJson(Map<String, dynamic> json) => PaginationProductsVendor(
    totalOrders: json["totalProducts"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalProducts": totalOrders,
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
