import 'dart:convert';

List<GetActiveOrders> getActiveOrdersFromJson(String str) => List<GetActiveOrders>.from(json.decode(str).map((x) => GetActiveOrders.fromJson(x)));

String getActiveOrdersToJson(List<GetActiveOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetActiveOrders {
  int id;
  int userId;
  int assignedDeliveryId;
  String address;
  String phone;
  int orderAmount;
  int deliveryFee;
  String notes;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  List<StatusHistory> statusHistory;

  GetActiveOrders({
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
    required this.user,
    required this.statusHistory,
  });

  factory GetActiveOrders.fromJson(Map<String, dynamic> json) => GetActiveOrders(
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
    user: User.fromJson(json["user"]),
    statusHistory: List<StatusHistory>.from(json["statusHistory"].map((x) => StatusHistory.fromJson(x))),
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
    "user": user.toJson(),
    "statusHistory": List<dynamic>.from(statusHistory.map((x) => x.toJson())),
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
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "location": location,
  };
}
