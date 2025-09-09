import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kampus/models/sign_in_form_model.dart';
import 'package:kampus/models/user_model.dart';
import 'package:kampus/services/auth_service.dart';
import 'package:kampus/services/user_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLogin) {
        try {
          emit(AuthLoading());

          final user = await AuthService().login(event.data);

          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthGetCurrentUser) {
        try {
          emit(AuthLoading());
          final SignInFormModel data =
              await AuthService().getCredentialFromLocal();
          final UserModel user = await AuthService().login(data);
          emit(AuthSuccess(user));
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthUpadatePassword) {
        try {
          if (state is AuthSuccess) {
            final updatedUser = (state as AuthSuccess).user.copyWith(
                  password: event.newPassword,
                );

            emit(AuthLoading());

            await UserService().updatePassword(
              event.oldPassword,
              event.newPassword,
            );

            emit(AuthSuccess(updatedUser));
          }
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }

      if (event is AuthLogout) {
        try {
          emit(AuthLoading());

          await AuthService().logout();

          emit(AuthInitial());
        } catch (e) {
          emit(AuthFailed(e.toString()));
        }
      }
    });
  }
}
