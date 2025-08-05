import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Data/models/tour_model.dart';
import 'package:opal_app/features/user/Domain/usecases/select_tour_use_case.dart';
import 'package:opal_app/features/user/Domain/usecases/unconfirm_tour_use_case.dart';
import 'package:opal_app/features/user/presentaion/bloc/selection_tour/selection_tour_state.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';

class SelectionTourCubit extends Cubit<SelectionTourState> {
  final SelectionTourUseCase selectionTourUseCase;
  final UnconfirmTourUseCase unconfirmTourUseCase;
  TourModel? tourCurrent;

  SelectionTourCubit(this.selectionTourUseCase, this.unconfirmTourUseCase)
    : super(SelectionTourInitial());
  Future<void> selectionTour(String tourId) async {
    emit(SelectionTourLoading());
    try {
      final selectTour = await selectionTourUseCase(tourId);

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
