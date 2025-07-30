import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_id.dart/get_tour_id_state.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../user/Domain/entities/user_entity.dart';
import '../../../Domain/usecase/get_tour_id_use_case.dart';

class GetTourIdCubit extends Cubit<GetTourIdState> {
  final GetTourByIdUseCase getTourByIdUseCase;
  List<UserEntity>? numOfUsers;
  GetTourIdCubit(this.getTourByIdUseCase) : super(GetTourByIdInitial());

  Future<void> getTourById(String id) async {
    emit(GetTourByIdLoading());
    try {
      final tour = await getTourByIdUseCase(id);
      tour.fold(
        (Failure) {
          print('GetTourIdCubit Error: ${Failure.runtimeType}');
          emit(getTourByIdError(_errorMessage(Failure)));
        },
        (tour) {
          numOfUsers = tour.users;
          emit(TourByIdLoaded(tour));
          print("USE CASE RESULT: $tour");
        },
      );
    } catch (e) {
      print('Error in GetTourIdCubit: $e');
      emit(getTourByIdError(UNEXPECTED_FAILURE_MESSAGE));
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
