abstract class UpdateLineState {}

class UpdateLineInitial extends UpdateLineState {}

class UpdateLineLoading extends UpdateLineState {}

class UpdateLineSuccess extends UpdateLineState {}

class UpdateLineError extends UpdateLineState {
  String message;
  UpdateLineError(this.message);
}
