abstract class DeleteUniversityState {}

class DeleteUniversityInitial extends DeleteUniversityState {}

class DeleteUniversityLoading extends DeleteUniversityState {}

class DeleteUniversitySuccess extends DeleteUniversityState {
  final String message;
  final String id;
  DeleteUniversitySuccess(this.message, this.id);
}

class DeleteUniversityError extends DeleteUniversityState {
  final String message;
  DeleteUniversityError(this.message);
}
