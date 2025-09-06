import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_lines/add_line_state.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_lines/get_all_lines_cubit.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../Domain/entities/line_entity.dart';
import '../../../Domain/usecase/add_update_delete_line.dart.dart';

class AddLineCubit extends Cubit<AddLineState> {
  final AddLineUseCase addLineUseCase;
  AddLineCubit(this.addLineUseCase) : super(AddLineInitial());
  Future<void> AddLine(LineEntity Line, dynamic context) async {
    emit(AddLineLoading());
    final result = await addLineUseCase(Line);
    result.fold(
      (failure) {
        emit(AddLineError(_errorMessage(failure)));
      },
      (_) {
        emit(AddLineSuccess());
        BlocProvider.of<LinesCubit>(context).getAllLiness();
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
