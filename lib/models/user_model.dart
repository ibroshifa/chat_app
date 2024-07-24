class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Create a User object from a Map object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
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