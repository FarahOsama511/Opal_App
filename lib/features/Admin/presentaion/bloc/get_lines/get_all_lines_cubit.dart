import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../Domain/usecase/get_all_lines.dart';
import 'get_all_lines_state.dart';

class LinesCubit extends Cubit<GetAllLinesState> {
  final GetAllLinesUseCase getAllLinesUseCase;
  LinesCubit(this.getAllLinesUseCase) : super(LinesInitial());

  Future<void> getAllLiness() async {
    emit(LinesLoading());
    try {
      final Lines = await getAllLinesUseCase();
      Lines.fold(
        (Failure) {
          emit(LinesError(_errorMessage(Failure)));
        },
        (Lines) {
          emit(LinesLoaded(Lines));
          print("USE CASE RESULT: $Lines");
        },
      );
    } catch (e) {
      // log('Error in LinesCubit: $e');
      emit(LinesError(UNEXPECTED_FAILURE_MESSAGE));
    }
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
