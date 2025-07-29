import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/Domain/usecase/add_line_use_case.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_state.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';

class AddLineCubit extends Cubit<AddLineState> {
  final AddLineUseCase addLineUseCase;
  AddLineCubit(this.addLineUseCase) : super(AddLineInitial());
  Future<void> AddLine(LineEntity Line) async {
    emit(AddLineLoading());
    final result = await addLineUseCase(Line);
    result.fold(
      (failure) {
        emit(AddLineError(_errorMessage(failure)));
      },
      (_) {
        emit(AddLineSuccess());
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
