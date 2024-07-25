import 'package:chat_app/models/message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageModel> messages;

  ChatLoaded({required this.messages});
}
