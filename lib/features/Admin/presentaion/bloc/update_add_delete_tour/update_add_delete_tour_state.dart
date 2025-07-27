abstract class UpdateAddDeleteTourState {}

class UpdateAddDeleteTourInitial extends UpdateAddDeleteTourState {}

class UpdateAddDeleteTourLoading extends UpdateAddDeleteTourState {}

class UpdateAddDeleteTourError extends UpdateAddDeleteTourState {
  final String message;

  UpdateAddDeleteTourError(this.message);
}

class TourAdded extends UpdateAddDeleteTourState {
  final String message;

  TourAdded(this.message);
}

class TourDeleted extends UpdateAddDeleteTourState {
  final String message;

  TourDeleted(this.message);
}

class TourUpdated extends UpdateAddDeleteTourState {
  final String message;

  TourUpdated(this.message);
}
