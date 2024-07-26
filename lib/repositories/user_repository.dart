import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String id) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        //.orderBy('rolNumber')
        .snapshots(includeMetadataChanges: true);
  }

  updateUser(String id, ChatUser user) {
    FirebaseFirestore.instance.collection('user').doc(id).set(user.toJson());
  }

  getUsers() {
    return FirebaseFirestore.instance
        .collection('user')
        // .orderBy('date', descending: true)
        .snapshots(includeMetadataChanges: true);
  }

  // updateExamCollection(String id, ExamCollectionModel examCollection) {
  //   FirebaseFirestore.instance.collection('examCollection').doc(id).set(
  //       ExamCollectionModel('', '', '', [], '', '').toJson(examCollection));
  // }

  newUser(ChatUser user) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(user.id)
        .set(user.toJson());
  }

  deleteUser(String id) {
    FirebaseFirestore.instance.collection('user').doc(id).delete();
  }
}
