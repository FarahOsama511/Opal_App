import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/Domain/usecase/add_admin_supervisor.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/create_admin_supervisors/add_admin_supervisor_state.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';

class AddAdminSupervisorCubit extends Cubit<AddAdminSupervisorState> {
  final AddAdminSupervisorUseCase addAdminSupervisorUseCase;
  AddAdminSupervisorCubit(this.addAdminSupervisorUseCase)
    : super(AddAdminSupervisorInitial());
  Future<void> AddAdminORSupervisor(UserEntity user) async {
    emit(AddAdminSupervisorLoading());
    final result = await addAdminSupervisorUseCase(user);
    result.fold(
      (failure) {
        emit(AddAdminSupervisorError(_errorMessage(failure)));
      },
      (_) {
        emit(AddAdminSupervisorSuccess(ADDED_SUCCESS_MESSAGE));
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
