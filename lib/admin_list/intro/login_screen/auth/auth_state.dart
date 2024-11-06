abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String message;

  AuthAuthenticated(this.message);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
