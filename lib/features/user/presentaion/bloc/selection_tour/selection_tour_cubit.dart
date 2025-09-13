import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../Admin/Data/models/tour_model.dart';
import '../../../Domain/usecases/select_tour_use_case.dart';
import '../../../Domain/usecases/unconfirm_tour_use_case.dart';
import 'selection_tour_state.dart';

class SelectionTourCubit extends Cubit<SelectionTourState> {
  final SelectionTourUseCase selectionTourUseCase;
  final UnconfirmTourUseCase unconfirmTourUseCase;
  TourModel? tourCurrent;

  SelectionTourCubit(this.selectionTourUseCase, this.unconfirmTourUseCase)
    : super(SelectionTourInitial());
  Future<void> selectionTour(String tourId) async {
    print("داخل selectionTour: $tourId");

    emit(SelectionTourLoading());
    try {
      final selectTour = await selectionTourUseCase(tourId);
      print("tour id is ${tourId}");
      print("النتيجة من useCase: $selectTour");

      selectTour.fold(
        (failure) {
          emit(SelectionTourError(_errorMessage(failure)));
        },
        (selectTour) {
          emit(SelectionTourSuccess(selectTour));
          tourCurrent = selectTour as TourModel;
          print("Fetched tour successfully: ${selectTour}");
        },
      );
    } catch (e) {
      print('Server error: ${e}');
      emit(SelectionTourError(e.toString()));
    }
  }

  Future<void> UnconfirmTour(String tourId) async {
    emit(SelectionTourLoading());
    try {
      final unConfirmTour = await unconfirmTourUseCase(tourId);

      unConfirmTour.fold(
        (failure) {
          emit(SelectionTourError(_errorMessage(failure)));
        },
        (unConfirmTour) {
          emit(UnConfirmTourSuccess());
          print("Fetched UnconfirmTour: ${unConfirmTour}");
        },
      );
    } catch (e) {
      print('Server error: ${e}');
      emit(SelectionTourError(e.toString()));
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
