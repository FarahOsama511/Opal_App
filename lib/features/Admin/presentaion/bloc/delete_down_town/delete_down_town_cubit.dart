import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
import '../../../Domain/usecase/delete_down_town_usecase.dart';
import 'delete_down_town_state.dart';

class DeleteDownTownCubit extends Cubit<DeleteDownTownState> {
  final DeleteDownTownUsecase deleteDownTownUsecase;
  DeleteDownTownCubit(this.deleteDownTownUsecase)
    : super(DeleteDownTownInitial());

  Future<void> deleteDownTown(String id) async {
    emit(DeleteDownTownLoading());
    final result = await deleteDownTownUsecase(id);
    result.fold(
      (failure) {
        emit(DeleteDownTownError(_errorMessage(failure)));
      },
      (_) {
        emit(DeleteDownTownSuccess(DELETED_SUCCESS_MESSAGE, id));
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
