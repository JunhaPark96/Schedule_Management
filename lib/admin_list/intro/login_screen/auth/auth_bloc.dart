import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneline2/admin_list/intro/login_screen/auth/auth_event.dart';
import 'package:oneline2/admin_list/intro/login_screen/auth/auth_state.dart';
import 'package:oneline2/admin_list/intro/login_screen/auth/login_api.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginApi loginApi;

  AuthBloc(this.loginApi) : super(AuthInitial()) {
    on<LoginRequested>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final success = await loginApi.login(event.email, event.password);
          if (success) {
            emit(AuthAuthenticated('Login Successful'));
          } else {
            emit(AuthError('Failed to Login'));
          }
        } catch (e) {
          emit(AuthError('Failed to Login :$e'));
        }
      },
    );
  }
}
