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
