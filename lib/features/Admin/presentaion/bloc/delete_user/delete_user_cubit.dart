import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
import '../../../../user/Domain/usecases/delete_user_usecase.dart';
import 'delete_user_state.dart';

class DeleteUserCubit extends Cubit<DeleteUserState> {
  final DeleteUserUsecase deleteUserUsecase;
  DeleteUserCubit(this.deleteUserUsecase) : super(DeleteUserInitial());

  Future<void> deleteUser(String userId) async {
    emit(DeleteUserLoading());
    final result = await deleteUserUsecase(userId);
    result.fold(
      (failure) {
        emit(DeleteUserError(_errorMessage(failure)));
      },
      (_) {
        print("Deleting user: $userId");
        emit(DeleteUserLoaded(DELETED_SUCCESS_MESSAGE, userId));
      },
    );
  }

  String _errorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case NoInternetFailure:
        return NO_INTERNET_FAILURE_MESSAGE;

      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
