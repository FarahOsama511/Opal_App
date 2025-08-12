import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/strings/failures.dart';
import '../../../user/Domain/usecases/get_university_id_usecase.dart';
import 'get_university_by_id_state.dart';

class GetUniversityByIdCubit extends Cubit<GetUniversityByIdState> {
  final GetUniversityIdUsecase getUniversityIdUsecase;
  String? nameOfUniversity;
  GetUniversityByIdCubit(this.getUniversityIdUsecase)
    : super(getUniversityByIdInitial());

  Future<void> getUniversityById(String id) async {
    emit(getUniversityByIdLoading());
    try {
      final universityById = await getUniversityIdUsecase(id);
      universityById.fold(
        (failure) {
          emit(getUniversityByIdError(_errorMessage(failure)));
        },
        (universityById) async {
          nameOfUniversity = universityById.name;
          emit(getUniversityByIdSuccess(universityById));
        },
      );
    } catch (e) {
      emit(getUniversityByIdError(e.toString()));
    }
  }

  String _errorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case NoInternetFailure:
        return NO_INTERNET_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
