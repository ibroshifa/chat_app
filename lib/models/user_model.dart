import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatUser {
  final String email;
  String id;
  String firstName;
  String lastName;
  String? avatarUrl;

  ChatUser(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.avatarUrl});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
    };
  }

  factory ChatUser.fromJson(Map<String, dynamic> map) {
    return ChatUser(
      id: map['id'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      avatarUrl: map['avatarUrl'],
    );
  }

  factory ChatUser.empty() {
    return ChatUser(
      id: '',
      email: '',
      firstName: '',
      lastName: '',
      avatarUrl: '',
    );
  }
}

// Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: "AIzaSyDlit45aOD11olvHzo6KdICpbjKdV-qm7M", 
//       appId: "1:7559726379:android:f92cc23b8e7857c1c5b16e", 
//       messagingSenderId: "7559726379", 
//       projectId: "chatapp-b1d59", 
//       storageBucket: "chatapp-b1d59.appspot.com", 
//     ),
//   );


// class ChatUsers  {

//    ChatUsers({
//     required this. id,
//     required this.email,
//     required this. firstName,
//     required this. lastName,
//     required this.avatarUrl
    
//   }); 

//   final String email;
//     String id;
//      String firstName;
//      String lastName;
//      String? avatarUrl,
 

//   // Convert ChatUser to a map
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'email': email,
//       'firstName': firstName,
//       'lastName': lastName,
//       'avatarUrl': imageUrl,
//     };
//   }

//   // Create a ChatUser from a map
// //   factory ChatUser.fromMap(Map<String, dynamic> map) {
// //     return ChatUser(
// //       id: map['id'],
// //       email: map['email'],
// //       firstName: map['firstName'],
// //       lastName: map['lastName'],
// //       avatarUrl: map['avatarUrl'],
// //     );
// //   }
  
// //   @override
// //   types.User copyWith({int? createdAt, String? firstName, String? id, String? imageUrl, String? lastName, int? lastSeen, Map<String, dynamic>? metadata, types.Role? role, int? updatedAt}) {
// //     // TODO: implement copyWith
// //     throw UnimplementedError();
// //   }
// // }
