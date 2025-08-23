import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
import '../../../Domain/usecase/add_update_delete_line.dart.dart';
import 'delete_line_state.dart';

class DeleteLineCubit extends Cubit<DeleteLineState> {
  final DeleteLineUseCase deleteLineUsecase;
  DeleteLineCubit(this.deleteLineUsecase) : super(DeleteLineInitial());

  Future<void> deleteLine(String LineId) async {
    emit(DeleteLineLoading());
    final result = await deleteLineUsecase(LineId);
    result.fold(
      (failure) {
        emit(DeleteLineError(_errorMessage(failure)));
      },
      (_) {
        print("Deleting line: $LineId");
        emit(DeleteLineLoaded(DELETED_SUCCESS_MESSAGE));
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
