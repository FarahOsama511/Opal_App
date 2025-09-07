abstract class DeleteDownTownState {}

class DeleteDownTownInitial extends DeleteDownTownState {}

class DeleteDownTownLoading extends DeleteDownTownState {}

class DeleteDownTownSuccess extends DeleteDownTownState {
  final String message;
  final String id;
  DeleteDownTownSuccess(this.message, this.id);
}

class DeleteDownTownError extends DeleteDownTownState {
  final String message;
  DeleteDownTownError(this.message);
}
