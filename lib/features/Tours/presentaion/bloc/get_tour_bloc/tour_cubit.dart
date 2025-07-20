import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Tours/Domain/usecase/get_all_tours.dart';
import 'package:opal_app/features/Tours/presentaion/bloc/get_tour_bloc/tour_state.dart';

import '../../../../../core/strings/failures.dart';

class TourCubit extends Cubit<TourState> {
  final GetAllToursUseCase getAllToursUseCase;
  TourCubit(this.getAllToursUseCase) : super(TourInitial());

  Future<void> getAllTours() async {
    emit(TourLoading());
    try {
      final tours = await getAllToursUseCase();
      tours.fold(
        (Failure) {
          emit(TourError(_errorMessage(Failure)));
        },
        (tours) {
          emit(TourLoaded(tours));
          print("USE CASE RESULT: $tours");
        },
      );
    } catch (e) {
      log('Error in TourCubit: $e');
      emit(TourError(UNEXPECTED_FAILURE_MESSAGE));
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
