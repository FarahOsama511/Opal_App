abstract class DeleteLineState {}

class DeleteLineInitial extends DeleteLineState {}

class DeleteLineLoading extends DeleteLineState {}

class DeleteLineLoaded extends DeleteLineState {
  final String deleteLine;
  final String id;
  DeleteLineLoaded(this.deleteLine, this.id);
}

class DeleteLineError extends DeleteLineState {
  final String message;

  DeleteLineError(this.message);
}
