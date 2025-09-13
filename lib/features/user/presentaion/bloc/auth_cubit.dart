import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/local_network.dart';
import '../../../../core/strings/failures.dart';
import '../../Domain/entities/authentity.dart';
import '../../Domain/entities/login_entity.dart';
import '../../Domain/usecases/login_usecase.dart';
import '../../Domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;
  LoginEntity? _user;

  static const Map<String, String> roleMapping = {
    'admin': 'مسؤول',
    'supervisor': 'مشرف',
    'student': 'طالب', // رجعنا الطالب هنا
  };

  LoginEntity? get user => _user;

  AuthCubit({required this.loginUsecase, required this.registerUsecase})
    : super(AuthInitial());

  Future<void> login(
    String identifier,
    String credential,
    String selectedArabicRole,
  ) async {
    emit(AuthLoading());

    try {
      final result = await loginUsecase(
        identifier,
        credential,
        _convertRoleToEnglish(selectedArabicRole),
      );

      result.fold(
        (failure) {
          emit(AuthFailure(_errorMessage(failure)));
          print("Login failed: ${failure.toString()}");
        },
        (user) async {
          // التشيك بس للإدمن والسوبر فايزور
          if (selectedArabicRole == 'مسؤول' || selectedArabicRole == 'مشرف') {
            if (_doesRoleMatch(user.user.role!, selectedArabicRole)) {
              await _handleSuccessfulLogin(user);
            } else {
              emit(AuthFailure('الدور المحدد لا يتطابق مع صلاحياتك'));
            }
          } else {
            // لو طالب → عادي يدخل على طول
            await _handleSuccessfulLogin(user);
          }
        },
      );
    } catch (e) {
      emit(AuthFailure('حدث خطأ غير متوقع'));
      print("Login error: ${e.toString()}");
    }
  }

  String _convertRoleToEnglish(String arabicRole) {
    return roleMapping.entries
        .firstWhere((entry) => entry.value == arabicRole)
        .key;
  }

  bool _doesRoleMatch(String userRole, String selectedArabicRole) {
    final englishRole = _convertRoleToEnglish(selectedArabicRole);
    return userRole == englishRole;
  }

  Future<void> _handleSuccessfulLogin(LoginEntity user) async {
    _user = user;
    await Future.wait([
      CacheNetwork.insertToCache(key: "Save_UserName", value: user.user.name!),
      CacheNetwork.insertToCache(key: "Save_UserId", value: user.user.id!),
    ]);

    emit(AuthSuccess());
    _user = user;
    print("Login successful. Token: ${user.token}");
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
