abstract class ChatStates {}

class ChatInitialState extends ChatStates {}

class ChatGetHistoryLoadingState extends ChatStates {}
class ChatGetHistorySuccessState extends ChatStates {}
class ChatGetHistoryErrorState extends ChatStates {
  final String error;
  ChatGetHistoryErrorState(this.error);
}

class ChatSendMessageLoadingState extends ChatStates {}
class ChatSendMessageSuccessState extends ChatStates {}
class ChatSendMessageErrorState extends ChatStates {
  final String error;
  ChatSendMessageErrorState(this.error);
}

class ChatReceivedNewMessageState extends ChatStates {}
class ChatMarkReadSuccessState extends ChatStates {}
