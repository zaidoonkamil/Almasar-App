import 'dart:convert';

GetDashboard getDashboardFromJson(String str) => GetDashboard.fromJson(json.decode(str));

String getDashboardToJson(GetDashboard data) => json.encode(data.toJson());

class GetDashboard {
  String message;
  int orderCount;
  int deliveredOrderComplet;
  int deliveredOrderCancelled;
  int deliveredOrderExchange;
  dynamic deliveryFee;
  int totalAmountIncludingFee;
  String averageRating;
  int totalRatings;

  GetDashboard({
    required this.message,
    required this.orderCount,
    required this.deliveredOrderComplet,
    required this.deliveredOrderCancelled,
    required this.deliveredOrderExchange,
    required this.deliveryFee,
    required this.totalAmountIncludingFee,
    required this.averageRating,
    required this.totalRatings,
  });

  factory GetDashboard.fromJson(Map<String, dynamic> json) => GetDashboard(
    message: json["message"],
    orderCount: json["orderCount"],
    deliveredOrderComplet: json["deliveredOrderComplet"],
    deliveredOrderCancelled: json["deliveredOrderCancelled"],
    deliveredOrderExchange: json["deliveredOrderExchange"],
    deliveryFee: json["deliveryFee"]??'',
    totalAmountIncludingFee: json["totalAmountIncludingFee"],
    averageRating: json["averageRating"],
    totalRatings: json["totalRatings"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "orderCount": orderCount,
    "deliveredOrderComplet": deliveredOrderComplet,
    "deliveredOrderCancelled": deliveredOrderCancelled,
    "deliveredOrderExchange": deliveredOrderExchange,
    "deliveryFee": deliveryFee,
    "totalAmountIncludingFee": totalAmountIncludingFee,
    "averageRating": averageRating,
    "totalRatings": totalRatings,
  };
}
