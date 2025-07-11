import 'package:opal_app/features/Tours/Data/models/tour_model.dart';
import 'package:opal_app/features/Tours/Domain/entities/tour.dart';

abstract class TourState {}

class TourInitial extends TourState {}

class TourLoading extends TourState {}

class TourLoaded extends TourState {
  final List<Tour> tours;

  TourLoaded(this.tours);
}

class TourError extends TourState {
  final String message;

  TourError(this.message);
}
