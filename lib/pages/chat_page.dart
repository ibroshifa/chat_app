import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/models/message_model.dart' as ms;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import '../cubits/chat_cubit.dart';
import '../cubits/chat_state.dart' as ch;
import '../repositories/chat_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatScreen extends StatelessWidget {
  final User user;
  final User receiver;

  ChatScreen({required this.user, required this.receiver});

  void _handleImageSelection(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      context.read<ChatCubit>().sendImage(file, receiver);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatCubit(currentUser: user, chatRepository: ChatRepository())
            ..loadMessages(),
      child: Scaffold(
        appBar: AppBar(title: Text('${receiver.name}')),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ch.ChatState>(
                builder: (context, state) {
                  if (state is ch.ChatLoaded) {
                    state.messages.sort((b, a) =>
                        a.message.createdAt
                            ?.compareTo(b.message.createdAt ?? 0) ??
                        0);
                    final messages = state.messages
                        .where((e) =>
                            (e.user.id == receiver.id &&
                                e.message.author.id == user.id) ||
                            (e.user.id == user.id &&
                                e.message.author.id == receiver.id))
                        .map((m) => m.message)
                        .toList();
                    return Chat(
                      messages: messages,
                      onSendPressed: (types.PartialText partialText) {
                        context.read<ChatCubit>().sendMessage(ms.Message(
                              message: types.TextMessage(
                                  id: Uuid().v4(),
                                  author: types.User(
                                      id: user.id, firstName: user.name),
                                  createdAt:
                                      DateTime.now().millisecondsSinceEpoch,
                                  text: partialText.text,
                                  type: types.MessageType.text),
                              user: receiver,
                            ));
                      },
                      onAttachmentPressed: () => _handleImageSelection(context),
                      user: types.User(id: user.id),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
