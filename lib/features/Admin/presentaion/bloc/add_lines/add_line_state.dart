abstract class AddLineState {}

class AddLineInitial extends AddLineState {}

class AddLineLoading extends AddLineState {}

class AddLineSuccess extends AddLineState {}

class AddLineError extends AddLineState {
  final String message;
  AddLineError(this.message);
}
