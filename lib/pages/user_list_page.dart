import 'package:chat_app/cubits/user_cubit.dart';
import 'package:chat_app/cubits/user_state.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersListPage extends StatefulWidget {
  UsersListPage(this.reload);
  VoidCallback reload;
  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final AuthService _authService = AuthService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_authService.currentUser != null) context.read<UserCubit>().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              'Hi ${_authService.currentUser?.displayName?.split(' ').first}'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _authService.signOut();
                widget.reload();
                setState(() {});
              },
              child: Text('Sign out'),
            )
          ]),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (contextx, state) {
          if (state is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoadedState) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("Chat with Others")),
                Container(
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];

                        return user.id != (_authService.currentUser?.uid ?? "")
                            ? Card(
                                child: ListTile(
                                  leading: user.avatarUrl != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(user.avatarUrl!),
                                        )
                                      : CircleAvatar(
                                          child: Text(user.firstName[0]),
                                        ),
                                  title: Text(
                                      '${user.firstName} ${user.lastName}'),
                                  trailing: Icon(Icons.navigate_next),
                                  subtitle: Text(user.email),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          user: state.user,
                                          receiver: user,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
