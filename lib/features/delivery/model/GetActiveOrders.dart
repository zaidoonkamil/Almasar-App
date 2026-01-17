import 'dart:convert';

List<GetActiveOrders> getActiveOrdersFromJson(String str) => List<GetActiveOrders>.from(json.decode(str).map((x) => GetActiveOrders.fromJson(x)));

String getActiveOrdersToJson(List<GetActiveOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

int toInt(dynamic v, {int defaultValue = 0}) {
  if (v == null) return defaultValue;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? defaultValue;
  return defaultValue;
}

class GetActiveOrders {
  int id;
  int userId;
  int? vendorId;
  dynamic productId;
  int assignedDeliveryId;
  String address;
  String phone;
  int orderAmount;
  int deliveryFee;
  String notes;
  String status;
  dynamic isAccepted;
  dynamic rejectionReason;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> statusHistory;
  List<Item>? items;
  User user;
  Delivery delivery;
  dynamic rating;

  GetActiveOrders({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.productId,
    required this.assignedDeliveryId,
    required this.address,
    required this.phone,
    required this.orderAmount,
    required this.deliveryFee,
    required this.notes,
    required this.status,
    required this.isAccepted,
    required this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    required this.statusHistory,
    required this.items,
    required this.user,
    required this.delivery,
    required this.rating,
  });

  factory GetActiveOrders.fromJson(Map<String, dynamic> json) => GetActiveOrders(
    id: toInt(json["id"]),
    userId: toInt(json["userId"]),
    vendorId: json["vendorId"] == null ? null : toInt(json["vendorId"]),
    productId: json["productId"],
    assignedDeliveryId: toInt(json["assignedDeliveryId"]??0),
    address: json["address"] ?? '',
    phone: json["phone"] ?? '',
    orderAmount: toInt(json["orderAmount"]),
    deliveryFee: toInt(json["deliveryFee"]),
    notes: json["notes"] ?? '',
    status: json["status"] ?? '',
    isAccepted: json["isAccepted"],
    rejectionReason: json["rejectionReason"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    statusHistory: (json["statusHistory"] as List? ?? []).toList(),
    items: json["items"] == null ? [] : List<Item>.from((json["items"] as List).map((x) => Item.fromJson(x))),
    user: User.fromJson(json["user"]),
    delivery: json["delivery"] != null
        ? Delivery.fromJson(json["delivery"])
        : Delivery(id: 0, name: "", phone: "", location: "", createdAt: DateTime.now()),
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "vendorId": vendorId,
    "productId": productId,
    "assignedDeliveryId": assignedDeliveryId,
    "address": address,
    "phone": phone,
    "orderAmount": orderAmount,
    "deliveryFee": deliveryFee,
    "notes": notes,
    "status": status,
    "isAccepted": isAccepted,
    "rejectionReason": rejectionReason,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "statusHistory": List<dynamic>.from(statusHistory.map((x) => x)),
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "user": user.toJson(),
    "delivery": delivery.toJson(),
    "rating": rating,
  };
}


class Delivery {
  int id;
  String name;
  String phone;
  String location;
  DateTime createdAt;

  Delivery({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.createdAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    id: toInt(json["id"]),
    name: json["name"] ?? '',
    phone: json["phone"] ?? '',
    location: json["location"] ?? '',
    createdAt: json["createdAt"] == null
        ? DateTime.now()
        : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "location": location,
    "createdAt": createdAt.toIso8601String(),
  };
}

class Item {
  int id;
  int orderId;
  int productId;
  int quantity;
  DateTime createdAt;
  DateTime updatedAt;
  Product product;

  Item({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    orderId: json["orderId"],
    productId: json["productId"],
    quantity: json["quantity"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    product: Product.fromJson(json["Product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "productId": productId,
    "quantity": quantity,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "Product": product.toJson(),
  };
}

class Product {
  int id;
  String title;
  int price;
  List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: toInt(json["id"]),
    title: json["title"] ?? '',
    price: toInt(json["price"]),
    images: List<String>.from(
      (json["images"] as List? ?? []).map((x) => x.toString()),
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "images": List<dynamic>.from(images.map((x) => x)),
  };
}

class StatusHistory {
  int id;
  String status;
  DateTime changeDate;
  int orderId;

  StatusHistory({
    required this.id,
    required this.status,
    required this.changeDate,
    required this.orderId,
  });

  factory StatusHistory.fromJson(Map<String, dynamic> json) => StatusHistory(
    id: json["id"],
    status: json["status"],
    changeDate: DateTime.parse(json["changeDate"]),
    orderId: json["orderId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "changeDate": changeDate.toIso8601String(),
    "orderId": orderId,
  };
}

class User {
  int id;
  String name;
  String phone;
  String location;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: toInt(json["id"]),
    name: json["name"] ?? '',
    phone: json["phone"] ?? '',
    location: json["location"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "location": location,
  };
}

