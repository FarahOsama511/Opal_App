import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../user/Domain/entities/university_entity.dart';
import '../../../../user/Domain/usecases/update_university_usecase.dart';
import '../update_University/update_University_state.dart';

class UpdateUniversityCubit extends Cubit<UpdateUniversityState> {
  UpdateUniversityCubit(this.updateUniversityUseCase)
    : super(UpdateUniversityInitial());
  final UpdateUniversityUsecase updateUniversityUseCase;
  Future<void> updateUniversity(UniversityEntity University) async {
    emit(UpdateUniversityLoading());
    final result = await updateUniversityUseCase(University);
    result.fold(
      (failure) {
        emit(UpdateUniversityError(_errorMessage(failure)));
      },
      (_) {
        emit(UpdateUniversitySuccess());
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
