abstract class UpdateAddDeleteTourState {}

class TourLoading extends UpdateAddDeleteTourState {}

class TourError extends UpdateAddDeleteTourState {
  final String message;

  TourError(this.message);
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
