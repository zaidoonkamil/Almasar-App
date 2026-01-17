// To parse this JSON data, do
//
//     final getTodayDashboardAdmin = getTodayDashboardAdminFromJson(jsonString);

import 'dart:convert';

GetTodayDashboardAdmin getTodayDashboardAdminFromJson(String str) => GetTodayDashboardAdmin.fromJson(json.decode(str));

String getTodayDashboardAdminToJson(GetTodayDashboardAdmin data) => json.encode(data.toJson());

class GetTodayDashboardAdmin {
  String message;
  int totalOrders;
  int completedOrders;
  int cancelledOrders;
  int exchangedOrders;
  int totalOrderAmount;
  int totalDeliveryFee;
  int totalAmountIncludingFee;

  GetTodayDashboardAdmin({
    required this.message,
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.exchangedOrders,
    required this.totalOrderAmount,
    required this.totalDeliveryFee,
    required this.totalAmountIncludingFee,
  });

  factory GetTodayDashboardAdmin.fromJson(Map<String, dynamic> json) => GetTodayDashboardAdmin(
    message: json["message"] ?? '',
    totalOrders: (json["totalOrders"] as num).toInt(),
    completedOrders: (json["completedOrders"] as num).toInt(),
    cancelledOrders: (json["cancelledOrders"] as num).toInt(),
    exchangedOrders: (json["exchangedOrders"] as num).toInt(),
    totalOrderAmount: (json["totalOrderAmount"] as num).toInt(),
    totalDeliveryFee: (json["totalDeliveryFee"] as num).toInt(),
    totalAmountIncludingFee: (json["totalAmountIncludingFee"] as num).toInt(),
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
