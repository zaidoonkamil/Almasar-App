import 'dart:convert';

GetDashboardAdmin getDashboardAdminFromJson(String str) => GetDashboardAdmin.fromJson(json.decode(str));

String getDashboardAdminToJson(GetDashboardAdmin data) => json.encode(data.toJson());

class GetDashboardAdmin {
  String message;
  int totalOrders;
  int completedOrders;
  int cancelledOrders;
  int exchangedOrders;
  int totalOrderAmount;
  int totalDeliveryFee;
  int totalAmountIncludingFee;

  GetDashboardAdmin({
    required this.message,
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.exchangedOrders,
    required this.totalOrderAmount,
    required this.totalDeliveryFee,
    required this.totalAmountIncludingFee,
  });

  factory GetDashboardAdmin.fromJson(Map<String, dynamic> json) => GetDashboardAdmin(
    message: json["message"],
    totalOrders: json["totalOrders"],
    completedOrders: json["completedOrders"],
    cancelledOrders: json["cancelledOrders"],
    exchangedOrders: json["exchangedOrders"],
    totalOrderAmount: json["totalOrderAmount"],
    totalDeliveryFee: json["totalDeliveryFee"],
    totalAmountIncludingFee: json["totalAmountIncludingFee"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "totalOrders": totalOrders,
    "completedOrders": completedOrders,
    "cancelledOrders": cancelledOrders,
    "exchangedOrders": exchangedOrders,
    "totalOrderAmount": totalOrderAmount,
    "totalDeliveryFee": totalDeliveryFee,
    "totalAmountIncludingFee": totalAmountIncludingFee,
  };
}
