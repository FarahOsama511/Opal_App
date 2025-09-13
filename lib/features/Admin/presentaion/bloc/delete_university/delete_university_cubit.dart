import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
import '../../../../user/Domain/usecases/delete_university_use_case.dart';
import 'delete_university_state.dart';

class DeleteUniversityCubit extends Cubit<DeleteUniversityState> {
  final DeleteUniversityUseCase deleteUniversityUseCase;
  DeleteUniversityCubit(this.deleteUniversityUseCase)
    : super(DeleteUniversityInitial());

  Future<void> deleteUniversity(String id) async {
    emit(DeleteUniversityLoading());
    final result = await deleteUniversityUseCase(id);
    result.fold(
      (failure) {
        emit(DeleteUniversityError(_errorMessage(failure)));
      },
      (_) {
        print("Deleting university: $id");
        emit(DeleteUniversitySuccess(DELETED_SUCCESS_MESSAGE, id));
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
