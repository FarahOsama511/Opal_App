import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Domain/usecase/update_admin_supervisor.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import 'update_admin_supervisor_state.dart';

class UpdateAdminOrSupervisorCubit extends Cubit<UpdateAdminOrSupervisorState> {
  UpdateAdminOrSupervisorCubit(this.updateAdminOrSupervisorUseCase)
    : super(UpdateAdminOrSupervisorInitial());
  final UpdateAdminSupervisorUseCase updateAdminOrSupervisorUseCase;
  Future<void> updateAdminOrSupervisor(UserEntity AdminOrSupervisor) async {
    emit(UpdateAdminOrSupervisorLoading());
    final result = await updateAdminOrSupervisorUseCase(AdminOrSupervisor);
    result.fold(
      (failure) {
        emit(UpdateAdminOrSupervisorError(_errorMessage(failure)));
      },
      (_) {
        emit(UpdateAdminOrSupervisorSuccess());
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
