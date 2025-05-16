import 'dart:convert';

GetTodayDashboard getTodayDashboardFromJson(String str) => GetTodayDashboard.fromJson(json.decode(str));

String getTodayDashboardToJson(GetTodayDashboard data) => json.encode(data.toJson());

class GetTodayDashboard {
  String message;
  int orderCount;
  int deliveredOrderComplet;
  int deliveredOrderCancelled;
  int deliveredOrderExchange;
  int totalOrderAmount;
  int totalDeliveryFee;
  int totalAmountIncludingFee;

  GetTodayDashboard({
    required this.message,
    required this.orderCount,
    required this.deliveredOrderComplet,
    required this.deliveredOrderCancelled,
    required this.deliveredOrderExchange,
    required this.totalOrderAmount,
    required this.totalDeliveryFee,
    required this.totalAmountIncludingFee,
  });

  factory GetTodayDashboard.fromJson(Map<String, dynamic> json) => GetTodayDashboard(
    message: json["message"],
    orderCount: json["orderCount"],
    deliveredOrderComplet: json["deliveredOrderComplet"],
    deliveredOrderCancelled: json["deliveredOrderCancelled"],
    deliveredOrderExchange: json["deliveredOrderExchange"],
    totalOrderAmount: json["totalOrderAmount"],
    totalDeliveryFee: json["totalDeliveryFee"],
    totalAmountIncludingFee: json["totalAmountIncludingFee"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "orderCount": orderCount,
    "deliveredOrderComplet": deliveredOrderComplet,
    "deliveredOrderCancelled": deliveredOrderCancelled,
    "deliveredOrderExchange": deliveredOrderExchange,
    "totalOrderAmount": totalOrderAmount,
    "totalDeliveryFee": totalDeliveryFee,
    "totalAmountIncludingFee": totalAmountIncludingFee,
  };
}
