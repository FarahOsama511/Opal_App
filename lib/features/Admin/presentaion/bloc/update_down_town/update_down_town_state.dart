abstract class UpdateDownTownState {}

class UpdateDownTownInitial extends UpdateDownTownState {}

class UpdateDownTownLoading extends UpdateDownTownState {}

class UpdateDownTownSuccess extends UpdateDownTownState {}

class UpdateDownTownError extends UpdateDownTownState {
  String message;
  UpdateDownTownError(this.message);
}
