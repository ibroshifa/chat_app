import 'package:chat_app/cubits/user_state.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.repository) : super(InitialState());
  final UserRepository repository;
  List<ChatUser> users = [];
  ChatUser selectedUser = ChatUser.empty();

  // setSelectedCollection(String id) {
  //   var collection = users.firstWhere((element) => element.id == id);
  //   selectedUser = collection;
  //   emit(LoadedState(users: users, user: selectedUser));
  // }
  void getUerById(String id) async {
    final AuthService _authService = AuthService();
    if (_authService.currentUser != null) {
      try {
        //emit(LoadingState());
        repository.getUserById(id).listen(
          (e) {
            if (e.data()?.isNotEmpty ?? false) {
              selectedUser = ChatUser.fromJson(
                e.data() ?? {},
              );
              emit(LoadedState(user: selectedUser, users: users));
            } else {
              emit(UserNotFound());
            }
          },
        );
      } catch (e) {
        emit(ErrorState(message: e.toString()));
      }
    } else {
      emit(UserNotSignedIn());
    }
  }

  userNotSignedIn() {
    emit(UserNotSignedIn());
  }

  newUser(ChatUser user) {
    repository.newUser(user);
    users.add(user);
    emit(LoadedState(user: user, users: users));
  }

  updateUser(String id, ChatUser user) {
    repository.updateUser(id, user);
  }

  void getUsers() async {
    try {
      emit(LoadingState());
      repository.getUsers().listen(
        (element) {
          if (element.docs.isNotEmpty) {
            users = element.docs
                .map<ChatUser>((e) => ChatUser.fromJson(
                      e.data(),
                    ))
                .toList();
            // booksSink.add(books);
            //emit(ErrorState());
            emit(LoadedState(user: selectedUser, users: users));
          }
        },
      );
    } catch (e) {
      emit(ErrorState(message: e.toString()));
    }
  }
}
