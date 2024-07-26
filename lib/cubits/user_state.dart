import 'package:chat_app/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {}

class InitialState extends UserState {
  @override
  List<Object> get props => [];
}

class LoadingState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserNotFound extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserNotSignedIn extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadedState extends UserState {
  LoadedState({required this.users, required this.user});
  // bool imageDownloaded = false;
  final List<ChatUser> users;
  //List<EpisodModel> episods;
  final ChatUser user;
  @override
  List<Object> get props => [users, user];
}

class ErrorState extends UserState {
  String message;
  ErrorState({required this.message});
  @override
  List<Object> get props => [];
}
