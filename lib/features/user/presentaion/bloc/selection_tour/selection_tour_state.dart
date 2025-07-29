import '../../../../Admin/Domain/entities/tour.dart';

abstract class SelectionTourState {}

class SelectionTourInitial extends SelectionTourState {}

class SelectionTourLoading extends SelectionTourState {}

class SelectionTourSuccess extends SelectionTourState {
  final Tour tour;
  SelectionTourSuccess(this.tour);
}

class UnConfirmTourSuccess extends SelectionTourState {}

class SelectionTourError extends SelectionTourState {
  final String message;
  SelectionTourError(this.message);
}
