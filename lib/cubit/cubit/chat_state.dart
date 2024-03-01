part of 'chat_cubit.dart';

class ChatState {}

class ChatInitial extends ChatState {}

class ChatMessageState extends ChatState {
  ChatMessageState();
}

class ChatLoadingState extends ChatState {
  ChatLoadingState();
}

class ChatErrorState extends ChatState {
  final String error;
  ChatErrorState({required this.error});
}

class ChatCompleteState extends ChatState {
  ChatCompleteState();
}

class ClearCacheState extends ChatState {
  ClearCacheState();
}
