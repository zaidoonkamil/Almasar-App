import 'package:delivery_app/core/network/remote/dio_helper.dart';
import 'package:delivery_app/core/network/remote/socket_helper.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/features/user/cubit/chat_states.dart';
import 'package:delivery_app/features/user/model/chat_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);

  List<ChatMessageModel> messages = [];

  // Initialize Socket.io and Join Chat Room
  void initChatSocket({required int orderId, required int otherUserId}) {
    // Make sure socket is connected
    SocketHelper.connect();

    final myUserId = int.tryParse(id) ?? 0;

    // Join room when connected
    if (SocketHelper.isConnected()) {
      _joinRoom(orderId, myUserId, otherUserId);
    } else {
      SocketHelper.onEvent("connect", (_) {
        _joinRoom(orderId, myUserId, otherUserId);
      });
    }

    // Listen to incoming messages
    SocketHelper.onEvent("new_message", (data) {
      print("📩 Received new message via Socket: $data");
      try {
        final message = ChatMessageModel.fromJson(data);
        // Add message if it belongs to this order and conversation pair
        if (message.orderId == orderId &&
            ((message.senderId == myUserId && message.receiverId == otherUserId) ||
             (message.senderId == otherUserId && message.receiverId == myUserId))) {
          
          // Check if message is already in list (avoid duplication)
          bool exists = messages.any((m) => m.id == message.id);
          if (!exists) {
            messages.add(message);
            emit(ChatReceivedNewMessageState());
            // Mark as read
            markMessagesAsRead(orderId: orderId, senderId: otherUserId);
          }
        }
      } catch (e) {
        print("Error parsing socket message: $e");
      }
    });
  }

  void _joinRoom(int orderId, int myUserId, int otherUserId) {
    SocketHelper.emitEvent("join_room", {
      "orderId": orderId,
      "userId1": myUserId,
      "userId2": otherUserId,
    });
  }

  // Get chat history from API
  void getChatHistory({required int orderId, required int otherUserId}) {
    emit(ChatGetHistoryLoadingState());
    messages = [];

    final myUserId = int.tryParse(id) ?? 0;

    DioHelper.getData(
      url: '/chat/history/$orderId?user1Id=$myUserId&user2Id=$otherUserId',
      token: token,
    ).then((value) {
      messages = (value.data as List)
          .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(ChatGetHistorySuccessState());
      // Also mark as read
      markMessagesAsRead(orderId: orderId, senderId: otherUserId);
    }).catchError((error) {
      String errorMsg = "حدث خطأ أثناء تحميل الرسائل";
      if (error is DioException && error.response?.data is Map) {
        errorMsg = error.response?.data["error"] ?? errorMsg;
      }
      emit(ChatGetHistoryErrorState(errorMsg));
    });
  }

  // Send message via API (it will broadcast via socket automatically)
  void sendMessage({
    required int orderId,
    required int receiverId,
    required String text,
  }) {
    if (text.trim().isEmpty) return;

    emit(ChatSendMessageLoadingState());

    DioHelper.postData(
      url: '/chat/message',
      data: {
        'orderId': orderId,
        'receiverId': receiverId,
        'messageText': text.trim(),
      },
      token: token,
    ).then((value) {
      final sentMessage = ChatMessageModel.fromJson(value.data);
      
      // Add message locally if not already received via socket
      bool exists = messages.any((m) => m.id == sentMessage.id);
      if (!exists) {
        messages.add(sentMessage);
      }
      emit(ChatSendMessageSuccessState());
    }).catchError((error) {
      String errorMsg = "فشل إرسال الرسالة";
      if (error is DioException && error.response?.data is Map) {
        errorMsg = error.response?.data["error"] ?? errorMsg;
      }
      emit(ChatSendMessageErrorState(errorMsg));
    });
  }

  // Send push notification to user when representative arrives
  void sendArrivalNotification({
    required int orderId,
    required int receiverId,
  }) {
    emit(ChatSendNotificationLoadingState());

    // 1. Send the chat message first
    sendMessage(
      orderId: orderId,
      receiverId: receiverId,
      text: "📍 لقد وصلت إلى موقع التوصيل وأنا بانتظارك بالخارج.",
    );

    // 2. Send the push notification via API
    DioHelper.postData(
      url: '/send-notification-to-user',
      data: {
        'userId': receiverId,
        'title': 'المندوب وصل! 📍',
        'message': 'لقد وصل المندوب إلى موقعك وهو بانتظارك بالخارج. يرجى استلام الطلب.',
      },
      token: token,
    ).then((value) {
      emit(ChatSendNotificationSuccessState());
    }).catchError((error) {
      String errorMsg = "فشل إرسال إشعار الوصول";
      if (error is DioException && error.response?.data is Map) {
        errorMsg = error.response?.data["error"] ?? errorMsg;
      }
      emit(ChatSendNotificationErrorState(errorMsg));
    });
  }

  // Mark messages as read
  void markMessagesAsRead({required int orderId, required int senderId}) {
    DioHelper.putData(
      url: '/chat/read',
      data: {
        'orderId': orderId,
        'senderId': senderId,
      },
      token: token,
    ).then((value) {
      emit(ChatMarkReadSuccessState());
    }).catchError((error) {
      print("Error marking messages as read: $error");
    });
  }
}
