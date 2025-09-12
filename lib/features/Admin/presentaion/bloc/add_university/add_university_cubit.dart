import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/strings/messages.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_university/add_university_state.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import 'package:opal_app/features/user/Domain/usecases/add_university_usecase.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';

class AddUniversityCubit extends Cubit<AddUniversityState> {
  final AddUniversityUsecase addUniversityUsecase;
  AddUniversityCubit(this.addUniversityUsecase) : super(AddUniversityInitial());
  Future<void> AddUniversity(
    UniversityEntity university,
    dynamic context,
  ) async {
    emit(AddUniversityLoading());
    final result = await addUniversityUsecase(university);
    result.fold(
      (failure) {
        emit(AddUniversityFailure(_errorMessage(failure)));
      },
      (_) {
        emit(AddUniversitySuccess(ADDED_SUCCESS_MESSAGE));
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
