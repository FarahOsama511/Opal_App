import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/errors/failure.dart';
import 'package:opal_app/features/Admin/Domain/usecase/get_all_tours.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_bloc/tour_state.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

import '../../../../../core/strings/failures.dart';
import '../../../Domain/entities/tour.dart';

class TourCubit extends Cubit<TourState> {
  final GetAllToursUseCase getAllToursUseCase;
  List<UserEntity>? numOfUsers;
  List<Tour> tours = [];
  TourCubit(this.getAllToursUseCase) : super(TourInitial());

  Future<void> getAllTours() async {
    emit(TourLoading());
    try {
      final tours = await getAllToursUseCase();
      tours.fold(
        (Failure) {
          print('TourCubit Error: ${Failure.runtimeType}');
          emit(TourError(_errorMessage(Failure)));
        },
        (tours) {
          tours = tours;
          emit(TourLoaded(tours));
          print("USE CASE RESULT: $tours");
        },
      );
    } catch (e) {
      print('Error in TourCubit: $e');
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
