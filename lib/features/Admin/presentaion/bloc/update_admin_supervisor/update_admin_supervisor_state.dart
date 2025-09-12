abstract class UpdateAdminOrSupervisorState {}

class UpdateAdminOrSupervisorInitial extends UpdateAdminOrSupervisorState {}

class UpdateAdminOrSupervisorLoading extends UpdateAdminOrSupervisorState {}

class UpdateAdminOrSupervisorSuccess extends UpdateAdminOrSupervisorState {}

class UpdateAdminOrSupervisorError extends UpdateAdminOrSupervisorState {
  String message;
  UpdateAdminOrSupervisorError(this.message);
}
