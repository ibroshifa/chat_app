import 'package:chat_app/cubits/user_cubit.dart';
import 'package:chat_app/cubits/user_state.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/sign_in_page.dart';
import 'package:chat_app/pages/user_list_page.dart';
import 'package:chat_app/pages/user_registration.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => UserCubit(UserRepository()),
        child: AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final AuthService _authService = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext contextxx) {
    context.read<UserCubit>().getUerById(_authService.currentUser?.uid ?? '');
    return BlocBuilder<UserCubit, UserState>(builder: (contextx, state) {
      if (state is InitialState) {
        // replace with actual user ID

        return Scaffold(body: Center(child: Container()));
      } else if (state is LoadingState) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      } else if (state is UserNotSignedIn) {
        return LoginPage(() {
          //setState(() {
          context
              .read<UserCubit>()
              .getUerById(_authService.currentUser?.uid ?? '');
          // });
        });
      } else if (state is UserNotFound) {
        return UserRegistrationPage();
      } else if (state is ErrorState) {
        return Center(child: Text(state.message));
      } else if (state is LoadedState) {
        return BlocProvider(
            create: (contextx) => UserCubit(UserRepository()),
            child: UsersListPage(() {
              setState(() {
                _authService.signOut();
                //context.read<UserCubit>().userNotSignedIn();
                context.read<UserCubit>().getUerById('');
              });
            }));
      } else {
        return Container();
      }
    });
  }
}












































// import 'package:chat_app/models/user_model.dart';
// import 'package:chat_app/pages/chat_page.dart';
// import 'package:chat_app/pages/sign_in_page.dart';
// import 'package:chat_app/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:uuid/uuid.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: "AIzaSyDlit45aOD11olvHzo6KdICpbjKdV-qm7M",
//       appId: "1:7559726379:android:f92cc23b8e7857c1c5b16e",
//       messagingSenderId: "7559726379",
//       projectId: "chatapp-b1d59",
//       storageBucket: "chatapp-b1d59.appspot.com",
//     ),
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Chat App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: UserSelectionScreen(),
//     );
//   }
// }

// class UserSelectionScreen extends StatefulWidget {
//   @override
//   _UserSelectionScreenState createState() => _UserSelectionScreenState();
// }

// class _UserSelectionScreenState extends State<UserSelectionScreen> {
//   final AuthService _authService = AuthService();
//   final List<ChatUser> users = List.generate(
//     3,
//     (index) => ChatUser(
//         id: Uuid().v4(),
//         firstName: 'User $index',
//         email: '',
//         lastName: 'last',
//         avatarUrl: ''),
//   );
//   ChatUser? _selectedUser;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select User'), actions: [
//         ElevatedButton(
//           onPressed: () async {
//             await _authService.signOut();
//             print('User signed out');
//           },
//           child: Text('Sign out'),
//         ),
//       ]),
//       body: _authService.currentUser == null
//           ? SignInPage()
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   DropdownButton<ChatUser>(
//                     hint: Text('Select a user'),
//                     value: _selectedUser,
//                     onChanged: (ChatUser? newValue) {
//                       setState(() {
//                         _selectedUser = newValue;
//                       });
//                     },
//                     items:
//                         users.map<DropdownMenuItem<ChatUser>>((ChatUser user) {
//                       return DropdownMenuItem<ChatUser>(
//                         value: user,
//                         child: Text(user.firstName),
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                       height: 500,
//                       child: ListView.builder(
//                         itemCount: users.length,
//                         itemBuilder: (context, index) {
//                           final user = users[index];
//                           return ListTile(
//                             title: Text(user.firstName),
//                             onTap: () {
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => ChatScreen(
//                                       user: _selectedUser!, receiver: user),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ))
//                   // ElevatedButton(
//                   //   onPressed: _selectedUser == null
//                   //       ? null
//                   //       : () {
//                   //           Navigator.of(context).push(
//                   //             MaterialPageRoute(
//                   //               builder: (context) => ChatScreen(
//                   //                 user: _selectedUser!,
//                   //                 receiver: users
//                   //                     .firstWhere((u) => u.id != _selectedUser!.id),
//                   //               ),
//                   //             ),
//                   //           );
//                   //         },
//                   //   child: Text('Start Chat'),
//                   // ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
