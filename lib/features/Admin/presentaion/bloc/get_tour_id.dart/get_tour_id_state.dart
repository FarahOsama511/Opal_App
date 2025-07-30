import 'package:opal_app/features/Admin/Domain/entities/tour.dart';

abstract class GetTourIdState {}

class GetTourByIdInitial extends GetTourIdState {}

class GetTourByIdLoading extends GetTourIdState {}

class TourByIdLoaded extends GetTourIdState {
  final Tour tour;
  TourByIdLoaded(this.tour);
}

class getTourByIdError extends GetTourIdState {
  final String message;

  getTourByIdError(this.message);
}
