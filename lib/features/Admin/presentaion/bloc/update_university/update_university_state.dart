abstract class UpdateUniversityState {}

class UpdateUniversityInitial extends UpdateUniversityState {}

class UpdateUniversityLoading extends UpdateUniversityState {}

class UpdateUniversitySuccess extends UpdateUniversityState {}

class UpdateUniversityError extends UpdateUniversityState {
  String message;
  UpdateUniversityError(this.message);
}
