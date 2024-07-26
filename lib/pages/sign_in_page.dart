import 'package:chat_app/cubits/user_cubit.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.reload);
  VoidCallback reload;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserRepository _userRepository = UserRepository();

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;
      setState(() {});
      if (firebaseUser != null) {
        widget.reload();
        // ChatUser? chatUser =
        //     await _userRepository.getUserById(firebaseUser.uid);
        // if (chatUser == null) {
        //   chatUser = ChatUser(
        //     id: firebaseUser.uid,
        //     email: firebaseUser.email!,
        //     firstName: firebaseUser.displayName?.split(' ').first ?? '',
        //     lastName: firebaseUser.displayName?.split(' ').last ?? '',
        //     avatarUrl: firebaseUser.photoURL,
        //   );
        //   await _userRepository.createUser(chatUser);
        // }
        //  context.read<UserCubit>().emit(UserLoaded(chatUser));
      }
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(
                'images/arkwood.jpg',
              ),
            ),
            SizedBox(
              height: 100,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  _signInWithGoogle(context);
                },
                label: Text('Sign in with Google'),
                icon: Image.asset(
                  'images/google.png',
                  height: 60,
                )),
            SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
