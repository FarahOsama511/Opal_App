import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Domain/usecase/add_tour.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_state.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
import '../../../Domain/entities/tour.dart';
import '../../../Domain/usecase/delete_tour.dart';
import '../../../Domain/usecase/update_tour.dart';

class UpdateAddDeleteTourCubit extends Cubit<UpdateAddDeleteTourState> {
  final AddTourUseCase addTourUseCase;
  final DeleteTourUseCase deleteTourUseCase;
  final UpdateTourUseCase updateTourUseCase;
  UpdateAddDeleteTourCubit(
    this.addTourUseCase,
    this.deleteTourUseCase,
    this.updateTourUseCase,
  ) : super(UpdateAddDeleteTourInitial());
  Future<void> addTour(Tour tour) async {
    emit(UpdateAddDeleteTourLoading());
    final result = await addTourUseCase(tour);
    result.fold(
      (failure) {
        emit(UpdateAddDeleteTourError(_errorMessage(failure)));
      },
      (result) {
        emit(TourAdded(TOUR_ADDED_SUCCESS_MESSAGE));
      },
    );
  }

  Future<void> updateTour(Tour tour) async {
    emit(UpdateAddDeleteTourLoading());
    final result = await updateTourUseCase(tour);
    result.fold(
      (failure) {
        emit(UpdateAddDeleteTourError(_errorMessage(failure)));
      },
      (_) {
        emit(TourAdded(TOUR_UPDATED_SUCCESS_MESSAGE));
      },
    );
  }

  Future<void> deleteTour(String tourId) async {
    emit(UpdateAddDeleteTourLoading());
    final result = await deleteTourUseCase(tourId);
    result.fold(
      (failure) {
        emit(UpdateAddDeleteTourError(_errorMessage(failure)));
      },
      (_) {
        print("Deleting tour: $tourId");
        emit(TourDeleted(TOUR_DELETED_SUCCESS_MESSAGE));
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
