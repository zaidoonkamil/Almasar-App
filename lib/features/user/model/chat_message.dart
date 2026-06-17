import 'dart:convert';

List<ChatMessageModel> chatMessagesFromJson(String str) =>
    List<ChatMessageModel>.from(json.decode(str).map((x) => ChatMessageModel.fromJson(x)));

String chatMessagesToJson(List<ChatMessageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatUserDetail {
  final int id;
  final String name;
  final String role;
  final List<dynamic>? images;

  ChatUserDetail({
    required this.id,
    required this.name,
    required this.role,
    this.images,
  });

  factory ChatUserDetail.fromJson(Map<String, dynamic> json) => ChatUserDetail(
        id: json["id"],
        name: json["name"],
        role: json["role"],
        images: json["images"] != null ? List<dynamic>.from(json["images"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
        "images": images,
      };
}

class ChatMessageModel {
  final int id;
  final int orderId;
  final int senderId;
  final int receiverId;
  final String messageText;
  final bool isRead;
  final DateTime createdAt;
  final ChatUserDetail? sender;
  final ChatUserDetail? receiver;

  ChatMessageModel({
    required this.id,
    required this.orderId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    required this.isRead,
    required this.createdAt,
    this.sender,
    this.receiver,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
        id: json["id"],
        orderId: json["orderId"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        messageText: json["messageText"],
        isRead: json["isRead"] ?? false,
        createdAt: DateTime.parse(json["createdAt"]),
        sender: json["sender"] != null ? ChatUserDetail.fromJson(json["sender"]) : null,
        receiver: json["receiver"] != null ? ChatUserDetail.fromJson(json["receiver"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "senderId": senderId,
        "receiverId": receiverId,
        "messageText": messageText,
        "isRead": isRead,
        "createdAt": createdAt.toIso8601String(),
        "sender": sender?.toJson(),
        "receiver": receiver?.toJson(),
      };
}
