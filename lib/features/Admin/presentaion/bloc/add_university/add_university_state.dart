abstract class AddUniversityState {}

class AddUniversityInitial extends AddUniversityState {}

class AddUniversityLoading extends AddUniversityState {}

class AddUniversitySuccess extends AddUniversityState {
  final String message;

  AddUniversitySuccess(this.message);
}

class AddUniversityFailure extends AddUniversityState {
  final String error;

  AddUniversityFailure(this.error);
}
