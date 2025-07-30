import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/errors/failure.dart';
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
          emit(UserSuccess(user));
          print("Fetched users successfully: ${user}");
        },
      );
    } catch (e) {
      print('Server error: ${e}');
      emit(UserError(e.toString()));
    }
  }

  Future<void> userIsActivate(String userId) async {
    emit(UserLoading());
    try {
      final activateUser = await userIsactivatUseCase(userId, 'active');
      activateUser.fold(
        (failure) {
          emit(UserError(_errorMessage(failure)));
        },
        (activateUser) async {
          emit(ActivateUser(activateUser));
          print("Activate User successfully: ${activateUser}");
          await fetchAllUsers();
        },
      );
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> userIsDeactivate(String userId) async {
    emit(UserLoading());
    try {
      final deactivateUser = await userIsDeactivatUseCase(userId, 'inactive');
      deactivateUser.fold(
        (failure) {
          emit(UserError(_errorMessage(failure)));
        },
        (deactivateUser) async {
          emit(DeactivateUser(deactivateUser));
          print("Deactivate User successfully: ${deactivateUser}");
          await fetchAllUsers();
        },
      );
    } catch (e) {
      emit(UserError(e.toString()));
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
          emit(UserByIdSuccess(userById));
          userId = userById.id!;
          print(" User successfully: ${userById}");
        },
      );
    } catch (e) {
      emit(UserError(e.toString()));
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
