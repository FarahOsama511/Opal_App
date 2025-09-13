import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../Domain/entities/line_entity.dart';
import '../../../Domain/usecase/add_update_delete_line.dart.dart';
import 'update_line_state.dart';

class UpdateLineCubit extends Cubit<UpdateLineState> {
  UpdateLineCubit(this.updateLineUseCase) : super(UpdateLineInitial());
  final UpdateLineUseCase updateLineUseCase;
  Future<void> updateLine(LineEntity line) async {
    emit(UpdateLineLoading());
    final result = await updateLineUseCase(line);
    result.fold(
      (failure) {
        emit(UpdateLineError(_errorMessage(failure)));
      },
      (_) {
        emit(UpdateLineSuccess());
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
