abstract class AddDownTownState {}

class AddDownTownInitial extends AddDownTownState {}

class AddDownTownLoading extends AddDownTownState {}

class AddDownTownSuccess extends AddDownTownState {
  final String successMessage;
  AddDownTownSuccess(this.successMessage);
}

class AddDownTownFailure extends AddDownTownState {
  final String errorMessage;
  AddDownTownFailure(this.errorMessage);
}
