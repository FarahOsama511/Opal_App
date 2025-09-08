import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Domain/usecase/update_down_town.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../Domain/entities/down_town_entity.dart';
import 'update_down_town_state.dart';

class UpdateDownTownCubit extends Cubit<UpdateDownTownState> {
  UpdateDownTownCubit(this.updateDownTownUseCase)
    : super(UpdateDownTownInitial());
  final UpdateDownTownUsecase updateDownTownUseCase;
  Future<void> updateDownTown(DownTownEntity DownTown) async {
    emit(UpdateDownTownLoading());
    final result = await updateDownTownUseCase(DownTown);
    result.fold(
      (failure) {
        emit(UpdateDownTownError(_errorMessage(failure)));
      },
      (_) {
        emit(UpdateDownTownSuccess());
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
