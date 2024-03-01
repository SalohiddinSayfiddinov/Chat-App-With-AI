import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_task/services/chat_gpt_service.dart';
import 'package:web_task/services/shared_prefs.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial()) {
    SharedPrefs.getStoredMessages().then(
      (storedMessages) {
        if (storedMessages.isNotEmpty) {
          messages.addAll(
            storedMessages
                .map((msg) {
                  return ChatMessage.fromJson(msg);
                })
                .toList()
                .reversed,
          );
        }
        emit(ChatCompleteState());
      },
    );
  }

  final chatGPTService = ChatGPTService();
  final me = ChatUser(id: '1', firstName: "Me");
  final chatGpt = ChatUser(id: '2', firstName: "ChatGpt");
  final List<ChatMessage> messages = [];
  final List<ChatUser> typingUsers = [];

  void sendMessage(ChatMessage m) {
    messages.insert(0, m);
    emit(ChatMessageState());
    getChatResponse(m);
    SharedPrefs.storeMessage(m.toJson());
  }

  Future<void> getChatResponse(ChatMessage m) async {
    String textMessage = m.text;
    typingUsers.add(chatGpt);

    final Map<String, String> result = await ChatGPTService.getResponse(
        textMessage, "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");
    if (result['result'] != 'nulll') {
      ChatMessage response = ChatMessage(
        text: result['result']!,
        user: chatGpt,
        createdAt: DateTime.now(),
      );

      messages.insert(0, response);
      SharedPrefs.storeMessage(response.toJson());

      emit(ChatCompleteState());
    } else {
      emit(ChatErrorState(error: result['error']!));
    }

    typingUsers.remove(chatGpt);
  }

  void clearCache() {
    SharedPrefs.clearMessages();
    messages.clear();
    emit(ClearCacheState());
  }
}
