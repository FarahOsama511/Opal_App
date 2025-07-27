import 'package:opal_app/features/Admin/Domain/entities/tour.dart';

abstract class GetAllLinesState {}

class LinesInitial extends GetAllLinesState {}

class LinesLoading extends GetAllLinesState {}

class LinesLoaded extends GetAllLinesState {
  final List<LineEntity> Liness;

  LinesLoaded(this.Liness);
}

class LinesError extends GetAllLinesState {
  final String message;

  LinesError(this.message);
}
