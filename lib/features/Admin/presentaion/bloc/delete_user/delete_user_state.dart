abstract class DeleteUserState {}

class DeleteUserInitial extends DeleteUserState {}

class DeleteUserLoading extends DeleteUserState {}

class DeleteUserLoaded extends DeleteUserState {
  final String deleteUser;
  final String userId;

  DeleteUserLoaded(this.deleteUser, this.userId);
}

class DeleteUserError extends DeleteUserState {
  final String message;

  DeleteUserError(this.message);
}
