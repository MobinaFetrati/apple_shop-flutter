import 'package:flutter_ecommerce_project/bloc/authentication/auth_event.dart';
import 'package:flutter_ecommerce_project/bloc/authentication/auth_state.dart';
import 'package:flutter_ecommerce_project/data/repository/authentication_repository.dart';
import 'package:flutter_ecommerce_project/di/di.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _repository = locator.get();
  AuthBloc() : super(AuthInitiateState()) {
    on<AutLoginRequest>((event, emit) async {
      emit(AuthLoadingState());
      var response = await _repository.login(event.username, event.password);
      emit(AuthResponseState(response));
    });

    on<AutRegisterRequest>((event, emit) async {
      emit(AuthLoadingState());
      var response = await _repository.register(
          event.username, event.password, event.passwordConfirm);
      emit(AuthResponseState(response));
    });
  }
}
