import 'dart:convert';

AllOrder allOrderFromJson(String str) => AllOrder.fromJson(json.decode(str));

String allOrderToJson(AllOrder data) => json.encode(data.toJson());

class AllOrder {
  Pagination pagination;
  List<Order> orders;

  AllOrder({
    required this.pagination,
    required this.orders,
  });

  factory AllOrder.fromJson(Map<String, dynamic> json) => AllOrder(
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

class Order {
  int id;
  int userId;
  int? assignedDeliveryId;
  String address;
  String phone;
  int orderAmount;
  int deliveryFee;
  String notes;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  List<StatusHistory> statusHistory;
  User user;
  Delivery? delivery;

  Order({
    required this.id,
    required this.userId,
    required this.assignedDeliveryId,
    required this.address,
    required this.phone,
    required this.orderAmount,
    required this.deliveryFee,
    required this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.statusHistory,
    required this.user,
    required this.delivery,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    userId: json["userId"],
    assignedDeliveryId: json["assignedDeliveryId"],
    address: json["address"],
    phone: json["phone"],
    orderAmount: json["orderAmount"],
    deliveryFee: json["deliveryFee"],
    notes: json["notes"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    statusHistory: List<StatusHistory>.from(json["statusHistory"].map((x) => StatusHistory.fromJson(x))),
    user: User.fromJson(json["user"]),
    delivery: json["delivery"] == null ? null : Delivery.fromJson(json["delivery"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "assignedDeliveryId": assignedDeliveryId,
    "address": address,
    "phone": phone,
    "orderAmount": orderAmount,
    "deliveryFee": deliveryFee,
    "notes": notes,
    "status": status,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "statusHistory": List<dynamic>.from(statusHistory.map((x) => x.toJson())),
    "user": user.toJson(),
    "delivery": delivery?.toJson(),
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
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    location: json["location"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "location": location,
    "createdAt": createdAt.toIso8601String(),
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
  bool isActive;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    required this.isActive,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    location: json["location"],
    isActive: json["isActive"],
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
    "role": role,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
