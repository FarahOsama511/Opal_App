import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/delete_university/delete_university_state.dart';
import 'package:opal_app/features/user/Domain/usecases/delete_university_use_case.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';

class DeleteUniversityCubit extends Cubit<DeleteUniversityState> {
  final DeleteUniversityUseCase deleteUniversityUseCase;
  DeleteUniversityCubit(this.deleteUniversityUseCase)
    : super(DeleteUniversityInitial());

  Future<void> deleteUser(String id) async {
    emit(DeleteUniversityLoading());
    final result = await deleteUniversityUseCase(id);
    result.fold(
      (failure) {
        emit(DeleteUniversityError(_errorMessage(failure)));
      },
      (_) {
        print("Deleting university: $id");
        emit(DeleteUniversitySuccess(DELETED_SUCCESS_MESSAGE));
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
