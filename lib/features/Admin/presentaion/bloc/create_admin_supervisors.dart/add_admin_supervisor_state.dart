abstract class AddAdminSupervisorState {}

class AddAdminSupervisorInitial extends AddAdminSupervisorState {}

class AddAdminSupervisorLoading extends AddAdminSupervisorState {}

class AddAdminSupervisorSuccess extends AddAdminSupervisorState {
  final String message;

  AddAdminSupervisorSuccess(this.message);
}

class AddAdminSupervisorError extends AddAdminSupervisorState {
  final String message;

  AddAdminSupervisorError(this.message);
}
