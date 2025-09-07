import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import 'package:opal_app/features/user/Domain/usecases/get_all_user.dart';
import 'package:opal_app/features/user/Domain/usecases/get_user_id_use_case.dart';
import 'package:opal_app/features/user/Domain/usecases/user_isactivat.dart';
import 'package:opal_app/features/user/Domain/usecases/user_isdeactivat_UseCase.dart';
import '../../../../core/strings/failures.dart';
import 'user_state.dart';

class GetAllUserCubit extends Cubit<UserState> {
  final GetAllUserUseCase getAllUserUseCase;
  final UserIsactivatUseCase userIsactivatUseCase;
  final UserIsDeactivatUseCase userIsDeactivatUseCase;
  final GetUserIdUseCase getUserIdUseCase;
  String? userId;
  String? lineName;
  List<UserEntity> _users = [];
  GetAllUserCubit(
    this.getUserIdUseCase,
    this.getAllUserUseCase,
    this.userIsactivatUseCase,
    this.userIsDeactivatUseCase,
  ) : super(UserInitial());
  Future<void> fetchAllUsers() async {
    emit(UserLoading());
    try {
      final users = await getAllUserUseCase();
      users.fold(
        (failure) {
          emit(UserError(_errorMessage(failure)));
        },
        (user) {
          _users = user;
          emit(UserSuccess(user));
        },
      );
    } catch (e) {
      print('Server error: ${e}');
      emit(UserError("حدث خطأ ما، يرجى المحاولة مرة أخرى"));
    }
  }

  Future<void> userIsActivate(String userId) async {
    try {
      final result = await userIsactivatUseCase(userId, 'active');
      result.fold(
        (failure) {
          emit(UserError(_errorMessage(failure)));
        },
        (activatedUser) {
          // عدل حالة المستخدم داخل القائمة
          _users = _users.map((user) {
            if (user.id == userId) {
              return user.copyWith(status: 'active');
            }
            return user;
          }).toList();

          emit(UserSuccess(_users));
        },
      );
    } catch (e) {
      print('Server error: ${e}');
      emit(UserError("حدث خطأ ما، يرجى المحاولة مرة أخرى"));
    }
  }

  Future<void> userIsDeactivate(String userId) async {
    try {
      final result = await userIsDeactivatUseCase(userId, 'inactive');
      result.fold(
        (failure) {
          emit(UserError(_errorMessage(failure)));
        },
        (deactivatedUser) {
          _users = _users.map((user) {
            if (user.id == userId) {
              return user.copyWith(status: 'inactive');
            }
            return user;
          }).toList();

          emit(UserSuccess(_users));
        },
      );
    } catch (e) {
      print('Server error: ${e}');
      emit(UserError("حدث خطأ ما، يرجى المحاولة مرة أخرى"));
    }
  }

  Future<void> getUserById(String userId) async {
    emit(UserLoading());
    try {
      final userById = await getUserIdUseCase(userId);
      userById.fold(
        (failure) {
          emit(UserError(_errorMessage(failure)));
        },
        (userById) async {
          if (userById != null) {
            emit(UserByIdSuccess(userById));
            userId = userById.id ?? "";
            lineName = userById.line?.name ?? "";
            print("User successfully: $userById");
          } else {
            emit(UserError("المستخدم غير موجود"));
            print("UserById returned null");
          }
        },
      );
    } catch (e) {
      print('Server error: ${e}');
      emit(UserError("حدث خطأ ما، يرجى المحاولة مرة أخرى"));
    }
  }

  String _errorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case NoInternetFailure:
        return NO_INTERNET_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
