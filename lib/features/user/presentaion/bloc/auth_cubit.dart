import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/strings/failures.dart';
import 'package:opal_app/features/user/Domain/entities/authentity.dart';
import 'package:opal_app/features/user/Domain/entities/login_entity.dart';
import 'package:opal_app/features/user/Domain/usecases/login_usecase.dart';
import 'package:opal_app/features/user/presentaion/bloc/auth_state.dart';
import '../../../../core/errors/failure.dart';
import '../../Domain/usecases/register_usecase.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  LoginEntity? _user;
  LoginEntity? get user => _user;
  AuthCubit({required this.loginUsecase, required this.registerUsecase})
    : super(AuthInitial());
  Future<void> login(String identifier, String credential, String role) async {
    emit(AuthLoading());
    try {
      final user = await loginUsecase(identifier, credential, role);

      user.fold(
        (failure) {
          emit(AuthFailure(_errorMessage(failure)));
          print("Login failed: ${failure.toString()}");
        },
        (user) {
          emit(AuthSuccess());
          _user = user;
          print("Login successful: ${_user!.token}");
        },
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register(RegisterEntity registerEntity) async {
    emit(AuthLoading());
    try {
      final user = await registerUsecase(registerEntity);
      user.fold(
        (failure) {
          emit(AuthFailure(_errorMessage(failure)));
        },
        (user) {
          emit(AuthSuccess());
          print("Registration successful: $user");
        },
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  String _errorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case NoInternetFailure:
        return NO_INTERNET_FAILURE_MESSAGE;
      case WrongDataFailure:
        return WRONG_DATA_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
