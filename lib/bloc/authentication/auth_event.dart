abstract class AuthEvent {}

class AutLoginRequest extends AuthEvent {
  String username;
  String password;
  AutLoginRequest(this.username, this.password);
}

class AutRegisterRequest extends AuthEvent {
  String username;
  String password;
  String passwordConfirm;

  AutRegisterRequest(this.username, this.password, this.passwordConfirm);
}
