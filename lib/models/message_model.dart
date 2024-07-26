import 'package:chat_app/models/user_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class MessageModel {
  final types.Message message;
  final ChatUser user;

  MessageModel({required this.message, required this.user});
  Map<String, dynamic> toJson() {
    return {
      'message': message.toJson(), // Assuming TextMessage has toJson method
      'user': user.toJson(),
    };
  }

  // Create a Message object from a Map object
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: types.Message.fromJson(
          json['message']), // Assuming TextMessage has fromJson method
      user: ChatUser.fromJson(json['user']),
    );
  }
}
