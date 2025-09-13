import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../Admin/Domain/usecase/get_all_down_town_usecase.dart';
import 'get_all_down_town_state.dart';

class GetAllDownTownCubit extends Cubit<GetAllDownTownState> {
  final GetAllDownTownUsecase getAllDownTownUsecase;

  GetAllDownTownCubit(this.getAllDownTownUsecase)
    : super(GetAllDownTownsInitial());

  Future<void> fetchAllDownTowns() async {
    emit(GetAllDownTownsLoading());
    try {
      final result = await getAllDownTownUsecase();
      result.fold(
        (failure) {
          emit(GetAllDownTownsError(_errorMessage(failure)));
        },
        (downTowns) {
          emit(GetAllDownTownsSuccess(downTowns));
          print("Fetched DownTowns successfully: $downTowns");
        },
      );
    } catch (e, stack) {
      print('Server error: $e');
      print(stack);
      emit(GetAllDownTownsError(e.toString()));
    }
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
