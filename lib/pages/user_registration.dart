import 'package:chat_app/cubits/user_cubit.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRegistrationPage extends StatefulWidget {
  UserRegistrationPage();

  @override
  State<UserRegistrationPage> createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();

  TextEditingController _lastNameController = TextEditingController();

  TextEditingController _avatarUrlController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController = TextEditingController(
        text: _authService.currentUser?.displayName?.split(' ').first ?? '');
    _lastNameController = TextEditingController(
        text: _authService.currentUser?.displayName?.split(' ').last ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.only(top: 30),
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Wrap(
                      //direction: Axis.vertical,
                      // crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        if (_authService.currentUser?.photoURL != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  _authService.currentUser?.photoURL ?? ""),
                              radius: 50,
                            ),
                          ),

                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(labelText: 'First Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(labelText: 'Last Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        // TextFormField(
                        //   controller: _avatarUrlController,
                        //   decoration: InputDecoration(labelText: 'Avatar URL'),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter an avatar URL';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final newUser = ChatUser(
                                  id: _authService.currentUser?.uid ?? '',
                                  email: _authService.currentUser?.email ?? "",
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  avatarUrl: _authService.currentUser?.photoURL,
                                );
                                context.read<UserCubit>().newUser(newUser);
                              }
                            },
                            child: Text('Register'),
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
