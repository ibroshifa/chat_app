import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDlit45aOD11olvHzo6KdICpbjKdV-qm7M",
      appId: "1:7559726379:android:f92cc23b8e7857c1c5b16e",
      messagingSenderId: "7559726379",
      projectId: "chatapp-b1d59",
      storageBucket: "chatapp-b1d59.appspot.com",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserSelectionScreen(),
    );
  }
}

class UserSelectionScreen extends StatefulWidget {
  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  final List<User> users = List.generate(
    3,
    (index) => User(id: Uuid().v4(), name: 'User $index'),
  );
  User? _selectedUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<User>(
              hint: Text('Select a user'),
              value: _selectedUser,
              onChanged: (User? newValue) {
                setState(() {
                  _selectedUser = newValue;
                });
              },
              items: users.map<DropdownMenuItem<User>>((User user) {
                return DropdownMenuItem<User>(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Container(
                height: 500,
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.name),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                user: _selectedUser!, receiver: user),
                          ),
                        );
                      },
                    );
                  },
                ))
            // ElevatedButton(
            //   onPressed: _selectedUser == null
            //       ? null
            //       : () {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (context) => ChatScreen(
            //                 user: _selectedUser!,
            //                 receiver: users
            //                     .firstWhere((u) => u.id != _selectedUser!.id),
            //               ),
            //             ),
            //           );
            //         },
            //   child: Text('Start Chat'),
            // ),
          ],
        ),
      ),
    );
  }
}
