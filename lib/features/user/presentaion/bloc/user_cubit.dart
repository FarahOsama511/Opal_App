import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/strings/failures.dart';
import '../../Domain/entities/user_entity.dart';
import '../../Domain/usecases/get_all_user.dart';
import '../../Domain/usecases/get_user_id_use_case.dart';
import '../../Domain/usecases/user_isactivat.dart';
import '../../Domain/usecases/user_isdeactivat_UseCase.dart';
import 'user_state.dart';

class GetAllUserCubit extends Cubit<UserState> {
  final GetAllUserUseCase getAllUserUseCase;
  final UserIsactivatUseCase userIsactivatUseCase;
  final UserIsDeactivatUseCase userIsDeactivatUseCase;
  final GetUserIdUseCase getUserIdUseCase;
  String? userId;
  String? lineName;
  UserEntity? user;
  List<UserEntity> _users = [];
  GetAllUserCubit(
    this.getUserIdUseCase,
    this.getAllUserUseCase,
    this.userIsactivatUseCase,
    this.userIsDeactivatUseCase,
  ) : super(UserInitial());
  Future<void> fetchAllUsers() async {
    emit(UserLoading());
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
  }

  Future<void> userIsActivate(String userId) async {
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
  }

  Future<void> userIsDeactivate(String userId) async {
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
  }

  Future<void> getUserById(String userId) async {
    emit(UserLoading());
    final result = await getUserIdUseCase(userId);
    result.fold(
      (failure) {
        emit(UserError(_errorMessage(failure)));
      },
      (userById) {
        if (userById != null) {
          emit(UserByIdSuccess(userById));
          print("User successfully: $userById");
        } else {
          emit(UserError("المستخدم غير موجود"));
          print("UserById returned null");
        }
      },
    );
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
