abstract class DeleteUniversityState {}

class DeleteUniversityInitial extends DeleteUniversityState {}

class DeleteUniversityLoading extends DeleteUniversityState {}

class DeleteUniversitySuccess extends DeleteUniversityState {
  final String message;
  DeleteUniversitySuccess(this.message);
}

class DeleteUniversityError extends DeleteUniversityState {
  final String message;
  DeleteUniversityError(this.message);
}
