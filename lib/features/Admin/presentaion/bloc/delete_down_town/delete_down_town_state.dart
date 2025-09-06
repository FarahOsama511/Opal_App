abstract class DeleteDownTownState {}

class DeleteDownTownInitial extends DeleteDownTownState {}

class DeleteDownTownLoading extends DeleteDownTownState {}

class DeleteDownTownSuccess extends DeleteDownTownState {
  final String message;
  DeleteDownTownSuccess(this.message);
}

class DeleteDownTownError extends DeleteDownTownState {
  final String message;
  DeleteDownTownError(this.message);
}
