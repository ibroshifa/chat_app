import 'dart:io';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Message>> getMessages() {
    return _firestore
        .collection('messagess')
        //  .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Message.fromJson(data);
      }).toList();
    });
  }

  Future<void> sendMessage(Message message) async {
    await _firestore.collection('messagess').add(message.toJson());
  }

  Future<String> uploadImage(File file) async {
    final ref = _storage.ref().child('chat_images').child(Uuid().v4());
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> sendImageMessage(File file, User sender, User receiver) async {
    final imageUrl = await uploadImage(file);
    // final message = {
    //   'id': Uuid().v4(),
    //   'authorId': sender.id,
    //   'authorName': sender.name,
    //   'createdAt': DateTime.now().millisecondsSinceEpoch,
    //   'imageUrl': imageUrl,
    //   'type': 'image',
    // };
//  final message = types.TextMessage(
//                                 id: Uuid().v4(),
//                                 author: types.User(
//                                     id: sender.id, firstName: se.name),
//                                 createdAt:
//                                     DateTime.now().millisecondsSinceEpoch,
//                                 text: partialText.text,
//                               )
//     await _firestore.collection('messagess').add(Message(message: message ,user: receiver).toJson());
  }
}
