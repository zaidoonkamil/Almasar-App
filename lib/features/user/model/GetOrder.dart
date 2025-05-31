import 'dart:convert';

GetOrder getOrderFromJson(String str) => GetOrder.fromJson(json.decode(str));

String getOrderToJson(GetOrder data) => json.encode(data.toJson());

class GetOrder {
  Pagination pagination;
  List<Order> orders;

  GetOrder({
    required this.orders,
    required this.pagination,
  });

  factory GetOrder.fromJson(Map<String, dynamic> json) => GetOrder(
    pagination: Pagination.fromJson({
      "totalOrders": json["totalOrders"],
      "totalPages": json["totalPages"],
      "currentPage": json["currentPage"],
    }),
    orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalOrders": pagination.totalOrders,
    "totalPages": pagination.totalPages,
    "currentPage": pagination.currentPage,
    "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
  };
}


class Order {
  int id;
  int userId;
  int? vendorId;
  dynamic productId;
  dynamic assignedDeliveryId;
  String address;
  String phone;
  int orderAmount;
  int deliveryFee;
  String notes;
  String status;
  dynamic isAccepted;
  dynamic rejectionReason;
  List<Item>? items;
  DateTime createdAt;
  DateTime updatedAt;
  List<StatusHistory> statusHistory;

  Order({
    required this.id,
    required this.userId,
    required this.assignedDeliveryId,
    required this.address,
    required this.phone,
    required this.vendorId,
    required this.productId,
    required this.isAccepted,
    required this.rejectionReason,
    required this.items,
    required this.orderAmount,
    required this.deliveryFee,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.statusHistory,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    userId: json["userId"],
    vendorId: json["vendorId"],
    productId: json["productId"],
    assignedDeliveryId: json["assignedDeliveryId"],
    address: json["address"],
    phone: json["phone"],
    orderAmount: json["orderAmount"],
    deliveryFee: json["deliveryFee"],
    notes: json["notes"],
    status: json["status"],
    isAccepted: json["isAccepted"],
    rejectionReason: json["rejectionReason"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    statusHistory: List<StatusHistory>.from(json["statusHistory"].map((x) => StatusHistory.fromJson(x))),
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
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    "statusHistory": List<dynamic>.from(statusHistory.map((x) => x.toJson())),
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
    id: json["id"],
    title: json["title"],
    price: json["price"],
    images: List<String>.from(json["images"].map((x) => x)),
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

class Pagination {
  int totalOrders;
  int totalPages;
  int currentPage;

  Pagination({
    required this.totalOrders,
    required this.totalPages,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalOrders: json["totalOrders"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalOrders": totalOrders,
    "totalPages": totalPages,
    "currentPage": currentPage,
  };
}
