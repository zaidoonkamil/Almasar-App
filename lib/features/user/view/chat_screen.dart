import 'package:delivery_app/core/styles/themes.dart';
import 'package:delivery_app/core/widgets/constant.dart';
import 'package:delivery_app/core/widgets/show_toast.dart';
import 'package:delivery_app/features/user/cubit/chat_cubit.dart';
import 'package:delivery_app/features/user/cubit/chat_states.dart';
import 'package:delivery_app/features/user/model/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;

class ChatScreen extends StatefulWidget {
  final int orderId;
  final int otherUserId;
  final String otherUserName;
  final String otherUserRole;
  final String orderStatus;

  const ChatScreen({
    super.key,
    required this.orderId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserRole,
    required this.orderStatus,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool get isChatClosed {
    final closedStatuses = ["تم التسليم", "استرجاع الطلب", "تبديل الطلب"];
    return closedStatuses.contains(widget.orderStatus);
  }

  String getTranslatedRole(String role) {
    switch (role.toLowerCase()) {
      case 'delivery':
        return 'المندوب';
      case 'user':
        return 'الزبون';
      case 'vendor':
        return 'التاجر';
      case 'admin':
        return 'الإدارة (الدعم)';
      default:
        return role;
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myUserId = int.tryParse(id) ?? 0;

    return BlocProvider(
      create: (context) => ChatCubit()
        ..getChatHistory(orderId: widget.orderId, otherUserId: widget.otherUserId)
        ..initChatSocket(orderId: widget.orderId, otherUserId: widget.otherUserId),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          if (state is ChatGetHistorySuccessState ||
              state is ChatReceivedNewMessageState ||
              state is ChatSendMessageSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
          if (state is ChatSendNotificationSuccessState) {
            showToastSuccess(text: 'تم إرسال إشعار الوصول للزبون بنجاح 📍', context: context);
          }
          if (state is ChatSendNotificationErrorState) {
            showToastError(text: state.error, context: context);
          }
        },
        builder: (context, state) {
          final cubit = ChatCubit.get(context);

          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F9),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              titleSpacing: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: Text(
                      widget.otherUserName.isNotEmpty ? widget.otherUserName[0] : '?',
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.otherUserName,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'cairo',
                        ),
                      ),
                      Text(
                        getTranslatedRole(widget.otherUserRole),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'cairo',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Text(
                      'طلب #${widget.orderId}',
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'cairo',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                if (isChatClosed)
                  Container(
                    width: double.infinity,
                    color: Colors.orange.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.lock_outline, color: Colors.orange, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'الدردشة مغلقة لأن الطلب مكتمل أو ملغى',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isChatClosed && widget.otherUserRole.toLowerCase() == 'user')
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.blue[700]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'تنبيه الوصول السريع 📍',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'cairo',
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'اضغط لإرسال رسالة وإشعار وصول فوري لهاتف الزبون.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontFamily: 'cairo',
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            cubit.sendArrivalNotification(
                              orderId: widget.orderId,
                              receiverId: widget.otherUserId,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          ),
                          child: state is ChatSendNotificationLoadingState
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blueAccent,
                                  ),
                                )
                              : const Text(
                                  'أنا في الموقع',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: 'cairo',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: state is ChatGetHistoryLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : cubit.messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline,
                                    size: 64,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'لا توجد رسائل بعد.\nابدأ المحادثة الآن!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                      fontFamily: 'cairo',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: cubit.messages.length,
                              itemBuilder: (context, index) {
                                final message = cubit.messages[index];
                                final isMe = message.senderId == myUserId;

                                return _buildMessageBubble(message, isMe);
                              },
                            ),
                ),
                if (!isChatClosed) _buildInputArea(context, cubit),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message, bool isMe) {
    final timeStr = DateFormat('hh:mm a').format(message.createdAt.toLocal());

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.messageText,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'cairo',
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey[500],
                    fontSize: 9,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    color: Colors.white70,
                    size: 12,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatCubit cubit) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 4,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'cairo',
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    hintText: 'اكتب رسالتك هنا...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'cairo',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                final text = _messageController.text.trim();
                if (text.isNotEmpty) {
                  cubit.sendMessage(
                    orderId: widget.orderId,
                    receiverId: widget.otherUserId,
                    text: text,
                  );
                  _messageController.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
