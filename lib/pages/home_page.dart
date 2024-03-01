import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_task/cubit/cubit/chat_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(listener: (context, state) {
      if (state is ChatErrorState) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(state.error),
              ),
            );
          },
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("ChatGpt"),
          actions: [
            IconButton(
              onPressed: () {
                context.read<ChatCubit>().clearCache();
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: DashChat(
          currentUser: context.watch<ChatCubit>().me,
          typingUsers: context.watch<ChatCubit>().typingUsers,
          onSend: (ChatMessage m) {
            context.read<ChatCubit>().sendMessage(m);
          },
          messages: context.watch<ChatCubit>().messages,
        ),
      );
    });
  }
}
