import 'dart:io';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<MessageModel>> getMessages() {
    return _firestore
        .collection('messagess')
        //  .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MessageModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> sendMessage(MessageModel message) async {
    await _firestore.collection('messagess').add(message.toJson());
  }

  Future<String> uploadImage(File file) async {
    final ref = _storage.ref().child('chat_images').child(Uuid().v4());
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> sendImageMessage(
      XFile result, ChatUser sender, ChatUser receiver) async {
    final imageUrl = await uploadImage(File(result.path));

    final bytes = await result.readAsBytes();
    final image = await decodeImageFromList(bytes);

    final message = types.ImageMessage(
      author: types.User(id: sender.id, firstName: sender.firstName),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      height: image.height.toDouble(),
      id: Uuid().v4(),
      name: result.name,
      size: bytes.length,
      uri: imageUrl,
      width: image.width.toDouble(),
    );
    // final message = {
    //   'id': Uuid().v4(),
    //   'authorId': sender.id,
    //   'authorName': sender.name,
    //   'createdAt': DateTime.now().millisecondsSinceEpoch,
    //   'imageUrl': imageUrl,
    //   'type': 'image',
    // };

    await _firestore
        .collection('messagess')
        .add(MessageModel(message: message, user: receiver).toJson());
  }
}
