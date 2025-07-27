import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/user/Domain/usecases/get_all_univeristies.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import 'get_all_universities_state.dart';

class GetAllUniversitiesCubit extends Cubit<GetAllUniversitiesState> {
  final GetAllUniveristiesUseCase getAllUniveristies;

  GetAllUniversitiesCubit(this.getAllUniveristies)
    : super(GetAllUniversitiesInitial());
  Future<void> fetchAlluniversities() async {
    emit(GetAllUniversitiesLoading());
    try {
      final universities = await getAllUniveristies();
      universities.fold(
        (failure) {
          emit(GetAllUniversitiesError(_errorMessage(failure)));
        },
        (universities) {
          emit(GetAllUniversitiesSuccess(universities));
          print("Fetched universities successfully: ${universities}");
        },
      );
    } catch (e) {
      print('Server error: ${e}');
      emit(GetAllUniversitiesError(e.toString()));
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
