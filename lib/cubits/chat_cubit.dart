import 'dart:io';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'chat_state.dart';
import '../repositories/chat_repository.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final User currentUser;

  ChatCubit({required this.currentUser, required this.chatRepository})
      : super(ChatInitial());

  void loadMessages() {
    chatRepository.getMessages().listen((messages) {
      emit(ChatLoaded(messages: messages));
    });
  }

  void sendMessage(Message msg) {
    chatRepository.sendMessage(msg);
  }

  void sendImage(File file, User receiver) {
    chatRepository.sendImageMessage(file, currentUser, receiver);
  }
}
