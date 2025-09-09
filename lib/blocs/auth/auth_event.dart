part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// class AuthCheckEmail extends AuthEvent {
//   final String email;
//   const AuthCheckEmail(this.email);

//   @override
//   List<Object> get props => [email];
// }

class AuthLogin extends AuthEvent {
  final SignInFormModel data;
  const AuthLogin(this.data);

  @override
  List<Object> get props => [data];
}

class AuthGetCurrentUser extends AuthEvent {}

class AuthUpadatePassword extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  const AuthUpadatePassword(
    this.oldPassword,
    this.newPassword,
  );

  @override
  List<Object> get props => [oldPassword, newPassword];
}

class AuthLogout extends AuthEvent {}
