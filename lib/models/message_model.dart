import 'package:chat_app/models/user_model.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Message {
  final types.TextMessage message;
  final User user;

  Message({required this.message, required this.user});
  Map<String, dynamic> toJson() {
    return {
      'message': message.toJson(), // Assuming TextMessage has toJson method
      'user': user.toJson(),
    };
  }

  // Create a Message object from a Map object
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: types.TextMessage.fromJson(
          json['message']), // Assuming TextMessage has fromJson method
      user: User.fromJson(json['user']),
    );
  }
}
