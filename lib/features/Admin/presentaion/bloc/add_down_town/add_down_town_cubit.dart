import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/strings/messages.dart';
import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';
import 'package:opal_app/features/Admin/Domain/usecase/add_down_town_usecase.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/add_down_town/add_down_town_state.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../user/presentaion/bloc/get_all_downtowns/get_all_down_town_cubit.dart';

class AddDownTownCubit extends Cubit<AddDownTownState> {
  AddDownTownCubit(this.addDownTownUsecase) : super(AddDownTownInitial());
  final AddDownTownUsecase addDownTownUsecase;
  Future<void> addDownTown(DownTownEntity downTown, dynamic context) async {
    emit(AddDownTownLoading());
    final result = await addDownTownUsecase.call(downTown);
    result.fold(
      (failure) {
        emit(AddDownTownFailure(_errorMessage(failure)));
      },
      (_) {
        emit(AddDownTownSuccess(ADDED_SUCCESS_MESSAGE));
        BlocProvider.of<GetAllDownTownCubit>(context).fetchAllDownTowns();
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
