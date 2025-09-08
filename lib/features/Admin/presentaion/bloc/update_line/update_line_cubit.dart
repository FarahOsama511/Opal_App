import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Domain/entities/line_entity.dart';
import 'package:opal_app/features/Admin/Domain/usecase/add_update_delete_line.dart.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_line/update_line_state.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';

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
